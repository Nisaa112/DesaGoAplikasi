import 'package:desa_go_aplikasi/page/login_page.dart';
import 'package:desa_go_aplikasi/page/navbar_screen.dart'; // <-- GANTI IMPORT HomePage ke NavbarScreen
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
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

    if (authViewModel.isLoggedIn) {
      return const NavbarScreen(); 
    } 
    else {
      return const LoginPage();
    }
  }
}