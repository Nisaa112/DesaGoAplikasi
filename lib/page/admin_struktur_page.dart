import 'package:desa_go_aplikasi/page/admin_identitas_pejabat_page.dart';
import 'package:desa_go_aplikasi/page/admin_tambah_struktur_page.dart';
import 'package:desa_go_aplikasi/viewmodel/struktur_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;

class AdminStrukturPage extends StatefulWidget {
  const AdminStrukturPage({super.key});

  @override
  State<AdminStrukturPage> createState() => _AdminStrukturPageState();
}

class _AdminStrukturPageState extends State<AdminStrukturPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StrukturViewModel>(context, listen: false).loadStruktur();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    
    final int? adminRwId = authViewModel.idRw;

    return Consumer<StrukturViewModel>(
      builder: (context, viewModel, child) {
        
        final filteredList = viewModel.strukturList.where((member) {
          
          if (adminRwId == null) return false;

          final int? wargaRwId = member.rt?.idRw; 
          
          return wargaRwId == adminRwId;
        }).toList();

        return Scaffold(
          backgroundColor: const Color(0xFF4A4E8A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF4A4E8A),
            elevation: 0,
            title: Text(
              'Struktur RW ${adminRwId ?? ""}', // Menampilkan info RW di title
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: _buildBody(viewModel, filteredList, adminRwId),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildFAB(context),
        );
      },
    );
  }

  Widget _buildBody(StrukturViewModel viewModel, List<StrukturModel.Data> filteredList, int? adminRwId) {
    if (viewModel.isLoading && viewModel.strukturList.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF4A4E8A)));
    }

    if (adminRwId == null) {
      return const Center(child: Text("Sesi admin tidak ditemukan. Silahkan login ulang."));
    }

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons. people_outline, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data warga di RW $adminRwId',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFFFC212),
      onRefresh: () async => await viewModel.synchronizeStruktur(),
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 80.0),
        itemCount: filteredList.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final member = filteredList[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: (member.foto != null && member.foto!.isNotEmpty)
                  ? NetworkImage(member.foto!)
                  : null,
              child: (member.foto == null || member.foto!.isEmpty)
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(member.nama ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(member.jabatan?.namaJabatan ?? 'Warga'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminIdentitasPejabatPage(dataPejabat: member),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminTambahStrukturPage()),
          ).then((_) => Provider.of<StrukturViewModel>(context, listen: false).loadStruktur());
        },
        backgroundColor: const Color(0xFFFFCC33),
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('Tambah Jabatan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}