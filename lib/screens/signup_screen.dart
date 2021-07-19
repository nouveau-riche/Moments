import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../core/store.dart';
import '../constant.dart';
import './login_screen.dart';
import '../widgets/taost.dart';
import '../core/authentication.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  MyStore store = VxState.store;

  String _name;
  String _email;
  String _password;

  void _save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        Authentication.signUpUserFromFirebase(
            context: context, name: _name, email: _email, password: _password);
      } catch (error) {
        const errorMessage = 'Internet connection too slow';
        toast(errorMessage, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: mq.height,
          ),
          child: Stack(
            children: [
              buildBackContainer(context, mq),
              buildInputContainer(mq),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBackContainer(BuildContext context, Size mq) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      'WHO GETS THIS',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                SizedBox(
                  height: mq.height * 0.05,
                ),
                const Text(
                  'Signup',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 248, 52, 1),
                      fontSize: 38,
                      fontFamily: 'Raleway'),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        VxBuilder(
          builder: (_, __, ___) {
            return store.isLoading == false
                ? buildSignUpButton(mq)
                : SpinKitHourGlass(
                    color: kPrimaryColor,
                  );
          },
          mutations: {ToggleLoading},
        ),
        buildHaveAccount(context),
        SizedBox(
          height: mq.height * 0.025,
        ),
      ],
    );
  }

  Widget buildInputContainer(Size mq) {
    return Positioned(
      left: mq.width * 0.06,
      right: mq.width * 0.06,
      top: mq.height * 0.36,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 1,
        child: Container(
          width: mq.width * 0.8,
          padding: EdgeInsets.symmetric(
              horizontal: mq.width * 0.05, vertical: mq.height * 0.04),
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
                buildEmailField(),
                SizedBox(height: mq.height * 0.02),
                buildPasswordField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNameField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        style: textStyle(),
        cursorColor: kPrimaryColor,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: 'Name',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kNameNullError;
          }
        },
        onSaved: (_value) {
          _name = _value;
        },
      ),
    );
  }

  Widget buildEmailField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        style: textStyle(),
        cursorColor: kPrimaryColor,
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

  Widget buildPasswordField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        style: textStyle(),
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kPassNullError;
          }

          if (_value.length < 6) {
            return kShortPassError;
          }
        },
        onSaved: (_value) {
          _password = _value;
        },
      ),
    );
  }

  Widget buildSignUpButton(Size mq) {
    return GestureDetector(
      onTap: _save,
      child: Container(
        height: mq.height * 0.065,
        width: mq.width * 0.5,
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
            'SIGNUP',
            style: TextStyle(
                fontSize: 16, fontFamily: 'Raleway', color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildHaveAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(fontSize: 15, fontFamily: 'Raleway'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (ctx) => LogInScreen(),
              ),
            );
          },
          child: const Text(
            'Login',
            style: TextStyle(color: kPrimaryColor, fontFamily: 'Raleway'),
          ),
        ),
      ],
    );
  }
}
