import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
import 'package:qr_code/provider_qr_code.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'HalfBlueHalfBlackBorderPainter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  late TabController _tabController;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _tabController.addListener(() {
      Provider.of<QrCodeProvider>(context, listen: false)
          .setCurrentTabIndex(_tabController.index);
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<QrCodeProvider>(
        builder: (context, qrCodeProvider, child) {
          return Column(
            children: [
              Container(
                height: height * 0.72,
                width: double.infinity,
                color: Colors.white10,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 80),
                      Text(
                        currentTabIndex == 0
                            ? 'Scan QR Code'
                            : 'Scan Bar Code',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Please point the camera at ${currentTabIndex == 0 ? 'QR code' : 'Bar code'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(flex: 4, child: _buildQrView(context)),
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
                        const Tab(
                          text: "QR Code",
                        ),
                        const Tab(
                          text: "Bar Code",
                        ),
                      ],
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(fontSize: 14),
                      indicator: const BoxDecoration(
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
              const Divider(),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                      color: Colors.white12,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.browse_gallery,
                        color: Colors.blue),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.file_copy, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!qrCodeProvider.isScanning) {
                        if (controller != null) {
                          controller!.resumeCamera();
                        }
                        qrCodeProvider.setIsScanning(true);
                      } else {
                        if (qrCodeProvider.result != null) {
                          _showResultDialog(context, qrCodeProvider.result!);
                          // Clear the result after showing the dialog
                          qrCodeProvider.setResult(null);
                        }
                      }
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {

    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(

      key: qrKey,

      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(

        borderColor: Colors.blue,
        borderRadius: 20,
        borderLength: 40,
        borderWidth: 20,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      Provider.of<QrCodeProvider>(context, listen: false).setResult(scanData);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  void _showResultDialog(BuildContext context, Barcode result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scanned Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Barcode Type: ${describeEnum(result.format)}'),
              const SizedBox(height: 10),
              const Text(
                'Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  _launchURL(result.code.toString());
                },
                child: Text(
                  result.code.toString(),
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
