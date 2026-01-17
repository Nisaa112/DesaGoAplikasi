import 'package:desa_go_aplikasi/models/user_model.dart';
import 'package:desa_go_aplikasi/page/admin_tambah_user_page.dart';
import 'package:desa_go_aplikasi/viewmodel/auth_viewmodel.dart';
import 'package:desa_go_aplikasi/viewmodel/user_viewmodel.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminManageUserPage extends StatefulWidget {
  const AdminManageUserPage({super.key});

  @override
  State<AdminManageUserPage> createState() => _AdminManageUserPageState();
}

class _AdminManageUserPageState extends State<AdminManageUserPage> {
  GlobalKey<_SlidableListItemState>? _currentlyOpenItemKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserViewModel>(context, listen: false).fetchUsers();
    });
  }

  void _handleItemOpen(GlobalKey<_SlidableListItemState> key) {
    if (_currentlyOpenItemKey != null && _currentlyOpenItemKey != key) {
      _currentlyOpenItemKey?.currentState?.closeItem();
    }
    _currentlyOpenItemKey = key;
  }

  void _handleItemClose() => _currentlyOpenItemKey = null;

  Future<void> _deleteUser(UserDetail user) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: Text('Anda yakin ingin menghapus akun login milik ${user.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await Provider.of<UserViewModel>(context, listen: false).deleteUser(user.id!);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Akun berhasil dihapus'), backgroundColor: Colors.green));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<UserViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context);
    final int? adminRwId = authVM.idRw;

    const Color primaryColor = Color(0xFF4A4E8A);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Manajemen Pengguna', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminTambahUserPage())),
        backgroundColor: const Color(0xFFFFCC33),
        elevation: 0,
        icon: const Icon(Icons.person_add, color: Colors.black),
        label: const Text('Tambah User', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: _buildBody(userVM, adminRwId),
      ),
    );
  }

  Widget _buildBody(UserViewModel viewModel, int? adminRwId) {
    if (viewModel.isLoading && viewModel.users.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF4A4E8A)));
    }

    List<UserDetail> filteredUsers = viewModel.users.where((u) => u.idRw == adminRwId).toList();
    
    if (filteredUsers.isEmpty) {
      return const Center(child: Text('Tidak ada akun pengguna di wilayah RW Anda.', style: TextStyle(color: Colors.grey)));
    }

    return RefreshIndicator(
      onRefresh: () async => await viewModel.fetchUsers(),
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 80),
        itemCount: filteredUsers.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          final itemKey = GlobalKey<_SlidableListItemState>();

          return _SlidableListItem(
            key: itemKey,
            title: user.name ?? '-',
            subtitle: "${user.role?.toUpperCase()} | NIK: ${user.serialNumber}",
            onDelete: () => _deleteUser(user),
            onTap: () {}, // Tidak ada aksi tap/edit sesuai permintaan
            onItemOpen: _handleItemOpen,
            onItemClose: _handleItemClose,
          );
        },
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