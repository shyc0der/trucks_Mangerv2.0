// ignore_for_file: no_leading_underscores_for_local_identifiers, annotate_overrides

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:get/get.dart';
import 'package:pdf_reports_generator/pdf_reports_generator.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/reports/reports_generator_module.dart';

import '../../modules/expenses_modules.dart';
import '../../modules/job_module.dart';

class OrderReport extends ReportGeneratorModule{
  OrderReport({this.customerId, this.selectedOrderState = const [], required this.dateRange});
  final String? customerId; 
  final DateTimeRange dateRange;
  final List<String> selectedOrderState;

  final OrderModules _orderModule = OrderModules();
  final JobModule _jobModule2 = JobModule();
  final ExpenseModule _expenseModule = ExpenseModule();
  final UserModule _customerModule = UserModule();
  UserModule userModule=Get.find<UserModule>();

  List<OrdersReoprtModel> orders = [];

  double _expenseTotals = 0;
  double _orderTotals = 0;


  List<String> get _filters => [
    if(customerId != null) 'By Customer',
    if(selectedOrderState.isNotEmpty) 'State:$selectedOrderState',
  ]; 

  Future getOrder() async{
    var _orders = await _orderModule.fetchAllWhereOrders(dateRange).first;
    // filter customer
    if(customerId != null){
      _orders.retainWhere((order) => order.customerId == customerId);
    }
    // filter state
    if(selectedOrderState.isNotEmpty){
      _orders.retainWhere((order) => selectedOrderState.contains(order.state));
    }

     for (var _order in _orders){
      // order totals
      _orderTotals += _order.amount ?? 0;

      // get job by Orderid
      final _job = await _jobModule2.fetchJobsByOrderId(_order.id ?? 'null');
      double _expensesPerJobTotal = 0;

      if(_job != null){
        // then get expenses by job id
        final _exs = await _expenseModule.fetchByJobExpenses(_job.id ?? 'null',userModule.currentUser.value).first;
        
        for(var _e in _exs){
          _expensesPerJobTotal += double.tryParse(_e.totalAmount ?? '0') ?? 0;
        }
        // get expense total
        _expenseTotals += _expensesPerJobTotal;


      }

      // get customer name
      final _customer = await _customerModule.fetchCustomerById(_order.customerId ?? 'null');
      String _customerName = "${_customer.firstName ?? ''}  ${_customer.lastName ?? ''}";

      orders.add(OrdersReoprtModel(expensesAmount: _expensesPerJobTotal, orderModel: _order, customerName: _customerName));
      
    }
  }

  Future<Document> generatePdf({PdfPageFormat? pageFormat})async{
    // get orders
    orders.clear();
    _orderTotals = _expenseTotals = 0;
   await getOrder();
  
   var _template =OrdersReportPdf(
     orders: orders.map((e) => e.asMap()).toList(),
     totals: [_orderTotals, _expenseTotals, _orderTotals - _expenseTotals],
     rangeFrom: dateRange.start,
     rangeTo: dateRange.end,
     filters : _filters


   );
   

    return PdfGenerate.generate(_template,pageFormat:pageFormat ?? PdfPageFormat.a4);
    
  }

}

class OrdersReoprtModel {
  OrdersReoprtModel({required this.expensesAmount, required this.orderModel, required this.customerName});
  OrderModel orderModel;
  double expensesAmount = 0;
  String customerName;

  double get total => orderModel.amount ?? 0 - expensesAmount;

  Map<String, dynamic> asMap()=>{
    ...orderModel.asMap(),
    'expensesAmount': expensesAmount.toString(),
    'total': total,
    'customerName': customerName,
  };

}

class OrderReportController extends GetxController{
  Rx<String?> customerId = Rxn();
  RxList<String> selectedOrderState = <String>[].obs;
  
  Rx<DateTimeRange> dateRange = Rx(DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)), 
    end: DateTime.now()
  ));

  ReportGeneratorModule filter(){
    return OrderReport(customerId: customerId.value, selectedOrderState: selectedOrderState, dateRange: dateRange.value);
  }
}