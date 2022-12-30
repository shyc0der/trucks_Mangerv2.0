// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trucks_manager/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/widgets/user_widget.dart';

import '../../../models/response_model copy.dart';
import '../../../modules/user_modules.dart';
import '../../widgets/input_fields.dart';

class AddUserWidget extends StatefulWidget {
  const AddUserWidget({this.user, this.isEditing = false, Key? key})
      : super(key: key);
  final bool isEditing;
  final UserModel? user;

  @override
  _AddUserWidgetState createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
  final UserModule userModule = UserModule();
  UserWidgetType selectedUserRole = UserWidgetType.driver;

  late final TextEditingController fNameController;
  late final TextEditingController lNameController;
  late final TextEditingController idController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  final ImagePicker _picker = ImagePicker();
  XFile? _receiptImage;
  String? _onlineImage;

  bool fNameError = false;
  bool lNameError = false;
  bool idError = false;
  bool phoneError = false;
  bool emailError = false;
  bool emailInvalid = false;
  bool _receiptError = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fNameController = TextEditingController();
    lNameController = TextEditingController();
    idController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    if (widget.isEditing) {
      fNameController.text = widget.user?.firstName ?? '';
      lNameController.text = widget.user?.lastName ?? '';
      idController.text = widget.user?.idNumber ?? '';
      phoneController.text = widget.user?.phoneNo ?? '';
      emailController.text = widget.user?.email ?? '';
      selectedUserRole = widget.user?.userRole ?? UserWidgetType.driver;
      _onlineImage = widget.user?.receiptPath;
    }
  }

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    idController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void createUser() async {
    setState(() {
      isLoading = true;
    });
    // save user
    var _res = await userModule.addUser(UserModel(
        firstName: fNameController.text,
        lastName: lNameController.text,
        idNumber: idController.text,
        phoneNo: phoneController.text,
        email: emailController.text,
        userRole: selectedUserRole,
        receiptPath: _onlineImage),
       _receiptImage);

    setState(() {
      isLoading = false;
    });

    if (_res.status == ResponseType.success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User created!"),
      ));
      // back
      Navigator.pop(context);
    } else {
      if (_res.body == 'weak-password') {
        Get.showSnackbar(const GetSnackBar(
          title: 'Weak password',
          message: 'Weak password',
          backgroundColor: Colors.redAccent,
        ));
      } else if (_res.body == 'email-already-in-use') {
        Get.showSnackbar(GetSnackBar(
          title: 'Email already registered',
          message: 'Email already registered',
          isDismissible: true,
          backgroundColor: Colors.amber.withOpacity(.65),
        ));
        setState(() {
          emailInvalid = true;
        });
      } else {
        Get.showSnackbar(GetSnackBar(
          title: 'Error',
          message: _res.body.toString(),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }

  void updateUser() async {
    setState(() {
      isLoading = true;
    });
    // save user
    var _res = await userModule.updateUser((widget.user?.id ?? ''), {
      'firstName': fNameController.text,
      'lastName': lNameController.text,
      'idNumber': idController.text,
      'phoneNo': phoneController.text,
      'userRole': selectedUserRole.lable,
      'receiptPath': _onlineImage
    },image: _receiptImage);

    setState(() {
      isLoading = false;
    });

    if (_res.status == ResponseType.success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User Updated!"),
      ));
      // back
      Navigator.pop(context);
    } else {
      Get.showSnackbar(GetSnackBar(
        title: 'Error',
        message: _res.body.toString(),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  ImageProvider get _getImage {
    String? _path;
    if (widget.isEditing && _receiptImage == null) {
      _path = _onlineImage;
    } else {
      _path = _receiptImage!.path;
    }
    if (kIsWeb) {
      return NetworkImage(_path!);
    } else {
      return FileImage(File(_path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ListView(
          children: [
            if (isLoading) const LinearProgressIndicator(),
            // 1st name
            InputField('First name', fNameController, fNameError,
                onChanged: (String val) {
              if (val.isNotEmpty) {
                setState(() {
                  fNameError = false;
                });
              }
            }),

            // 2nd name

            // last name
            InputField('Last name', lNameController, lNameError,
                onChanged: (String val) {
              if (val.isNotEmpty) {
                setState(() {
                  lNameError = false;
                });
              }
            }),

            // id
            InputField('ID No', idController, idError,
                isNumbers: true,
                keyboardType: TextInputType.number, onChanged: (String val) {
              if (val.isNotEmpty) {
                setState(() {
                  idError = false;
                });
              }
            }),

            // phone
            InputField('Phone number', phoneController, phoneError,
                isNumbers: true,
                keyboardType: TextInputType.phone, onChanged: (String val) {
              if (val.isNotEmpty) {
                setState(() {
                  phoneError = false;
                });
              }
            }),

            // email
            if (!widget.isEditing)
              InputField('Email address', emailController, emailError,
                  keyboardType: TextInputType.emailAddress,
                  invalid: emailInvalid, onChanged: (String val) {
                if (val.isNotEmpty) {
                  setState(() {
                    emailInvalid = false;
                    emailError = false;
                  });
                }
              }),

            const Text(
              'User Role',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var _role in UserWidgetType.values)
                  // ToggleButtons(children: children, isSelected: isSelected)

                  Row(
                    children: [
                      Radio<UserWidgetType>(
                          key: ValueKey(_role),
                          value: _role,
                          groupValue: selectedUserRole,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedUserRole = val;
                              });
                            }
                          }),
                      Text(_role.lable)
                    ],
                  ),
              ],
            ),

            // actions buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(width: 80, child: Text('ID Number Image:')),
                  ),

                  // image
                  if (!(_receiptImage == null || _onlineImage == null))
                    InkWell(
                      onTap: () {
                        _picker
                            .pickImage(source: ImageSource.gallery)
                            .then((value) {
                          setState(() {
                            _receiptImage = value;
                            _receiptError = false;
                          });
                        });
                      },
                      child: Container(
                        height: 120,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: _getImage, fit: BoxFit.contain)),
                      ),
                    ),

                  if (_receiptImage == null)
                    Expanded(
                      child: TextButton.icon(
                          onPressed: () {
                            _picker
                                .pickImage(source: ImageSource.gallery)
                                .then((value) {
                              setState(() {
                                _receiptImage = value;
                                _receiptError = false;
                              });
                            });
                          },
                          icon: const Icon(
                            Icons.image_outlined,
                            size: 35,
                          ),
                          label: const Text('Add image')),
                    ),
                ],
              ),
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
                        onPressed: isLoading
                            ? null
                            : () async {
                                bool errorExist = false;

                                if (fNameController.text.isEmpty) {
                                  errorExist = true;
                                  setState(() {
                                    fNameError = true;
                                  });
                                }
                                if (lNameController.text.isEmpty) {
                                  errorExist = true;
                                  setState(() {
                                    lNameError = true;
                                  });
                                }
                                if (idController.text.isEmpty) {
                                  errorExist = true;
                                  setState(() {
                                    idError = true;
                                  });
                                }
                                if (phoneController.text.isEmpty) {
                                  errorExist = true;
                                  setState(() {
                                    phoneError = true;
                                  });
                                }
                                if (emailController.text.isEmpty &&
                                    !widget.isEditing) {
                                  errorExist = true;
                                  setState(() {
                                    emailError = true;
                                  });
                                }
                                if (!GetUtils.isEmail(emailController.text) &&
                                    !widget.isEditing) {
                                  errorExist = true;
                                  setState(() {
                                    emailInvalid = true;
                                  });
                                }
                                if (_receiptImage == null) {
                                  setState(() {
                                    _receiptError = true;
                                  });
                                  errorExist = true;

                                  if (_receiptError == true) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor:
                                          Get.theme.colorScheme.secondary,
                                      content: const Text(
                                        "Please attach image!",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ));
                                  }
                                }

                                // if no error exist save user
                                if (!errorExist) {
                                  widget.isEditing
                                      ? updateUser()
                                      : createUser();
                                }
                              },
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                widget.isEditing ? 'Update user' : 'Add User'))
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
