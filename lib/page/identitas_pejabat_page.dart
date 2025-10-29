import 'package:flutter/material.dart';

class IdentitasPejabatPage extends StatelessWidget {
  // Variabel untuk menampung data yang dikirim dari halaman sebelumnya
  final Map<String, String> member;

  // Constructor untuk menerima data
  const IdentitasPejabatPage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: const Text(
          'Identitas Pejabat',
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
              children: [
                // Foto Profil
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/pejabat_profile.png'), // Ganti dengan path aset Anda
                ),
                const SizedBox(height: 32),

                // Daftar Informasi
                _buildInfoField(label: 'Jabatan', value: member['jabatan'] ?? 'N/A'),
                const SizedBox(height: 20),
                _buildInfoField(label: 'NIK', value: member['nik'] ?? 'N/A'),
                const SizedBox(height: 20),
                _buildInfoField(label: 'Nama', value: member['nama'] ?? 'N/A'),
                const SizedBox(height: 20),
                _buildInfoField(label: 'Alamat', value: member['alamat'] ?? 'N/A', maxLines: 3),
                const SizedBox(height: 20),
                _buildInfoField(label: 'No.Telp', value: member['telp'] ?? 'N/A'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper yang sama seperti halaman sebelumnya
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