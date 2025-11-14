import 'package:desa_go_aplikasi/page/home_page.dart';
import 'package:desa_go_aplikasi/page/info_laporan_page.dart';
import 'package:desa_go_aplikasi/page/informasi_publik_page.dart';
import 'package:desa_go_aplikasi/page/kegiatan_page.dart';
import 'package:desa_go_aplikasi/page/keuangan_page.dart';
import 'package:flutter/material.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int _selectedIndex = 0; 

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    InformasiPublikPage(), 
    InfoLaporanPage(),  
    KegiatanPage(),
    KeuanganPage(),
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            _buildNavItem(Icons.volunteer_activism, Icons.volunteer_activism_outlined, 2),
            _buildNavItem(Icons.calendar_month, Icons.calendar_month_outlined, 3),
            _buildNavItem(Icons.account_balance_wallet, Icons.account_balance_wallet_outlined, 4),
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
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          color: isSelected ? const Color(0xFF4A4E8A) : Colors.white60,
          size: 28,
        ),
      ),
    );
  }
}