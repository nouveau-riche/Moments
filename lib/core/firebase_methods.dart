import 'dart:io';

import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../core/store.dart';

final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;
MyStore store = VxState.store;

class FirebaseMethods {
  static void saveUserToFirebase({String uid, String name, String email}) {
    final ref = db.collection('users').doc(uid);
    ref.set({
      'id': uid,
      'name': name,
      'email': email,
    });
  }

  static String createInventory(
      {String uid,
      String name,
      String street,
      String city,
      String state,
      String zip}) {
    final ref = db.collection('users').doc(uid).collection('inventories').doc();

    ref.set({
      'id': ref.id,
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'date': Timestamp.now(),
    });

    return ref.id;
  }

  static void addInventoryDetails(
      {String uid,
      String inventoryId,
      String inventoryDataId,
      String imageUrl,
      String description,
      String history,
      String address,
      String gift,
      String relationship}) {
    final ref = db
        .collection('users')
        .doc(uid)
        .collection('inventories')
        .doc(inventoryId);
    ref.update({
      'inventoryData.$inventoryDataId': {
        'inventoryId': '$inventoryDataId',
        'image': imageUrl,
        'description': description,
        'history': history,
        'address': address,
        'gift': gift,
        'relationship': relationship,
      },
    });
  }

  static void deleteInventory({String uid, String inventoryId}) {
    final ref = db
        .collection('users')
        .doc(uid)
        .collection('inventories')
        .doc(inventoryId);

    ref.delete();
  }

  static void editInventory(
      {String uid,
      String inventoryId,
      String inventoryDataId,
      String imageUrl,
      String description,
      String address,
      String history,
      String gift,
      String relationship}) {
    final ref = db
        .collection('users')
        .doc(uid)
        .collection('inventories')
        .doc(inventoryId);

    ref.update({
      'inventoryData.$inventoryDataId': {
        'inventoryId': '$inventoryDataId',
        'image': imageUrl,
        'description': description,
        'history': history,
        'gift': gift,
        'address': address,
        'relationship': relationship,
      }
    });
  }

  static Future<String> uploadImageToFirebase({File image}) async {
    String downloadUrl;
    String fileName = '${image.path}/${DateTime.now()}';
    final ref = storage.ref().child('images');
    UploadTask uploadTask = ref.child(fileName).putFile(image);
    await uploadTask.whenComplete(() async {
      downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
    });
    return downloadUrl;
  }
}
