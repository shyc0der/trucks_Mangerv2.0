// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:trucks_manager/src/models/expenses_model.dart';
// import 'package:trucks_manager/src/models/trucks_model.dart';
// import 'package:trucks_manager/src/modules/expenses_modules.dart';
// import 'package:trucks_manager/src/modules/trucks_modules.dart';
// import 'package:trucks_manager/theme_data.dart';

// class ExpenseReportPage extends StatefulWidget {
//   const ExpenseReportPage({super.key});

//   @override
//   State<ExpenseReportPage> createState() => _ExpenseReportPageState();
// }

// class _ExpenseReportPageState extends State<ExpenseReportPage> {
//   @override
//   Widget build(BuildContext context) {
//     final TruckModules _truckModules = Get.put(TruckModules());
//     List<Map<String, dynamic>> trucks = [
//       {
//         'item': {'budget': 'shopping', 'amount': '100'}
//       },
//       {
//         'item': {'budget': 'cloths', 'amount': '200'}
//       },
//       {
//         'item': {'budget': 'clotes', 'amount': '200'}
//       },
//       {
//         'item': {'budget': 'clthes', 'amount': '200'}
//       },
//       {
//         'item': {'budget': 'cothes', 'amount': '200'}
//       },
//       {
//         'item': {'budget': 'lothes', 'amount': '200'}
//       },
//       {
//         'item': {'budget': 'othes', 'amount': '200'}
//       },
//       {
//         'item': {'budget': 'thes', 'amount': '200'}
//       },
//       {
//         'item': {'budget': 'pthes', 'amount': '200'}
//       },
//       {
//         'item': {'budget': '6hes', 'amount': '200'}
//       },
//       {
//         'item': {'budget': 'hes', 'amount': '200'}
//       },
//     ];
//     List<Map<String, dynamic>> amountsPerExpenseType = [];
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Expense Report'),
//       ),
//       body: StreamBuilder<List<TrucksModel>>(
//           stream: _truckModules.fetctch(),
//           builder: (context, snapshot) {
//             var data = snapshot.data ?? [];
//             var totalAmount = data.fold<double>(
//                 0.0,
//                 (amount, expense) =>
//                     amount +
//                     (double.tryParse(expense.totalAmount!) ?? 0.0));
//             var newMap = groupBy(data,
//                 (ExpenseModel expenseModel) => expenseModel.expenseType);
//             newMap.forEach((key, value) {
//               var tes = value.fold<double>(
//                   0.0,
//                   (previousValue, expense) =>
//                       previousValue +
//                       (double.tryParse(expense.totalAmount!) ?? 0.0));
//               amountsPerExpenseType.add({
//                            'item': {'title': key, 'amount': tes}
//                          });
//               // Future.delayed(
//               //     const Duration(seconds: 1),
//               //     (() => setState(() {
//               //           amountsPerExpenseType.add({
//               //             'item': {'title': key, 'amount': tes}
//               //           });
//               //         })));
//             });

//        
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 400,
//                   child: SfCircularChart(
//                     backgroundColor: themeData.backgroundColor,
//                     borderColor: themeData.primaryColor,
//                     palette: palettes,
//                     legend: Legend(
//                         isVisible: true,
//                         textStyle: const TextStyle(fontSize: 18)),
//                     title: ChartTitle(
//                         text: 'Total Amount : $totalAmount',
//                         textStyle: const TextStyle(fontWeight: FontWeight.bold)),
//                     series: <CircularSeries>[
//                       PieSeries<Map<String, dynamic>, String>(
//                         dataSource: amountsPerExpenseType,
//                         xValueMapper: (Map<String, dynamic> maps, _) =>
//                             maps['item']['title'],
//                         yValueMapper: (Map<String, dynamic> maps, _) =>
//                             maps['item']['amount'],
//                         dataLabelSettings: const DataLabelSettings(
//                             isVisible: true, textStyle: TextStyle(fontSize: 18)),
//                       ),
//                     ],
//                   ),
//                 ),
//               const  SizedBox(height: 20,),
//              const Center(child: Text('EXPENSES TABLE'),),
//          Expanded(
//             child: Center(
//               child: ListView.builder(
//               //shrinkWrap: true,
//               itemCount: amountsPerExpenseType.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   // amountsPerExpenseType.add({
//                   //            'item': {'title': 'ALL', 'amount': totalAmount}
//                   //          });
//                  return Padding(
//                   padding: const EdgeInsets.only(left: 50,right: 50),
//                   child: SingleChildScrollView(
//                     child: 
                    
//                     Table(
//                      //bo   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      border: TableBorder.all(),
                     
//                       children: [
//                        TableRow(
//                         decoration:  BoxDecoration(color: themeData.backgroundColor),
//                         //decoration: const Decoration(),
//                         children: [
//                         SizedBox(
//                           height: 50,
//                           child: Center(
//                             child: Text(
                                    
//                                     amountsPerExpenseType[index]['item']['title']),
//                           ),
//                         ),
//                            SizedBox(
//                             height: 50,
//                              child: Center(
//                                child: Text(
//                                   'KES ${amountsPerExpenseType[index]['item']['amount']}'),
//                              ),
//                            ),
                               
//                        ])
                            
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             ),
//       )
  
//               ],
//             );
//           }),
//     );
//   }
// }
