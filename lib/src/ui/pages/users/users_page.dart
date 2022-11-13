import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/pages/users/add_user_widget.dart';
import 'package:trucks_manager/src/ui/pages/users/users_list_page.dart';

import '../../widgets/user_widget.dart';


// ignore: must_be_immutable
class UsersPage extends StatelessWidget {
 UsersPage({Key? key}) : super(key: key);
 final bool isCustomer = false;
UserModule userModule=Get.find<UserModule>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
          backgroundColor: Colors.green,
          radius: 30,
          child: IconButton(onPressed: () {
            
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=> const AddUserWidget()));
          },
          icon: const Icon(Icons.add),
          )),
       
      body:  
      (userModule.currentUser.value.userRole == UserWidgetType.admin || userModule.currentUser.value.userRole == UserWidgetType.manager)
      ? UsersListPage(isCustomer) : Container());

      
    
  }

  //Stream<List<UserModel>> get _users => _userModule!.fetchUsersWhere(isCustomer);
  //  List.generate(10, (index) {
  //       // List<UserWidgetType> types = [
  //       //   UserWidgetType.admin,
  //       //   UserWidgetType.manager,
  //       //   UserWidgetType.manager,
  //       //   UserWidgetType.manager,
  //       //   UserWidgetType.manager,
  //       //   UserWidgetType.driver,
  //       //   UserWidgetType.driver,
  //       //   UserWidgetType.driver,
  //       //   UserWidgetType.driver,
  //       //   UserWidgetType.driver,
  //       //   UserWidgetType.driver,
  //       //   UserWidgetType.driver,
  //       //   UserWidgetType.driver,
  //       //   UserWidgetType.driver,
  //       // ];

  //       // types.shuffle();

  //       // return UserModel(
  //       //     role: index == 0 ? UserWidgetType.admin : types.first,
  //       //     firstName: 'Name Name$index',
  //       //     lastName: 'Name Name$index',
  //       //     email: 'email@mail.email',
  //       //     phoneNo: '+254797162465',
  //       //     isActive: true,
  //       //     isDeleted: false);
  //     });
}
