import 'package:flutter/material.dart';
import 'package:pharmacy_stock_management_app/Screens/CategoryScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/HomeScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/MyAccountScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/ProviderListScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _selectedIndex = 0;

  // Liste des pages à afficher selon l'index sélectionné
  final List<Widget> _pages = [
    HomeScreen(),
    CategoryScreen(),
    ProviderlistScreen(),
    MyAccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Affiche la page active
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.lightBlueAccent,
          indicatorColor: Colors.white.withOpacity(0.2), // Cercle autour de l'icône sélectionnée
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: "Acceuil",
              tooltip: "Acceuil",
            ),
            NavigationDestination(
              icon: Icon(Icons.category_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.category, color: Colors.white),
              label: "Catégories",
              tooltip: "Catégories",
            ),
            NavigationDestination(
              icon: Icon(Icons.store_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.store, color: Colors.white),
              label: "Fournisseurs",
              tooltip: "Fournisseurs",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.white),
              selectedIcon: Icon(Icons.person, color: Colors.white),
              label: "Profil",
              tooltip: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}


