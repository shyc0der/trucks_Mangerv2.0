import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/pages/orders/orders_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/job_list_tile_widget.dart';
import '../../../models/order_model.dart';
import '../../../modules/job_module.dart';
import '../../widgets/dismiss_widget.dart';
import 'add_order_widget.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage(this.state, {Key? key}) : super(key: key);
  String state;
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
 // late Stream<List<OrderModel>> orders;
  // late List<OrderModel> displayOrders = [];
  late List<OrderModel> displayOrder;
  final OrderModules _orderModules = OrderModules();
  final UserModule _userModule = Get.find<UserModule>();
  NumberFormat doubleFormat = NumberFormat.decimalPattern('en_us');
  @override
  void initState() {
    super.initState();
    
  }
   Future<bool> _dismissDialog(OrderModel orderModel)async{
     JobModule _jobModule2=JobModule();
     String? _jobId;

    bool? _delete = await dismissWidget('${orderModel.orderNo}');

    if(_delete == true){
      // delete from server
      //fetch job id by orderid
      var _res= await _jobModule2.fetchJobsByOrderId(orderModel.id ?? '');
      _jobId=_res?.id;    
            
     if(_jobId != null){
       await _jobModule2.deleteJob(_jobId, orderModel.id);
     }else{
       await orderModel.deleteOnline(orderModel.id ?? 'null');
     }

     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Order Deleted!"),
      ));
    }
  return _delete == true;
  }  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderModel>>(
        builder: (context, snapshot) {
      return Scaffold(
        floatingActionButton: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 30,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddOrderWidget()));
              },
              icon: const Icon(Icons.add),
            )),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Orders'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: StreamBuilder<List<OrderModel>>(
            stream: _orderModules.fetchOrderByState(widget.state,_userModule.currentUser.value),
            builder: (context, snapshot) {
            
                if (snapshot.hasError) {
                            return Text('Error = ${snapshot.error}');
                          }
                          if (snapshot.hasData) {
                              var displayOrders = snapshot.data!;
              return ListView.builder(
                itemCount: displayOrders.length,
                itemBuilder: (_, index) {
                  return JobListTile(
                    title: displayOrders[index].title ?? '',
                    orderNo: displayOrders[index].orderNo ?? '',
                    dateTime: displayOrders[index].dateCreated,
                    amount: doubleFormat.format(
                        (displayOrders[index].amount ?? 0).ceilToDouble()),
                    jobState: displayOrders[index].orderStates,
                    onDoubleTap: () async {
                      await  _dismissDialog(snapshot.data![index]);                        
                    },
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              OrderDetailPage(displayOrders[index])));
                    },
                  );
                },
              );
              }
              else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
      );

    });
  }
}

