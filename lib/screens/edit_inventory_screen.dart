import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constant.dart';
import '../widgets/taost.dart';
import '../widgets/center_loader.dart';
import '../core/firebase_methods.dart';
import '../models/inventory_details_model.dart';

class EditInventoryScreen extends StatefulWidget {
  final String inventoryId;
  final InventoryDetailModel inventoryDetailModel;

  EditInventoryScreen({this.inventoryId, this.inventoryDetailModel});

  @override
  _EditInventoryScreenState createState() => _EditInventoryScreenState();
}

class _EditInventoryScreenState extends State<EditInventoryScreen> {
  final _formKey = GlobalKey<FormState>();

  int index = 0;

  String _itemDescription;
  String _itemHistory;
  String _giftRecipient;
  String _relationship;
  String _imageUrl;
  String _address;

  @override
  void initState() {
    super.initState();
    setState(() {
      _imageUrl = widget.inventoryDetailModel.imageUrl;
      _itemDescription = widget.inventoryDetailModel.description;
      _itemHistory = widget.inventoryDetailModel.history;
      _giftRecipient = widget.inventoryDetailModel.gift;
      _relationship = widget.inventoryDetailModel.relationship;
      _address = widget.inventoryDetailModel.address;

      int ind = allRelationship.indexWhere((element) {
        if (element == widget.inventoryDetailModel.relationship) {
          return true;
        }
        return false;
      });

      index = ind;
    });
  }

  void _save() async {
    if (_formKey.currentState.validate()) {
      if (index == 0) {
        toast('Select Relationship', true);
        return;
      }

      showCenterLoader(context, MediaQuery.of(context).size,
          'Please wait, this may take \na moment');

      if (image != null) {
        _imageUrl = await FirebaseMethods.uploadImageToFirebase(image: image);
      }

      _formKey.currentState.save();

      String uid = FirebaseAuth.instance.currentUser.uid;

      FirebaseMethods.editInventory(
          uid: uid,
          inventoryId: widget.inventoryId,
          inventoryDataId: widget.inventoryDetailModel.id,
          gift: _giftRecipient,
          history: _itemHistory,
          address: _address,
          description: _itemDescription,
          relationship: _relationship,
          imageUrl: _imageUrl);

      Navigator.of(context).pop();

      toast('Memorandum Edited', false);

      Navigator.of(context).pop();
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
                SizedBox(
                  height: mq.height * 0.04,
                ),
                const Text(
                  'Edit',
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
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w800),
            ),
            Text(
              'Memo',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildInputContainer(Size mq) {
    return Card(
      margin: EdgeInsets.only(
          top: mq.height * 0.32, left: mq.width * 0.06, right: mq.width * 0.06),
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
                  'Add Item Image',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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

  openDialogBox() {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: kPrimaryColor,
              children: <Widget>[
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
                    child: const Text(
                      "Pick Image from Gallery",
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      pickImageFromGallery();
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
          openDialogBox();
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
                image == null ? 'Edit Photo' : 'Photo Added',
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
          hintText: 'Add Item Description',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        initialValue: _itemDescription,
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

  Widget buildItemHistoryField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        cursorColor: kPrimaryColor,
        style: textStyle(),
        decoration: InputDecoration(
          hintText: 'How did you obtain?',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        initialValue: _itemHistory,
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
          hintText: 'Add Gift Recipient',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        initialValue: _giftRecipient,
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

  Widget buildAddressField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        maxLines: 2,
        cursorColor: kPrimaryColor,
        style: textStyle(),
        decoration: InputDecoration(
          hintText: 'Add Address',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        initialValue: _address,
        onSaved: (_value) {
          _address = _value;
        },
      ),
    );
  }

  Widget buildAddRelationshipField(Size mq) {
    return Container(
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

  Widget buildSaveButton(Size mq) {
    return GestureDetector(
      onTap: _save,
      child: Container(
        height: mq.height * 0.055,
        width: mq.width * 0.3,
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
            'EDIT & SAVE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Raleway',
            ),
          ),
        ),
      ),
    );
  }
}
