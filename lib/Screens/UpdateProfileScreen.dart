import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_stock_management_app/Screens/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateProfileScreen extends StatefulWidget {
  final Map<String, String> userData;

  UpdateProfileScreen({required this.userData});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Liste des villes disponibles au Maroc
  final List<String> _cities = [
    "Casablanca", "Rabat", "Marrakech", "Fès", "Tanger",
    "Agadir", "Meknès", "Oujda", "Tétouan", "Safi",
    "El Jadida", "Kénitra", "Mohammedia", "Béni Mellal", "Nador"
  ];

  String? _selectedCity;

  // Clé pour la validation du formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs actuelles du profil
    _nameController = TextEditingController(text: widget.userData["name"]);
    _emailController = TextEditingController(text: widget.userData["email"]);
    _phoneController = TextEditingController(text: widget.userData["phone"]);
    _selectedCity = widget.userData["city"];

    // Si la ville actuelle n'est pas dans la liste, l'ajouter
    if (!_cities.contains(_selectedCity)) {
      _cities.add(_selectedCity!);
      // Trier la liste alphabétiquement
      _cities.sort();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
            "Modifier mon profil",
            style: TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image de profil avec option de modification
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.lightBlueAccent,
                      backgroundImage: widget.userData["profileImage"]!.isNotEmpty
                          ? AssetImage(widget.userData["profileImage"]!)
                          : null,
                      child: widget.userData["profileImage"]!.isEmpty
                          ? Icon(Icons.person, size: 50, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          onPressed: () {
                            // Logique pour changer l'image de profil
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Fonctionnalité à venir"))
                            );
                          },
                          constraints: BoxConstraints.tightFor(width: 36, height: 36),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(height: 30),

                // Champ Nom
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(

                    labelText: "Nom complet",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    prefixIcon: Icon(Icons.person, color: Colors.lightBlueAccent),
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
                      return "Veuillez entrer votre nom";
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
                      return "Veuillez entrer votre email";
                    }
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ]')),
                  ],
                  decoration: InputDecoration(

                    labelText: "Téléphone",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
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
                      return "Veuillez entrer votre numéro de téléphone";
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
                    prefixIcon: Icon(Icons.location_on, color: Colors.lightBlueAccent),
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
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              int? userId = prefs.getInt("user_id");

                              if (userId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erreur: Utilisateur non identifié")),
                                );
                                return;
                              }

                              final response = await http.post(
                                Uri.parse("${baseURL}api.php"),
                                body: {
                                  "action": "update_profile",
                                  "id": userId.toString(),
                                  "name": _nameController.text,
                                  "email": _emailController.text,
                                  "phone": _phoneController.text,
                                  "city": _selectedCity!,
                                },
                              );

                              final data = jsonDecode(response.body);
                              if (data["success"]) {
                                // Retournez TOUTES les données mises à jour
                                Navigator.pop(context, {
                                  "name": _nameController.text,
                                  "email": _emailController.text,
                                  "phone": _phoneController.text,
                                  "city": _selectedCity!,
                                  "role": widget.userData["role"]!,
                                  "profileImage": widget.userData["profileImage"]!,
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erreur lors de la mise à jour")),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Erreur: $e")),
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
                          "ENREGISTRER",
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
    super.dispose();
  }
}