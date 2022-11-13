
// ignore_for_file: no_leading_underscores_for_local_identifiers, constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';

import '../../../models/trucks_model.dart';
import '../../widgets/input_fields.dart';

class AddTruckWidget extends StatefulWidget {
  const AddTruckWidget({ this.isEditing = false, this.truck, Key? key }) : super(key: key);
  final bool isEditing;
  final TrucksModel? truck;

  @override
  _AddTruckWidgetState createState() => _AddTruckWidgetState();
}

class _AddTruckWidgetState extends State<AddTruckWidget> {
  final TruckModules truckModule=TruckModules();
  late final TextEditingController _regNoController;
  late final TextEditingController _tankController;
  late final TextEditingController _loadController;

  bool _regNoError = false;
  bool _tankError = false;
  bool _loadError = false;
  bool isLoading = false;

  late VehicleCategory selectTruckCategory;

  @override
  void initState() {
    super.initState();
    _regNoController = TextEditingController();
    _tankController = TextEditingController();
    _loadController = TextEditingController();
    selectTruckCategory= VehicleCategory.Trucks;

    // populate truck fields
    if(widget.isEditing){
      _regNoController.text = widget.truck?.vehicleRegNo ?? '';
      _tankController.text = widget.truck?.tankCapity ?? '';
      _loadController.text = widget.truck?.vehicleLoad ?? '';
      selectTruckCategory = truckCategoryFromString(widget.truck?.category);
    }
  }

  @override
  void dispose() {
    _regNoController.dispose();
    _tankController.dispose();
    _loadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      centerTitle: true,
      title: Text(widget.isEditing ? 'Edit Truck' : 'Add Truck'),
    ),
      //color: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
       const     SizedBox(height: 10,),
            //category
            Row(children:[
          const    Padding(
              padding: EdgeInsets.all(8.0),
              child:SizedBox(width: 80,
              child:Text('Title')),),
              Expanded(child: Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(18),
                  border: Border.all(width: .8,color: Colors.grey)
                ),
                child: DropdownButtonFormField<VehicleCategory>(
                  value: selectTruckCategory,
                  onChanged: (VehicleCategory? val){
                    if(val !=null){
                      setState((){
                        selectTruckCategory=val;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border:  UnderlineInputBorder(borderSide: BorderSide.none)
                  ),
                  items: [
                    for(var _truck in VehicleCategory.values)
                    DropdownMenuItem(
                      value: _truck,
                      child: Text(_truck.value),),
                  ],)
                ,),)
              
              
              
            ]),
 
            // title
            InputField(
              'Registration Number', 
              _regNoController, 
              _regNoError,
              onChanged: (String val){
                if(val.isNotEmpty){
                  setState(() {
                    _regNoError = false;
                  });
                }
              }
            ),

            // description
            InputField(
              'Tank Capacity', _tankController, _tankError, isNumbers: true,
              onChanged: (String val){
                if(val.isNotEmpty){
                  setState(() {
                    _tankError = false;
                  });
                }
              }
            ),

            // Load capacity
          
            if(selectTruckCategory == VehicleCategory.Trucks)
            InputField(
              'Load Capacity', _loadController, _loadError, isNumbers: true,
              onChanged: (String val){
                if(val.isNotEmpty){
                  setState(() {
                    _loadError = false;
                  });
                }
              }
            ),

            // buttons
           const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // cancel
                TextButton(
                  onPressed: (){
                    // clear inputs
                    clearInputs();

                    // pop
                    Navigator.of(context).pop();
                  }, 
                  child: const Text('Cancel')
                ),

                ElevatedButton.icon(
                  onPressed: isLoading ? null : () async {
                    // validate inputs
                    bool errorExist = false;
                    if(_regNoController.text.isEmpty){
                      setState(() {
                        _regNoError = true;
                      });
                      errorExist = true;
                    }
                    if(_tankController.text.isEmpty){
                      setState(() {
                        _tankError = true;
                      });
                      errorExist = true;
                    }
                    if(_loadController.text.isEmpty && selectTruckCategory == VehicleCategory.Trucks){
                      setState(() {
                        _loadError = true;
                      });
                      errorExist = true;
                    }

                    // save job
                  if(!errorExist){
                     if(!widget.isEditing){
                        // save
                        await  truckModule.addTruck(TrucksModel(
                          tankCapity: _tankController.text,
                          vehicleRegNo: _regNoController.text,
                          vehicleLoad: _loadController.text,
                          category: selectTruckCategory.value,

                        ),);
                     }else{
                       // update truck
                        await  truckModule.updateTruck((widget.truck?.id ?? '') ,{
                          'tankCapity': _tankController.text,
                          'vehicleRegNo': _regNoController.text,
                          'vehicleload': _loadController.text,
                          'category': selectTruckCategory.value,
                          },);

                     }

                     
                      // clear inputs
                      

                      // pop
                      Navigator.of(context).pop();

                    }

                    
                  }, 
                  label: Text(widget.isEditing ? 'Update Truck' : 'Add Truck'),
                  icon: const Icon(Icons.add),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void clearInputs(){
    _regNoController.clear();
    _tankController.clear();
    _loadController.clear();
  }
}

enum VehicleCategory{
  Trucks, Saloon
}

extension VehicleCategoryValue on VehicleCategory{
  String get value{
    switch(this){
      case VehicleCategory.Saloon:
      return 'Saloon';
      default:
      return 'Trucks';
    }
  }
}

VehicleCategory truckCategoryFromString(String? category){
  switch (category) {
    case 'Saloon':
      return VehicleCategory.Saloon;
    default:
    return VehicleCategory.Trucks;
  }
}