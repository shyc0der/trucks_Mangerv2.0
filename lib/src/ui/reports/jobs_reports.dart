// ignore_for_file: no_leading_underscores_for_local_identifiers, annotate_overrides

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:get/state_manager.dart';
import 'package:pdf_reports_generator/pdf_reports_generator.dart';
import 'package:trucks_manager/src/models/jobs_model.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/ui/reports/reports_generator_module.dart';

import '../../modules/expenses_modules.dart';
import '../../modules/user_modules.dart';

class JobsReport extends ReportGeneratorModule{
  JobsReport({this.driverId, this.selectedJobState = const [], this.selectedJobTypes = const [], required this.dateRange});
  final String? driverId;
  final DateTimeRange dateRange;
  final List<String> selectedJobTypes;
  final List<String> selectedJobState;

  final OrderModules _orderModule = OrderModules();
  final JobModule _jobModule2 = JobModule();
  final ExpenseModule _expenseModule = ExpenseModule();
  final UserModule _userModule = UserModule();
  final TruckModules _truckModule = TruckModules();

  List<JobsReportModel> jobs = [];

  double _expenseTotals = 0;
  double _jobTotals = 0;

  List<String> get _filters => [
    if(driverId != null) 'By driver Id',
    if(selectedJobTypes.isNotEmpty) 'Title:$selectedJobTypes',
    if(selectedJobState.isNotEmpty) 'State:$selectedJobState',
  ]; 

  Future getJobs() async{
    var _jobs = await _jobModule2.fetchAllWhereDateRangeJobs(dateRange).first;
    if(driverId != null){
      _jobs.retainWhere((job) => job.driverId == driverId );
    }
    if(selectedJobState.isNotEmpty){
      _jobs.retainWhere((job) => selectedJobState.contains(job.state) );
    }

     for (var _job in _jobs){
            // get order by jobid
      final order = await  _orderModule.getOrderById(_job.orderId ?? 'null');

      if(selectedJobTypes.isNotEmpty && !selectedJobTypes.contains(order.title)){
        continue;
      }
     
      // order totals
      _jobTotals += order.amount ?? 0;
      

      double _expensesPerJobTotal = 0;
      
            // then get expenses by job id
      final _exs = await _expenseModule.fetchByJobExpenses(_job.id ?? 'null').first;
      
      
      for(var _e in _exs){
        _expensesPerJobTotal += double.tryParse(_e.totalAmount ?? '0') ?? 0;
        
      }

      // get expense total
      _expenseTotals += _expensesPerJobTotal;

            

      // get customer
      final customer = await _userModule.fetchCustomerById(order.customerId ?? 'null');
     
      String customerName = "${customer.firstName ?? ''}  ${customer.lastName ?? ''}";
      // get driver name 
      final driver = await _userModule.getUserById(_job.driverId ?? 'null');
      String driverName = "${driver.firstName ?? ''} ${driver.lastName ?? ''}";
      // vehicle reg
      final truck = await _truckModule.fetchTruckById(_job.vehicleId ?? 'null');
      String reg = "${truck.vehicleRegNo}";
      
  

      jobs.add(JobsReportModel(
        expensesAmount: _expensesPerJobTotal, orderModel: order, jobModel2: _job,
        customerName: customerName, driverName:driverName, vehicleRegNo: reg
      ));
      
    }
  }

  Future<Document> generatePdf({PdfPageFormat? pageFormat})async{
    // get jobs    
    jobs.clear();
    _jobTotals = _expenseTotals = 0;
   await getJobs();
  
   var _template =JobsReportPdf(
     jobs: jobs.map((e) => e.asMap()).toList(),
     totals: [_jobTotals, _expenseTotals, _jobTotals-_expenseTotals],
     rangeFrom: dateRange.start,
     rangeTo: dateRange.end,
     filters : _filters


   );
   

    return PdfGenerate.generate(_template,pageFormat:pageFormat ?? PdfPageFormat.a4);
    
  }

}

class JobsReportModel {
  JobsReportModel({
    required this.expensesAmount, required this.orderModel, 
    required this.jobModel2, required this.customerName,
    required this.driverName,    required this.vehicleRegNo,
  });
  OrderModel orderModel;
  JobModel jobModel2;
  String customerName;
  String driverName;
  String vehicleRegNo;
  double expensesAmount = 0;

  double get total => orderModel.amount ?? 0 - expensesAmount;

  Map<String, dynamic> asMap()=>{
    ...orderModel.asMap(),
    ...jobModel2.asMap(),
    'expensesAmount': expensesAmount.toString(),
    'total': total.toString(),
    'customerName': customerName,
    'driverName': driverName,
    'vehicleRegNo': vehicleRegNo,
  };

}

class AllJobsReportController extends GetxController{
  Rx<String?> driverId = Rxn();
  RxList<String> selectedJobTypes = <String>[].obs;
  RxList<String> selectedJobState = <String>[].obs;
  
  Rx<DateTimeRange> dateRange = Rx(DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)), 
    end: DateTime.now()
  ));

  ReportGeneratorModule filter(){
    return JobsReport(driverId: driverId.value, selectedJobTypes: selectedJobTypes, selectedJobState: selectedJobState, dateRange: dateRange.value);
  }
}