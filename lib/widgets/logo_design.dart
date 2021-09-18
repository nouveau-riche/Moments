import 'package:flutter/material.dart';

class LogoDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
}
