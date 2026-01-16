import 'package:desa_go_aplikasi/models/rt_model.dart' as RtModel;
import 'package:desa_go_aplikasi/models/rw_model.dart' as RwModel;
import 'package:desa_go_aplikasi/viewmodel/rt_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rw_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart'; // Import AuthViewModel
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminInfoRtPage extends StatefulWidget {
  const AdminInfoRtPage({super.key});

  @override
  State<AdminInfoRtPage> createState() => _AdminInfoRtPageState();
}

class _AdminInfoRtPageState extends State<AdminInfoRtPage> {
  GlobalKey<_SlidableListItemState>? _currentlyOpenItemKey;
  late TextEditingController _namaRtController;

  @override
  void initState() {
    super.initState();
    _namaRtController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RtViewModel>(context, listen: false).loadRt();
      Provider.of<RwViewModel>(context, listen: false).loadRw();
    });
  }

  @override
  void dispose() {
    _namaRtController.dispose();
    super.dispose();
  }

  // =======================================================
  // MARK: - DIALOG TAMBAH RT (DIBATASI RW USER)
  // =======================================================
  void _showAddRtDialog(BuildContext context) {
    _namaRtController.clear();
    
    // Ambil ID RW dari user yang login
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    int? selectedIdRw = authVM.idRw; 
    
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            Future<void> tambahRt() async {
              if (_namaRtController.text.isEmpty || selectedIdRw == null) {
                _showSnackbar('Nama RT dan RW wajib diisi!', Colors.red);
                return;
              }

              setStateModal(() => isLoading = true);
              final newRt = RtModel.Data(
                namaRt: _namaRtController.text,
                idRw: selectedIdRw,
              );

              try {
                final viewModel = Provider.of<RtViewModel>(this.context, listen: false);
                await viewModel.createRt(newRt); 
                _showSnackbar('RT baru berhasil ditambahkan!', const Color(0xFF5CB85C));
                Navigator.of(dialogContext).pop(); 
                viewModel.loadRt(); 
              } catch (e) {
                _showSnackbar('Gagal: ${e.toString()}', Colors.red);
              } finally {
                setStateModal(() => isLoading = false);
              }
            }

            return AlertDialog(
              backgroundColor: Colors.white, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Tambah Data RT', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildLabel('Nama RT'),
                    _buildTextField(controller: _namaRtController, hint: 'Cth: RT 001'),
                    const SizedBox(height: 16),
                    _buildLabel('Pilih RW'),
                    // Dropdown RW dikunci jika user punya idRw
                    _buildDropdownRw(
                      selectedValue: selectedIdRw,
                      onChanged: authVM.idRw != null ? null : (newValue) => setStateModal(() => selectedIdRw = newValue),
                    ),
                    if (authVM.idRw != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text("*Terkunci pada wilayah RW Anda", style: TextStyle(fontSize: 10, color: Colors.orange)),
                      ),
                    const SizedBox(height: 20),
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
    );
  }
  
  // =======================================================
  // MARK: - DIALOG EDIT RT
  // =======================================================
  void _showEditRtDialog(BuildContext context, RtModel.Data rt) {
    _namaRtController.text = rt.namaRt ?? '';
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    int? selectedIdRw = rt.idRw;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            Future<void> editRt() async {
              if (_namaRtController.text.isEmpty || selectedIdRw == null) {
                _showSnackbar('Data tidak lengkap!', Colors.red);
                return;
              }

              setStateModal(() => isLoading = true);
              final updatedRt = rt.copyWith(namaRt: _namaRtController.text, idRw: selectedIdRw);

              try {
                final viewModel = Provider.of<RtViewModel>(this.context, listen: false);
                await viewModel.updateRt(updatedRt); 
                _showSnackbar('Data diperbarui!', const Color(0xFF5CB85C));
                Navigator.of(dialogContext).pop(); 
                viewModel.loadRt(); 
              } catch (e) {
                _showSnackbar('Gagal memperbarui', Colors.red);
              } finally {
                setStateModal(() => isLoading = false);
              }
            }

            return AlertDialog(
              backgroundColor: Colors.white, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Edit Data RT', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(controller: _namaRtController, hint: 'Nama RT'),
                  const SizedBox(height: 10),
                  _buildDropdownRw(
                    selectedValue: selectedIdRw,
                    onChanged: authVM.idRw != null ? null : (val) => setStateModal(() => selectedIdRw = val),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : editRt,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFCC33), minimumSize: const Size(double.infinity, 45)),
                    child: const Text('Perbarui', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- Widget helper Dropdown, TextField dll ---
  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)));

  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: Colors.grey), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget _buildDropdownRw({required int? selectedValue, required ValueChanged<int?>? onChanged}) {
    return Consumer<RwViewModel>(builder: (context, rwVM, _) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            isExpanded: true,
            value: selectedValue,
            hint: const Text('Pilih RW'),
            items: rwVM.listRw.map((rw) => DropdownMenuItem<int>(value: rw.id, child: Text(rw.namaRw ?? ''))).toList(),
            onChanged: onChanged, // Jika null, dropdown otomatis disabled
          ),
        ),
      );
    });
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final rtVM = Provider.of<RtViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context);
    final int? userRwId = authVM.idRw;

    return Scaffold(
      backgroundColor: const Color(0xFF4A4E8A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A4E8A),
        title: const Text('Data RT Desa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRtDialog(context), 
        backgroundColor: const Color(0xFFFFCC33),
        elevation: 0,
        label: const Text('Tambah RT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: _buildBody(rtVM, userRwId),
      ),
    );
  }

  Widget _buildBody(RtViewModel viewModel, int? userRwId) {
    if (viewModel.isLoading) return const Center(child: CircularProgressIndicator());

    // --- LOGIKA FILTER RT BERDASARKAN RW USER ---
    List<RtModel.Data> filteredList = viewModel.listRt;
    if (userRwId != null) {
      filteredList = viewModel.listRt.where((rt) => rt.idRw == userRwId).toList();
    }

    if (filteredList.isEmpty) return const Center(child: Text('Tidak ada data RT di wilayah Anda.'));

    return RefreshIndicator(
      onRefresh: () async => await viewModel.loadRt(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final rt = filteredList[index];
          return _SlidableListItem(
            key: GlobalKey<_SlidableListItemState>(),
            rt: rt,
            onEdit: (r) => _showEditRtDialog(context, r),
            onDelete: (r) async {
              final confirm = await _showDeleteConfirm(r);
              if (confirm) viewModel.loadRt();
              return confirm;
            },
            onItemOpen: (key) => setState(() => _currentlyOpenItemKey = key),
            onItemClose: () => _currentlyOpenItemKey = null,
          );
        },
      ),
    );
  }

  Future<bool> _showDeleteConfirm(RtModel.Data rt) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hapus?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (res == true) {
      await Provider.of<RtViewModel>(context, listen: false).deleteRt(rt.id!);
      _showSnackbar('Berhasil dihapus', Colors.green);
    }
    return res ?? false;
  }
}

// Widget SlidableListItem (tetap sama secara visual, hanya update callback)
class _SlidableListItem extends StatefulWidget {
  final RtModel.Data rt;
  final void Function(RtModel.Data) onEdit;
  final Future<bool> Function(RtModel.Data) onDelete;
  final void Function(GlobalKey<_SlidableListItemState>) onItemOpen;
  final void Function() onItemClose;

  const _SlidableListItem({super.key, required this.rt, required this.onEdit, required this.onDelete, required this.onItemOpen, required this.onItemClose});

  @override
  State<_SlidableListItem> createState() => _SlidableListItemState();
}

class _SlidableListItemState extends State<_SlidableListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _slideAnimation = Tween(begin: 0.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void closeItem() {
    _slideAnimation = Tween(begin: _slideAnimation.value, end: 0.0).animate(_controller);
    _controller.forward(from: 0.0).then((_) => widget.onItemClose());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (d) => setState(() {
        double newOffset = (_slideAnimation.value + d.primaryDelta!).clamp(-140.0, 0.0);
        _slideAnimation = Tween(begin: newOffset, end: newOffset).animate(_controller);
      }),
      onHorizontalDragEnd: (d) {
        if (_slideAnimation.value.abs() > 70) {
          _slideAnimation = Tween(begin: _slideAnimation.value, end: -140.0).animate(_controller);
          _controller.forward(from: 0.0).then((_) => widget.onItemOpen(widget.key as GlobalKey<_SlidableListItemState>));
        } else {
          closeItem();
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(onTap: () { closeItem(); widget.onEdit(widget.rt); }, child: Container(width: 70, color: Colors.blue, child: const Icon(Icons.edit, color: Colors.white))),
                InkWell(onTap: () => widget.onDelete(widget.rt), child: Container(width: 70, color: Colors.red, child: const Icon(Icons.delete, color: Colors.white))),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (c, child) => Transform.translate(offset: Offset(_slideAnimation.value, 0), child: child),
            child: Container(color: Colors.white, child: ListTile(title: Text(widget.rt.namaRt ?? '', style: const TextStyle(fontWeight: FontWeight.bold)))),
          ),
        ],
      ),
    );
  }
}