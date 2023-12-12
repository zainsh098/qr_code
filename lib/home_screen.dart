import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code/views/qr_create_screen.dart';
import 'package:qr_code/views/qr_scanner_screen.dart';
import 'package:qr_code/views/qr_scanning_history.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Barcode? result;
  int myIndex = 0;

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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BottomNavigationBar(
                elevation: 8,
                backgroundColor: Colors.grey.shade200,
                selectedItemColor: Colors.blue,
                unselectedLabelStyle: GoogleFonts.poppins(
                    wordSpacing: 2,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                    fontSize: height * 0.018,
                    color: Colors.black),
                iconSize: 25,
                selectedFontSize: 13,
                selectedLabelStyle: GoogleFonts.poppins(
                  wordSpacing: 2,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                  fontSize: height * 0.018,
                ),
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  setState(() {
                    myIndex = index;
                  });

                  switch (index) {
                    case 0:
                      break;
                    case 1:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QrScannerScreen(),
                          ));
                      break;
                    case 2:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateQRScreen(),
                          ));
                      break;
                    case 3:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRHistoryScreen(),
                          ));

                      break;
                  }
                },
                currentIndex: myIndex,
                items: [
                  BottomNavigationBarItem(
                      backgroundColor: Colors.green,
                      icon: Icon(
                        Icons.home,
                      ),
                      label: 'Home'),
                  BottomNavigationBarItem(
                      backgroundColor: Colors.green,
                      icon: Icon(
                        Icons.qr_code_scanner,
                      ),
                      label: 'Scan'),
                  BottomNavigationBarItem(
                      backgroundColor: Colors.green,
                      icon: Icon(Icons.qr_code),
                      label: 'Create QR'),
                  BottomNavigationBarItem(
                      backgroundColor: Colors.green,
                      icon: Icon(Icons.history),
                      label: 'History'),
                ]),
          ),
        ),
        body: Scaffold(
          appBar: AppBar(
            title: Text('Home Screen Naigation'),
          ),
          body: Column(



          ),

        ));
  }
}
