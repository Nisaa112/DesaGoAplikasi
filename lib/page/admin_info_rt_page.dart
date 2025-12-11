import 'package:desa_go_aplikasi/models/rt_model.dart' as RtModel;
import 'package:desa_go_aplikasi/viewmodel/rt_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import RwViewModel (asumsi) untuk mengambil daftar RW
// import 'package:desa_go_aplikasi/viewmodel/rw_viewmodel.dart'; 

class AdminInfoRtPage extends StatefulWidget {
  const AdminInfoRtPage({super.key});

  @override
  State<AdminInfoRtPage> createState() => _AdminInfoRtPageState();
}

class _AdminInfoRtPageState extends State<AdminInfoRtPage> {
  GlobalKey<_SlidableListItemState>? _currentlyOpenItemKey;

  // Data dummy RW (digunakan di pop-up)
  final List<Map<String, dynamic>> _listRwDummy = [
    {'id': 1, 'nama_rw': '001'},
    {'id': 2, 'nama_rw': '002'},
    {'id': 3, 'nama_rw': '003'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RtViewModel>(context, listen: false).loadRt();
    });
  }

  // =======================================================
  // MARK: - DIALOG UNTUK TAMBAH RT
  // =======================================================
  void _showAddRtDialog(BuildContext context) {
    final TextEditingController namaRtController = TextEditingController();
    int? selectedIdRw;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            Future<void> tambahRt() async {
              if (namaRtController.text.isEmpty || selectedIdRw == null) {
                _showSnackbar('Nama RT dan RW wajib diisi!', Colors.red);
                return;
              }

              setStateModal(() => isLoading = true);

              final newRt = RtModel.Data(
                namaRt: namaRtController.text,
                idRw: selectedIdRw,
              );

              try {
                final viewModel = Provider.of<RtViewModel>(this.context, listen: false);
                await viewModel.createRt(newRt); 
                _showSnackbar('RT baru berhasil ditambahkan!', const Color(0xFF5CB85C));
                Navigator.of(dialogContext).pop(); // Tutup modal
                Provider.of<RtViewModel>(this.context, listen: false).loadRt(); // Refresh list
              } catch (e) {
                final errorMessage = e.toString().split(':').last.trim();
                _showSnackbar('Gagal menambahkan RT: $errorMessage', Colors.red);
              } finally {
                setStateModal(() => isLoading = false);
              }
            }

            return AlertDialog(
              backgroundColor: Colors.white, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.all(25),
              title: const Text('Tambah Data RT', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Input Nama RT
                    _buildLabel('Nama RT'),
                    _buildTextField(controller: namaRtController, hint: 'Cth: RT 001'),
                    const SizedBox(height: 16),

                    // Dropdown RW
                    _buildLabel('Pilih RW'),
                    _buildDropdownRw(
                      selectedValue: selectedIdRw,
                      onChanged: (newValue) => setStateModal(() => selectedIdRw = newValue),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Simpan
                    ElevatedButton(
                      onPressed: isLoading ? null : tambahRt,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC212),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                        : const Text('Simpan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      namaRtController.dispose();
    });
  }
  
  // =======================================================
  // MARK: - DIALOG UNTUK EDIT RT
  // =======================================================
  void _showEditRtDialog(BuildContext context, RtModel.Data rt) {
    final TextEditingController namaRtController = TextEditingController(text: rt.namaRt);
    int? selectedIdRw = rt.idRw;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            Future<void> editRt() async {
              if (rt.id == null) {
                _showSnackbar('ID RT tidak ditemukan!', Colors.red);
                return;
              }
              if (namaRtController.text.isEmpty || selectedIdRw == null) {
                _showSnackbar('Nama RT dan RW wajib diisi!', Colors.red);
                return;
              }

              setStateModal(() => isLoading = true);

              final updatedRt = rt.copyWith(
                namaRt: namaRtController.text,
                idRw: selectedIdRw,
              );

              try {
                final viewModel = Provider.of<RtViewModel>(this.context, listen: false);
                await viewModel.updateRt(updatedRt); 
                _showSnackbar('Data RT berhasil diperbarui!', const Color(0xFF5CB85C));
                Navigator.of(dialogContext).pop(); // Tutup modal
                Provider.of<RtViewModel>(this.context, listen: false).loadRt(); // Refresh list
              } catch (e) {
                final errorMessage = e.toString().split(':').last.trim();
                _showSnackbar('Gagal memperbarui RT: $errorMessage', Colors.red);
              } finally {
                setStateModal(() => isLoading = false);
              }
            }

            return AlertDialog(
              backgroundColor: Colors.white, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.all(25),
              title: const Text('Edit Data RT', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Input Nama RT
                    _buildLabel('Nama RT'),
                    _buildTextField(controller: namaRtController, hint: 'Cth: RT 001'),
                    const SizedBox(height: 16),

                    // Dropdown RW
                    _buildLabel('Pilih RW'),
                    _buildDropdownRw(
                      selectedValue: selectedIdRw,
                      onChanged: (newValue) => setStateModal(() => selectedIdRw = newValue),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Simpan
                    ElevatedButton(
                      onPressed: isLoading ? null : editRt,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFCC33), // Warna berbeda untuk Edit
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Perbarui', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      namaRtController.dispose();
    });
  }


  // Implementasi fungsi-fungsi helper widget untuk Dialog
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4A4E8A), width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownRw({required int? selectedValue, required ValueChanged<int?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), 
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: selectedValue,
          hint: const Text('Pilih RW'),
          items: _listRwDummy.map((rw) {
            return DropdownMenuItem<int>(
              value: rw['id'],
              child: Text(rw['nama_rw']),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // --- Fungsi lainnya dari AdminInfoRtPage sebelumnya ---

  Future<bool> _confirmAndDelete(RtModel.Data rt) async {
    // Logika penghapusan tetap sama
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus RT'),
          content: Text('Anda yakin ingin menghapus data RT ${rt.namaRt}?'),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        if (!mounted) return false;
        final viewModel = Provider.of<RtViewModel>(context, listen: false);
        if (rt.id == null) {
          _showSnackbar('ID RT tidak ditemukan.', Colors.red);
          return false;
        }
        await viewModel.deleteRt(rt.id!);
        _showSnackbar('RT ${rt.namaRt} berhasil dihapus.', const Color(0xFF5CB85C));
        return true; 
      } catch (e) {
        _showSnackbar('Gagal menghapus RT: ${e.toString().split(':').last.trim()}', Colors.red);
        return false; 
      }
    }
    return false;
  }

  // Ganti navigasi push biasa menjadi showDialog untuk Edit
  void _navigateToEditPage(RtModel.Data rt) {
    _showEditRtDialog(context, rt);
  }

  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 2)),
    );
  }
  
  void _handleItemOpen(GlobalKey<_SlidableListItemState> key) {
    if (_currentlyOpenItemKey != null && _currentlyOpenItemKey != key) {
      _currentlyOpenItemKey?.currentState?.closeItem();
    }
    _currentlyOpenItemKey = key;
  }
  
  void _handleItemClose() {
    _currentlyOpenItemKey = null;
  }

  @override
  Widget build(BuildContext context) {
    final rtViewModel = Provider.of<RtViewModel>(context);
    const Color primaryColor = Color(0xFF4A4E8A);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text('Data RT Desa', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 200, height: 50, 
        child: FloatingActionButton.extended(
          // Panggil modal pop-up untuk Tambah RT
          onPressed: () => _showAddRtDialog(context), 
          backgroundColor: const Color(0xFFFFCC33), elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          icon: const Icon(Icons.add, color: Colors.black),
          label: const Text('Tambah RT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: _buildBody(rtViewModel),
        ),
      ),
    );
  }

  Widget _buildBody(RtViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (viewModel.errorMessage != null && viewModel.errorMessage!.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gagal memuat data: ${viewModel.errorMessage}', textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => viewModel.loadRt(), child: const Text('Coba Lagi')),
          ],
        ),
      );
    } else if (viewModel.listRt.isEmpty) {
      return const Center(child: Text('Tidak ada data RT.'));
    } else {
      return RefreshIndicator(
        color: const Color(0xFFFFC212),
        onRefresh: () async => await viewModel.loadRt(),
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 80.0),
          itemCount: viewModel.listRt.length,
          itemBuilder: (context, index) {
            final RtModel.Data rt = viewModel.listRt[index];
            final itemKey = GlobalKey<_SlidableListItemState>(); 
            
            return _SlidableListItem(
              key: itemKey,
              rt: rt,
              onEdit: _navigateToEditPage, // Memanggil showDialog
              onDelete: (r) async {
                final result = await _confirmAndDelete(r);
                if (result) {
                  viewModel.loadRt();
                } else {
                  itemKey.currentState?.closeItem();
                }
                return result; 
              },
              onItemOpen: _handleItemOpen,
              onItemClose: _handleItemClose,
            );
          },
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 8, endIndent: 8),
        ),
      );
    }
  }
}


// =======================================================
// WIDGET SLIDABLE LIST ITEM (TIDAK BERUBAH SIGNIFIKAN)
// =======================================================

class _SlidableListItem extends StatefulWidget {
  final RtModel.Data rt;
  final void Function(RtModel.Data) onEdit;
  final Future<bool> Function(RtModel.Data) onDelete; 
  final void Function(GlobalKey<_SlidableListItemState>) onItemOpen;
  final void Function() onItemClose;

  const _SlidableListItem({
    required super.key, 
    required this.rt, 
    required this.onEdit, 
    required this.onDelete,
    required this.onItemOpen,
    required this.onItemClose,
  });

  @override
  State<_SlidableListItem> createState() => _SlidableListItemState();
}

class _SlidableListItemState extends State<_SlidableListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  static const double _actionExtent = 140.0; 
  static const double _openThreshold = _actionExtent / 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _slideAnimation = Tween(begin: 0.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    if (_controller.value.abs() > 0) widget.onItemClose();
    _controller.dispose();
    super.dispose();
  }
  
  void closeItem() {
    if (_controller.value.abs() > 0) {
      _slideAnimation = Tween(begin: _slideAnimation.value, end: 0.0).animate(_controller);
      _controller.forward(from: 0.0).then((_) {
        _slideAnimation = Tween(begin: 0.0, end: 0.0).animate(_controller);
        widget.onItemClose();
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      double newOffset = _slideAnimation.value + details.primaryDelta!;
      newOffset = newOffset.clamp(-_actionExtent, 0.0);
      _slideAnimation = Tween(begin: newOffset, end: newOffset).animate(_controller);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final double currentOffset = _slideAnimation.value;
    if (currentOffset.abs() > _openThreshold) {
      _slideAnimation = Tween(begin: currentOffset, end: -_actionExtent).animate(_controller);
      _controller.forward(from: 0.0).then((_) {
        widget.onItemOpen(widget.key as GlobalKey<_SlidableListItemState>);
      });
    } else {
      _slideAnimation = Tween(begin: currentOffset, end: 0.0).animate(_controller);
      _controller.forward(from: 0.0).then((_) => widget.onItemClose());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Diubah: onTap memanggil onEdit (yang sekarang memanggil showDialog)
      onTap: () => _controller.value.abs() > 0 ? closeItem() : widget.onEdit(widget.rt),
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  // Diubah: onTap memanggil onEdit
                  onTap: () { closeItem(); widget.onEdit(widget.rt); },
                  child: Container(
                    width: _actionExtent / 2, color: const Color(0xFF4A4E8A),
                    alignment: Alignment.center, child: const Icon(Icons.edit, color: Colors.white),
                  ),
                ),
                InkWell(
                  onTap: () async => await widget.onDelete(widget.rt),
                  child: Container(
                    width: _actionExtent / 2, color: Colors.red,
                    alignment: Alignment.center, child: const Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.translate(offset: Offset(_slideAnimation.value, 0), child: child),
            child: Container(
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                title: Text(widget.rt.namaRt ?? 'Nama RT tidak tersedia', style: const TextStyle(fontWeight: FontWeight.bold)),
                // Tampilkan Nama RW (jika data RW tersedia di model RtModel.Data)
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}