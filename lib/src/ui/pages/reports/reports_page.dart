import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trucks_manager/src/models/expenses_model.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
import 'package:trucks_manager/src/modules/expenses_modules.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/ui/pages/reports/reports_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/item_card_widget.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({Key? key}) : super(key: key);

  final OrderModules _orderModule = Get.put(OrderModules());
  final ExpenseModule _expenseModule = Get.put(ExpenseModule());
  final TruckModules _truckModules = Get.put(TruckModules());

  NumberFormat doubleFormat = NumberFormat.decimalPattern('en_us');
  double jobAmount = 0;
  Map<String?, dynamic> amountsPerOrderTitle = {};
  Map<String?, dynamic> amountsPerExpenseType = {};
  Map<String?, dynamic> amountsPerTrucksType = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Reports",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Wrap(
            children: [
              // jobs
              ItemCardWidget(
                label: 'Jobs',
                iconData: Icons.work_outline,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => StreamBuilder<List<OrderModel>>(
                          stream: _orderModule.fetchAllOrders(),
                          builder: (context, snapshot) {
                            var data = snapshot.data ?? [];
                            // print(data.asMap());
                            var totalAmount = data.fold<double>(
                                0.0,
                                (amount, order) =>
                                    amount + (order.amount ?? 0.0));

                            amountsPerOrderTitle
                                .addAll({'All': totalAmount.ceilToDouble()});
                            var newMap = groupBy(data,
                                (OrderModel orderModel) => orderModel.title);
                            //print('yyyyyyyyyyyyyyyyyyyyy');
                            //print(newMap);j
                            Map<String?, dynamic> groupedAndSum = Map();
                            newMap.forEach((key, value) {
                              var tes = value.fold<double>(
                                  0.0,
                                  (previousValue, element) =>
                                      previousValue + (element.amount ?? 0.0));

                              amountsPerOrderTitle.addAll({key: tes});

                              //print(tes);
                              //print(key);
                              groupedAndSum[key] = {
                                value.fold<double>(
                                    0.0,
                                    (previousValue, element) =>
                                        previousValue + (element.amount ?? 0.0))
                              };
                            });
                            //amountsPerOrderTitle = groupedAndSum;
                            print(amountsPerOrderTitle);
                            //  print(amountsPerOrderTitle.entries.toList());

                            //print(groupedAndSum);
                            //var groupedData=
                            var fileredData = data.where(
                                (element) => element.title == 'Transport');

                            var finalData = fileredData.fold<double>(
                                0.0,
                                (amount, order) =>
                                    amount + (order.amount ?? 0.0));
                            //print(finalData);
                            //amountsPerOrderTitle
                            //  .addAll({'Transport': finalData});
                            //print(amountsPerOrderTitle);

                            // future: _expenseModule.fetchByExenpseByOrder(data[].id),

                            return ReportsDetailsPage(
                              title: 'Jobs',
                              items: [
                                for (int i = 0;
                                    i < amountsPerOrderTitle.length;
                                    i++)
                                  ReportItemModel(
                                      label: amountsPerOrderTitle.keys
                                          .toList()[i]!,
                                      amount: amountsPerOrderTitle.values
                                          .toList()[i],
                                      expense: 200000),
                                // ReportItemModel(
                                //     label: 'Logisticts',
                                //     amount: 400000,
                                //     expense: 40000),
                                // ReportItemModel(
                                //     label: 'Transport',
                                //     amount: 600000,
                                //     expense: 180000),
                              ],
                            );
                          })));
                },
              ),

              // expenses
              StreamBuilder<List<ExpenseModel>>(
                  stream: _expenseModule.fetchExpenses(),
                  builder: (context, snapshot) {
                    return ItemCardWidget(
                      label: 'Expenses',
                      iconData: Icons.account_balance_wallet_outlined,
                      onTap: () {
                        var data = snapshot.data ?? [];
                        var totalAmount = data.fold<double>(
                            0.0,
                            (amount, expense) =>
                                amount +
                                (double.tryParse(expense.totalAmount!) ?? 0.0));
                        amountsPerExpenseType
                            .addAll({'All': totalAmount.ceilToDouble()});
                        var newMap = groupBy(
                            data,
                            (ExpenseModel expenseModel) =>
                                expenseModel.expenseType);
                        newMap.forEach((key, value) {
                          var tes = value.fold<double>(
                              0.0,
                              (previousValue, expense) =>
                                  previousValue +
                                  (double.tryParse(expense.totalAmount!) ??
                                      0.0));
                          amountsPerExpenseType.addAll({key: tes});
                        });
                        //print(amountsPerExpenseType);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ReportsDetailsPage(
                                  title: 'Expenses',
                                  items: [
                                    for (int i = 0;
                                        i < amountsPerExpenseType.length;
                                        i++)
                                      ReportItemModel(
                                          label: amountsPerExpenseType.keys
                                              .toList()[i]!,
                                          expense: amountsPerExpenseType.values
                                              .toList()[i]!,
                                          amount: 2000),
                                  ],
                                )));
                      },
                    );
                  }),

              // trucks
              StreamBuilder<List<TrucksModel>>(
                  stream: _truckModules.fetchTrucks(),
                  //expenses per truck
                  builder: (context, snapshot) {
                    var data = snapshot.data!;
                    return ItemCardWidget(
                      label: 'Trucks',
                      iconData: Icons.local_shipping_outlined,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ReportsDetailsPage(
                                  title: 'Trucks',
                                  items: [
                                    for(int i=0; i < data.length; i++)
                                    ReportItemModel(
                                        label: data[i].vehicleRegNo!,
                                        amount: 800000,
                                        expense: 0,
                                        //data[i].getTotalExpense(DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), 
                                      //end: DateTime.now()
                                      
                                      //) )
                                        ),
                                   
                                  ],
                                )));
                      },
                    );
                  }),

              // users
              ItemCardWidget(
                label: 'Drivers',
                iconData: Icons.people_alt_outlined,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ReportsDetailsPage(
                            title: 'Drivers',
                            items: [
                             
                            ],
                          )));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
