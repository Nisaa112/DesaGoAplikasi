import 'package:desa_go_aplikasi/models/ronda_model.dart' as RondaModel;
import 'package:desa_go_aplikasi/models/warga_model.dart' as WargaModel;
import 'package:desa_go_aplikasi/models/kas_model.dart' as KasModel;
import 'package:desa_go_aplikasi/viewmodel/ronda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/kas_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AdminTambahRondaPage extends StatefulWidget {
  const AdminTambahRondaPage({super.key});

  @override
  State<AdminTambahRondaPage> createState() => _AdminTambahRondaPageState();
}

class _AdminTambahRondaPageState extends State<AdminTambahRondaPage> {
  // State variables
  int? _selectedRwId;
  int? _selectedKasId;
  WargaModel.Data? _selectedPjWarga;
  List<WargaModel.Data> _selectedPetugas = []; // List Penampung Warga

  // Controllers
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _pjDisplayController = TextEditingController();
  final TextEditingController _anggaranController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _modalSearchController = TextEditingController();

  String _searchQuery = "";
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      _selectedRwId = authVM.idRw;
      Provider.of<KasViewModel>(context, listen: false).loadKas();
      Provider.of<WargaViewModel>(context, listen: false).loadWarga();
    });
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _lokasiController.dispose();
    _pjDisplayController.dispose();
    _anggaranController.dispose();
    _detailController.dispose();
    _modalSearchController.dispose();
    super.dispose();
  }

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
              primary: Color(0xFF4A4E8A), 
              onPrimary: Colors.white,    
              surface: Colors.white,      
              onSurface: Colors.black,    
            ),
            dialogBackgroundColor: Colors.white, 
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF4A4E8A)),
            ),
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

  Future<void> _handleSave() async {
    if (_tanggalController.text.isEmpty ||
        _lokasiController.text.isEmpty ||
        _selectedPjWarga == null ||
        _selectedPetugas.isEmpty ||
        _selectedKasId == null) {
      _showSnackbar("Mohon lengkapi data (Tanggal, Lokasi, PJ, Petugas, dan Kas)!", Colors.red);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final rondaVM = Provider.of<RondaViewModel>(context, listen: false);

      List<Map<String, dynamic>> detailsPayload = _selectedPetugas.map((warga) {
        return {
          'id_warga': warga.id,           
          'jam_mulai': "22:00:00",        
          'jam_selesai': "04:00:00",      
          'area_patroli': "Lingkungan RT",
          'hadir': 0,                    
        };
      }).toList();
      
      final Map<String, dynamic> payload = {
        'tanggal': _tanggalController.text,
        'lokasi': _lokasiController.text,
        'penanggung_jawab': _selectedPjWarga?.id, 
        'id_kas': _selectedKasId,                
        'anggaran': int.tryParse(_anggaranController.text) ?? 0,
        'detail': _detailController.text,
        'details': detailsPayload, 
      };

      await rondaVM.createRonda(payload);

      _showSnackbar("Jadwal Ronda berhasil disimpan!", const Color(0xFF5CB85C));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackbar("Gagal menyimpan: ${e.toString().split(':').last}", Colors.red);
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
        title: const Text('Tambah Ronda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    _buildInputField("Tanggal Ronda", _tanggalController, hint: "Pilih Tanggal", isReadOnly: true, onTap: _selectDate, suffixIcon: const Icon(Icons.calendar_today, size: 20)),
                    const SizedBox(height: 20),
                    _buildInputField("Lokasi Pos Ronda", _lokasiController, hint: "Contoh: Pos Kamling RT 01"),
                    const SizedBox(height: 20),
                    _buildPjPicker(), // Picker PJ (Single)
                    const SizedBox(height: 20),
                    _buildPetugasSection(), // Picker Petugas (Multi)
                    const SizedBox(height: 20),
                    _buildKasDropdown(),
                    const SizedBox(height: 20),
                    _buildInputField("Anggaran Konsumsi (Rp)", _anggaranController, hint: "0", keyboardType: TextInputType.number),
                    const SizedBox(height: 20),
                    _buildInputField("Detail Regu", _detailController, hint: "Contoh: Regu Elang (Blok C)", maxLines: 2),
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

  // --- WIDGET PJ (KETUA) ---
  Widget _buildPjPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Penanggung Jawab", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _pjDisplayController,
          readOnly: true,
          onTap: () => _showWargaPickerModal(isMulti: false),
          decoration: InputDecoration(
            hintText: "Klik untuk cari ketua regu...",
            prefixIcon: const Icon(Icons.person_pin_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  // --- WIDGET PETUGAS (WRAP CHIPS) ---
  Widget _buildPetugasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Daftar Petugas Ronda", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showWargaPickerModal(isMulti: true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _selectedPetugas.isEmpty
                ? const Text("Klik untuk pilih anggota petugas...", style: TextStyle(color: Colors.grey))
                : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _selectedPetugas.map((warga) {
                      return Chip(
                        label: Text(warga.nama ?? '', style: const TextStyle(fontSize: 12)),
                        onDeleted: () {
                          setState(() { _selectedPetugas.remove(warga); });
                        },
                        backgroundColor: const Color(0xFF4A4E8A).withOpacity(0.1),
                        deleteIcon: const Icon(Icons.close, size: 14),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }

  // --- MODAL PICKER WARGA (BISA SINGLE ATAU MULTI) ---
  void _showWargaPickerModal({required bool isMulti}) {
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
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(isMulti ? 'Pilih Anggota Petugas' : 'Pilih Penanggung Jawab', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _modalSearchController,
                        decoration: InputDecoration(hintText: "Cari nama warga...", prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        onChanged: (val) { setModalState(() => _searchQuery = val.toLowerCase()); },
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
                              bool isAlreadyInList = _selectedPetugas.any((element) => element.id == w.id);

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF4A4E8A).withOpacity(0.1),
                                  backgroundImage: (w.foto != null && w.foto!.isNotEmpty) ? NetworkImage(w.foto!) : null,
                                  child: (w.foto == null || w.foto!.isEmpty) ? const Icon(Icons.person, color: Color(0xFF4A4E8A)) : null,
                                ),
                                title: Text(w.nama ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('NIK: ${w.nik}'),
                                trailing: isMulti 
                                  ? (isAlreadyInList ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.add_circle_outline))
                                  : null,
                                onTap: () {
                                  if (isMulti) {
                                    setState(() {
                                      if (isAlreadyInList) {
                                        _selectedPetugas.removeWhere((e) => e.id == w.id);
                                      } else {
                                        _selectedPetugas.add(w);
                                      }
                                    });
                                    setModalState(() {}); 
                                  } else {
                                    setState(() {
                                      _selectedPjWarga = w;
                                      _pjDisplayController.text = w.nama ?? '';
                                    });
                                    Navigator.pop(context);
                                  }
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
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
              value: _selectedKasId,
              hint: const Text("Pilih Kas..."),
              items: vm.listKas.map((kas) => DropdownMenuItem<int>(value: kas.id, child: Text(kas.namaPengguna ?? '-'))).toList(),
              onChanged: (v) => setState(() => _selectedKasId = v),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {String? hint, bool isReadOnly = false, VoidCallback? onTap, Widget? suffixIcon, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller, readOnly: isReadOnly, onTap: onTap, keyboardType: keyboardType, maxLines: maxLines,
          decoration: InputDecoration(hintText: hint, filled: isReadOnly, fillColor: isReadOnly ? Colors.grey.shade50 : Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), suffixIcon: suffixIcon),
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
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C2C2C), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
        child: _isSubmitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Simpan Jadwal Ronda", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}