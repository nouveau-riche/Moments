import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromRGBO(104, 81, 255, 1);
const kSecondaryColor = Color.fromRGBO(247, 245, 255, 1);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

const String kEmailNullError = "Please enter your email";
const String kInvalidEmailError = "Please enter valid Email";
const String kPassNullError = "Please enter your password";
const String kShortPassError = "Password length should be more than five\neg: 123456";
const String kNameNullError = "Please enter your name";
const String kStreetNullError = "Please enter your street";
const String kCityNullError = "Please enter your city";
const String kStateNullError = "Please enter your state";
const String kZipCodeNullError = "Please enter your zip code";

const kInventoryNameNullError = "Please enter inventory name";
const String kItemDescriptionNullError = "Please enter description";
const String kItemHistoryNullError = "Please enter history";
const String kGiftNullError = "Please enter gift recipient";
const String kRelationshipNullError = "Please enter your relationship";

BoxDecoration boxDecoration(){
  return BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(70),
      bottomRight: Radius.circular(70),
    ),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [kPrimaryColor.withOpacity(0.65), kPrimaryColor],
    ),
  );
}

TextStyle textStyle() {
  return TextStyle(
      fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black,fontFamily: 'Raleway');
}

TextStyle hintStyle() {
  return TextStyle(
      fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black,fontFamily: 'Raleway');
}


InputBorder border(){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(2),
    borderSide: BorderSide(
      color: kPrimaryColor.withOpacity(0.5),
    ),
  );
}

InputBorder focusedBorder(){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(2),
    borderSide: const BorderSide(
      width: 1.5,
      color: kPrimaryColor,
    ),
  );
}
