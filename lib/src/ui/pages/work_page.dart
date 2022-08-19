import 'package:flutter/material.dart';
import 'package:trucks_manager/src/modules/workPage_modules.dart';
import 'package:trucks_manager/src/ui/pages/customers_page.dart';
import 'package:trucks_manager/src/ui/pages/expenses_page.dart';
import 'package:trucks_manager/src/ui/pages/orders_page.dart';
import 'package:trucks_manager/src/ui/pages/trucks_list_page.dart';
import 'package:trucks_manager/src/ui/widgets/item_card_widget.dart';

import '../../models/work_model.dart';

class WorkPage extends StatelessWidget {
  WorkPage({Key? key}) : super(key: key);

  final WorkPageModule _workPageModule = WorkPageModule();
  

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: FutureBuilder<WorkModel>(
        future: _workPageModule.getCounts(),
        builder: (context, snapshot) {
          var count=snapshot.data ?? [];
          
          return Wrap(
            children: [
              // orders
              ItemCardWidget(
                label: 'Orders',
                iconData: Icons.shopping_cart_checkout_outlined,
                count: snapshot.data!.jobsCount,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const OrdersPage()));
                },
              ),
      
              // jobs
              ItemCardWidget(
                label: 'Jobs',
                iconData: Icons.work_outline,
                count: 2,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const OrdersPage()));
                },
              ),
      
              // expenses
              ItemCardWidget(
                label: 'Expenses',
                iconData: Icons.account_balance_wallet_outlined,
                count: 10,
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ExpensesPage()));
                },
              ),
      
              // trucks
              ItemCardWidget(
                label: 'Trucks',
                iconData: Icons.local_shipping_outlined,
                count: 8,
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return TrucksListPage();
                      });
                },
              ),
      
              // customers
              ItemCardWidget(
                label: 'Customers',
                iconData: Icons.people_alt_outlined,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const CustomersPage()));
                },
              ),
      
              // // reports
              // const ItemCardWidget(
              //   label: 'Reports',
              //   iconData: Icons.pie_chart_outline_outlined,
              // ),
            ],
          );
        }
      ),
    );
  }
}
