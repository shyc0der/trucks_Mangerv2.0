// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/modules/expenses_modules.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/pages/users/addCustomer.dart';
import 'package:trucks_manager/src/ui/pages/users/add_user_widget.dart';
import 'package:trucks_manager/src/ui/widgets/user_widget.dart';

import '../../../models/user_model.dart';
import '../../widgets/dismiss_widget.dart';

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
  Future<bool> _dismissDialog(UserModel userModel) async {
    UserModule userModule = UserModule();
    ExpenseModule expenseModule = ExpenseModule();
    JobModule jobModule = JobModule();
    OrderModules orderModules = OrderModules();
    OrderModel orderModel = OrderModel();
    String? userId;
    String? expenseId;
    String? jobId;

    bool? _delete =
        await dismissWidget('${userModel.firstName}, ${userModel.lastName}');

    if (_delete == true) {
      // delete from server
      //fetch expenses by user
      var userExpenses = await expenseModule.fetchExpensesByUser(userModel);
      var userJobs = await jobModule.fetchJobsByUser(userModel);
      var userOrders = await orderModules.fetchOrdersByUser(userModel);

      if (userExpenses!.isNotEmpty == false) {
        // throw error
      } else {
        userExpenses.forEach((element) async {
          expenseId = element.id;
          var _res = await expenseModule.deleteExpenses(expenseId!);
        });
      }
      //delete Jobs
      if (userJobs!.isNotEmpty == false) {
      } else {
        userJobs.forEach((element) async {
          await jobModule.deleteJob(element.id!, element.orderId);
        });
      }
      //delete Orders
    if (userOrders!.isNotEmpty == false) {
      } else {
        userOrders.forEach((element) async {
          var jobsByOrder= await jobModule.fetchJobsByOrderId(element.id ?? '');
      if(jobsByOrder?.id != null){
       await jobModule.deleteJob(jobsByOrder!.id!, orderModel.id);
     }else{
        await orderModel.deleteOnline(element.id ?? 'null');
     }
      });
      }
  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("User Deleted!"),
  //     ));
    }
    return _delete == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: StreamBuilder<List<UserModel?>>(
              stream: _userModule.fetchUsersWhere(isCustomer, isDriver),
              builder: (context, snapshot) {
                var user = snapshot.data ?? [];
                user.sort(
                  (a, b) => a!.userRole.myCompare(b!.userRole),
                );
                return Wrap(
                  children: [
                    for (var us in user)
                      GestureDetector(
                        onDoubleTap: () async {
                          await _dismissDialog(us!);
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => isCustomer == true
                                      ? AddCustomer(
                                          customer: us,
                                          isEditing: true,
                                        )
                                      : AddUserWidget(
                                          user: us, isEditing: true))));
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
      ),
    );
  }
}
