// ignore_for_file: no_leading_underscores_for_local_identifiers, annotate_overrides

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:get/get.dart';
import 'package:pdf_reports_generator/pdf_reports_generator.dart';
import 'package:trucks_manager/src/ui/reports/reports_generator_module.dart';

import '../../models/expenses_model.dart';
import '../../modules/expenses_modules.dart';
import '../../modules/job_module.dart';
import '../../modules/trucks_modules.dart';
import '../../modules/user_modules.dart';

class ExpensesReport extends ReportGeneratorModule{
  ExpensesReport({this.expenseTypes = const [], required this.dateRange,required this.state});
  final List<String> expenseTypes;
  final List<String> state;
  final DateTimeRange dateRange;

  final ExpenseModule _expenseModule = ExpenseModule();
  final JobModule _jobModule = Get.put(JobModule());
  final UserModule _userModule = UserModule();
  final TruckModules _truckModule = TruckModules();

  List<ExpensesReportModel> expenses = [];

  double get totals {
    double _t = 0;
    for(var _ex in expenses){
      _t += _ex.totalAmount;
    }

    return _t;
  }

  List<String> get _filters =>
  [ 
     if(expenseTypes.isNotEmpty) 'ExpenseTypes: $expenseTypes',
    if(state.isNotEmpty) 'State: $state'
     ];

  Future getExpenses() async{
    var _exes = (await _expenseModule.fetchAllWhereDateRangeExpenses(dateRange).first);
    // filter
    if(expenseTypes.isNotEmpty){
      _exes = _exes.where((e) => expenseTypes.contains(e.expenseType)).toList();
    }
    //expense types
     if(state.isNotEmpty){
      _exes = _exes.where((e) => state.contains(e.state)).toList();
    }
    for ( var _exp in _exes){
      // get driver name 
      final _user = await _userModule.getUserById(_exp.userId ?? 'null');
      String _userName = "${_user.firstName} ${_user.lastName}";
      // vehicle reg
      final _truck = await _truckModule.fetchTruckById(_exp.truckId ?? 'null');
      String _reg = "${_truck.vehicleRegNo}";

      
      if(_exp.jobId != null){
       final _res =  _jobModule.getJobById(_exp.jobId ?? 'null');
       if(_res != null){
         _exp.jobId =_res.orderNo;
       }      
      }
      expenses.add(ExpensesReportModel(
        expense: _exp, user: _userName, vehicleRegNo: _reg
      ));
    }
  }
  

  Future<Document> generatePdf({PdfPageFormat? pageFormat})async{
    // get expenses
    expenses.clear();
    await getExpenses();

    var _template = ExpensesReportPdf(
      expenses: expenses.map((e) => e.asMap()).toList(),
      totals: totals,
      rangeFrom: dateRange.start,
      rangeTo: dateRange.end,
      filters: _filters
    );

    return PdfGenerate.generate(_template, pageFormat: pageFormat ?? PdfPageFormat.a4);
  }

}


class ExpensesReportModel {
  ExpensesReportModel({
    required this.expense, this.orderNo, 
    required this.user, required this.vehicleRegNo,
    
  });
  ExpenseModel expense;
  String? orderNo;
  String user;
  String vehicleRegNo;
  double get totalAmount => double.tryParse(expense.totalAmount ?? '0') ?? 0;

  Map<String, dynamic> asMap(){
    if((expense.id?.length ?? 0) > 14){
      expense.id = expense.id?.substring(10);
    }
    return {
      ...expense.asMap(),
      'user': user,
      'vehicleRegNo': vehicleRegNo,
      'totalAmount': totalAmount,
    };
  }

}

class ExpensesReportController extends GetxController {
  RxList<String> selectedExpenseTypes = <String>[].obs;
  RxList<String> selectedState=<String>[].obs;
  
  Rx<DateTimeRange> dateRange = Rx(DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)), 
    end: DateTime.now()
  ));
  ReportGeneratorModule filter(){
    return ExpensesReport(expenseTypes: selectedExpenseTypes, dateRange: dateRange.value,state:selectedState);
  }
}