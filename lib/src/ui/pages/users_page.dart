import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/pages/users_list_page.dart';


class UsersPage extends StatelessWidget {
  UsersPage({Key? key}) : super(key: key);
 final bool isCustomer = false;

  @override
  Widget build(BuildContext context) {
    return UsersListPage(isCustomer);
    
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
