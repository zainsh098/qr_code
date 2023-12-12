 import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/provider_qr_code.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> with SingleTickerProviderStateMixin {

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery
        .sizeOf(context)
        .height * 1;
    final width = MediaQuery
        .sizeOf(context)
        .width * 1;
    return Scaffold(
      appBar: AppBar(title: Text('QR Scanner'), centerTitle: true,),
      body: Container(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.1,),

            Center(

              child: Container(

                height: height * 0.4,
                width: width * 0.8,
                color: Colors.amber,
                child: _buildQrCode(context),

              ),

            ),


          ],


        ),

      ),


    );
  }


  Widget _buildQrCode(BuildContext context) {
    return QRView(

      key: qrKey,

      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(

        borderColor: Colors.blue,
        borderRadius: 10,
        borderLength: 40,
        borderWidth: 20,
        cutOutSize: 500,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {});
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

}