// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';

import '../../ui/reports/jobs_per_vehicle_report.dart';
import '../../ui/widgets/custom_chips.dart';
import '../../ui/widgets/custom_dropdown.dart';
import 'filter_buttons.dart';

class JobsPerVehicleFilterWidget extends StatefulWidget {
  const JobsPerVehicleFilterWidget({Key? key }) : super(key: key);


  @override
  State<JobsPerVehicleFilterWidget> createState() => _JobsPerVehicleFilterWidgetState();
}

class _JobsPerVehicleFilterWidgetState extends State<JobsPerVehicleFilterWidget> {
  final _controller = Get.find<JobsPerVehicleReportController>();

  
 final TruckModules _truckModule=TruckModules();
  
  Map<String, dynamic> _trucks = {'None': 'None'};

final  List<String> _jobTypes = ['Transport', 'Logistics'];

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

              // job type chips
              SizedBox(
                width: 350,
                child: CustomChips(
                  label: 'Job type',
                  items: _jobTypes,
                  initial: _controller.selectedJobTypes,
                  onChanged: (List<String> val) => _controller.selectedJobTypes.value = val,
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