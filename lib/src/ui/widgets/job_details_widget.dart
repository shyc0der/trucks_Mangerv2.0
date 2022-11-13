// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'order_details_widget.dart';
class JobDetailWidget extends StatefulWidget{
   const JobDetailWidget(
      {required this.title,
      required this.amount,
      required this.date,
      required this.jobState,
      this.update,
      this.onCancel,
      this.onClose,
      this.addExpense,
      Key? key})
      : super(key: key);
       final String title;
  final String amount;
  final String date;
  final OrderWidgateState jobState;
  final void Function()? onCancel;
  final void Function()? onClose;
  final void Function()? update;
   final void Function()? addExpense;
   @override
JobDetailWidgetState createState() => JobDetailWidgetState();
}

class JobDetailWidgetState extends State<JobDetailWidget> {
 
 

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
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
      child: Stack(   
       alignment: AlignmentDirectional.topStart,         
          children: [
            Align( alignment: Alignment.topRight,
           child: ElevatedButton.icon(
           onPressed: widget.addExpense,
           icon: const Icon(Icons.add), 
       label: const Text('Add Expenses')
           ,),
           
           ),
  Column(  
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
          Text(
            widget.jobState.value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
           const SizedBox(
            height: 20,
          ),
          
           ],),
      Align(
        alignment: Alignment.bottomRight,
        child: Row(
          
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: [
         if ((widget.jobState == OrderWidgateState.Pending || widget.jobState == OrderWidgateState.Approved) ||
             widget.jobState == OrderWidgateState.Open)
           ElevatedButton(
               style: ElevatedButton.styleFrom(primary: Colors.redAccent),
               onPressed: widget.onCancel,
               child: const Text('Cancel')),
         if ((widget.jobState == OrderWidgateState.Pending || widget.jobState == OrderWidgateState.Approved) ||
             widget.jobState == OrderWidgateState.Open)
           ElevatedButton(
               // style: ElevatedButton.styleFrom(primary: Colors.redAccent),
               onPressed: (widget.jobState == OrderWidgateState.Pending || widget.jobState == OrderWidgateState.Approved)
                   ? widget.update
                   : widget.onClose,
               child: Text((widget.jobState == OrderWidgateState.Pending || widget.jobState == OrderWidgateState.Approved)
                   ? 'Update'
                   : 'Close')),
         if (widget.jobState == OrderWidgateState.Closed)
         const ElevatedButton(onPressed: null, child:  Text('Close')),
       ],
            ),
      )


         ],
      ),
    );
  }
}

