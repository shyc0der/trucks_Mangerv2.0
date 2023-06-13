// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/trucks_model.dart';

import '../models/response_model copy.dart';

class TruckModules extends GetxController {
  final TrucksModel _trucksModel = TrucksModel();
  RxList<TrucksModel> trucks = <TrucksModel>[].obs;

  void init() {
    // fetch jobs, drivers & truck
    fetchTrucks();
  }

  Future<List<TrucksModel>> fetchTrucks() async {
    var trucks2 = (await _trucksModel.fetchStreamsData().first)
        .docs
        .map<Future<TrucksModel>>((doc) async {
      var t = TrucksModel.fromMap({'id': doc.id, ...doc.data() as Map});

      t.reportTotal = await t.getTotals(DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 30)),
          end: DateTime.now()));
      return t;
    }).toList();

    List<TrucksModel> _trucks = [];

    for (var f in trucks2) {
     
      _trucks.add(await f);
    }
 List<TrucksModel> removeDefaultTruck =  _trucks.where((element) => element.vehicleRegNo != "DEFAULT VEHICLE").toList();
    trucks.clear();
    trucks.addAll(removeDefaultTruck);
    return trucks;
  }

  TrucksModel? getTruckById(String? truckId) {
    final _trucks = trucks.where((truck) => truck.id == truckId).toList();
    if (_trucks.isNotEmpty) {
      return _trucks.first;
    }
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

  Future<Map<String, String>> fetchTrucksReges() async {
    final Map<String, String> _map = {}; // {'id': 'registration'}
    final _trucks = await _trucksModel.fetchData();
    for (var truck in _trucks) {
      if (truck.id != "EVwLiKI3Bazd6vLakBWt") {
          _map.addAll({truck.id: truck.data()['vehicleRegNo']});
      }
   
    }

    return _map;
  }

  Future<TrucksModel> fetchTruckById(String truckId) async {
    final _docSnapshot = await _trucksModel.fetchDataById(truckId);
    return TrucksModel.fromMap(
        {'id': _docSnapshot.id, ...(_docSnapshot.data() ?? {})});
  }

  Future<bool> addTruck(TrucksModel truckModel) async {
    await _trucksModel.saveOnline(truckModel.asMap());

    return true;
  }

  // update truck
  Future<ResponseModel> updateTruck(String id, Map<String, dynamic> map) async {
    await _trucksModel.updateOnline(id, map);
    return ResponseModel(ResponseType.success, 'Truck updated');
  }
}
//list of jobs per expenses
//get amount
