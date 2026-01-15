import 'package:desa_go_aplikasi/page/identitas_pejabat_page.dart';
import 'package:desa_go_aplikasi/viewmodel/struktur_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;

class StrukturPage extends StatefulWidget {
  const StrukturPage({super.key});

  @override
  State<StrukturPage> createState() => _StrukturPageState();
}

class _StrukturPageState extends State<StrukturPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Menggunakan loadStruktur() sesuai pola baru
      context.read<StrukturViewModel>().loadStruktur();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StrukturViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF4A4E8A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF4A4E8A),
            elevation: 0,
            title: const Text(
              'Struktur Keanggotaan',
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
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: _buildBody(viewModel),
          ),
        );
      },
    );
  }

  Widget _buildBody(StrukturViewModel viewModel) {
    // Mengecek loading hanya jika list masih kosong
    if (viewModel.isLoading && viewModel.strukturList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4A4E8A),
        ),
      );
    } 
    
    // Penyesuaian pengecekan errorMessage (String?)
    if (viewModel.errorMessage != null && viewModel.strukturList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              'Gagal memuat data:\n${viewModel.errorMessage}', 
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadStruktur(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    } 
    
    if (viewModel.strukturList.isEmpty) {
      return const Center(child: Text('Tidak ada data struktur keanggotaan.'));
    }

    return RefreshIndicator(
      color: const Color(0xFFFFC212),
      backgroundColor: Colors.white,
      onRefresh: () async {
        // Sinkronisasi ulang dari API
        await viewModel.synchronizeStruktur();
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          itemCount: viewModel.strukturList.length,
          itemBuilder: (context, index) {
            final StrukturModel.Data member = viewModel.strukturList[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: (member.foto != null && member.foto!.isNotEmpty)
                    ? NetworkImage(member.foto!) // Pastikan URL lengkap atau tambah baseUrl
                    : null,
                child: (member.foto == null || member.foto!.isEmpty)
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              title: Text(
                member.nama ?? 'Nama tidak tersedia',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),
              ),
              subtitle: Text(
                member.jabatan?.namaJabatan ?? 'Jabatan tidak tersedia',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IdentitasPejabatPage(member: member),
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 8, endIndent: 8),
        ),
      ),
    );
  }
}