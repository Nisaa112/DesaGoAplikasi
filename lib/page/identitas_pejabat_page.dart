import 'package:flutter/material.dart';
import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;

class IdentitasPejabatPage extends StatelessWidget {
  final StrukturModel.Data member;

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
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300, 
                  backgroundImage: member.foto != null
                    ? NetworkImage(member.foto!)
                    : null,
                child: member.foto == null
                    ? const Icon(Icons.person, color: Colors.white, size: 60,)
                    : null,
                ),
                const SizedBox(height: 32),

                _buildInfoField(label: 'Jabatan', value: member.jabatan?.namaJabatan ?? 'N/A'),
                const SizedBox(height: 20),
                // _buildInfoField(label: 'NIK', value: member.nik ?? 'N/A'),
                // const SizedBox(height: 20),
                _buildInfoField(label: 'Nama', value: member.nama ?? 'N/A'),
                const SizedBox(height: 20),
                _buildInfoField(label: 'Alamat', value: member.alamat ?? 'N/A', maxLines: 3),
                const SizedBox(height: 20),
                _buildInfoField(label: 'No.Telp', value: member.noTelp ?? 'N/A'),
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