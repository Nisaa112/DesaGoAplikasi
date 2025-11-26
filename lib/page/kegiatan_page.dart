import 'package:desa_go_aplikasi/page/detail_kegiatan_page.dart';
import 'package:desa_go_aplikasi/viewmodel/agenda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/posyandu_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rapat_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/ronda_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desa_go_aplikasi/models/ronda_model.dart' as Ronda; 
import 'package:desa_go_aplikasi/models/posyandu_model.dart' as Posyandu;
import 'package:desa_go_aplikasi/models/agenda_model.dart' as Agenda;
import 'package:desa_go_aplikasi/models/rapat_model.dart' as Rapat;

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
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
        
        if (date.isBefore(DateTime(now.year, now.month, now.day))) {
          var formattedWaktu = (timeStart.isNotEmpty && timeEnd.isNotEmpty) ? '$timeStart - $timeEnd' : 'N/A';
          return {'status': 'Selesai', 'waktu': formattedWaktu};
        } else if (date.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
          var formattedWaktu = (timeStart.isNotEmpty && timeEnd.isNotEmpty) ? '$timeStart - $timeEnd' : 'N/A';
          return {'status': 'Berlangsung', 'waktu': formattedWaktu};
        } else {
          var formattedWaktu = (timeStart.isNotEmpty && timeEnd.isNotEmpty) ? '$timeStart - $timeEnd' : 'N/A';
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
        'nama': 'Ronda: ${r.lokasi}', 
        'tanggal': _formatDate(r.tanggal ?? 'N/A'), 
        'waktu': statusInfo['waktu'],
        'status': statusInfo['status'], 
        'tipe': 'Ronda',
        'data': r,
      });
    }

    for (var p in posyanduVM.posyanduList) {
      var statusInfo = _determineStatusAndTime(p.tanggal ?? '');
      list.add({
        'nama': p.judulPosyandu ?? 'Posyandu Tanpa Nama', 
        'tanggal': _formatDate(p.tanggal ?? 'N/A'), 
        'waktu': 'N/A', 
        'status': statusInfo['status'], 
        'tipe': 'Posyandu',
        'data': p,
      });
    }

    for (var a in agendaVM.agendaList) {
      var statusInfo = _determineStatusAndTime(a.tanggal ?? '');
      list.add({
        'nama': a.namaAgenda ?? 'Agenda Tanpa Nama', 
        'tanggal': _formatDate(a.tanggal ?? 'N/A'), 
        'waktu': 'N/A',
        'status': statusInfo['status'], 
        'tipe': 'Agenda',
        'data': a,
      });
    }
    
    for (var rp in rapatVM.rapatList) {
      var statusInfo = _determineStatusAndTime(rp.createdAt ?? ''); 
      list.add({
        'nama': rp.judulRapat ?? 'Rapat Tanpa Judul', 
        'tanggal': _formatDate(rp.createdAt ?? 'N/A'), 
        'waktu': 'N/A', 
        'status': statusInfo['status'], 
        'tipe': 'Rapat',
        'data': rp,
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
                      itemCount: filteredKegiatan.length, // Gunakan filteredKegiatan
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
    Map<String, dynamic> getStatusInfo(String status) {
      switch (status) {
        case 'Berlangsung':
          return {'color': const Color(0xFF4CAF50), 'text': 'Berlangsung'};
        case 'Akan Datang':
          return {'color': const Color(0xFF7A73C2), 'text': 'Akan Datang'};
        case 'Selesai':
          return {'color': const Color(0xFF2C2C2C), 'text': 'Selesai'};
        default:
          return {'color': Colors.grey, 'text': 'N/A'};
      }
    }
    
    var statusInfo = getStatusInfo(kegiatan['status']!);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailKegiatanPage(kegiatan: kegiatan)),
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
                    color: statusInfo['color'],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    statusInfo['text'],
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