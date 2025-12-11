import 'package:desa_go_aplikasi/page/bendahara_home_page.dart';
import 'package:desa_go_aplikasi/page/bendahara_informasi_publik_page.dart';
import 'package:desa_go_aplikasi/page/bendahara_keuangan_page.dart';
import 'package:desa_go_aplikasi/page/info_laporan_page.dart';
import 'package:desa_go_aplikasi/page/informasi_publik_page.dart';
import 'package:desa_go_aplikasi/page/kegiatan_page.dart';
import 'package:desa_go_aplikasi/page/keuangan_page.dart';
import 'package:desa_go_aplikasi/page/laporan_keuangan_page.dart';
import 'package:desa_go_aplikasi/page/pengaduan_page.dart';
import 'package:flutter/material.dart';

class BendaharaNavbarScreen extends StatefulWidget {
  const BendaharaNavbarScreen({super.key});

  @override
  State<BendaharaNavbarScreen> createState() => _BendaharaNavbarScreenState();
}

class _BendaharaNavbarScreenState extends State<BendaharaNavbarScreen> {
  int _selectedIndex = 0; 

  static const List<Widget> _pages = <Widget>[
    BendaharaHomePage(),
    BendaharaInformasiPublikPage(), 
    LaporanKeuanganPage(),
    BendaharaKeuanganPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget currentPage = _selectedIndex < _pages.length ? _pages.elementAt(_selectedIndex) : const BendaharaHomePage();

    return Scaffold(
      backgroundColor: Colors.white,
      body: currentPage,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
  
  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black,
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
            _buildNavItem(Icons.group, Icons.group_outlined, 1),
            _buildNavItem(Icons.receipt_long, Icons.receipt_long_outlined, 2), 
            _buildNavItem(Icons.account_balance_wallet, Icons.account_balance_wallet_outlined, 3), 
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData selectedIcon, IconData unselectedIcon, int index) {
    bool isSelected = _selectedIndex == index;
    if (index >= _pages.length) {
      return const SizedBox.shrink(); 
    }
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 60, 
        height: 50, 
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          color: isSelected ? Colors.black : Colors.white60,
          size: 28, 
        ),
      ),
    );
  }
}