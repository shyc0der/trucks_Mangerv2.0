import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';
class ExpensesListTile extends StatelessWidget {
  const ExpensesListTile({required this.title, required this.driverName,required this.truckNumber, required this.dateTime, required this.amount, 
  this.onTap, 
  this.onDoubleTap, 
  required this.expenseState, Key? key}) : super(key: key);
  final String title;
  final String driverName;
  final String truckNumber;
  final DateTime dateTime;
  final String amount;
  final OrderWidgateState expenseState;
  final void Function()? onTap;
  final void Function()? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(top:4.0,bottom: 4.0),
        isThreeLine: true,
        onTap: onTap,
        onLongPress: onDoubleTap,
        leading: Container(
          width: 6,
          color: expenseState.color,
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(truckNumber),
            Text(driverName),            
            Text(dateTime.toString().substring(0, 16))
          ],
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            Text(expenseState.value,style: TextStyle(color: expenseState.color,fontWeight: FontWeight.bold,fontSize: 14.5), ),
            const SizedBox(height:15),
            Text('Ksh. $amount'),
          ]),
        ),
      ),
    );
  }
}