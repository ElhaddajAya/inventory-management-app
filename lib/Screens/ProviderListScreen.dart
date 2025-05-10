import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pharmacy_stock_management_app/Screens/AddProviderScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/UpdateProviderScreen.dart';

class ProviderlistScreen extends StatefulWidget {
  @override
  _ProviderlistScreenState createState() => _ProviderlistScreenState();
}

class _ProviderlistScreenState extends State<ProviderlistScreen> {
  List<Map<String, dynamic>> fournisseurs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProviders();
  }

  Future<void> fetchProviders() async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
        body: {"action": "list_providers"},
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        setState(() {
          fournisseurs = data.map<Map<String, dynamic>>((item) => {
            "id": item["id"].toString(),
            "name": item["name"],
            "email": item["email"],
            "phone": item["phone"],
            "city": item["city"],
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors du chargement des fournisseurs")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion: $e")),
      );
    }
  }

  Future<void> _deleteProvider(String providerId, String providerName, int index) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
        body: {
          "action": "delete_provider",
          "id": providerId,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse["success"] == true) {
          setState(() {
            fournisseurs.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$providerName supprimé")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jsonResponse["message"] ?? "Impossible de supprimer le fournisseur."),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la suppression")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Fournisseurs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: isLoading
            ? Center(
              child: CircularProgressIndicator(color: Colors.lightBlueAccent),
            )
            : fournisseurs.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Aucun fournisseur disponible",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              Icon(
                Icons.store_outlined,
                size: 40,
                color: Colors.grey,
              )
            ],
          ),
        )
            : ListView.builder(
          itemCount: fournisseurs.length,
          itemBuilder: (context, index) {
            final fourniss = fournisseurs[index];
            return Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.store, size: 30, color: Colors.orange),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${fourniss["name"]}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 13, color: Colors.grey),
                              SizedBox(width: 5),
                              Text(
                                "${fourniss["city"]}",
                                style: TextStyle(fontSize: 13, color: Colors.grey),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.email, size: 13),
                              SizedBox(width: 5),
                              Text(
                                "${fourniss["email"]}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 13),
                              SizedBox(width: 5),
                              Text(
                                "${fourniss["phone"]}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              )
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.lightBlueAccent,
                            onPressed: () async {
                              final updatedProvider = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateProviderScreen(provider: {
                                    "name": fourniss["name"],
                                    "email": fourniss["email"],
                                    "phone": fourniss["phone"],
                                    "city": fourniss["city"],
                                    "id": fourniss["id"],
                                  }),
                                ),
                              );

                              if (updatedProvider != null) {
                                setState(() {
                                  fournisseurs[index] = {
                                    ...fourniss,
                                    "name": updatedProvider["name"],
                                    "email": updatedProvider["email"],
                                    "phone": updatedProvider["phone"],
                                    "city": updatedProvider["city"],
                                  };
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              _showDeleteConfirmation(context, fourniss["name"], index);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // Attend le retour de AddProviderScreen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProviderScreen()),
          );

          // Si le fournisseur a été ajouté, on recharge la liste
          if (result == true) {
            fetchProviders();
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String fournissName, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Supprimer $fournissName ?"),
          backgroundColor: Colors.white,
          content: Text("Êtes-vous sûr de vouloir supprimer ce fournisseur ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler", style: TextStyle(color: Colors.lightBlueAccent)),
            ),
            TextButton(
              onPressed: () {
                _deleteProvider(fournisseurs[index]["id"], fournissName, index);
                Navigator.pop(context);
              },
              child: Text("Supprimer", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}