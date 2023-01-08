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
import 'package:trucks_manager/src/ui/pages/reports/order_report.dart';
import 'package:trucks_manager/src/ui/pages/reports/reports_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/item_card_widget.dart';

import 'expense_report.dart';

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
                label: 'Orders',
                iconData: Icons.work_outline,
                onTap: () {
           Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const OrderReportPage()));
                                   
                
               
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
                      Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const ExpenseReportPage()));
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
                                        amounter: data[i].getTotalExpense(DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), 
                                      end: DateTime.now())),
                                        expense: 0,),
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
                      builder: (_) => const  ReportsDetailsPage(
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
