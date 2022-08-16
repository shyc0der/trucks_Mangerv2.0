import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({this.userType, this.name, this.lname,this.email, this.phoneNo, this.onTap, this.onLongPress, Key? key}) : super(key: key);
  final void Function()? onTap;
  final void Function()? onLongPress;
  final UserWidgetType ? userType;
  final String? name;
  final String? lname;
  final String? email;
  final String? phoneNo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onLongPress,
      child: 
      Container(
        width: 160,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), 
            )
          ]          
        ),
        
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // avator
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                shape: BoxShape.circle,
                border: Border.all(color: userType!.color, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: userType!.color.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3), 
                  )
                ]
              ),
              child: const Icon(Icons.person_outline, size: 35,),
            ),

            // role
            Container(
              width: 65,
              decoration: BoxDecoration(
                color: userType!.color,
                borderRadius: BorderRadius.circular(8)
              ),
              padding: const EdgeInsets.symmetric(vertical: 3),
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Text(userType!.lable, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),),
              ),
            ),

            // name
            if(name != null)
            Text(name!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),

            // email
            if(email != null)
            Text(email!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),),

            // phone number
            if(phoneNo != null)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(phoneNo!, style: Theme.of(context).textTheme.bodyMedium,),
            ),
          ],
        ),
      )
    );
  }
}

enum UserWidgetType{
  admin, manager, driver, customer,normal
}
UserWidgetType userRoleFromString(String val){
  switch (val) {
    case 'admin':
      return UserWidgetType.admin;
    case 'manager':
      return UserWidgetType.manager;
    case 'driver':
      return UserWidgetType.driver;
      case 'customer':
      return UserWidgetType.customer;
    default:
    return UserWidgetType.normal;
  }
}


extension UserWidgetTypeExt on UserWidgetType{
  String get lable {
    switch (this) {
      case UserWidgetType.admin:
        return 'Admin';
      case UserWidgetType.manager:
        return 'manager';
      case UserWidgetType.driver:
        return 'driver';
      case UserWidgetType.customer:
        return 'customer';
      default:
        return 'normal';
    }
  }


  Color get color {
    switch (this) {
      case UserWidgetType.admin:
        return Colors.redAccent;
      case UserWidgetType.manager:
        return Colors.purpleAccent;
      case UserWidgetType.driver:
        return Colors.lightBlue;
      case UserWidgetType.customer:
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
  int myCompare(UserWidgetType other){
    switch (this) {
      case UserWidgetType.admin:
        if(other == UserWidgetType.admin){
          return 0;
        }else{
          return -1;
        }
      case UserWidgetType.manager:
        if(other == UserWidgetType.manager){
          return 0;
        }else if (other == UserWidgetType.admin){
          return 1;
        }else{
          return -1;
        }
      case UserWidgetType.driver:
        if(other == UserWidgetType.driver){
          return 0;
        }else if (other == UserWidgetType.admin || other == UserWidgetType.manager){
          return 1;
        }else{
          return -1;
        }
      case UserWidgetType.customer:
        if(other == UserWidgetType.customer){
          return 0;
        }else{
          return 1;
        }
      default:
        return 1;
    }
  }
}