import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controller untuk mengelola teks di dalam TextField
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _telpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Isi TextField dengan data dummy saat halaman dibuka
    _nikController.text = '32898366529008';
    _namaController.text = 'Annisa Aulia Firdaus';
    _alamatController.text = 'Gg. Bidan Tati Jambudipa Rt04/Rw03 Warungkondang, Cianjur, 43261';
    _telpController.text = '08123455678';
  }

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _nikController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _telpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: const Text('Profil Pengguna', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
              _buildTextField(label: 'NIK', controller: _nikController),
              const SizedBox(height: 20),
              _buildTextField(label: 'Nama', controller: _namaController),
              const SizedBox(height: 20),
              _buildTextField(label: 'Alamat', controller: _alamatController, maxLines: 3),
              const SizedBox(height: 20),
              _buildTextField(label: 'No.Telp', controller: _telpController),
              const SizedBox(height: 40),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk foto profil dengan ikon edit
  Widget _buildProfilePicture() {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage('assets/profile_picture.png'), // Ganti dengan path aset Anda
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4A4E8A),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ),
        )
      ],
    );
  }

  // Widget helper untuk membuat TextField agar tidak berulang
  Widget _buildTextField({required String label, required TextEditingController controller, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            filled: true,
            fillColor: Colors.grey.shade100, // Warna latar field
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300),
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

  // Widget untuk tombol Simpan
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Aksi ketika tombol simpan ditekan
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}