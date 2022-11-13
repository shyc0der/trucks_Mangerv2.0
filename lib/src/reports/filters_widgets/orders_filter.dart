// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';
import '../../ui/reports/orders_reports.dart';
import '../../ui/widgets/custom_chips.dart';
import '../../ui/widgets/custom_dropdown.dart';
import 'filter_buttons.dart';

class AllOrdersFilterWidget extends StatefulWidget {
  const AllOrdersFilterWidget({Key? key }) : super(key: key);


  @override
  State<AllOrdersFilterWidget> createState() => _AllOrdersFilterWidgetState();
}

class _AllOrdersFilterWidgetState extends State<AllOrdersFilterWidget> {
  final _controller = Get.put(OrderReportController());
  
  final UserModule _customerModule=UserModule();
  
  Map<String, dynamic> _customers = {'None': 'None'};


  @override
  void initState() {
    super.initState();


  _customerModule.fetchCustomersEmail(true).then((value) {
      setState(() {
        _customers = value;
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
              // Customer dropdown
              CustomDropDown(
                label: "Customer",
                isNullable: true,
                value: _controller.customerId.value,
                items: _customers,
                onChanged: (value) {
                    _controller.customerId.value = value;
                    
                  },
              ),
              const SizedBox(height: 10,),
             
              // order state chips
              SizedBox(
                width: 350,
                child: CustomChips(
                  label: 'Order state',
                  items: OrderWidgateState.values.map((e) => e.value).toList(),
                  initial: _controller.selectedOrderState,
                  onChanged: (List<String> val) => _controller.selectedOrderState.value = val,
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
      ),
    );
  }
}