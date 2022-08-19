// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class OrderDetialWidget extends StatelessWidget {
  const OrderDetialWidget(
      {required this.title,
      required this.amount,
      required this.date,
      required this.orderState,
      this.onApprove,
      this.onCancel,
      this.onClose,
      Key? key})
      : super(key: key);
  final String title;
  final String amount;
  final String date;
  final OrderWidgateState orderState;
  final void Function()? onCancel;
  final void Function()? onClose;
  final void Function()? onApprove;

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
            title,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              amount,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            date,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (orderState == OrderWidgateState.Pending ||
                  orderState == OrderWidgateState.Open)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    onPressed: onCancel,
                    child: const Text('Cancel')),
              if (orderState == OrderWidgateState.Pending ||
                  orderState == OrderWidgateState.Open)
                ElevatedButton(
                    // style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    onPressed: orderState == OrderWidgateState.Pending
                        ? onApprove
                        : onClose,
                    child: Text(orderState == OrderWidgateState.Pending
                        ? 'Approve'
                        : 'Close')),
              if (orderState == OrderWidgateState.Closed)
                const ElevatedButton(onPressed: null, child: Text('Closed')),
            ],
          )
        ],
      ),
    );
  }
}

enum OrderWidgateState { Pending, Open, Closed, Rejected, Approved }

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
    case 'Closed':
      return OrderWidgateState.Closed;
    case 'Approved':
      return OrderWidgateState.Approved;

    default:
      return OrderWidgateState.Pending;
  }
}
