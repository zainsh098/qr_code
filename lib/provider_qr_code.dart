

import 'package:flutter/cupertino.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeProvider with ChangeNotifier{


  Barcode? _result;
  bool _isScanning=false;

  Barcode? get result=>_result;
  bool get isScanning =>_isScanning;
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void setCurrentTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void startScanning()
  {

    _isScanning=true;
    notifyListeners();

  }

  void stopScanning() {
    _isScanning = false;
    notifyListeners();
  }

  void setScannedResult(Barcode result) {
    _result = result;
    notifyListeners();
  }

  void setIsScanning(bool scanning) {
    _isScanning = scanning;
    notifyListeners();
  }
  void setResult(Barcode? scanData) {
    _result = scanData;
    notifyListeners();
  }
}