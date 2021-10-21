import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';

class Support extends StatelessWidget {
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
       iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: mq.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email,size: 24,),
                SizedBox(width: 5,),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 20,
                    // fontFamily: 'Raleway',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: mq.height * 0.01,
            ),
            GestureDetector(
              onTap: () {
                _launchURL('mailto:rande@whiteglovehouse.com');
              },
              child: Container(
                width: mq.width * 0.75,
                height: mq.height * 0.06,
                decoration: BoxDecoration(
                  // color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: const Text(
                    'rande@whiteglovehouse.com',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: mq.height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.call,size: 24,),
                SizedBox(width: 5,),
                const Text(
                  'Phone',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: mq.height * 0.01,
            ),
            GestureDetector(
              onTap: () {
                _launchURL('tel:+1813-943-2677');
              },
              child: Container(
                width: mq.width * 0.75,
                height: mq.height * 0.06,
                decoration: BoxDecoration(
                  // color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: const Text(
                    '+1 813-943-2677',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: mq.height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map,size: 24),
                SizedBox(width: 5,),
                const Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: mq.height * 0.01,
            ),
            GestureDetector(
              onTap: () {
                _launchURL(
                    'https://www.google.com/maps/place/3325+Bayshore+Blvd+UNIT+A15,+Tampa,+FL+33629,+USA/@27.9139439,-82.4941742,17z/data=!3m1!4b1!4m5!3m4!1s0x88c2c349512e21d9:0xf963c66a022386ef!8m2!3d27.9139392!4d-82.4919855');
              },
              child: Container(
                width: mq.width * 0.75,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: const Text(
                    '3325 Bayshore Blvd UNIT A15, Tampa, FL 33629, United States',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}