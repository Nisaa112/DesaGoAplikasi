import 'package:desa_go_aplikasi/page/identitas_pejabat_page.dart';
import 'package:desa_go_aplikasi/viewmodel/struktur_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart'; // 1. Import AuthViewModel
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
      context.read<StrukturViewModel>().loadStruktur();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2. Ambil ID RW milik user yang sedang login
    final authViewModel = Provider.of<AuthViewModel>(context);
    final int? userRwId = authViewModel.idRw;

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
            // 3. Kirim userRwId ke buildBody
            child: _buildBody(viewModel, userRwId),
          ),
        );
      },
    );
  }

  Widget _buildBody(StrukturViewModel viewModel, int? userRwId) {
    if (viewModel.isLoading && viewModel.strukturList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4A4E8A),
        ),
      );
    } 
    
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

    // --- 4. LOGIKA FILTER BERDASARKAN RW USER ---
    List<StrukturModel.Data> filteredStruktur = viewModel.strukturList;

    if (userRwId != null) {
      filteredStruktur = viewModel.strukturList.where((member) {
        return member.idRw == userRwId;
      }).toList();
    }

    if (filteredStruktur.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data struktur di wilayah RW Anda.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    // --- SELESAI FILTER ---

    return RefreshIndicator(
      color: const Color(0xFFFFC212),
      backgroundColor: Colors.white,
      onRefresh: () async {
        await viewModel.synchronizeStruktur();
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          // 5. Gunakan filteredStruktur, bukan viewModel.strukturList
          itemCount: filteredStruktur.length,
          itemBuilder: (context, index) {
            final StrukturModel.Data member = filteredStruktur[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: (member.foto != null && member.foto!.isNotEmpty)
                    ? NetworkImage(member.foto!)
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