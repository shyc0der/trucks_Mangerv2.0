import 'package:get/get.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';

import '../models/jobs_model.dart';

class JobModule extends GetxController {
  JobModel jobModel = JobModel();
//fetch Jobs
  Stream<List<JobModel>> fetchJobs() {
    return jobModel.fetchStreamsData().map<List<JobModel>>((streams) {
      return streams.docs
          .map<JobModel>(
              (doc) => JobModel.fromMap({'id': doc.id, ...doc.data() as Map}))
          .toList();
    });
  }
  //fetch job per trucks

  Future<List<JobModel>> fetchJobsByTruck(String truckId) async {
    var trucks = await jobModel.fetchWhereData('vehicleId', isEqualTo: truckId);

    return  trucks.map<JobModel>((truck) =>
        JobModel.fromMap({'id': truck.id,...truck.data()})).toList();
  
  }
}
