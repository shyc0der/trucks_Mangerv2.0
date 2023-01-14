import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/login_page.dart';
import 'package:trucks_manager/src/ui/pages/reports/reports_page.dart';

import 'package:trucks_manager/src/ui/pages/work_page.dart';
import 'package:trucks_manager/src/ui/reports/expenses_per_vehicle.dart';
import 'package:trucks_manager/src/ui/reports/expenses_reports.dart';
import 'package:trucks_manager/src/ui/reports/jobs_per_vehicle_report.dart';
import 'package:trucks_manager/src/ui/reports/orders_reports.dart';

import '../../modules/firebase_user_module.dart';
import '../../reports/filters_widgets/all_expenses_filter.dart';
import '../../reports/filters_widgets/all_jobs_filter.dart';
import '../../reports/filters_widgets/expense_per_v_filter.dart';
import '../../reports/filters_widgets/jobs_per_v_filter.dart';
import '../../reports/filters_widgets/orders_filter.dart';
import '../reports/jobs_reports.dart';
import 'others_page.dart';
import 'reports/reports_drawer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final UserModule _userModule = Get.put(UserModule());
  final OrderModules _orderModules = Get.put(OrderModules());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
    });
    _orderModules.init(_userModule.currentUser.value);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool isCollapsed = true;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 30,
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('Reports'),
              trailing: Icon(
                  isCollapsed ? Icons.arrow_drop_down : Icons.arrow_drop_up),
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                });
              },
            ),

            // items
            if (!isCollapsed)
              Container(
                padding: const EdgeInsets.only(left: 15),
                height: 330,
                child: ListView(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('Expenses per Vehicle'),
                      onTap: () {
                        Get.put(ExpensesPerVehicleReportController());
                        Get.to(const ReportsDrawerPage(
                          filterWidget: ExpensePerVehicleFilterWidget(),
                        ));
                      },
                    ),
                    ListTile(
                      title: const Text('All Expenses'),
                      onTap: () {
                        Get.put(ExpensesReportController());
                        Get.to(const ReportsDrawerPage(
                          filterWidget: AllExpensesFilterWidget(),
                        ));
                      },
                    ),
                    ListTile(
                      title: const Text('Jobs per Vehicle'),
                      onTap: () {
                        Get.put(JobsPerVehicleReportController());
                        Get.to(const ReportsDrawerPage(
                          filterWidget: JobsPerVehicleFilterWidget(),
                        ));
                      },
                    ),
                    ListTile(
                      title: const Text('All Jobs'),
                      onTap: () {
                        Get.put(AllJobsReportController());
                        Get.to(const ReportsDrawerPage(
                          filterWidget: AllJobsFilterWidget(),
                        ));
                      },
                    ),
                    ListTile(
                      title: const Text('Orders'),
                      onTap: () {
                        Get.put(OrderReportController());
                        Get.to(const ReportsDrawerPage(
                          filterWidget: AllOrdersFilterWidget(),
                        ));
                      },
                    ),
                  ],
                ),
              ),

            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text('Logout'),
                  tileColor: Colors.greenAccent.withOpacity(.4),
                  onTap: () async {
                    // logout
                   await FirebaseUserModule.logout();
                   await Future.delayed(const Duration(seconds: 1));
                 await  _userModule.setCurrentUser('');
                    // navigate to login
                    await Future.delayed(const Duration(seconds: 3));
                  
                    Get.offAll(const LoginPage());
                    // ignore: use_build_context_synchronously

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => const LoginPage())));
                  },
                ),
              ),
            ),
          
        const  SizedBox(height: 2,),
      
          ],
        ),
      ), //reports pages

      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(onPressed: (){}, 
          icon: const Icon(Icons.update_outlined)),
                  
   
        ],
        title: Text(_userModule.currentUser.value.role == 'driver'
            ? '${_userModule.currentUser.value.firstName} ${_userModule.currentUser.value.lastName}'
            : 'Truck Manager'),
      ),
      body: TabBarView(controller: _tabController, children: [
        // reports page
        const WorkPage(),
        // users page
        const OthersPage(),

        //if(_userModule.isSuperUser.value)
        ReportsPage(),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (int val) {
          setState(() {
            _tabController.index = val;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.work_history_outlined), label: 'Work'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1_outlined), label: 'Others'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline), label: 'Reports'),
        ],
      ),
    );
  }
}
