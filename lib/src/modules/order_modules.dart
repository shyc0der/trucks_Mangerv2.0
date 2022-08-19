import 'package:get/get.dart';
import 'package:trucks_manager/src/models/order_model.dart';

class OrderModules extends GetxController {
 final OrderModel _orderModel = OrderModel();
  RxList<OrderModel> orders = <OrderModel>[].obs;

  Stream<List<OrderModel>> fetchOrders() {
    return _orderModel.fetchStreamsData().map<List<OrderModel>>((streams) {
      return streams.docs.map<OrderModel>((doc) =>
        OrderModel.from({'id': doc.id,...doc.data() as Map})
      ).toList();
    });
  }
  
  //FETCH DRIVER PER JOB
  //FETCH VEHICLE PER JOB
}
