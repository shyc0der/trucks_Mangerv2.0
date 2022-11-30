// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trucks_manager/src/models/jobs_model.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
import 'package:trucks_manager/src/models/user_model.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/pages/expenses/add_expense_widget.dart';
import 'package:trucks_manager/src/ui/pages/expenses/expense_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/order_items_widget.dart';
import 'package:trucks_manager/src/ui/widgets/update_state_widget.dart';

import '../../../models/expenses_model.dart';
import '../../../modules/expenses_modules.dart';
import '../../widgets/expenses_list_tile_widget.dart';
import '../../widgets/job_details_widget.dart';
import '../../widgets/order_details_widget.dart';
import '../../widgets/user_widget.dart';

class JobDetailPage extends StatefulWidget {
  const JobDetailPage(this.job, {Key? key}) : super(key: key);
  final JobModel job;

  @override
  JobDetailPageState createState() => JobDetailPageState();
}

class JobDetailPageState extends State<JobDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TruckModules _truckModules = TruckModules();
  final OrderModules _orderModule = OrderModules();
  final JobModule _jobModule = JobModule();
  UserModule userModule = Get.find<UserModule>();
  NumberFormat doubleFormat = NumberFormat.decimalPattern('en_us');

  String _jobState = '';
  final ExpenseModule _expenseModule = ExpenseModule();

  OrderWidgateState orderState = OrderWidgateState.Approved;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
    });
    orderState = widget.job.jobStates;
    _jobState = orderState.value;
  }

  OrderWidgateState get getJobState {
    return orderWidgateState(_jobState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Jobs Details'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //ADD EXPENSE
            // order detail
            FutureBuilder<OrderModel>(
                future: _orderModule.fetchFutureOrderById(widget.job.orderId!),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return JobDetailWidget(
                        title: snapshot.data!.title ?? '',
                        amount: 'Ksh. ${(doubleFormat.format((snapshot.data!.amount ?? 0).ceilToDouble()))}',
                        date: snapshot.data!.dateCreated
                            .toString()
                            .substring(0, 16),
                        jobState: orderState,
                        addExpense: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: AddExpenseWidget(
                                    truckId: widget.job.vehicleId ?? "null",
                                    jobId: widget.job.id ?? "null",
                                  ),
                                );
                              });
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        update: () async {
                          OrderWidgateState? _state =
                              await changeDialogStateJob(getJobState,
                                  isDriver:
                                      userModule.currentUser.value.userRole ==
                                          UserWidgetType.driver);

                          if (_state != null) {
                            await _jobModule.updateJobState(
                                widget.job.id.toString(), _state);
                            await _orderModule.updateOrderState(
                                widget.job.orderId.toString(), _state);
                            setState(() {
                              _jobState = _state.value;
                            });
                          }
                        },
                        onClose: () async {
                          OrderWidgateState? _state =
                              await changeDialogStateJob(getJobState,
                                  isDriver:
                                      userModule.currentUser.value.userRole ==
                                          UserWidgetType.driver);

                          if (_state != null) {
                            await _jobModule.updateJobState(
                                widget.job.id.toString(), _state);
                            await _orderModule.updateOrderState(
                                widget.job.orderId.toString(), _state);
                               
                           if (_state == OrderWidgateState.Closed) {
                              Navigator.pop(context);
                                }
                          }
                        });
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),

            const SizedBox(
              height: 20,
            ),

            // driver detail
            if (widget.job.jobStates != OrderWidgateState.Pending)
              FutureBuilder<UserModel>(
                  future: userModule.fetchTruckByUser(widget.job.driverId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Driver Not Found'),);
                    }
                    if (snapshot.hasData) {
                      return OrderItemsDriverWidget(
                        driverName:
                            '${snapshot.data?.firstName ?? ''} ${snapshot.data?.lastName ?? ''}',
                        email: snapshot.data?.email ?? '',
                        phoneNo: snapshot.data?.phoneNo ?? '',
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),

            // Truck detail
            if (widget.job.jobStates != OrderWidgateState.Pending)
              FutureBuilder<TrucksModel>(
                  future: _truckModules
                      .fetchFutureJobsPerTruck(widget.job.vehicleId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error : Truck Not Found}');
                    }
                    if (snapshot.hasData) {
                      var snaps = snapshot.data!;
                      return OrderItemsTruckWidget(
                        registration: snaps.vehicleRegNo ?? '',
                        loadCapacity: snaps.tankCapity ?? '',
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),

            if (widget.job.jobStates != OrderWidgateState.Pending)
              SizedBox(
                child: SingleChildScrollView(
                    child: StreamBuilder<List<ExpenseModel>>(
                        stream: _expenseModule.fetchByJobExpenses(
                            widget.job.id!, userModule.currentUser.value),
                        builder: (context, snapshot) {
                          List<ExpenseModel> _expenses = snapshot.data ?? [];
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: _expenses.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                               onDoubleTap : () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => ExpenseDetailsPage(
                                            _expenses[index]))),
                              
                               onTap : () {
                                 
                                  AlertDialog alert = 
                                  AlertDialog(
                                    title: const Text('Update Expense State'),
                                    actions: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              OrderWidgateState? _state =
                                                  await changeDialogStateJob(
                                                      _expenses[index]
                                                          .expensesState,
                                                      isSuperUser: userModule
                                                          .isSuperUser.value,
                                                      isJob: false);

                                              if (_state != null) {
                                                // update online
                                                await _expenseModule
                                                    .updateExpenseState(
                                                        _expenses[index].id!,
                                                        _state);
                                                // setState

                                              }
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Update State'))
                                    ],
                                  );
                           if (_expenses[index].expensesState != OrderWidgateState.Closed)   {
                            showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                           }
                                  
                                },
                                child: ExpensesListTile(
                                  title: _expenses[index].expenseType ?? '',
                                  driverName: _expenses[index].userId ?? '',
                                  dateTime: _expenses[index].date,
                                  amount: 
                                  doubleFormat.format(double.tryParse(_expenses[index].totalAmount ?? '0')),
                                              
                                  expenseState: _expenses[index].expensesState,
                                ),
                              );
                            },
                          );
                        })),
              )
          ],
        ),
      ),
    );
  }
}
