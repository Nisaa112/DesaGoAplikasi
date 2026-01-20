import 'package:desa_go_aplikasi/models/kas_model.dart' as KasModel;
import 'package:desa_go_aplikasi/viewmodel/kas_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/page/status_pembayaran_kas_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BendaharaPembayaranKasPage extends StatefulWidget {
  const BendaharaPembayaranKasPage({super.key});

  @override
  State<BendaharaPembayaranKasPage> createState() => _BendaharaPembayaranKasPageState();
}

class _BendaharaPembayaranKasPageState extends State<BendaharaPembayaranKasPage> {
  GlobalKey<_SlidableListItemState>? _currentlyOpenItemKey;
  late TextEditingController _namaKasController;

  @override
  void initState() {
    super.initState();
    _namaKasController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KasViewModel>(context, listen: false).loadKas();
    });
  }

  @override
  void dispose() {
    _namaKasController.dispose();
    super.dispose();
  }

  void _handleItemOpen(GlobalKey<_SlidableListItemState> key) {
    if (_currentlyOpenItemKey != null && _currentlyOpenItemKey != key) {
      _currentlyOpenItemKey?.currentState?.closeItem();
    }
    _currentlyOpenItemKey = key;
  }

  void _handleItemClose() => _currentlyOpenItemKey = null;

  // =======================================================
  // DIALOG TAMBAH & EDIT KAS
  // =======================================================

  void _showKasDialog({KasModel.Data? kas}) {
    final bool isEdit = kas != null;
    _namaKasController.text = isEdit ? kas.namaPengguna ?? '' : '';
    
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            Future<void> simpanKas() async {
              if (_namaKasController.text.trim().isEmpty) {
                _showSnackbar('Nama Kas wajib diisi!', Colors.red);
                return;
              }

              setStateModal(() => isLoading = true);
              
              final data = KasModel.Data(
                id: isEdit ? kas.id : null,
                namaPengguna: _namaKasController.text.trim(),
                email: isEdit ? (kas.email ?? 'bank@example.com') : 'bank@example.com',
                peran: isEdit ? (kas.peran ?? 'bank') : 'bank',
                saldo: isEdit ? (kas.saldo ?? "0") : "0", 
              );

              try {
                final viewModel = Provider.of<KasViewModel>(this.context, listen: false);
                if (isEdit) {
                  await viewModel.updateKas(data);
                  _showSnackbar('Kas berhasil diperbarui!', const Color(0xFF5CB85C));
                } else {
                  await viewModel.createKas(data);
                  _showSnackbar('Kas baru berhasil ditambahkan!', const Color(0xFF5CB85C));
                }
                Navigator.of(dialogContext).pop();
                viewModel.loadKas();
              } catch (e) {
                _showSnackbar('Gagal menyimpan: $e', Colors.red);
              } finally {
                setStateModal(() => isLoading = false);
              }
            }

            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(isEdit ? 'Edit Data Kas' : 'Tambah Data Kas', 
                style: const TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildLabel('Nama Kas'),
                    _buildTextField(
                      controller: _namaKasController, 
                      hint: 'Cth: Iuran Agustus',
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: isLoading ? null : simpanKas,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC212),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: isLoading
                        ? const SizedBox(width: 24, height: 24, 
                            child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                        : const Text('Simpan', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    // TOMBOL BATAL (Konsisten dengan halaman Status Pembayaran Kas)
                    if (!isLoading) 
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteKas(KasModel.Data kas) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, 
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Kas', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus "${kas.namaPengguna}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text('Batal', style: TextStyle(color: Colors.grey))
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Hapus', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
    if (confirm == true) {
      await Provider.of<KasViewModel>(context, listen: false).deleteKas(kas.id!);
      _showSnackbar('Kas berhasil dihapus', Colors.green);
    }
  }

  // --- UI Helpers ---
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0), 
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold))
  );

  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
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

  void _showSnackbar(String m, Color c) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(m), backgroundColor: c, duration: const Duration(seconds: 2))
  );

  @override
  Widget build(BuildContext context) {
    final kasVM = Provider.of<KasViewModel>(context);
    const Color primaryColor = Color(0xFF4A4E8A);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Pembayaran Kas', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showKasDialog(),
        backgroundColor: const Color(0xFFFFCC33),
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('Tambah Kas', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: _buildBody(kasVM),
      ),
    );
  }

  Widget _buildBody(KasViewModel viewModel) {
    if (viewModel.isLoading && viewModel.listKas.isEmpty) return const Center(child: CircularProgressIndicator());
    if (viewModel.listKas.isEmpty) return const Center(child: Text('Tidak ada data Kas.'));

    return RefreshIndicator(
      onRefresh: () async => await viewModel.loadKas(),
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 80),
        itemCount: viewModel.listKas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final kas = viewModel.listKas[index];
          final itemKey = GlobalKey<_SlidableListItemState>();
          return _SlidableListItem(
            key: itemKey,
            kas: kas,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatusPembayaranKasPage(kasTitle: kas.namaPengguna ?? '-',),
                ),
              );
            },
            onEdit: () => _showKasDialog(kas: kas),
            onDelete: () => _deleteKas(kas),
            onItemOpen: _handleItemOpen,
            onItemClose: _handleItemClose,
          );
        },
      ),
    );
  }
}

class _SlidableListItem extends StatefulWidget {
  final KasModel.Data kas;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final void Function(GlobalKey<_SlidableListItemState>) onItemOpen;
  final void Function() onItemClose;

  const _SlidableListItem({
    required super.key, 
    required this.kas, 
    required this.onTap,
    required this.onEdit, 
    required this.onDelete, 
    required this.onItemOpen, 
    required this.onItemClose
  });

  @override
  State<_SlidableListItem> createState() => _SlidableListItemState();
}

class _SlidableListItemState extends State<_SlidableListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  static const double _actionExtent = 140.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _slideAnimation = Tween(begin: 0.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() { 
    _controller.dispose(); 
    super.dispose(); 
  }

  void closeItem() {
    _slideAnimation = Tween(begin: _slideAnimation.value, end: 0.0).animate(_controller);
    _controller.forward(from: 0.0).then((_) {
      widget.onItemClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _controller.value.abs() > 0 ? closeItem() : widget.onTap(),
      onHorizontalDragUpdate: (d) => setState(() {
        double newOffset = (_slideAnimation.value + d.primaryDelta!).clamp(-_actionExtent, 0.0);
        _slideAnimation = Tween(begin: newOffset, end: newOffset).animate(_controller);
      }),
      onHorizontalDragEnd: (d) {
        if (_slideAnimation.value.abs() > _actionExtent / 2) {
          _slideAnimation = Tween(begin: _slideAnimation.value, end: -_actionExtent).animate(_controller);
          _controller.forward(from: 0.0).then((_) {
            widget.onItemOpen(widget.key as GlobalKey<_SlidableListItemState>);
          });
        } else {
          closeItem();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double currentOffset = _slideAnimation.value;
          double slideProgress = (currentOffset.abs() / _actionExtent).clamp(0.0, 1.0);

          return Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: slideProgress, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () { closeItem(); widget.onEdit(); }, 
                        child: Container(
                          width: 70, color: const Color(0xFF4A4E8A), 
                          alignment: Alignment.center, 
                          child: const Icon(Icons.edit, color: Colors.white)
                        )
                      ),
                      InkWell(
                        onTap: () { closeItem(); widget.onDelete(); }, 
                        child: Container(
                          width: 70, color: Colors.red, 
                          alignment: Alignment.center, 
                          child: const Icon(Icons.delete, color: Colors.white)
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(currentOffset, 0),
                child: child,
              ),
            ],
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.kas.namaPengguna ?? '-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Saldo: Rp ${widget.kas.saldo ?? '0'}", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}