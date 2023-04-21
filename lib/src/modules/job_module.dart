// ignore_for_file: no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';
import 'package:trucks_manager/src/modules/expenses_modules.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/ui/widgets/order_details_widget.dart';
import 'package:trucks_manager/src/ui/widgets/user_widget.dart';

import '../models/expenses_model.dart';
import '../models/jobs_model.dart';
import '../models/order_model.dart';
import '../models/response_model copy.dart';
import '../models/user_model.dart';
class JobModule extends GetxController {
  JobModel jobModel = JobModel();
  RxList<JobModel> jobs = <JobModel>[].obs;
   RxList<TrucksModel> trucks = <TrucksModel>[].obs;
    void init(UserModel user){
    // fetch jobs, drivers & truck
    fetchJobs(user);
    
    fetchTrucks();
  }

  
  void fetchTrucks()async{
   final _truck = TruckModules();
   _truck.fetchTrucks().then((event) {
     trucks.clear();
     trucks.addAll(event);
   }); 

  }
    // fetch all jobs
  Stream<List<JobModel>> fetchAllWhereDateRangeJobs(DateTimeRange dateRange){
      return jobModel.fetchStreamsDataWhere(
        'dateCreated', 
        orderBy: 'dateCreated',
        isGreaterThanOrEqualTo: dateRange.start.toIso8601String(),
        isLessThanOrEqualTo: dateRange.end.toIso8601String(),
      ).map<List<JobModel>>((snapshot) {
        var _jobs = snapshot.docs.map<JobModel>((doc) {

        return JobModel.fromMap({'id': doc.id, ...doc.data() as Map});}
        ).toList();
        jobs.clear();
        jobs.addAll(_jobs);
        return _jobs;   
                
      });
    
  }
  //fetch by order id
   Future<JobModel?> fetchJobsByOrderId(String _orderId)async{
    final _res = (await jobModel.fetchWhereData('orderId', isEqualTo: _orderId, orderBy: 'dateCreated')).
    map((documentSnapshot) {
      return JobModel.fromMap({'id': documentSnapshot.id, ...documentSnapshot.data()});
    }).toList();
    return _res.isNotEmpty ? _res.first : null;
  }
  //fetch jobs by user
  Future<List<JobModel>?> fetchJobsByUser(UserModel userModel)async{

    final _res = (await jobModel.fetchWhereData('userId', isEqualTo: userModel.id, orderBy: 'dateCreated')).
    map((documentSnapshot) {
      return JobModel.fromMap({'id': documentSnapshot.id, ...documentSnapshot.data()});
    }).toList();
    return _res;
  }
  //fetch jobs by user and state
    Stream<List<JobModel>> fetchJobsByState(String state,UserModel user ) {
 if(user.userRole == UserWidgetType.admin || user.userRole == UserWidgetType.manager){
      return jobModel.fetchStreamsData(orderBy: 'dateCreated').map<List<JobModel>>((snapshot) {
        var _jobs = snapshot.docs.map<JobModel>((doc) {

        return JobModel.fromMap({'id': doc.id, ...doc.data() as Map});}
        ).where((element) => element.state == state)
        .toList();
       
        return _jobs;   
                
      });
    }
  else{
      return jobModel.fetchStreamsDataWhere('driverId',  isEqualTo: user.id, orderBy: 'dateCreated').map<List<JobModel>>((snapshot) {
        var _jobs = snapshot.docs.map<JobModel>((doc) => 
        JobModel.fromMap({'id': doc.id, ...doc.data() as Map}))
        .where((element) => element.state == state)
        .toList();   
            
        return _jobs;            
      });
    }
   }
 
//fetch Jobs
  Stream<List<JobModel>> fetchJobs(UserModel user) {
 if(user.userRole == UserWidgetType.admin || user.userRole == UserWidgetType.manager){
      return jobModel.fetchStreamsData(orderBy: 'dateCreated').map<List<JobModel>>((snapshot) {
        var _jobs = snapshot.docs.map<JobModel>((doc) {

        return JobModel.fromMap({'id': doc.id, ...doc.data() as Map});}
        ).toList();
        jobs.clear();
        jobs.addAll(_jobs);
        return _jobs;   
                
      });
    }
  else{
      return jobModel.fetchStreamsDataWhere('driverId',  isEqualTo: user.id, orderBy: 'dateCreated').map<List<JobModel>>((snapshot) {
        var _jobs = snapshot.docs.map<JobModel>((doc) => 
        JobModel.fromMap({'id': doc.id, ...doc.data() as Map})).toList();   
        jobs.clear();
        jobs.addAll(_jobs);        
        return _jobs;            
      });
    }
   }
  //fetch job per trucks

  Future<List<JobModel>> fetchJobsByTruck(String truckId) async {
    var trucks = await jobModel.fetchWhereData('vehicleId', isEqualTo: truckId);

    return  trucks.map<JobModel>((truck) =>
        JobModel.fromMap({'id': truck.id,...truck.data()})).toList();
  
  }
   Future<bool> addJob(JobModel jobs) async{
    await jobModel.saveOnline(jobs.asMap());
    return true;
  }
  
  // update job state
  Future<bool> updateJobState(String jobId, OrderWidgateState jobState) async{
    await jobModel.updateOnline(jobId, {
      'state': jobState.value,
      if(jobState == OrderWidgateState.Open || jobState == OrderWidgateState.Rejected) 'dateApproved': DateTime.now().toIso8601String(),
      if(jobState == OrderWidgateState.Rejected) 'dateClosed': DateTime.now().toIso8601String(),
      'dateRejected': DateTime.now().toIso8601String(),
      if(jobState == OrderWidgateState.Closed) 'dateClosed': DateTime.now().toIso8601String(),
    });
    return true;
  }
    //fetch by vehicle id
   Future<List<JobModel>> fetchJobsByVehicleId(String _vid)async{
    return (await jobModel.fetchWhereData('vehicleId', isEqualTo: _vid, orderBy: 'dateCreated')).
      map((documentSnapshot) {
      return JobModel.fromMap({'id': documentSnapshot.id, ...documentSnapshot.data()});
    }).toList();
  }
  
  TrucksModel? getTruckById(String _truckId){
    final _trucks = trucks.where((truck) => truck.id == _truckId).toList();
    if(_trucks.isNotEmpty){
      return _trucks.first;
    }
  }

//update job details
Future<ResponseModel> updateJob(String id,Map<String, dynamic> map)async{
  await jobModel.updateOnline(id, map);
  return ResponseModel(ResponseType.success, 'Job Updated');
}
  // update state
  JobModel? getJobById(String _jobId){
    final _jobs = jobs.where((job) => job.id == _jobId).toList();
    if(_jobs.isNotEmpty){
      return _jobs.first;
    }
  }
  // fetch all jobs
  Stream<List<JobModel>> fetchAllJobs(){
      return jobModel.fetchStreamsData(orderBy: 'dateCreated').map<List<JobModel>>((snapshot) {
        var jobModel = snapshot.docs.map<JobModel>((doc) {

        return JobModel.fromMap({'id': doc.id, ...doc.data() as Map});}
        ).toList();

        jobs.clear();
        jobs.addAll(jobModel);
       return jobModel;   
                
      });
    
  }

//delete Job
  Future<void> deleteJob(String jobId, orderId) async{
    OrderModel orderModel=OrderModel();
    //fetchjobs and get order id 
    await orderModel.deleteOnline(orderId);
    await jobModel.deleteOnline(jobId);

    // delete expenses
    final ExpenseModule expenseModule = ExpenseModule();
    final List<ExpenseModel> _exs =await expenseModule.fetchByJobExpensesNoUser(jobId).first;
    for(var x in _exs){
      x.deleteOnline(x.id ?? 'null');
    }
  }
}
  
