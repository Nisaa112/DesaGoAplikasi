import 'package:desa_go_aplikasi/models/warga_model.dart' as Warga; // Diperbaiki: menggunakan prefix 'Warga'
import 'package:desa_go_aplikasi/page/identitas_warga_page.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoWargaPage extends StatefulWidget {
  const InfoWargaPage({super.key});

  @override
  State<InfoWargaPage> createState() => _InfoWargaPageState();
}

class _InfoWargaPageState extends State<InfoWargaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // PERBAIKAN: Mengganti fetchWarga() menjadi loadWarga()
      Provider.of<WargaViewModel>(context, listen: false).loadWarga();
    });
  }

  @override
  Widget build(BuildContext context) {
    // PERBAIKAN: Mengganti WargaViewmodel menjadi WargaViewModel
    final wargaViewModel = Provider.of<WargaViewModel>(context);

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
          child: _buildBody(wargaViewModel),
        ),
      ),
    );
  }

  Widget _buildBody(WargaViewModel viewModel) {
    // PERBAIKAN: Menyesuaikan penamaan listWarga dan errorMessage
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (viewModel.errorMessage != null && viewModel.errorMessage!.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gagal memuat data: ${viewModel.errorMessage}', textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // PERBAIKAN: Mengganti fetchWarga() menjadi loadWarga()
                viewModel.loadWarga();
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    } else if (viewModel.listWarga.isEmpty) {
      return const Center(child: Text('Tidak ada data Warga.'));
    } else {
      return RefreshIndicator(
        color: const Color(0xFFFFC212),
        backgroundColor: Colors.white,
        onRefresh: () async {
          // PERBAIKAN: Mengganti fetchWarga() menjadi loadWarga() (akan memicu sync)
          await viewModel.loadWarga();
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            itemCount: viewModel.listWarga.length,
            itemBuilder: (context, index) {
              // PERBAIKAN: Menggunakan Warga.Data karena sudah diimport dengan prefix
              final Warga.Data warga = viewModel.listWarga[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
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
                      builder: (context) => IdentitasWargaPage(warga: warga),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 1, indent: 8, endIndent: 8);
            },
          )
        )
      );
    }
  }
}