import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmacy_stock_management_app/Screens/AddCategoryScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/UpdateCategoryScreen.dart';
import 'MedicineListScreen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreen createState() => _CategoryScreen();
}

class _CategoryScreen extends State<CategoryScreen> {
  // final List<Map<String, dynamic>> categories = [
  //   {"name": "Antibiotiques", "icon": Icons.medical_services, "color": Colors.orange},
  //   {"name": "Antalgiques", "icon": Icons.healing, "color": Colors.lightGreen},
  //   {"name": "Vitamines", "icon": Icons.local_florist, "color": Colors.lightBlue},
  //   {"name": "Sirop", "icon": Icons.liquor, "color": Colors.redAccent},
  //   {"name": "Antiseptiques", "icon": Icons.sanitizer, "color": Colors.cyan},
  //   {"name": "Allergies", "icon": Icons.cloud, "color": Colors.deepPurpleAccent},
  // ];

  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
      body: {"action": "list_categories"},
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        categories = data.map<Map<String, dynamic>>((item) {
          return {
            "id": item["id"],
            "name": item["name"],
            "icon": item["icon"], // garde le nom de l'icône
            "color": item["color"], // garde le nom de la couleur
            "displayIcon": _getIconData(item["icon"]),
            "displayColor": _getColor(item["color"]),
          };
        }).toList();
        isLoading = false;
      });
    } else {
      print("Erreur lors du chargement des catégories");
      setState(() {
        isLoading = false;
      });
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "medical_services": return Icons.medical_services;
      case "healing": return Icons.healing;
      case "local_florist": return Icons.local_florist;
      case "liquor": return Icons.liquor;
      case "sanitizer": return Icons.sanitizer;
      case "cloud": return Icons.cloud;
      case "medication_liquid": return Icons.medication_liquid;
      case "medication": return Icons.medication;
      default: return Icons.category;
    }
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case "orange": return Colors.orange;
      case "lightGreen": return Colors.lightGreen;
      case "lightBlue": return Colors.lightBlue;
      case "redAccent": return Colors.redAccent;
      case "cyan": return Colors.cyan;
      case "deepPurpleAccent": return Colors.deepPurpleAccent;
      case "pinkAccent": return Colors.pinkAccent;
      case "yellow": return Colors.yellow;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Catégories de Produits",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
            child: CircularProgressIndicator(color: Colors.lightBlueAccent),
          )
          : Padding(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicineListScreen(
                      categoryId: categories[index]["id"], // <-- ID au lieu du nom
                      categoryName: categories[index]["name"], // (facultatif) si tu veux l'afficher dans l'AppBar
                    ),
                  ),
                );
              },
              onLongPress: () {
                _showCategoryMenu(context, categories[index]);
              },
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(categories[index]["displayIcon"], size: 30, color: categories[index]["displayColor"]),
                    SizedBox(height: 10),
                    Text(categories[index]["name"], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () async {
          final newCategory = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCategoryScreen()),
          );

          if (newCategory != null) {
            // Au lieu d'ajouter manuellement, on rafraîchit toute la liste depuis l'API
            await fetchCategories();
          }
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }

  // Fonction pour afficher le menu contextuel
  void _showCategoryMenu(BuildContext context, Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                category["name"],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.lightBlueAccent),
                title: Text("Modifier"),
                onTap: () async {
                  Navigator.pop(context); // Fermer le menu
                  // Dans la méthode qui ouvre UpdateCategoryScreen
                  final updatedCategory = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateCategoryScreen(category: category),
                    ),
                  );

                  if (updatedCategory != null) {
                    await fetchCategories(); // Rafraîchir les données
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Supprimer"),
                onTap: () {
                  Navigator.pop(context);
                  _deleteCategory(category["name"]);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteCategory(String categoryName) async {
    final category = categories.firstWhere((c) => c["name"] == categoryName);
    final response = await http.post(
      Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
      body: {
        "action": "delete_category",
        "id": category["id"].toString(),
      },
    );

    final result = jsonDecode(response.body);
    if (result["success"] == true) {
      setState(() {
        categories.removeWhere((c) => c["name"] == categoryName);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$categoryName supprimée avec succès")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"] ?? "Impossible de supprimer cette catégorie"),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }
}