import 'package:flutter/material.dart';
import 'package:pharmacy_stock_management_app/Screens/UpdateMedicineScreen.dart';
import 'MedicineListScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Produits",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: medicines.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Aucun médicament disponible.",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              Image.asset("assets/images/pills.png", width: 50),
            ],
          ),
        )
            : ListView.builder(
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 5),
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Image.asset(
                      medicine["image"],
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine["name"],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.category, size: 13, color: Colors.grey,),
                            SizedBox(width: 5,),
                            Text(
                              "${medicine["category"]}",
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Icon(Icons.store, size: 13,),
                            SizedBox(width: 5,),
                            Text(
                              "${medicine["provider"]}",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.production_quantity_limits, size: 13,),
                            SizedBox(width: 5,),
                            Text(
                              "${medicine["stock"]}",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${medicine["price"]} DH",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                            final updateMedicine = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateMedicineScreen(medicine: medicine)
                              )
                            );
                            if(updateMedicine != null) {
                              setState(() {
                                // Mettre à jour la liste des médicaments avec les nouvelles données
                                medicines[medicines.indexOf(medicine)] = updateMedicine;
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            _showDeleteConfirmation(context, medicine["name"]);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
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
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler", style: TextStyle(color: Colors.lightBlueAccent),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$medicineName supprimé")),
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
