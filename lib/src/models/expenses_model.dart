import '../ui/widgets/order_details_widget.dart';
import 'model.dart';

class ExpenseModel extends Model {
  ExpenseModel(
      {this.id,
      this.jobId,
      this.truckId,
      this.totalAmount,
      this.description,
      this.userId,
      this.expenseType,
      this.dateApproved,
      this.dateClosed,
      this.dateRejected,
      DateTime? dateCreated,
      OrderWidgateState? expenseState,
      this.state ,
      DateTime? date})
      : super('expenses') {
    state = expenseState?.value ?? 'Pending';
    this.date = date ?? DateTime.now();
  }

  OrderWidgateState get expensesState => orderWidgateState(state ?? 'Pending');

  String? id;
  String? userId;
  String? truckId;
  String? jobId;
  String? totalAmount;
  String? description;
  String? expenseType;
  String? receiptPath;
  String? state;
  DateTime date = DateTime.now();
  DateTime? dateApproved;
  DateTime? dateClosed;
  DateTime? dateRejected;

  Map<String, dynamic> asMap() {
    return {
      if (id != null) '_id': id,
      'userId': userId,
      'truckId': truckId,
      'jobId': jobId,
      'totalAmount': totalAmount,
      'description': description,
      'expenseType': expenseType,
      'state': state,
      'receiptPath': receiptPath,
      'date': date.toIso8601String(),
      'dateApproved': dateApproved?.toIso8601String(),
      'dateClosed': dateClosed?.toIso8601String(),
      'dateRejected': dateRejected?.toIso8601String(),
    };
  }

  ExpenseModel.fromMap(Map map) : super('expenses') {
    id = map['id'];
    userId = map['userId'];
    truckId = map['truckId'];
    jobId = map['jobId'];
    totalAmount = map['totalAmount'];
    description = map['description'];
    expenseType = map['expenseType'];
    state = map['state'] ?? 'Pending';
    receiptPath = map['receiptPath'];

    if (map['date'] != null) {
      date = DateTime.tryParse(map['date']) ?? DateTime.now();
    }

    if (map['dateApproved'] != null) {
      dateApproved = DateTime.tryParse(map['dateApproved']) ?? DateTime.now();
    }
    if (map['dateClosed'] != null) {
      dateClosed = DateTime.tryParse(map['dateClosed']) ?? DateTime.now();
    }
    if (map['dateRejected'] != null) {
      dateClosed = DateTime.tryParse(map['dateRejected']) ?? DateTime.now();
    }
  }
}
