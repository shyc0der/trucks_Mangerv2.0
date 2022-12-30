import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/expenseType.dart';
import 'package:trucks_manager/src/models/user_model.dart';
import 'package:trucks_manager/src/modules/expense_type_module.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/pages/expenseType/expense_type_page.dart';

import '../widgets/item_card_widget.dart';
import 'users/users_page.dart';

class OthersPage extends StatefulWidget {
  const OthersPage({super.key});

  @override
  State<OthersPage> createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
  final UserModule _userModule = Get.put(UserModule());
  final ExpenseTypeModule _expenseTypeModule = Get.put(ExpenseTypeModule());
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          children: [
            // Users

            // Expense Types
            StreamBuilder<List<UserModel>>(
                stream: _userModule.fetchUsersWhere(false,false),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return ItemCardWidget(
                      label: 'Users',
                      iconData: Icons.work_outline,
                      count: snapshot.data!.length,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => UsersPage(false,false),));
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),

            // JobTitles
            StreamBuilder<List<ExpenseType>>(
                stream: _expenseTypeModule.fetchExpenseType(),                    
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error = ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return ItemCardWidget(
                      label: 'Expense Type',
                      iconData: Icons.account_balance_wallet_outlined,
                      count: snapshot.data!.length,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>  const ExpenseTypesPage()));
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),

            // trucks

            // // reports
            // const ItemCardWidget(
            //   label: 'Reports',
            //   iconData: Icons.pie_chart_outline_outlined,
            // ),
          ],
        ));
  }
}
