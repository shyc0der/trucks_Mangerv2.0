// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/user_model.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/widgets/user_widget.dart';

import '../../../models/response_model copy.dart';
import '../../widgets/input_fields.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({this.customer,this.isEditing=false,Key? key}) : super(key: key);
  final UserModel? customer;
  final bool isEditing;

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final UserModule _customerModule = UserModule();
  late final TextEditingController fnameController;
  late final TextEditingController lnameController;
  late final TextEditingController pNOController;
  late final TextEditingController idNoController;
  late final TextEditingController emailController;
  late final TextEditingController addressController;

  bool fNameError = false;
  bool lnameError = false;
  bool pNoError = false;
  bool idNoError = false;
  bool emailError = false;
  bool addressError = false;
  bool emailInvalid = false;
  bool isLoading = false;

@override
void initState(){
  super.initState();
  emailController=TextEditingController();
  pNOController=TextEditingController();
  lnameController=TextEditingController();
  idNoController=TextEditingController();
  fnameController=TextEditingController();
  addressController=TextEditingController();
  if(widget.isEditing){
    emailController.text=widget.customer?.email ?? '';
    pNOController.text=widget.customer?.phoneNo ?? '';
    lnameController.text=widget.customer?.lastName ?? '';
    fnameController.text=widget.customer?.firstName ?? '';
    idNoController.text=widget.customer?.idNumber ?? '';
    addressController.text=widget.customer?.address ?? '';


  }
}
@override
void dispose(){
  emailController.dispose();
  pNOController.dispose();
  lnameController.dispose();
  fnameController.dispose();
  idNoController.dispose();
  addressController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text( widget.isEditing== true ? 'Edit Customer' : 'Add Customer'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: ListView(
            children: [
              InputField(
                'FirstName',
                fnameController,
                fNameError,
                onChanged: (val) => {
                  if (val.isNotEmpty)
                    {
                      setState(() {
                        fNameError = false;
                      })
                    }
                },
              ),
              InputField(
                'LastName',
                lnameController,
                lnameError,
                onChanged: (val) => {
                  if (val.isNotEmpty)
                    {
                      setState(() {
                        lnameError = false;
                      })
                    }
                },
              ),
              InputField(
                'Phone Number',
                pNOController,
                pNoError,
                keyboardType: TextInputType.phone,
                onChanged: (val) => {
                  if (val.isNotEmpty)
                    {
                      setState(() {
                        pNoError = false;
                      })
                    }
                },
              ),
              InputField(
                'Email',
                emailController,
                emailError,
                keyboardType: TextInputType.emailAddress,
                invalid: emailInvalid,
                onChanged: (val) => {
                  if (val.isNotEmpty)
                    {
                      setState(() {
                        emailError = false;
                      })
                    }
                },
              ),
              InputField(
                'ID Number',
                idNoController,
                idNoError,
                onChanged: (val) => {
                  if (val.isNotEmpty)
                    {
                      setState(() {
                        idNoError = false;
                      })
                    }
                },
              ),
              InputField(
                'Address',
                addressController,
               addressError,
                onChanged: (val) => {
                  if (val.isNotEmpty)
                    {
                      setState(() {
                        addressError = false;
                      })
                    }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () {
                          bool errorExist = false;
                          if (fnameController.text.isEmpty) {
                            errorExist = true;
                            setState(() {
                              fNameError = true;
                            });
                          }
/*                           if (mnameController.text.isEmpty) {
                            errorExist = true;
                            setState(() {
                              mNameError = true;
                            });
                          } */
                          if (lnameController.text.isEmpty) {
                            errorExist = true;
                            setState(() {
                              lnameError = true;
                            });
                          }
/*                           if (idNoController.text.isEmpty) {
                            errorExist = true;
                            setState(() {
                              idNoError = true;
                            });
                          } */
                          if (pNOController.text.isEmpty) {
                            errorExist = true;
                            setState(() {
                              pNoError = true;
                            });
                          }
                          if (emailController.text.isEmpty) {
                            errorExist = true;
                            setState(() {
                              emailError = true;
                            });
                          }
                          if (!GetUtils.isEmail(emailController.text)) {
                            errorExist = true;
                            setState(() {
                              emailInvalid = true;
                            });
                          }

                          // if no error exist save user
                          if (!errorExist) {
                            widget.isEditing ? updateCustomer() : createCustomer();

                              }
                        },
                        child: isLoading ? const CircularProgressIndicator(): Text(widget.isEditing ? 'Update Customer' : 'Add Customer')),
                  ],
                ),
              )
            ],
          )),
    );
  }

  void createCustomer() async {
    setState(() {
      isLoading=true;
    });
    var _res=await _customerModule.addCustomer(UserModel(
        firstName: fnameController.text,
        lastName: lnameController.text,
        idNumber: idNoController.text,
        email: emailController.text,
        phoneNo: pNOController.text,
        address: addressController.text,
        userRole: UserWidgetType.customer
        ));
        setState(() {
          isLoading=false;
        });
        if(_res.status == ResponseType.success){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Customer Created!"),
      ));
      // back
      Navigator.pop(context);
    }else{
      Get.showSnackbar(GetSnackBar(title: 'Error', message: _res.body.toString(), backgroundColor: Colors.redAccent,)
        );
    }
    
  }
void updateCustomer() async{
  setState(() {
    isLoading=true;
  });
  var _res =await _customerModule.updateCustomers((widget.customer?.id ?? ''), 
  {
        'firstName': fnameController.text,
        'lastName': lnameController.text,
        'idNumber': idNoController.text,
        'email': emailController.text,
        'phoneNo': pNOController.text,
        'address': addressController.text,
        'userRole': UserWidgetType.customer.lable
  }
  );

  setState(() {
    isLoading=false;
  });
  if(_res.status == ResponseType.success){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Customer Updated!"),
      ));
      // back
      Navigator.pop(context);
    }else{
      Get.showSnackbar(GetSnackBar(title: 'Error', message: _res.body.toString(), backgroundColor: Colors.redAccent,)
        );
    }

}
  void clearInputs() {
    fnameController.clear();
    lnameController.clear();
    emailController.clear();
    pNOController.clear();
    idNoController.clear();
  }
}
