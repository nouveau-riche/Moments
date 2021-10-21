import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../constant.dart';
import './home_screen.dart';
import '../widgets/taost.dart';
import '../widgets/center_loader.dart';
import '../core/firebase_methods.dart';

class CreateInventoryStepTwoScreen extends StatefulWidget {
  final String inventoryId;

  CreateInventoryStepTwoScreen({this.inventoryId});

  @override
  _CreateInventoryStepTwoScreenState createState() =>
      _CreateInventoryStepTwoScreenState();
}

class _CreateInventoryStepTwoScreenState
    extends State<CreateInventoryStepTwoScreen> {
  final _formKey = GlobalKey<FormState>();

  int index = 0;

  String _itemDescription;
  String _itemHistory;
  String _giftRecipient;
  String _address;
  String _relationship = allRelationship[0];

  void _save() async {
    var uuid = Uuid();

    if (_formKey.currentState.validate()) {
      if (image == null) {
        toast('Add Image', true);
        return;
      }

      if (index == 0) {
        toast('Select Relationship', true);
        return;
      }

      showCenterLoader(context, MediaQuery.of(context).size,
          'Please wait, this may take \na moment');

      String url = await FirebaseMethods.uploadImageToFirebase(image: image);

      _formKey.currentState.save();

      String uid = FirebaseAuth.instance.currentUser.uid;

      print(uuid.v4());

      FirebaseMethods.addInventoryDetails(
        uid: uid,
        inventoryId: widget.inventoryId,
        inventoryDataId: uuid.v4().toString().substring(0, 12),
        imageUrl: url,
        address: _address,
        description: _itemDescription,
        gift: _giftRecipient,
        history: _itemHistory,
        relationship: _relationship,
      );

      Navigator.of(context).pop();

      toast('Memorandum Saved', false);

      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (ctx) => HomeScreen()), (route) => false);
    }
  }

  void _addMore() async {
    var uuid = Uuid();

    if (_formKey.currentState.validate()) {
      if (image == null) {
        toast('Add Image', true);
        return;
      }

      if (index == 0) {
        toast('Select Relationship', true);
        return;
      }

      showCenterLoader(context, MediaQuery.of(context).size,
          'Please wait, this may take \na moment');

      _formKey.currentState.save();

      String url = await FirebaseMethods.uploadImageToFirebase(image: image);

      String uid = FirebaseAuth.instance.currentUser.uid;

      FirebaseMethods.addInventoryDetails(
        uid: uid,
        inventoryId: widget.inventoryId,
        inventoryDataId: uuid.v4().toString().substring(0, 12),
        imageUrl: url,
        description: _itemDescription,
        gift: _giftRecipient,
        address: _address,
        history: _itemHistory,
        relationship: _relationship,
      );

      Navigator.of(context).pop();

      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
            builder: (ctx) =>
                CreateInventoryStepTwoScreen(inventoryId: widget.inventoryId)),
      );
    }
  }

  File image;
  final picker = ImagePicker();

  Future pickImageFromGallery() async {
    try {
      final imageFile = await picker.getImage(source: ImageSource.gallery);
      print(imageFile);
      if (mounted && imageFile != null) {
        image = File(imageFile.path);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future captureImageFromCamera() async {
    try {
      final imageFile = await picker.getImage(source: ImageSource.camera);
      print(imageFile);
      if (mounted && imageFile != null) {
        image = File(imageFile.path);
        setState(() {});
      }
    } catch (e) {
      print(e);
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
          height: mq.height * 0.55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(70),
              bottomRight: Radius.circular(70),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kPrimaryColor.withOpacity(0.65), kPrimaryColor],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: mq.height * 0.05,
                ),
                buildAppBar(mq),
                const Text(
                  'STEP 2',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                const Text(
                  'Let\'s Create a',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Raleway',
                  ),
                ),
                const Text(
                  'Memo',
                  style: TextStyle(
                      color: Colors.white, fontSize: 26, fontFamily: 'Raleway'),
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
          top: mq.height * 0.34, left: mq.width * 0.06, right: mq.width * 0.06),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Item Image*',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Raleway',
                      fontSize: 14,
                      color: Colors.black),
                ),
                SizedBox(height: mq.height * 0.02),
                Row(
                  children: [
                    if (image != null)
                      Container(
                        height: mq.height * 0.06,
                        width: mq.height * 0.065,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (image != null)
                      const SizedBox(
                        width: 8,
                      ),
                    buildAddImageField(mq),
                  ],
                ),
                SizedBox(height: mq.height * 0.02),
                buildAddDescriptionField(),
                SizedBox(height: mq.height * 0.02),
                buildItemHistoryField(),
                SizedBox(height: mq.height * 0.02),
                buildAddGiftField(),
                SizedBox(height: mq.height * 0.02),
                buildAddressField(),
                SizedBox(height: mq.height * 0.02),
                buildAddRelationshipField(mq),
                SizedBox(height: mq.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildAddMoreButton(mq),
                    buildSaveButton(mq),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openDialogBoxForImage() {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: kPrimaryColor,
              children: <Widget>[
                SimpleDialogOption(
                    child: const Text(
                      "Pick Image from Gallery",
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      pickImageFromGallery();
                    }),
                SimpleDialogOption(
                    child: const Text(
                      "Capture Image with Camera",
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      captureImageFromCamera();
                    }),
                SimpleDialogOption(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const Text(
                          "Cancel",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }

  Widget buildAddImageField(Size mq) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          openDialogBoxForImage();
        },
        child: Container(
          height: mq.height * 0.065,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [kButtonColor.withOpacity(0.8), kButtonColor],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.photo_fill,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                image == null ? 'Add Photo' : 'Photo Added',
                style: const TextStyle(
                    fontSize: 15, fontFamily: 'Raleway', color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddDescriptionField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        maxLines: 4,
        cursorColor: kPrimaryColor,
        style: textStyle(),
        decoration: InputDecoration(
          hintText: 'Add Item Description*',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kItemDescriptionNullError;
          }
        },
        onSaved: (_value) {
          _itemDescription = _value;
        },
      ),
    );
  }

  Widget buildAddressField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        maxLines: 2,
        cursorColor: kPrimaryColor,
        style: textStyle(),
        decoration: InputDecoration(
          hintText: 'Add Recipient’s Address',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        onSaved: (_value) {
          _address = _value;
        },
      ),
    );
  }

  Widget buildItemHistoryField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        cursorColor: kPrimaryColor,
        style: textStyle(),
        decoration: InputDecoration(
          hintText: 'Where Did You Get This?',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        onSaved: (_value) {
          _itemHistory = _value;
        },
      ),
    );
  }

  Widget buildAddGiftField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        cursorColor: kPrimaryColor,
        style: textStyle(),
        decoration: InputDecoration(
          hintText: 'Add Gift Recipient\'s Name*',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kGiftNullError;
          }
        },
        onSaved: (_value) {
          _giftRecipient = _value;
        },
      ),
    );
  }

  Widget buildAddRelationshipField(Size mq) {
    return Container(
      height: mq.height * 0.07,
      width: mq.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.black.withOpacity(0.35),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: index,
          items: stateDropDownList,
          onChanged: (value) {
            setState(() {
              index = value;
            });

            _relationship = allRelationship[index];
          },
        ),
      ),
    );
  }

  Widget buildAddMoreButton(Size mq) {
    return GestureDetector(
      onTap: _addMore,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        width: mq.width * 0.36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [kButtonColor.withOpacity(0.8), kButtonColor],
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Save & Add',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Raleway',
              ),
            ),
            Text(
              'another item',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Raleway',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSaveButton(Size mq) {
    return GestureDetector(
      onTap: _save,
      child: Container(
        width: mq.width * 0.36,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [kButtonColor.withOpacity(0.8), kButtonColor],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Save & Continue',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Raleway',
              ),
            ),
            Text(
              'to Next Step',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Raleway',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
