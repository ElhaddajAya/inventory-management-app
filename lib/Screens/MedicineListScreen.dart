import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy_stock_management_app/Screens/AddMedicineScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/UpdateMedicineScreen.dart';

class MedicineListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  MedicineListScreen({required this.categoryId, required this.categoryName});

  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  List<Map<String, dynamic>> medicines = [];
  List<Map<String, dynamic>> filteredMedicines = []; // Pour la recherche
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController(); // Contrôleur pour la recherche

  @override
  void initState() {
    super.initState();
    fetchMedicines();

    // Ajouter un écouteur pour filtrer en temps réel
    _searchController.addListener(() {
      filterMedicines(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Méthode pour filtrer les médicaments selon le texte de recherche
  void filterMedicines(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredMedicines = List.from(medicines);
      } else {
        filteredMedicines = medicines
            .where((medicine) {
          final name = medicine["name"].toString().toLowerCase();
          final provider = medicine["provider"].toString().toLowerCase();
          final searchLower = searchText.toLowerCase();
          return name.contains(searchLower) || provider.contains(searchLower);
        })
            .toList();
      }
    });
  }

  Future<void> fetchMedicines() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
      body: {
        "action": "list_medicines_by_category",
        "category_id": widget.categoryId,
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        medicines = data.map<Map<String, dynamic>>((item) => {
          "id": item["id"].toString(), // Conversion en String
          "name": item["name"],
          "category": widget.categoryName,
          "stock": item["stock"] ?? 0,
          "price": item["price"] ?? 0.0,
          "image": 'assets/images/pills.png',
          "provider": item["provider"] ?? "Inconnu",
          "provider_id": item["provider_id"]?.toString() ?? "", // Conversion en String
          "category_id": widget.categoryId, // Ajout de category_id comme String
        }).toList();
        filteredMedicines = List.from(medicines); // Initialiser la liste filtrée
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Erreur lors du chargement des médicaments");
    }
  }

  Future<void> _deleteMedicine(String medicineId, String medicineName) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
        body: {
          "action": "delete_medicine",
          "id": medicineId.toString(),
        },
      );

      if (response.statusCode == 200) {
        // Rafraîchir la liste après la suppression
        fetchMedicines();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$medicineName supprimé avec succès")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la suppression du médicament")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion: $e")),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> medicine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Supprimer ${medicine['name']} ?"),
          backgroundColor: Colors.white,
          content: Text("Êtes-vous sûr de vouloir supprimer ce médicament ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler", style: TextStyle(color: Colors.lightBlueAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Appeler la fonction de suppression
                _deleteMedicine(medicine["id"].toString(), medicine["name"]);
              },
              child: Text("Supprimer", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Produits - ${widget.categoryName}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un médicament...",
                prefixIcon: Icon(Icons.search, color: Colors.lightBlueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    filterMedicines('');
                  },
                )
                    : null,
              ),
            ),
          ),

          // Contenu principal
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent))
                  : filteredMedicines.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _searchController.text.isEmpty
                            ? "Aucun médicament de catégorie ${widget.categoryName} n'est disponible."
                            : "Aucun résultat trouvé pour '${_searchController.text}'",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      "assets/images/pills.png",
                      width: 40,
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: filteredMedicines.length,
                itemBuilder: (context, index) {
                  final medicine = filteredMedicines[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 15, 15),
                      child: Row(
                        children: [
                          Image.asset(
                            medicine["image"],
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  medicine["name"],
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                        Icons.category, size: 15, color: Colors.grey),
                                    SizedBox(width: 5),
                                    Text(
                                      "${medicine["category"]}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
                                    Spacer(),
                                    Icon(Icons.production_quantity_limits, size: 15),
                                    SizedBox(width: 5),
                                    Text(
                                      "${medicine["stock"]}",
                                      style: TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.store, size: 15),
                                    SizedBox(width: 5),
                                    Text(
                                      "${medicine["provider"]}",
                                      style: TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${medicine["price"]} DH",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.lightBlueAccent,
                                onPressed: () async {
                                  final updatedMedicine = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateMedicineScreen(medicine: medicine),
                                    ),
                                  );
                                  if (updatedMedicine != null) {
                                    // Pas besoin d'une mise à jour locale, actualiser depuis l'API
                                    fetchMedicines();
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  _showDeleteConfirmation(context, medicine);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedicineScreen(
                category: widget.categoryName,
                categoryId: widget.categoryId,
              ),
            ),
          );
          // Rafraîchir la liste après être revenu de l'écran d'ajout
          fetchMedicines();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}