import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy_stock_management_app/Screens/LoginScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/UpdateProfileScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  Map<String, String> adminData = {
    "name": "",
    "email": "",
    "phone": "",
    "role": "",
    "city": "",
    "profileImage": "",
  };

  bool isLoading = false;

  // Dans initState
  @override
  void initState() {
    super.initState();
    isLoading = true;
    _loadUserData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    if (userId == null) {
      print("Aucun ID trouvé");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${baseURL}api.php"),
        body: {
          "action": "get_user",
          "id": userId.toString(),
        },
      );

      // Vérifier le content-type
      if (response.headers['content-type']?.contains('application/json') == false) {
        throw FormatException("Réponse non JSON");
      }

      // Nettoyer la réponse avant le parsing
      String cleanedResponse = response.body.trim();
      if (cleanedResponse.startsWith('<br />')) {
        cleanedResponse = cleanedResponse.substring(cleanedResponse.indexOf('{'));
      }

      final data = jsonDecode(cleanedResponse);

      if (data["success"]) {
        final user = data["user"];
        setState(() {
          adminData = {
            "name": user["full_name"] ?? "",
            "email": user["email"] ?? "",
            "phone": user["phone"] ?? "",
            "role": user["role"] ?? "",
            "city": user["city"] ?? "",
            "profileImage": user["role"] == "admin" ? "assets/images/aya.png" : "assets/images/salma.png",
          };
        });
      } else {
        print("Erreur de chargement : ${data["message"]}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur de chargement des données")),
        );
      }
    } on FormatException catch (e) {
      print("Erreur de format: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de format des données reçues")),
      );
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
              "Mon Profil", style: TextStyle(fontWeight: FontWeight.bold)
          ),
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
        body: isLoading ?
          Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent))
          : Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image de profil
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.lightBlueAccent,
                    backgroundImage: adminData["profileImage"]!.isNotEmpty
                        ? AssetImage(adminData["profileImage"]!)
                        : null,
                    child: adminData["profileImage"]!.isEmpty
                        ? Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  SizedBox(height: 15,),
                  // Nom et rôle
                  Text(
                    adminData["name"]!,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    adminData["role"]! == "admin" ? "Pharmacien Admnistrateur" : "Pharmacien Assistant",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 15,),
                  // Email & telephone
                  Card(
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: 350,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Infos Personnelles",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.orange),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nom",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      adminData["name"]!,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            Divider(),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Icon(Icons.email, color: Colors.orange,),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      adminData["email"]!,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            Divider(),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Icon(Icons.phone, color: Colors.orange),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Téléphone",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      adminData["phone"]!,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.orange,),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ville",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      adminData["city"]!,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            // Boutons Modifier & Déconnexion
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10),
                                    backgroundColor: Colors.lightBlueAccent, // background color
                                    foregroundColor: Colors.white, // text color
                                    shape: CircleBorder(),
                                  ),
                                  onPressed: () async {
                                    // Ajoutez un await pour attendre le résultat
                                    final updatedData = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateProfileScreen(userData: adminData),
                                      ),
                                    );

                                    // Vérifiez si des données ont été retournées
                                    if (updatedData != null && updatedData is Map<String, String>) {
                                      // Forcez le rafraîchissement en rechargeant les données depuis l'API
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await _loadUserData();
                                      setState(() {
                                        isLoading = false;
                                      });

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Profil mis à jour avec succès")),
                                      );
                                    }
                                  },
                                  child: Icon(Icons.edit),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10),
                                    backgroundColor: Colors.red, // background color
                                    foregroundColor: Colors.white, // text color
                                    shape: CircleBorder(),
                                  ),
                                  onPressed: () {
                                    // Logout
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginScreen()),
                                    );
                                  },
                                  child: Icon(Icons.logout),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  )
                ],
              ),
            )
        )
    );
  }
}