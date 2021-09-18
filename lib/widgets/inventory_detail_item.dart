import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constant.dart';
import '../models/inventory_details_model.dart';
import '../screens/edit_inventory_screen.dart';

class InventoryDetailItem extends StatelessWidget {
  final String inventoryId;
  final InventoryDetailModel inventoryDetailModel;

  InventoryDetailItem({this.inventoryId, this.inventoryDetailModel});

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: inventoryDetailModel.imageUrl,
              imageBuilder: (context, imageProvider) => Card(
                elevation: 10,
                shadowColor: Color(0xfff1edff),
                color: Colors.white,
                shape:
                    CircleBorder(side: BorderSide(color: Colors.transparent)),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: imageProvider,
                  backgroundColor: Colors.white,
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(
                value: downloadProgress.progress,
                backgroundColor: kPrimaryColor,
                color: Colors.grey[100],
              ),
              errorWidget: (context, url, error) => Icon(Icons.unarchive),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildData('Gift: ', inventoryDetailModel.gift),
                const SizedBox(
                  height: 5,
                ),
                buildData('History: ', inventoryDetailModel.history),
                const SizedBox(
                  height: 5,
                ),
                buildData('Realtionship: ', inventoryDetailModel.relationship),
              ],
            ),
            Spacer(),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (ctx) => EditInventoryScreen(
                          inventoryId: inventoryId,
                          inventoryDetailModel: inventoryDetailModel,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 20,
                    width: 25,
                    child: Image.asset('assets/images/edit.png'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    openDialogBox(context);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildData(String type, String data) {
    if (data.length > 12) {
      data = '${data.substring(0, 11)}...';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          type,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          data,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  openDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: kPrimaryColor.withOpacity(0.95),
        title: const Text(
          'Do you want to delete the item ?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "CANCEL",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              final uid = FirebaseAuth.instance.currentUser.uid;

              final ref = FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('inventories')
                  .doc(inventoryId);

              ref.update({
                'inventoryData.${inventoryDetailModel.id}': FieldValue.delete(),
              });
              Navigator.of(context).pop();
            },
            child: const Text(
              "DELETE",
              style: const TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
