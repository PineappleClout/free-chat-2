import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeJoin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeJoinState();
}

class _HomeJoinState extends State<HomeJoin> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  BuildContext currentContext;
  Barcode result;
  QRViewController controller;
  final myController = TextEditingController();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context, myController.text),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
           //child: Text("Holder"),
           child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                  '${result.code}')
                  : Text(""),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        if(scanData.format == BarcodeFormat.qrcode && scanData.code.isNotEmpty
        ) {
          myController.text = scanData.code;
        }
        result = scanData;
      });


    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}