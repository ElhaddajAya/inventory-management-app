import 'package:flutter/material.dart';

class MedicineListScreen extends StatelessWidget {
  final String category; // Var. pour stocker la catégorie séléctionnée

  final List<Map<String, dynamic>> medicines = [
    {
      "name": "Amoxicilline",
      "category": "Antibiotiques",
      "stock": 20,
      "price": 50.0,
      "image": 'assets/images/pills.png',
      "provider": "PharmaPlus"
    },
    {
      "name": "Ibuprofène",
      "category": "Antalgiques",
      "stock": 10,
      "price": 30.0,
      "image": 'assets/images/pills.png',
      "provider": "MediPharm"
    }
  ];

  MedicineListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    // Filtrer les médicaments en fonction de la catégorie sélectionnée
    List<Map<String, dynamic>> filteredMedicines =
        medicines.where((med) => med["category"] == category).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Médicaments - $category",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: filteredMedicines.length <= 0 // Verifier c'est la liste des médicaments filtrés est vide
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Aucun médicament de catégorie $category n'est disponible.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20,),
                Image(
                  image: AssetImage("assets/images/pills.png"),
                  width: 40,
                )
              ],
            )
          )
          : ListView.builder(
          itemCount: filteredMedicines.length,
          itemBuilder: (context, index) {
            final medicine = filteredMedicines[index]; // Récuppérer chaque médicament
            return Card(
              margin: EdgeInsets.symmetric(vertical: 5), // Espacement entre chaque carte
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 15, 15),
                child: Row(
                  children: [
                    Container(
                      child: Image(
                        image: AssetImage(medicine["image"]),
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine["name"],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "${medicine["provider"]}",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Stock : ${medicine["stock"]}",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "MAD ${medicine["price"]}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              _showDeleteConfirmation(context, medicine["name"]);
                            },
                          )
                        ],
                      )
                    ],
                ),
              )
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

  // Fonction pour afficher une boîte de dialogue de confirmation avant suppression
  void _showDeleteConfirmation(BuildContext context, String medicineName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Supprimer $medicineName ?"),
          backgroundColor: Colors.white,
          content: Text("Êtes-vous sûr de vouloir supprimer ce médicament ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Annuler
              child: Text("Annuler", style: TextStyle(color: Colors.lightBlueAccent),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue"
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$medicineName supprimé")),
                );
              },
              child: Text("Supprimer", style: TextStyle(color: Colors.red)),
            )
          ],
        );
      }
    );
  }
}