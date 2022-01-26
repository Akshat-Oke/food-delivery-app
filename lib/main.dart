import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fooddeli/auth/auth_manager.dart';
import 'package:fooddeli/firebase_options.dart';
import 'package:fooddeli/models/cart_provider.dart';
import 'package:fooddeli/models/login_manager.dart';
import 'package:provider/provider.dart';

import 'screens/menu_page.dart';
import 'screens/main_home_page.dart';
import 'utility/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartProvider>(
      create: (_) => CartProvider(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yummies',
        theme: THEME_DATA,
        home: ChangeNotifierProvider<LoginManager>(
          create: (_) => LoginManager(),
          builder: (context, _) => const AuthManager(),
        ),
      ),
    );
  }
}
