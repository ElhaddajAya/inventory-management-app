import 'package:flutter/material.dart';
import 'package:pharmacy_stock_management_app/Screens/CategoryScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/HomeScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/LoginScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/MyAccountScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/OutOfStockScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/ProviderListScreen.dart';
import 'package:pharmacy_stock_management_app/Screens/SplashScreen.dart';
import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await sendOutOfStockNotification();
    return Future.value(true);
  });
}

Future<void> sendOutOfStockNotification() async {
  final response = await http.post(
    Uri.parse("http://192.168.1.6/pharmacy_api/api.php"),
    body: {"action": "list_out_of_stock_medicines"},
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);

    if (data.isNotEmpty) {
      String firstName = data[0]["name"];
      int total = data.length;

      String title = "Rupture de stock";
      String body = total == 1
          ? "$firstName est en rupture de stock."
          : "$firstName et ${total - 1} autres produits sont en rupture de stock.";

      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'out_of_stock_channel',
        'Ruptures de stock',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
        payload: "out_of_stock",
      );
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser WorkManager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Planifier une tâche périodique toutes les 15 minutes
  Workmanager().registerPeriodicTask("checkStockTask", "checkStockTask",
      frequency: Duration(minutes: 15));

  // Initialiser les notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@drawable/ic_notification');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload == "out_of_stock") {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => OutOfStockScreen()),
        );
      }
    },
  );

  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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


