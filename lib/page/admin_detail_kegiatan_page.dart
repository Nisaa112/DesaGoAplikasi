import 'package:desa_go_aplikasi/models/ronda_model.dart' as Ronda;
import 'package:desa_go_aplikasi/models/posyandu_model.dart' as Posyandu;
import 'package:desa_go_aplikasi/models/agenda_model.dart' as Agenda;
import 'package:desa_go_aplikasi/models/rapat_model.dart' as Rapat;
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/ronda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/posyandu_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/agenda_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rapat_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/kas_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminDetailKegiatanPage extends StatefulWidget {
  final Map<String, dynamic> kegiatan;

  const AdminDetailKegiatanPage({super.key, required this.kegiatan});

  @override
  State<AdminDetailKegiatanPage> createState() => _AdminDetailKegiatanPageState();
}

class _AdminDetailKegiatanPageState extends State<AdminDetailKegiatanPage> {
  // Controllers
  final _namaController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jamMulaiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _anggaranController = TextEditingController();
  final _keteranganController = TextEditingController();
  final _hasilController = TextEditingController();
  final _pjDisplayController = TextEditingController();
  final _modalSearchController = TextEditingController();

  int? _selectedPjId;
  int? _selectedRwId;
  String _searchQuery = "";
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    final tipe = widget.kegiatan['tipe'];
    final data = widget.kegiatan['original_data'];
    final authVM = context.read<AuthViewModel>();
    _selectedRwId = authVM.idRw;

    _namaController.text = widget.kegiatan['nama'] ?? '';
    _tanggalController.text = widget.kegiatan['tanggal'] ?? '';
    _lokasiController.text = widget.kegiatan['lokasi'] ?? '';

    if (tipe == 'Ronda') {
      final d = data as Ronda.RondaData;
      _anggaranController.text = d.anggaran?.toString() ?? '0';
      _keteranganController.text = d.detail ?? '';
      _selectedPjId = d.penanggungJawab;
      _jamMulaiController.text = "22:00"; // Default ronda
    } else if (tipe == 'Posyandu') {
      final d = data as Posyandu.Data;
      _anggaranController.text = d.anggaran?.toString() ?? '0';
      _keteranganController.text = d.keterangan ?? '';
      _hasilController.text = d.ringkasanHasil ?? '';
      _jamMulaiController.text = d.jamMulai ?? '08:00';
      _selectedPjId = int.tryParse(d.penanggungJawab ?? '');
    } else if (tipe == 'Agenda') {
      final d = data as Agenda.Data;
      _anggaranController.text = d.anggaran?.toString() ?? '0';
      _keteranganController.text = d.keterangan ?? '';
      _hasilController.text = d.hasil ?? '';
      _jamMulaiController.text = d.jamMulai ?? '08:00';
      _selectedPjId = d.penanggungJawab?.id; 
    } else if (tipe == 'Rapat') {
      final d = data as Rapat.Data;
      _anggaranController.text = d.anggaran?.toString() ?? '0';
      _keteranganController.text = d.tujuan ?? '';
      _hasilController.text = d.kesimpulan ?? '';
      _jamMulaiController.text = d.jamMulai ?? '19:30';
      _selectedPjId = int.tryParse(d.penanggungJawab ?? '');
    }

    // Ambil nama PJ dari WargaViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wargaVM = context.read<WargaViewModel>();
      try {
        final pj = wargaVM.listWarga.firstWhere((w) => w.id == _selectedPjId);
        _pjDisplayController.text = pj.nama ?? '';
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tanggalController.dispose();
    _jamMulaiController.dispose();
    _lokasiController.dispose();
    _anggaranController.dispose();
    _keteranganController.dispose();
    _hasilController.dispose();
    _pjDisplayController.dispose();
    _modalSearchController.dispose();
    super.dispose();
  }

  // Pickers (White Background)
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF4A4E8A), surface: Colors.white)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked));
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF4A4E8A), surface: Colors.white)),
        child: child!,
      ),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() => _jamMulaiController.text = DateFormat('HH:mm').format(dt));
    }
  }

  void _showPjPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          expand: false,
          builder: (_, sc) => Column(
            children: [
              const SizedBox(height: 15),
              const Text("Pilih Penanggung Jawab", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _modalSearchController,
                  decoration: InputDecoration(hintText: "Cari nama...", prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  onChanged: (v) => setModalState(() => _searchQuery = v.toLowerCase()),
                ),
              ),
              Expanded(
                child: Consumer<WargaViewModel>(
                  builder: (context, vm, _) {
                    final list = vm.listWarga.where((w) => w.rt?.idRw == _selectedRwId && (w.nama?.toLowerCase().contains(_searchQuery) ?? false)).toList();
                    return ListView.builder(
                      controller: sc,
                      itemCount: list.length,
                      itemBuilder: (context, i) => ListTile(
                        title: Text(list[i].nama ?? ''),
                        onTap: () {
                          setState(() { _selectedPjId = list[i].id; _pjDisplayController.text = list[i].nama ?? ''; });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _simpanPerubahan() async {
    setState(() => _isSubmitting = true);
    final tipe = widget.kegiatan['tipe'];
    final dataAsli = widget.kegiatan['original_data'];

    try {
      if (tipe == 'Ronda') {
        final updated = Ronda.RondaData(
          id: dataAsli.id,
          tanggal: _tanggalController.text,
          lokasi: _lokasiController.text,
          detail: _keteranganController.text,
          anggaran: int.tryParse(_anggaranController.text),
          penanggungJawab: _selectedPjId,
          detailRondas: dataAsli.detailRondas,
        );
        await context.read<RondaViewModel>().updateRonda(updated);
      } else if (tipe == 'Posyandu') {
        final updated = Posyandu.Data(
          id: dataAsli.id,
          judulPosyandu: _namaController.text,
          tanggal: _tanggalController.text,
          jamMulai: _jamMulaiController.text, // FIX: Kirim jamMulai
          lokasi: _lokasiController.text,
          anggaran: int.tryParse(_anggaranController.text),
          penanggungJawab: _selectedPjId?.toString(),
          ringkasanHasil: _hasilController.text,
          keterangan: _keteranganController.text,
          status: dataAsli.status,
        );
        await context.read<PosyanduViewmodel>().updatePosyandu(updated);
      } else if (tipe == 'Agenda') {
        final updated = Agenda.Data(
          id: dataAsli.id,
          namaAgenda: _namaController.text,
          tanggal: _tanggalController.text,
          jamMulai: _jamMulaiController.text, // FIX: Kirim jamMulai
          lokasi: _lokasiController.text,
          anggaran: int.tryParse(_anggaranController.text),
          penanggungJawab: Agenda.PenanggungJawabWarga(id: _selectedPjId), 
          hasil: _hasilController.text,
          keterangan: _keteranganController.text,
          status: dataAsli.status,
        );
        await context.read<AgendaViewmodel>().updateAgenda(updated);
      } else if (tipe == 'Rapat') {
        final updated = Rapat.Data(
          id: dataAsli.id,
          judulRapat: _namaController.text,
          tanggal: _tanggalController.text,
          jamMulai: _jamMulaiController.text, // FIX: Kirim jamMulai
          lokasi: _lokasiController.text,
          anggaran: int.tryParse(_anggaranController.text),
          penanggungJawab: _selectedPjId?.toString(),
          kesimpulan: _hasilController.text,
          tujuan: _keteranganController.text,
          status: dataAsli.status,
        );
        await context.read<RapatViewmodel>().updateRapat(updated);
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil disimpan!"), backgroundColor: Colors.green));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A4E8A);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor, elevation: 0, centerTitle: true,
        title: Text('Edit ${widget.kegiatan['tipe']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildInputField("Judul Kegiatan", _namaController),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildInputField("Tanggal", _tanggalController, isReadOnly: true, onTap: _selectDate, suffixIcon: const Icon(Icons.calendar_today, size: 18))),
                        const SizedBox(width: 15),
                        Expanded(child: _buildInputField("Jam Mulai", _jamMulaiController, isReadOnly: true, onTap: _selectTime, suffixIcon: const Icon(Icons.access_time, size: 18))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInputField("Lokasi", _lokasiController),
                    const SizedBox(height: 20),
                    _buildInputField("Penanggung Jawab", _pjDisplayController, isReadOnly: true, onTap: _showPjPicker, suffixIcon: const Icon(Icons.search)),
                    const SizedBox(height: 20),
                    _buildInputField("Anggaran (Rp)", _anggaranController, keyboardType: TextInputType.number),
                    const SizedBox(height: 20),
                    _buildInputField("Keterangan/Deskripsi", _keteranganController, maxLines: 3),
                    const SizedBox(height: 20),
                    _buildInputField("Laporan Hasil/Kesimpulan", _hasilController, maxLines: 4),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24.0), width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _simpanPerubahan,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C2C2C), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {int maxLines = 1, bool isReadOnly = false, VoidCallback? onTap, Widget? suffixIcon, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller, readOnly: isReadOnly, onTap: onTap, maxLines: maxLines, keyboardType: keyboardType,
          decoration: InputDecoration(filled: isReadOnly, fillColor: isReadOnly ? Colors.grey.shade50 : Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), suffixIcon: suffixIcon),
        ),
      ],
    );
  }
}