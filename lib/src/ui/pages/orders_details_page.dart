import 'package:flutter/material.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';

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
      
      
        
          ],
        ),
      ),
    );
  }
}