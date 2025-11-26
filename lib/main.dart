import 'package:desa_go_aplikasi/page/login_page.dart';
import 'package:desa_go_aplikasi/page/navbar_screen.dart';
import 'package:desa_go_aplikasi/page/authwrapper.dart';
import 'package:desa_go_aplikasi/page/welcome_page.dart';
import 'package:desa_go_aplikasi/viewmodel/agenda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/posyandu_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rapat_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/ronda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/struktur_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => WargaViewmodel()),
        ChangeNotifierProvider(create: (_) => StrukturViewModel()),
        ChangeNotifierProvider(create: (_) => RondaViewModel()),
        ChangeNotifierProvider(create: (_) => AgendaViewmodel()),
        ChangeNotifierProvider(create: (_) => RapatViewmodel()),
        ChangeNotifierProvider(create: (_) => PosyanduViewmodel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DesaGo! App',
        initialRoute: '/welcome',
        routes: {
          '/': (context) => AuthWrapper(),
          '/welcome': (context) => const WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const NavbarScreen(),
        },
      ),
    );
  }
}