import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Import Model & ViewModel
import '../models/laporan_posyandu_model.dart';
import '../viewmodel/laporan_posyandu_viewmodel.dart';

// Import Halaman Detail
import 'detail_laporan_posyandu_page.dart';

class LaporanPosyanduPage extends StatefulWidget {
  const LaporanPosyanduPage({super.key});

  @override
  State<LaporanPosyanduPage> createState() => _LaporanPosyanduPageState();
}

class _LaporanPosyanduPageState extends State<LaporanPosyanduPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaporanPosyanduViewModel>(context, listen: false).fetchLaporan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A), // Warna Tema Ungu
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Laporan Posyandu',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // Tombol Filter Periode
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
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
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Consumer<LaporanPosyanduViewModel>(
            builder: (context, viewModel, child) {
              
              // 1. Loading
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF4A4E8A)));
              }

              // 2. Error
              if (viewModel.errorMessage.isNotEmpty) {
                return Center(child: Text(viewModel.errorMessage));
              }

              // 3. Data Kosong
              if (viewModel.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medical_services_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text(
                        'Belum ada laporan posyandu bulan ini.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              // 4. List Data
              return RefreshIndicator(
                onRefresh: () => viewModel.fetchLaporan(),
                color: const Color(0xFF4A4E8A),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  itemCount: viewModel.data.length,
                  itemBuilder: (context, index) {
                    final LaporanPosyanduModel posyandu = viewModel.data[index];

                    // Format Tanggal
                    String formattedDate = posyandu.tanggal ?? '-';
                    try {
                      formattedDate = DateFormat('EEEE, d MMM yyyy', 'id_ID').format(DateTime.parse(posyandu.tanggal!));
                    } catch (_) {}

                    // Cek Status Laporan & Hitung Total Pasien
                    bool adaLaporan = (posyandu.laporans != null && posyandu.laporans!.isNotEmpty);
                    int totalPasien = 0;
                    if (adaLaporan) {
                      final lap = posyandu.laporans![0];
                      totalPasien = (lap.jmlBalita ?? 0) + (lap.jmlIbuHamil ?? 0) + (lap.jmlLansia ?? 0);
                    }

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      // Icon Bulat (Medical Services)
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A4E8A).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.medical_services, color: Color(0xFF4A4E8A)),
                      ),
                      // Judul Kegiatan
                      title: Text(
                        posyandu.judulPosyandu ?? 'Posyandu',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      // Subtitle: Tanggal & Status
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(formattedDate, style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(height: 4),
                          // Badge Status
                          Text(
                            adaLaporan ? "✅ Terlaksana ($totalPasien Pasien)" : "⏳ Belum Ada Laporan",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: adaLaporan ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        // Navigasi ke Halaman Detail
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailLaporanPosyanduPage(posyandu: posyandu),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 1, indent: 70, endIndent: 16);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Dialog Filter (Sama persis dengan halaman lain)
  void _showFilterDialog(BuildContext context) {
    final viewModel = Provider.of<LaporanPosyanduViewModel>(context, listen: false);
    int tempBulan = viewModel.selectedBulan;
    int tempTahun = viewModel.selectedTahun;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Pilih Periode"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: "Bulan"),
                value: tempBulan,
                items: List.generate(12, (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text(DateFormat('MMMM', 'id_ID').format(DateTime(2022, i + 1))),
                )),
                onChanged: (val) => tempBulan = val!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: "Tahun"),
                value: tempTahun,
                items: List.generate(5, (i) {
                  int year = DateTime.now().year - 2 + i;
                  return DropdownMenuItem(value: year, child: Text(year.toString()));
                }),
                onChanged: (val) => tempTahun = val!,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A4E8A)),
              onPressed: () {
                viewModel.updateFilter(tempBulan, tempTahun);
                Navigator.pop(ctx);
              },
              child: const Text("Terapkan", style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }
}