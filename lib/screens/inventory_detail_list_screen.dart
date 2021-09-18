import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constant.dart';
import '../widgets/inventory_detail_item.dart';
import '../models/inventory_details_model.dart';

class InventoryDetailScreen extends StatelessWidget {
  final String inventoryId;

  InventoryDetailScreen({this.inventoryId});

  final uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
        centerTitle: true,
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Row(
          children: [
            SizedBox(
              width: mq.width * 0.09,
            ),
            Container(
              height: 38,
              width: 34,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              children: [
                Text(
                  'Personal Property',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  'Memo',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('inventories')
            .doc(inventoryId)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;

            List<InventoryDetailModel> inventoryDetailsList = [];

            data['inventoryData'].forEach((key, val) {
              inventoryDetailsList.add(
                InventoryDetailModel(
                  id: key,
                  gift: val['gift'],
                  description: val['description'],
                  history: val['history'],
                  address: val['address'],
                  relationship: val['relationship'],
                  imageUrl: val['image'],
                ),
              );
            });

            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (ctx, index) => InventoryDetailItem(
                inventoryId: inventoryId,
                inventoryDetailModel: inventoryDetailsList[index],
              ),
              itemCount: inventoryDetailsList.length,
            );
          } else {
            return Text('No inventories');
          }
        },
      ),
    );
  }
}
