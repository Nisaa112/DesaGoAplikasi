import 'package:desa_go_aplikasi/page/admin_navbar_screen.dart';
import 'package:desa_go_aplikasi/page/bendahara_navbar_screen.dart';
import 'package:desa_go_aplikasi/page/login_page.dart';
import 'package:desa_go_aplikasi/page/navbar_screen.dart';
import 'package:desa_go_aplikasi/page/authwrapper.dart';
import 'package:desa_go_aplikasi/page/welcome_page.dart';
import 'package:desa_go_aplikasi/viewmodel/agenda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/jabatan_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/kas_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/pengaduan_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/posyandu_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rapat_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/ronda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rt_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rw_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/struktur_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/transaksi_kas_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/user_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/laporan_ronda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/laporan_agenda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/laporan_posyandu_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/laporan_rapat_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/laporan_keuangan_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('id', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => WargaViewModel()),
        ChangeNotifierProvider(create: (_) => StrukturViewModel()),
        ChangeNotifierProvider(create: (_) => RondaViewModel()),
        ChangeNotifierProvider(create: (_) => AgendaViewmodel()),
        ChangeNotifierProvider(create: (_) => RapatViewmodel()),
        ChangeNotifierProvider(create: (_) => PosyanduViewmodel()),
        ChangeNotifierProvider(create: (_) => PengaduanViewModel()),
        ChangeNotifierProvider(create: (_) => RtViewModel()),
        ChangeNotifierProvider(create: (_) => RwViewModel()),
        ChangeNotifierProvider(create: (_) => JabatanViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => KasViewModel()),
        ChangeNotifierProvider(create: (_) => TransaksiViewModel()),
        ChangeNotifierProvider(create: (_) => LaporanRondaViewModel()),
        ChangeNotifierProvider(create: (_) => LaporanAgendaViewModel()),
        ChangeNotifierProvider(create: (_) => LaporanPosyanduViewModel()),
        ChangeNotifierProvider(create: (_) => LaporanRapatViewModel()),
        ChangeNotifierProvider(create: (_) => LaporanKeuanganViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DesaGo! App',
        initialRoute: '/',
        routes: {
          '/': (context) => AuthWrapper(),
          '/welcome': (context) => const WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const NavbarScreen(),
          '/admin-home': (context) => const AdminNavbarScreen(),
          '/bendahara-home': (context) => const BendaharaNavbarScreen(),
        },
      ),
    );
  }
}