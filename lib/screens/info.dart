import 'package:flutter/material.dart';
import 'package:RummyCalculator/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<Data>(context).isDarkMode ? kInverseWhite : Colors.white,
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        backgroundColor: Provider.of<Data>(context).isDarkMode
            ? Colors.black
            : kBackgroundColor,
        title: Text(
          'Dev',
          style: kTitleTextStyle,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              Provider.of<Data>(context).translations['app_idea'],
              style: TextStyle(
                color: Provider.of<Data>(context).isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Developer - FM',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
                color: Provider.of<Data>(context).isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              color: Provider.of<Data>(context).isDarkMode
                  ? Colors.white
                  : Colors.black,
              width: 300.0,
              height: 1.0,
            ),
            GestureDetector(
              onTap: () async {
                if (await canLaunch("https://www.instagram.com/franm.py/")) {
                  await launch("https://www.instagram.com/franm.py/");
                }
              },
              child: Center(
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Provider.of<Data>(context).isDarkMode
                        ? kInverseWhite
                        : Colors.white,
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/ig_logo.png"),
                          ),
                        ),
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "@franm.py",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w600,
                          color: Provider.of<Data>(context).isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final Email email = Email(
                  subject: 'I have an app idea!',
                  body: '',
                  recipients: ['fran.maric.vk@gmail.com'],
                );
                try {
                  await FlutterEmailSender.send(email);
                } catch (e) {}
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Provider.of<Data>(context).isDarkMode
                        ? kInverseWhite
                        : Colors.white,
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/mail_logo.png"),
                          ),
                        ),
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "fran.maric.vk@gmail.com",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Provider.of<Data>(context).isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
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
