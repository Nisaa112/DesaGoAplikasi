import 'package:desa_go_aplikasi/models/warga_model.dart' as Warga;
import 'package:desa_go_aplikasi/page/admin_tambah_warga_page.dart';
import 'package:desa_go_aplikasi/page/admin_identitas_warga_page.dart';
import 'package:desa_go_aplikasi/viewmodel/warga_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminInfoWargaPage extends StatefulWidget {
  const AdminInfoWargaPage({super.key});

  @override
  State<AdminInfoWargaPage> createState() => _AdminInfoWargaPageState();
}

class _AdminInfoWargaPageState extends State<AdminInfoWargaPage> {
  // Key unik untuk mengontrol item mana yang sedang terbuka
  GlobalKey<_SlidableListItemState>? _currentlyOpenItemKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WargaViewModel>(context, listen: false).loadWarga();
    });
  }

  // Fungsi untuk konfirmasi dan penghapusan
  Future<bool> _confirmAndDelete(Warga.Data warga) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Warga'),
          content: Text('Anda yakin ingin menghapus data warga ${warga.nama}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        if (!mounted) return false;
        final viewModel = Provider.of<WargaViewModel>(context, listen: false);
        if (warga.id == null) {
          _showSnackbar('ID Warga tidak ditemukan.', Colors.red);
          return false;
        }
        await viewModel.deleteWarga(warga.id!);
        _showSnackbar('Warga ${warga.nama} berhasil dihapus.', const Color(0xFF5CB85C));
        return true; 
      } catch (e) {
        _showSnackbar('Gagal menghapus warga: ${e.toString().split(':').last.trim()}', Colors.red);
        return false; 
      }
    }
    return false;
  }

  // Navigasi ke halaman Edit
  void _navigateToEditPage(Warga.Data warga) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminIdentitasWargaPage(warga: warga),
      ),
    ).then((_) {
      // Refresh data setelah kembali dari halaman edit
      Provider.of<WargaViewModel>(context, listen: false).loadWarga();
    });
  }

  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  // Fungsi dipanggil oleh item anak ketika item lain dibuka
  void _handleItemOpen(GlobalKey<_SlidableListItemState> key) {
    if (_currentlyOpenItemKey != null && _currentlyOpenItemKey != key) {
      // Tutup item yang sebelumnya terbuka
      _currentlyOpenItemKey?.currentState?.closeItem();
    }
    _currentlyOpenItemKey = key;
  }
  
  // Fungsi dipanggil oleh item anak ketika item ditutup
  void _handleItemClose() {
    _currentlyOpenItemKey = null;
  }


  @override
  Widget build(BuildContext context) {
    final wargaViewModel = Provider.of<WargaViewModel>(context);
    const Color primaryColor = Color(0xFF4A4E8A);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Warga Desa (Admin)',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      floatingActionButton: SizedBox(
        width: 200, 
        height: 50, 
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminTambahWargaPage(),
              ),
            ).then((_) {
              Provider.of<WargaViewModel>(context, listen: false).loadWarga();
            });
          },
          backgroundColor: const Color(0xFFFFCC33), 
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          icon: const Icon(Icons.add, color: Colors.black),
          label: const Text(
            'Tambah Warga',
            style: TextStyle(
              color: Colors.black, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      body: Container(
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
          child: _buildBody(wargaViewModel),
        ),
      ),
    );
  }

  Widget _buildBody(WargaViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (viewModel.errorMessage != null && viewModel.errorMessage!.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gagal memuat data: ${viewModel.errorMessage}', textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                viewModel.loadWarga();
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    } else if (viewModel.listWarga.isEmpty) {
      return const Center(child: Text('Tidak ada data Warga.'));
    } else {
      return RefreshIndicator(
        color: const Color(0xFFFFC212),
        backgroundColor: Colors.white,
        onRefresh: () async {
          await viewModel.loadWarga();
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 80.0),
            itemCount: viewModel.listWarga.length,
            itemBuilder: (context, index) {
              final Warga.Data warga = viewModel.listWarga[index];
              
              // >>> MENGGUNAKAN WIDGET SLIDABLE KUSTOM <<<
              final itemKey = GlobalKey<_SlidableListItemState>(); 
              
              return _SlidableListItem(
                key: itemKey,
                warga: warga,
                onEdit: _navigateToEditPage,
                
                // PERBAIKAN: Closure onDelete sekarang mengembalikan Future<bool>
                onDelete: (w) async {
                  final result = await _confirmAndDelete(w);
                  // Jika berhasil dihapus, muat ulang data untuk menghilangkan item
                  if (result) {
                    viewModel.loadWarga();
                  } else {
                    // Jika dibatalkan/gagal, tutup kembali slidable
                    itemKey.currentState?.closeItem();
                  }
                  return result; // Mengembalikan hasil bool
                },

                onItemOpen: _handleItemOpen,
                onItemClose: _handleItemClose,
              );
              // >>> SELESAI MENGGUNAKAN WIDGET SLIDABLE KUSTOM <<<
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 1, indent: 8, endIndent: 8);
            },
          ),
        ),
      );
    }
  }
}

// =========================================================================
// WIDGET KUSTOM: _SlidableListItem
// =========================================================================

class _SlidableListItem extends StatefulWidget {
  final Warga.Data warga;
  final void Function(Warga.Data) onEdit;
  // PERBAIKAN: onDelete sekarang mengembalikan Future<bool>
  final Future<bool> Function(Warga.Data) onDelete; 
  final void Function(GlobalKey<_SlidableListItemState>) onItemOpen;
  final void Function() onItemClose;

  const _SlidableListItem({
    required super.key, 
    required this.warga, 
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

  // Lebar menu aksi (Edit + Hapus). Misalnya 70px per tombol.
  static const double _actionExtent = 140.0; 
  // Batas swipe minimum agar item tetap terbuka setelah dilepas
  static const double _openThreshold = _actionExtent / 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween(begin: 0.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    // Pastikan menutup slidable yang terbuka sebelum dispose
    if (_controller.value.abs() > 0) {
        widget.onItemClose();
    }
    _controller.dispose();
    super.dispose();
  }
  
  // Metode publik untuk menutup item dari luar
  void closeItem() {
    if (_controller.value.abs() > 0) {
      // Pastikan animasi dimulai dari posisi saat ini
      _slideAnimation = Tween(begin: _slideAnimation.value, end: 0.0).animate(_controller);
      _controller.forward(from: 0.0).then((_) {
        // Setelah animasi selesai, reset controller dan panggil callback close
        _slideAnimation = Tween(begin: 0.0, end: 0.0).animate(_controller);
        widget.onItemClose();
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Hanya izinkan geser ke kiri (nilai negatif)
      double newOffset = _slideAnimation.value + details.primaryDelta!;
      newOffset = newOffset.clamp(-_actionExtent, 0.0);
      
      // Update Tween/Animation agar posisi visual berubah saat drag
      _slideAnimation = Tween(begin: newOffset, end: newOffset).animate(_controller);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final double currentOffset = _slideAnimation.value;

    if (currentOffset.abs() > _openThreshold) {
      // Buka menu (geser ke -_actionExtent)
      _slideAnimation = Tween(begin: currentOffset, end: -_actionExtent).animate(_controller);
      _controller.forward(from: 0.0).then((_) {
        widget.onItemOpen(widget.key as GlobalKey<_SlidableListItemState>);
      });
    } else {
      // Tutup menu (geser kembali ke 0)
      _slideAnimation = Tween(begin: currentOffset, end: 0.0).animate(_controller);
      _controller.forward(from: 0.0).then((_) {
        widget.onItemClose();
      });
    }
  }

  void _handleTap() {
    if (_controller.value.abs() > 0) {
      // Jika menu terbuka, tutup saat diklik
      closeItem();
    } else {
      // Jika menu tertutup, jalankan aksi default (Edit/Detail)
      widget.onEdit(widget.warga);
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: <Widget>[
          // Latar Belakang: Tombol Aksi (Edit & Hapus)
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Tombol Edit
                InkWell(
                  onTap: () {
                    closeItem();
                    widget.onEdit(widget.warga);
                  },
                  child: Container(
                    width: _actionExtent / 2, // 70px
                    color: const Color(0xFF4A4E8A), // Biru
                    alignment: Alignment.center,
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                ),
                // Tombol Hapus
                InkWell(
                  onTap: () async {
                    // Panggil onDelete yang akan menjalankan konfirmasi dan penghapusan.
                    // closeItem() dipanggil di parent tergantung hasil penghapusan.
                    await widget.onDelete(widget.warga);
                  },
                  child: Container(
                    width: _actionExtent / 2, // 70px
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          
          // Konten Utama (ListTile) yang akan digeser
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                // Menggunakan _slideAnimation.value (akan bernilai antara 0 hingga -140)
                offset: Offset(_slideAnimation.value, 0),
                child: child,
              );
            },
            child: Container(
              color: Colors.white, // Penting agar background tidak tembus
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                title: Text(
                  widget.warga.nama ?? 'Nama tidak tersedia',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                subtitle: Text(
                  widget.warga.alamat ?? 'Alamat tidak tersedia',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                // onTap dihandle oleh GestureDetector _handleTap
              ),
            ),
          ),
        ],
      ),
    );
  }
}