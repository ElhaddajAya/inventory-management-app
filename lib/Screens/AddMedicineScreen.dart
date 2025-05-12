import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMedicineScreen extends StatefulWidget {
  final String category;
  final String categoryId; // Ajout de l'ID

  AddMedicineScreen({required this.category, required this.categoryId});

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Liste des fournisseurs disponibles
  final List<Map<String, dynamic>> _providers = []; // Liste vide initialement
  String? _selectedProviderId;

  @override
  void initState() {
    super.initState();
    _fetchProviders();
  }

  Future<void> _fetchProviders() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
      body: {"action": "list_providers"},
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        _providers.clear();
        _providers.addAll(data.map<Map<String, dynamic>>((item) => {
          "id": item["id"],  // L'ID du fournisseur
          "name": item["name"],  // Nom du fournisseur
        }).toList());
      });
    } else {
      print("Erreur lors de la récupération des fournisseurs");
    }
  }

  // Clé pour la validation du formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Ajouter un médicament",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                        "${widget.category}",
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
                    fillColor: Colors.white,
                    filled: true,
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

                // Champ Stock
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
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
                    fillColor: Colors.white,
                    filled: true,
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
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: "Fournisseur",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    prefixIcon: Icon(Icons.store, color: Colors.lightBlueAccent),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  items: _providers.map((provider) {
                    return DropdownMenuItem<String>(
                      value: provider['id'].toString(),  // Utilisation de l'ID du fournisseur
                      child: Text(provider['name']),  // Affichage du nom du fournisseur
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
                          Navigator.pop(context); // Retour à l'écran précédent
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
                            final newMedicine = {
                              "name": _nameController.text,
                              "category_id": widget.categoryId,
                              "stock": int.parse(_stockController.text),
                              "price": double.parse(_priceController.text),
                              "provider_id": _selectedProviderId,
                            };

                            // Envoi des données vers l'API pour ajouter le médicament
                            final response = await http.post(
                              Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
                              body: {
                                "action": "add_medicine",
                                "name": newMedicine["name"],
                                "category_id": widget.categoryId,
                                "stock": newMedicine["stock"].toString(),
                                "price": newMedicine["price"].toString(),
                                "provider_id": newMedicine["provider_id"],
                              },
                            );

                            if (response.statusCode == 200) {
                              // Simplement retourner à l'écran précédent sans passer de données
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${_nameController.text} ajouté avec succès")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Erreur lors de l'ajout du médicament")),
                              );
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
                          "AJOUTER",
                          style: TextStyle(fontWeight: FontWeight.bold),
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