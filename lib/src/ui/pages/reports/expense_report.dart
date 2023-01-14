import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trucks_manager/src/models/expenses_model.dart';
import 'package:trucks_manager/src/modules/expenses_modules.dart';
import 'package:trucks_manager/theme_data.dart';

class ExpenseReportPage extends StatefulWidget {
  const ExpenseReportPage({super.key});

  @override
  State<ExpenseReportPage> createState() => _ExpenseReportPageState();
}

class _ExpenseReportPageState extends State<ExpenseReportPage> {
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
    final ExpenseModule _expenseModule = Get.put(ExpenseModule());
    List<Map<String, dynamic>> amountsPerExpenseType = [];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Expense Report'),
      ),
      body: StreamBuilder<List<ExpenseModel>>(
          stream: _expenseModule.fetchAllWhereDateRangeExpenses(_dateTimeRange),
          builder: (context, snapshot) {
            var data = snapshot.data ?? [];
            var totalAmount = data.fold<double>(
                0.0,
                (amount, expense) =>
                    amount + (double.tryParse(expense.totalAmount!) ?? 0.0));
            amountsPerExpenseType.clear();
            var newMap = groupBy(
                data, (ExpenseModel expenseModel) => expenseModel.expenseType);
            newMap.forEach((key, value) {
              var tes = value.fold<double>(
                  0.0,
                  (previousValue, expense) =>
                      previousValue +
                      (double.tryParse(expense.totalAmount!) ?? 0.0));
              amountsPerExpenseType.add({
                'item': {'title': key, 'amount': tes}
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
                        text:
                            'Total Amount : KES ${doubleFormat.format(totalAmount)}',
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    series: <CircularSeries>[
                      PieSeries<Map<String, dynamic>, String>(
                        dataSource: amountsPerExpenseType,
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
                  child: Text('EXPENSES TABLE'),
                ),
                Expanded(
                  child: Center(
                    child: ListView.builder(
                        //shrinkWrap: true,
                        itemCount: amountsPerExpenseType.length,
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
                                                amountsPerExpenseType[index]
                                                    ['item']['title']),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                                'KES ${doubleFormat.format(amountsPerExpenseType[index]['item']['amount'])}'),
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
