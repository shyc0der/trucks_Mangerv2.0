import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trucks_manager/src/models/user_model.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/upload_image.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

import '../models/expenses_model.dart';
import '../models/response_model copy.dart';
import '../ui/widgets/user_widget.dart';

class ExpenseModule extends GetXState {
  final ExpenseModel _expensesModel = ExpenseModel();
  final JobModule _jobModule = JobModule();
  String folder = "receipts";
  
  void init(UserModel user) {
    // fetch jobs, drivers & truck
    fetchAllExpenses(user);
  }

  Stream<List<ExpenseModel>> fetchAllExpenses(UserModel user) {
    if (user.userRole == UserWidgetType.admin ||
        user.userRole == UserWidgetType.manager) {
      return _expensesModel
          .fetchStreamsData(orderBy: 'date')
          .map<List<ExpenseModel>>((snapshot) {
        return snapshot.docs
            .map<ExpenseModel>((doc) =>
                ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .toList();
      });
    } else {
      return _expensesModel
          .fetchStreamsDataWhere('userId', isEqualTo: user.id, orderBy: 'date')
          .map<List<ExpenseModel>>((snapshot) {
        return snapshot.docs
            .map<ExpenseModel>((doc) =>
                ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .toList();
      });
    }
  }

//fetch Expenses By User

//fetch Expenses
  Stream<List<ExpenseModel>> fetchExpenses() {
         return _expensesModel
          .fetchStreamsData(orderBy: 'date')
          .map<List<ExpenseModel>>((snapshot) {
        return snapshot.docs
            .map<ExpenseModel>((doc) =>
                ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .toList();
            
      });
    
  }
  //fetch Expenses By date
  
  
  Stream<List<ExpenseModel>> fetchByExpensesByState(
      String state, UserModel user) {
    if (user.userRole == UserWidgetType.admin ||
        user.userRole == UserWidgetType.manager) {
      return _expensesModel
          .fetchStreamsDataWhere("state", isEqualTo: state, orderBy: 'date')
          .map<List<ExpenseModel>>((snapshot) {
        return snapshot.docs
            .map<ExpenseModel>((doc) =>
                ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .toList();
      });
    } else {
      return _expensesModel
          .fetchStreamsDataWhere("state", isEqualTo: state, orderBy: 'date')
          .map<List<ExpenseModel>>((snapshot) {
        return snapshot.docs
            .map<ExpenseModel>((doc) =>
                ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .where((element) => element.userId == user.id)
            .toList();
      });
    }
  }
  //fetch expenses by truck
  Stream<List<ExpenseModel>> fetchExpenseByTruckAndDate(String truckId,DateTimeRange dateRange){
   return _expensesModel
        .fetchStreamsDataWhere(
      'date',
      orderBy: 'date',
      isGreaterThanOrEqualTo: dateRange.start.toIso8601String(),
      isLessThanOrEqualTo: dateRange.end.toIso8601String(),
    )
        .map<List<ExpenseModel>>((snapshot) {
      return snapshot.docs
          .map<ExpenseModel>((doc) =>
              ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map})).
              where((element) => element.truckId == truckId)
          .toList();
    });

  }
//fetch expenses truck and user
  Stream<List<ExpenseModel>> fetchByTruckExpenses(
      String truckId, UserModel user) {
    if (user.userRole == UserWidgetType.admin ||
        user.userRole == UserWidgetType.manager) {
      return _expensesModel
          .fetchStreamsDataWhere("truckId", isEqualTo: truckId, orderBy: 'date')
          .map<List<ExpenseModel>>((snapshot) {
        return snapshot.docs
            .map<ExpenseModel>((doc) =>
                ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .toList();
      });
    } else {
      return _expensesModel
          .fetchStreamsDataWhere("truckId", isEqualTo: truckId, orderBy: 'date')
          .map<List<ExpenseModel>>((snapshot) {
        return snapshot.docs
            .map<ExpenseModel>((doc) =>
                ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .where((element) => element.userId == user.id)
            .toList();
      });
    }
  }

  // fetch expense where
  Stream<List<ExpenseModel>> fetchAllWhereDateRangeExpenses(
      DateTimeRange dateRange) {
    return _expensesModel
        .fetchStreamsDataWhere(
      'date',
      orderBy: 'date',
      isGreaterThanOrEqualTo: dateRange.start.toIso8601String(),
      isLessThanOrEqualTo: dateRange.end.toIso8601String(),
    )
        .map<List<ExpenseModel>>((snapshot) {
      return snapshot.docs
          .map<ExpenseModel>((doc) =>
              ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
          .toList();
    });
  }
//fetch expenses by date and 
  // fetch expense by job
  Stream<List<ExpenseModel>> fetchByJobExpenses(String jobId, UserModel user) {
    if (user.userRole == UserWidgetType.admin ||
        user.userRole == UserWidgetType.manager) {
      var expenses = _expensesModel
          .fetchStreamsDataWhere('jobId', isEqualTo: jobId, orderBy: 'date')
          .map<List<ExpenseModel>>((snapshot) {
        return snapshot.docs
            .map<ExpenseModel>((doc) =>
                ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .toList();
      });
      return expenses;
    } else {
      var expenses = _expensesModel
          .fetchStreamsDataWhere('jobId', isEqualTo: jobId, orderBy: 'date')
          .map<List<ExpenseModel>>((snapshot) {
        return snapshot.docs
            .map<ExpenseModel>((doc) =>
                ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .where((element) => element.userId == user.id)
            .toList();
      });
      return expenses;
    }
  }
   Stream<List<ExpenseModel>> fetchByJobExpensesNoUser(String jobId) {
      var expenses = _expensesModel
          .fetchStreamsDataWhere('jobId', isEqualTo: jobId, orderBy: 'date')
          .map<List<ExpenseModel>>((snapshot) {
        return snapshot.docs
            .map<ExpenseModel>((doc) =>
                ExpenseModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .toList();
      });

      return expenses;
    
  }

  Future<List<ExpenseModel>> fetchAllExpensesByJob(String jobId) async {
    var expenses = (await _expensesModel.fetchWhereData('jobId',
            isEqualTo: jobId, orderBy: 'date'))
        .map<ExpenseModel>((snapshot) {
      return ExpenseModel.fromMap({'id': snapshot.id, ...snapshot.data()});
    }).toList();

    return expenses;
  }
  ///fetch expense by expenseType
 Future<List<ExpenseModel>> fetchAllExpensesByExpenseTypes(String expenseType) async {
    var expenses = (await _expensesModel.fetchWhereData('expenseType',
            isEqualTo: expenseType, orderBy: 'date'))
        .map<ExpenseModel>((snapshot) {
      return ExpenseModel.fromMap({'id': snapshot.id, ...snapshot.data()});
    }).toList();

    return expenses;
  }

//fetch expense by Order
  Future<List<ExpenseModel>> fetchByExenpseByOrder(String orderId) async {
    var job = await _jobModule.fetchJobsByOrderId(orderId);
    if (job == null) {
      return [];
    }
    var expense = await fetchAllExpensesByJob(job.id!);
    return expense;
  }

  // add
  Future<bool> addExpense(ExpenseModel expense, XFile? image) async {
    // save image to server then get image path
    String? imagePath;
    if (image != null) {
      imagePath = await uploadPics(image, folder);
      expense.receiptPath = imagePath;
    }

    await _expensesModel.saveOnline(expense.asMap());
    return true;
  }

//UPDATE EXPENSE
  Future<ResponseModel> updateExpense(String id, Map<String, dynamic> map,
      {XFile? image}) async {
    String? imagePath;
    if (image != null) {
      imagePath = await uploadPics(image, folder);
      map['receiptPath'] = imagePath;
    }

    await _expensesModel.updateOnline(id, map);
    return ResponseModel(ResponseType.success, 'Expense Updated');
  }

  Future<bool> updateExpenseState(
      String expenseId, OrderWidgateState expenseSate) async {
    await _expensesModel.updateOnline(expenseId, {
      'state': expenseSate.value,
      if (expenseSate == OrderWidgateState.Open ||
          expenseSate == OrderWidgateState.Rejected)
        'dateApproved': DateTime.now().toIso8601String(),
      if (expenseSate == OrderWidgateState.Rejected)
        'dateClosed': DateTime.now().toIso8601String(),
      'dateRejected': DateTime.now().toIso8601String(),
      if (expenseSate == OrderWidgateState.Closed)
        'dateClosed': DateTime.now().toIso8601String(),
    });
    return true;
  }
  Future<void> deleteExpenses(String id)async{

  await  _expensesModel.deleteOnline(id);
 }

   Future<List<ExpenseModel>?> fetchExpensesByUser(UserModel userModel)async{

    final _res = (await _expensesModel.fetchWhereData('userId', isEqualTo: userModel.id, orderBy: 'dateCreated')).
    map((documentSnapshot) {
      return ExpenseModel.fromMap({'id': documentSnapshot.id, ...documentSnapshot.data()});
    }).toList();
    return _res;
  }
}
