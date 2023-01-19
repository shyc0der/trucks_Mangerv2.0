import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/expenses_model.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/ui/pages/trucks/add_truck_widget.dart';
import 'package:trucks_manager/src/ui/pages/trucks/truck_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/item_card_widget.dart';

import '../../../modules/expenses_modules.dart';
import '../../../modules/user_modules.dart';

class TrucksListPage extends StatelessWidget {
  TrucksListPage({Key? key}) : super(key: key);
  final TruckModules _truckModules = TruckModules();
  final ExpenseModule _expenseModule = Get.put(ExpenseModule());
   UserModule userModule=Get.find<UserModule>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
          backgroundColor: Colors.green,
          radius: 30,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddTruckWidget()));
            },
            icon: const Icon(Icons.add),
          )),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: FutureBuilder<List<TrucksModel?>>(
              future: _truckModules.fetchTrucks(),
              builder: (context, snapshot) {
                var trucks = snapshot.data ?? [];
                return Wrap(
                  children: [
                    for (var truck in trucks)
                      StreamBuilder<List<ExpenseModel>>(
                          stream: _expenseModule.fetchByTruckExpenses(truck!.id!,userModule.currentUser.value),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error = ${snapshot.error}');
                            }
                            if (snapshot.hasData) {
                              return ItemCardWidget(
                                label: truck.vehicleRegNo ?? '',
                                iconData: Icons.local_shipping_outlined,
                                count: snapshot.data!.length,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => TruckDetailsPage(truck)));
                                },
                              );
                            }
                            else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                          })
                  ],
                );
              }),
        ),
      ),
    );
  }
}
