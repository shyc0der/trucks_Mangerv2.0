import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trucks_manager/src/modules/expenses_modules.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/ui/pages/expenses/expense_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/constants.dart';
import 'package:trucks_manager/src/ui/widgets/expenses_list_tile_widget.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

import '../../../models/expenses_model.dart';
import '../../../modules/user_modules.dart';

class ExpensesPage extends StatefulWidget {
  ExpensesPage(this.state,{Key? key}) : super(key: key);
  String state;

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {

   ExpenseModule _expenseModule = Get.put(ExpenseModule());
  UserModule userModule = Get.put(UserModule());
  TruckModules truckModules = Get.put(TruckModules());
  NumberFormat doubleFormat = NumberFormat.decimalPattern('en_us');
  Constants constants = Constants();

  // void _changeView(int val) {
  //   switch (val) {
  //     case 1:
  //       setState(() {
  //         displayExpenses = expenses
  //             .where((element) =>
  //                 element.expensesState == OrderWidgateState.Pending)
  //             .toList();
  //       });
  //       break;
  //     case 2:
  //       setState(() {
  //         displayExpenses = expenses
  //             .where(
  //                 (element) => element.expensesState == OrderWidgateState.Open)
  //             .toList();
  //       });
  //       break;
  //     case 3:
  //       setState(() {
  //         displayExpenses = expenses
  //             .where((element) =>
  //                 element.expensesState == OrderWidgateState.Closed)
  //             .toList();
  //       });
  //       break;
  //     default:
  //       setState(() {
  //         displayExpenses = expenses;
  //       });
  //   }
  // }

  @override
  void initState() {
    super.initState();
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Expenses'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: StreamBuilder<List<ExpenseModel>>(
        stream: _expenseModule.fetchByExpensesByState(widget.state, userModule.currentUser.value),
        builder: (context, snapshot) {
             if (snapshot.hasError) {
                            return Text('Error = ${snapshot.error}');
                          }
                          if (snapshot.hasData) {
                              var displayExpenses = snapshot.data!;
          return ListView.builder(
            itemCount: displayExpenses.length,
            itemBuilder: (_, index) {
              return ExpensesListTile(
                title: displayExpenses[index].expenseType ?? '',
                truckNumber:
                    constants.truckNumber(displayExpenses[index].truckId ?? ''),
                driverName:
                    constants.driverName(displayExpenses[index].userId ?? ''),
                dateTime: displayExpenses[index].date,
                amount: doubleFormat.format(
                    (double.tryParse(displayExpenses[index].totalAmount ?? '0'))),
                expenseState: displayExpenses[index].expensesState,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ExpenseDetailsPage(displayExpenses[index])));
                },
              );
            },
          );}
          else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
        }
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: 0,
      //   onTap: _changeView,
      //   items: const [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.list_outlined), label: 'All'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.pending_outlined), label: 'Pending'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.outbox_outlined), label: 'Open'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.done_all_outlined), label: 'Closed'),
      //   ],
      // ),
    );
  }
}

// List<ExpensesModel> _expenses = List.generate(30, (index) {
//   final List<OrderWidgateState> states = List.from(OrderWidgateState.values);
//   final list = ['Fuel', 'Repair', 'Airtime'];
//   list.shuffle();
//   states.shuffle();
//   return  ExpensesModel(
//   list.first, 'Driver Name', 30000, DateTime.now(), states.first);
// });

// class ExpensesModel {
//   ExpensesModel(this.title, this.userName, this.amount, this.dateTime, this.expenseState);
//   final String title;
//   final String userName;
//   final double amount;
//   final DateTime dateTime;
//   final OrderWidgateState expenseState;
// }