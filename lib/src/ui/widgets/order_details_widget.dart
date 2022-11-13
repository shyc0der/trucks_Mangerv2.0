// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
class OrderDetailWidget extends StatefulWidget{
   const OrderDetailWidget(
      {required this.title,
      required this.amount,
      required this.date,
      required this.orderState,
      this.update,
      this.onCancel,
      this.onClose,
      this.goToJob,
      Key? key})
      : super(key: key);
       final String title;
  final String amount;
  final String date;
  final OrderWidgateState orderState;
  final void Function()? onCancel;
  final void Function()? onClose;
  final void Function()? update;
  final void Function()? goToJob;
   @override
OrderDetailWidgetState createState() => OrderDetailWidgetState();
}

class OrderDetailWidgetState extends State<OrderDetailWidget> {
 
 

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.amount,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            widget.date,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.orderState == OrderWidgateState.Pending ||
                  widget.orderState == OrderWidgateState.Open)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    onPressed: widget.onCancel,
                    child: const Text('Cancel')),
              if (widget.orderState == OrderWidgateState.Pending ||
                  widget.orderState == OrderWidgateState.Open)
                ElevatedButton(
                    // style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    onPressed: widget.orderState == OrderWidgateState.Pending
                        ? widget.update
                        : widget.goToJob,
                    child: Text(widget.orderState == OrderWidgateState.Pending
                        ? 'Update'
                        : 'Go To Respective Job')),
              if (widget.orderState == OrderWidgateState.Closed || widget.orderState == OrderWidgateState.Approved)
               ElevatedButton(onPressed: widget.goToJob, child: const Text('Go To Respective Job')),
            ],
          )
        ],
      ),
    );
  }
}

enum OrderWidgateState { Pending, Open, Closed, Rejected, Approved,Declined }

extension OrderWidgateStateExt on OrderWidgateState {
  Color get color {
    switch (this) {
      case OrderWidgateState.Pending:
        return Colors.amber;
      case OrderWidgateState.Open:
        return Colors.blue;
      case OrderWidgateState.Approved:
        return Colors.green;
      case OrderWidgateState.Rejected:
        return Colors.red;
        case OrderWidgateState.Declined:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get value {
    switch (this) {
      case OrderWidgateState.Open:
        return 'Open';
      case OrderWidgateState.Closed:
        return 'Closed';
      case OrderWidgateState.Rejected:
        return 'Rejected';  
     case OrderWidgateState.Declined:
        return 'Declined';
      case OrderWidgateState.Approved:
        return 'Approved';
      default:
        return 'Pending';
    }
  }
}

OrderWidgateState orderWidgateState(String val) {
  switch (val) {
    case 'Open':
      return OrderWidgateState.Open;
    case 'Rejected':
      return OrderWidgateState.Rejected;
  case 'Declined':
      return OrderWidgateState.Declined;
    case 'Closed':
      return OrderWidgateState.Closed;
    case 'Approved':
      return OrderWidgateState.Approved;

    default:
      return OrderWidgateState.Pending;
  }
}
