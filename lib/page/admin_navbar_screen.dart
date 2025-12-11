import 'package:desa_go_aplikasi/page/admin_home_page.dart';
import 'package:desa_go_aplikasi/page/admin_informasi_publik_page.dart';
import 'package:desa_go_aplikasi/page/admin_kegiatan_page.dart';
import 'package:desa_go_aplikasi/page/admin_pengaduan_page.dart';
import 'package:desa_go_aplikasi/page/info_laporan_page.dart';
import 'package:desa_go_aplikasi/page/informasi_publik_page.dart';
import 'package:desa_go_aplikasi/page/kegiatan_page.dart';
import 'package:desa_go_aplikasi/page/keuangan_page.dart';
import 'package:desa_go_aplikasi/page/pengaduan_page.dart';
import 'package:flutter/material.dart';

class AdminNavbarScreen extends StatefulWidget {
  const AdminNavbarScreen({super.key});

  @override
  State<AdminNavbarScreen> createState() => _AdminNavbarScreenState();
}

class _AdminNavbarScreenState extends State<AdminNavbarScreen> {
  int _selectedIndex = 0; 

  static const List<Widget> _pages = <Widget>[
    AdminHomePage(),
    AdminInformasiPublikPage(), 
    AdminKegiatanPage(),
    KeuanganPage(),
    InfoLaporanPage(),  
    AdminPengaduanPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
  
  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(50), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, Icons.home_outlined, 0),
            _buildNavItem(Icons.groups, Icons.groups_outlined, 1),
            _buildNavItem(Icons.calendar_month, Icons.calendar_month_outlined, 2),
            _buildNavItem(Icons.account_balance_wallet, Icons.account_balance_wallet_outlined, 3),
            _buildNavItem(Icons.library_books, Icons.library_books_outlined, 4),
            _buildNavItem(Icons.support_agent, Icons.support_agent_outlined, 5),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData selectedIcon, IconData unselectedIcon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 55,
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          color: isSelected ? const Color(0xFF4A4E8A) : Colors.white60,
          size: 25,
        ),
      ),
    );
  }
}