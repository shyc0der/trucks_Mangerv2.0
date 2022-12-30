import 'package:trucks_manager/src/models/expenseType.dart';

class ExpenseTypeModule{
 final ExpenseType _expenseType= ExpenseType();

  Future<bool> addExpenseType(ExpenseType expenseType) async{
    await  _expenseType.saveOnline(expenseType.asMap());
    return true;
  }
 Stream<List<ExpenseType>> fetchExpenseType(){
   return _expenseType.fetchStreamsData().map((snapshots) {
    return snapshots.docs.map<ExpenseType>((doc) =>
    ExpenseType.fromMap({'id': doc.id,...doc.data() as Map})
    ).toList();
    
  });
 }

 Future<List<String>> fetchExpenseTypesAsString()async{
   return (await _expenseType.fetchData()).map((snapshot) => snapshot.data()['name'].toString()).toList();
 }

 Future<void> deleteExpenseTpe(String id)async{
  await  _expenseType.deleteOnline(id);
 }
}