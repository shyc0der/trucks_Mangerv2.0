import 'package:flutter/material.dart';
import 'package:trucks_manager/src/models/jobs_model.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/ui/pages/expenses_page.dart';
import 'package:trucks_manager/src/ui/pages/jobs_details_page.dart';
import 'package:trucks_manager/src/ui/pages/orders_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/expenses_list_tile_widget.dart';
import 'package:trucks_manager/src/ui/widgets/job_list_tile_widget.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';
import 'package:trucks_manager/src/ui/widgets/truck_widget.dart';

import '../../models/order_model.dart';

class TruckDetailsPage extends StatefulWidget {
  const TruckDetailsPage(this.trucksModel, {Key? key}) : super(key: key);
  final TrucksModel? trucksModel;

  @override
  State<TruckDetailsPage> createState() => _TruckDetailsPageState();
}

class _TruckDetailsPageState extends State<TruckDetailsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
    });
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
          TruckWidget(
            registration: widget.trucksModel!.vehicleRegNo ?? '',
            //TO:DO CALCULATE AMOUNTS PER VEHICLE
            jobsAmount: 'Ksh. 120,000',
            expensesAmount: 'Ksh. 50,000',
          ),
          BottomNavigationBar(
            currentIndex: _tabController.index,
            onTap: (int val) {
              setState(() {
                _tabController.index = val;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_shipping_outlined), label: 'Jobs'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: 'Expenses')
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ListOfJobs(widget.trucksModel?.id),
                _ListOfExpenses()
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

  final List<OrderModel> _orders = List.generate(13, (index) {
    final List<OrderWidgateState> states = List.from(OrderWidgateState.values);
    states.shuffle();
    return OrderModel();
  });

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
              itemCount: (snapshot.data ?? []).length ,
              itemBuilder: (_, index) {
                return JobListTile(
                  title: snapshot.data![index].lpoNumber ?? '',
                  dateTime:snapshot.data![index].dateCreated,
                  amount: _orders[index].amount ?? 0,
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
  _ListOfExpenses({Key? key}) : super(key: key);

  final List<ExpensesModel> _expenses = List.generate(30, (index) {
    final List<OrderWidgateState> states = List.from(OrderWidgateState.values);
    final list = ['Fuel', 'Repair', 'Airtime'];
    list.shuffle();
    states.shuffle();
    return ExpensesModel(
        list.first, 'Driver Name', 30000, DateTime.now(), states.first);
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (_, index) {
        return ExpensesListTile(
          title: _expenses[index].title,
          driverName: _expenses[index].userName,
          dateTime: _expenses[index].dateTime,
          amount: _expenses[index].amount,
          expenseState: _expenses[index].expenseState,
        );
      },
    );
  }
}
