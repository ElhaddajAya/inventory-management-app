import 'package:flutter/material.dart';
import 'package:pharmacy_stock_management_app/Screens/CategoryScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/HomeScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/LoginScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/MyAccountScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/ProviderListScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/SplashScreen.dart';
import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

const taskName = "checkOutOfStockTask";
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == taskName) {
      // Appelle le serveur pour vérifier les stocks
      final response = await http.post(
        Uri.parse("http://192.168.1.6/pharmacy_api/api.php"), // adapte l'URL !
        body: {"action": "get_out_of_stock"},
      );

      final data = jsonDecode(response.body);
      if (data["out_of_stock"] != null && data["out_of_stock"] != "") {
        final name = data["out_of_stock"];

        // Notification
        const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'rupture_channel_id',
          'Rupture de stock',
          channelDescription: 'Notification quand un produit est en rupture',
          importance: Importance.max,
          priority: Priority.high,
        );

        const NotificationDetails notifDetails =
        NotificationDetails(android: androidDetails);

        await flutterLocalNotificationsPlugin.show(
          0,
          'Produit en rupture',
          '$name est en rupture de stock !',
          notifDetails,
        );
      }
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Initialiser Workmanager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  // Enregistrer la tâche périodique (20 secondes pour test)
  await Workmanager().registerPeriodicTask(
    "rupture_task_1", // ID unique
    taskName,
    frequency: Duration(minutes: 15), // ⚠️ Pour test. Minimum 15min en prod (Android)
    initialDelay: Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
      // home: LoginScreen(),  // Change ici la page d'accueil pour LoginScreen
      home: SplashScreen(),  // Nouvelle page d'accueil (SplashScreen)
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _selectedIndex = 0;

  // Liste des pages à afficher selon l'index sélectionné
  final List<Widget> _pages = [
    HomeScreen(),
    CategoryScreen(),
    ProviderlistScreen(),
    MyAccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Affiche la page active
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.lightBlueAccent,
          indicatorColor: Colors.white.withOpacity(0.2), // Cercle autour de l'icône sélectionnée
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: "Acceuil",
              tooltip: "Acceuil",
            ),
            NavigationDestination(
              icon: Icon(Icons.category_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.category, color: Colors.white),
              label: "Catégories",
              tooltip: "Catégories",
            ),
            NavigationDestination(
              icon: Icon(Icons.store_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.store, color: Colors.white),
              label: "Fournisseurs",
              tooltip: "Fournisseurs",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.white),
              selectedIcon: Icon(Icons.person, color: Colors.white),
              label: "Profil",
              tooltip: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}


