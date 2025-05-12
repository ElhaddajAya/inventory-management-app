import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  IconData? _selectedIcon;
  Color? _selectedColor;

  final Map<String, IconData> _icons = {
    "medical_services": Icons.medical_services,
    "healing": Icons.healing,
    "local_florist": Icons.local_florist,
    "liquor": Icons.liquor,
    "sanitizer": Icons.sanitizer,
    "cloud": Icons.cloud,
    "medication_liquid": Icons.medication_liquid,
    "medication": Icons.medication,
    // Nouvelles icônes ajoutées
    "vaccines": Icons.vaccines,
    "medical_information": Icons.medical_information,
    "health_and_safety": Icons.health_and_safety,
    "science": Icons.science,
    "biotech": Icons.biotech,
    "coronavirus": Icons.coronavirus,
    "air": Icons.air,
    "water_drop": Icons.water_drop,
  };

  final Map<String, Color> _colors = {
    "orange": Colors.orange,
    "lightGreen": Colors.lightGreen,
    "lightBlue": Colors.lightBlue,
    "redAccent": Colors.redAccent,
    "cyan": Colors.cyan,
    "deepPurpleAccent": Colors.deepPurpleAccent,
    "pinkAccent": Colors.pinkAccent,
    "yellow": Colors.yellow,
    // Nouvelles couleurs ajoutées
    "teal": Colors.teal,
    "indigo": Colors.indigo,
    "amber": Colors.amber,
    "brown": Colors.brown,
    "deepOrange": Colors.deepOrange,
    "lime": Colors.lime,
    "blueGrey": Colors.blueGrey,
    "purple": Colors.purple,
  };

  Future<void> _submitCategory() async {
    if (_formKey.currentState!.validate() && _selectedIcon != null && _selectedColor != null) {
      final iconName = _icons.entries.firstWhere((e) => e.value == _selectedIcon).key;
      final colorName = _colors.entries.firstWhere((e) => e.value == _selectedColor).key;

      final response = await http.post(
        Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
        body: {
          "action": "add_category",
          "name": _nameController.text,
          "icon": iconName,
          "color": colorName,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Retourner toutes les informations nécessaires
        Navigator.pop(context, {
          'id': data['id'], // Assurez-vous que votre API retourne l'ID
          'name': _nameController.text,
          'icon': iconName,
          'color': colorName,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Échec de l'ajout de la catégorie.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Ajouter une catégorie", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Nom de la catégorie",
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                  prefixIcon: Icon(Icons.label, color: Colors.lightBlueAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un nom";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<IconData>(
                value: _selectedIcon,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Icône",
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                  prefixIcon: Icon(Icons.image, color: Colors.lightBlueAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                  ),
                ),
                dropdownColor: Colors.white,
                items: _icons.entries.map((entry) {
                  return DropdownMenuItem<IconData>(
                    value: entry.value,
                    child: Row(children: [Icon(entry.value), SizedBox(width: 10), Text(entry.key)]),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedIcon = value),
                validator: (value) => value == null ? "Veuillez sélectionner une icône" : null,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<Color>(
                value: _selectedColor,
                decoration: InputDecoration(
                  labelText: "Couleur",
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                  prefixIcon: Icon(Icons.color_lens, color: Colors.lightBlueAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                dropdownColor: Colors.white,
                items: _colors.entries.map((entry) {
                  return DropdownMenuItem<Color>(
                    value: entry.value,
                    child: Row(children: [
                      Container(width: 20, height: 20, decoration: BoxDecoration(color: entry.value, shape: BoxShape.circle)),
                      SizedBox(width: 10),
                      Text(entry.key)
                    ]),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedColor = value),
                validator: (value) => value == null ? "Veuillez sélectionner une couleur" : null,
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.lightBlueAccent),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("ANNULER", style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitCategory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("AJOUTER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}