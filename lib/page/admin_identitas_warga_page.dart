import 'package:desa_go_aplikasi/models/warga_model.dart' as Warga; // Diperbaiki: menggunakan prefix 'Warga'
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Diubah menjadi StatefulWidget agar bisa mengelola input form
class AdminIdentitasWargaPage extends StatefulWidget {
  // PERBAIKAN: Menggunakan Warga.Data
  final Warga.Data warga;

  // Constructor wajib memiliki data warga (untuk mode edit)
  const AdminIdentitasWargaPage({super.key, required this.warga});

  @override
  State<AdminIdentitasWargaPage> createState() => _AdminIdentitasWargaPageState();
}

class _AdminIdentitasWargaPageState extends State<AdminIdentitasWargaPage> {
  // Controllers untuk field yang bisa diubah
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Isi controllers dengan data warga yang diterima
    _nikController.text = widget.warga.nik ?? '';
    _namaController.text = widget.warga.nama ?? '';
    _alamatController.text = widget.warga.alamat ?? '';
    _noTelpController.text = widget.warga.noTelp ?? '';
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _noTelpController.dispose();
    super.dispose();
  }

  Future<void> _simpanPerubahan() async {
    if (_namaController.text.isEmpty || _nikController.text.isEmpty) {
      _showSnackbar('NIK dan Nama wajib diisi!', Colors.red);
      return;
    }

    setState(() => _isSubmitting = true);

    // PERBAIKAN: Menggunakan Warga.Data
    final updatedWarga = Warga.Data(
      id: widget.warga.id, 
      idRt: widget.warga.idRt, // Pertahankan data relasi (RT, User)
      idUsers: widget.warga.idUsers, 
      rt: widget.warga.rt,
      user: widget.warga.user,
      createdAt: widget.warga.createdAt,
      
      // Data yang diubah
      nik: _nikController.text,
      nama: _namaController.text,
      alamat: _alamatController.text,
      noTelp: _noTelpController.text,
      updatedAt: DateTime.now().toIso8601String(), // Update timestamp lokal
    );

    try {
      // PERBAIKAN: Mengganti WargaViewmodel menjadi WargaViewModel
      final viewModel = Provider.of<WargaViewModel>(context, listen: false);
      await viewModel.updateWarga(updatedWarga); 
      _showSnackbar('Data warga berhasil diperbarui!', const Color(0xFF5CB85C));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackbar('Gagal menyimpan perubahan: ${e.toString().split(':').last.trim()}', Colors.red);
      debugPrint('Error saat update warga: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A4E8A);
    const String titleText = 'Edit Warga'; // Diubah menjadi 'Edit Warga' untuk memperjelas tujuan

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          titleText,
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoField(
                        label: 'NIK', 
                        controller: _nikController, 
                        maxLines: 1,
                        isEditable: true, 
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoField(
                        label: 'Nama', 
                        controller: _namaController, 
                        maxLines: 1,
                        isEditable: true,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoField(
                        label: 'Alamat', 
                        controller: _alamatController, 
                        maxLines: 3,
                        isEditable: true,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoField(
                        label: 'No.Telp', 
                        controller: _noTelpController, 
                        maxLines: 1,
                        isEditable: true,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 40), 
                    ],
                  ),
                ),
              ),
            ),
            // Tombol Simpan Perubahan di bawah
            Container(
              padding: const EdgeInsets.all(24.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _simpanPerubahan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2C2C2C),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Simpan Perubahan',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi yang diubah untuk menggunakan TextField agar bisa diedit
  Widget _buildInfoField({
    required String label, 
    required TextEditingController controller, 
    int maxLines = 1,
    bool isEditable = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // const Color primaryColor = const Color(0xFF4A4E8A); // Tidak terpakai di sini
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w600), 
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isEditable ? Colors.white : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10), 
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: TextField(
            controller: controller,
            readOnly: !isEditable, 
            maxLines: maxLines,
            keyboardType: keyboardType,
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