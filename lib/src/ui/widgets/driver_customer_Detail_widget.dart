//Driver LPO Vehicle
// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/ui/widgets/custom_dropdown.dart';

import '../../modules/user_modules.dart';
import 'input_fields.dart';

class DriverVehicleGetDetails extends StatefulWidget {
  const DriverVehicleGetDetails({Key? key}) : super(key: key);

  @override
  _DriverVehicleGetDetailsState createState() =>
      _DriverVehicleGetDetailsState();
}

class _DriverVehicleGetDetailsState extends State<DriverVehicleGetDetails> {
  final UserModule _userModule = UserModule();
  final TruckModules _truckModule = TruckModules();
  final Map<String, dynamic> _driver = {'None': 'None'};
  Map<String, dynamic> _trucks = {'None': 'None'};
  String? _userName;
  String? _truck;
  TextEditingController lpoController = TextEditingController();
  bool lpoError = false;
  bool hasDriver = false;
  @override
  void initState() {
  //print(hasDriver);

    _userModule.fetchUsersName().then((value) {
      setState(() {
        if (value.isNotEmpty) {
          _driver.clear();
        }
        for (String userId in value.keys) {
          _driver[userId] =
              '${value[userId]['firstName']} ${value[userId]['lastName']}';
        }
        _userName = _driver.keys.first;
      });
    });
    _truckModule.fetchTrucksReges().then((value) {
      setState(() {
        _trucks = value;
        _truck = _trucks.keys.first;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 // print(hasDriver);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // get driver id
          const SizedBox(
            height: 10,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
                children: [   
                const  Text("ORDER HAS A DRIVER"), 

              Switch(
                          value: hasDriver,
                          onChanged: ((value) => setState(() => hasDriver = value)),
                          activeColor: Colors.green,
                          activeTrackColor: Colors.greenAccent,
                          inactiveTrackColor: Colors.blueGrey.shade600,
                          inactiveThumbColor: Colors.grey.shade400,
                          splashRadius: 50.0,
                        ),
                ],
              ),
          

         if(hasDriver == true)
          CustomDropDown(
            label: 'Driver',
            value: _userName,
            items: _driver,
            onChanged: (value) {
              if (value != null) {
                _userName = value;
              }
            },
          ),

          const SizedBox(
            height: 10,
          ),
      if(hasDriver == true)
          // get vehicle reg
          CustomDropDown(
            label: "Reg No",
            value: _truck,
            items: _trucks,
            onChanged: (value) {
              if (value != null) {
                _truck = value;
              }
            },
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
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // get driver id & reg no & lpo
                  
                  Navigator.of(context)
                      .pop([ hasDriver ? _userName! : "c9AP9R06ugY54uHMmhscoTarpix2" , hasDriver ? _truck! : "EVwLiKI3Bazd6vLakBWt" , lpoController.text]);
                },
                child: const Text('submit'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
