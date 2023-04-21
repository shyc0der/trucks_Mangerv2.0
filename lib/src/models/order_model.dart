import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

import 'model.dart';

class OrderModel extends Model{

OrderModel({
 this.userId,
    this.title, this.decription, this.amount, this.rate,this.noOfDays, this.customerId,this.vat,
    this.state, this.dateApproved, this.dateClosed, this.orderNo,
    OrderWidgateState? orderState, DateTime? dateCreated,

}):super('orders'){
   this.dateCreated = dateCreated ?? DateTime.now();
    state= orderState?.value  ?? 'Pending';

    // generate order no
   orderNo ??= (DateTime.now().millisecondsSinceEpoch/1000).floor().toRadixString(16);
}

  String? title;
  String? id;
  String? decription;
  double? amount;
  double? rate;
  double? noOfDays;
  String? orderNo;
  double? vat;
  String? customerId;
  // user info(how created the oder)
  String? userId;
  // state: pending, approved, declined, open, close; 
  String? state;
  late DateTime dateCreated;
  DateTime? dateApproved;
  DateTime? dateClosed;
OrderWidgateState get orderStates => orderWidgateState(state ?? '');
OrderModel.from(Map map):super('orders'){
    id = map['id'];
    userId = map['userId'];
    orderNo = map['orderNo'] ?? (DateTime.now().millisecondsSinceEpoch/1000).floor().toRadixString(16);
    title = map['title'];
    decription = map['decription'];
    amount = double.tryParse(map['amount'].toString());
    rate = double.tryParse(map['rate'].toString());
    noOfDays = double.tryParse(map['noOfDays'].toString());
    vat = double.tryParse(map['vat'].toString());
    customerId = map['customerId'];
    state = map['state'];
    dateCreated = DateTime.tryParse(map['dateCreated'].toString()) ?? DateTime.now();
    dateApproved = DateTime.tryParse(map['dateApproved'].toString());
    dateClosed = DateTime.tryParse(map['dateClosed'].toString() );
 

}
Map<String,dynamic> asMap(){
  return{
    'orderNo': orderNo,
    'userId': userId,
    'title': title,
    'decription': decription,
    'amount': amount,
    'rate': rate,
    'noOfDays':noOfDays,
    'vat':vat,
    'customerId': customerId,
    'state': state,
    'dateCreated': dateCreated.toIso8601String(),
    'dateApproved': dateApproved?.toIso8601String(),
    'dateClosed': dateClosed?.toIso8601String(),
  };
}

  // static Future<List<OrderModel>?> fromMap(Map<String, dynamic> map) {}

}