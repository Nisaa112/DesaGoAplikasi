import 'package:desa_go_aplikasi/page/detail_kegiatan_page.dart';
import 'package:flutter/material.dart';

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  // Indeks untuk filter yang aktif
  int _selectedFilterIndex = 0;

  // Daftar label untuk filter
  final List<String> _filters = ['Ronda', 'Posyandu', 'Agenda', 'Rapat'];

  // [PERUBAHAN] Data dummy diperbarui dengan key 'tipe'
  final List<Map<String, dynamic>> _allKegiatan = [
    {'nama': 'Ronda Malam Sektor A', 'tanggal': 'Rabu, 16 Okt 2025', 'waktu': '00:00 - 02:00', 'status': 'Berlangsung', 'tipe': 'Ronda'},
    {'nama': 'Ronda Malam Sektor B', 'tanggal': 'Sabtu, 18 Okt 2025', 'waktu': '12:00 - 14:00', 'status': 'Akan Datang', 'tipe': 'Ronda'},
    {'nama': 'Ronda Malam Sektor C', 'tanggal': 'Selasa, 15 Okt 2025', 'waktu': '07:00 - 10:00', 'status': 'Selesai', 'tipe': 'Ronda'},
    {'nama': 'Ronda Malam Sektor D', 'tanggal': 'Rabu, 22 Okt 2025', 'waktu': '08:00 - 10:00', 'status': 'Akan Datang', 'tipe': 'Ronda'},
    {'nama': 'Posyandu Balita Melati', 'tanggal': 'Jumat, 24 Okt 2025', 'waktu': '09:00 - 11:00', 'status': 'Akan Datang', 'tipe': 'Posyandu'},
    {'nama': 'Rapat Persiapan HUT RI', 'tanggal': 'Senin, 27 Okt 2025', 'waktu': '19:30 - 21:00', 'status': 'Akan Datang', 'tipe': 'Rapat'},
  ];

  List<Map<String, dynamic>> _filteredKegiatan = [];

  @override
  void initState() {
    super.initState();
    _filterKegiatan();
  }

  // [PERUBAHAN] Logic filter diubah untuk memfilter berdasarkan 'tipe'
  void _filterKegiatan() {
    String selectedType = _filters[_selectedFilterIndex];
    setState(() {
      _filteredKegiatan = _allKegiatan.where((k) => k['tipe'] == selectedType).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        // [PERUBAHAN] Tombol kembali dihapus dan judul di tengah
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Kegiatan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _filteredKegiatan.length,
                itemBuilder: (context, index) {
                  return _buildKegiatanCard(_filteredKegiatan[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [PERUBAHAN] Filter chips sekarang horizontal scrollable
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
          _filterKegiatan();
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

  // Widget _buildKegiatanCard tidak perlu diubah, karena datanya masih sama
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