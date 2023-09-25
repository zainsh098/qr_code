import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'HalfBlueHalfBlackBorderPainter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String scanResult = "";
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                    currentTabIndex == 0 ? 'Scan QR Code' : 'Scan Bar Code', // Display different text based on the selected tab
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Please point the camera at ${currentTabIndex == 0 ? 'QR code' : 'Bar code'}', // Display different text based on the selected tab
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 0.8 * MediaQuery.of(context).size.width,
                    height: 0.4 * MediaQuery.of(context).size.height,
                    child: MobileScanner(
                      fit: BoxFit.fill,
                      onDetect: (result) {
                        setState(() {
                          scanResult = result as String;
                        });
                      },
                    ),
                  ),
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
                  labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
}
