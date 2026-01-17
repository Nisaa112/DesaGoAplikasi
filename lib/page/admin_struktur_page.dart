import 'package:desa_go_aplikasi/page/admin_identitas_pejabat_page.dart';
import 'package:desa_go_aplikasi/page/admin_tambah_struktur_page.dart';
import 'package:desa_go_aplikasi/viewmodel/struktur_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desa_go_aplikasi/models/struktur_model.dart' as StrukturModel;

class AdminStrukturPage extends StatefulWidget {
  const AdminStrukturPage({super.key});

  @override
  State<AdminStrukturPage> createState() => _AdminStrukturPageState();
}

class _AdminStrukturPageState extends State<AdminStrukturPage> {
  GlobalKey<_SlidableListItemState>? _currentlyOpenItemKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StrukturViewModel>(context, listen: false).loadStruktur();
    });
  }

  void _handleItemOpen(GlobalKey<_SlidableListItemState> key) {
    if (_currentlyOpenItemKey != null && _currentlyOpenItemKey != key) {
      _currentlyOpenItemKey?.currentState?.closeItem();
    }
    _currentlyOpenItemKey = key;
  }

  void _handleItemClose() => _currentlyOpenItemKey = null;

  Future<void> _deleteMember(StrukturModel.Data member) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Struktur'),
        content: Text('Yakin ingin menghapus ${member.nama} dari struktur?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await Provider.of<StrukturViewModel>(context, listen: false).deleteStruktur(member.id!);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil dihapus'), backgroundColor: Colors.green));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final int? adminRwId = authViewModel.idRw;

    return Consumer<StrukturViewModel>(
      builder: (context, viewModel, child) {
        final filteredList = viewModel.strukturList.where((member) {
          if (adminRwId == null) return false;
          return member.idRw == adminRwId;
        }).toList();

        return Scaffold(
          backgroundColor: const Color(0xFF4A4E8A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF4A4E8A),
            elevation: 0,
            centerTitle: true,
            title: Text('Struktur RW ${adminRwId ?? ""}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: _buildBody(viewModel, filteredList),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildFAB(context),
        );
      },
    );
  }

  Widget _buildBody(StrukturViewModel viewModel, List<StrukturModel.Data> filteredList) {
    if (viewModel.isLoading && viewModel.strukturList.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF4A4E8A)));
    }

    if (filteredList.isEmpty) {
      return const Center(child: Text('Tidak ada data keanggotaan.', style: TextStyle(color: Colors.grey)));
    }

    return RefreshIndicator(
      color: const Color(0xFFFFC212),
      onRefresh: () async => await viewModel.synchronizeStruktur(),
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 25.0, left: 16.0, right: 16.0, bottom: 80.0),
        itemCount: filteredList.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final member = filteredList[index];
          final itemKey = GlobalKey<_SlidableListItemState>();

          return _SlidableListItem(
            key: itemKey,
            title: member.nama ?? '-',
            subtitle: member.jabatan?.namaJabatan ?? 'Warga',
            foto: member.foto,
            onDelete: () => _deleteMember(member),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => AdminIdentitasPejabatPage(dataPejabat: member)));
            },
            onItemOpen: _handleItemOpen,
            onItemClose: _handleItemClose,
          );
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return SizedBox(
      width: 200, height: 50,
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminTambahStrukturPage())),
        backgroundColor: const Color(0xFFFFCC33),
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('Tambah Jabatan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ==========================================================
// WIDGET SLIDABLE LIST ITEM (Hanya Hapus)
// ==========================================================
class _SlidableListItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? foto;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final void Function(GlobalKey<_SlidableListItemState>) onItemOpen;
  final void Function() onItemClose;

  const _SlidableListItem({
    required super.key,
    required this.title,
    required this.subtitle,
    this.foto,
    required this.onDelete,
    required this.onTap,
    required this.onItemOpen,
    required this.onItemClose,
  });

  @override
  State<_SlidableListItem> createState() => _SlidableListItemState();
}

class _SlidableListItemState extends State<_SlidableListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  static const double _actionExtent = 80.0; 

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
    if (mounted) {
      _slideAnimation = Tween(begin: _slideAnimation.value, end: 0.0).animate(_controller);
      _controller.forward(from: 0.0).then((_) {
        if (mounted) widget.onItemClose();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _controller.value.abs() > 0 ? closeItem() : widget.onTap(),
      onHorizontalDragUpdate: (details) {
        setState(() {
          double newOffset = _slideAnimation.value + details.primaryDelta!;
          newOffset = newOffset.clamp(-_actionExtent, 0.0);
          _slideAnimation = Tween(begin: newOffset, end: newOffset).animate(_controller);
        });
      },
      onHorizontalDragEnd: (details) {
        if (_slideAnimation.value.abs() > _actionExtent / 2) {
          _slideAnimation = Tween(begin: _slideAnimation.value, end: -_actionExtent).animate(_controller);
          _controller.forward(from: 0.0).then((_) {
            widget.onItemOpen(widget.key as GlobalKey<_SlidableListItemState>);
          });
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
                  onTap: () {
                    closeItem();
                    widget.onDelete();
                  },
                  child: Container(
                    width: _actionExtent,
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: const Icon(Icons.delete, color: Colors.white),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF4A4E8A).withOpacity(0.1),
                  backgroundImage: (widget.foto != null && widget.foto!.isNotEmpty) ? NetworkImage(widget.foto!) : null,
                  child: (widget.foto == null || widget.foto!.isEmpty) ? const Icon(Icons.person, color: Color(0xFF4A4E8A)) : null,
                ),
                title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(widget.subtitle),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}