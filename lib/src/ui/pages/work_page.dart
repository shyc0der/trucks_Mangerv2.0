// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/expenses_model.dart';
import 'package:trucks_manager/src/models/jobs_model.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
import 'package:trucks_manager/src/models/user_model.dart';
import 'package:trucks_manager/src/modules/expenses_modules.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/pages/users/customers_page.dart';
import 'package:trucks_manager/src/ui/pages/expenses/expenses_page.dart';
import 'package:trucks_manager/src/ui/pages/orders/orders_page.dart';
import 'package:trucks_manager/src/ui/pages/trucks/trucks_list_page.dart';
import 'package:trucks_manager/src/ui/widgets/item_card_widget.dart';

import 'jobs/jobs_page.dart';

class WorkPage extends StatelessWidget {
  WorkPage({Key? key}) : super(key: key);

  final OrderModules _orderModules = Get.find<OrderModules>();
  final JobModule _jobModule = Get.find<JobModule>();
  final ExpenseModule _expenseModule = Get.put(ExpenseModule());
  final TruckModules _truckModules = Get.put(TruckModules());
  final UserModule _userModule = Get.find<UserModule>();

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          children: [
            // orders
            StreamBuilder<List<OrderModel>>(
                stream:
                    _orderModules.fetchOrders(_userModule.currentUser.value),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return ItemCardWidget(
                      label: 'Orders',
                      iconData: Icons.shopping_cart_checkout_outlined,
                      count: snapshot.data!.length,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const OrdersPage()));
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),

            // jobs
            StreamBuilder<List<JobModel>>(
                stream: _jobModule.fetchJobs(_userModule.currentUser.value),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return ItemCardWidget(
                      label: 'Jobs',
                      iconData: Icons.work_outline,
                      count:  snapshot.data!.length,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const JobsPage()));
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),

            // expenses
            StreamBuilder<List<ExpenseModel>>(
                stream: _expenseModule
                    .fetchAllExpenses(_userModule.currentUser.value),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return ItemCardWidget(
                      label: 'Expenses',
                      iconData: Icons.account_balance_wallet_outlined,
                      count: snapshot.data!.length,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const ExpensesPage()));
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),

            // trucks
            StreamBuilder<List<TrucksModel>>(
                stream: _truckModules.fetchTrucks(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                  return ItemCardWidget(
                    label: 'Trucks',
                    iconData: Icons.local_shipping_outlined,
                    count:  snapshot.data!.length,
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return TrucksListPage();
                          });
                    },
                  );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),

            // customers
            StreamBuilder<List<UserModel>>(
                stream: _userModule.fetchUsersWhere(true),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                  return ItemCardWidget(
                    label: 'Customers',
                    count: snapshot.data!.length,
                    iconData: Icons.people_alt_outlined,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const CustomersPage()));
                    },
                  );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),

            // // reports
            // const ItemCardWidget(
            //   label: 'Reports',
            //   iconData: Icons.pie_chart_outline_outlined,
            // ),
          ],
        ));
  }
}
