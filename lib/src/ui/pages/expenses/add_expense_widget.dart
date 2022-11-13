// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/expenses_model.dart';
import '../../../modules/expense_type_module.dart';
import '../../../modules/expenses_modules.dart';
import '../../../modules/user_modules.dart';
import '../../widgets/input_fields.dart';

class AddExpenseWidget extends StatefulWidget {
  const AddExpenseWidget({
    required this.truckId,
    this.expense,
    this.isEditing = false,
    Key? key,
    this.jobId,
  }) : super(key: key);
  final String truckId;
  final String? jobId;
  final bool isEditing;
  final ExpenseModel? expense;

  @override
  _AddExpenseWidgetState createState() => _AddExpenseWidgetState();
}

class _AddExpenseWidgetState extends State<AddExpenseWidget> {
  final ImagePicker _picker = ImagePicker();
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  final ExpenseTypeModule expenseTypeModule = ExpenseTypeModule();
  final ExpenseModule expenseModule = ExpenseModule();
  final UserModule userModule = Get.put(UserModule());
  String _exType = 'None';
  XFile? _receiptImage;
  String? _onlineImage;

  bool _descError = false;
  bool _amountError = false;
  bool _receiptError = false;
  bool isLoading = false;

  List<String> _exes = ["None"];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    expenseTypeModule.fetchExpenseTypesAsString().then((value) {
      setState(() {
        if (value.isNotEmpty) {
          _exes = value;
          _exType = _exes.first;
        }
      });
    });
    if (widget.isEditing) {
      _descriptionController.text = widget.expense?.description ?? '';
      _amountController.text = widget.expense?.totalAmount ?? '';
      _exType = widget.expense?.expenseType ?? '';
      _onlineImage = widget.expense?.receiptPath;
      //_receiptImage?.path=widget.expense?.receiptPath ?? '';

    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
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

  void createExpense() async {
    setState(() {
      isLoading = true;
    });
    expenseModule.addExpense(
        ExpenseModel(
            userId: userModule.currentUser.value.id,
            truckId: widget.truckId,
            jobId: widget.jobId,
            expenseType: _exType,
            totalAmount: _amountController.text,
            description: _descriptionController.text),
        _receiptImage);

    setState(() {
      isLoading = false;
    });
  }

  void updateExpense() async {
    setState(() {
      isLoading = true;
    });
    expenseModule.updateExpense(
        (widget.expense?.id ?? ''),
        {
          'userId': userModule.currentUser.value.id,
          'truckId': widget.truckId,
          'jobId': widget.jobId,
          'expenseType': _exType,
          'totalAmount': _amountController.text,
          'description': _descriptionController.text,
          'receiptPath': _onlineImage
        },
        image: _receiptImage);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.isEditing ? 'Edit Expense' : 'Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const SizedBox(
              height: 10,
            ),
            // expense type
            Row(
              children: [
                // label
                const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: SizedBox(width: 80, child: Text('Expense Type:')),
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
                        value: _exes[0],
                        onChanged: (String? val) {
                          if (val != null) {
                            setState(() {
                              _exType = val;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none)),
                        items: [
                          for (var expenseName in _exes)
                            DropdownMenuItem(
                              value: expenseName,
                              child: Text(expenseName),
                            ),
                        ]),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            // description
            InputField('Description', _descriptionController, _descError,
                maxLines: 3, onChanged: (String val) {
              if (val.isNotEmpty) {
                setState(() {
                  _descError = false;
                });
              }
            }),

            // amount
            InputField('Amount Quoted', _amountController, _amountError,
                isNumbers: true, onChanged: (String val) {
              if (val.isNotEmpty) {
                setState(() {
                  _amountError = false;
                });
              }
            }),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(width: 80, child: Text('Receipt Image:')),
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

            // buttons
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
                    if (_descriptionController.text.isEmpty) {
                      setState(() {
                        _descError = true;
                      });
                      errorExist = true;
                    }
                    if (_amountController.text.isEmpty) {
                      setState(() {
                        _amountError = true;
                      });
                      errorExist = true;
                    }
                    if ((_exType.toLowerCase() == 'FUEL'.toLowerCase()) &&
                        (_receiptImage == null)) {
                      setState(() {
                        _receiptError = true;
                      });
                      errorExist = true;

                      if (_receiptError == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Get.theme.colorScheme.secondary,
                          content: const Text(
                            "Please attach image!",
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      }
                    }

                    // save job
                    if (!errorExist) {
                      // save
                      !widget.isEditing ? createExpense() : updateExpense();
                      // pop
                      Navigator.of(context).pop('expenseId');
                    }
                  },
                  label:
                      Text(widget.isEditing ? 'Update Expense' : 'Add Expense'),
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
    _descriptionController.clear();
    _amountController.clear();
  }
}
