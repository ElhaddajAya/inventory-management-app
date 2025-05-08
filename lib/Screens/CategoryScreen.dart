import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.6/pharmacy_api/api.php"), // Remplace l'URL selon ton cas
      body: {"action": "list_categories"},
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        categories = data.map<Map<String, dynamic>>((item) {
          return {
            "name": item["name"],
            "icon": _getIconData(item["icon"]),
            "color": _getColor(item["color"]),
          };
        }).toList();
      });
    } else {
      print("Erreur lors du chargement des catégories");
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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Nombre de colonnes (3 cases par ligne)
            crossAxisSpacing: 7, // Espacement horizontal entre les cases
            mainAxisSpacing: 7, // Espacement vertical entre les cases
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              // Lorsque l'utilisateur clique sur une catégorie, on ouvre l'écran des médicaments
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MedicineListScreen(category: categories[index]["name"]))
                );
              },
              onLongPress: () {
                // Afficher le menu contextuel
                _showCategoryMenu(context, categories[index]["name"]);
              },
              child: Card(
                color: Colors.white,
                elevation: 4, // Ombre autour des cartes pour un effet 3D
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centrer le contenu verticalement
                  children: [
                    Icon(
                      categories[index]["icon"],
                      size: 30,
                      color: categories[index]["color"],
                    ),
                    SizedBox(height: 10), // Espacement entre l'icône et le texte
                    Text(
                      categories[index]["name"],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {},
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }

  // Fonction pour afficher le menu contextuel
  void _showCategoryMenu(BuildContext context, String categoryName) {
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
                categoryName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.lightBlueAccent),
                title: Text("Modifier"),
                onTap: () {
                  Navigator.pop(context);
                  print("Modifier $categoryName");
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Supprimer"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$categoryName supprimé")),
                  );
                },
              ),
            ],
          ),
        );
      }
    );
  }
}