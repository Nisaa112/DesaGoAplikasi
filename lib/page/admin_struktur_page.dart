import 'package:desa_go_aplikasi/page/admin_identitas_pejabat_page.dart';
import 'package:desa_go_aplikasi/page/admin_tambah_struktur_page.dart';
import 'package:desa_go_aplikasi/viewmodel/struktur_viewmodel.dart';
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
      // Memuat data struktur saat halaman pertama kali dibuka
      Provider.of<StrukturViewModel>(context, listen: false).loadStruktur();
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
            centerTitle: false,
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: 200,
            height: 50,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminTambahStrukturPage(),
                  ),
                ).then((_) {
                  Provider.of<StrukturViewModel>(context, listen: false).loadStruktur();
                });
              },
              backgroundColor: const Color(0xFFFFCC33),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                'Tambah Jabatan',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
    if (viewModel.isLoading && viewModel.strukturList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4A4E8A),
        ),
      );
    } 
    
    else if (viewModel.errorMessage != null && viewModel.strukturList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Gagal memuat data: ${viewModel.errorMessage}', 
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadStruktur(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A4E8A)),
              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } 
    
    else if (viewModel.strukturList.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data struktur keanggotaan.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    } 
    
    else {
      return RefreshIndicator(
        color: const Color(0xFFFFC212),
        onRefresh: () async {
          await viewModel.synchronizeStruktur();
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 80.0),
            itemCount: viewModel.strukturList.length,
            itemBuilder: (context, index) {
              final StrukturModel.Data member = viewModel.strukturList[index];
              
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: (member.foto != null && member.foto!.isNotEmpty)
                      ? NetworkImage(member.foto!)
                      : null,
                  child: (member.foto == null || member.foto!.isEmpty)
                      ? const Icon(Icons.person, color: Colors.grey, size: 30)
                      : null,
                ),
                title: Text(
                  member.nama ?? 'Nama tidak tersedia',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: Colors.black87, 
                    fontSize: 16
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    member.jabatan?.namaJabatan ?? 'Jabatan tidak tersedia',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminIdentitasPejabatPage(
                        dataPejabat: member, // Pastikan parameter di halaman tujuan sesuai
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 1),
          ),
        ),
      );
    }
  }
}