import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:qr_code/provider_qr_code.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {

  Barcode? result;
  int myIndex=0;

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(


      body:  Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.2,
            ),
            Center(
              child: Container(
                height: height * 0.4,
                width: width * 0.78,
                child: _buildQrView(context),
              ),
            ),
            SizedBox(
              height: height * 0.15,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.grey.shade400),
                  backgroundColor:
                  MaterialStatePropertyAll(Colors.blue.shade400),
                  minimumSize: MaterialStatePropertyAll(
                      Size(width * 0.7, height * 0.058)),
                  shape: MaterialStatePropertyAll(StadiumBorder())),
              onPressed: () {},
              child: Text('SCAN QR',
                  style: GoogleFonts.poppins(
                      wordSpacing: 2,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      fontSize: height * 0.022,
                      color: Colors.white)),
            )
          ],
        ),
      ),

    );
  }

Widget _buildQrView(BuildContext context) {
  final height = MediaQuery.sizeOf(context).height * 1;

  return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: Colors.green.shade50,
            width: 1,
          ),
        ),
        child: QRView(
          cameraFacing: CameraFacing.back,
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            overlayColor: Colors.grey.shade50,
            borderColor: Colors.blue.shade300,
            borderRadius: 20,
            borderLength: 40,
            borderWidth: 20,
            cutOutSize: height * 0.38,
          ),
        ),
      ));
}

void _onQRViewCreated(QRViewController controller) {
  this.controller = controller;

  controller.scannedDataStream.listen((scanData) {
    Provider.of<QrCodeProvider>(context, listen: false).setResult(scanData);
  });
}
}
