import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

class JobListTile extends StatelessWidget {
  const JobListTile(
      {required this.title,
      required this.orderNo,
      required this.dateTime,
      required this.amount,
      this.onTap,
      this.onDoubleTap,
      required this.jobState,
      Key? key})
      : super(key: key);
  final String title;
  final String orderNo;
  final DateTime dateTime;
  final String amount;
  final OrderWidgateState jobState;
  final void Function()? onTap;
  final void Function()? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        onLongPress: onDoubleTap,
        leading: Container(
          width: 6,
          color: jobState.color,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(orderNo),
          ],
        ),
        subtitle: Text(dateTime.toString().substring(0, 16)),
        trailing:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text('Ksh. $amount'),
          Text(
            jobState.value,
            style: TextStyle(
                color: jobState.color,
                fontWeight: FontWeight.bold,
                fontSize: 14.5),
          )
        ]),
      ),
    );
  }
}
