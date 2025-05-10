import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pharmacy_stock_management_app/Screens/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Animation pour le fade-in
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Animation pour la rotation
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  // Animation pour le scale
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Configuration de l'animation de fade
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    // Configuration de l'animation de rotation
    _rotationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
        CurvedAnimation(parent: _rotationController, curve: Curves.elasticOut)
    );

    // Configuration de l'animation de scale (zoom)
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut)
    );

    // Démarrer les animations
    _fadeController.forward();
    _rotationController.forward();
    _scaleController.forward();

    // Rediriger vers LoginScreen après 3 secondes
    Timer(Duration(milliseconds: 3200), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent, // Fond bleu (inversé par rapport à LoginScreen)
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/icon de l'app (en blanc) avec rotation
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (_, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Icon(
                        Icons.local_pharmacy,
                        size: 120,
                        color: Colors.white, // Couleur blanche
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // App title (en blanc)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  "Stock Manager",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Couleur blanche
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              // Indicateur de chargement
              FadeTransition(
                opacity: _fadeAnimation,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}