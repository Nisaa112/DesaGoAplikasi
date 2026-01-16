import 'package:desa_go_aplikasi/models/warga_model.dart' as WargaModel;
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rw_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminTambahUserPage extends StatefulWidget {
  const AdminTambahUserPage({super.key});

  @override
  State<AdminTambahUserPage> createState() => _AdminTambahUserPageState();
}

class _AdminTambahUserPageState extends State<AdminTambahUserPage> {
  int? _selectedRwId;
  String? _selectedRole;
  WargaModel.Data? _selectedWarga;

  // State untuk show/hide password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _namaSearchController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _modalSearchController = TextEditingController();

  String _searchQuery = "";
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      if (authVM.idRw != null) {
        setState(() {
          _selectedRwId = authVM.idRw;
        });
      }
      Provider.of<RwViewModel>(context, listen: false).loadRw();
      Provider.of<WargaViewModel>(context, listen: false).loadWarga();
    });
  }

  @override
  void dispose() {
    _namaSearchController.dispose();
    _nikController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _modalSearchController.dispose();
    super.dispose();
  }

  void _onWargaSelected(WargaModel.Data warga) {
    setState(() {
      _selectedWarga = warga;
      _namaSearchController.text = warga.nama ?? '';
      _nikController.text = warga.nik ?? '';
      _selectedRole = 'warga';
    });
  }

  Future<void> _handleSave() async {
    if (_selectedWarga == null || _selectedRole == null || _passwordController.text.isEmpty) {
      _showSnackbar("Mohon lengkapi semua data!", Colors.red);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackbar("Konfirmasi kata sandi tidak cocok!", Colors.red);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final userVM = Provider.of<UserViewModel>(context, listen: false);
      await userVM.createUser(
        _namaSearchController.text,
        _nikController.text,
        _selectedRole!,
        _passwordController.text,
        _selectedRwId,
      );

      _showSnackbar("Akun pengguna berhasil dibuat!", const Color(0xFF5CB85C));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackbar(e.toString().replaceAll("Exception: ", ""), Colors.red);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackbar(String m, Color c) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), backgroundColor: c, behavior: SnackBarBehavior.floating),
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
        title: const Text('Tambah Pengguna', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    _buildRwInfo(),
                    const SizedBox(height: 20),
                    _buildWargaSearchField(),
                    const SizedBox(height: 20),
                    _buildInputField("NIK (Serial Number)", _nikController, isReadOnly: true),
                    const SizedBox(height: 20),
                    _buildRoleDropdown(),
                    const SizedBox(height: 20),
                    // INPUT PASSWORD DENGAN MATA
                    _buildInputField(
                      "Kata Sandi", 
                      _passwordController, 
                      isObscure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // INPUT KONFIRMASI PASSWORD DENGAN MATA
                    _buildInputField(
                      "Konfirmasi Kata Sandi", 
                      _confirmPasswordController, 
                      isObscure: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
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

  Widget _buildRwInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Wilayah RW", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Consumer<RwViewModel>(
          builder: (context, vm, _) {
            String namaRw = "Memuat...";
            if (vm.listRw.isNotEmpty && _selectedRwId != null) {
              try {
                namaRw = vm.listRw.firstWhere((e) => e.id == _selectedRwId).namaRw ?? "-";
              } catch (e) {
                namaRw = "RW $_selectedRwId";
              }
            }
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(namaRw, style: const TextStyle(fontSize: 16, color: Colors.black54)),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 4, left: 4),
          child: Text("*Otomatis sesuai RW Anda", style: TextStyle(fontSize: 11, color: Colors.orange, fontStyle: FontStyle.italic)),
        ),
      ],
    );
  }

  Widget _buildWargaSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Cari Nama Warga", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _namaSearchController,
          readOnly: true,
          onTap: () => _showWargaPickerModal(),
          decoration: InputDecoration(
            hintText: "Ketuk untuk cari warga...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 4, left: 4),
          child: Text("Hanya menampilkan warga yang BELUM memiliki akun.", style: TextStyle(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.w500)),
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
                      child: Text('Pilih Warga (Tanpa Akun)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                            final noAccount = w.idUsers == null;
                            final matchName = w.nama?.toLowerCase().contains(_searchQuery) ?? false;
                            return matchRw && noAccount && matchName;
                          }).toList();

                          if (filteredList.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text("Semua warga di RW ini sudah memiliki akun atau data tidak ditemukan.", textAlign: TextAlign.center),
                              ),
                            );
                          }

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

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Role / Hak Akses", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          value: _selectedRole,
          hint: const Text("Pilih Role"),
          items: [
            {'val': 'admin', 'label': 'Administrator'},
            {'val': 'warga', 'label': 'Warga'},
            {'val': 'bendahara', 'label': 'Bendahara'},
          ].map((r) => DropdownMenuItem(
            value: r['val'], 
            child: Text(r['label']!)
          )).toList(),
          onChanged: (v) => setState(() => _selectedRole = v),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isReadOnly = false, bool isObscure = false, Widget? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: isReadOnly,
          obscureText: isObscure,
          decoration: InputDecoration(
            filled: isReadOnly,
            fillColor: isReadOnly ? Colors.grey.shade100 : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: suffixIcon, // Mata Show/Hide disematkan di sini
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
            : const Text("Simpan Pengguna", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}