import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;
import 'package:desa_go_aplikasi/viewmodel/struktur_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminIdentitasPejabatPage extends StatefulWidget {
  final StrukturModel.Data dataPejabat;

  const AdminIdentitasPejabatPage({super.key, required this.dataPejabat});

  @override
  State<AdminIdentitasPejabatPage> createState() => _AdminIdentitasPejabatPageState();
}

class _AdminIdentitasPejabatPageState extends State<AdminIdentitasPejabatPage> {
  // Controllers untuk field identitas pejabat
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  
  // Controller Read-only untuk info organisasi
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data dari parameter dataPejabat
    _namaController.text = widget.dataPejabat.nama ?? '';
    _nikController.text = widget.dataPejabat.nik ?? '';
    _noTelpController.text = widget.dataPejabat.noTelp ?? '';
    _alamatController.text = widget.dataPejabat.alamat ?? '';
    
    // Data Pendukung (Read Only / Info)
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

  Future<void> _simpanPerubahan() async {
    if (_namaController.text.trim().isEmpty) {
      _showSnackbar('Nama tidak boleh kosong!', Colors.red);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Simulasi proses API
      await Future.delayed(const Duration(seconds: 1));
      
      _showSnackbar('Data pejabat berhasil diperbarui!', const Color(0xFF5CB85C));
      
      if (mounted) {
        // Refresh list melalui ViewModel
        Provider.of<StrukturViewModel>(context, listen: false).loadStruktur();
        Navigator.pop(context);
      }
    } catch (e) {
      _showSnackbar('Gagal menyimpan: ${e.toString()}', Colors.red);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Header Foto Profil
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: (widget.dataPejabat.foto != null && widget.dataPejabat.foto!.isNotEmpty)
                                  ? NetworkImage(widget.dataPejabat.foto!)
                                  : null,
                              child: (widget.dataPejabat.foto == null || widget.dataPejabat.foto!.isEmpty)
                                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Identitas Form
                      _buildInfoField(
                        label: 'Nama Lengkap',
                        controller: _namaController,
                        isEditable: true,
                        icon: Icons.person_outline,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoField(
                        label: 'NIK',
                        controller: _nikController,
                        isEditable: true,
                        icon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoField(
                        label: 'Jabatan',
                        controller: _jabatanController,
                        isEditable: false,
                        icon: Icons.work_outline,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoField(
                              label: 'RW',
                              controller: _rwController,
                              isEditable: false,
                              primaryColor: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoField(
                              label: 'RT',
                              controller: _rtController,
                              isEditable: false,
                              primaryColor: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildInfoField(
                        label: 'Nomor Telepon',
                        controller: _noTelpController,
                        isEditable: true,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoField(
                        label: 'Alamat',
                        controller: _alamatController,
                        isEditable: true,
                        icon: Icons.location_city,
                        maxLines: 3,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _simpanPerubahan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2C2C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required Color primaryColor,
    bool isEditable = false,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isEditable ? Colors.white : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            readOnly: !isEditable,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 15,
              color: isEditable ? Colors.black87 : Colors.grey.shade600,
            ),
            decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon, size: 20, color: primaryColor.withOpacity(0.7)) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}