
// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:get/get.dart';
import 'package:trucks_manager/src/models/jobs_model.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:flutter/material.dart';

import '../../../models/response_model copy.dart';
import '../../../modules/user_modules.dart';
import '../../widgets/input_fields.dart';

class AddJobWidget extends StatefulWidget {
  const AddJobWidget({this.jobs, this.isEditing = true, Key? key})
      : super(key: key);
  final bool isEditing;
  final JobModel? jobs;

  @override
  _AddJobWidgetState createState() => _AddJobWidgetState();
}

class _AddJobWidgetState extends State<AddJobWidget> {
 final UserModule _userModule = UserModule();
  final OrderModules orderModule = OrderModules();
  final JobModule _jobModule = JobModule();
  final TruckModules _truckModule = TruckModules();
  Map<String, dynamic> _driver = {'None': 'None'};
  Map<String, dynamic> _trucks = {'None': 'None'};

  String? _userName;
  String? _truck;
  String _initialTruck = 'None';
  String _initialUser = 'None';
  String? _customerid;

  TextEditingController lpoController = TextEditingController();
  bool lpoError = false;
  bool isLoading = false;

  @override
  void initState() {
    //fetch drivers
    if (_driver.isNotEmpty) {
      _userName = _driver.keys.first;
      _initialUser = _driver.keys.first;
    }
    _userModule.fetchUsersName().then((value) {
      setState(() {
        _driver = value;
        if (value.isNotEmpty) {
          _initialUser = widget.jobs?.driverId ?? '';
        }
        for (String userId in value.keys) {
          _driver[userId] =
              '${value[userId]['firstName']} ${value[userId]['middleName']} ${value[userId]['lastName']}';
        }
        _userName = _driver.keys.first;
      });
    });

//fetch vehicles
    if (_trucks.isNotEmpty) {
      _truck = _trucks.keys.first;
      _initialTruck = _trucks.keys.first;
    }

    _truckModule.fetchTrucksReges().then((value) {
      setState(() {
        _trucks = value;
        if (widget.isEditing) {
          _initialTruck = widget.jobs?.vehicleId ?? '';
        } else {
          _initialTruck = _trucks.keys.first;
        }
      });
    });

    if (widget.isEditing) {
      

      lpoController.text = widget.jobs?.lpoNumber ?? '';
      setState(() {
        _truck = widget.jobs?.vehicleId ?? 'None';
        _userName = widget.jobs?.driverId ?? 'None';
      });
    }

    super.initState();
  }

  void updateJob() async {
    setState(() {
      isLoading = true;
    });
    var res = await _jobModule.updateJob((widget.jobs?.id ?? ''), {
      'vehicleId': _truck,
      'createdBy': _userModule.currentUser.value.id,
      'customerId': _customerid,
      'lpoNumber': lpoController.text,
      'driverId': _userName,
    });
    
    await orderModule
        .updateOrder(widget.jobs?.orderId ?? '', {'userId': _userName});
   
    setState(() {
      isLoading = false;
    });
    if (res.status == ResponseType.success) {
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
        content: Text("Job Updated!"),
      ));
      // back
      Navigator.pop(context);
    } else {
      Get.showSnackbar(GetSnackBar(
        title: 'Error',
        message: res.body.toString(),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // color: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.isEditing ? 'Edit Job' : 'Add Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            // vehicle
            Row(
              children: [
                // label
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(width: 80, child: Text('Registration No:')),
                ),
                // items
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(width: .8, color: Colors.grey)),
                    child: DropdownButtonFormField<String>(
                        value: _initialTruck,
                        onChanged: (String? val) {
                          if (val != null) {
                            _truck = val;
                          }
                        },
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none)),
                        items: [
                          for (var truckId in _trucks.keys)
                            DropdownMenuItem(
                              value: truckId,
                              child: Text(_trucks[truckId].toString()),
                            ),
                        ]),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),
            //DRIVER
            Row(
              children: [
                // label
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(width: 80, child:  Text('Driver :')),
                ),
                // items
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(width: .8, color: Colors.grey)),
                    child: DropdownButtonFormField<String>(
                        value: _initialUser,
                        onChanged: (String? val) {
                          if (val != null) {
                            _userName = val;
                          }
                        },
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none)),
                        items: [
                          for (var truckId in _driver.keys)
                            DropdownMenuItem(
                              value: truckId,
                              child: Text(_driver[truckId].toString()),
                            ),
                        ]),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            InputField(
              "LPO No",
              lpoController,
              lpoError,
              onChanged: (val) {
                if (val.isNotEmpty) {
                  setState(() {
                    lpoError = false;
                  });
                }
              },
            ), // buttons
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // cancel
                TextButton(
                    onPressed: () {
                      // clear inputs
                      clearInputs();

                      // pop
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),

                ElevatedButton.icon(
                  onPressed: () {
                    // validate inputs
                    bool errorExist = false;

                    if (lpoController.text.isEmpty) {
                      setState(() {
                        lpoError = true;
                      });
                      errorExist = true;
                    }

                    // save job
                    if (!errorExist) {
                      // save
                      updateJob();
                    }
                  },
                  label: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Update Job Details'),
                  icon: const Icon(Icons.add),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void clearInputs() {
    lpoController.clear();
  }
}