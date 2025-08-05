import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show platformViewRegistry;
import 'package:cloud_firestore/cloud_firestore.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String scanResult = "";
  bool showResult = false;
  bool showCountdown = false;
  String countdownText = "";
  String heure = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    platformViewRegistry.registerViewFactory(
      'qr-reader',
          (int viewId) => html.DivElement()
        ..id = 'qr-reader'
        ..style.width = '300px'
        ..style.height = '300px'
        ..style.position = 'relative'
        ..style.margin = '200px auto 0'
        ..style.overflow = 'hidden',
    );

    _startScanner();
    _startClock();
  }

  void _startClock() {
    _timer?.cancel();
    _updateHeure();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateHeure();
    });
  }

  void _updateHeure() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    setState(() {
      heure = "Heure : $h:$m:$s";
    });
  }

  Future<void> saveScanResultToFirestore(String result) async {
    final now = DateTime.now();
    final heure = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    await FirebaseFirestore.instance.collection('scans').add({
      'id_or_nom': result,
      'heure': heure,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _startScanner() {
    js.context.callMethod('startQrScanner', [
      js.allowInterop((String result) async {
        setState(() {
          scanResult = result;
          showResult = true;
          showCountdown = true;
          countdownText = "Le scan sera réactivé dans 5 secondes...";
        });

        await saveScanResultToFirestore(result); // 🟢 Enregistrer dans Firestore

        Future.delayed(const Duration(seconds: 5), () {
          setState(() {
            showResult = false;
            showCountdown = false;
          });
          _startScanner();
        });
      })
    ]);
  }

  @override
  void dispose() {
    _timer?.cancel();
    js.context.callMethod('stopQrScanner');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner le code QR de l'employé"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    heure,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: HtmlElementView(viewType: 'qr-reader'),
                  ),
                  const SizedBox(height: 12),
                  if (showResult)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Résultat : $scanResult",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (showCountdown)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        countdownText,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.orange.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
