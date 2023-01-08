// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Model {
  Model(this.collectionName);
  String collectionName;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //String? id;
  static Future<void> initiateDbs() async {
    try {
      await Firebase.initializeApp(
      //     options: const FirebaseOptions(
      //   apiKey: 'AIzaSyDwn4T6UwLMqLLD5w7jARWVJabiS7DyAmY',
      //   appId: '1:834602052606:web:0852fa8eedae2746682eaf',
      //   messagingSenderId: '834602052606',
      //   projectId: 'trucks-c05a8',
      //   databaseURL: "https://trucks-c05a8.firebaseio.com",
      //   storageBucket: "trucks-c05a8.appspot.com",
      //   measurementId: "G-6CQQ394FHP",
      // )
      ).whenComplete(() {
        print("complete");
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> saveOnline(
      Map<String, dynamic> map) async {
    // DocumentReference _dr =
    return await firestore.collection(collectionName).add(map);
  }

  Future<void> saveOnlineWithId(String id, Map<String, dynamic> map) async {
    await firestore.collection(collectionName).doc(id).set(map);
  }

  Future updateOnline(String id, Map<String, dynamic> map) async {
    await firestore.collection(collectionName).doc(id).update(map);
  }

  Future deleteOnline(String id) async {
    await firestore.collection(collectionName).doc(id).delete();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchData() async {
    return (await firestore.collection(collectionName).get()).docs;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchDataById(
      String id) async {
    return (await firestore.collection(collectionName).doc(id).get());
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchStreamsDataById(
      String id) {
    return firestore.collection(collectionName).doc(id).snapshots();
  }

  Stream<QuerySnapshot> fetchStreamsData({String? orderBy}) {
    final ref = firestore.collection(collectionName);
    var ref2;
    if (orderBy != null) {
      ref2 = ref.orderBy(orderBy, descending: true);
    } else {
      ref2 = ref;
    }
    return ref2.snapshots();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchWhereData(
    String field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
    String? orderBy,
  }) async {
    final ref = firestore.collection(collectionName);
    var ref2;
    if (orderBy != null) {
      ref2 = ref.orderBy(orderBy, descending: true);
    } else {
      ref2 = ref;
    }
    return (await ref2
            .where(
              field,
              isEqualTo: isEqualTo,
              isNotEqualTo: isNotEqualTo,
              isLessThan: isLessThan,
              isLessThanOrEqualTo: isLessThanOrEqualTo,
              isGreaterThan: isGreaterThan,
              isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
              arrayContains: arrayContains,
              arrayContainsAny: arrayContainsAny,
              whereIn: whereIn,
              whereNotIn: whereNotIn,
              isNull: isNull,
            )
            .get())
        .docs;
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>> fetchWhereModelData(
    String field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
    String? orderBy,
  }) async {
    final ref = firestore.collection(collectionName);
    var ref2;
    if (orderBy != null) {
      ref2 = ref.orderBy(orderBy, descending: true);
    } else {
      ref2 = ref;
    }
    return (await ref2
            .where(
              field,
              isEqualTo: isEqualTo,
              isNotEqualTo: isNotEqualTo,
              isLessThan: isLessThan,
              isLessThanOrEqualTo: isLessThanOrEqualTo,
              isGreaterThan: isGreaterThan,
              isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
              arrayContains: arrayContains,
              arrayContainsAny: arrayContainsAny,
              whereIn: whereIn,
              whereNotIn: whereNotIn,
              isNull: isNull,
            )
            .get())
        .docs;
  }

  Stream<QuerySnapshot> fetchStreamsDataWhere(
    String field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
    String? orderBy,
  }) {
    final ref = firestore.collection(collectionName);
    var ref2;
    if (orderBy != null) {
      ref2 = ref.orderBy(orderBy, descending: true);
    } else {
      ref2 = ref;
    }

    return ref2
        .where(
          field,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThan: isLessThan,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThan: isGreaterThan,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          isNull: isNull,
        )
        .snapshots();
  }

  Stream<QuerySnapshot> fetchStreamsDatasWhere(
    String field,
    String field2, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
    String? orderBy,
  }) {
    final ref = firestore.collection(collectionName);
    var ref2;
    if (orderBy != null) {
      ref2 = ref.orderBy(orderBy, descending: true);
    } else {
      ref2 = ref;
    }
    return ref2
        .where(
          field,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThan: isLessThan,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThan: isGreaterThan,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          isNull: isNull,
        )
        .where(
          field2,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThan: isLessThan,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThan: isGreaterThan,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          isNull: isNull,
        )
        .snapshots();
  }
}
// options: FirebaseOptions(
//          apiKey: "AIzaSyDwn4T6UwLMqLLD5w7jARWVJabiS7DyAmY",
//          authDomain: "trucks-c05a8.firebaseapp.com",
//          projectId: "trucks-c05a8",
//          storageBucket: "trucks-c05a8.appspot.com",
//          messagingSenderId: "834602052606",
//         appId: "1:834602052606:web:7b054961f5251c90682eaf",
//         measurementId: "G-ZMXMTPH316",
//         databaseURL: "https://trucks-c05a8.firebaseio.com"

//          )
