import 'package:get/get.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
import 'package:trucks_manager/src/models/user_model.dart';

class TruckModules extends GetxController {
  TrucksModel _trucksModel = TrucksModel();
  RxList<TrucksModel> trucks = <TrucksModel>[].obs;

  Stream<List<TrucksModel>> fetchTrucks() {
    return _trucksModel.fetchStreamsData().map<List<TrucksModel>>((streams) {
       return streams.docs.map<TrucksModel>((doc)=>
       TrucksModel.fromMap({'id':doc.id,...doc.data() as Map})
       ).toList();
    });
      }
      //list of jobs per vehicle
      Stream<TrucksModel> fetchJobTruck(){
      return _trucksModel.fetchStreamsDataWhere('id',isNotEqualTo:  ).map<TrucksModel>((streams)
       {
        
        });
      }
      //list of jobs per expenses
      //get amount 
     

      
}
