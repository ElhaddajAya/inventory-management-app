import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharmacy_stock_management_app/Screens/HomeScreen.dart';
import 'package:pharmacy_stock_management_app/main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  // clé pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50,),
                    // Logo/icon de l'app
                    Icon(
                      Icons.local_pharmacy,
                      size: 100,
                      color: Colors.lightBlueAccent,
                    ),
                    SizedBox(height: 20,),
                    // App title
                    Text(
                      "Stock Manager",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    // Champ Email/Username
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email ou nom d'utilisateur",
                        labelStyle: TextStyle(color: Colors.lightBlueAccent),
                        prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre email ou nom d'utilisateur";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Champ Mot de passe
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        labelStyle: TextStyle(color: Colors.lightBlueAccent),
                        prefixIcon: Icon(Icons.lock, color: Colors.lightBlueAccent),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre mot de passe";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    // Lien "Mot de passe oublié"
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Fonction pour mot de passe oublié
                          _showForgotPasswordDialog();
                        },
                        child: Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Bouton de connexion
                    ElevatedButton(
                      // onPressed: () {
                      //   // Validation du formulaire
                      //   if (_formKey.currentState!.validate()) {
                      //     Navigator.pushAndRemoveUntil(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => HomePage()),
                      //           (route) => false, // Cela supprime toutes les routes précédentes
                      //     );
                      //   }
                      // },
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _loginUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "SE CONNECTER",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fonction pour afficher une boîte de dialogue "Mot de passe oublié"
  void _showForgotPasswordDialog() {
    final TextEditingController _resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Réinitialiser le mot de passe"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Veuillez entrer votre adresse e-mail pour recevoir un lien de réinitialisation du mot de passe.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _resetEmailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                  prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique pour envoyer un email de réinitialisation
                // Pour l'instant, on va juste afficher un message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email de réinitialisation envoyé à ${_resetEmailController.text}")),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
              child: Text("Envoyer", style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.6/pharmacy_api/api.php"), // ⚠️ mets l'adresse exacte de ton fichier PHP
        body: {
          "action": "login", // ✅ INDISPENSABLE
          "email": email,
          "password": password,
        },
      );

      print("Réponse brute : ${response.body}");

      final data = jsonDecode(response.body);

      // Vérification que la réponse contient la clé "status" et qu'elle est égale à "success"
      if (data["status"] == "success") {
        // Vous pouvez ajouter une vérification des données spécifiques comme l'ID et le nom
        final fullName = data["full_name"] ?? "Nom inconnu"; // Si 'full_name' est null, on affecte une valeur par défaut
        final role = data["role"] ?? "Rôle inconnu"; // Si 'role' est null, on affecte une valeur par défaut

        print("Utilisateur connecté : $fullName, Rôle : $role");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Erreur inconnue")),
        );
      }
    } catch (e) {
      print("Erreur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Une erreur est survenue.")),
      );
    }
  }

  @override
  void dispose() {
    // Libérer les ressources des contrôleurs
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}