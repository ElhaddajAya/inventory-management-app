import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_stock_management_app/Screens/LoginScreen.dart';

class MyAccountScreen extends StatelessWidget {
  final Map<String, String> adminData = {
    "name": "Claire Jackson",
    "email": "admin@epharmacy.com",
    "phone": "+02 82498270",
    "role": "Administrateur",
    "city": "Casablanca",
    "profileImage": "assets/images/pills.png", // Laisser vide si pas d'image
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Mon Compte", style: TextStyle(fontWeight: FontWeight.bold)
          ),
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
        body: Padding(
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
                  adminData["role"]!,
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
                            Icon(Icons.email, color: Colors.green,),
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
                            Icon(Icons.phone, color: Colors.lightBlueAccent),
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
                            Icon(Icons.location_on, color: Colors.deepPurpleAccent,),
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
                              onPressed: () {},
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginScreen())
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
