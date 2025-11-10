// lib/page/info_warga_page.dart

import 'package:desa_go_aplikasi/models/warga_model.dart'; // Import model Data
import 'package:desa_go_aplikasi/page/identitas_warga_page.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. Ubah menjadi StatefulWidget
class InfoWargaPage extends StatefulWidget {
  const InfoWargaPage({super.key});

  @override
  State<InfoWargaPage> createState() => _InfoWargaPageState();
}

class _InfoWargaPageState extends State<InfoWargaPage> {
  // 2. Panggil method fetchWarga() saat halaman pertama kali dibuka
  @override
  void initState() {
    super.initState();
    // Gunakan addPostFrameCallback untuk memastikan context sudah siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WargaViewmodel>(context, listen: false).fetchWarga();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3. Dengarkan perubahan dari WargaViewmodel
    final wargaViewModel = Provider.of<WargaViewmodel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        title: const Text(
          'Warga Desa',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          // 4. Bangun UI berdasarkan state dari ViewModel
          child: _buildBody(wargaViewModel),
        ),
      ),
    );
  }

  // Widget helper untuk membangun body berdasarkan state
  Widget _buildBody(WargaViewmodel viewModel) {
    if (viewModel.isLoading && viewModel.wargaList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage.isNotEmpty && viewModel.wargaList.isEmpty) {
      return Center(
        child: Text('Gagal memuat data: ${viewModel.errorMessage}'),
      );
    }

    if (viewModel.wargaList.isEmpty) {
      return const Center(child: Text('Tidak ada data warga.'));
    }

    // Jika data ada, tampilkan ListView
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      itemCount: viewModel.wargaList.length,
      itemBuilder: (context, index) {
        // Ambil data warga dari viewmodel
        final Data warga = viewModel.wargaList[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          title: Text(
            warga.nama ?? 'Nama tidak tersedia',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          subtitle: Text(
            warga.alamat ?? 'Alamat tidak tersedia',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // 5. Kirim objek 'Data' ke halaman detail
                builder: (context) => IdentitasWargaPage(warga: warga),
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(height: 1, indent: 8, endIndent: 8);
      },
    );
  }
}