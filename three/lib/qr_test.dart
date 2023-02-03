import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class qr_test extends StatefulWidget {
  const qr_test({Key? key}) : super(key: key);

  @override
  State<qr_test> createState() => _qr_testState();
}

class _qr_testState extends State<qr_test> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  /*
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

   */

  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQrView(context),
          Positioned(bottom: 10, child: buildResult()),
          check_yes(),
        ],
      ),
    );
  }

  Widget buildResult() =>
      Text(
        barcode != null ? 'Result: ${barcode!.code}' : 'Scan the code',
        maxLines: 3,
      );
  check_yes() {
    barcode!.code == "YES"?
    Navigator.pushNamed(context, 'coupon')
        :Fluttertoast.showToast(msg: "Invalid QR Code",
        toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.redAccent,
        textColor: Colors.white, fontSize: 16.0);
  }


  Widget buildQrView(BuildContext context) =>
      QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        //overlay: QrScannerOverlayShape(
        //  borderWidth: 10,
        //  borderRadius: 10,
        //  cutOutSize: MediaQuery
        //      .of(context)
        //      .size
        //      .width * 0.8,),
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





