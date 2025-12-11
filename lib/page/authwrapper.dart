import 'package:desa_go_aplikasi/page/admin_home_page.dart';
import 'package:desa_go_aplikasi/page/admin_navbar_screen.dart';
import 'package:desa_go_aplikasi/page/bendahara_home_page.dart';
import 'package:desa_go_aplikasi/page/bendahara_navbar_screen.dart';
import 'package:desa_go_aplikasi/page/home_page.dart';
import 'package:desa_go_aplikasi/page/login_page.dart';
import 'package:desa_go_aplikasi/page/navbar_screen.dart'; 
import 'package:desa_go_aplikasi/page/welcome_page.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    if (authViewModel.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!authViewModel.isLoggedIn) {
      return const WelcomePage();
    }

    final userRole = authViewModel.userRole?.toLowerCase() ?? '';

    switch (userRole) {
      case 'admin': 
        return const AdminNavbarScreen();
      case 'bendahara': 
        return const BendaharaNavbarScreen();
      case 'warga': 
        return const NavbarScreen();
      default:
        return Center(
            child: Text(
                "Role Pengguna Tidak Dikenal: $userRole. Silakan hubungi Admin."));
    }
  }
}