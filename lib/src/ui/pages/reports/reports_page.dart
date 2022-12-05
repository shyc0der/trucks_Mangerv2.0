import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/ui/pages/reports/reports_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/item_card_widget.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({Key? key}) : super(key: key);

  final OrderModules _orderModule = Get.put(OrderModules());
  double jobAmount = 0;
  Map<String?, dynamic> amountsPerOrderTitle = {};

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

                            amountsPerOrderTitle.addAll({'All': totalAmount});
                            var newMap = groupBy(data,
                                (OrderModel orderModel) => orderModel.title);
                            print('yyyyyyyyyyyyyyyyyyyyy');
                            //print(newMap);
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
                            print(amountsPerOrderTitle.keys);
                            //  print(amountsPerOrderTitle.entries.toList());

                            //print(groupedAndSum);
                            //var groupedData=
                            var fileredData = data.where(
                                (element) => element.title == 'Transport');

                            var finalData = fileredData.fold<double>(
                                0.0,
                                (amount, order) =>
                                    amount + (order.amount ?? 0.0));
                            print(finalData);
                            //amountsPerOrderTitle
                            //  .addAll({'Transport': finalData});
                            //print(amountsPerOrderTitle);

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
              ItemCardWidget(
                label: 'Expenses',
                iconData: Icons.account_balance_wallet_outlined,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ReportsDetailsPage(
                            title: 'Expenses',
                            items: [
                              ReportItemModel(
                                  label: 'All', amount: 0, expense: 200000),
                              ReportItemModel(
                                  label: 'Fuel', amount: 0, expense: 40000),
                              ReportItemModel(
                                  label: 'Repair', amount: 0, expense: 180000),
                              ReportItemModel(
                                  label: 'Airtime', amount: 0, expense: 30000),
                            ],
                          )));
                },
              ),

              // trucks
              ItemCardWidget(
                label: 'Trucks',
                iconData: Icons.local_shipping_outlined,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ReportsDetailsPage(
                            title: 'Trucks',
                            items: [
                              ReportItemModel(
                                  label: 'KBZ 001A',
                                  amount: 800000,
                                  expense: 200000),
                              ReportItemModel(
                                  label: 'KBZ 001B',
                                  amount: 900000,
                                  expense: 230000),
                              ReportItemModel(
                                  label: 'KBZ 001C',
                                  amount: 600000,
                                  expense: 210000),
                              ReportItemModel(
                                  label: 'KBZ 001D',
                                  amount: 500000,
                                  expense: 180000),
                              ReportItemModel(
                                  label: 'KBZ 001E',
                                  amount: 700000,
                                  expense: 220000),
                            ],
                          )));
                },
              ),

              // users
              ItemCardWidget(
                label: 'Users',
                iconData: Icons.people_alt_outlined,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ReportsDetailsPage(
                            title: 'Users',
                            items: [
                              ReportItemModel(
                                  label: 'User A',
                                  amount: 200000,
                                  expense: 60000),
                              ReportItemModel(
                                  label: 'User B',
                                  amount: 200000,
                                  expense: 60000),
                              ReportItemModel(
                                  label: 'User C',
                                  amount: 300000,
                                  expense: 60000),
                              ReportItemModel(
                                  label: 'User D',
                                  amount: 400000,
                                  expense: 70000),
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
