import 'package:desa_go_aplikasi/models/pengaduan_model.dart' as PengaduanModel;
// ✅ PASTIKAN IMPORT INI MENGARAH KE FILE FORM ADMIN YANG KAMU BUAT
import 'package:desa_go_aplikasi/page/admin_pengaduan_form_page.dart'; 
import 'package:desa_go_aplikasi/viewmodel/pengaduan_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPengaduanPage extends StatelessWidget {
  const AdminPengaduanPage({super.key});

  Widget _buildStatusBadge(String status) {
    Color color;
    String displayText = status;

    // Logika warna badge status
    if (status.toLowerCase() == 'pending') {
      color = const Color(0xFFFFC212);
      displayText = 'Pending';
    } else if (status.toLowerCase() == 'diproses' || status.toLowerCase() == 'processing') {
      color = const Color(0xFF5CB85C);
      displayText = 'Diproses';
    } else if (status.toLowerCase() == 'selesai' || status.toLowerCase() == 'completed') {
      color = const Color(0xFF333333);
      displayText = 'Selesai';
    } else {
      color = Colors.grey;
      displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPengaduanItem(BuildContext context, PengaduanModel.Data pengaduan) {
    return Column(
      children: [
        Dismissible(
          key: ValueKey(pengaduan.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Konfirmasi Hapus"),
                  content: Text("Yakin ingin menghapus pengaduan '${pengaduan.judul}'?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Hapus"),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            if (pengaduan.id != null) {
              Provider.of<PengaduanViewModel>(context, listen: false)
                  .deletePengaduan(pengaduan.id!);
            }
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              pengaduan.judul ?? 'Tanpa Judul',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              pengaduan.pesan ?? 'Tidak ada pesan',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            trailing: _buildStatusBadge(pengaduan.status ?? 'Unknown'),
            onTap: () {
              // ✅ PERBAIKAN DI SINI:
              // Sebelumnya mengarah ke AdminPengaduanPage (Recursive),
              // Sekarang mengarah ke AdminPengaduanFormPage untuk Edit.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPengaduanFormPage(pengaduan: pengaduan),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1, color: Colors.grey, thickness: 0.5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A4E8A);

    return Consumer<PengaduanViewModel>(
      builder: (context, viewModel, child) {
        final pengaduanList = viewModel.pengaduanList;
        final isLoading = viewModel.isLoading;

        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'Pengaduan',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: _buildListContent(context, pengaduanList, isLoading, viewModel),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Opsional: Jika ingin admin bisa menambah pengaduan manual
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: const Color(0xFFFFC212),
          //   child: const Icon(Icons.add, color: Colors.black),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         // Buka form tanpa parameter pengaduan (Mode Create)
          //         builder: (context) => const AdminPengaduanFormPage(),
          //       ),
          //     );
          //   },
          // ),
        );
      },
    );
  }

  Widget _buildListContent(BuildContext context, List<PengaduanModel.Data> list, bool isLoading, PengaduanViewModel viewModel) {
    if (isLoading && list.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF4A4E8A)));
    } else if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: viewModel.fetchPengaduan,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: const Center(
              child: Text('Tidak ada pengaduan saat ini.', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: viewModel.fetchPengaduan,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _buildPengaduanItem(context, list[index]);
          },
        ),
      );
    }
  }
}