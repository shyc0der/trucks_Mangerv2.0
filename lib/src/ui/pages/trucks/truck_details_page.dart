// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/jobs_model.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
import 'package:trucks_manager/src/modules/expenses_modules.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/ui/pages/jobs/jobs_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/expenses_list_tile_widget.dart';
import 'package:trucks_manager/src/ui/widgets/job_list_tile_widget.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';
import 'package:trucks_manager/src/ui/widgets/truck_widget.dart';

import '../../../models/expenses_model.dart';
import '../../../models/order_model.dart';
import '../expenses/add_expense_widget.dart';
import '../expenses/expense_details_page.dart';

class TruckDetailsPage extends StatefulWidget {
  const TruckDetailsPage(this.trucksModel, {Key? key}) : super(key: key);
  final TrucksModel? trucksModel;

  @override
  State<TruckDetailsPage> createState() => _TruckDetailsPageState();
}

class _TruckDetailsPageState extends State<TruckDetailsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final OrderModules _orderModules = OrderModules();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  Future<double> getTotalJobAmount(String truckId) async {
    double amounts = 0;
    print('pisss');
    var trucks = await _orderModules.fetchOrderByTruckId(truckId);
    for (var truck in trucks) {
      amounts += truck.amount ?? 0;
    }

    return amounts;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Truck Details'),
      ),
      body: Column(
        children: [
          // truck info
          FutureBuilder<double>(
              future: getTotalJobAmount(widget.trucksModel!.id!),
              builder: (context, snapshot) {
                print(snapshot.data);
                return TruckWidget(
                    registration: widget.trucksModel!.vehicleRegNo ?? '',
                    //TO:DO CALCULATE AMOUNTS PER VEHICLE
                    jobsAmount: snapshot.data ?? 0,
                    expensesAmount: 'Ksh. 50,000',
                    addExpense: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: AddExpenseWidget(
                                truckId: widget.trucksModel!.id ?? "null",
                              ),
                            );
                          });
                    });
              }),
          BottomNavigationBar(
            currentIndex: _tabController.index,
            onTap: (int val) {
              setState(() {
                _tabController.index = val;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: 'Expenses'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_shipping_outlined), label: 'Jobs'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ListOfExpenses(widget.trucksModel?.id),
                _ListOfJobs(widget.trucksModel?.id),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ListOfJobs extends StatelessWidget {
  _ListOfJobs(this.jobId, {Key? key}) : super(key: key);
  String? jobId;
  
  final OrderModules _orderModules =Get.find<OrderModules>();

  double? fetchAmount(String? orderId) {
    var res = _orderModules.getOrderByJobId(orderId!);

    return res?.amount ;
  }
  
  String? fetchOrder(String? orderId) {
    var res = _orderModules.getOrderByJobId(orderId!);
    
    return res?.title;
  }

  final JobModule _jobModule = JobModule();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<JobModel>>(
        future: _jobModule.fetchJobsByTruck(jobId!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: (snapshot.data ?? []).length,
              itemBuilder: (_, index) {
                return JobListTile(
                  title: fetchOrder(snapshot.data![index].orderId) ?? '',
                  dateTime: snapshot.data![index].dateCreated,
                  amount: fetchAmount(snapshot.data![index].orderId) ?? 0,
                  jobState: snapshot.data![index].jobStates,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => JobDetailPage(snapshot.data![index])));
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class _ListOfExpenses extends StatelessWidget {
  _ListOfExpenses(this.truckId, {Key? key}) : super(key: key);
  String? truckId;
  final ExpenseModule _expenseModule = ExpenseModule();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ExpenseModel>>(
        stream: _expenseModule.fetchByTruckExpenses(truckId!),
        builder: (context, snapshot) {
          List<ExpenseModel> _expenses = snapshot.data ?? [];
          return ListView.builder(
            itemCount: _expenses.length,
            itemBuilder: (_, index) {
              return ExpensesListTile(
                title: _expenses[index].expenseType ?? '',
                driverName: _expenses[index].userId ?? '',
                dateTime: _expenses[index].date,
                amount:
                    double.tryParse(_expenses[index].totalAmount ?? '0') ?? 0,
                expenseState: _expenses[index].expensesState,
                 onTap:() {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ExpenseDetailsPage(_expenses[index])));
            },
              );
            },
          );
        });
  }
}
