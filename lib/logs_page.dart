import 'package:flutter/material.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Consulter les logs'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "📄 Fiches de présence des employés",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ✅ بدل Row بـ Wrap ليكون Responsive
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: 350,
                  child: _buildInfoCard("👥 Employés", "Nombre total d'employés : "),
                ),
                SizedBox(
                  width: 350,
                  child: _buildInfoCard("📅 Mois courant", "Mois courant : "),
                ),
                SizedBox(
                  width: 350,
                  child: _buildSelectMonth(),
                ),
              ],
            ),

            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: const [
                  Icon(Icons.people, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Liste des employés",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Rechercher un employé...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildEmployeeTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSelectMonth() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("📅 Sélectionner un mois", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: "Janvier",
                  items: [
                    for (var month in [
                      "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                      "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
                    ])
                      DropdownMenuItem(value: month, child: Text(month)),
                  ],
                  onChanged: (_) {},
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: "2025",
                  items: [
                    for (var year in ["2023", "2024", "2025", "2026", "2027","2028","2029","2030"])
                      DropdownMenuItem(value: year, child: Text(year)),
                  ],
                  onChanged: (_) {},
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeTable() {
    final List<String> employees = [
      "ABDELLAH ELYAMANI",
      "ABDERRAFIE EL MOUAHID",
      "SALMA BENALI",
      "YASSINE BOUZIANE",
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DataTable(
        columnSpacing: 20,
        headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
        columns: const [
          DataColumn(label: Expanded(child: Text("Nom de l'employé", style: TextStyle(fontWeight: FontWeight.bold)))),
          DataColumn(label: Text("Action", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: List.generate(employees.length, (index) {
          final emp = employees[index];
          return DataRow(
            cells: [
              DataCell(Text(emp, style: const TextStyle(fontWeight: FontWeight.w600))),
              DataCell(ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye),
                label: const Text("Afficher la fiche"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              )),
            ],
          );
        }),
      ),
    );
  }
}
