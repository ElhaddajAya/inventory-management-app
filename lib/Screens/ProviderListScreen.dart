import 'package:flutter/material.dart';
import 'package:pharmacy_stock_management_app/Screens/AddProviderScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/UpdateProviderScreen.dart';

class ProviderlistScreen extends StatefulWidget {
  @override
  _ProviderlistScreenState createState() => _ProviderlistScreenState();
}

class _ProviderlistScreenState extends State<ProviderlistScreen> {
  // Liste des fournisseurs (convertie en State pour pouvoir la modifier)
  final List<Map<String, String>> fournisseurs = [
    {"name": "PharmaPlus", "email": "contact@pharmaplus.com", "phone": "0111113124", "city": "Rabat"},
    {"name": "MediStock", "email": "info@medistock.com", "phone": "0111113948", "city": "Kénitra"},
    {"name": "BioHealth", "email": "support@biohealth.com", "phone": "0111119871", "city": "Safi"},
  ];

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
        child: fournisseurs.isEmpty
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
                margin: EdgeInsets.symmetric(vertical: 5), // Espacement entre chaque carte
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icône arrondie du magasin
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
                      // Détails du fournisseur
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
                              Icon(Icons.location_on, size: 13, color: Colors.grey,),
                              SizedBox(width: 5,),
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
                              SizedBox(width: 5,),
                              Text(
                                "${fourniss["email"]}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, ),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 13,),
                              SizedBox(width: 5,),
                              Text(
                                "${fourniss["phone"]}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, ),
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
                              // Navigation vers l'écran de mise à jour du fournisseur
                              final updatedProvider = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateProviderScreen(provider: fourniss),
                                ),
                              );

                              // Si un fournisseur mis à jour est retourné, mettre à jour la liste
                              if (updatedProvider != null) {
                                setState(() {
                                  fournisseurs[index] = updatedProvider;
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              _showDeleteConfirmation(context, fourniss["name"]!, index);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () async {
          // Navigation vers l'écran d'ajout de fournisseur
          final newProvider = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProviderScreen(),
            ),
          );

          // Si un nouveau fournisseur est retourné, l'ajouter à la liste
          if (newProvider != null) {
            setState(() {
              fournisseurs.add(newProvider);
            });
          }
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
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
              child: Text("Annuler", style: TextStyle(color: Colors.lightBlueAccent),),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Supprimer le fournisseur de la liste
                  fournisseurs.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$fournissName supprimé")),
                );
              },
              child: Text("Supprimer", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}