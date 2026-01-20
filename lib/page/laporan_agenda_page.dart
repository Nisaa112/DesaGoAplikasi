import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Import ViewModel & Model Laporan (Bukan Agenda biasa)
import '../viewmodel/laporan_agenda_viewmodel.dart';
import '../models/laporan_agenda_model.dart';

// Import Halaman Detail
import 'detail_laporan_agenda_page.dart';

class LaporanAgendaPage extends StatefulWidget {
  const LaporanAgendaPage({super.key});

  @override
  State<LaporanAgendaPage> createState() => _LaporanAgendaPageState();
}

class _LaporanAgendaPageState extends State<LaporanAgendaPage> {
  
  @override
  void initState() {
    super.initState();
    // Panggil fetchLaporan dari LaporanAgendaViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaporanAgendaViewModel>(context, listen: false).fetchLaporan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Laporan Agenda',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // Tambahan: Tombol Filter (agar bisa ganti bulan/tahun laporan)
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
          // Gunakan Consumer LaporanAgendaViewModel
          child: Consumer<LaporanAgendaViewModel>(
            builder: (context, viewModel, child) {
              
              // 1. Loading
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF4A4E8A)));
              }

              // 2. Error (Optional handle)
              if (viewModel.errorMessage.isNotEmpty) {
                 return Center(child: Text(viewModel.errorMessage));
              }

              // 3. Empty
              if (viewModel.data.isEmpty) {
                return const Center(child: Text('Belum ada laporan agenda bulan ini.'));
              }

              // 4. List Data
              return RefreshIndicator(
                onRefresh: () => viewModel.fetchLaporan(),
                color: const Color(0xFF4A4E8A),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  itemCount: viewModel.data.length,
                  itemBuilder: (context, index) {
                    final LaporanAgendaModel agenda = viewModel.data[index];
                    
                    // Format Tanggal Cantik
                    String formattedDate = agenda.tanggal ?? '-';
                    try {
                      formattedDate = DateFormat('EEEE, d MMM yyyy', 'id_ID').format(DateTime.parse(agenda.tanggal!));
                    } catch (_) {}

                    // Cek Status Laporan (Ada isinya atau tidak)
                    bool isLapor = (agenda.laporans != null && agenda.laporans!.isNotEmpty);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A4E8A).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.event_note, color: Color(0xFF4A4E8A)),
                      ),
                      title: Text(
                        agenda.namaAgenda ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      // Tampilkan Tanggal & Status Laporan di subtitle
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formattedDate),
                          const SizedBox(height: 4),
                          // Badge Status Kecil
                          Text(
                            isLapor ? "✅ Terlaksana" : "⏳ Belum Lapor",
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.w600,
                              color: isLapor ? Colors.green : Colors.orange
                            ),
                          )
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // Kirim data ke halaman detail
                            builder: (context) => DetailLaporanAgendaPage(agenda: agenda),
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

  // Dialog Filter Bulan & Tahun (Agar user bisa ganti periode laporan)
  void _showFilterDialog(BuildContext context) {
    final viewModel = Provider.of<LaporanAgendaViewModel>(context, listen: false);
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
              child: const Text("Batal"),
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