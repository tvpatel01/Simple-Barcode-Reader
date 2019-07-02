import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  String appName = 'Simple Barcode Reader';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _barcode = '';
  bool _errorStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: getResultCard(context),
      floatingActionButton: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          child: Icon(Icons.center_focus_weak,color: Colors.white,size: 36,),
          height: 60.0,
          width: 200.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.blue
          ),
        ),
        onTap: () {
          _barcode = '';
          _errorStatus = false;
          scan(context);
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  Widget getResultCard(BuildContext context) {
    if(!_errorStatus && _barcode != '')
      return successResultCard(context);
    else if(!_errorStatus && _barcode == '')
      return defaultResultCard(context);
    return errorResultCard(context);
  }

  @override
  Widget defaultResultCard(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.blur_on,color: Colors.grey[200],size: 256,),
          ],
        ),
      ),
    );
  }

  @override
  Widget successResultCard(BuildContext context) {
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
            child: Column(
              children: <Widget>[
                new Card(
                  elevation: 2.0,
                  margin: EdgeInsets.all(5.0),
                  child: new Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                    child: new Column(
                      children: <Widget>[
                          Icon(Icons.check_circle,color: Colors.green,size: 96,),
                          Text(
                            '',
                          ),
                          Text(
                            _barcode,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            '',
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
        )
      ),
    );
  }

  @override
  Widget errorResultCard(BuildContext context) {
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
            child: Column(
              children: <Widget>[
                new Card(
                  elevation: 2.0,
                  child: new Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 20.0),
                    child: new Column(
                      children: <Widget>[
                        Text(
                            'Opps...\n',
                            style: Theme.of(context).textTheme.headline,
                          ),
                          Icon(Icons.error,color: Colors.red[300],size: 128,),
                          Text(
                            '\n' + _barcode,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
        )
      ),
    );
  }

  Future scan(context) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        _barcode = barcode;
        _errorStatus = false;
        log("*****************************************");
        log(_barcode);
        log("*****************************************");
      });
    } on PlatformException catch (e) {
      _errorStatus = true;
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._barcode = 'Camera permission required';
        });
      } else {
        setState(() => this._barcode = 'Something went really wrong');
      }
    } on FormatException catch (e) {
      _errorStatus = true;
      setState(() => this._barcode =
          'Unable to detect/parse barcode');
    } catch (e) {
      _errorStatus = true;
      setState(() => this._barcode = 'Unexpected problem occured');
    }
  }
}
