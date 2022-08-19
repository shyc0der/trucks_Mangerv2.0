import 'package:trucks_manager/src/models/model.dart';

class TrucksModel extends Model {
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
