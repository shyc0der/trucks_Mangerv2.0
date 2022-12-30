import 'package:trucks_manager/src/models/expenseType.dart';
import 'package:trucks_manager/src/modules/expense_type_module.dart';
import 'package:flutter/material.dart';

import '../../widgets/dismiss_widget.dart';
import '../../widgets/input_fields.dart';

class ExpenseTypesPage extends StatefulWidget {
  const ExpenseTypesPage({ Key? key }) : super(key: key);

  @override
  _ExpenseTypesPageState createState() => _ExpenseTypesPageState();
}
//Displays Expenses
class _ExpenseTypesPageState extends State<ExpenseTypesPage> {
final  ExpenseTypeModule _expenseModule= ExpenseTypeModule();

  Future<bool> _dismissDialog(ExpenseType expense)async{

    bool? _delete = await dismissWidget('${expense.name}');
    bool _shouldDelete = _delete == true;

    if(_shouldDelete){
      // delete from server
      _expenseModule.deleteExpenseTpe(expense.id ?? '');
    }


    return _shouldDelete;

  }

  @override
  Widget build(BuildContext context) {
    return 
       Scaffold(
        floatingActionButton: CircleAvatar(
          child: IconButton(
            onPressed: (){
              showDialog(
                context: context, 
                builder: (BuildContext context){
                  return const Dialog(
                    child: AddExpenseTypeWidget(),
                  );
                }
              );
            }, 
            icon: const Icon(Icons.add)
          ),
        ),
        body: StreamBuilder<List<ExpenseType?>>(
          stream: _expenseModule.fetchExpenseType(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: (snapshot.data ?? []).length,
              itemBuilder: (BuildContext context, int index){
                var _expenseType=snapshot.data![index]!;
                return Dismissible(
                  confirmDismiss: (val)async{

                    // dismissDialog
                    return await _dismissDialog(_expenseType);
                  },
                  key: ValueKey('$index-${_expenseType.name}'),
                  child: Card(
                    child: ListTile(
                      title: Text(_expenseType.name ?? ''),
                    ),
                  ),
                );
              },
            );
          }
        ),
      
    );
  }
}
//ADD EXPENSES
class AddExpenseTypeWidget extends StatefulWidget {
  const AddExpenseTypeWidget({ Key? key }) : super(key: key);

  @override
  _AddExpenseTypeWidgetState createState() => _AddExpenseTypeWidgetState();
}

class _AddExpenseTypeWidgetState extends State<AddExpenseTypeWidget> {
  ExpenseTypeModule expenseModule=ExpenseTypeModule();
  late final TextEditingController _addExpenseTypeController;
  bool _addExpenseError = false;


  @override
  void initState() {
    super.initState();
    _addExpenseTypeController = TextEditingController();
  }

  @override
  void dispose() {
    _addExpenseTypeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        const  Text('Add Expense Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
         const SizedBox(height: 15,),
          InputField(
            "Expense Type", 
            _addExpenseTypeController, 
            _addExpenseError,
            onChanged: (String val){
              if(val.isNotEmpty){
                setState(() {
                  _addExpenseError = false;
                });
              }
            }
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // cancel
              TextButton(
                onPressed: ()=> Navigator.pop(context), 
                child: const Text('cancel')
              ),
              ElevatedButton(
                onPressed: (){
                  // check if input is empty
                  if(_addExpenseTypeController.text.isEmpty){
                    setState(() {
                      _addExpenseError = true;
                    });
                  }else{
                    // proceed saving
                    expenseModule.addExpenseType(
                      ExpenseType(
                        name: _addExpenseTypeController.text
                      )
                    );
                    Navigator.of(context).pop();

                  }
                }, 
                child: const Text('Add')
              )
            ],
          )
        ],
      ),
    );
  }
}