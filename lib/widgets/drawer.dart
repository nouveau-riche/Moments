import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/authentication.dart';
import '../screens/login_screen.dart';

class MyDrawer extends StatelessWidget {
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

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: mq.height * 0.05,
          ),
          buildDrawerHeader(mq),
          buildAboutUsListTile(context, mq),
          buildLogOutListTile(context, mq),
        ],
      ),
    );
  }

  Widget buildDrawerHeader(Size mq) {
    return Container(
      height: mq.height * 0.16,
      padding: EdgeInsets.only(left: 60),
      child: Image.asset('assets/images/logo.png'),
    );
  }

  Widget buildAboutUsListTile(BuildContext context, Size mq) {
    return ListTile(
      onTap: () async {
        _launchURL('https://whiteglovehouse.com');
      },
      dense: true,
      leading: Container(
        margin: EdgeInsets.only(left: mq.width * 0.04),
        child: Icon(
          CupertinoIcons.person_circle_fill,
          size: 25,
          color: Colors.black,
        ),
      ),
      title: Text(
        'About Us!',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget buildLogOutListTile(BuildContext context, Size mq) {
    return ListTile(
      onTap: () {
        Authentication.signOut().whenComplete(
          () {
            Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (ctx) => LogInScreen(),
                ),
                (route) => false);
          },
        );
      },
      dense: true,
      leading: Container(
        margin: EdgeInsets.only(left: mq.width * 0.04),
        child: Icon(
          Icons.exit_to_app,
          size: 25,
          color: Colors.black,
        ),
      ),
      title: Text(
        'Logout',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
