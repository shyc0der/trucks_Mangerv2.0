// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, annotate_overrides

import 'package:pdf_reports_generator/pdf_reports_generator.dart';
import 'package:trucks_manager/src/models/order_model.dart';
import 'package:trucks_manager/src/models/user_model.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/reports/reports_generator_module.dart';

class InvoiceQuotationModule extends ReportGeneratorModule {
  InvoiceQuotationModule(
      {this.isDelNote,
      required this.orderModel,
      this.isInvoice,
      this.isQuotation});
  InvoiceQuotationModule.fromOrder(
      this.orderModel, this.isDelNote, this.isInvoice, this.isQuotation);
  InvoiceQuotationModule.fromOrderId(
      this._orderId, this.isDelNote, this.isInvoice, this.isQuotation) {
    _fetchOrder = true;
  }

  late OrderModel orderModel;
  String? _orderId;
  bool? isInvoice = true;
  bool? isDelNote = true;
  bool? isQuotation = true;

  bool _fetchOrder = false;

  final UserModule _userModule = UserModule();

  Future<UserModel> _getCustomer() async {
    return _userModule.fetchCustomerById(orderModel.customerId ?? 'null');
  }

  Future<void> _setOderModel() async {
    final OrderModules module = OrderModules();
    orderModel = await module.getOrderById(_orderId!);
  }

  Future<Document> generatePdf({PdfPageFormat? pageFormat}) async {
    // get order
    if (_fetchOrder) {
      await _setOderModel();
    }
    // get customer model
    final _customer = await _getCustomer();

    var _template;
    if (isInvoice == true) {
      _template = InvoiceWidget(
        order: orderModel.asMap(),
        client: _customer.asMap()
      );
    }
    if (isQuotation == true) {
      _template = QuotationWidget(
        order: orderModel.asMap(),
        client: _customer.asMap(),
      );
    }
    if (isDelNote == true) {
      _template = DeliveryNote(
        order: orderModel.asMap(),
        client: _customer.asMap(),
      );
    }

    // pass to quotation pdf
    return PdfGenerate.generate(_template,
        pageFormat: pageFormat ?? PdfPageFormat.a4);
  }
}
