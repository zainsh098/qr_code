import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'HalfBlueHalfBlackBorderPainter.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  late TabController _tabController;
  int currentTabIndex = 0; // To keep track of the selected tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        currentTabIndex = _tabController.index; // Update the current tab index
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: height * 0.72,
            width: double.infinity,
            color: Colors.white10,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 80),
                  Text(
                    currentTabIndex == 0 ? 'Scan QR Code' : 'Scan Bar Code',
                    style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Please point the camera at ${currentTabIndex == 0
                        ? 'QR code'
                        : 'Bar code'}',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 20),


                  Expanded(flex: 4, child: _buildQrView(context)),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          if (result != null)
                            Text(
                                'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
                            style:  TextStyle(color: Colors.amber,fontSize: 20),)
                          else
                            const Text('Scan a code',style:  TextStyle(color: Colors.amber,fontSize: 20)),

                        ],
                      ),
                    ),
                  )



                ],
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBar(
                  indicatorColor: Colors.grey,
                  controller: _tabController,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "QR Code",
                    ),
                    Tab(
                      text: "Bar Code",
                    ),
                  ],
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.white,
                  labelStyle: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(fontSize: 14),
                  indicator: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.blue,
                        width: 3,

                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 30,),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.browse_gallery, color: Colors.blue),
              ),
              SizedBox(width: 15,),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.file_copy, color: Colors.blue),
                ),
              ),
              SizedBox(width: 15,),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 5,
                    style: BorderStyle.solid,
                    color: Colors.white12,
                  ),
                ),
                child: CustomPaint(
                  painter: HalfBlueHalfBlackBorderPainter(6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery
        .of(context)
        .size
        .width < 400 ||
        MediaQuery
            .of(context)
            .size
            .height < 400)
        ? 150.0
        : 300.0;
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 20,
          borderLength: 40,
          borderWidth: 20,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }


}