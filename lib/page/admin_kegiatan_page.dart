import 'package:desa_go_aplikasi/page/detail_kegiatan_page.dart';
import 'package:desa_go_aplikasi/viewmodel/agenda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/posyandu_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rapat_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/ronda_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminKegiatanPage extends StatefulWidget {
  const AdminKegiatanPage({super.key});

  @override
  State<AdminKegiatanPage> createState() => _AdminKegiatanPageState();
}

class _AdminKegiatanPageState extends State<AdminKegiatanPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Ronda', 'Posyandu', 'Agenda', 'Rapat'];
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RondaViewModel>().loadRondaData();
        context.read<PosyanduViewmodel>().fetchPosyandu();
        context.read<AgendaViewmodel>().fetchAgenda();
        context.read<RapatViewmodel>().fetchRapat();
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  // --- MAPPING DATA UNTUK LIST ---
  List<Map<String, dynamic>> _mapAllDataToKegiatanList(BuildContext context) {
    List<Map<String, dynamic>> list = [];
    final rondaVM = context.watch<RondaViewModel>();
    final posyanduVM = context.watch<PosyanduViewmodel>();
    final agendaVM = context.watch<AgendaViewmodel>();
    final rapatVM = context.watch<RapatViewmodel>();

    Map<String, dynamic> determineStatus(String dateString, {String timeStart = '', String timeEnd = ''}) {
      try {
        DateTime date = DateTime.parse(dateString.split('T').first);
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        String formattedWaktu = (timeStart.isNotEmpty && timeEnd.isNotEmpty) ? '$timeStart - $timeEnd' : '08:00 - Selesai';

        if (date.isBefore(today)) {
          return {'status': 'Selesai', 'waktu': formattedWaktu};
        } else if (date.isAtSameMomentAs(today)) {
          return {'status': 'Berlangsung', 'waktu': formattedWaktu};
        } else {
          return {'status': 'Akan Datang', 'waktu': formattedWaktu};
        }
      } catch (e) {
        return {'status': 'N/A', 'waktu': 'N/A'};
      }
    }

    for (var r in rondaVM.listRonda) {
      String jamMulai = r.detailRondas?.isNotEmpty == true ? r.detailRondas!.first.jamMulai?.substring(0, 5) ?? '22:00' : '22:00';
      String jamSelesai = r.detailRondas?.isNotEmpty == true ? r.detailRondas!.first.jamSelesai?.substring(0, 5) ?? '04:00' : '04:00';
      var statusInfo = determineStatus(r.tanggal ?? '', timeStart: jamMulai, timeEnd: jamSelesai);
      list.add({
        'tipe': 'Ronda',
        'nama': 'Ronda Malam',
        'tanggal': r.tanggal?.split('T').first ?? 'N/A',
        'waktu': statusInfo['waktu'],
        'status': statusInfo['status'],
        'lokasi': r.lokasi ?? 'Pos Ronda',
      });
    }

    for (var p in posyanduVM.posyanduList) {
      var statusInfo = determineStatus(p.tanggal ?? '');
      list.add({'tipe': 'Posyandu', 'nama': p.judulPosyandu ?? 'Posyandu', 'tanggal': p.tanggal?.split('T').first ?? 'N/A', 'waktu': '08:00 - 11:00', 'status': statusInfo['status'], 'lokasi': p.lokasi ?? 'Balai Desa'});
    }

    for (var a in agendaVM.agendaList) {
      var statusInfo = determineStatus(a.tanggal ?? '');
      list.add({'tipe': 'Agenda', 'nama': a.namaAgenda ?? 'Agenda Desa', 'tanggal': a.tanggal?.split('T').first ?? 'N/A', 'waktu': '09:00 - Selesai', 'status': statusInfo['status'], 'lokasi': a.lokasi ?? 'Balai Desa'});
    }

    for (var rp in rapatVM.rapatList) {
      var statusInfo = determineStatus(rp.createdAt ?? '');
      list.add({'tipe': 'Rapat', 'nama': rp.judulRapat ?? 'Rapat Desa', 'tanggal': rp.createdAt?.split('T').first ?? 'N/A', 'waktu': '19:00 - Selesai', 'status': statusInfo['status'], 'lokasi': rp.lokasi ?? 'Kantor Desa'});
    }

    list.sort((a, b) => (b['tanggal'] ?? '').compareTo(a['tanggal'] ?? ''));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A4E8A);

    return Consumer4<RondaViewModel, PosyanduViewmodel, AgendaViewmodel, RapatViewmodel>(
      builder: (context, rondaVM, posyanduVM, agendaVM, rapatVM, child) {
        final allData = _mapAllDataToKegiatanList(context);
        final filteredKegiatan = allData.where((k) => k['tipe'] == _filters[_selectedFilterIndex]).toList();
        final isLoading = rondaVM.isLoading || posyanduVM.isLoading || agendaVM.isLoading || rapatVM.isLoading;

        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text('Jadwal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildDropdownTambah(context),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Column(
              children: [
                _buildFilterChips(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.wait([
                        context.read<RondaViewModel>().synchronizeRonda(),
                        context.read<PosyanduViewmodel>().fetchPosyandu(),
                        context.read<AgendaViewmodel>().fetchAgenda(),
                        context.read<RapatViewmodel>().fetchRapat(),
                      ]);
                    },
                    child: isLoading && filteredKegiatan.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : filteredKegiatan.isEmpty
                            ? ListView(children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                                Center(child: Text('Tidak ada ${_filters[_selectedFilterIndex]} yang ditemukan.', style: TextStyle(color: Colors.grey.shade600))),
                              ])
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                                itemCount: filteredKegiatan.length,
                                itemBuilder: (context, index) => _buildKegiatanCard(filteredKegiatan[index]),
                              ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- DROPDOWN TAMBAH KEGIATAN (REPLACING FAB) ---
  Widget _buildDropdownTambah(BuildContext context) {
    const Color actionColor = Color(0xFFFFCC33); // Warna Tombol Kuning
    const Color primaryColor = Color(0xFF4A4E8A); // Warna Ikon Ungu/Biru

    return PopupMenuButton<String>(
      offset: const Offset(0, -230), 
      
      color: Colors.white,            
      surfaceTintColor: Colors.white,  
      
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200, width: 1), 
      ),
      onSelected: (String value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tambah $value')));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildPopupItem("Ronda", Icons.nightlight_round, primaryColor),
        _buildPopupItem("Posyandu", Icons.child_care, primaryColor),
        _buildPopupItem("Agenda", Icons.event_note, primaryColor),
        _buildPopupItem("Rapat", Icons.groups, primaryColor),
      ],
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: actionColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Tambah Kegiatan',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(String label, IconData icon, Color color) {
    return PopupMenuItem<String>(
      value: label,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            label, 
            style: const TextStyle(
              color: Colors.black87, 
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            bool isSelected = _selectedFilterIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilterIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Text(_filters[index], style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.bold))),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKegiatanCard(Map<String, dynamic> kegiatan) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'Berlangsung': return const Color(0xFF4CAF50);
        case 'Akan Datang': return const Color(0xFF7A73C2);
        case 'Selesai': return const Color(0xFF2C2C2C);
        default: return Colors.grey;
      }
    }

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailKegiatanPage(kegiatan: kegiatan))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100, 
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: Colors.grey.shade300)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(kegiatan['nama']!, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: getStatusColor(kegiatan['status']!), borderRadius: BorderRadius.circular(10)),
                  child: Text(kegiatan['status']!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(kegiatan['tanggal']!, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(kegiatan['waktu']!, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Expanded(child: Text(kegiatan['lokasi']!, style: const TextStyle(fontSize: 13, color: Colors.black54), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}