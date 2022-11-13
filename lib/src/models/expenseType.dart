// ignore_for_file: file_names

import 'package:trucks_manager/src/models/model.dart';

class ExpenseType extends Model{
  ExpenseType({
   this.id,this.name,
  }):super('expenseType');
  String? id;
  String? name;
  Map<String,dynamic> asMap()
{
  return {
    if(id != null) 'id': id,
    'name': name,
  };
}
//how to know methods or constructors that have a return type
ExpenseType.fromMap(Map map):super('expenseType'){
  
    id=map['id'];
    name=map['name'];
    
  
}
}
