import 'package:flutter/material.dart';

class ProviderlistScreen extends StatelessWidget {
  final List<Map<String, String>> fournisseurs = [
    {"nom": "PharmaPlus", "email": "contact@pharmaplus.com", "phone": "0111113124"},
    {"nom": "MediStock", "email": "info@medistock.com", "phone": "0111113124"},
    {"nom": "BioHealth", "email": "support@biohealth.com", "phone": "0111113124"},
  ];

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
        child: ListView.builder(
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
              child: Row(
                children: [
                  // Icône arrondie du magasin
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.store, size: 40, color: Colors.lightBlueAccent),
                  ),
                  SizedBox(width: 15),
                  // Détails du fournisseur
                  Column(

                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {},
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}