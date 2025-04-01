import 'package:flutter/material.dart';
import 'package:pharmacy_stock_management_app/Screens/CategoryScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/HomeScreen.dart';
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
    Container(), // User's account
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
      bottomNavigationBar: NavigationBar(
        height: 70, // Hauteur ajustée pour un look propre
        backgroundColor: Colors.white,
        indicatorColor: Colors.lightBlueAccent.withOpacity(0.2), // Cercle autour de l'icône sélectionnée
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services),
            label: "Produits",
            tooltip: "Produits",
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: "Catégories",
            tooltip: "Catégories",
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: "Fournisseurs",
            tooltip: "Fournisseurs",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Compte",
            tooltip: "Compte",
          ),
        ],
      ),
    );
  }
}


