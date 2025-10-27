import 'package:flutter/material.dart';

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  // 0 = Berlangsung, 1 = Mendatang, 2 = Selesai
  int _selectedFilterIndex = 0;

  // Data dummy untuk semua kegiatan
  final List<Map<String, String>> _allKegiatan = [
    {'nama': 'Ronda Malam Sektor A', 'tanggal': 'Rabu, 16 Okt 2025', 'waktu': '00:00 - 02:00', 'status': 'Berlangsung'},
    {'nama': 'Rapat', 'tanggal': 'Sabtu, 18 Okt 2025', 'waktu': '12:00 - 14:00', 'status': 'Akan Datang'},
    {'nama': 'Kerja Bakti', 'tanggal': 'Selasa, 15 Okt 2025', 'waktu': '07:00 - 10:00', 'status': 'Selesai'},
    {'nama': 'Posyandu', 'tanggal': 'Rabu, 22 Okt 2025', 'waktu': '08:00 - 10:00', 'status': 'Akan Datang'},
  ];

  List<Map<String, String>> _filteredKegiatan = [];

  @override
  void initState() {
    super.initState();
    _filterKegiatan(); // Panggil filter saat halaman pertama kali dibuka
  }

  void _filterKegiatan() {
    String status;
    switch (_selectedFilterIndex) {
      case 1:
        status = 'Akan Datang';
        break;
      case 2:
        status = 'Selesai';
        break;
      default:
        status = 'Berlangsung';
        break;
    }
    setState(() {
      _filteredKegiatan = _allKegiatan.where((k) => k['status'] == status).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: const Text('Kegiatan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
             if (Navigator.canPop(context)) {
               Navigator.pop(context);
             }
          },
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

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildChip("Berlangsung", 0),
          _buildChip("Mendatang", 1),
          _buildChip("Selesai", 2),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildKegiatanCard(Map<String, String> kegiatan) {
    // Helper untuk menentukan warna & teks badge
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

    return Container(
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
            padding: EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }
}