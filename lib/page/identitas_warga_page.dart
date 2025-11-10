import 'package:desa_go_aplikasi/models/warga_model.dart';
import 'package:flutter/material.dart';

class IdentitasWargaPage extends StatelessWidget {
   final Data warga;

  // Constructor ini MENERIMA data tersebut
  const IdentitasWargaPage({super.key, required this.warga});

  @override
  Widget build(BuildContext context) {
    // [PERUBAHAN] HAPUS variabel dummy 'warga' dari sini.
    // final Map<String, String> warga = { ... }; // <-- BARIS INI DIHAPUS

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: const Text(
          'Identitas Warga',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama: ${warga.nama ?? '-'}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('NIK: ${warga.nik ?? '-'}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Alamat: ${warga.alamat ?? '-'}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('No. Telepon: ${warga.noTelp ?? '-'}', style: TextStyle(fontSize: 18)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/identitas_illustration.png', // Ganti dengan path aset Anda
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField({required String label, required String value, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}