import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/application.dart';
import '../services/firebase_service.dart';
import 'application_form_page.dart';

class ApplicationListPage extends StatefulWidget {
  const ApplicationListPage({super.key});

  @override
  State<ApplicationListPage> createState() => _ApplicationListPageState();
}

class _ApplicationListPageState extends State<ApplicationListPage> {
  String searchQuery = "";
  String statusFilter = "All";
  List<Application> applications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      List<Application> loadedApplications = await FirebaseService.getAllApplications();
      setState(() {
        applications = loadedApplications;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading applications: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Application> get filteredApplications {
    return applications.where((app) {
      bool matchesSearch = app.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          app.nidNumber.contains(searchQuery) ||
          app.phoneNumber.contains(searchQuery) ||
          app.vaccineName.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesStatus = statusFilter == "All" || app.status == statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> _deleteApplication(String id) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this application?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      bool success = await FirebaseService.deleteApplication(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadApplications(); // Reload the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete application'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateApplicationStatus(Application app) async {
    String? newStatus = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Application Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Pending'),
                leading: Radio<String>(
                  value: 'Pending',
                  groupValue: app.status,
                  onChanged: (value) => Navigator.of(context).pop(value),
                ),
              ),
              ListTile(
                title: const Text('Approved'),
                leading: Radio<String>(
                  value: 'Approved',
                  groupValue: app.status,
                  onChanged: (value) => Navigator.of(context).pop(value),
                ),
              ),
              ListTile(
                title: const Text('Rejected'),
                leading: Radio<String>(
                  value: 'Rejected',
                  groupValue: app.status,
                  onChanged: (value) => Navigator.of(context).pop(value),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (newStatus != null && newStatus != app.status) {
      String? adminComment;
      if (newStatus == 'Rejected') {
        adminComment = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            TextEditingController commentController = TextEditingController();
            return AlertDialog(
              title: const Text('Add Admin Comment'),
              content: TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Enter reason for rejection...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(commentController.text),
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
        if (adminComment == null) return; // User cancelled
      }

      bool success = await FirebaseService.updateApplicationStatus(
        app.id!,
        newStatus,
        adminComment,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application status updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadApplications(); // Reload the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update application status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showApplicationDetails(Application app) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Application Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Name', app.name),
                _buildDetailRow('Nationality', app.nationality),
                _buildDetailRow('NID Number', app.nidNumber),
                _buildDetailRow('Phone Number', app.phoneNumber),
                _buildDetailRow('Vaccine', app.vaccineName),
                _buildDetailRow('Submission Date', DateFormat.yMMMd().format(app.submissionDate)),
                _buildDetailRow('Status', app.status, textColor: _getStatusColor(app.status)),
                if (app.adminComment != null && app.adminComment!.isNotEmpty)
                  _buildDetailRow('Admin Comment', app.adminComment!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vaccination Applications"),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadApplications,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ApplicationFormPage(),
            ),
          );
          if (result == true) {
            _loadApplications(); // Reload if new application was added
          }
        },
        backgroundColor: const Color(0xFF1565C0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by Name, NID, Phone, or Vaccine",
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
          
          // Status Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: statusFilter,
              decoration: const InputDecoration(
                labelText: 'Filter by Status',
                border: OutlineInputBorder(),
              ),
              items: ["All", "Pending", "Approved", "Rejected"]
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  statusFilter = val!;
                });
              },
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Applications List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredApplications.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No applications found',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredApplications.length,
                        itemBuilder: (context, index) {
                          final app = filteredApplications[index];
                          return Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                app.name,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1565C0)),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text("Vaccine: ${app.vaccineName}"),
                                  Text("Phone: ${app.phoneNumber}"),
                                  Text("Submitted: ${DateFormat.yMMMd().format(app.submissionDate)}"),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(app.status).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      app.status,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _getStatusColor(app.status),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  switch (value) {
                                    case 'view':
                                      _showApplicationDetails(app);
                                      break;
                                    case 'edit':
                                      bool? result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ApplicationFormPage(application: app),
                                        ),
                                      );
                                      if (result == true) {
                                        _loadApplications();
                                      }
                                      break;
                                    case 'status':
                                      _updateApplicationStatus(app);
                                      break;
                                    case 'delete':
                                      _deleteApplication(app.id!);
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'view',
                                    child: ListTile(
                                      leading: Icon(Icons.visibility),
                                      title: Text('View Details'),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'status',
                                    child: ListTile(
                                      leading: Icon(Icons.update),
                                      title: Text('Update Status'),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: Icon(Icons.delete, color: Colors.red),
                                      title: Text('Delete', style: TextStyle(color: Colors.red)),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => _showApplicationDetails(app),
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
                