import 'package:desa_go_aplikasi/page/login_page.dart';
import 'package:desa_go_aplikasi/page/navbar_screen.dart';
import 'package:desa_go_aplikasi/page/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DesaGo! App',
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(), // WelcomePage tetap menjadi halaman awal
        '/login': (context) => const LoginPage(), // LoginPage tetap di rute /login
        
        // [PERUBAHAN UTAMA DI SINI]
        // Rute '/home' sekarang tidak lagi memanggil HomePage secara langsung,
        // tetapi memanggil MainScreen. MainScreen akan menampilkan HomePage
        // sebagai halaman default-nya (index 0) DAN juga menampilkan
        // BottomNavigationBar yang kita inginkan.
        '/home': (context) => const NavbarScreen(),
      },
    );
  }
}