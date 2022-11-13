import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

class JobListTile extends StatelessWidget {
  const JobListTile(
      {required this.title,
      required this.dateTime,
      required this.amount,
      this.onTap,
      required this.jobState,
      Key? key})
      : super(key: key);
  final String title;
  final DateTime dateTime;
  final double amount;
  final OrderWidgateState jobState;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 6,
          color: jobState.color,
        ),
        title: Text(title),
        subtitle: Text(dateTime.toString().substring(0, 16)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Text('Ksh. ${amount.ceilToDouble()}'),

          Text(jobState.value,style: TextStyle(color: jobState.color,fontWeight: FontWeight.bold,fontSize: 14.5),)
          
          ]),
      ),
    );
  }
}
