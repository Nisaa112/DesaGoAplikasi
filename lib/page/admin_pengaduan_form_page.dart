import 'package:desa_go_aplikasi/models/pengaduan_model.dart';
import 'package:desa_go_aplikasi/models/pengaduan_model.dart' as PengaduanModel;
import 'package:desa_go_aplikasi/viewmodel/pengaduan_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPengaduanFormPage extends StatefulWidget {
  final PengaduanModel.Data? pengaduan;
  const AdminPengaduanFormPage({super.key, this.pengaduan});

  @override
  State<AdminPengaduanFormPage> createState() => _AdminPengaduanFormPageState();
}

class _AdminPengaduanFormPageState extends State<AdminPengaduanFormPage> {
  String? _selectedKategori;
  final List<String> _kategoriList = ['Infrastruktur', 'Pelayanan', 'Lain-lain'];

  String? _selectedPrioritas;
  final List<String> _prioritasList = ['Rendah', 'Sedang', 'Tinggi'];
  
  // ✅ STATE DAN LIST STATUS UNTUK ADMIN
  String? _selectedStatus;
  // Nilai yang disimpan ke database (biasanya huruf kecil)
  final List<String> _statusList = ['pending', 'diproses', 'selesai']; 

  bool _isLaporanPublik = false;
  bool _isSubmitting = false;

  final TextEditingController _namaLaporanController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();
  final TextEditingController _ditugaskanUntukController = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    if (widget.pengaduan != null) {
      _namaLaporanController.text = widget.pengaduan!.judul ?? '';
      _pesanController.text = widget.pengaduan!.pesan ?? '';
      _ditugaskanUntukController.text = widget.pengaduan!.assignedTo ?? widget.pengaduan!.recipient ?? '';

      _selectedKategori = widget.pengaduan!.kategori;
      _selectedPrioritas = _mapPriorityIntToString(widget.pengaduan!.priority);
      _isLaporanPublik = widget.pengaduan!.isPublic ?? false;
      
      // ✅ INISIALISASI STATUS DARI DATA
      _selectedStatus = widget.pengaduan!.status; 
    } else {
      // Jika buat baru (oleh Admin), default status adalah 'pending'
      _selectedStatus = 'pending';
    }
  }

  String? _mapPriorityIntToString(int? priority) {
    if (priority == 1) return 'Rendah';
    if (priority == 2) return 'Sedang';
    if (priority == 3) return 'Tinggi';
    return null;
  }

  int? _mapPriorityStringToInt(String? priority) {
    if (priority == 'Rendah') return 1;
    if (priority == 'Sedang') return 2;
    if (priority == 'Tinggi') return 3;
    return null;
  }

  Future<void> _kirimPengaduan() async {
    // Validasi wajib diisi
    if (_namaLaporanController.text.isEmpty ||
        _pesanController.text.isEmpty ||
        _selectedKategori == null ||
        _selectedPrioritas == null ||
        _selectedStatus == null 
        ) {
        _showSnackbar('Semua field wajib diisi', Colors.red);
        return;
    }

    setState(() => _isSubmitting = true);
    final viewModel = Provider.of<PengaduanViewModel>(context, listen: false);
    final isEditMode = widget.pengaduan != null;

    final pengaduanToSave = PengaduanModel.Data(
      id: widget.pengaduan?.id,
      userId: widget.pengaduan?.userId ?? 1, 
      recipient: _ditugaskanUntukController.text.isNotEmpty ? _ditugaskanUntukController.text : null,
      kategori: _selectedKategori,
      judul: _namaLaporanController.text,
      pesan: _pesanController.text,
      status: _selectedStatus, // ✅ Hanya status yang mungkin berubah
      isPublic: _isLaporanPublik,
      priority: _mapPriorityStringToInt(_selectedPrioritas),
      createdAt: widget.pengaduan?.createdAt,
      updatedAt: widget.pengaduan?.updatedAt,
    );

    try {
      if (isEditMode) {
        await viewModel.updatePengaduan(pengaduanToSave);
        _showSnackbar('Status pengaduan berhasil diupdate!', const Color(0xFF5CB85C));
      } else {
        await viewModel.addPengaduan(pengaduanToSave);
        _showSnackbar('Pengaduan berhasil dikirim!', const Color(0xFF5CB85C));
      }

      if(mounted) Navigator.pop(context);

    } catch (e) {
      _showSnackbar('Gagal: ${e.toString()}', Colors.red);
      debugPrint('Error saat kirim/update pengaduan: $e');
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
  void dispose() {
    _namaLaporanController.dispose();
    _pesanController.dispose();
    _ditugaskanUntukController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A4E8A);
    final titleText = 'Update Status Pengaduan'; 

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          titleText,
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Header (Opsional, dibiarkan saja)
                Container(
                  height: 100, // Sedikit diperkecil biar hemat tempat
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt, // Ganti icon biar lebih cocok untuk admin
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ==========================
                // 1. KATEGORI (DISABLED)
                // ==========================
                const Text('Kategori', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildDropdownField(
                  value: _selectedKategori,
                  hint: 'Pilih kategori...',
                  items: _kategoriList,
                  enabled: false, // 🔒 DISABLED
                  onChanged: (newValue) {}, 
                ),
                const SizedBox(height: 20),

                // ==========================
                // 2. NAMA LAPORAN (DISABLED)
                // ==========================
                const Text('Nama Laporan', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _namaLaporanController,
                  hintText: 'Nama Laporan',
                  maxLines: 1,
                  enabled: false, // 🔒 DISABLED
                ),
                const SizedBox(height: 20),

                // ==========================
                // 3. PESAN (DISABLED)
                // ==========================
                const Text('Pesan (Deskripsi)', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _pesanController,
                  hintText: 'Pesan',
                  maxLines: 3,
                  enabled: false, // 🔒 DISABLED
                ),
                const SizedBox(height: 20),
                
                // ==========================
                // 4. STATUS PENGADUAN (ENABLED / BISA DIEDIT)
                // ==========================
                Row(
                  children: const [
                    Text('Status Pengaduan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                _buildDropdownField(
                  value: _selectedStatus,
                  hint: 'Pilih status...',
                  items: _statusList,
                  enabled: true, // ✅ ENABLED (HANYA INI YANG BISA DIUBAH)
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStatus = newValue; 
                    });
                  },
                ),
                const SizedBox(height: 20),

                // ==========================
                // 5. DITUGASKAN UNTUK (DISABLED)
                // ==========================
                const Text('Ditugaskan untuk', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _ditugaskanUntukController,
                  hintText: '-',
                  maxLines: 1,
                  enabled: false, // 🔒 DISABLED
                ),
                const SizedBox(height: 20),

                // ==========================
                // 6. PRIORITAS (DISABLED)
                // ==========================
                const Text('Prioritas', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildDropdownField(
                  value: _selectedPrioritas,
                  hint: 'Pilih prioritas...',
                  items: _prioritasList,
                  enabled: false, // 🔒 DISABLED
                  onChanged: (newValue) {},
                ),
                const SizedBox(height: 20),

                // ==========================
                // 7. PUBLIC RADIO (DISABLED)
                // ==========================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _isLaporanPublik,
                      // onChanged null membuat radio button disabled (abu-abu)
                      onChanged: null, // 🔒 DISABLED
                      activeColor: primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Laporan Publik',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          Text(
                            'Laporan ini bersifat ${_isLaporanPublik ? "Publik" : "Privat"}.',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // TOMBOL UPDATE
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _kirimPengaduan,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Simpan Status',
                      style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ MODIFIKASI: Menambahkan parameter `enabled`
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    bool enabled = true, // Default true
  }) {
    return Container(
      decoration: BoxDecoration(
        // Jika disabled, warnanya abu-abu
        color: enabled ? Colors.white : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled, // Mengontrol apakah bisa diketik
        style: TextStyle(
          color: enabled ? Colors.black87 : Colors.grey.shade700
        ),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
  
  // ✅ MODIFIKASI: Implementasi Null Safety yang lebih bersih dengan 'orElse'
  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool enabled = true, // Default true
  }) {
    // 1. Buat daftar item untuk ditampilkan (Contoh: 'pending' -> 'Pending')
    final displayItems = items.map((s) => s[0].toUpperCase() + s.substring(1)).toList();
    
    String? selectedDisplayValue;

    if (value != null) {
      const String notFoundValue = '__NOT_FOUND__'; 
      
      final foundItem = displayItems.firstWhere(
        (item) => item.toLowerCase() == value.toLowerCase(),
        orElse: () => notFoundValue, 
      );
      
      selectedDisplayValue = foundItem == notFoundValue ? null : foundItem;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        // Jika disabled, warnanya abu-abu
        color: enabled ? Colors.white : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedDisplayValue, 
          hint: Text(hint),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          style: TextStyle(
            // Jika disabled, teks sedikit lebih pudar
            color: enabled ? Colors.black87 : Colors.grey.shade700, 
            fontSize: 16
          ),
          // Jika enabled false, onChanged harus null agar dropdown tidak bisa diklik
          onChanged: enabled 
            ? (String? newValue) {
                // Simpan nilai ke model dalam format huruf kecil (sesuai list _statusList, dll.)
                onChanged(newValue?.toLowerCase()); 
              }
            : null, 
          items: displayItems.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}