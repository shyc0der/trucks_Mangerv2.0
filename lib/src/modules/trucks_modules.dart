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
  Stream<TrucksModel> fetchJobsPerTruck(String id) {
    //fetch job and then get vehicleid
    return _trucksModel.fetchStreamsDataById(id).map(
        (doc) => TrucksModel.fromMap({'id': doc.id, ...(doc.data() as Map)}));
  }

  //
  Future<TrucksModel> fetchFutureJobsPerTruck(String id) async {
    //fetch job and then get vehicleid
    var trucks = await _trucksModel.fetchDataById(id);
    return TrucksModel.fromMap({'id': trucks.id, ...(trucks.data() as Map)});
  }
}


    //list of jobs per expenses
    //get amount
  
