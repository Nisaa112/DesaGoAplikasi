import 'package:desa_go_aplikasi/models/rt_model.dart' as RtModel;
import 'package:desa_go_aplikasi/models/rw_model.dart' as RwModel;
import 'package:desa_go_aplikasi/viewmodel/rt_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/rw_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminInfoRtPage extends StatefulWidget {
  const AdminInfoRtPage({super.key});

  @override
  State<AdminInfoRtPage> createState() => _AdminInfoRtPageState();
}

class _AdminInfoRtPageState extends State<AdminInfoRtPage> {
  // Controller untuk manajemen slide (agar hanya satu yang terbuka)
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

  // Handle ketika salah satu item digeser terbuka
  void _handleItemOpen(GlobalKey<_SlidableListItemState> key) {
    if (_currentlyOpenItemKey != null && _currentlyOpenItemKey != key) {
      _currentlyOpenItemKey?.currentState?.closeItem();
    }
    _currentlyOpenItemKey = key;
  }

  void _handleItemClose() => _currentlyOpenItemKey = null;

  // =======================================================
  // MARK: - DIALOG TAMBAH & EDIT RT
  // =======================================================

  void _showAddRtDialog(BuildContext context) {
    _namaRtController.clear();
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
              try {
                final viewModel = Provider.of<RtViewModel>(this.context, listen: false);
                await viewModel.createRt(RtModel.Data(namaRt: _namaRtController.text, idRw: selectedIdRw)); 
                _showSnackbar('RT berhasil ditambahkan!', const Color(0xFF5CB85C));
                Navigator.of(dialogContext).pop(); 
                viewModel.loadRt(); 
              } catch (e) {
                _showSnackbar('Gagal: $e', Colors.red);
              } finally {
                setStateModal(() => isLoading = false);
              }
            }
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Tambah Data RT', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(controller: _namaRtController, hint: 'Cth: RT 001'),
                  const SizedBox(height: 15),
                  _buildDropdownRw(
                    selectedValue: selectedIdRw,
                    onChanged: authVM.idRw != null ? null : (val) => setStateModal(() => selectedIdRw = val),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : tambahRt,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFC212), minimumSize: const Size(double.infinity, 45)),
                    child: isLoading ? const CircularProgressIndicator() : const Text('Simpan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditRtDialog(RtModel.Data rt) {
    _namaRtController.text = rt.namaRt ?? '';
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    int? selectedIdRw = rt.idRw;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Edit Data RT', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(controller: _namaRtController, hint: 'Nama RT'),
              const SizedBox(height: 15),
              _buildDropdownRw(
                selectedValue: selectedIdRw,
                onChanged: authVM.idRw != null ? null : (val) => setStateModal(() => selectedIdRw = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  setStateModal(() => isLoading = true);
                  try {
                    await Provider.of<RtViewModel>(this.context, listen: false).updateRt(rt.copyWith(namaRt: _namaRtController.text, idRw: selectedIdRw));
                    _showSnackbar('Berhasil diperbarui', Colors.green);
                    Navigator.pop(context);
                    Provider.of<RtViewModel>(this.context, listen: false).loadRt();
                  } catch (e) {
                    _showSnackbar('Gagal: $e', Colors.red);
                  } finally {
                    setStateModal(() => isLoading = false);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFC212), minimumSize: const Size(double.infinity, 45)),
                child: const Text('Perbarui', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteRt(RtModel.Data rt) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus RT'),
        content: Text('Yakin hapus ${rt.namaRt}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await Provider.of<RtViewModel>(context, listen: false).deleteRt(rt.id!);
      Provider.of<RtViewModel>(context, listen: false).loadRt();
      _showSnackbar('RT dihapus', Colors.green);
    }
  }

  // --- UI Helpers ---
  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return TextField(controller: controller, decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
  }

  Widget _buildDropdownRw({required int? selectedValue, required ValueChanged<int?>? onChanged}) {
    return Consumer<RwViewModel>(builder: (context, rwVM, _) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true, value: selectedValue, hint: const Text('Pilih RW'),
          items: rwVM.listRw.map((rw) => DropdownMenuItem<int>(value: rw.id, child: Text(rw.namaRw ?? ''))).toList(),
          onChanged: onChanged,
        ),
      ),
    ));
  }

  void _showSnackbar(String m, Color c) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c));

  @override
  Widget build(BuildContext context) {
    final rtVM = Provider.of<RtViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context);
    const Color primaryColor = Color(0xFF4A4E8A);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor, elevation: 0,
        centerTitle: true,
        title: const Text('Data RT Desa', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRtDialog(context),
        backgroundColor: const Color(0xFFFFCC33), elevation: 0,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('Tambah RT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: _buildBody(rtVM, authVM.idRw),
      ),
    );
  }

  Widget _buildBody(RtViewModel viewModel, int? userRwId) {
    if (viewModel.isLoading && viewModel.listRt.isEmpty) return const Center(child: CircularProgressIndicator());
    
    List<RtModel.Data> filteredList = viewModel.listRt;
    if (userRwId != null) filteredList = viewModel.listRt.where((rt) => rt.idRw == userRwId).toList();

    if (filteredList.isEmpty) return const Center(child: Text('Tidak ada data RT.'));

    return RefreshIndicator(
      onRefresh: () async => await viewModel.loadRt(),
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 80),
        itemCount: filteredList.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final rt = filteredList[index];
          final itemKey = GlobalKey<_SlidableListItemState>();
          return _SlidableListItem(
            key: itemKey,
            rt: rt,
            onEdit: () => _showEditRtDialog(rt),
            onDelete: () => _deleteRt(rt),
            onItemOpen: _handleItemOpen,
            onItemClose: _handleItemClose,
          );
        },
      ),
    );
  }
}

// =======================================================
// WIDGET SLIDABLE LIST ITEM
// =======================================================
class _SlidableListItem extends StatefulWidget {
  final RtModel.Data rt;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final void Function(GlobalKey<_SlidableListItemState>) onItemOpen;
  final void Function() onItemClose;

  const _SlidableListItem({
    required super.key, 
    required this.rt, 
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
    _controller.forward(from: 0.0).then((_) => widget.onItemClose());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _controller.value.abs() > 0 ? closeItem() : widget.onEdit(),
      onHorizontalDragUpdate: (d) => setState(() {
        double newOffset = (_slideAnimation.value + d.primaryDelta!).clamp(-_actionExtent, 0.0);
        _slideAnimation = Tween(begin: newOffset, end: newOffset).animate(_controller);
      }),
      onHorizontalDragEnd: (d) {
        if (_slideAnimation.value.abs() > _actionExtent / 2) {
          _slideAnimation = Tween(begin: _slideAnimation.value, end: -_actionExtent).animate(_controller);
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
                InkWell(
                  onTap: () { closeItem(); widget.onEdit(); }, 
                  child: Container(
                    width: _actionExtent / 2, 
                    color: const Color(0xFF4A4E8A), 
                    alignment: Alignment.center, 
                    child: const Icon(Icons.edit, color: Colors.white)
                  )
                ),
                InkWell(
                  onTap: () { closeItem(); widget.onDelete(); }, 
                  child: Container(
                    width: _actionExtent / 2, 
                    color: Colors.red, 
                    alignment: Alignment.center, 
                    child: const Icon(Icons.delete, color: Colors.white)
                  )
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), 
                title: Text(
                  widget.rt.namaRt ?? '', 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)
                ),
                subtitle: Text(
                  "Wilayah Rukun Tetangga", 
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13)
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}