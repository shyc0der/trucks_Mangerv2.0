import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/widgets/expenses_list_tile_widget.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  late final List<ExpensesModel> expenses;
  late List<ExpensesModel> displayExpenses;

  void _changeView(int val){
    switch (val) {
      case 1:
        setState(() {
          displayExpenses = expenses.where((element) => element.expenseState == OrderWidgateState.Pending).toList();
        });
        break;
      case 2:
        setState(() {
          displayExpenses = expenses.where((element) => element.expenseState == OrderWidgateState.Open).toList();
        });
        break;
      case 3:
        setState(() {
          displayExpenses = expenses.where((element) => element.expenseState == OrderWidgateState.Closed).toList();
        });
        break;
      default:
      setState(() {
          displayExpenses = expenses;
        });
      
    }
  }


  @override
  void initState() {
    super.initState();
    expenses = _expenses;
    displayExpenses = expenses;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Expenses'),
        actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.search))],
      ),

      body: ListView.builder(
        itemCount: displayExpenses.length,
        itemBuilder: (_, index){
          return ExpensesListTile(
            title: displayExpenses[index].title, 
            driverName: displayExpenses[index].userName, 
            dateTime: displayExpenses[index].dateTime, 
            amount: displayExpenses[index].amount, 
            expenseState: displayExpenses[index].expenseState,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: _changeView,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_outlined), label: 'All'),
          BottomNavigationBarItem(icon: Icon(Icons.pending_outlined), label: 'Pending'),
          BottomNavigationBarItem(icon: Icon(Icons.outbox_outlined), label: 'Open'),
          BottomNavigationBarItem(icon: Icon(Icons.done_all_outlined), label: 'Closed'),
        ],
      ),
    );
  }
}

List<ExpensesModel> _expenses = List.generate(30, (index) {
  final List<OrderWidgateState> states = List.from(OrderWidgateState.values);
  final list = ['Fuel', 'Repair', 'Airtime'];
  list.shuffle();
  states.shuffle();
  return  ExpensesModel(
  list.first, 'Driver Name', 30000, DateTime.now(), states.first);
});

class ExpensesModel {
  ExpensesModel(this.title, this.userName, this.amount, this.dateTime, this.expenseState);
  final String title;
  final String userName;
  final double amount;
  final DateTime dateTime;
  final OrderWidgateState expenseState;
}