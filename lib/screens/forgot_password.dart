import 'package:flutter/material.dart';
import 'package:who_gets_this/widgets/taost.dart';

import '../constant.dart';
import '../core/authentication.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _email;
  final _formKey = GlobalKey<FormState>();

  void _reset() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        Authentication.resetPasswordWithEmail(_email);

        toast('Email successfully sent',false);
      } catch (error) {
        const errorMessage = 'Internet connection too slow';
        toast(errorMessage,true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mq.height * 0.08,
            ),
            Text(
              'Change your password',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,color: kPrimaryColor, fontFamily: 'Raleway'),
            ),
            SizedBox(
              height: mq.height * 0.02,
            ),
            Text(
              'You will recieve the password reset link to this email',
              style: TextStyle(fontSize: 12, color: kSecondaryColor),
            ),
            SizedBox(
              height: mq.height * 0.06,
            ),
            Form(
              key: _formKey,
              child: buildEmailField(),
            ),
            SizedBox(
              height: mq.height * 0.06,
            ),
            buildResetButton(mq),
          ],
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.white,
      child: TextFormField(
        cursorColor: kPrimaryColor,
        style: textStyle(),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kEmailNullError;
          }
          bool emailValid = emailValidatorRegExp.hasMatch(_value);
          if (!emailValid) {
            return kInvalidEmailError;
          }
        },
        onSaved: (_value) {
          _email = _value;
        },
      ),
    );
  }

  Widget buildResetButton(Size mq) {
    return SizedBox(
      width: mq.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kButtonColor,
          elevation: 1,
        ),
        onPressed: _reset,
        child: const Text(
          'Reset',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}