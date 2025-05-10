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
  // Clé pour la validation du formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs actuelles du médicament
    _nameController = TextEditingController(text: widget.medicine["name"]);
    _stockController = TextEditingController(text: widget.medicine["stock"].toString());
    _priceController = TextEditingController(text: widget.medicine["price"].toString());
    // Récupérer les fournisseurs depuis l'API
    _fetchProviders();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    fillColor: Colors.white,
                    filled: true,
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
                              // Préparer les données pour l'API
                              final medicineData = {
                                "id": widget.medicine["id"], // Assurez-vous d'avoir l'ID du médicament
                                "name": _nameController.text,
                                "stock": _stockController.text,
                                "price": _priceController.text,
                                "provider_id": _selectedProviderId,
                              };
                              // Appel à l'API pour mettre à jour
                              final response = await http.post(
                                Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
                                body: {
                                  "action": "update_medicine",
                                  "id": medicineData["id"],
                                  "name": medicineData["name"],
                                  "stock": medicineData["stock"],
                                  "price": medicineData["price"],
                                  "provider_id": medicineData["provider_id"],
                                  "category_id": widget.medicine["category_id"], // Ne pas oublier la catégorie
                                },
                              );
                              if (response.statusCode == 200) {
                                // Pour l'UI, construire l'objet medicine avec les données mises à jour
                                // Trouver le nom du fournisseur sélectionné pour l'affichage
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
                                };
                                // Retour à l'écran précédent avec succès
                                Navigator.pop(context, updatedMedicine);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${_nameController.text} modifié avec succès")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erreur lors de la mise à jour du médicament")),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Erreur: $e")),
                              );
                              print(e);
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