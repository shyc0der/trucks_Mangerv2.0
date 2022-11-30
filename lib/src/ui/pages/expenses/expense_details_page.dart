import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/ui/pages/expenses/add_expense_widget.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';
import '../../../models/expenses_model.dart';
import '../../../models/trucks_model.dart';
import '../../../modules/expenses_modules.dart';
import '../../../modules/trucks_modules.dart';
import '../../../modules/user_modules.dart';
import '../../widgets/order_items_widget.dart';
import '../../widgets/update_state_widget.dart';

class ExpenseDetailsPage extends StatefulWidget {
  const ExpenseDetailsPage(this.expensesModel, {Key? key}) : super(key: key);
  final ExpenseModel expensesModel;

  @override
  _ExpenseDetailsPageState createState() => _ExpenseDetailsPageState();
}

class _ExpenseDetailsPageState extends State<ExpenseDetailsPage> {
  final TruckModules _truckModules = TruckModules();
  final UserModule userModule = Get.find<UserModule>();
  final ExpenseModule _expenseModule = Get.find<ExpenseModule>();
  final JobModule jobModule2 = Get.find<JobModule>();
  final OrderModules _orderModules = Get.find<OrderModules>();
    NumberFormat doubleFormat = NumberFormat.decimalPattern('en_us');

  OrderWidgateState _expenseState = OrderWidgateState.Pending;

  @override
  void initState() {
    super.initState();
    _expenseState = widget.expensesModel.expensesState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Expense Detail'),
        actions: [
          if (_expenseState != OrderWidgateState.Closed)
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddExpenseWidget(
                                truckId: widget.expensesModel.truckId ?? '',
                                isEditing: true,
                                expense: widget.expensesModel,
                              )));
                },
                icon: const Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // info card
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // type
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.expensesModel.expenseType ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            _expenseState.value,
                            style: TextStyle(
                                color: _expenseState.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          if (_expenseState != OrderWidgateState.Closed)
                            ElevatedButton(
                                onPressed: () async {
                                  OrderWidgateState? _state =
                                      await changeDialogStateJob(_expenseState,
                                          isSuperUser:
                                              userModule.isSuperUser.value,
                                          isJob: false);

                                  if (_state != null) {
                                    // update online
                                    await _expenseModule.updateExpenseState(
                                        widget.expensesModel.id!, _state);
                                    // setState
                                    setState(() {
                                      _expenseState = _state;
                                    });
                                  }
                                },
                                child: const Text('Update State'))
                        ],
                      ),
                    ),
                    // description
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(widget.expensesModel.description ?? ''),
                    ),
                    // amount and state
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // amount
                          Text(
                              "Ksh.${doubleFormat.format(double.tryParse((widget.expensesModel.totalAmount ?? '0')))}"),
                          // state
                          // Text(expensesModel.state)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(widget.expensesModel.date
                          .toString()
                          .substring(0, 10)),
                    ),
                    // expense state
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        _expenseState.value,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              // job
              if (widget.expensesModel.jobId != null)
                FutureBuilder<OrderModel>(
                    future: _orderModules
                        .fetchOrderByJobId(widget.expensesModel.jobId!),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Error : JOB Not Found}');
                      }
                      if (snapshot.hasData) {
                        var snaps = snapshot.data!;
                        return OrderItemsJobWidget(
                          title: snaps.title ?? '',
                          amount: (snaps.amount ?? 0).toString(),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),

              // truck
              if (widget.expensesModel.truckId != null)
                FutureBuilder<TrucksModel>(
                    future: _truckModules
                        .fetchFutureJobsPerTruck(widget.expensesModel.truckId!),
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

              // image
              if (widget.expensesModel.receiptPath != null)
                SizedBox(
                  width: 300,
                  child: Image.network(
                    widget.expensesModel.receiptPath!,
                    fit: BoxFit.fitWidth,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
