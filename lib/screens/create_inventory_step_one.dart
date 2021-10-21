import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constant.dart';
import '../core/store.dart';
import '../core/firebase_methods.dart';
import './create_inventory_step_two.dart';

class CreateInventoryStepOneScreen extends StatefulWidget {
  @override
  _CreateInventoryStepOneScreenState createState() =>
      _CreateInventoryStepOneScreenState();
}

class _CreateInventoryStepOneScreenState
    extends State<CreateInventoryStepOneScreen> {
  final _formKey = GlobalKey<FormState>();
  MyStore store = VxState.store;

  String _inventoryName;
  String _street;
  String _city;
  String _state = "Florida";
  String _zipCode;

  void _save() async {
    if (_formKey.currentState.validate()) {
      ToggleLoading();

      await Future.delayed(Duration(seconds: 1));

      _formKey.currentState.save();

      String uid = FirebaseAuth.instance.currentUser.uid;

      String inventoryId = FirebaseMethods.createInventory(
          uid: uid,
          name: _inventoryName,
          street: _street,
          city: _city,
          state: _state,
          zip: _zipCode);

      ToggleLoading();

      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (ctx) =>
              CreateInventoryStepTwoScreen(inventoryId: inventoryId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                buildBackContainer(mq),
                buildInputContainer(mq),
              ],
            ),
            SizedBox(
              height: mq.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBackContainer(Size mq) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: mq.height * 0.48,
          decoration: boxDecoration(),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: mq.height * 0.05,
                ),
                buildAppBar(mq),
                const Text(
                  'STEP 1',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Raleway'),
                ),
                SizedBox(
                  height: mq.height * 0.015,
                ),
                const Text(
                  'If you are creating a list for yourself,',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.8,
                      fontFamily: 'Raleway'),
                ),
                const Text(
                  'enter your legal name',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.8,
                      fontFamily: 'Raleway'),
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                const Text(
                  'If you are creating a list for',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.8,
                      fontFamily: 'Raleway'),
                ),
                const Text(
                  'someone else, enter their legal name',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.8,
                      fontFamily: 'Raleway'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAppBar(Size mq) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget buildInputContainer(Size mq) {
    return Card(
      margin: EdgeInsets.only(
          top: mq.height * 0.37, left: mq.width * 0.06, right: mq.width * 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 1,
      child: Container(
        padding: EdgeInsets.all(mq.width * 0.05),
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildNameField(),
              SizedBox(height: mq.height * 0.02),
              buildStreetAddressField(),
              SizedBox(height: mq.height * 0.02),
              buildCityField(),
              SizedBox(height: mq.height * 0.02),
              buildStateField(),
              SizedBox(height: mq.height * 0.02),
              buildZIPCodeField(),
              SizedBox(height: mq.height * 0.02),
              VxBuilder(
                  builder: (_, __, ___) {
                    return store.isLoading == true
                        ? SpinKitHourGlass(color: kPrimaryColor)
                        : buildSaveAndExitButton(mq);
                  },
                  mutations: {ToggleLoading}),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNameField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        cursorColor: kPrimaryColor,
        textCapitalization: TextCapitalization.words,
        style: textStyle(),
        decoration: InputDecoration(
          hintText: 'Legal Name*',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kInventoryNameNullError;
          }
        },
        onSaved: (_value) {
          _inventoryName = _value;
        },
      ),
    );
  }

  Widget buildStreetAddressField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        style: textStyle(),
        textCapitalization: TextCapitalization.words,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: 'Street Address*',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kStreetNullError;
          }
        },
        onSaved: (_value) {
          _street = _value;
        },
      ),
    );
  }

  Widget buildCityField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        style: textStyle(),
        textCapitalization: TextCapitalization.words,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: 'City*',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kCityNullError;
          }
        },
        onSaved: (_value) {
          _city = _value;
        },
      ),
    );
  }

  Widget buildStateField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        style: textStyle(),
        textCapitalization: TextCapitalization.words,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: 'State*',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        initialValue: _state,
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kStateNullError;
          }
        },
        onSaved: (_value) {
          _state = _value;
        },
      ),
    );
  }

  Widget buildZIPCodeField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        style: textStyle(),
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: 'ZIP Code*',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kZipCodeNullError;
          }
        },
        onSaved: (_value) {
          _zipCode = _value;
        },
      ),
    );
  }

  Widget buildSaveAndExitButton(Size mq) {
    return GestureDetector(
      onTap: _save,
      child: Container(
        height: mq.height * 0.06,
        width: mq.width * 0.52,
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
            'Save And Continue',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
