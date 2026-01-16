import 'package:desa_go_aplikasi/models/warga_model.dart';
import 'package:flutter/material.dart';

class IdentitasWargaPage extends StatelessWidget {
  final Data warga;

  const IdentitasWargaPage({super.key, required this.warga});

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari variabel warga
    final String nik = warga.nik ?? '-';
    final String nama = warga.nama ?? '-';
    final String alamat = warga.alamat ?? '-';
    final String noTelp = warga.noTelp ?? '-';
    
    // CARA MENGAMBIL RT: masuk ke objek rt lalu ambil namaRt
    final String namaRt = warga.rt?.namaRt ?? '-';

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
                _buildInfoField(
                  label: 'Nama Lengkap', 
                  value: nama, 
                  maxLines: 1
                ),
                const SizedBox(height: 20),
                
                // --- FIELD RT BARU ---
                _buildInfoField(
                  label: 'RT (Rukun Tetangga)', 
                  value: namaRt, 
                  maxLines: 1
                ),
                const SizedBox(height: 20),

                _buildInfoField(
                  label: 'Alamat', 
                  value: alamat, 
                  maxLines: 3 
                ),
                const SizedBox(height: 20),

                _buildInfoField(
                  label: 'No. Telepon', 
                  value: noTelp, 
                  maxLines: 1 
                ),
                const SizedBox(height: 20),

                _buildInfoField(
                  label: 'NIK', 
                  value: nik, 
                  maxLines: 1 
                ),
                const SizedBox(height: 40), 
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
          style: TextStyle(color: Colors.grey.shade700.withOpacity(0.7), fontSize: 16), 
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), 
            border: Border.all(color: Colors.black),
          ),
          child: Text(
            value,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}