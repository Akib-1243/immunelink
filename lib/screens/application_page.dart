import 'package:flutter/material.dart';
import 'package:immunelink/screens/application.dart';
import 'package:immunelink/screens/firebase_service.dart';
import 'package:immunelink/screens/homePage.dart';
import 'package:immunelink/screens/profile.dart' hide Application;

class ApplicationFormPage extends StatefulWidget {
  final Application? application; // For editing existing application

  const ApplicationFormPage({super.key, this.application});

  @override
  State<ApplicationFormPage> createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _nidController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedVaccine = 'Pfizer';
  bool _isLoading = false;

  final List<String> _vaccines = [
    'Pfizer',
    'Moderna',
    'AstraZeneca',
    'Johnson & Johnson',
    'Sinovac',
    'Sinopharm'
  ];

  @override
  void initState() {
    super.initState();

    // If editing, populate form with existing data
    if (widget.application != null) {
      _nameController.text = widget.application!.name;
      _nationalityController.text = widget.application!.nationality;
      _nidController.text = widget.application!.nidNumber;
      _phoneController.text = widget.application!.phoneNumber;
      _selectedVaccine = widget.application!.vaccineName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nationalityController.dispose();
    _nidController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Application application = Application(
          id: widget.application?.id,
          name: _nameController.text.trim(),
          nationality: _nationalityController.text.trim(),
          vaccineName: _selectedVaccine,
          nidNumber: _nidController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          submissionDate: widget.application?.submissionDate ?? DateTime.now(),
          status: widget.application?.status ?? 'Pending',
          adminComment: widget.application?.adminComment,
        );

        bool success;
        if (widget.application == null) {
          // Create new application
          String? id = await FirebaseService.createApplication(application);
          success = id != null;
        } else {
          // Update existing application
          success = await FirebaseService.updateApplication(
              widget.application!.id!,
              application
          );
        }

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.application == null
                  ? 'Application submitted successfully!'
                  : 'Application updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        } else {
          throw Exception('Failed to save application');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new), // Custom icon
          onPressed: () {
            // Custom back button logic, if needed
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>homePage()));
          },
        ),
        title: Text(widget.application == null
            ? 'New Vaccination Application'
            : 'Edit Application'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      drawer: NavigationDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Nationality Field
                      TextFormField(
                        controller: _nationalityController,
                        decoration: const InputDecoration(
                          labelText: 'Nationality',
                          prefixIcon: Icon(Icons.flag),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your nationality';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // NID Number Field
                      TextFormField(
                        controller: _nidController,
                        decoration: const InputDecoration(
                          labelText: 'NID Number',
                          prefixIcon: Icon(Icons.credit_card),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your NID number';
                          }
                          if (value.trim().length < 10) {
                            return 'NID number must be at least 10 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone Number Field
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.trim().length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vaccination Information',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Vaccine Selection
                      DropdownButtonFormField<String>(
                        value: _selectedVaccine,
                        decoration: const InputDecoration(
                          labelText: 'Preferred Vaccine',
                          prefixIcon: Icon(Icons.vaccines),
                          border: OutlineInputBorder(),
                        ),
                        items: _vaccines.map((vaccine) {
                          return DropdownMenuItem<String>(
                            value: vaccine,
                            child: Text(vaccine),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedVaccine = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a vaccine';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  widget.application == null
                      ? 'Submit Application'
                      : 'Update Application',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({super.key});
  @override
  Widget build(BuildContext context) => Drawer(
      child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context),

              ]
          )
      )
  );
}

Widget buildHeader(BuildContext context) => Container(
  color: Colors.blue,
  padding: EdgeInsets.all(24),
);
Widget buildMenuItems(BuildContext context) => Column(
    children: [
      ListTile(
        leading: const Icon(Icons.account_balance_rounded),
        title: const Text('Home'),
        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>homePage())),
      ),
      ListTile(
        leading: const Icon(Icons.add_chart_rounded),
        title: const Text('Apply'),
        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ApplicationFormPage())),
      ),
      ListTile(
        leading: const Icon(Icons.account_circle),
        title: const Text('Account'),
        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ProfilePage())),
      )
    ]
);