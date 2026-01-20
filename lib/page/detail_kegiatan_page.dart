import 'package:desa_go_aplikasi/models/ronda_model.dart' as Ronda;
import 'package:desa_go_aplikasi/models/posyandu_model.dart' as Posyandu;
import 'package:desa_go_aplikasi/models/agenda_model.dart' as Agenda;
import 'package:desa_go_aplikasi/models/rapat_model.dart' as Rapat;
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailKegiatanPage extends StatelessWidget {
  final Map<String, dynamic> kegiatan;

  const DetailKegiatanPage({super.key, required this.kegiatan});

  String formatCurrency(int? amount) {
    if (amount == null) return "Rp 0";
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  // Fungsi helper untuk mencari nama warga berdasarkan ID
  String getWargaNameById(BuildContext context, dynamic id) {
    if (id == null) return "-";
    final wargaVM = context.read<WargaViewModel>();
    try {
      final wargaId = int.parse(id.toString());
      final warga = wargaVM.listWarga.firstWhere((w) => w.id == wargaId);
      return warga.nama ?? "-";
    } catch (e) {
      return id.toString(); // Balikkan ID jika nama tidak ketemu
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'berlangsung': return const Color(0xFF4CAF50);
        case 'akan datang': return const Color(0xFF7A73C2);
        case 'selesai': return const Color(0xFF2C2C2C);
        default: return Colors.grey;
      }
    }

    final String tipe = kegiatan['tipe'] ?? 'Kegiatan';
    final String status = kegiatan['status'] ?? 'N/A';
    final dynamic dataAsli = kegiatan['original_data'];

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        centerTitle: true,
        title: Text('Detail $tipe', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(kegiatan['nama'] ?? '-', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: getStatusColor(status), borderRadius: BorderRadius.circular(20)),
                    child: Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInfoRow(Icons.calendar_today_outlined, kegiatan['tanggal'] ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.access_time, kegiatan['waktu'] ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on_outlined, kegiatan['lokasi'] ?? '-'),
              const SizedBox(height: 32),
              const Text('Informasi Lengkap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              const SizedBox(height: 12),

              // KONTEN BERDASARKAN TIPE
              if (tipe == 'Ronda') _buildRondaContent(context, dataAsli),
              if (tipe == 'Posyandu') _buildPosyanduContent(context, dataAsli),
              if (tipe == 'Agenda') _buildAgendaContent(context, dataAsli),
              if (tipe == 'Rapat') _buildRapatContent(context, dataAsli),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRondaContent(BuildContext context, Ronda.RondaData? r) {
    if (r == null) return const Text("-");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRichTextInfo('Ketua Regu (PJ)', getWargaNameById(context, r.penanggungJawab)),
        _buildRichTextInfo('Anggaran Konsumsi', formatCurrency(r.anggaran)),
        // _buildRichTextInfo('Sumber Kas', r.kas?.namaPengguna ?? '-'),
        _buildRichTextInfo('Keterangan', r.detail ?? '-'),
        const SizedBox(height: 20),
        const Text('Daftar Petugas:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(
            color: Colors.grey.shade300, 
            borderRadius: BorderRadius.circular(8),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2), // Nama
            1: FlexColumnWidth(2), // Area
            2: FlexColumnWidth(1), // Hadir
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade100), 
              children: const [
                _TableCell(text: 'Nama', isHeader: true),
                _TableCell(text: 'Area', isHeader: true),
                _TableCell(text: 'Hadir', isHeader: true),
              ],
            ),
            
            if (r.detailRondas != null)
              ...r.detailRondas!.map((dr) => TableRow(
                children: [
                  _TableCell(text: dr.warga?.nama ?? '-'),
                  _TableCell(text: dr.areaPatroli ?? '-'),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        dr.hadir == 1 ? Icons.check_circle : Icons.cancel,
                        color: dr.hadir == 1 ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              )).toList(), 
          ],
        )
      ],
    );
  }

  Widget _buildPosyanduContent(BuildContext context, Posyandu.Data? p) {
    if (p == null) return const Text("-");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRichTextInfo('Penanggung Jawab', getWargaNameById(context, p.penanggungJawab)),
        _buildRichTextInfo('Anggaran', formatCurrency(p.anggaran)),
        _buildRichTextInfo('Keterangan', p.keterangan ?? '-'),
        const SizedBox(height: 10),
        const Text('Ringkasan Hasil:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(p.ringkasanHasil ?? 'Belum ada ringkasan.', textAlign: TextAlign.justify),
      ],
    );
  }

  Widget _buildAgendaContent(BuildContext context, Agenda.Data? a) {
  if (a == null) return const Text("-");
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildRichTextInfo('Penanggung Jawab', a.penanggungJawab?.nama ?? '-'), 
      _buildRichTextInfo('Anggaran', formatCurrency(a.anggaran)),
        _buildRichTextInfo('Keterangan', a.keterangan ?? '-'),
        const SizedBox(height: 10),
        const Text('Hasil Kegiatan:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(a.hasil ?? 'Belum ada laporan hasil.', style: TextStyle(color: a.hasil == null ? Colors.grey : Colors.black)),
      ],
    );
  }

  Widget _buildRapatContent(BuildContext context, Rapat.Data? rp) {
    if (rp == null) return const Text("-");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRichTextInfo('Penanggung Jawab', getWargaNameById(context, rp.penanggungJawab)),
        _buildRichTextInfo('Anggaran', formatCurrency(rp.anggaran)),
        _buildRichTextInfo('Tujuan', rp.tujuan ?? '-'),
        const SizedBox(height: 10),
        const Text('Kesimpulan:', style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
          child: Text(rp.kesimpulan ?? 'Belum ada kesimpulan.', textAlign: TextAlign.justify),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) => Row(children: [Icon(icon, color: const Color(0xFF4A4E8A), size: 20), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(color: Colors.black54, fontSize: 16)))]);
  
  Widget _buildRichTextInfo(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: RichText(text: TextSpan(style: const TextStyle(fontSize: 15, color: Colors.black87), children: [TextSpan(text: '$label : ', style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: value, style: const TextStyle(color: Colors.black54))])));
}

class _TableCell extends StatelessWidget {
  final String text; final bool isHeader;
  const _TableCell({required this.text, this.isHeader = false});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(10.0), child: Text(text, style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal, fontSize: 13)));
  }
}