// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';

import '../../modules/expense_type_module.dart';
import '../../ui/reports/expenses_per_vehicle.dart';
import '../../ui/widgets/custom_chips.dart';
import '../../ui/widgets/custom_dropdown.dart';
import 'filter_buttons.dart';

class ExpensePerVehicleFilterWidget extends StatefulWidget {
  const ExpensePerVehicleFilterWidget({Key? key }) : super(key: key);


  @override
  State<ExpensePerVehicleFilterWidget> createState() => _ExpensePerVehicleFilterWidgetState();
}

class _ExpensePerVehicleFilterWidgetState extends State<ExpensePerVehicleFilterWidget> {
  final _controller = Get.find<ExpensesPerVehicleReportController>();

  
 final TruckModules _truckModule=TruckModules();
  final ExpenseTypeModule expenseTypeModule = ExpenseTypeModule();
  
  Map<String, dynamic> _trucks = {'None': 'None'};

  List<String> _expenseTypes = [];

  @override
  void initState() {
    super.initState();

    _truckModule.fetchTrucksReges().then((value) {
      setState(() {
        _trucks = value;
        if(_controller.selectedTruck.isEmpty){
          _controller.selectedTruck.value = _trucks.keys.first;
        }
      });
    });

    expenseTypeModule.fetchExpenseTypesAsString().then((value){
      setState(() {
        if(value.isNotEmpty){
          _expenseTypes = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(
          ()=> Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // vehicle dropdown
              CustomDropDown(
                label: "Reg No",
                value: _controller.selectedTruck.isEmpty ? null : _controller.selectedTruck.value,
                items: _trucks,
                onChanged: (value) {
                    if(value != null){
                    _controller.selectedTruck.value = value;
                    }
                  },
              ),
              const SizedBox(height: 10,),

              // expense type chips
              SizedBox(
                width: 350,
                child: CustomChips(
                  label: 'Expense type',
                  items: _expenseTypes,
                  initial: _controller.selectedExpenseTypes,
                  onChanged: (List<String> val) => _controller.selectedExpenseTypes.value = val,
                ),
              ),
              const SizedBox(height: 10,),

              // date range picker
              TextButton.icon(
                onPressed: () async {
                  var _res = await showDateRangePicker(
                    context: context, initialDateRange: _controller.dateRange.value,
                    firstDate: DateTime(2021, 10), lastDate: DateTime(2099),
                  );

                  if(_res != null){
                    _controller.dateRange.value = _res;
                  }

                }, 
                icon: const Icon(Icons.calendar_today), 
                label: Obx(()=> Text('From: ${_controller.dateRange.value.start.toString().substring(0, 10)} To: ${_controller.dateRange.value.end.toString().substring(0, 10)}'))
              ),

            const  SizedBox(height: 15,),

              FilterButton(
                onFilter: _controller.filter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}