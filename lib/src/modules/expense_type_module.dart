import 'package:trucks_manager/src/models/expenseType.dart';
import 'package:trucks_manager/src/modules/expenses_modules.dart';

class ExpenseTypeModule {
  final ExpenseType _expenseType = ExpenseType();
  final ExpenseModule _expenseModule = ExpenseModule();
  Future<bool> addExpenseType(ExpenseType expenseType) async {
    await _expenseType.saveOnline(expenseType.asMap());
    return true;
  }

  Stream<List<ExpenseType>> fetchExpenseType() {
    return _expenseType.fetchStreamsData().map((snapshots) {
      return snapshots.docs
          .map<ExpenseType>((doc) =>
              ExpenseType.fromMap({'id': doc.id, ...doc.data() as Map}))
          .toList();
    });
  }

  Future<List<String>> fetchExpenseTypesAsString() async {
    return (await _expenseType.fetchData())
        .map((snapshot) => snapshot.data()['name'].toString())
        .toList();
  }

  Future<void> deleteExpenseTpe(String id) async {
    await _expenseType.deleteOnline(id);
  }

  Future<bool> checkIfExpenseTypeExists(String name) async {
    bool test;
    var expensesType =
        await _expenseModule.fetchAllExpensesByExpenseTypes(name);
   
    if (expensesType == [] || expensesType.isEmpty) {
      
      test = false;
    } else {
        
      test = true;
    }

    return test;
  }
}
