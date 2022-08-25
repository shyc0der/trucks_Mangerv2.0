import 'package:trucks_manager/src/models/model.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

class JobModel extends Model{

  JobModel({this.createdBy,this.customerId,this.vehicleId,this.orderNo,this.orderId,this.driverId,
  OrderWidgateState? jobState,this.state,this.dateClosed,DateTime? dateCreated,this.lpoNumber
  }):super("jobsCreated"){
  state= jobState?.value  ?? 'Open';
  this.dateCreated = dateCreated ?? DateTime.now();
}
  String? id;
  String? createdBy;
  String? customerId;
  String? driverId;
  String? vehicleId;
  String? orderNo;
  String? lpoNumber;
  String? orderId;
  String? state;
  DateTime dateCreated =DateTime.now();
  DateTime? dateClosed;
  OrderWidgateState get jobStates => orderWidgateState(state ?? '');
  JobModel.fromMap(Map map):super("jobsCreated"){
    id=map['id'];
    createdBy=map['createdBy'];
    customerId=map['customerId'];
    lpoNumber=map['lpoNumber'];
    vehicleId=map['vehicleId'];
    orderNo=map['orderNo'];
    orderId=map['orderId'];
    driverId=map['driverId'];
    state=map['state'];
    dateClosed= map['dateClosed'] != null ? DateTime.tryParse(map['dateClosed']) : null;
    dateCreated= map['dateCreated'] != null ? DateTime.tryParse(map['dateCreated']) ?? DateTime.now() : DateTime.now();

  }
  Map<String,dynamic> asMap(){
    return{
    //if(id != null) 'id' : id,
    'createdBy' :createdBy,
    'customerId' :customerId,
    'lpoNumber' :lpoNumber,
    'vehicleId' :vehicleId,
    'driverId' :driverId,
    'orderNo' :orderNo,
    'orderId' :orderId,
    'state' :state,
    'dateCreated': dateCreated.toIso8601String(),
    'dateClosed': dateClosed?.toIso8601String(),
  
  };}
  }
  