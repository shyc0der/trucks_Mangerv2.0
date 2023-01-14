import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/theme_data.dart';

import '../../../models/order_model.dart';

class OrderReportPage extends StatefulWidget {
  const OrderReportPage({super.key});

  @override
  State<OrderReportPage> createState() => _OrderReportPageState();
}

class _OrderReportPageState extends State<OrderReportPage> {
  DateTimeRange _dateTimeRange =
      DateTimeRange(start: DateTime(2022), end: DateTime.now());
  late final TextEditingController _dateController;
  //late final void Function(DateTimeRange dateTimeRange)? onDateRangeChanged;
  NumberFormat doubleFormat = NumberFormat.decimalPattern('en_us');

  @override
  void initState() {
    super.initState();

    _dateController = TextEditingController(
        text:
            '${_dateTimeRange.start.toString().substring(0, 10)} - ${_dateTimeRange.end.toString().substring(0, 10)}');
  }

  @override
  Widget build(BuildContext context) {
    final OrderModules _orderModules = Get.put(OrderModules());
    List<Map<String, dynamic>> amountsPerOrderType = [];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order Report'),
      ),
      body: StreamBuilder<List<OrderModel>>(
          stream: _orderModules.fetchAllWhereOrders(_dateTimeRange),
          builder: (context, snapshot) {
            var data = snapshot.data ?? [];
            var totalAmount = data.fold<double>(
                0.0,
                (amount, order) =>
                    amount + (order.amount ?? 0.0));
            var newMap = groupBy(
                data, (OrderModel orderModel) => orderModel.title);
            amountsPerOrderType.clear();
            newMap.forEach((key, value) {
              var tes = value.fold<double>(
                  0.0,
                  (previousValue, element) =>
                      previousValue +
                      (element.amount ?? 0.0));
                      
              amountsPerOrderType.add({
                'item': {'title': key, 'amount':  tes}
              });
            });
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Date range:'),
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        textAlign: TextAlign.right,
                        readOnly: false,
                        onTap: () async {
                          var dtr = await showDateRangePicker(
                              context: context,
                              initialDateRange: _dateTimeRange,
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2069));

                          if (dtr != null) {
                            setState(() {
                               _dateTimeRange = dtr;
                            _dateController.text =
                                '${_dateTimeRange.start.toString().substring(0, 10)} - ${_dateTimeRange.end.toString().substring(0, 10)}';
                      
                            });
                                // onDateRangeChanged?.call(_dateTimeRange);
                          }
                          
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: SfCircularChart(
                    backgroundColor: themeData.backgroundColor,
                    borderColor: themeData.primaryColor,
                    palette: palettes,
                    legend: Legend(
                        isVisible: true,
                        textStyle: const TextStyle(fontSize: 18)),
                    title: ChartTitle(
                        text: 'Total Amount : KES ${doubleFormat.format(totalAmount)}',
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    series: <CircularSeries>[
                      DoughnutSeries<Map<String, dynamic>, String>(
                        dataSource: amountsPerOrderType,
                        xValueMapper: (Map<String, dynamic> maps, _) =>
                            maps['item']['title'],
                        yValueMapper: (Map<String, dynamic> maps, _) =>
                            maps['item']['amount'],
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text('OrderS TABLE'),
                ),
                Expanded(
                  child: Center(
                    child: ListView.builder(
                        //shrinkWrap: true,
                        itemCount: amountsPerOrderType.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 50, right: 50),
                            child: SingleChildScrollView(
                              child: Table(
                                border: TableBorder.all(),
                                children: [
                                  TableRow(
                                      decoration: BoxDecoration(
                                          color: themeData.backgroundColor),
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                                amountsPerOrderType[index]
                                                    ['item']['title']),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                                'KES ${doubleFormat.format(amountsPerOrderType[index]['item']['amount'])}'),
                                          ),
                                        ),
                                      ])
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                )
              ],
            );
          }),
    );
  }
}
