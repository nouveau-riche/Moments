import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constant.dart';
import '../core/store.dart';
import './login_screen.dart';
import '../widgets/inventory.dart';
import '../core/authentication.dart';
import '../models/inventory_model.dart';
import './create_inventory_step_one.dart';
import '../models/inventory_details_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;

  MyStore store = VxState.store;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 22,
              width: 22,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'WHO GETS THIS',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Raleway',
              ),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Authentication.signOut().whenComplete(() {
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(builder: (ctx) => LogInScreen()),
                        (route) => false);
                  });
                },
                child: Text('Logout'))
          ],
        ),
      ),
      body: buildFetchInventories(mq),
      floatingActionButton: buildCreateInventoryButton(context, mq),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildNoInventoryFound(Size mq) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: mq.height * 0.14,
          ),
          Container(
            height: mq.height * 0.24,
            width: mq.width * 0.54,
            color: Colors.grey[100],
            child: Image.asset(
              'assets/images/empty.png',
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          const Text(
            'You don’t have a PPM list',
            style: TextStyle(
              fontSize: 18.5,
              fontFamily: 'Raleway',
            ),
          ),
          const Text(
            'Let\'s Create a Memorandum',
            style: TextStyle(
              fontSize: 18.5,
              fontFamily: 'Raleway',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFetchInventories(Size mq) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('inventories')
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;

          List<InventoryModel> list = [];

          data.docs.forEach((element) async {
            List<InventoryDetailModel> inventoryDetailsList = [];

            if (element.data()['inventoryData'] != null) {
              element.data()['inventoryData'].forEach((key, val) async {
                await NetworkAssetBundle(Uri.parse(val['image']))
                    .load("")
                    .then((value) {
                  inventoryDetailsList.add(
                    InventoryDetailModel(
                      id: key,
                      gift: val['gift'],
                      description: val['description'],
                      history: val['history'],
                      relationship: val['relationship'],
                      imageUrl: val['image'],
                      byteData: value,
                    ),
                  );
                });
              });

              list.add(InventoryModel(
                id: element.data()['id'],
                title: element.data()['name'],
                date: element.data()['date'].toDate(),
                state: element.data()['state'],
                street: element.data()['street'],
                zip: element.data()['zip'],
                city: element.data()['city'],
                total: element.data()['inventoryData'].length,
                list: inventoryDetailsList,
              ));
            }
          });

          return list.length == 0
              ? buildNoInventoryFound(mq)
              : Column(
                  children: [
                    SizedBox(
                      height: mq.height * 0.04,
                    ),
                    Text(
                      'Your Memorandums',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Raleway'),
                    ),
                    SizedBox(
                      height: mq.height * 0.07,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) =>
                          Inventory(inventoryModel: list[index]),
                      itemCount: list.length,
                    ),
                  ],
                );
        } else {
          return buildNoInventoryFound(mq);
        }
      },
    );
  }

  Widget buildCreateInventoryButton(BuildContext context, Size mq) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (ctx) => CreateInventoryStepOneScreen(),
          ),
        );
      },
      child: Container(
        height: mq.height * 0.065,
        width: mq.width * 0.58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [kPrimaryColor.withOpacity(0.8), kPrimaryColor],
          ),
        ),
        child: Center(
          child: const Text(
            'Create New Memorandum',
            style: TextStyle(
                fontSize: 14, fontFamily: 'Raleway', color: Colors.white),
          ),
        ),
      ),
    );
  }
}
