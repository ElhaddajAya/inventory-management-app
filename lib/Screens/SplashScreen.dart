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

    // Configuration de l'animation de fade (plus courte)
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Configuration de l'animation de rotation (avec une courbe plus fluide)
    _rotationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.fastOutSlowIn),
    );

    // Configuration de l'animation de scale (zoom)
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.fastOutSlowIn),
    );

    // Démarrer les animations séquentiellement
    _fadeController.forward().then((_) {
      _rotationController.forward();
      _scaleController.forward();
    });

    // Rediriger vers LoginScreen après que toutes les animations sont terminées
    _scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
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
            transitionDuration: Duration(milliseconds: 500),
          ),
        );
      }
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
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/icon de l'app avec rotation et scale
              AnimatedBuilder(
                animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
                builder: (_, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Icon(
                        Icons.local_pharmacy,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // App title avec scale
              ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  "Pharma Stock",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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