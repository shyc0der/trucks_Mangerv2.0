// pass vehicleId & get regno
// get job by vehicleid
// get expences by jobId
// ignore_for_file: no_leading_underscores_for_local_identifiers, annotate_overrides

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:get/get.dart';
import 'package:pdf_reports_generator/pdf_reports_generator.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/ui/reports/reports_generator_module.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

import '../../modules/expenses_modules.dart';
import '../../modules/job_module.dart';
import '../../modules/user_modules.dart';

class JobsPerVehicle extends ReportGeneratorModule {
  JobsPerVehicle(this.vehicleId,
      {this.selectedJobTypes = const [], required this.dateRange}) {
    UserModule userModule = Get.find<UserModule>();
    _jobModule.init(userModule.currentUser.value);
    
  }
  final DateTimeRange dateRange;

  final JobModule _jobModule = Get.put(JobModule());
  final ExpenseModule _expenseModule = ExpenseModule();
  final OrderModules _orderModule = OrderModules();

  final String vehicleId;
  final List<String> selectedJobTypes;
  final List<JobsPerVehicleModel> _jobsPerV = [];

  String get _vehicleReg =>
      _jobModule.getTruckById(vehicleId)?.vehicleRegNo ?? 'null';

  List<double> get totals {
    double _subT = 0;
    double _expT = 0;
    double _total = 0;

    for (var _j in _jobsPerV) {
      _subT += _j.amount;
      _expT += _j.expensesAmount;
      _total += _j._total;
    }

    return [_subT, _expT, _total];
  }

  List<String> get _filters => selectedJobTypes;

  Future getJobs() async {
    var _jobs = (await _jobModule.fetchJobsByVehicleId(vehicleId));

    // filter by date
    _jobs.retainWhere((job) {
      var _dt = job.dateCreated;
      return _dt.isAfter(dateRange.start) && _dt.isBefore(dateRange.end);
    });

    for (var _job in _jobs) {
      // fetch jobs, then loop each job to fetch expenses per job

      // get order
      var _orderModel =
          (await _orderModule.getOrderById(_job.orderId ?? 'null'));

      if (selectedJobTypes.isNotEmpty &&
          !selectedJobTypes.contains(_orderModel.title)) {
        continue;
      }

      // get expenses total
      double _expenseAmount = 0;
      for (var _expense in (await _expenseModule
          .fetchByJobExpenses(_job.id ?? 'null')
          .first)) {
        if (_expense.expensesState == OrderWidgateState.Approved ||
            _expense.expensesState == OrderWidgateState.Closed) {
          _expenseAmount += double.tryParse(_expense.totalAmount ?? '0') ?? 0;
        }
      }

      _jobsPerV.add(JobsPerVehicleModel(
          orderModel: _orderModel, expensesAmount: _expenseAmount));
    }
  }

  Future<Document> generatePdf({PdfPageFormat? pageFormat}) async {
    // regNo
    // jobs per vehicle
    // get totals
    _jobsPerV.clear();
    await getJobs();

    var _template = JobsPerVehicleReportPdf(
        regNo: _vehicleReg,
        jobs: _jobsPerV.map((e) => e.asMap()).toList(),
        totals: totals,
        rangeFrom: dateRange.start,
        rangeTo: dateRange.end,
        filters: _filters);

    return PdfGenerate.generate(_template,
        pageFormat: pageFormat ?? PdfPageFormat.a4);
  }

  Future<void> generateCsv() async {}
}

class JobsPerVehicleModel {
  JobsPerVehicleModel({required this.expensesAmount, required this.orderModel});
  OrderModel orderModel;
  double expensesAmount = 0;

  double get amount => orderModel.amount ?? 0;

  double get _total => (amount - expensesAmount);

  Map<String, dynamic> asMap() => {
        'orderNo': orderModel.orderNo.toString(),
        'description': '${orderModel.title} : ${orderModel.decription}',
        'amount': orderModel.amount.toString(),
        'expenseAmount': expensesAmount.toString(),
        'total': _total.toString()
      };

  List<String> toList() => asMap().values.map((e) => e.toString()).toList();
}

// amount | expAm   | total
// 200    | 50      | 150
// 200    | 50      | 150
// 200    | 50      | 150
//
//        subtotal: 600,
//        exptotal: 150,
//        total: 450,

class JobsPerVehicleReportController extends GetxController {
  RxString selectedTruck = ''.obs;
  RxList<String> selectedJobTypes = <String>[].obs;

  Rx<DateTimeRange> dateRange = Rx(DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now()));

  ReportGeneratorModule filter() {
    return JobsPerVehicle(selectedTruck.value,
        selectedJobTypes: selectedJobTypes, dateRange: dateRange.value);
  }
}
