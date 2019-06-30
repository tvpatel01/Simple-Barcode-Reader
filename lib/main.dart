import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'driver.dart';
import 'results.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iVerify Demo',
      theme: ThemeData(

        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'i-Verify'),
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
  int _counter = 0;
  String barcode = "";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.camera_enhance),
      ),
    );
  }

  Future scan(context) async {
    try {
      String barcode = await BarcodeScanner.scan();
      print('entered barcode scan');
      var txtSplit = barcode.split('\n');
      print('barcode : ' + barcode);
      print(txtSplit);
      for (int i = 0; i < txtSplit.length; i++) {
        print('${txtSplit[i]}');
      }

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

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Results(driver)));
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