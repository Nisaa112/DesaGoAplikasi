import 'package:desa_go_aplikasi/models/warga_model.dart' as Warga;
import 'package:desa_go_aplikasi/models/rt_model.dart' as RtModel;
import 'package:desa_go_aplikasi/utils/token_storage.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rt_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminTambahWargaPage extends StatefulWidget {
  const AdminTambahWargaPage({super.key});

  @override
  State<AdminTambahWargaPage> createState() => _AdminTambahWargaPageState();
}

class _AdminTambahWargaPageState extends State<AdminTambahWargaPage> {
  // Controllers untuk input form
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

  int? _selectedRtId;
  int? _currentAdminId; 

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RtViewModel>(context, listen: false).loadRt();
      _loadAdminId(); 
    });
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _noTelpController.dispose();
    super.dispose();
  }
  
  Future<void> _loadAdminId() async {
    final userId = await TokenStorage.getUserId(); 
    
    if (mounted) {
      setState(() {
        _currentAdminId = userId;
        debugPrint('ID Admin yang login: $_currentAdminId');
      });
    }
    if (_currentAdminId == null) {
      _showSnackbar('Gagal mendapatkan ID Admin. Silakan login ulang.', Colors.orange);
    }
  }

  Future<void> _tambahWarga() async {
      if (_namaController.text.isEmpty || 
        _nikController.text.isEmpty || 
        _alamatController.text.isEmpty ||
        _selectedRtId == null) { 
      _showSnackbar('NIK, Nama, Alamat, dan RT wajib diisi!', Colors.red);
      return;
    }

    setState(() => _isSubmitting = true);

    final newWarga = Warga.Data(
      nik: _nikController.text,
      nama: _namaController.text,
      alamat: _alamatController.text,
      noTelp: _noTelpController.text,
      idRt: _selectedRtId, 
      idUsers: null, // UBAH KE NULL
    );

    try {
      final viewModel = Provider.of<WargaViewModel>(context, listen: false);
      await viewModel.createWarga(newWarga); 
      _showSnackbar('Warga baru berhasil ditambahkan!', const Color(0xFF5CB85C));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackbar('Gagal menambahkan warga: ${e.toString().split(':').last.trim()}', Colors.red);
      debugPrint('Error saat menambah warga: $e');
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
    const String titleText = 'Tambah Warga';

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
                      _buildInputField(
                        label: 'NIK', 
                        controller: _nikController, 
                        hintText: 'cth: 8973294839847349', 
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        label: 'Nama', 
                        controller: _namaController, 
                        hintText: 'Masukkan nama Warga...',
                      ),
                      const SizedBox(height: 20),

                      _buildRtDropdown(),
                      const SizedBox(height: 20),
                      
                      _buildInputField(
                        label: 'Alamat', 
                        controller: _alamatController, 
                        hintText: 'Masukkan alamat...',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        label: 'No.Telp', 
                        controller: _noTelpController, 
                        hintText: 'cth: 081234567891', 
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 40), 
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _tambahWarga,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2C2C),
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
                        'Tambah Warga',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRtDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RT (Rukun Tetangga)',
          style: TextStyle(color: Colors.grey.shade700.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w600), 
        ),
        const SizedBox(height: 8),
        Consumer<RtViewModel>(
          builder: (context, rtViewModel, child) {
            if (rtViewModel.isLoading && rtViewModel.listRt.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            final List<RtModel.Data> rts = rtViewModel.listRt;
            
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), 
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _selectedRtId,
                  hint: Text(
                    rts.isEmpty ? 'Data RT belum tersedia' : 'Pilih RT...',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  dropdownColor: Colors.white, 
                  iconEnabledColor: const Color(0xFF4A4E8A),
                  items: rts.map((rt) {
                    return DropdownMenuItem<int>(
                      value: rt.id,
                      child: Text(
                        rt.namaRt ?? 'RT tidak diketahui', 
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    );
                  }).toList(),
                  onChanged: rts.isEmpty ? null : (int? newValue) {
                    setState(() {
                      _selectedRtId = newValue;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label, 
    required TextEditingController controller, 
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), 
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              border: InputBorder.none,
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade400),
            ),
          ),
        ),
      ],
    );
  }
}