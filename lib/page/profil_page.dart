import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nikController;
  late TextEditingController _rwController;
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _telpController;

  @override
  void initState() {
    super.initState();
    _nikController = TextEditingController();
    _rwController = TextEditingController();
    _namaController = TextEditingController();
    _alamatController = TextEditingController();
    _telpController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pastikan AuthViewModel memiliki properti yang sesuai
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      setState(() {
        _nikController.text = authViewModel.userEmail ?? 'N/A';
        _namaController.text = authViewModel.userName ?? 'N/A';

        _rwController.text = authViewModel.idRw != null
            ? 'RW ${authViewModel.idRw.toString().padLeft(2, '0')}'
            : 'N/A';

        _alamatController.text = 'Gg. Bidan Tati Jambudipa Rt04/Rw03 Warungkondang, Cianjur, 43261';
        _telpController.text = '08123455678';
      });
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
    const Color primaryColor = Color(0xFF4A4E8A);

    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Profil Pengguna',
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
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Column(
                      children: [
                        _buildProfilePicture(primaryColor),
                        const SizedBox(height: 32),
                        _buildTextField(
                            label: 'NIK (Serial Number)',
                            controller: _nikController),
                        const SizedBox(height: 20),
                        _buildTextField(
                            label: 'Nama Lengkap',
                            controller: _namaController),
                        const SizedBox(height: 20),
                        _buildTextField(
                            label: 'Wilayah RW',
                            controller: _rwController),
                        const SizedBox(height: 20),
                        _buildTextField(
                            label: 'Alamat',
                            controller: _alamatController,
                            maxLines: 3),
                        const SizedBox(height: 20),
                        _buildTextField(
                            label: 'No. Telp',
                            controller: _telpController),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildLogoutButton(authViewModel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePicture(Color color) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: color.withOpacity(0.1),
      child: Icon(Icons.person, size: 70, color: color),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
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
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          maxLines: maxLines,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4A4E8A), width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(AuthViewModel authViewModel) {
    final bool isLoading = authViewModel.isLoading;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        // Disable button saat loading
        onPressed: isLoading ? null : () => authViewModel.logout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          disabledBackgroundColor: Colors.red.shade300,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}