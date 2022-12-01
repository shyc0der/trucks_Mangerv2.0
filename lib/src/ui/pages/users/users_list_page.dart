// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/pages/users/addCustomer.dart';
import 'package:trucks_manager/src/ui/pages/users/add_user_widget.dart';
import 'package:trucks_manager/src/ui/widgets/user_widget.dart';

import '../../../models/user_model.dart';

class UsersListPage extends StatelessWidget {
  UsersListPage(
    this.isCustomer,
    this.isDriver, {
    Key? key,
  }) : super(key: key);
  //final Stream<List<UserModel?>> users;
  final UserModule _userModule = UserModule();
  bool isCustomer = false;
  bool isDriver = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: StreamBuilder<List<UserModel?>>(
            stream: _userModule.fetchUsersWhere(isCustomer,isDriver),
            builder: (context, snapshot) {
              var user = snapshot.data ?? [];
              user.sort(
                (a, b) => a!.userRole.myCompare(b!.userRole),
              );
              return Wrap(
                children: [
                  for (var us in user)
                    GestureDetector(
                      onDoubleTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: ((context) => 
                        isCustomer== true ? AddCustomer(customer: us,isEditing: true,) :
                        AddUserWidget( user: us, isEditing: true))));
                      },
                      child: UserWidget(
                        userType: us!.userRole,
                        name: us.firstName,
                        lname: us.lastName,
                        email: us.email,
                        phoneNo: us.phoneNo,
                        onLongPress: us.onLongPress,
                        onTap: us.onTap,
                      ),
                    )
                ],
              );
            }),
      ),
    );
  }
}
