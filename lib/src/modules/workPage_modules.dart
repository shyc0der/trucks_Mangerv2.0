// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:trucks_manager/src/models/work_model.dart';

class WorkPageModule extends GetxController {
 //final WorkModel _workModel = WorkModel();

//number of trucks
  Future<WorkModel> getCounts() async {

    //var count = await  _truckModules.fetchTrucks().length;

    return   WorkModel.from({'trucksCount': 1, 'ordersCount': 1, 'jobsCount': 1});
  }
}
