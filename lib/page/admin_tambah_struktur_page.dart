import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;
import 'package:desa_go_aplikasi/models/warga_model.dart' as WargaModel;
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/struktur_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/jabatan_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rw_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminTambahStrukturPage extends StatefulWidget {
  const AdminTambahStrukturPage({super.key});

  @override
  State<AdminTambahStrukturPage> createState() => _AdminTambahStrukturPageState();
}

class _AdminTambahStrukturPageState extends State<AdminTambahStrukturPage> {
  // Field pendukung state
  int? _selectedRwId;
  int? _selectedJabatanId;
  WargaModel.Data? _selectedWarga;

  // Controller untuk form
  final TextEditingController _namaSearchController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  
  // Controller tambahan untuk pencarian di dalam modal
  final TextEditingController _modalSearchController = TextEditingController();
  String _searchQuery = "";

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1. Ambil ID RW dari AuthViewModel
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      if (authVM.idRw != null) {
        setState(() {
          _selectedRwId = authVM.idRw;
        });
      }

      // 2. Load data pendukung
      Provider.of<RwViewModel>(context, listen: false).loadRw();
      Provider.of<JabatanViewModel>(context, listen: false).fetchJabatan();
      Provider.of<WargaViewModel>(context, listen: false).loadWarga(); 
    });
  }

  // Fungsi Auto-fill data warga ke controller
  void _onWargaSelected(WargaModel.Data warga) {
    setState(() {
      _selectedWarga = warga;
      _namaSearchController.text = warga.nama ?? '';
      _nikController.text = warga.nik ?? '';
      _noTelpController.text = warga.noTelp ?? '';
      _alamatController.text = warga.alamat ?? '';
    });
  }

  Future<void> _simpanStruktur() async {
    if (_selectedWarga == null || _selectedJabatanId == null || _selectedRwId == null) {
      _showSnackbar('RW, Nama, dan Jabatan wajib diisi!', Colors.red);
      return;
    }

    setState(() => _isSubmitting = true);

    final newMember = StrukturModel.Data(
      idRw: _selectedRwId,
      idRt: _selectedWarga?.idRt, // Otomatis terisi dari data warga
      idJabatan: _selectedJabatanId,
      nama: _selectedWarga?.nama,
      nik: _selectedWarga?.nik,
      alamat: _selectedWarga?.alamat,
      noTelp: _selectedWarga?.noTelp,
      foto: _selectedWarga?.foto,
    );

    try {
      await Provider.of<StrukturViewModel>(context, listen: false).createStruktur(newMember);
      _showSnackbar('Data struktur berhasil disimpan!', const Color(0xFF5CB85C));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackbar('Error: $e', Colors.red);
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
        title: const Text('Tambah Struktur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        width: double.infinity,
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
                    _buildRwSelection(),
                    const SizedBox(height: 20),
                    _buildWargaSearch(primaryColor),
                    const SizedBox(height: 20),
                    if (_selectedWarga != null) ...[
                      _buildWargaDetails(),
                      const SizedBox(height: 20),
                    ],
                    _buildJabatanDropdown(),
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

  Widget _buildRwSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Wilayah RW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
        const SizedBox(height: 8),
        Consumer<RwViewModel>(
          builder: (context, vm, _) {
            // Ambil data user untuk pengecekan role/akses
            final authVM = Provider.of<AuthViewModel>(context, listen: false);
            bool isRestricted = authVM.idRw != null;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isRestricted ? Colors.grey.shade100 : Colors.white, // Beri warna beda jika terkunci
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _selectedRwId,
                  hint: const Text('Pilih RW...'),
                  // Jika isRestricted (punya id_rw), maka onChanged diset null (disabled)
                  onChanged: isRestricted ? null : (val) {
                    setState(() {
                      _selectedRwId = val;
                      _selectedWarga = null;
                      _namaSearchController.clear();
                    });
                  },
                  items: vm.listRw.map((rw) {
                    return DropdownMenuItem<int>(
                      value: rw.id, 
                      child: Text(
                        rw.namaRw ?? '',
                        style: TextStyle(color: isRestricted ? Colors.black : Colors.black),
                      )
                    );
                  }).toList(),
                  // Tambahkan style untuk disabled agar tetap terlihat jelas
                  disabledHint: vm.listRw.isEmpty 
                      ? const Text("Memuat...") 
                      : Text(vm.listRw.firstWhere((e) => e.id == _selectedRwId, 
                        orElse: () => vm.listRw[0]).namaRw ?? ''),
                ),
              ),
            );
          },
        ),
        if (Provider.of<AuthViewModel>(context, listen: false).idRw != null)
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 4),
            child: Text("*Wilayah dikunci sesuai profil Anda", style: TextStyle(fontSize: 11, color: const Color(0xFFFFCC33), fontStyle: FontStyle.italic)),
          ),
      ],
    );
  }


  Widget _buildWargaSearch(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cari Nama Warga', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _namaSearchController,
          readOnly: true,
          onTap: _selectedRwId == null 
              ? () => _showSnackbar('Pilih RW terlebih dahulu!', Colors.orange)
              : () => _showWargaPickerModal(),
          decoration: InputDecoration(
            hintText: _selectedRwId == null ? 'Pilih RW dulu...' : 'Ketuk untuk cari nama warga...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      shape: const  RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder( // Agar search field bisa update list secara real-time
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
                      child: Text('Pilih Warga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    
                    // Fitur Pencarian Nama
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: _modalSearchController,
                        decoration: InputDecoration(
                          hintText: 'Ketik nama warga...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        ),
                        onChanged: (val) {
                          setModalState(() {
                            _searchQuery = val.toLowerCase();
                          });
                        },
                      ),
                    ),

                    Expanded(
                      child: Consumer<WargaViewModel>(
                        builder: (context, vm, _) {
                          // Filter berdasarkan RW yang dipilih DAN Query pencarian nama
                          final filteredWarga = vm.listWarga.where((w) {
                            final matchesRw = w.rt?.idRw == _selectedRwId;
                            final matchesSearch = w.nama?.toLowerCase().contains(_searchQuery) ?? false;
                            return matchesRw && matchesSearch;
                          }).toList();

                          if (filteredWarga.isEmpty) {
                            return const Center(child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Warga tidak ditemukan di RW ini.'),
                            ));
                          }

                          return ListView.separated(
                            controller: controller,
                            itemCount: filteredWarga.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final w = filteredWarga[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF4A4E8A).withOpacity(0.1),
                                  backgroundImage: (w.foto != null && w.foto!.isNotEmpty) ? NetworkImage(w.foto!) : null,
                                  child: (w.foto == null || w.foto!.isEmpty) ? const Icon(Icons.person, color: Color(0xFF4A4E8A)) : null,
                                ),
                                title: Text(w.nama ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('RT: ${w.rt?.namaRt ?? '-'} | NIK: ${w.nik}'),
                                onTap: () {
                                  _onWargaSelected(w);
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

  Widget _buildWargaDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Informasi Terpilih:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
              if (_selectedWarga?.foto != null && _selectedWarga!.foto!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(_selectedWarga!.foto!, height: 40, width: 40, fit: BoxFit.cover),
                )
            ],
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.credit_card, 'NIK', _nikController.text),
          _infoRow(Icons.phone, 'No Telp', _noTelpController.text),
          _infoRow(Icons.map, 'Alamat', _alamatController.text),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Expanded(child: Text(value.isEmpty ? '-' : value, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildJabatanDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Jabatan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Consumer<JabatanViewModel>(
          builder: (context, vm, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  value: _selectedJabatanId,
                  hint: const Text('Pilih Jabatan...'),
                  items: vm.jabatanList.map((j) {
                    return DropdownMenuItem<int>(value: j.id, child: Text(j.namaJabatan ?? ''));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedJabatanId = val),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _simpanStruktur,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C2C2C),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        child: _isSubmitting 
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
          : const Text('Simpan Struktur', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}