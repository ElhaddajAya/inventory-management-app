import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateMedicineScreen extends StatefulWidget {
  final Map<String, dynamic> medicine;

  UpdateMedicineScreen({required this.medicine});

  @override
  _UpdateMedicineScreenState createState() => _UpdateMedicineScreenState();
}

class _UpdateMedicineScreenState extends State<UpdateMedicineScreen> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;
  late TextEditingController _providerController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine["name"]);
    _categoryController =
        TextEditingController(text: widget.medicine["category"]);
    _stockController =
        TextEditingController(text: widget.medicine["stock"].toString());
    _priceController =
        TextEditingController(text: widget.medicine["price"].toString());
    _providerController =
        TextEditingController(text: widget.medicine["provider"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mettre à Jour le Médicament"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
        )
    );
  }
}