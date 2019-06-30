import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:iverify/main.dart';
import 'driver.dart';

class Results extends StatefulWidget {
  final Driver driver;
  Results(this.driver);

  @override
  _ResultsPage createState() => new _ResultsPage();
}

class _ResultsPage extends State<Results> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  final topAppBar = AppBar(
    //elevation: 0,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'i ',
          style: TextStyle(
              fontSize: 30.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.red),
        ),
        Text(
          'Check',
          style: TextStyle(fontSize: 32.75, color: Colors.black),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: topAppBar,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              color: Colors.blueGrey[50],
              margin: EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 20.0),
                      child: Image(
                        image: AssetImage("assets/SuccessIcon.png"),
                      )),
                  Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(25.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 20.0),
                            child: Text(
                              widget.driver.firstName +
                                  ' ' +
                                  widget.driver.surName,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      widget.driver.addrLine1,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10.0),
                                    ),
                                    Text(
                                      widget.driver.addrLine2,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10.0),
                                    ),
                                  ])
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          )
                        ],
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '\nStart Over',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyHomePage()));
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            height: 100.0,
            width: 80.0,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/GreenBottom.png"),
                fit: BoxFit.fill,
              ),
            ),
          )),
    );
  }

  Future scan(context) async {
    try {
      String barcode = await BarcodeScanner.scan();
      // print(barcode);
      var txtSplit = barcode.split('\n');
      //   for (int i = 0; i < txtSplit.length; i++) {
      //     print('${txtSplit[i]}');
      //   }

      String surName = txtSplit[5].substring(3);
      String firstName = txtSplit[6].substring(3);
      String addrLine1 = txtSplit[12].substring(3);
      String addrLine2 = txtSplit[13].substring(3);
      String addrLine3 = txtSplit[14].substring(3);
      String addrLine4 = txtSplit[15].substring(3);
      String addrRest = addrLine2 + ' ' + addrLine3 + ' ' + addrLine4;
      String dob = txtSplit[8].substring(3);
      String dobFormatted = dob.substring(4, 8) +
          '-' +
          dob.substring(0, 2) +
          '-' +
          dob.substring(2, 4);
      Driver driver = new Driver(
          firstName: firstName,
          surName: surName,
          dob: dobFormatted,
          addrLine1: addrLine1,
          addrLine2: addrRest);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
