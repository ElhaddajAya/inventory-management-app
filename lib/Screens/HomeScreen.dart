import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy_stock_management_app/Screens/AllMedicinesScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/OutOfStockScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/config.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final List<Map<String, dynamic>> medicines = [
  //   {
  //     "name": "Amoxicilline",
  //     "category": "Antibiotiques",
  //     "stock": 2,
  //     "price": 50.0,
  //     "provider": "PharmaPlus"
  //   },
  //   {
  //     "name": "Ibuprofène",
  //     "category": "Antalgiques",
  //     "stock": 10,
  //     "price": 30.0,
  //     "provider": "MediPharm"
  //   },
  //   {
  //     "name": "Paracétamol",
  //     "category": "Antalgiques",
  //     "stock": 0,
  //     "price": 25.0,
  //     "provider": "PharmaPlus"
  //   },
  //   {
  //     "name": "Vitamine C",
  //     "category": "Vitamines",
  //     "stock": 50,
  //     "price": 15.0,
  //     "provider": "BioHealth"
  //   },
  // ];
  //
  // final List<Map<String, String>> providers = [
  //   {"name": "PharmaPlus", "email": "contact@pharmaplus.com", "phone": "0111113124", "city": "Rabat"},
  //   {"name": "MediPharm", "email": "info@medipharm.com", "phone": "0111113948", "city": "Kénitra"},
  //   {"name": "BioHealth", "email": "support@biohealth.com", "phone": "0111119871", "city": "Safi"},
  // ];
  //
  // String _calculateOutOfStock() {
  //   List<String> outOfStock = medicines
  //       .where((medicine) => medicine["stock"] == 0)
  //       .map((medicine) => medicine["name"] as String)
  //       .toList();
  //   return outOfStock.isNotEmpty ? outOfStock.first : "Aucun";
  // }
  //
  // int _calculateTotalStock() {
  //   return medicines.fold<int>(
  //     0,
  //         (sum, medicine) => sum + (medicine["stock"] as int),
  //   );
  // }
  //
  // String _calculateLoyalProviders() {
  //   Map<String, int> providerCount = {};
  //   for (var medicine in medicines) {
  //     providerCount[medicine["provider"]] = (providerCount[medicine["provider"]] ?? 0) + 1;
  //   }
  //   List<String> loyalProviders = providerCount.entries
  //       .where((entry) => entry.value > 1)
  //       .map((entry) => entry.key)
  //       .toList();
  //   return loyalProviders.isNotEmpty ? loyalProviders.first : "Aucun";
  // }

  late String totalMedicines = "Chargement...";
  late String rupture = "Chargement...";
  late String loyalProvider = "Chargement...";
  late String mostExpensiveMedicine = "Chargement...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatistics();
    checkOutOfStock();
  }

  Future<void> checkOutOfStock() async {
    final url = '${baseURL}api.php';
    final response = await http.post(
      Uri.parse(url),
      body: {'action': 'get_out_of_stock'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        rupture = data['out_of_stock_count'].toString();
      });
    }
  }

  Future<void> fetchStatistics() async {
    final url = '${baseURL}api.php'; // Remplace par l'URL de ton API

    // D'abord, récupérer les statistiques générales
    final statsResponse = await http.post(
      Uri.parse(url),
      body: {'action': 'get_statistics'},
    );

    // Ensuite, récupérer le nombre de médicaments en rupture de stock
    final outOfStockResponse = await http.post(
      Uri.parse(url),
      body: {'action': 'get_out_of_stock'},
    );

    if (statsResponse.statusCode == 200 && outOfStockResponse.statusCode == 200) {
      final statsData = json.decode(statsResponse.body);
      final outOfStockData = json.decode(outOfStockResponse.body);

      setState(() {
        totalMedicines = statsData['total_medicines'].toString();
        rupture = outOfStockData['out_of_stock_count'].toString(); // Utilisation du nouveau champ
        loyalProvider = statsData['loyal_provider'];
        mostExpensiveMedicine = statsData['most_expensive_medicine'];
        isLoading = false;
      });
    } else {
      // Gérer les erreurs
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // String outOfStock = _calculateOutOfStock();
    // int totalStock = _calculateTotalStock();
    // String loyalProviders = _calculateLoyalProviders();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Tableau de Bord",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildStatisticCard(
                  "Produits en rupture",
                  rupture,
                  Colors.red,
                  Icon(Icons.production_quantity_limits, color: Colors.white, size: 30)
                ),
                _buildStatisticCard(
                  "Totals en stock",
                  "$totalMedicines",
                  Colors.green,
                  Icon(Icons.medication_liquid, color: Colors.white, size: 30)
                ),
                _buildStatisticCard(
                  "Fourniss. fidèle",
                  loyalProvider,
                  Colors.orange,
                  Icon(Icons.store, color: Colors.white, size: 30)
                ),
                _buildStatisticCard(
                  "Médic. le plus cher",
                  mostExpensiveMedicine,
                  Colors.blue,
                  Icon(Icons.attach_money, color: Colors.white, size: 30)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value, Color color, Icon icon) {
    return InkWell(
      onTap: () {
        if (title == "Produits en rupture") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OutOfStockScreen(),
            ),
          );
        } else if (title == "Totals en stock") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllMedicinesScreen(),
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 15),
              Text(
                value,
                style: TextStyle(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
