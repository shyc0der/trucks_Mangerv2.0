// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

import '../../modules/expense_type_module.dart';
import '../../ui/reports/expenses_reports.dart';
import '../../ui/widgets/custom_chips.dart';
import 'filter_buttons.dart';

class AllExpensesFilterWidget extends StatefulWidget {
  const AllExpensesFilterWidget({Key? key }) : super(key: key);


  @override
  State<AllExpensesFilterWidget> createState() => _AllExpensesFilterWidgetState();
}

class _AllExpensesFilterWidgetState extends State<AllExpensesFilterWidget> {
  final _controller = Get.find<ExpensesReportController>();

  final ExpenseTypeModule expenseTypeModule = ExpenseTypeModule();
  

  List<String> _expenseTypes = [];

  @override
  void initState() {
    super.initState();

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
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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

              const SizedBox(height: 10,),
             
              // order state chips
              SizedBox(
                width: 350,
                child: CustomChips(
                  label: 'Order state',
                  items: OrderWidgateState.values.map((e) => e.value).toList(),
                  initial: _controller.selectedState,
                  onChanged: (List<String> val) => _controller.selectedState.value = val,
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
              

             const SizedBox(height: 15,),

              FilterButton(
                onFilter: _controller.filter,
              ),
            ],
          ),
      ),
    );
  }
}