import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/laporan_ronda_model.dart'; // Pastikan path model benar

class DetailLaporanRondaPage extends StatelessWidget {
  final LaporanRondaModel ronda; // Terima Objek Model

  const DetailLaporanRondaPage({super.key, required this.ronda});

  @override
  Widget build(BuildContext context) {
    // Format Tanggal Cantik (opsional, biar tidak kaku yyyy-mm-dd)
    String formattedDate = ronda.tanggal ?? '-';
    try {
      formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.parse(ronda.tanggal!));
    } catch (_) {}

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        title: const Text(
          'Detail Ronda',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4A4E8A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. JUDUL & TANGGAL
              Text(
                ronda.lokasi ?? 'Lokasi Tidak Diketahui',
                style: const TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black87
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(formattedDate, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
              
              const SizedBox(height: 24),

              // 2. CATATAN KEGIATAN
              const Text(
                "Catatan Kegiatan", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A4E8A))
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!)
                ),
                child: Text(
                  ronda.detail ?? '-', 
                  style: TextStyle(color: Colors.grey[800], height: 1.5)
                ),
              ),

              const SizedBox(height: 24),

              // 3. LAPORAN INSIDEN (Hanya muncul jika ada insiden)
              if (ronda.insiden != null && ronda.insiden!.isNotEmpty) ...[
                const Text(
                  "🚨 Laporan Insiden", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)
                ),
                const SizedBox(height: 8),
                ...ronda.insiden!.map((insiden) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red[100]!)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insiden.judul ?? 'Insiden', 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)
                      ),
                      const SizedBox(height: 4),
                      Text(insiden.deskripsi ?? '', style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
              ],

              // 4. DAFTAR PETUGAS
              const Text(
                "Daftar Petugas & Kehadiran", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A4E8A))
              ),
              const SizedBox(height: 12),
              
              if (ronda.petugas != null && ronda.petugas!.isNotEmpty)
                ...ronda.petugas!.map((p) {
                  // Cek hadir bisa berupa int (1) atau bool (true) tergantung API
                  bool isHadir = p.hadir == 1 || p.hadir == true;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
                      ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: isHadir ? const Color(0xFF46467A).withOpacity(0.1) : Colors.grey[100],
                              child: Icon(
                                Icons.person, 
                                size: 18, 
                                color: isHadir ? const Color(0xFF46467A) : Colors.grey
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              p.namaWarga ?? 'Tanpa Nama', 
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)
                            ),
                          ],
                        ),
                        // Badge Status
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isHadir ? Colors.green[50] : Colors.red[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isHadir ? Colors.green[100]! : Colors.red[100]!)
                          ),
                          child: Text(
                            isHadir ? 'Hadir' : 'Absen',
                            style: TextStyle(
                              fontSize: 11, 
                              fontWeight: FontWeight.bold, 
                              color: isHadir ? Colors.green : Colors.red
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                })
              else 
                const Text(
                  "Tidak ada data petugas.", 
                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)
                ),
                
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}