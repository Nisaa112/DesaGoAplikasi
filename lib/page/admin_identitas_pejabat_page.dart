import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;
import 'package:flutter/material.dart';

class AdminIdentitasPejabatPage extends StatefulWidget {
  final StrukturModel.Data dataPejabat;

  const AdminIdentitasPejabatPage({super.key, required this.dataPejabat});

  @override
  State<AdminIdentitasPejabatPage> createState() => _AdminIdentitasPejabatPageState();
}

class _AdminIdentitasPejabatPageState extends State<AdminIdentitasPejabatPage> {
  // Controllers (Semua diset Read-Only untuk tampilan Identitas)
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi data dari parameter dataPejabat
    _namaController.text = widget.dataPejabat.nama ?? '';
    _nikController.text = widget.dataPejabat.nik ?? '';
    _noTelpController.text = widget.dataPejabat.noTelp ?? '';
    _alamatController.text = widget.dataPejabat.alamat ?? '';
    _jabatanController.text = widget.dataPejabat.jabatan?.namaJabatan ?? '-';
    _rwController.text = widget.dataPejabat.rw?.namaRw ?? '-';
    _rtController.text = widget.dataPejabat.rt?.namaRt ?? '-';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _noTelpController.dispose();
    _alamatController.dispose();
    _jabatanController.dispose();
    _rwController.dispose();
    _rtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A4E8A);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
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
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Foto Profil (Tanpa ikon kamera)
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (widget.dataPejabat.foto != null && widget.dataPejabat.foto!.isNotEmpty)
                        ? NetworkImage(widget.dataPejabat.foto!)
                        : null,
                    child: (widget.dataPejabat.foto == null || widget.dataPejabat.foto!.isEmpty)
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 32),
                
                _buildInfoField(
                  label: 'Nama Lengkap',
                  controller: _namaController,
                ),
                const SizedBox(height: 20),
                _buildInfoField(
                  label: 'NIK',
                  controller: _nikController,
                ),
                const SizedBox(height: 20),
                _buildInfoField(
                  label: 'Jabatan',
                  controller: _jabatanController,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoField(
                        label: 'RW',
                        controller: _rwController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoField(
                        label: 'RT',
                        controller: _rtController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInfoField(
                  label: 'Nomor Telepon',
                  controller: _noTelpController,
                ),
                const SizedBox(height: 20),
                _buildInfoField(
                  label: 'Alamat',
                  controller: _alamatController,
                  maxLines: 3,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // Background abu-abu karena read-only
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: TextField(
            controller: controller,
            readOnly: true, // Tidak bisa diedit
            maxLines: maxLines,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}