import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';
import 'package:trucks_manager/src/ui/widgets/order_items_widget.dart';

import '../../models/order_model.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage(this.order, {Key? key}) : super(key: key);
  final OrderModel order;

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
            OrderDetialWidget(
              title: order.title ?? '',
              amount: 'Ksh. ${order.amount}',
              date: order.dateCreated.toString().substring(0, 16),
              orderState: order.orderStates,
              onApprove: (){},
              onCancel: (){},
              onClose: (){},
            ),
    
            const SizedBox(height: 20,),
      
      
            // driver detail
            if(order.orderStates != OrderWidgateState.Pending)
            const OrderItemsDriverWidget(
              driverName: 'Name Name Name',
              email: 'email@mail.mail',
              phoneNo: '+254712345678',
            ),
      
            // Truck detail
            if(order.orderStates != OrderWidgateState.Pending)
            const OrderItemsTruckWidget(
              registration: 'KBZ 001Z',
              loadCapacity: 'LC: 30t',
            )
          ],
        ),
      ),
    );
  }
}