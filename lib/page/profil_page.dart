import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nikController = TextEditingController();
  final _rwController = TextEditingController(); // Controller untuk RW
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _telpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    Future.microtask(() {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      _nikController.text = authViewModel.userEmail ?? 'N/A'; 
      _namaController.text = authViewModel.userName ?? 'N/A';
      
      // Mengambil data RW dari AuthViewModel
      // Jika idRw tersedia, tampilkan format "RW 0X", jika tidak "N/A"
      _rwController.text = authViewModel.idRw != null 
          ? 'RW ${authViewModel.idRw.toString().padLeft(2, '0')}' 
          : 'N/A';

      // Data dummy (bisa disesuaikan nanti jika sudah ada di backend)
      _alamatController.text = 'Gg. Bidan Tati Jambudipa Rt04/Rw03 Warungkondang, Cianjur, 43261'; 
      _telpController.text = '08123455678';
    });
  }

  @override
  void dispose() {
    _nikController.dispose();
    _rwController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _telpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF4A4E8A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF4A4E8A),
            elevation: 0,
            title: const Text('Profil Pengguna',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                children: [
                  _buildProfilePicture(),
                  const SizedBox(height: 32),
                  
                  // NIK (Read-Only)
                  _buildTextField(
                      label: 'NIK (Serial Number)',
                      controller: _nikController,
                      isReadOnly: true),
                  const SizedBox(height: 20),
                  
                  // // RW (Read-Only) - Diambil dari identitas RW user
                  // _buildTextField(
                  //     label: 'Wilayah RW',
                  //     controller: _rwController, // Menggunakan rwController yang benar
                  //     isReadOnly: true),
                  // const SizedBox(height: 20),
                  
                  // Nama (Editable)
                  _buildTextField(
                      label: 'Nama', 
                      controller: _namaController, 
                      isReadOnly: false),
                  const SizedBox(height: 20),
                  
                  // Alamat (Read-Only)
                  _buildTextField(
                      label: 'Alamat',
                      controller: _alamatController,
                      maxLines: 3,
                      isReadOnly: true),
                  const SizedBox(height: 20),
                  
                  // No.Telp (Read-Only)
                  _buildTextField(
                      label: 'No.Telp',
                      controller: _telpController,
                      isReadOnly: true),
                  const SizedBox(height: 40),
                  
                  _buildSaveButton(),
                  const SizedBox(height: 20),
                  _buildLogoutButton(authViewModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: const Color(0xFF4A4E8A).withOpacity(0.8),
          child: const Icon(Icons.person, size: 60, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      int maxLines = 1,
      bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: isReadOnly,
          maxLines: maxLines,
          style: TextStyle(
            color: isReadOnly ? Colors.grey.shade600 : Colors.black,
            fontWeight: isReadOnly ? FontWeight.normal : FontWeight.bold,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            filled: true,
            fillColor: isReadOnly ? Colors.grey.shade200 : Colors.grey.shade100, 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: isReadOnly ? Colors.grey.shade400 : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF4A4E8A), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Implementasi update nama ke API jika diperlukan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perubahan nama berhasil disimpan secara lokal')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C2C2C),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Simpan Perubahan',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(AuthViewModel authViewModel) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          authViewModel.logout(context);
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red.shade600, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Logout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade600,
          ),
        ),
      ),
    );
  }
}