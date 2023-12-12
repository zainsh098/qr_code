import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          padding: EdgeInsets.symmetric(vertical: height * 0.06, horizontal: width * 0.057),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.18), // Set the shadow color
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 6), // changes position of shadow
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BottomNavigationBar(
                backgroundColor: Colors.blueGrey.shade50,
                selectedItemColor: Colors.blue,
                enableFeedback: true,
                unselectedLabelStyle: GoogleFonts.poppins(
                  wordSpacing: 2,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                  fontSize: height * 0.018,
                  color: Colors.black,
                ),
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
                          builder: (context) => const QrScannerScreen(),
                        ),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateQRScreen(),
                        ),
                      );
                      break;
                    case 3:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QRHistoryScreen(),
                        ),
                      );

                      break;
                  }
                },
                currentIndex: myIndex,
                items: const [
                  BottomNavigationBarItem(
                    backgroundColor: Colors.green,
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.green,
                    icon: Icon(Icons.qr_code_scanner),
                    label: 'Scan',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.green,
                    icon: Icon(Icons.qr_code),
                    label: 'Create QR',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.green,
                    icon: Icon(Icons.history),
                    label: 'History',
                  ),
                ],
              ),
            ),
          ),
        ),

        body: Scaffold(

          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height:  height * 0.05,),

                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Text('Welcome to ',

                        style: GoogleFonts.poppins(

                            wordSpacing: 2,
                            letterSpacing: 1,
                            fontSize: height * 0.035,
                            fontWeight:  FontWeight.w500,
                          fontStyle: FontStyle.italic,
                            color: Colors.black)),
                  ),


                  SizedBox(height:  height * 0.02,),


                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: SvgPicture.asset('assets/qrcode1.svg', fit: BoxFit.cover,height: height * 0.45,
                      width: width * 0.85,),
                  ),

                  SizedBox(height:  height * 0.02,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: Text('Scan QR codes, generate your own, and keep track of your code history with ease.',
textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(

                            wordSpacing: 2,
                            letterSpacing: 1,
                            fontSize: height * 0.020,
                            fontWeight:  FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade800)),
                  ),



                ],





              ),
            ),
          ),

        ));
  }
}
