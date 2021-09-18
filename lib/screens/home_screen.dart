import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:who_gets_this/widgets/drawer.dart';

import '../constant.dart';
import '../core/store.dart';
import '../widgets/inventory.dart';
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
          children: [
            SizedBox(
              width: mq.width * 0.1,
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
      drawer: MyDrawer(),
      body: buildFetchInventories(mq),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildCreateInventoryButton(context, mq),
          buildCloseButton(context, mq),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildNoInventoryFound(Size mq) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: mq.height * 0.25,
          ),
          const Text(
            'You don’t have a',
            style: TextStyle(
              color: kButtonColor,
              fontSize: 26,
              fontFamily: 'Raleway',
            ),
          ),
          const Text(
            'Personal Property',
            style: TextStyle(
              color: kButtonColor,
              fontSize: 26,
              fontFamily: 'Raleway',
            ),
          ),
          const Text(
            'Memo',
            style: TextStyle(
              color: kButtonColor,
              fontSize: 26,
              fontFamily: 'Raleway',
            ),
          ),
          SizedBox(
            height: mq.height * 0.05,
          ),
          const Text(
            'Let\'s Create a List',
            style: TextStyle(
              color: kButtonColor,
              fontSize: 26,
              fontFamily: 'Raleway',
            ),
          ),
          SizedBox(
            height: mq.height * 0.08,
          ),
          const Text(
            'Provided by',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 18,
              fontFamily: 'Raleway',
            ),
          ),
          SizedBox(
            height: mq.height * 0.01,
          ),
          const Text(
            'WhiteGloveHouse.com',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 18,
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
                      address: val['address'],
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
        width: mq.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [kButtonColor.withOpacity(0.8), kButtonColor],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Start a',
              style: TextStyle(
                  fontSize: 12, fontFamily: 'Raleway', color: Colors.white),
            ),
            const Text(
              'New Memo',
              style: TextStyle(
                  fontSize: 12, fontFamily: 'Raleway', color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCloseButton(BuildContext context, Size mq) {
    return GestureDetector(
      onTap: () {
        SystemNavigator. pop();
      },
      child: Container(
        height: mq.height * 0.065,
        width: mq.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [kButtonColor.withOpacity(0.8), kButtonColor],
          ),
        ),
        child: Center(
          child: const Text(
            'Close',
            style: TextStyle(
                fontSize: 12, fontFamily: 'Raleway', color: Colors.white),
          ),
        ),
      ),
    );
  }
}
