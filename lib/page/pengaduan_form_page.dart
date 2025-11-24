import 'package:flutter/material.dart';

class FormPengaduanPage extends StatefulWidget {
  const FormPengaduanPage({super.key});

  @override
  State<FormPengaduanPage> createState() => _FormPengaduanPageState();
}

class _FormPengaduanPageState extends State<FormPengaduanPage> {
  String? _selectedKategori;
  final List<String> _kategoriList = ['Infrastruktur', 'Pelayanan', 'Lain-lain'];

  String? _selectedPrioritas;
  final List<String> _prioritasList = ['Rendah', 'Sedang', 'Tinggi'];

  bool _isLaporanPublik = false;

  final TextEditingController _namaLaporanController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();
  final TextEditingController _ditugaskanUntukController = TextEditingController();


  @override
  void dispose() {
    _namaLaporanController.dispose();
    _pesanController.dispose();
    _ditugaskanUntukController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna utama yang digunakan di App Bar dan Tombol
    const Color primaryColor = Color(0xFF4A4E8A);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Form Pengaduan',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Kotak Unggah Foto (Sama persis dengan gambar)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // 2. Kategori (Dropdown)
                const Text('Kategori', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildDropdownField(
                  value: _selectedKategori,
                  hint: 'Pilih kategori...',
                  items: _kategoriList,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedKategori = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // 3. Nama Laporan (TextField)
                const Text('Nama Laporan', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _namaLaporanController,
                  hintText: 'Nama Laporan',
                  maxLines: 1,
                ),
                const SizedBox(height: 20),

                // 4. Pesan (TextField Multiline)
                const Text('Pesan', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _pesanController,
                  hintText: 'Pesan',
                  maxLines: 3, // Multi-line input
                ),
                const SizedBox(height: 20),

                // 5. Ditugaskan untuk (TextField)
                const Text('Ditugaskan untuk', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _ditugaskanUntukController,
                  hintText: 'Ditugaskan untuk',
                  maxLines: 1,
                ),
                const SizedBox(height: 20),

                // 6. Prioritas (Dropdown)
                const Text('Prioritas', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                _buildDropdownField(
                  value: _selectedPrioritas,
                  hint: 'Pilih prioritas...',
                  items: _prioritasList,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPrioritas = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // 7. Laporan Publik (Radio Button dan Teks)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _isLaporanPublik,
                      onChanged: (bool? value) {
                        setState(() {
                          _isLaporanPublik = value!;
                        });
                      },
                      // Sesuaikan warna jika diperlukan
                      activeColor: primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Laporan Publik',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          Text(
                            'Jika opsi Laporan Publik di centang, maka warga lain akan menerima informasi Laporan.',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 8. Tombol Kirim
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Tambahkan logika pengiriman form di sini
                      print('Kirim ditekan');
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text('Kirim', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                const SizedBox(height: 24), // Spacer di bagian bawah
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Helper untuk Teks Field ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none, // Hapus border default
          isDense: true, // Membuat padding internal lebih ketat
        ),
      ),
    );
  }

  // --- Widget Helper untuk Dropdown Field ---
  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}