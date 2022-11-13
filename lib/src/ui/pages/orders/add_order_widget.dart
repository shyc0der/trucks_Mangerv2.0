// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

import '../../../models/response_model copy.dart';
import '../../../modules/order_modules.dart';
import '../../../modules/user_modules.dart';
import '../../widgets/input_fields.dart';

class AddOrderWidget extends StatefulWidget {
  const AddOrderWidget({this.order, this.isEditing = false, key})
      : super(key: key);
  final bool isEditing;
  final OrderModel? order;

  @override
  // ignore: library_private_types_in_public_api
  _AddOrderWidgetState createState() => _AddOrderWidgetState();
}

class _AddOrderWidgetState extends State<AddOrderWidget> {
  final UserModule _userModule = Get.put(UserModule());
  final OrderModules _orderModule = OrderModules();
 final  List<String> _jobTitles = [
    'Transport',
    'Logistics',
    'Dumping',
    'Hire',
    'Pozoolana'
  ];
 final List<double> _vats = [0, 16];
  late String selectedJobTitle;

  late double appliedVat;
  late final TextEditingController descController;
  late final TextEditingController amountController;
  late final TextEditingController rateController;
  late final TextEditingController noOfDaysController;
  bool descError = false;
  bool amountError = false;
  bool orderError = false;
  bool isLoading = false;
  bool noOfDaysError = false;
  bool rateError = false;

  Map<String, dynamic> _customerEmail = {'None': 'None'};
final  Map<String, dynamic> _driver = {'None': 'None'};
  String? _customerid;

  // String? _userName;

  //String _initialCustomer = 'None';
  @override
  void initState() {
    descController = TextEditingController();
    amountController = TextEditingController();
    noOfDaysController = TextEditingController();
    rateController = TextEditingController();

    if (_customerEmail.isNotEmpty) {
      _customerid = _customerEmail.keys.first;
      // _initialCustomer=_customerEmail.keys.first;

    }
    //fetch customers email
    _userModule.fetchCustomersEmail(true).then((value) {
      setState(() {
        _customerEmail = value;
        if (widget.isEditing) {
          _customerid = widget.order?.customerId ?? '';
        } else {
          _customerid = _customerEmail.keys.first;
        }
      });
    });
    //fetch drivers email
    _userModule.fetchUsersName().then((value) {
      setState(() {
        for (String userId in value.keys) {
          _driver[userId] =
              '${value[userId]['firstName']} ${value[userId]['middleName']} ${value[userId]['lastName']}';
        }
        // if(_driver.isNotEmpty){
        //   _userName=_driver.keys.first;

        // }
      });
    });

    selectedJobTitle = _jobTitles.first;
    appliedVat = _vats.first;
    if (widget.isEditing) {
      
      descController.text = widget.order?.decription ?? '';
      amountController.text = widget.order?.amount.toString() ?? '';
      selectedJobTitle = widget.order?.title ?? '';
      appliedVat = widget.order?.vat ?? 0;
      rateController.text = widget.order?.rate.toString() ?? '';
      noOfDaysController.text = widget.order?.noOfDays.toString() ?? '';
      setState(() {
        _customerid = widget.order?.customerId ?? 'None';
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    descController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.isEditing ? 'Edit Order' : 'Add Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Padding(
                    padding:  EdgeInsets.all(8),
                    child: SizedBox(
                      child: SizedBox(
                        width: 80,
                        child: Text("Title"),
                      ),
                    )),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(width: .8, color: Colors.grey),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedJobTitle,
                    onChanged: (String? val) {
                      if (val != null) {
                        setState(() {
                          selectedJobTitle = val;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                        border:  UnderlineInputBorder(
                            borderSide: BorderSide.none)),
                    items: [
                      for (var jTitle in _jobTitles)
                        DropdownMenuItem(value: jTitle, child: Text(jTitle))
                    ],
                  ),
                )),
              ],
            ),
            //Description
            InputField(
              "Description",
              descController,
              descError,
              onChanged: (val) {
                if (val.isNotEmpty) {
                  setState(() {
                    descError = false;
                  });
                }
              },
            ),

            if (selectedJobTitle.contains('Transport') ||
                selectedJobTitle.contains('Logistics'))
              //amount
              InputField(
                "Amount",
                amountController,
                amountError,
                isNumbers: true,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      amountError = false;
                    });
                  }
                },
              ),
            if (selectedJobTitle.contains('Dumping') ||
                selectedJobTitle.contains('Pozoolana') ||
                selectedJobTitle.contains('Hire'))
              //amount
              InputField(
                "Rate",
                rateController,
                amountError,
                isNumbers: true,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      rateError = false;
                    });
                  }
                },
              ),
            if (selectedJobTitle.contains('Dumping'))
              InputField(
                'No Of Trips',
                noOfDaysController,
                noOfDaysError,
                isNumbers: true,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      noOfDaysError = false;
                    });
                  }
                },
              ),
            if (selectedJobTitle.contains('Hire'))
              InputField(
                'No Of Days',
                noOfDaysController,
                noOfDaysError,
                isNumbers: true,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      noOfDaysError = false;
                    });
                  }
                },
              ),
            if (selectedJobTitle.contains('Pozoolana'))
              InputField(
                'Tonnes',
                noOfDaysController,
                noOfDaysError,
                isNumbers: true,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      noOfDaysError = false;
                    });
                  }
                },
              ),
            //vat
            Row(
              children: [
           const     Padding(
                    padding:  EdgeInsets.all(8),
                    child: SizedBox(
                      child: SizedBox(
                        width: 80,
                        child: Text("VAT"),
                      ),
                    )),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(width: .8, color: Colors.grey),
                  ),
                  child: DropdownButtonFormField<double>(
                    value: appliedVat,
                    onChanged: (double? val) {
                      if (val != null) {
                        setState(() {
                          appliedVat = val;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                        border:  UnderlineInputBorder(
                            borderSide: BorderSide.none)),
                    items: [
                      for (var vat in _vats)
                        DropdownMenuItem(value: vat, child: Text('$vat %'))
                    ],
                  ),
                )),
              ],
            ),

            //customeremail,
            Row(
              children: [
               const Padding(
                  padding:  EdgeInsets.all(8),
                  child: SizedBox(width: 80, child: Text("Customer's Email")),
                ),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(width: .8, color: Colors.grey)),
                        child: DropdownButtonFormField<String>(
                          value: _customerEmail.keys.first,
                          onChanged: (value) {
                            if (value != null) {
                              _customerid = value;
                            }
                          },
                          items: [
                            for (var customer in _customerEmail.keys)
                              DropdownMenuItem(
                                  value: customer,
                                  child:
                                      Text(_customerEmail[customer].toString()))
                          ],
                        )))
              ],
            ),
            // user who created the order
         const   SizedBox(
              height: 5,
            ),

            //     //CANCEL AND SAVE BUTTON
          const  SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      clearInputs();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                ElevatedButton.icon(
                  onPressed: () {
                    bool errorExist = false;
                    if (descController.text.isEmpty) {
                      errorExist = true;
                      setState(() {
                        descError = true;
                      });
                    }
                    if (selectedJobTitle.contains('Transport') ||
                        selectedJobTitle.contains('Logistics')) {
                      if (amountController.text.isEmpty) {
                        setState(() {
                          amountError = true;
                        });
                        errorExist = true;
                      }
                    }

                    if (selectedJobTitle.contains('Dumping') ||
                        selectedJobTitle.contains('Pozoolana') ||
                        selectedJobTitle.contains('Hire')) {
                      if (rateController.text.isEmpty) {
                        setState(() {
                          rateError = true;
                        });
                        errorExist = true;
                      }
                      if (selectedJobTitle.contains('Dumping') ||
                          selectedJobTitle.contains('Pozoolana') ||
                          selectedJobTitle.contains('Hire')) {
                        if (noOfDaysController.text.isEmpty) {
                          setState(() {
                            noOfDaysError = true;
                          });
                          errorExist = true;
                        }
                      }
                    }

                    // save job
                    if (!errorExist) {
                      widget.isEditing ? updateOrder() : createOrder();
                    }
                  },
                  label: isLoading
                      ? const CircularProgressIndicator()
                      : Text(widget.isEditing ? 'Update' : 'Save'),
                  icon: const Icon(Icons.add),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  double get totalAmount {
    double amount = 0;
    if (selectedJobTitle.contains('Dumping') ||
        selectedJobTitle.contains('Hire') ||
        selectedJobTitle.contains('Pozoolana')) {
      amount = ((double.tryParse(noOfDaysController.text) ?? 0) *
          (double.tryParse(rateController.text) ?? 0));
    }
    if (selectedJobTitle.contains('Transport') ||
        selectedJobTitle.contains('Logistics')) {
      amount = double.tryParse(amountController.text) ?? 0;
    }

    return amount;
  }

  void createOrder() async {
    setState(() {
      isLoading = true;
    });
    var _res = await _orderModule.addOrder(OrderModel(
      decription: descController.text,
      title: selectedJobTitle,
      amount: totalAmount,
      rate: double.tryParse(rateController.text),
      noOfDays: double.tryParse(noOfDaysController.text),
      customerId: _customerid,
      userId: _userModule.currentUser.value.id,
      orderState: OrderWidgateState.Pending,
      vat: appliedVat,
    ));
    setState(() {
      isLoading = false;
    });

    if (_res.status == ResponseType.success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Order Created!"),
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
    clearInputs();
  }

  void updateOrder() async {
    setState(() {
      isLoading = true;
    });

    var _res = await _orderModule.updateOrder((widget.order?.id ?? ''), {
      'decription': descController.text,
      'title': selectedJobTitle,
      'amount': totalAmount,
      'rate': double.tryParse(
        rateController.text,
      ),
      'noOfDays': double.tryParse(noOfDaysController.text),
      'customerid': _customerid,
      //'userId': _userModule.currentUser.value.id,
      'vat': appliedVat,
    });
    setState(() {
      isLoading = false;
    });
    if (_res.status == ResponseType.success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Order Updated!"),
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
    clearInputs();
  }

  void clearInputs() {
    descController.clear();
    amountController.clear();
    noOfDaysController.clear();
    rateController.clear();
  }
}