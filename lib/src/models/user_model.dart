import 'package:trucks_manager/src/models/model.dart';

import '../ui/widgets/user_widget.dart';

class UserModel extends Model {
  UserModel(
      {this.firstName,
      this.lastName,
      this.phoneNo,
      this.idNumber,
      this.email,
      UserWidgetType ? userRole,
      this.onLongPress,
       bool? isActive ,
       bool?  isDeleted ,
      this.onTap})
      : super('users'){
        this.isActive=isActive ?? true;
        this.isDeleted=isDeleted ?? false;   
        role = userRole?.lable ?? 'normal';    
        }

  UserWidgetType get userRole => userRoleFromString(role ?? ''); 

  String? firstName;
  String? lastName;
  String? email;
  String? phoneNo;
  String? idNumber;
  String? role;
  void Function()? onTap;
  void Function()? onLongPress;

  bool isActive = true;
  bool isDeleted = false;

  UserModel.fromMap(Map map) : super('users') {
    firstName = map['firstName'];
    lastName = map['lastName'];
    email = map['email'];
    phoneNo = map['phoneNo'];
    idNumber = map['idNumber'];
    role = map['role'];
    isActive = map['isActive'] ?? true;
    isDeleted = map['isDeleted'] ?? false;
    onTap = map['onTap'];
    onLongPress = map['onLongPress'];
  }

  Map<String, dynamic> asMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNo': phoneNo,
      'email': email,
      'role': role,
      'isActive': isActive,
      'isDeleted': isDeleted
    };
  }
}
