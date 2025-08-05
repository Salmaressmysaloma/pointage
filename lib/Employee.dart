class Employee {
  final String name;
  final String qr;

  Employee({required this.name, required this.qr});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'qr': qr,
      'created_at': DateTime.now(),
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      name: map['name'] ?? '',
      qr: map['qr'] ?? '',
    );
  }
}
