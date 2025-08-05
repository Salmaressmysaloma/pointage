import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'Employee.dart';

class GenerateQrPage extends StatefulWidget {
 const GenerateQrPage({Key? key}) : super(key: key);

 @override
 State<GenerateQrPage> createState() => _GenerateQrPageState();
}

class _GenerateQrPageState extends State<GenerateQrPage> {
 final TextEditingController _controller = TextEditingController();
 GlobalKey globalKey = GlobalKey();
 String? qrData;
 List<Map<String, String>> employees = []; // Liste des employés

 Future<void> _generateQr() async {
  final input = _controller.text.trim();

  if (input.isNotEmpty) {
   final emp = Employee(name: input, qr: input);

   try {
    await FirebaseFirestore.instance.collection('employees').add(emp.toMap());

    setState(() {
     qrData = emp.qr;
     employees.add({'id': emp.name});
     _controller.clear();
    });

    if (context.mounted) {
     Navigator.pushReplacementNamed(context, '/logs'); // خاص تكون route مسجلة
    }

   } catch (e) {
    print("Erreur Firestore: $e");
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(content: Text('خطأ أثناء التسجيل')),
    );
   }
  }
 }
 Future<void> _downloadQr(String data) async {
  try {
   final qrValidationResult = QrValidator.validate(
    data: data,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.L,
   );
   if (qrValidationResult.status == QrValidationStatus.valid) {
    final qrCode = qrValidationResult.qrCode!;
    final painter = QrPainter.withQr(
     qr: qrCode,
     color: const Color(0xFF000000),
     emptyColor: const Color(0xFFFFFFFF),
     gapless: true,
    );

    final image = await painter.toImageData(300);
    final bytes = image!.buffer.asUint8List();
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
     ..setAttribute("download", "$data-qr.png")
     ..click();
    html.Url.revokeObjectUrl(url);
   }
  } catch (e) {
   print("Erreur téléchargement : $e");
  }
 }

 void _deleteEmployee(int index) {
  setState(() {
   employees.removeAt(index);
  });
 }

 Widget _buildQrPreview() {
  return RepaintBoundary(
   key: globalKey,
   child: QrImageView(
    data: qrData ?? " ",
    size: 200,
    version: QrVersions.auto,
    backgroundColor: Colors.white,
   ),
  );
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text("Générateur de code QR"),
    backgroundColor: Colors.blue,
   ),
   body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Center(
     child: Column(
      children: [
       Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
         border: Border.all(color: Colors.grey.shade300),
         borderRadius: BorderRadius.circular(15),
         color: Colors.white,
        ),
        child: Column(
         children: [
          const Text(
           "+ Générateur de code QR",
           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
           textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
           controller: _controller,
           decoration: InputDecoration(
            hintText: "Entrez l'ID ou le nom de l'employé",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
           ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
           onPressed: _generateQr,
           icon: const Icon(Icons.qr_code),
           label: const Text("Générer"),
           style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 45),
           ),
          ),
          const SizedBox(height: 20),
          _buildQrPreview(),
          const SizedBox(height: 20),
          ElevatedButton.icon(
           onPressed: qrData != null ? () => _downloadQr(qrData!) : null,
           icon: const Icon(Icons.download),
           label: const Text("Télécharger le QR"),
           style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 45),
           ),
          ),
         ],
        ),
       ),
       const SizedBox(height: 40),
       if (employees.isNotEmpty)
        Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          const Text(
           "👥 Liste des employés",
           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
           scrollDirection: Axis.horizontal,
           child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: DataTable(
             columns: const [
              DataColumn(label: Text("ID/Nom")),
              DataColumn(label: Text("QR Code")),
              DataColumn(label: Text("Télécharger")),
              DataColumn(label: Text("Supprimer")),
             ],
             rows: List.generate(employees.length, (index) {
              final emp = employees[index];
              return DataRow(cells: [
               DataCell(Text(emp['id']!)),
               DataCell(SizedBox(
                height: 50,
                width: 50,
                child: QrImageView(
                 data: emp['id']!,
                 version: QrVersions.auto,
                ),
               )),
               DataCell(ElevatedButton(
                onPressed: () => _downloadQr(emp['id']!),
                child: const Text("Télécharger"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
               )),
               DataCell(ElevatedButton(
                onPressed: () => _deleteEmployee(index),
                child: const Text("Supprimer"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
               )),
              ]);
             }),
            ),
           ),
          ),
         ],
        ),
      ],
     ),
    ),
   ),
  );
 }
}
