import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constant.dart';
import '../core/pdf_api.dart';
import '../core/firebase_methods.dart';
import '../models/inventory_model.dart';
import '../screens/create_inventory_step_two.dart';
import '../screens/inventory_detail_list_screen.dart';

class Inventory extends StatelessWidget {
  final InventoryModel inventoryModel;

  Inventory({this.inventoryModel});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: kPrimaryColor.withOpacity(0.8),
                child: Text(
                  inventoryModel.title[0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    inventoryModel.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                    ),
                  ),
                  Text(
                    '${DateFormat().add_yMMMd().format(inventoryModel.date)}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Raleway',
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    '${inventoryModel.total} Items added',
                    style: const TextStyle(
                        fontFamily: 'Raleway', color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              buildShowPopUp(context),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          saveAsPdfButton(mq, context),
        ],
      ),
    );
  }

  void actionPopUpItemSelected(String value, BuildContext context) {
    if (value == 'edit') {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (ctx) => InventoryDetailScreen(
            inventoryId: inventoryModel.id,
          ),
        ),
      );
    } else if (value == 'delete') {
      openDeleteAlert(context);
    } else if (value == 'view') {
      PdfApi.generatePdf(
              list: inventoryModel.list, inventoryModel: inventoryModel)
          .then((value) {
        OpenFile.open(value.path);
      });
    } else {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (ctx) => CreateInventoryStepTwoScreen(
            inventoryId: inventoryModel.id,
          ),
        ),
      );
    }
  }

  Widget buildShowPopUp(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: const Icon(CupertinoIcons.ellipsis_vertical),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'delete',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.delete,
                  color: Colors.red,
                  size: 22,
                ),
                const Text(
                  '  Delete Memo',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway'),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'edit',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 20,
                  width: 22.5,
                  child: Image.asset('assets/images/edit.png'),
                ),
                const Text(
                  '  Edit Memo',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway'),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'add',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.add_circled,
                  color: kPrimaryColor,
                ),
                const Text(
                  '  Add New',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway'),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'view',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.eye_fill,
                  color: kPrimaryColor,
                  size: 22,
                ),
                const Text(
                  '  View Memo',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway'),
                ),
              ],
            ),
          ),
        ];
      },
      onSelected: (String value) => actionPopUpItemSelected(value, context),
    );
  }

  Widget saveAsPdfButton(Size mq, BuildContext context) {
    return GestureDetector(
      onTap: () {
        openSuccessfullyCreatedDialogBox(context, mq);
      },
      child: Container(
        height: mq.height * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [kButtonColor.withOpacity(0.8), kButtonColor],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: mq.width * 0.15,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
            SizedBox(
              width: mq.width * 0.08,
            ),
            Container(
              height: 16,
              width: 16,
              child: Image.asset('assets/images/pdf.png'),
            ),
            const SizedBox(
              width: 4,
            ),
            const Text(
              'Click to Create & Send',
              style: TextStyle(
                  fontSize: 12.8,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  openSuccessfullyCreatedDialogBox(BuildContext context, Size mq) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: const Text(
          'List successfully created',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
          ),
        ),
        content: const Text(
          'Press NEXT to choose how to save the Personal Property Memo.',
          style: TextStyle(
            color: kPrimaryColor,
            fontFamily: 'Raleway',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "CANCEL",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => onSubmit(),
            child: const Text(
              "NEXT",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future onSubmit() async {

    try {
       File file = await PdfApi.generatePdf(
          list: inventoryModel.list, inventoryModel: inventoryModel);

      print(file.path);

      await Share.shareFiles(['${file.path}'], text: 'Personal Property Memorandum');

    } catch (e) {
      print(e);
    }
  }

  openDeleteAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: kPrimaryColor.withOpacity(0.95),
        title: const Text(
          'Do you want to delete the memorandum ?',
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

              FirebaseMethods.deleteInventory(
                  uid: uid, inventoryId: inventoryModel.id);
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
