import 'package:flutter/material.dart';
import 'GenerateQRPage.dart';
import 'scanner_page.dart';
import 'logs_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 80,
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed: () => _navigateTo(context, const ScannerPage()),
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                label: const Text("Scanner", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () => _navigateTo(context, const GenerateQrPage()),
                icon: const Icon(Icons.qr_code, color: Colors.white),
                label: const Text("Gener QR", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () => _navigateTo(context, const LogsPage()),
                icon: const Icon(Icons.list_alt, color: Colors.white),
                label: const Text("consulter les Logs", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false, // حيد زر الرجوع
      ),
      body: const Center(
        child: Text("Hi 👋", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
