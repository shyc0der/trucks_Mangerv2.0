import 'package:get/get.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';

import '../../modules/trucks_modules.dart';
import '../../modules/user_modules.dart';

class Constants {
  UserModule userModule = Get.put(UserModule());
  TruckModules truckModules = Get.put(TruckModules());
  OrderModules orderModules = Get.put(OrderModules());

  String driverName(String userId) {
    var driver = userModule.getStreamUserById(userId);

    var name = '${driver?.firstName ?? ''}  ${driver?.lastName ?? ''}';
    return name;
  }

  String truckNumber(String truckId) {
    var truck = truckModules.getTruckById(truckId);
    var truckNo = truck?.vehicleRegNo ?? '';
    return truckNo;
  }

 
   String? fetchOrder(String? orderId) {
    var res = orderModules.getOrderByJobId(orderId!);

    return res?.title;
  }

}
