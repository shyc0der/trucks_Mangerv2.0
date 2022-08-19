import 'package:get/get.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
class TruckModules extends GetxController {
 final TrucksModel _trucksModel = TrucksModel();
  RxList<TrucksModel> trucks = <TrucksModel>[].obs;

  Stream<List<TrucksModel>> fetchTrucks() {
    return _trucksModel.fetchStreamsData().map<List<TrucksModel>>((streams) {
      return streams.docs
          .map<TrucksModel>((doc) =>
              TrucksModel.fromMap({'id': doc.id, ...doc.data() as Map}))
          .toList();
    });
  }

  //list of jobs per vehicle
  Future<TrucksModel> fetchOrdersPerTruck(String id) async {
    //fetch job and then get vehicleid
       var truck = await _trucksModel.fetchDataById(id);
    return TrucksModel.fromMap({'id': truck.id, ...(truck.data() ?? {})});
  }
}

    //list of jobs per expenses
    //get amount
  
