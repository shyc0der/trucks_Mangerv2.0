import 'model.dart';

class ExpenseModel extends Model{

ExpenseModel({
  this.id,this.jobId,this.truckId, this.totalAmount,this.description, this.userId,this.expenseType, 
this.dateApproved, this.dateClosed, this.dateRejected,DateTime? dateCreated,
this.state = 'Pending',
DateTime? date
}):super('expenses'){
  this.date = date ?? DateTime.now();
}

  String? id;
  String? userId;
  String? truckId;
  String? jobId;
  String? totalAmount;
  String? description;
  String? expenseType;
  String? receiptPath;
  String state = OrderState.Pending.value;
  DateTime date = DateTime.now();
  DateTime? dateApproved;
  DateTime? dateClosed;
  DateTime? dateRejected;
}