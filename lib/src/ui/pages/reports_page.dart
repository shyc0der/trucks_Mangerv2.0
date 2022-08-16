import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/pages/reports_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/item_card_widget.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text("Reports", style: Theme.of(context).textTheme.headline5,),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Wrap(
            children: [
              // jobs
              ItemCardWidget(
                label: 'Jobs',
                iconData: Icons.work_outline,
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ReportsDetailsPage(
                    title: 'Jobs',
                    items: [
                      ReportItemModel(label: 'All', amount: 1000000, expense: 200000),
                      ReportItemModel(label: 'Logisticts', amount: 400000, expense: 40000),
                      ReportItemModel(label: 'Transport', amount: 600000, expense: 180000),
                    ],
                  )));
                },
              ),

              // expenses
              ItemCardWidget(
                label: 'Expenses',
                iconData: Icons.account_balance_wallet_outlined,
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ReportsDetailsPage(
                    title: 'Expenses',
                    items: [
                      ReportItemModel(label: 'All', amount: 0, expense: 200000),
                      ReportItemModel(label: 'Fuel', amount: 0, expense: 40000),
                      ReportItemModel(label: 'Repair', amount: 0, expense: 180000),
                      ReportItemModel(label: 'Airtime', amount: 0, expense: 30000),
                    ],
                  )));
                },
              ),

              // trucks
              ItemCardWidget(
                label: 'Trucks',
                iconData: Icons.local_shipping_outlined,
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ReportsDetailsPage(
                    title: 'Trucks',
                    items: [
                      ReportItemModel(label: 'KBZ 001A', amount: 800000, expense: 200000),
                      ReportItemModel(label: 'KBZ 001B', amount: 900000, expense: 230000),
                      ReportItemModel(label: 'KBZ 001C', amount: 600000, expense: 210000),
                      ReportItemModel(label: 'KBZ 001D', amount: 500000, expense: 180000),
                      ReportItemModel(label: 'KBZ 001E', amount: 700000, expense: 220000),
                    ],
                  )));
                },
              ),


              // users
              ItemCardWidget(
                label: 'Users',
                iconData: Icons.people_alt_outlined,
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ReportsDetailsPage(
                    title: 'Users',
                    items: [
                      ReportItemModel(label: 'User A', amount: 200000, expense: 60000),
                      ReportItemModel(label: 'User B', amount: 200000, expense: 60000),
                      ReportItemModel(label: 'User C', amount: 300000, expense: 60000),
                      ReportItemModel(label: 'User D', amount: 400000, expense: 70000),
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