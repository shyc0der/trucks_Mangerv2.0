import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/pages/users/addCustomer.dart';
import 'package:trucks_manager/src/ui/pages/users/users_list_page.dart';
class CustomersPage extends StatelessWidget {
 const CustomersPage({Key? key}) : super(key: key);
 final bool isCustomer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
          backgroundColor: Colors.green,
          radius: 30,
          child: IconButton(onPressed: () {
            
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=> const AddCustomer()));
          },
          icon: const Icon(Icons.add),
          )),
       appBar: AppBar(
        centerTitle: true,
        title: const Text('Customers'),
      ),
      body: UsersListPage(isCustomer),
    );
  }

//fetch users
  // //;
  // Stream<List<UserModel>> get _users =>
  //     _userModule.fetchUsersWhere(isCustomer);

  //  List.generate(20, (index) => UserModel(
  //   role: UserWidgetType.customer,
  //   firstName: 'Name Name$index',
  //   lastName: 'Name Name$index',
  //   email: 'email@mail.email',
  //   phoneNo: '+254797162465', isActive: true, isDeleted: false,

  // ));
}
