import 'package:desa_go_aplikasi/page/detail_laporan_agenda_page.dart';
import 'package:desa_go_aplikasi/viewmodel/agenda_viewmodel.dart';
import 'package:desa_go_aplikasi/models/agenda_model.dart' as AgendaModel;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaporanAgendaPage extends StatefulWidget {
  const LaporanAgendaPage({super.key});

  @override
  State<LaporanAgendaPage> createState() => _LaporanAgendaPageState();
}

class _LaporanAgendaPageState extends State<LaporanAgendaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AgendaViewmodel>(context, listen: false).fetchAgenda();
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
          child: Consumer<AgendaViewmodel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading && viewModel.agendaList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.agendaList.isEmpty) {
                return const Center(child: Text('Belum ada data laporan agenda.'));
              }

              return RefreshIndicator(
                onRefresh: () => viewModel.synchronizeAgenda(),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  itemCount: viewModel.agendaList.length,
                  itemBuilder: (context, index) {
                    final AgendaModel.Data agenda = viewModel.agendaList[index];
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
                      subtitle: Text(agenda.tanggal ?? '-'),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
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
}