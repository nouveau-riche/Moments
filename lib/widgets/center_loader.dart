import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constant.dart';

showCenterLoader(BuildContext context, Size mq,String text) {
  showDialog(context: context, builder: (ctx) => buildContainer(mq,text));
}

Widget buildContainer(Size mq,String text) {
  return AlertDialog(
    content: Container(
      height: mq.height * 0.18,
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          SpinKitHourGlass(
            color: Colors.white,
          ),
          Spacer(),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ),
  );
}
