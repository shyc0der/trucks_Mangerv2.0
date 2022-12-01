// ignore_for_file: unused_field, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf_reports_generator/pdf_reports_generator.dart' as pw;
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/ui/pages/jobs/jobs_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

import '../../../models/jobs_model.dart';
import '../../../models/order_model.dart';
import '../../../modules/user_modules.dart';
import '../../reports/invoice_quotation_module.dart';
import '../../widgets/driver_customer_Detail_widget.dart';
import '../../widgets/update_state_widget.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage(this.order, {Key? key}) : super(key: key);
  final OrderModel order;

  @override
  OrderDetailPageState createState() => OrderDetailPageState();
}

class OrderDetailPageState extends State<OrderDetailPage> {
  final OrderModules _orderModules = Get.put(OrderModules());
  final UserModule _userModule = Get.put(UserModule());
  final JobModule _jobModule = JobModule();
  String _orderState = '';
    NumberFormat doubleFormat = NumberFormat.decimalPattern('en_us');
  OrderWidgateState orderState = OrderWidgateState.Pending;
  @override
  void initState() {
    super.initState();

    orderState = widget.order.orderStates;
    _orderState = orderState.value;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // order detail
            OrderDetailWidget(
              title: widget.order.title ?? '',
              amount: 'Ksh. ${doubleFormat.format((widget.order.amount ?? 0).ceilToDouble())}',
              date: widget.order.dateCreated.toString().substring(0, 16),
              orderState: orderState,
              update: () async {
                OrderWidgateState? state = await changeDialogState();
                if (state != null) {
                  if (state == OrderWidgateState.Declined) {
                    await _orderModules.updateOrderState(
                        widget.order.id!, state);
                    setState(() {
                      _orderState = state.value;
                      orderState = state;
                    });
                  }
                  List<String>? _res;
                  if (state == OrderWidgateState.Approved) {
                    _res = await Get.dialog(
                        const Dialog(child: DriverVehicleGetDetails()));
                    if (_res != null && _res.isNotEmpty) {
                      final job = JobModel(
                          createdBy: _userModule.currentUser.value.id,
                          customerId: widget.order.customerId,
                          vehicleId: _res[1],
                          driverId: _res[0],
                          orderNo: widget.order.orderNo,
                          lpoNumber: _res[2],
                          orderId: widget.order.id,
                          jobState: OrderWidgateState.Pending);

                      await _jobModule.addJob(job);
                      await _orderModules.updateOrder(
                          widget.order.id ?? '', {'userId': _res[0]});

                      await _orderModules.updateOrderState(
                          widget.order.id!, state);
                      setState(() {
                        _orderState = state.value;
                        orderState = state;
                      });
                    }
                  }
                }
              },
              onCancel: () {
                Navigator.pop(context);
              },
              onClose: () async {
                JobModel? job =
                    await _jobModule.fetchJobsByOrderId(widget.order.id ?? '');
                if (job != null) {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobDetailPage(job)));
                }
              },
              goToJob: () async {
                JobModel? job =
                    await _jobModule.fetchJobsByOrderId(widget.order.id ?? '');
                if (job != null) {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobDetailPage(job)));
                } else {
                  Get.dialog(const Dialog(

                  ));
                }
              },
            ),

            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // quotation
                  if (!(orderState == OrderWidgateState.Declined ||
                      orderState == OrderWidgateState.Rejected ||
                      orderState == OrderWidgateState.Pending))
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => _pdfGenerator(
                                    isQuotation: true,
                                  ))),
                      child: const Text('Quotation'),
                    ),

                  // invoice
                  if (orderState == OrderWidgateState.Closed)
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => _pdfGenerator(
                                    isInvoice: true,
                                  ))),
                      child: const Text('Invoice'),
                    ),
                  if (orderState == OrderWidgateState.Closed)
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  _pdfGenerator(isDelNote: true))),
                      child: const Text('Delivery Note'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pdfGenerator({bool? isInvoice, bool? isDelNote, bool? isQuotation}) {
    final _pdf = InvoiceQuotationModule.fromOrderId(
      widget.order.id,
      isDelNote,
      isInvoice,
      isQuotation,
    );
    return PdfPreview(
      canDebug: false,
      pageFormats: const {
        'A4': pw.PdfPageFormat.a4,
        'Letter': pw.PdfPageFormat.letter,
        'A3': pw.PdfPageFormat.a3,
        'A5': pw.PdfPageFormat.a5,
        'A6': pw.PdfPageFormat.a6,
      },
      build: (pageFormat) async {
        return (await _pdf.generatePdf(pageFormat: pageFormat)).save();
      },
    );
  }
}
