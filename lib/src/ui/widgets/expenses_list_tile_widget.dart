import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';
class ExpensesListTile extends StatelessWidget {
  const ExpensesListTile({required this.title, required this.driverName, required this.dateTime, required this.amount, this.onTap, required this.expenseState, Key? key}) : super(key: key);
  final String title;
  final String driverName;
  final DateTime dateTime;
  final double amount;
  final OrderWidgateState expenseState;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        isThreeLine: true,
        onTap: onTap,
        leading: Container(
          width: 6,
          color: expenseState.color,
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(driverName),
            Text(dateTime.toString().substring(0, 16))
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          Text(expenseState.value,style: TextStyle(color: expenseState.color,fontWeight: FontWeight.bold,fontSize: 14.5), ),
          const SizedBox(height:15),
          Text('Ksh. $amount'),
        ]),
      ),
    );
  }
}