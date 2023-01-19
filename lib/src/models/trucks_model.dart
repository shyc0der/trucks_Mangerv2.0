import 'package:flutter/material.dart';
import 'package:trucks_manager/src/models/jobs_model.dart';
import 'package:trucks_manager/src/models/model.dart';
import 'package:trucks_manager/src/modules/expenses_modules.dart';
import 'package:trucks_manager/src/modules/job_module.dart';

import 'expenses_model.dart';

class TrucksModel extends Model {
  final ExpenseModule _expenseModule = ExpenseModule();
  final JobModule _jobModule = JobModule();
  TrucksModel({
    this.id,
    this.tankCapity,
    this.vehicleRegNo,
    this.vehicleLoad,
    this.category,
    bool? active,
    bool? deleted,
  }) : super('trucks') {
    isActive = active ?? true;
    isDeleted = deleted ?? false;
  }
  String? vehicleRegNo;
  String? tankCapity;
  String? vehicleLoad;
  String? id;
  String? category;
  bool isActive = true;
  bool isDeleted = false;

  TrucksModel.fromMap(Map map) : super('trucks') {
    id = map['id'];
    vehicleRegNo = map['vehicleRegNo'];
    tankCapity = map['tankCapity'];
    vehicleLoad = map['vehicleLoad'];
    isActive = map['isActive'] ?? true;
    isDeleted = map['isDeleted'] ?? false;
  }

  Future<List<ExpenseModel>> fetchExpenseByTruck(DateTimeRange dateTimeRange) {
    var expenses =
        _expenseModule.fetchExpenseByTruckAndDate(id!, dateTimeRange);
    return expenses.first;
  }

  Future<List<JobModel>> fetchJobsByTruck(DateTimeRange dateTimeRange) {
    var jobs = _jobModule.fetchJobsByVehicleId(id!);
    return jobs;
  }

  List<double> reportTotal = [0, 0];
  Future<List<double>> getTotals(DateTimeRange dateTimeRange) async {
    var expenses = (await fetchExpenseByTruck(dateTimeRange)).fold<double>(
        0.0,
        (previousValue, element) =>
            previousValue + (double.tryParse(element.totalAmount!) ?? 0.0));
    ;

    var job = (await fetchJobsByTruck(dateTimeRange))
        .fold<double>(0.0, (previousValue, element) => previousValue + (200.0));
    //print(expenses);
    return [job, expenses];
  }

  Map<String, dynamic> asMap() {
    return {
      'vehicleRegNo': vehicleRegNo,
      'tankCapity': tankCapity,
      'vehicleLoad': vehicleLoad,
      'isActive': isActive,
      'isDeleted': isDeleted,
    };
  }
}
