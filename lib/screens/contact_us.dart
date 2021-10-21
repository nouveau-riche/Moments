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
                _launchURL('mailto:');
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
                    'whogetsthis@gmail.com',
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
                _launchURL('tel:+917879641574');
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
                    '+91 7879641574',
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
                    'https://www.google.com/maps/place/Delhi/data=!4m2!3m1!1s0x390cfd5b347eb62d:0x37205b715389640?sa=X&ved=2ahUKEwiFlquiyeDxAhWCfH0KHfBuBaoQ8gEwAHoECAgQAQ');
              },
              child: Container(
                width: mq.width * 0.75,
                height: mq.height * 0.06,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: const Text(
                    'ABCd, Jaipurdd, Rajasthan 302017',
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