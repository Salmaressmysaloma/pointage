import 'package:flutter/material.dart';

class SalairePage extends StatefulWidget {
  const SalairePage({super.key});

  @override
  State<SalairePage> createState() => _SalairePageState();
}

class _SalairePageState extends State<SalairePage> {
  final TextEditingController heuresController = TextEditingController();
  final TextEditingController tauxController = TextEditingController();
  double? salaire;

  void calculerSalaire() {
    final heures = double.tryParse(heuresController.text) ?? 0;
    final taux = double.tryParse(tauxController.text) ?? 0;

    setState(() {
      salaire = heures * taux;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 AppBar أنيق
      appBar: AppBar(
        title: const Text("Salaire Pro", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.indigo),
            ),
          )
        ],
      ),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 📝 Card inputs
                Card(
                  margin: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: heuresController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Nombre d'heures",
                            prefixIcon: Icon(Icons.timer),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: tauxController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Taux par heure",
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 🔘 زر دائري أنيق
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                    elevation: 8,
                  ),
                  onPressed: calculerSalaire,
                  icon: const Icon(Icons.calculate, size: 28, color: Colors.white),
                  label: const SizedBox.shrink(),
                ),
                const SizedBox(height: 40),

                // 💰 Animated result
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: salaire == null ? Colors.transparent : Colors.green[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: salaire != null
                      ? Text(
                    "💰 Salaire: ${salaire!.toStringAsFixed(2)} MAD",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                      : const SizedBox.shrink(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
