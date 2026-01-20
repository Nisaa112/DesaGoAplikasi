import 'package:desa_go_aplikasi/models/rapat_model.dart' as RapatModel;
import 'package:desa_go_aplikasi/models/warga_model.dart' as WargaModel;
import 'package:desa_go_aplikasi/models/kas_model.dart' as KasModel;
import 'package:desa_go_aplikasi/viewmodel/rapat_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/kas_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AdminTambahRapatPage extends StatefulWidget {
  const AdminTambahRapatPage({super.key});

  @override
  State<AdminTambahRapatPage> createState() => _AdminTambahRapatPageState();
}

class _AdminTambahRapatPageState extends State<AdminTambahRapatPage> {
  // Field pendukung state
  int? _selectedRwId;
  int? _selectedKasId;
  WargaModel.Data? _selectedPjWarga;

  // Controllers
  final TextEditingController _judulRapatController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _jamMulaiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _pjDisplayController = TextEditingController();
  final TextEditingController _anggaranController = TextEditingController();
  final TextEditingController _tujuanController = TextEditingController();
  final TextEditingController _modalSearchController = TextEditingController();

  String _searchQuery = "";
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      _selectedRwId = authVM.idRw;

      // Load data pendukung (Kas dan Warga)
      Provider.of<KasViewModel>(context, listen: false).loadKas();
      Provider.of<WargaViewModel>(context, listen: false).loadWarga();
    });
  }

  @override
  void dispose() {
    _judulRapatController.dispose();
    _tanggalController.dispose();
    _jamMulaiController.dispose();
    _lokasiController.dispose();
    _pjDisplayController.dispose();
    _anggaranController.dispose();
    _tujuanController.dispose();
    _modalSearchController.dispose();
    super.dispose();
  }

  // Fungsi DatePicker dengan Tema Putih
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A4E8A), // Header
              onPrimary: Colors.white,   // Teks Header
              surface: Colors.white,     // Background kalender
              onSurface: Colors.black,   // Teks Tanggal
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Fungsi TimePicker dengan Tema Putih
  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A4E8A),
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        _jamMulaiController.text = DateFormat('HH:mm').format(dt);
      });
    }
  }

  Future<void> _handleSave() async {
    if (_judulRapatController.text.isEmpty ||
        _tanggalController.text.isEmpty ||
        _selectedPjWarga == null ||
        _selectedKasId == null) {
      _showSnackbar("Mohon lengkapi data (Judul, Tanggal, PJ, dan Kas)!", Colors.red);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final rapatVM = Provider.of<RapatViewmodel>(context, listen: false);
      
      final newData = RapatModel.Data(
        judulRapat: _judulRapatController.text,
        tanggal: _tanggalController.text,
        jamMulai: _jamMulaiController.text,
        lokasi: _lokasiController.text,
        penanggungJawab: _selectedPjWarga?.id.toString(), // ID Warga sebagai PJ
        idKas: _selectedKasId,
        anggaran: int.tryParse(_anggaranController.text) ?? 0,
        tujuan: _tujuanController.text,
        status: 'mendatang', // Diatur otomatis
      );

      await rapatVM.createRapat(newData);

      _showSnackbar("Rapat berhasil dijadwalkan!", const Color(0xFF5CB85C));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackbar("Gagal: ${e.toString()}", Colors.red);
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
        duration: const Duration(seconds: 2),
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
        title: const Text('Tambah Rapat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField("Judul Rapat", _judulRapatController, hint: "Contoh: Rapat Koordinasi Keamanan"),
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            "Tanggal",
                            _tanggalController,
                            hint: "Pilih Tanggal",
                            isReadOnly: true,
                            onTap: _selectDate,
                            suffixIcon: const Icon(Icons.calendar_today, size: 20),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildInputField(
                            "Jam Mulai",
                            _jamMulaiController,
                            hint: "19:30",
                            isReadOnly: true,
                            onTap: _selectTime,
                            suffixIcon: const Icon(Icons.access_time, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    _buildInputField("Lokasi Rapat", _lokasiController, hint: "Contoh: Balai Pertemuan RW"),
                    const SizedBox(height: 20),
                    
                    _buildWargaSearchField(), // Pencarian PJ Warga
                    const SizedBox(height: 20),

                    _buildKasDropdown(), // Pilihan Sumber Kas
                    const SizedBox(height: 20),
                    
                    _buildInputField(
                      "Anggaran (Rp)",
                      _anggaranController,
                      hint: "Masukkan jumlah anggaran",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    
                    _buildInputField(
                      "Tujuan Rapat",
                      _tujuanController,
                      hint: "Deskripsikan tujuan pertemuan...",
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWargaSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Penanggung Jawab", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _pjDisplayController,
          readOnly: true,
          onTap: () => _showWargaPickerModal(),
          decoration: InputDecoration(
            hintText: "Cari nama warga...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  void _showWargaPickerModal() {
    _modalSearchController.clear();
    _searchQuery = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (_, controller) {
                return Column(
                  children: [
                    const SizedBox(height: 15),
                    Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Pilih Penanggung Jawab', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _modalSearchController,
                        decoration: InputDecoration(
                          hintText: "Ketik nama warga...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onChanged: (val) {
                          setModalState(() => _searchQuery = val.toLowerCase());
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Consumer<WargaViewModel>(
                        builder: (context, vm, _) {
                          final filteredList = vm.listWarga.where((w) {
                            final matchRw = w.rt?.idRw == _selectedRwId;
                            final matchName = w.nama?.toLowerCase().contains(_searchQuery) ?? false;
                            return matchRw && matchName;
                          }).toList();

                          if (filteredList.isEmpty) return const Center(child: Text("Warga tidak ditemukan"));

                          return ListView.separated(
                            controller: controller,
                            itemCount: filteredList.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final w = filteredList[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF4A4E8A).withOpacity(0.1),
                                  backgroundImage: (w.foto != null && w.foto!.isNotEmpty) ? NetworkImage(w.foto!) : null,
                                  child: (w.foto == null || w.foto!.isEmpty) ? const Icon(Icons.person, color: Color(0xFF4A4E8A)) : null,
                                ),
                                title: Text(w.nama ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('RT: ${w.rt?.namaRt ?? '-'} | NIK: ${w.nik}'),
                                onTap: () {
                                  setState(() {
                                    _selectedPjWarga = w;
                                    _pjDisplayController.text = w.nama ?? '';
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildKasDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pilih Sumber Kas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Consumer<KasViewModel>(
          builder: (context, vm, _) {
            return DropdownButtonFormField<int>(
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              value: _selectedKasId,
              hint: const Text("Pilih Kas..."),
              items: vm.listKas.map((kas) {
                return DropdownMenuItem<int>(
                  value: kas.id,
                  child: Text(kas.namaPengguna ?? '-'),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedKasId = v),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    String? hint,
    bool isReadOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: isReadOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: isReadOnly,
            fillColor: isReadOnly ? Colors.grey.shade50 : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C2C2C),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        child: _isSubmitting
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Simpan Rapat", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}