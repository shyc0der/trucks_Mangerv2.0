// import 'dart:io';

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadPics(XFile image, String folder) async {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //Create a reference to the location you want to upload to in firebase
  Reference reference = _storage.ref().child("$folder/${image.name}");

  //Upload the file to firebase

  // UploadTask uploadTask = reference.putFile(File(image.path));
  UploadTask uploadTask = reference.putData(await image.readAsBytes());
  await uploadTask.whenComplete(() {});

  // Waits till the file is uploaded then stores the download url
  String location = await uploadTask.snapshot.ref.getDownloadURL();

  //returns the download url
  return location;
}
