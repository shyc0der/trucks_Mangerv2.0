// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

import '../../modules/user_modules.dart';
import '../../ui/reports/jobs_reports.dart';
import '../../ui/widgets/custom_chips.dart';
import '../../ui/widgets/custom_dropdown.dart';
import 'filter_buttons.dart';

class AllJobsFilterWidget extends StatefulWidget {
  const AllJobsFilterWidget({Key? key }) : super(key: key);


  @override
  State<AllJobsFilterWidget> createState() => _AllJobsFilterWidgetState();
}

class _AllJobsFilterWidgetState extends State<AllJobsFilterWidget> {
  final _controller = Get.find<AllJobsReportController>();

  
 final UserModule _userModule=UserModule();
  
 final Map<String, dynamic> _drivers = {'None': 'None'};

 final List<String> _jobTypes = ['Transport', 'Logistics'];

  @override
  void initState() {
    super.initState();

    _userModule.fetchUsersName().then((value) {
      setState(() {
        if(value.isNotEmpty){
          _drivers.clear();
        }
        for (String userId in value.keys){
          _drivers[userId] ='${value[userId]['firstName']} ${value[userId]['middleName']} ${value[userId]['lastName']}';
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
                label: "Driver",
                isNullable: true,
                value: _controller.driverId.value,
                items: _drivers,
                onChanged: (value) {
                    _controller.driverId.value = value;
                  },
              ),
              const SizedBox(height: 10,),

              // Job type chips
              SizedBox(
                width: 350,
                child: CustomChips(
                  label: 'Job type',
                  items: _jobTypes,
                  initial: _controller.selectedJobTypes,
                  onChanged: (List<String> val) => _controller.selectedJobTypes.value = val,
                ),
              ),

              // job state chips
              SizedBox(
                width: 350,
                child: CustomChips(
                  label: 'Job state',
                  items: OrderWidgateState.values.map((e) => e.value).toList(),
                  initial: _controller.selectedJobState,
                  onChanged: (List<String> val) => _controller.selectedJobState.value = val,
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