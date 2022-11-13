// import 'package:flutter/material.dart';
// import 'package:pdf_reports_generator/pdf_reports_generator.dart' as pw;

// import '../ui/reports/reports_generator_module.dart';

// class ReportsPage extends StatefulWidget {
//   ReportsPage({required this.filterWidget, Key? key }) : super(key: key);
//   final Widget filterWidget;


//   @override
//   State<ReportsPage> createState() => _ReportsPageState();
// }

// class _ReportsPageState extends State<ReportsPage> {
//   Future<ReportGeneratorModule?>? _filterFuture;
//   ReportGeneratorModule? pdfGenerator;

 
//   Future<ReportGeneratorModule?> _filter()async{
//     return await showDialog<ReportGeneratorModule>(
//       context: context, 
//       builder: (_)=> Dialog(
//         child: widget.filterWidget,
//       )
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((_) { 
//       setState(() {
//         _filterFuture = _filter();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomDrawer(
//       appBar: null,
//       value: 8,
//       child: Scaffold(
//         // filter button
//         floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
//         floatingActionButton: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//           child: ElevatedButton.icon(
//             onPressed: () async {
//               setState(() {
//                 _filterFuture = _filter();
//               });
//             }, 
//             label: const Text('Filter'),
//             icon: const Icon(Icons.filter_alt_outlined), 
            
//           ),
//         ),
//         body: FutureBuilder<ReportGeneratorModule?>(
//           future: _filterFuture,
//           builder: (context, snapshot) {
//             Widget _child ()=> pdfGenerator == null ? Center(child: const Text('Filter items')) : PdfPreview(
//               canDebug: false,
//               pageFormats: {
//                 'A4': pw.PdfPageFormat.a4,
//                 'Letter': pw.PdfPageFormat.letter,
//                 'A3': pw.PdfPageFormat.a3,
//                 'A5': pw.PdfPageFormat.a5,
//                 'A6': pw.PdfPageFormat.a6,
//               },
//               build: (pageFormat) async {
//                 return (await pdfGenerator!.generatePdf(pageFormat: pageFormat))!.save();
//               },
//             );

//             if(snapshot.hasData){
//               // setState(() {
//                 pdfGenerator = snapshot.data;
//               // });
//             }
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 if(snapshot.hasData){
//                   return Column(
//                     children: [
//                       LinearProgressIndicator(),
//                       Expanded(child: _child())
//                     ],
//                   );
//                 }else{
//                   return Center(child: CircularProgressIndicator(),);
//                 }
//               default:
//               return _child();
//             }

            
//           }
//         ),
//       ),
//     );
    
//   }
// }