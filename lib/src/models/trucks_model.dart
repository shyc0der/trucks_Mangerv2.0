import 'package:flutter/material.dart';
import 'package:trucks_manager/src/models/model.dart';
import 'package:trucks_manager/src/modules/expenses_modules.dart';

import 'expenses_model.dart';

class TrucksModel extends Model {
  final ExpenseModule _expenseModule = ExpenseModule();
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

  Stream<List<ExpenseModel>> fetchExpenseByTruck(DateTimeRange dateTimeRange) {
    var expenses =
        _expenseModule.fetchExpenseByTruckAndDate(id!, dateTimeRange);
    return expenses;
  }

  Stream<double> getTotalExpense(DateTimeRange dateTimeRange) {
    var expenses = fetchExpenseByTruck(dateTimeRange).map((e) {
      return e.fold<double>(
          0.0,
          (previousValue, element) =>
              previousValue + (double.tryParse(element.totalAmount!) ?? 0.0));
   
    });
    //print(expenses);
    return expenses;
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
