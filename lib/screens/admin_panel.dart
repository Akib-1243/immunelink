import 'package:flutter/material.dart';
import 'package:immunelink/screens/application_list_page.dart';
import 'package:immunelink/screens/application_page.dart';
import 'package:immunelink/screens/dose_page.dart';
import 'package:immunelink/screens/homePage.dart';
import 'package:immunelink/screens/profile.dart';
import 'package:firebase_database/firebase_database.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Example admin data
  final String adminId = "A001";
  final String adminName = "John Admin";
  final String adminEmail = "admin@example.com";
  final String adminPassword = "********";

  // Application statistics
  int totalApplications = 0;
  int pendingApplications = 0;
  int approvedApplications = 0;
  int rejectedApplications = 0;
  List<Application> applications = [];
  bool isLoading = true;

  final DatabaseReference _applicationsRef = FirebaseDatabase.instance.ref().child('applications');

  @override
  void initState() {
    super.initState();
    _loadApplicationData();
  }

  void _loadApplicationData() {
    _applicationsRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> applicationsMap = event.snapshot.value as Map<dynamic, dynamic>;
        List<Application> loadedApplications = [];

        applicationsMap.forEach((key, value) {
          loadedApplications.add(Application.fromMap(Map<String, dynamic>.from(value), key));
        });

        setState(() {
          applications = loadedApplications;
          totalApplications = applications.length;
          pendingApplications = applications.where((app) => app.status == 'Pending').length;
          approvedApplications = applications.where((app) => app.status == 'Approved').length;
          rejectedApplications = applications.where((app) => app.status == 'Rejected').length;
          isLoading = false;
        });
      } else {
        setState(() {
          totalApplications = 0;
          pendingApplications = 0;
          approvedApplications = 0;
          rejectedApplications = 0;
          isLoading = false;
        });
      }
    });
  }

  void _showPendingApplications() {
    List<Application> pendingApps = applications.where((app) => app.status == 'Pending').toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => PendingApplicationsSheet(
          applications: pendingApps,
          scrollController: scrollController,
          onStatusUpdate: _updateApplicationStatus,
        ),
      ),
    );
  }

  Future<void> _updateApplicationStatus(String applicationId, String newStatus, String? adminComment) async {
    try {
      await _applicationsRef.child(applicationId).update({
        'status': newStatus,
        'adminComment': adminComment,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Application $newStatus successfully!'),
          backgroundColor: newStatus == 'Approved' ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating application: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // ---------- HEADER SECTION ----------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings,
                      size: 50, color: Colors.blueAccent),
                ),
                const SizedBox(height: 10),
                Text(
                  adminName,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(adminEmail, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                Text("Admin ID: $adminId", style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),

          // ---------- DASHBOARD SECTION ----------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  DashboardCard(
                    title: "Total Applications",
                    value: totalApplications.toString(),
                    color: Colors.blue,
                    icon: Icons.description,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ApplicationListPage()),
                      );
                    },
                  ),
                  DashboardCard(
                    title: "Pending Applications",
                    value: pendingApplications.toString(),
                    color: Colors.orange,
                    icon: Icons.hourglass_empty,
                    onTap: _showPendingApplications,
                  ),
                  DashboardCard(
                    title: "Approved",
                    value: approvedApplications.toString(),
                    color: Colors.green,
                    icon: Icons.check_circle,
                    onTap: () {},
                  ),
                  DashboardCard(
                    title: "Rejected",
                    value: rejectedApplications.toString(),
                    color: Colors.red,
                    icon: Icons.cancel,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Dashboard Card Widget ----------
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Pending Applications Sheet ----------
class PendingApplicationsSheet extends StatelessWidget {
  final List<Application> applications;
  final ScrollController scrollController;
  final Function(String, String, String?) onStatusUpdate;

  const PendingApplicationsSheet({
    super.key,
    required this.applications,
    required this.scrollController,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.hourglass_empty, color: Colors.orange, size: 28),
              const SizedBox(width: 10),
              Text(
                'Pending Applications (${applications.length})',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: applications.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No pending applications',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: scrollController,
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final app = applications[index];
                return ApplicationCard(
                  application: app,
                  onApprove: () => onStatusUpdate(app.id!, 'Approved', null),
                  onReject: () => _showRejectDialog(context, app.id!, onStatusUpdate),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, String applicationId, Function(String, String, String?) onStatusUpdate) {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reject Application'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please provide a reason for rejection:'),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Enter reason for rejection...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (commentController.text.trim().isNotEmpty) {
                  onStatusUpdate(applicationId, 'Rejected', commentController.text.trim());
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Reject', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

// ---------- Application Card Widget ----------
class ApplicationCard extends StatelessWidget {
  final Application application;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Text(
                    application.name.isNotEmpty ? application.name[0].toUpperCase() : 'U',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        application.phoneNumber,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Nationality', application.nationality),
            _buildInfoRow('NID Number', application.nidNumber),
            _buildInfoRow('Vaccine', application.vaccineName),
            _buildInfoRow('Submitted', '${application.submissionDate.day}/${application.submissionDate.month}/${application.submissionDate.year}'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text('Approve', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text('Reject', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Application Model ----------
class Application {
  String? id;
  String name;
  String nationality;
  String vaccineName;
  String nidNumber;
  String phoneNumber;
  DateTime submissionDate;
  String status;
  String? adminComment;

  Application({
    this.id,
    required this.name,
    required this.nationality,
    required this.vaccineName,
    required this.nidNumber,
    required this.phoneNumber,
    required this.submissionDate,
    this.status = 'Pending',
    this.adminComment,
  });

  factory Application.fromMap(Map<String, dynamic> map, String id) {
    return Application(
      id: id,
      name: map['name'] ?? '',
      nationality: map['nationality'] ?? '',
      vaccineName: map['vaccineName'] ?? '',
      nidNumber: map['nidNumber'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      submissionDate: DateTime.fromMillisecondsSinceEpoch(map['submissionDate'] ?? 0),
      status: map['status'] ?? 'Pending',
      adminComment: map['adminComment'],
    );
  }
}