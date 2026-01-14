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
        context.read<RondaViewModel>().loadRondaData(fetchFromApi: true);
        context.read<PosyanduViewmodel>().fetchPosyandu(); 
        context.read<AgendaViewmodel>().fetchAgenda(); 
        context.read<RapatViewmodel>().fetchRapat(); 
      });
      _isInit = false; 
    }
    super.didChangeDependencies();
  }

  List<Map<String, dynamic>> _mapAllDataToKegiatanList(BuildContext context) {
    List<Map<String, dynamic>> list = [];
    
    final rondaVM = context.watch<RondaViewModel>();
    final posyanduVM = context.watch<PosyanduViewmodel>();
    final agendaVM = context.watch<AgendaViewmodel>();
    final rapatVM = context.watch<RapatViewmodel>();

    Map<String, dynamic> _determineStatusAndTime(String dateString, {String timeStart = '', String timeEnd = ''}) {
      try {
        DateTime date = DateTime.parse(dateString.split('T').first);
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        
        String formattedWaktu = (timeStart.isNotEmpty && timeEnd.isNotEmpty) ? '$timeStart - $timeEnd' : 'Lihat Detail';

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
    
    String _formatDate(String dateString) {
      try {
        return dateString.split('T').first;
      } catch (e) {
        return dateString;
      }
    }

    for (var r in rondaVM.listRonda) {
      String jamMulai = r.detailRondas?.isNotEmpty == true ? r.detailRondas!.first.jamMulai?.substring(0, 5) ?? '00:00' : '00:00';
      String jamSelesai = r.detailRondas?.isNotEmpty == true ? r.detailRondas!.first.jamSelesai?.substring(0, 5) ?? 'Selesai' : 'Selesai';
      
      var statusInfo = _determineStatusAndTime(r.tanggal ?? '', timeStart: jamMulai, timeEnd: jamSelesai);
      
      list.add({
        'tipe': 'Ronda',
        'nama': 'Ronda Malam', 
        'tanggal': _formatDate(r.tanggal ?? 'N/A'), 
        'waktu': statusInfo['waktu'],
        'status': statusInfo['status'], 
        
        'title_detail': 'Jadwal Ronda Wilayah', 
        'lokasi': r.lokasi ?? 'Pos Ronda',
        'detail': r.detail ?? 'Harap membawa peralatan ronda.', 
      });
    }

    for (var p in posyanduVM.posyanduList) {
      var statusInfo = _determineStatusAndTime(p.tanggal ?? '');
      list.add({
        'tipe': 'Posyandu',
        'nama': p.judulPosyandu ?? 'Posyandu', 
        'tanggal': _formatDate(p.tanggal ?? 'N/A'), 
        'waktu': '08:00 - 11:00',
        'status': statusInfo['status'], 
        
        'title_detail': p.judulPosyandu ?? 'Kegiatan Posyandu',
        'lokasi': p.lokasi ?? 'Balai Desa',
        'pj': p.penanggungJawab ?? '-',
      });
    }

    for (var a in agendaVM.agendaList) {
      var statusInfo = _determineStatusAndTime(a.tanggal ?? '');
      list.add({
        'tipe': 'Agenda',
        'nama': a.namaAgenda ?? 'Agenda Desa', 
        'tanggal': _formatDate(a.tanggal ?? 'N/A'), 
        'waktu': '09:00 - Selesai',
        'status': statusInfo['status'], 
        
        'title_detail': a.namaAgenda ?? 'Detail Agenda',
        'lokasi': a.lokasi ?? 'Balai Desa',
        'detail': 'Agenda rutin kegiatan desa.',
      });
    }
    
    for (var rp in rapatVM.rapatList) {
      var statusInfo = _determineStatusAndTime(rp.createdAt ?? ''); 
      list.add({
        'tipe': 'Rapat',
        'nama': rp.judulRapat ?? 'Rapat Desa', 
        'tanggal': _formatDate(rp.createdAt ?? 'N/A'), 
        'waktu': '19:00 - Selesai', 
        'status': statusInfo['status'], 
        
        'title_detail': rp.judulRapat ?? 'Detail Rapat',
        'lokasi': rp.lokasi ?? 'Kantor Desa',
        'tujuan': rp.tujuan ?? '-',        
        'kesimpulan': rp.kesimpulan ?? '-', 
      });
    }
    
    list.sort((a, b) => (b['tanggal'] ?? '').compareTo(a['tanggal'] ?? ''));
    
    return list;
  }
  
  List<Map<String, dynamic>> _filterKegiatan(List<Map<String, dynamic>> allData) {
    String selectedType = _filters[_selectedFilterIndex];
    return allData.where((k) => k['tipe'] == selectedType).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer4<RondaViewModel, PosyanduViewmodel, AgendaViewmodel, RapatViewmodel>(
      builder: (context, rondaVM, posyanduVM, agendaVM, rapatVM, child) {
        
        final allData = _mapAllDataToKegiatanList(context); 
        final filteredKegiatan = _filterKegiatan(allData); 
        final isLoading = rondaVM.isLoading || posyanduVM.isLoading || agendaVM.isLoading || rapatVM.isLoading;
        
        return Scaffold(
          backgroundColor: const Color(0xFF4A4E8A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF4A4E8A),
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text('Jadwal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          floatingActionButton: SizedBox(
            width: 200, 
            height: 50, 
            child: FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigasi ke halaman Tambah Kegiatan')),
                );
              },
              elevation: 0,
              backgroundColor: const Color(0xFFFFCC33),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                'Tambah Kegiatan',
                style: TextStyle(
                  color: Colors.black, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                _buildFilterChips(),
                if (isLoading && filteredKegiatan.isEmpty) 
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (filteredKegiatan.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'Tidak ada ${_filters[_selectedFilterIndex]} yang ditemukan.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: filteredKegiatan.length, 
                      itemBuilder: (context, index) {
                        return _buildKegiatanCard(filteredKegiatan[index]);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 4.0),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            return _buildChip(_filters[index], index);
          },
          separatorBuilder: (context, index) => const SizedBox(width: 12),
        ),
      ),
    );
  }

  Widget _buildChip(String label, int index) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
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
    
    var statusColor = getStatusColor(kegiatan['status']!);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailKegiatanPage(kegiatan: kegiatan),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kegiatan['nama']!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 1.0),
              child: Divider(color: Colors.grey),
            ),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.grey.shade600, size: 18),
                const SizedBox(width: 8),
                Text(kegiatan['tanggal']!, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey.shade600, size: 18),
                    const SizedBox(width: 8),
                    Text(kegiatan['waktu']!, style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    kegiatan['status']!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}