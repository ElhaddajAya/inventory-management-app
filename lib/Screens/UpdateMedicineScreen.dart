import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateMedicineScreen extends StatefulWidget {
  final Map medicine;
  UpdateMedicineScreen({required this.medicine});

  @override
  _UpdateMedicineScreenState createState() => _UpdateMedicineScreenState();
}

class _UpdateMedicineScreenState extends State<UpdateMedicineScreen> {
  late TextEditingController _nameController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;
  // Liste des fournisseurs disponibles
  final List<Map<String, dynamic>> _providers = [];
  String? _selectedProviderId;
  bool isLoading = true;

  final List<Map<String, dynamic>> _categories = [];
  String? _selectedCategoryId;

  // Clé pour la validation du formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine["name"]);
    _stockController = TextEditingController(text: widget.medicine["stock"].toString());
    _priceController = TextEditingController(text: widget.medicine["price"].toString());

    // Charger les fournisseurs et les catégories
    _fetchProviders();
    _fetchCategories();
  }

  Future<void> _fetchProviders() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
        body: {"action": "list_providers"},
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        setState(() {
          _providers.clear();
          _providers.addAll(data.map<Map<String, dynamic>>((item) => {
            "id": item["id"],
            "name": item["name"],
          }).toList());
          // Sélectionner le fournisseur actuel du médicament
          // Assurez-vous que provider_id existe dans votre objet medicine
          _selectedProviderId = widget.medicine["provider_id"]?.toString();

          // Si provider_id n'est pas disponible, chercher une correspondance par nom
          if (_selectedProviderId == null || _selectedProviderId!.isEmpty) {
            // Alternative: chercher le fournisseur par son nom
            var providerName = widget.medicine["provider"];
            var matchingProvider = _providers.firstWhere(
                    (p) => p["name"] == providerName,
                orElse: () => {"id": ""}
            );
            _selectedProviderId = matchingProvider["id"].toString();
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la récupération des fournisseurs")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
        body: {"action": "list_categories"},
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        setState(() {
          _categories.clear();
          _categories.addAll(data.map<Map<String, dynamic>>((item) => {
            "id": item["id"].toString(),
            "name": item["name"],
          }).toList());

          // Sélectionner la catégorie actuelle du médicament
          _selectedCategoryId = widget.medicine["category_id"]?.toString();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des catégories")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Modifier le médicament",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent))
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec rappel de la catégorie
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.category, color: Colors.orange),
                      SizedBox(width: 10),
                      Text(
                        "${widget.medicine["category"]}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Champ Nom du médicament
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(

                    labelText: "Nom du médicament",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    prefixIcon: Icon(Icons.medication, color: Colors.lightBlueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer le nom du médicament";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
// Menu déroulant pour la catégorie
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: "Catégorie",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    prefixIcon: Icon(Icons.category, color: Colors.lightBlueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),

                  ),
                  dropdownColor: Colors.white,
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['id'].toString(),
                      child: Text(category['name']),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategoryId = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez sélectionner une catégorie";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Champ Stock
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(

                    labelText: "Quantité en stock",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    prefixIcon: Icon(Icons.inventory, color: Colors.lightBlueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer la quantité en stock";
                    }
                    if (int.tryParse(value) == null) {
                      return "Veuillez entrer un nombre valide";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Champ Prix
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(

                    labelText: "Prix (DH)",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    hintText: "Ex: 45.50",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.monetization_on, color: Colors.lightBlueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer le prix";
                    }
                    if (double.tryParse(value) == null) {
                      return "Veuillez entrer un prix valide";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Menu déroulant pour le fournisseur
                DropdownButtonFormField<String>(
                  value: _selectedProviderId,
                  decoration: InputDecoration(
                    labelText: "Fournisseur",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    prefixIcon: Icon(Icons.store, color: Colors.lightBlueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),

                  ),
                  dropdownColor: Colors.white,
                  items: _providers.map((provider) {
                    return DropdownMenuItem<String>(
                      value: provider['id'].toString(),
                      child: Text(provider['name']),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedProviderId = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez sélectionner un fournisseur";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context); // Retour à l'écran précédent sans sauvegarder
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.lightBlueAccent),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "ANNULER",
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final response = await http.post(
                                Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
                                body: {
                                  "action": "update_medicine",
                                  "id": widget.medicine["id"].toString(),
                                  "name": _nameController.text,
                                  "stock": _stockController.text,
                                  "price": _priceController.text,
                                  "provider_id": _selectedProviderId,
                                  "category_id": _selectedCategoryId,
                                },
                              );

                              if (response.statusCode == 200) {
                                // Trouver le nom de la catégorie sélectionnée
                                String categoryName = widget.medicine["category"]; // Garde l'ancien nom par défaut
                                if (_selectedCategoryId != null) {
                                  final selectedCategory = _categories.firstWhere(
                                        (c) => c["id"].toString() == _selectedCategoryId,
                                    orElse: () => {"name": widget.medicine["category"]},
                                  );
                                  categoryName = selectedCategory["name"];
                                }

                                // Trouver le nom du fournisseur sélectionné
                                String providerName = "Inconnu";
                                if (_selectedProviderId != null) {
                                  final selectedProvider = _providers.firstWhere(
                                        (p) => p["id"].toString() == _selectedProviderId,
                                    orElse: () => {"name": "Inconnu"},
                                  );
                                  providerName = selectedProvider["name"];
                                }

                                final updatedMedicine = {
                                  ...widget.medicine,
                                  "name": _nameController.text,
                                  "stock": int.parse(_stockController.text),
                                  "price": double.parse(_priceController.text),
                                  "provider_id": _selectedProviderId,
                                  "provider": providerName,
                                  "category_id": _selectedCategoryId,
                                  "category": categoryName,
                                };

                                Navigator.pop(context, updatedMedicine);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${_nameController.text} modifié avec succès")),
                                );
                              }
                            } catch (e) {
                              print("Erreur lors de la mise à jour: $e");
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "MODIFIER",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libérer les ressources
    _nameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}