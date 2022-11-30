// ignore_for_file: no_leading_underscores_for_local_identifiers, annotate_overrides

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:get/get.dart';
import 'package:pdf_reports_generator/pdf_reports_generator.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/ui/reports/reports_generator_module.dart';

import '../../models/expenses_model.dart';
import '../../modules/expenses_modules.dart';
import '../../modules/user_modules.dart';

class ExpensesPerVehicleReport extends ReportGeneratorModule{
  ExpensesPerVehicleReport(this.vehicleId, {this.expenseType = const [], required this.dateRange});
  final String vehicleId;
  final List<String> expenseType;
  final DateTimeRange dateRange;

  final ExpenseModule _expenseModule = ExpenseModule();
    final TruckModules _truckModule = TruckModules();
    UserModule userModule=Get.find<UserModule>();

  List<ExpenseModel> expenses = [];
  List<String> _filters = [];

  Future<String> get _vehicleReg async => (await _truckModule.fetchTruckById(vehicleId)).vehicleRegNo ?? 'null';

  double get totals {
    double _t = 0;
    for(var _ex in expenses){
      _t += double.tryParse(_ex.totalAmount ?? '0') ?? 0;
    }

    return _t;
  }

  Future getExpenses()async{
    expenses = await _expenseModule.fetchByTruckExpenses(vehicleId,userModule.currentUser.value).first;

    // filter by date
    expenses.retainWhere((expense) {
      var _dt =expense.date;
      return _dt.isAfter(dateRange.start) && _dt.isBefore(dateRange.end);
    });
  }

  void filter(){
    if(expenseType.isNotEmpty){
      expenses = expenses.where((expense){
        return expenseType.contains(expense.expenseType);
      }).toList();

      _filters = expenseType;
    }
  }

  Future<Document> generatePdf({PdfPageFormat? pageFormat})async{
    // regNo
    // get expenses
    expenses.clear();
    await getExpenses();

    // apply filters
    filter();

    var _template = ExpensesPerVehicleReportPdf(
      regNo: await _vehicleReg,
      expenses: expenses.map((e) => e.asMap()).toList(),
      totals: totals,
      rangeFrom: dateRange.start,
      rangeTo: dateRange.end,
      filters: _filters
    );

    return PdfGenerate.generate(_template, pageFormat: pageFormat = PdfPageFormat.a4);
  }

}

class ExpensesPerVehicleReportController extends GetxController{
  RxString selectedTruck = ''.obs;
  RxList<String> selectedExpenseTypes = <String>[].obs;
  
  Rx<DateTimeRange> dateRange = Rx(DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)), 
    end: DateTime.now()
  ));

  ReportGeneratorModule filter(){
    return ExpensesPerVehicleReport(selectedTruck.value, expenseType: selectedExpenseTypes, dateRange: dateRange.value);
  }
}