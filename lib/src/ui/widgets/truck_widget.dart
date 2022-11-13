
import 'package:flutter/material.dart';

class TruckWidget extends StatelessWidget {
  const TruckWidget({required this.registration, required this.jobsAmount, required this.expensesAmount, this.addExpense, Key? key}) : super(key: key);
  final String registration;
  final double jobsAmount;
  final String expensesAmount;
 final void Function()? addExpense;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(10),
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
        ]          
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          // icon & registration
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_shipping_outlined, color: Theme.of(context).colorScheme.secondary, size: 60,),
              Text(registration, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),)
            ],
          ),

          // verticle divider
          VerticalDivider(indent: 10, endIndent: 10, width: 40, thickness: 2, color: Theme.of(context).colorScheme.onBackground.withOpacity(.4),),

          // jobs total & expneses total & score
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           
              Text('Jobs Ksh. $jobsAmount', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
              Text('Expenses Ksh. $expensesAmount', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ],            
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton.icon(
              onPressed: addExpense
              ,
              icon: const Icon(Icons.add), 
              label: const Text('Add Expenses')
                
            ),          
            
          ),

        ],
      ),
    );
  }
}