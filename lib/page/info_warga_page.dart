import 'package:desa_go_aplikasi/models/warga_model.dart' as Warga;
import 'package:desa_go_aplikasi/page/identitas_warga_page.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart'; // Import AuthViewModel
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
      Provider.of<WargaViewModel>(context, listen: false).loadWarga();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wargaViewModel = Provider.of<WargaViewModel>(context);
    
    // 1. Ambil identitas RW dari user yang sedang login
    final authViewModel = Provider.of<AuthViewModel>(context);
    final int? userRwId = authViewModel.idRw;

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
          // 2. Kirim userRwId ke buildBody
          child: _buildBody(wargaViewModel, userRwId),
        ),
      ),
    );
  }

  Widget _buildBody(WargaViewModel viewModel, int? userRwId) {
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

      // --- 3. LOGIKA FILTER BERDASARKAN RW USER ---
      List<Warga.Data> filteredWarga = viewModel.listWarga;

      if (userRwId != null) {
        filteredWarga = viewModel.listWarga.where((warga) {
          // Relasi: Warga -> RT -> idRw
          return warga.rt?.idRw == userRwId;
        }).toList();
      }

      if (filteredWarga.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Tidak ada data warga di wilayah RW Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      }
      // --- END LOGIKA FILTER ---

      return RefreshIndicator(
        color: const Color(0xFFFFC212),
        backgroundColor: Colors.white,
        onRefresh: () async {
          await viewModel.loadWarga();
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            // 4. Gunakan list yang sudah difilter
            itemCount: filteredWarga.length,
            itemBuilder: (context, index) {
              final Warga.Data warga = filteredWarga[index];
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