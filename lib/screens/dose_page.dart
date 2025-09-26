import 'package:flutter/material.dart';
import 'package:immunelink/screens/dose.dart';
import 'package:intl/intl.dart';

class DosePage extends StatefulWidget {
  DosePage({super.key});

  @override
  State<DosePage> createState() => _DosePageState();
}

class _DosePageState extends State<DosePage> {
  final List<Dose> doses = [
    Dose(
      doseId: "D001",
      userId: "USER123",
      doseNumber: 1,
      date: DateTime.now(),
      status: "Completed",
    ),
    Dose(
      doseId: "D002",
      userId: "USER123",
      doseNumber: 2,
      date: DateTime.now().add(const Duration(days: 30)),
      status: "Scheduled",
    ),
    Dose(
      doseId: "D003",
      userId: "USER456",
      doseNumber: 1,
      date: DateTime.now().subtract(const Duration(days: 15)),
      status: "Completed",
    ),
  ];

  String searchQuery = "";

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Scheduled":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<Dose> get filteredDoses {
    return doses.where((dose) {
      return dose.userId.contains(searchQuery) ||
          dose.doseId.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vaccination Doses"),
        backgroundColor: const Color(0xFF1565C0),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by UserID / DoseID",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredDoses.length,
              itemBuilder: (context, index) {
                final dose = filteredDoses[index];
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dose #${dose.doseNumber} - ${dose.status}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(dose.status))),
                          const SizedBox(height: 8),
                          Text("Dose ID: ${dose.doseId}"),
                          Text("User ID: ${dose.userId}"),
                          Text(
                              "Date: ${DateFormat.yMMMd().format(dose.date)}"),
                        ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
