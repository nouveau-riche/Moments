import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromRGBO(58, 76, 148, 1);
const kSecondaryColor = Color.fromRGBO(247, 245, 255, 1);
const kButtonColor = Color.fromRGBO(0, 102, 0, 1);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

const String kEmailNullError = "Please enter your email";
const String kInvalidEmailError = "Please enter valid Email";
const String kPassNullError = "Please enter your password";
const String kShortPassError =
    "Password length should be more than five\neg: 123456";
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

BoxDecoration boxDecoration() {
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
      fontSize: 13.5,
      color: Colors.black87,
      fontFamily: 'Raleway');
}

TextStyle hintStyle() {
  return TextStyle(
      fontSize: 13,
      color: Colors.black87,
      fontFamily: 'Raleway');
}

InputBorder border() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(2),
    borderSide: BorderSide(
      color: kPrimaryColor.withOpacity(0.5),
    ),
  );
}

InputBorder focusedBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(2),
    borderSide: const BorderSide(
      width: 1.5,
      color: kPrimaryColor,
    ),
  );
}

List<String> allRelationship = [
  'Select Relationship',
  'Spouse',
  'Child',
  'Partner',
  'Grandchild',
  'Sibling',
  'Parent',
  'Relative',
  'Child-In-Law',
  'Friend',
  'Charity',
  'Organization',
  'Other',
];

List<DropdownMenuItem> stateDropDownList = [
  DropdownMenuItem(
    child: const Text(
      'Select Relationship*',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.black87),
    ),
    value: 0,
  ),
  DropdownMenuItem(
    child: const Text(
      'Spouse',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.black87),
    ),
    value: 1,
  ),
  DropdownMenuItem(
    child: const Text(
      'Child',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          fontSize: 13.5,
          color: Colors.black87),
    ),
    value: 2,
  ),
  DropdownMenuItem(
    child: const Text(
      'Partner',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          fontSize: 13.5,
          color: Colors.black87),
    ),
    value: 3,
  ),
  DropdownMenuItem(
    child: const Text(
      'Grandchild',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          fontSize: 13.5,
          color: Colors.black87),
    ),
    value: 4,
  ),
  DropdownMenuItem(
    child: const Text(
      'Sibling',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.black87),
    ),
    value: 5,
  ),
  DropdownMenuItem(
    child: const Text(
      'Parent',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          fontSize: 13.5,
          color: Colors.black87),
    ),
    value: 6,
  ),
  DropdownMenuItem(
    child: const Text(
      'Relative',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.black87),
    ),
    value: 7,
  ),
  DropdownMenuItem(
    child: const Text(
      'Child-In-Law',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.black87),
    ),
    value: 8,
  ),
  DropdownMenuItem(
    child: const Text(
      'Friend',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.black87),
    ),
    value: 9,
  ),
  DropdownMenuItem(
    child: const Text(
      'Charity',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.black87),
    ),
    value: 10,
  ),
  DropdownMenuItem(
    child: const Text(
      'Organization',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.black87),
    ),
    value: 11,
  ),
  DropdownMenuItem(
    child: const Text(
      'Other',
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.black87),
    ),
    value: 12,
  ),
];
