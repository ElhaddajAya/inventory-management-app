import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pharmacy_stock_management_app/Screens/AddProviderScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/UpdateProviderScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderlistScreen extends StatefulWidget {
  @override
  _ProviderlistScreenState createState() => _ProviderlistScreenState();
}

class _ProviderlistScreenState extends State<ProviderlistScreen> {
  List<Map<String, dynamic>> fournisseurs = [];
  List<Map<String, dynamic>> filteredFournisseurs = []; // Pour la recherche
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController(); // Contrôleur pour la recherche

  @override
  void initState() {
    super.initState();
    fetchProviders();

    // Ajouter un écouteur pour filtrer en temps réel
    _searchController.addListener(() {
      filterProviders(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Méthode pour filtrer les fournisseurs selon le texte de recherche
  void filterProviders(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredFournisseurs = List.from(fournisseurs);
      } else {
        filteredFournisseurs = fournisseurs
            .where((provider) {
          final name = provider["name"].toString().toLowerCase();
          final email = provider["email"].toString().toLowerCase();
          final city = provider["city"].toString().toLowerCase();
          final phone = provider["phone"].toString().toLowerCase();
          final searchLower = searchText.toLowerCase();

          return name.contains(searchLower) ||
              email.contains(searchLower) ||
              city.contains(searchLower) ||
              phone.contains(searchLower);
        })
            .toList();
      }
    });
  }

  void _callProvider(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible de lancer l'appel")),
      );
    }
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
          filteredFournisseurs = List.from(fournisseurs); // Initialiser la liste filtrée
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
            // Supprimer de la liste originale
            int originalIndex = fournisseurs.indexWhere((f) => f["id"] == providerId);
            if (originalIndex != -1) {
              fournisseurs.removeAt(originalIndex);
            }

            // Supprimer de la liste filtrée
            filteredFournisseurs.removeAt(index);
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
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un fournisseur...",
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
                    filterProviders('');
                  },
                )
                    : null,
              ),
            ),
          ),
          // Liste des fournisseurs
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(color: Colors.lightBlueAccent),
              )
                  : filteredFournisseurs.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _searchController.text.isEmpty
                          ? "Aucun fournisseur disponible"
                          : "Aucun résultat pour \"${_searchController.text}\"",
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
                itemCount: filteredFournisseurs.length,
                itemBuilder: (context, index) {
                  final fourniss = filteredFournisseurs[index];
                  return GestureDetector(
                      onLongPress: () {
                        _showProviderOptions(fourniss["name"], fourniss["phone"]);
                      },
                      child: Card(
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
                                            // Mise à jour dans les deux listes
                                            int originalIndex = fournisseurs.indexWhere((f) => f["id"] == fourniss["id"]);
                                            if (originalIndex != -1) {
                                              fournisseurs[originalIndex] = {
                                                ...fourniss,
                                                "name": updatedProvider["name"],
                                                "email": updatedProvider["email"],
                                                "phone": updatedProvider["phone"],
                                                "city": updatedProvider["city"],
                                              };
                                            }

                                            filteredFournisseurs[index] = {
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
                          ))
                  );
                },
              ),
            ),
          ),
        ],
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

  void _showProviderOptions(String name, String phone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.lightBlueAccent),
                title: Text("Contacter le fournisseur"),
                onTap: () {
                  Navigator.pop(context);
                  _callProvider(phone);
                },
              ),
            ],
          ),
        );
      },
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
                _deleteProvider(filteredFournisseurs[index]["id"], fournissName, index);
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