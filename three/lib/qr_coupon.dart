import 'package:three/coupon.dart';
import 'package:three/globar_variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
class qr_coupon extends StatefulWidget {
  const qr_coupon({Key? key}) : super(key: key);

  @override
  State<qr_coupon> createState() => _qr_couponState();
}




class _qr_couponState extends State<qr_coupon> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }


  /*
  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQrView(context),
          Positioned(bottom: 10, child: buildResult()),
        ],
      ),
    );
    qr_check(barcode);
  }

  Widget buildResult() =>
      Text(
        barcode != null ? 'Result: ${barcode!.code}' : 'Scan the code',
        maxLines: 3,
      );


  Widget buildQrView(BuildContext context) =>
      QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderWidth: 10,
          borderRadius: 10,
          cutOutSize: MediaQuery
              .of(context)
              .size
              .width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
      });
    });
  }


}

void qr_check(Barcode? barcode) {
  if(barcode == "YES"){
    print('yes');
  }else{
    print('no');
  }
}



*/

class qr_coupon extends StatefulWidget {
  const qr_coupon({Key? key}) : super(key: key);

  @override
  State<qr_coupon> createState() => _qr_couponState();
}

class _qr_couponState extends State<qr_coupon> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;

  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //margin: EdgeInsets.all(5),
        //padding:EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: (result != null)
                    ? Text("${result!.code}")
                    : Text('Tap on the screen to scan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        Future.delayed(const Duration(milliseconds: 2000),(){
          setState(() {
            result = scanData;
          });
        });

            if(result!.code == 'YES'){
              Navigator.of(context).pop(true);
              Navigator.pushNamed(context, 'coupon');
              //Navigator.pushReplacement<void, void>(
              //  context,
              //  MaterialPageRoute<void>(
              //      builder: (BuildContext context) => const coupon(),
              //  ),
              //);
          //print('yes');
              //Fluttertoast.showToast(msg: "${result!.code}", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
          /////////////////////////
            }else{
              //print('no');
              //Navigator.of(context).pop(true);
              //Navigator.pushNamed(context, 'home');
              Fluttertoast.showToast(msg: "Invalid QR Code", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent, textColor: Colors.white, fontSize: 16.0);
            }

      });
    });

  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


