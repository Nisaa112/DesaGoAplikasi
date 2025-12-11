import 'package:flutter/material.dart';

class DetailKegiatanPage extends StatelessWidget {
  final Map<String, dynamic> kegiatan;

  const DetailKegiatanPage({super.key, required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'Berlangsung': return const Color(0xFF4CAF50);
        case 'Akan Datang': return const Color(0xFF7A73C2);
        case 'Selesai': return const Color(0xFF2C2C2C);
        default: return Colors.grey;
      }
    }

    final String title = kegiatan['title_detail'] ?? kegiatan['nama'] ?? 'Detail Kegiatan';
    final String tipe = kegiatan['tipe'] ?? 'Kegiatan';
    final String status = kegiatan['status'] ?? 'N/A';
    final String tanggal = kegiatan['tanggal'] ?? '-';
    final String waktu = kegiatan['waktu'] ?? '-';
    final String lokasi = kegiatan['lokasi'] ?? '-';
    final Color statusColor = getStatusColor(status);

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: Text(
          tipe, 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildInfoRow(Icons.calendar_today_outlined, tanggal),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.access_time, waktu),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on_outlined, lokasi),
              const SizedBox(height: 24),

              const Text('Informasi Detail', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),

              if (kegiatan['pj'] != null && kegiatan['pj'].toString().isNotEmpty)
                _buildRichTextInfo('Penanggung Jawab', kegiatan['pj']),

              if (kegiatan['tujuan'] != null && kegiatan['tujuan'].toString().isNotEmpty)
                _buildRichTextInfo('Tujuan', kegiatan['tujuan']),

              if (kegiatan['kesimpulan'] != null && kegiatan['kesimpulan'].toString().isNotEmpty)
                 Padding(
                   padding: const EdgeInsets.only(top: 8.0),
                   child: _buildRichTextInfo('Kesimpulan', kegiatan['kesimpulan']),
                 ),

              if (kegiatan['detail'] != null && kegiatan['detail'].toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Deskripsi / Catatan:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text(
                        kegiatan['detail'],
                        style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 16))),
      ],
    );
  }
  
  Widget _buildRichTextInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.4),
          children: [
            TextSpan(
              text: '$label : ',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}