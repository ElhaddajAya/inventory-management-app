import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateCategoryScreen extends StatefulWidget {
  final Map<String, dynamic> category;

  UpdateCategoryScreen({required this.category});

  @override
  _UpdateCategoryScreenState createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
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
    "medication": Icons.medication
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
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category['name']);
    _selectedIcon = _icons[widget.category['icon']];
    _selectedColor = _colors[widget.category['color']];
  }

  Future<void> _updateCategory() async {
    if (_formKey.currentState!.validate() && _selectedIcon != null && _selectedColor != null) {
      final iconName = _icons.entries.firstWhere((e) => e.value == _selectedIcon).key;
      final colorName = _colors.entries.firstWhere((e) => e.value == _selectedColor).key;

      final response = await http.post(
        Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
        body: {
          "action": "update_category",
          "id": widget.category['id'].toString(),
          "name": _nameController.text,
          "icon": iconName,
          "color": colorName,
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        final updatedCategory = {
          'id': widget.category['id'],
          'name': _nameController.text,
          'icon': iconName,
          'color': colorName,
        };
        Navigator.pop(context, updatedCategory); // Retourner la catégorie mise à jour
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Échec de la mise à jour de la catégorie.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Modifier la catégorie", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nom de la catégorie
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nom de la catégorie",
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                  prefixIcon: Icon(Icons.label, color: Colors.lightBlueAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? "Veuillez entrer un nom" : null,
              ),
              SizedBox(height: 20),

              // Icône
              DropdownButtonFormField<IconData>(
                value: _selectedIcon,
                items: _icons.entries.map((entry) {
                  return DropdownMenuItem<IconData>(
                    value: entry.value,
                    child: Row(
                      children: [
                        Icon(entry.value),
                        SizedBox(width: 10),
                        Text(entry.key),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newIcon) {
                  setState(() {
                    _selectedIcon = newIcon;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Icône",
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                  ),
                  prefixIcon: Icon(Icons.image, color: Colors.lightBlueAccent),
                  fillColor: Colors.white,
                  filled: true,
                ),
                dropdownColor: Colors.white,
                validator: (value) => value == null ? "Veuillez sélectionner une icône" : null,
              ),

              SizedBox(height: 20),

              // Couleur
              DropdownButtonFormField<Color>(
                value: _selectedColor,
                items: _colors.entries.map((entry) {
                  return DropdownMenuItem<Color>(
                    value: entry.value,
                    child: Row(
                      children: [
                        Container(width: 20, height: 20, color: entry.value),
                        SizedBox(width: 10),
                        Text(entry.key),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newColor) {
                  setState(() {
                    _selectedColor = newColor;
                  });
                },
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
                validator: (value) => value == null ? "Veuillez sélectionner une couleur" : null,
              ),
              SizedBox(height: 30),

              // Boutons
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
                      onPressed: _updateCategory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("MODIFIER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
