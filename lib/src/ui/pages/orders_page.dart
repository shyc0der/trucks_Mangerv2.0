import 'package:flutter/material.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/ui/pages/orders_details_page.dart';
import 'package:trucks_manager/src/ui/widgets/job_list_tile_widget.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

import '../../models/order_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Stream<List<OrderModel>> orders;
 late List<OrderModel> displayOrders = [];
  late List<OrderModel> displayOrder;
  final OrderModules _orderModules = OrderModules();

  void _changeView(int val) {
    switch (val) {
      case 1:
        setState(() {
          displayOrders = displayOrder
              .where(
                  (element) => element.orderStates == OrderWidgateState.Pending)
              .toList();
        });
        break;
      case 2:
        setState(() {
          displayOrders = displayOrder
              .where((element) => element.orderStates == OrderWidgateState.Open)
              .toList();
        });
        break;
      case 3:
        setState(() {
          displayOrders = displayOrder
              .where(
                  (element) => element.orderStates == OrderWidgateState.Closed)
              .toList();
        });
        break;
      default:
        setState(() {
          displayOrders = displayOrder;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    orders = _orderModules.fetchOrders();
    orders.forEach((element) {
      setState(() {        
      displayOrder = element;
         displayOrders = displayOrder;
      });
      
     });

 
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderModel>>(
        // stream: _orderModules!.fetchOrders(),
        builder: (context, snapshot) {
      //displayOrders = snapshot.data ?? [];
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Orders'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: ListView.builder(
          itemCount: displayOrders.length,
          itemBuilder: (_, index) {
            return JobListTile(
              title: displayOrders[index].title ?? '',
              dateTime: displayOrders[index].dateCreated,
              amount: displayOrders[index].amount ?? 0,
              jobState: displayOrders[index].orderStates,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OrderDetailPage(displayOrders[index])));
              },
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _changeView,
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.list_outlined), label: 'All'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pending_outlined), label: 'Pending'),
            BottomNavigationBarItem(
                icon: Icon(Icons.outbox_outlined), label: 'Open'),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all_outlined), label: 'Closed'),
          ],
        ),
      );
    });
  }
}

// List<OrderModel> _orders = List.generate(30, (index) {
//   final List<OrderWidgateState> states = List.from(OrderWidgateState.values);
//   states.shuffle();
//   return  OrderModel(
//   'From side A to side Z', 30000, DateTime.now(), states.first);
// });

// class OrderModel {
//   OrderModel(this.destination, this.amount, this.dateTime, this.orderState);
//   final String destination;
//   final double amount;
//   final DateTime dateTime;
//   final OrderWidgateState orderState;
// }