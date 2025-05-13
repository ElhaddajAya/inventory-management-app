import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmacy_stock_management_app/Screens/config.dart';

class AddProviderScreen extends StatefulWidget {
  @override
  _AddProviderScreenState createState() => _AddProviderScreenState();
}

class _AddProviderScreenState extends State<AddProviderScreen> {
  // Contrôleurs pour les champs du formulaire
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // Liste des villes disponibles
  final List<String> _cities = ["Rabat", "Casablanca", "Marrakech", "Fès", "Tanger", "Safi", "Kénitra"];
  String? _selectedCity;

  // Clé pour la validation du formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Ajouter un fournisseur",
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
                // Champ Nom du fournisseur
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(

                    labelText: "Nom du fournisseur",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    prefixIcon: Icon(Icons.business, color: Colors.lightBlueAccent),
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
                      return "Veuillez entrer le nom du fournisseur";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Champ Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(

                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent),
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
                      return "Veuillez entrer l'email";
                    }
                    // Validation basique du format email
                    if (!value.contains('@') || !value.contains('.')) {
                      return "Veuillez entrer un email valide";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Champ Téléphone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(

                    labelText: "Téléphone",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    hintText: "Ex: 0111113124",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.phone, color: Colors.lightBlueAccent),
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
                      return "Veuillez entrer le numéro de téléphone";
                    }
                    // Vérification que la valeur ne contient que des chiffres
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return "Veuillez entrer un numéro valide";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Menu déroulant pour la ville
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  decoration: InputDecoration(
                    labelText: "Ville",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    prefixIcon: Icon(Icons.location_city, color: Colors.lightBlueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),

                  ),
                  dropdownColor: Colors.white,
                  items: _cities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCity = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez sélectionner une ville";
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
                            final response = await http.post(
                              Uri.parse("${baseURL}api.php"),
                              body: {
                                "action": "add_provider",
                                "name": _nameController.text,
                                "email": _emailController.text,
                                "phone": _phoneController.text,
                                "city": _selectedCity ?? '',
                              },
                            );

                            if (response.statusCode == 200) {
                              final result = jsonDecode(response.body);
                              if (result["success"] == true) {
                                Navigator.pop(context, true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${_nameController.text} ajouté avec succès")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erreur lors de l'ajout du fournisseur.")),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Erreur serveur (${response.statusCode})")),
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
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}