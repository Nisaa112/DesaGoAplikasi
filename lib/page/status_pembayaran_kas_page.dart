import 'package:desa_go_aplikasi/models/kas_model.dart' as KasModel;
import 'package:desa_go_aplikasi/models/transaksi_model.dart' as TransaksiModel;
import 'package:desa_go_aplikasi/viewmodel/kas_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/transaksi_kas_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class StatusPembayaranKasPage extends StatefulWidget {
  final String kasTitle;
  const StatusPembayaranKasPage({super.key, required this.kasTitle});

  @override
  State<StatusPembayaranKasPage> createState() => _StatusPembayaranKasPageState();
}

class _StatusPembayaranKasPageState extends State<StatusPembayaranKasPage> {
  final _keteranganController = TextEditingController();
  final _jumlahController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _jenisTerpilih = 'masuk';

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Fungsi helper untuk refresh semua data terkait
  Future<void> _refreshData() async {
    final trxVM = Provider.of<TransaksiViewModel>(context, listen: false);
    final kasVM = Provider.of<KasViewModel>(context, listen: false);
    await trxVM.loadTransaksi();
    await kasVM.loadKas();
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, StateSetter setStateModal) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setStateModal(() => _selectedDate = picked);
    }
  }

  // FUNGSI KONFIRMASI HAPUS
  void _confirmDelete(BuildContext context, TransaksiModel.Data transaction, TransaksiViewModel trxVM) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Transaksi?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus "${transaction.keterangan}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (transaction.id != null) {
                Navigator.pop(context);
                await trxVM.deleteTransaksi(transaction.id!);
                
                if (context.mounted) {
                  final kasVM = Provider.of<KasViewModel>(context, listen: false);
                  await kasVM.loadKas();
                  await trxVM.loadTransaksi();
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transaksi berhasil dihapus dan saldo diperbarui')),
                    );
                  }
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransaksiViewModel, KasViewModel>(
      builder: (context, trxVM, kasVM, child) {
        final currentKas = kasVM.listKas.firstWhere(
          (element) => element.namaPengguna == widget.kasTitle,
          orElse: () => KasModel.Data(saldo: "0"),
        );

        final allTrxForThisKas = trxVM.listTransaksi.where((t) => t.kasId == currentKas.id).toList();
        
        List<TransaksiModel.Data> filteredDisplay = allTrxForThisKas;
        if (trxVM.filterStatus == 'masuk') {
          filteredDisplay = allTrxForThisKas.where((t) => t.jenis == 'masuk').toList();
        } else if (trxVM.filterStatus == 'keluar') {
          filteredDisplay = allTrxForThisKas.where((t) => t.jenis == 'keluar').toList();
        }

        double totalMasuk = 0;
        double totalKeluar = 0;
        for (var t in allTrxForThisKas) {
          if (t.jenis == 'masuk') totalMasuk += (t.jumlah ?? 0).toDouble();
          else totalKeluar += (t.jumlah ?? 0).toDouble();
        }

        const Color primaryColor = Color(0xFF4A4E8A);

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: const Text('Status Pembayaran Kas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: primaryColor,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  _buildSummaryCard(currentKas, totalMasuk, totalKeluar),
                  const SizedBox(height: 20),
                  _buildRiwayatTransaksi(filteredDisplay, trxVM),
                ],
              ),
            ),
          ),
          bottomSheet: _buildBottomSheet(context, currentKas.id),
        );
      }
    );
  }

  Widget _buildSummaryCard(KasModel.Data kas, double masuk, double keluar) {
    final fmt = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final double saldoAkhir = masuk - keluar;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildPieChart(masuk, keluar),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem('Pemasukan', const Color(0xFFFFC212)),
                  _buildLegendItem('Pengeluaran', Colors.black),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Text(widget.kasTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          const Text('Sisa saldo kas akhir',
              style: TextStyle(color: Colors.grey)),
          Text(
            fmt.format(saldoAkhir),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4E8A),
            ),
          ),
          const Divider(),
          Text(
            'Total Pemasukan : ${fmt.format(masuk)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }


  Widget _buildRiwayatTransaksi(List<TransaksiModel.Data> transactions, TransaksiViewModel trxVM) {
    final fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    IconData filterIcon = Icons.filter_list;
    String filterText = "Semua";
    Color filterColor = Colors.grey;

    if (trxVM.filterStatus == 'masuk') {
      filterIcon = Icons.trending_up;
      filterText = "Masuk";
      filterColor = const Color(0xFFFFC212);
    } else if (trxVM.filterStatus == 'keluar') {
      filterIcon = Icons.trending_down;
      filterText = "Keluar";
      filterColor = const Color(0xFF4A4E8A);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Riwayat Transaksi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () => trxVM.toggleFilter(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(filterIcon, size: 16, color: filterColor),
                      const SizedBox(width: 5),
                      Text(filterText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: filterColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (transactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text("Tidak ada data transaksi", style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...transactions.map((t) => InkWell(
              onLongPress: () => _confirmDelete(context, t, trxVM),
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(t.jenis == 'masuk' ? Icons.add_circle : Icons.remove_circle,
                            color: t.jenis == 'masuk' ? const Color(0xFFFFC212) : const Color(0xFF4A4E8A)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.keterangan ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(t.tanggal ?? '-', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                    Text(fmt.format(t.jumlah ?? 0), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
          // const Center(
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 8, bottom: 20),
          //     child: Text("Tekan lama untuk menghapus transaksi", style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic)),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context, int? kasId) {
    return Container(
      padding: const EdgeInsets.all(20), color: Colors.grey.shade100,
      child: ElevatedButton(
        onPressed: () => _showAddTrxDialog(context, kasId),
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFC212), minimumSize: const Size(double.infinity, 50), elevation: 0,shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),),
        child: const Text('Tambah Transaksi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
    );
  }

  void _showAddTrxDialog(BuildContext context, int? kasId) {
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Tambah Transaksi', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: isSaving ? null : () => _selectDate(context, setStateModal),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10), 
                      border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                        const Icon(Icons.calendar_month, color: Color(0xFF4A4E8A)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Keterangan', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTextField(_keteranganController, 'Cth: Bayar Listrik', enabled: !isSaving),
                const SizedBox(height: 16),
                const Text('Jenis', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildDropdown(setStateModal, enabled: !isSaving),
                const SizedBox(height: 16),
                const Text('Jumlah (Rp)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTextField(_jumlahController, 'Cth: 50000', isNum: true, enabled: !isSaving),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isSaving 
                  ? null 
                  : () async {
                      if (_jumlahController.text.isEmpty || kasId == null) return;
                      setStateModal(() => isSaving = true);
                      try {
                        final trx = TransaksiModel.Data(
                          kasId: kasId,
                          tanggal: DateFormat('yyyy-MM-dd').format(_selectedDate),
                          keterangan: _keteranganController.text,
                          jenis: _jenisTerpilih,
                          jumlah: int.parse(_jumlahController.text),
                        );
                        await Provider.of<TransaksiViewModel>(this.context, listen: false).createTransaksi(trx);
                        await Provider.of<KasViewModel>(this.context, listen: false).loadKas();
                        if (mounted) Navigator.pop(context);
                        _keteranganController.clear();
                        _jumlahController.clear();
                        _selectedDate = DateTime.now();
                      } catch (e) {
                        setStateModal(() => isSaving = false);
                      }
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC212), 
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), 
                    ),
                  ),
                  child: isSaving 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)
                      )
                    : const Text('Simpan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                if (!isSaving) Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController cont, String hint, {bool isNum = false, bool enabled = true}) {
    return TextField(
      controller: cont,
      enabled: enabled,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint, 
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300)
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4A4E8A))
        ),
      ),
    );
  }

  Widget _buildDropdown(StateSetter setStateModal, {bool enabled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(10), 
        border: Border.all(color: Colors.grey.shade300)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true, 
          value: _jenisTerpilih,
          dropdownColor: Colors.white, 
          onChanged: enabled ? (v) => setStateModal(() => _jenisTerpilih = v!) : null,
          items: const [
            DropdownMenuItem(value: 'masuk', child: Text('Uang Masuk')), 
            DropdownMenuItem(value: 'keluar', child: Text('Uang Keluar'))
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) => Row(children: [Container(width: 10, height: 10, color: color), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 12))]);

  Widget _buildPieChart(double income, double expense) {
    double total = income + expense;
    return SizedBox(width: 80, height: 80, child: CustomPaint(painter: PieChartPainter(incomeRatio: total > 0 ? income / total : 1, expenseRatio: total > 0 ? expense / total : 0, incomeColor: const Color(0xFFFFC212), expenseColor: Colors.black)));
  }
}

class PieChartPainter extends CustomPainter {
  final double incomeRatio; final double expenseRatio; final Color incomeColor; final Color expenseColor;
  PieChartPainter({required this.incomeRatio, required this.expenseRatio, required this.incomeColor, required this.expenseColor});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2); final radius = size.width / 2; final paint = Paint()..style = PaintingStyle.fill;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -1.57, 6.28 * expenseRatio, true, paint..color = expenseColor);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -1.57 + (6.28 * expenseRatio), 6.28 * incomeRatio, true, paint..color = incomeColor);
    canvas.drawCircle(center, radius * 0.7, Paint()..color = Colors.white);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}