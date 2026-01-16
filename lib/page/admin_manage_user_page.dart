import 'package:desa_go_aplikasi/models/user_model.dart';
import 'package:desa_go_aplikasi/page/admin_tambah_user_page.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/user_viewmodel.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminManageUserPage extends StatefulWidget {
  const AdminManageUserPage({super.key});

  @override
  State<AdminManageUserPage> createState() => _AdminManageUserPageState();
}

class _AdminManageUserPageState extends State<AdminManageUserPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserViewModel>(context, listen: false).fetchUsers();
    });
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<UserViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context);
    final int? adminRwId = authVM.idRw;

    const Color primaryColor = Color(0xFF4A4E8A);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text('Manajemen Pengguna', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminTambahUserPage())),
        backgroundColor: const Color(0xFFFFCC33),
        elevation: 0,
        icon: const Icon(Icons.person_add, color: Colors.black),
        label: const Text('Tambah User', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: _buildBody(userVM, adminRwId),
      ),
    );
  }

  Widget _buildBody(UserViewModel viewModel, int? adminRwId) {
    if (viewModel.isLoading) return const Center(child: CircularProgressIndicator());

    // FILTER: Hanya user yang RW-nya sama dengan Admin
    List<UserDetail> filteredUsers = viewModel.users;
    if (adminRwId != null) {
      filteredUsers = viewModel.users.where((u) => u.idRw == adminRwId).toList();
    }

    if (filteredUsers.isEmpty) return const Center(child: Text('Tidak ada pengguna di wilayah Anda.'));

    return ListView.separated(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 80),
      itemCount: filteredUsers.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF4A4E8A).withOpacity(0.1),
            child: const Icon(Icons.person, color: Color(0xFF4A4E8A)),
          ),
          title: Text(user.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("${user.role?.toUpperCase()} | NIK: ${user.serialNumber}"),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigasi ke Edit User
          },
        );
      },
    );
  }
}