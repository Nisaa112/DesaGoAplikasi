import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Import Model & ViewModel Laporan
import '../models/laporan_rapat_model.dart';
import '../viewmodel/laporan_rapat_viewmodel.dart';

// Import Halaman Detail
import 'detail_laporan_rapat_page.dart';

class LaporanRapatPage extends StatefulWidget {
  const LaporanRapatPage({super.key});

  @override
  State<LaporanRapatPage> createState() => _LaporanRapatPageState();
}

class _LaporanRapatPageState extends State<LaporanRapatPage> {
  
  @override
  void initState() {
    super.initState();
    // Fetch data saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaporanRapatViewModel>(context, listen: false).fetchLaporan();
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
          'Laporan Rapat',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Tombol Filter
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterDialog(context),
          )
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
          child: Consumer<LaporanRapatViewModel>(
            builder: (context, viewModel, child) {
              
              // 1. Loading
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF4A4E8A)));
              }

              // 2. Error
              if (viewModel.errorMessage.isNotEmpty) {
                return Center(child: Text(viewModel.errorMessage));
              }

              // 3. Kosong
              if (viewModel.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.groups_3_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text(
                        'Belum ada laporan rapat bulan ini.',
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
                    final LaporanRapatModel rapat = viewModel.data[index];

                    // Format Tanggal (Menggunakan tanggalDibuat/created_at sesuai model)
                    String formattedDate = rapat.tanggalDibuat ?? '-';
                    try {
                      formattedDate = DateFormat('EEEE, d MMM yyyy', 'id_ID').format(DateTime.parse(rapat.tanggalDibuat!));
                    } catch (_) {}

                    // Cek apakah notulensi sudah ada
                    bool adaLaporan = (rapat.laporans != null && rapat.laporans!.isNotEmpty);
                    int jumlahHadir = adaLaporan ? (rapat.laporans![0].jumlahHadir ?? 0) : 0;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      // Ikon Bulat (Group Icon)
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A4E8A).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.groups, color: Color(0xFF4A4E8A)),
                      ),
                      // Judul Rapat
                      title: Text(
                        rapat.judulRapat ?? 'Rapat Warga',
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
                            adaLaporan ? "✅ Terlaksana ($jumlahHadir Hadir)" : "⏳ Belum Ada Notulensi",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: adaLaporan ? Colors.green : Colors.orange,
                            ),
                          )
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailLaporanRapatPage(rapat: rapat),
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

  // Dialog Filter (Sama persis)
  void _showFilterDialog(BuildContext context) {
    final viewModel = Provider.of<LaporanRapatViewModel>(context, listen: false);
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