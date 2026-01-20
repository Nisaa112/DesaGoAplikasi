import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Import Model & ViewModel
import '../models/laporan_ronda_model.dart';
import '../viewmodel/laporan_ronda_viewmodel.dart'; 

// Import Halaman Detail
import 'detail_laporan_ronda_page.dart';

class LaporanRondaPage extends StatefulWidget {
  const LaporanRondaPage({super.key});

  @override
  State<LaporanRondaPage> createState() => _LaporanRondaPageState();
}

class _LaporanRondaPageState extends State<LaporanRondaPage> {
  
  @override
  void initState() {
    super.initState();
    // Fetch data saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaporanRondaViewModel>(context, listen: false).fetchLaporan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A), // Background Ungu DesaGo
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Laporan Ronda',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Tombol Filter Periode
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
          child: Consumer<LaporanRondaViewModel>(
            builder: (context, viewModel, child) {
              
              // 1. Loading
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF4A4E8A)));
              }

              // 2. Error
              if (viewModel.errorMessage.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 10),
                        Text(viewModel.errorMessage, textAlign: TextAlign.center),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A4E8A)),
                          onPressed: () => viewModel.fetchLaporan(),
                          child: const Text("Coba Lagi", style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                );
              }

              // 3. Kosong
              if (viewModel.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text(
                        'Belum ada laporan ronda bulan ini.',
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
                    final LaporanRondaModel ronda = viewModel.data[index];

                    // Format Tanggal
                    String formattedDate = ronda.tanggal ?? '-';
                    try {
                      formattedDate = DateFormat('EEEE, d MMM yyyy', 'id_ID').format(DateTime.parse(ronda.tanggal!));
                    } catch (_) {}

                    // Cek Status Insiden
                    bool adaInsiden = (ronda.insiden != null && ronda.insiden!.isNotEmpty);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      // Ikon Bulat di Kiri
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A4E8A).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.security, color: Color(0xFF4A4E8A)),
                      ),
                      // Judul (Lokasi)
                      title: Text(
                        ronda.lokasi ?? 'Pos Ronda',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      // Subtitle (Tanggal & Status)
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(formattedDate, style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(height: 4),
                          // Badge Status
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: adaInsiden ? Colors.red[50] : Colors.green[50],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: adaInsiden ? Colors.red[100]! : Colors.green[100]!),
                            ),
                            child: Text(
                              adaInsiden ? "⚠️ Ada Insiden" : "✅ Aman Terkendali",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: adaInsiden ? Colors.red : Colors.green,
                              ),
                            ),
                          )
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailLaporanRondaPage(ronda: ronda),
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

  // Dialog Filter Bulan & Tahun
  void _showFilterDialog(BuildContext context) {
    final viewModel = Provider.of<LaporanRondaViewModel>(context, listen: false);
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
              // Dropdown Bulan
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
              // Dropdown Tahun
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