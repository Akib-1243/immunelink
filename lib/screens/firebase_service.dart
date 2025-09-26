import 'package:firebase_database/firebase_database.dart';
import '../models/application.dart';

class FirebaseService {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static final DatabaseReference _applicationsRef = _database.ref().child('applications');

  // Create a new application
  static Future<String?> createApplication(Application application) async {
    try {
      DatabaseReference newApplicationRef = _applicationsRef.push();
      await newApplicationRef.set(application.toMap());
      return newApplicationRef.key;
    } catch (e) {
      print('Error creating application: $e');
      return null;
    }
  }

  // Get all applications
  static Future<List<Application>> getAllApplications() async {
    try {
      DatabaseEvent event = await _applicationsRef.once();
      DataSnapshot snapshot = event.snapshot;
      
      List<Application> applications = [];
      
      if (snapshot.value != null) {
        Map<dynamic, dynamic> applicationsMap = snapshot.value as Map<dynamic, dynamic>;
        
        applicationsMap.forEach((key, value) {
          applications.add(Application.fromMap(Map<String, dynamic>.from(value), key));
        });
      }
      
      return applications;
    } catch (e) {
      print('Error getting applications: $e');
      return [];
    }
  }

  // Get a single application by ID
  static Future<Application?> getApplicationById(String id) async {
    try {
      DatabaseEvent event = await _applicationsRef.child(id).once();
      DataSnapshot snapshot = event.snapshot;
      
      if (snapshot.value != null) {
        Map<String, dynamic> applicationData = Map<String, dynamic>.from(snapshot.value as Map);
        return Application.fromMap(applicationData, id);
      }
      return null;
    } catch (e) {
      print('Error getting application: $e');
      return null;
    }
  }

  // Update an application
  static Future<bool> updateApplication(String id, Application application) async {
    try {
      await _applicationsRef.child(id).update(application.toMap());
      return true;
    } catch (e) {
      print('Error updating application: $e');
      return false;
    }
  }

  // Update application status and admin comment
  static Future<bool> updateApplicationStatus(String id, String status, String? adminComment) async {
    try {
      await _applicationsRef.child(id).update({
        'status': status,
        'adminComment': adminComment,
      });
      return true;
    } catch (e) {
      print('Error updating application status: $e');
      return false;
    }
  }

  // Delete an application
  static Future<bool> deleteApplication(String id) async {
    try {
      await _applicationsRef.child(id).remove();
      return true;
    } catch (e) {
      print('Error deleting application: $e');
      return false;
    }
  }

  // Listen to real-time updates for all applications
  static Stream<List<Application>> getApplicationsStream() {
    return _applicationsRef.onValue.map((event) {
      List<Application> applications = [];
      
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> applicationsMap = event.snapshot.value as Map<dynamic, dynamic>;
        
        applicationsMap.forEach((key, value) {
          applications.add(Application.fromMap(Map<String, dynamic>.from(value), key));
        });
      }
      
      return applications;
    });
  }
}