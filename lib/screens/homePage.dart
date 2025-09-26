import 'package:flutter/material.dart';
import 'package:immunelink/screens/admin_panel.dart';
import 'package:immunelink/screens/application_page.dart';
import 'package:immunelink/screens/profile.dart';
import 'package:immunelink/screens/tile1.dart';
import 'package:immunelink/screens/admin_login.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedIndex = 0;

  // pages for bottom navigation
  final List<Widget> _pages = [
    HomeContent(), // your home content
    AdminLoginPage(), // placeholder
    ProfilePage(), // profile dashboard
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.blueAccent), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: ""),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        drawer: NavigationDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  // Background Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    child: Container(
                      height: 350,
                      width: double.maxFinite,
                      child: Image.asset(
                        'assets/images/home.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Top-left menu icon
                  // App name text
                  const Positioned(
                    top: 90,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.only(top: 320, left: 10, right: 10),
                    child: Container(
                      height: 70,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightBlue[300],
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 10),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 70,
                            child: Image.asset("assets/images/search.png"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Recommended section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recommended",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "More",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ApplicationFormPage()),
    );
    },
                child: Container(
                  width: double.maxFinite,
                  height: 230,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      tile1(imagePath: "assets/images/hep.png", price: "\$400", name: "Pfizer"),
                      SizedBox(width: 20),
                      tile1(imagePath: "assets/images/bcg.png", price: "\$540", name: "Moderna"),
                      SizedBox(width: 20),
                      tile1(imagePath: "assets/images/mr.png", price: "\$630", name: "AstraZeneca"),
                      SizedBox(width: 20),
                      tile1(imagePath: "assets/images/mr.png", price: "\$630", name: "J & J"),
                      SizedBox(width: 20),
                      tile1(imagePath: "assets/images/mr.png", price: "\$630", name: "Sinovac"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Featured section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "    Featured",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "More",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: double.maxFinite,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      height: 20,
                      width: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/covid.png"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 20,
                      width: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/pcv.png"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 20,
                      width: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/opv.png"),
                        ),
                      ),
                    ),
                  ],
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
      leading: const Icon(Icons.home_outlined),
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