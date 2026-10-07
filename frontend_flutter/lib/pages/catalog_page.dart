import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sparepart.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'detail_page.dart';
import 'form_page.dart';

/// Halaman katalog utama [CatalogPage] yang menampilkan seluruh daftar sparepart,
/// pencarian, filter kategori, serta opsi navigasi ke halaman detail & tambah data.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  /// Controller untuk input pencarian teks
  final TextEditingController _searchController = TextEditingController();

  /// Formatter mata uang Rupiah (Rp X.XXX.XXX)
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  /// State daftar sparepart yang dimuat dari API
  List<Sparepart> _spareparts = [];

  /// State indikator loading
  bool _isLoading = true;

  /// State pesan error jaringan / API
  String? _errorMessage;

  /// Kategori aktif yang dipilih pengguna
  String _selectedCategory = 'Semua';

  /// Daftar pilihan kategori sparepart
  final List<String> _categories = ['Semua', 'Knalpot', 'Pengereman', 'Ban & Velg', 'Mesin', 'Aksesoris'];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  /// Mengambil data sparepart dari API backend berdasarkan pencarian dan kategori aktif.
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getSpareparts(
        search: _searchController.text.trim(),
        category: _selectedCategory,
      );
      setState(() {
        _spareparts = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  /// Menampilkan dialog penyesuaian Base URL backend secara dinamis.
  void _showChangeBaseUrlDialog() {
    TextEditingController urlController = TextEditingController(text: ApiService.baseUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setting Base URL Backend'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan URL REST API Backend Laravel:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                hintText: 'https://nama-app.onrender.com/api',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Emulator Android: http://10.0.2.2:8000/api\n• Browser: http://127.0.0.1:8000/api\n• Online Live: https://vixion-mods.onrender.com/api',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            onPressed: () {
              if (urlController.text.trim().isNotEmpty) {
                setState(() {
                  ApiService.baseUrl = urlController.text.trim();
                });
                Navigator.pop(context);
                _fetchData();
              }
            },
            child: const Text('Simpan URL', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Menghapus item sparepart [part] setelah konfirmasi dialog.
  Future<void> _deleteItem(Sparepart part) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Sparepart?'),
        content: Text('Apakah Anda yakin ingin menghapus "${part.partName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && part.id != null) {
      try {
        await ApiService.deleteSparepart(part.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sparepart berhasil dihapus')),
          );
        }
        _fetchData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/logo.png',
                height: 32,
                width: 32,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.build_rounded, color: AppTheme.primaryColor, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text('MyParts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_ethernet_rounded, color: AppTheme.primaryColor),
            tooltip: 'Ubah Base URL Backend',
            onPressed: _showChangeBaseUrlDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Input Teks Pencarian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _fetchData(),
              decoration: InputDecoration(
                hintText: 'Cari Aeromax, RCB, VND, B-Pro...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          _fetchData();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Chips Filter Kategori
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor,
                    backgroundColor: AppTheme.surfaceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                      _fetchData();
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Daftar Item Katalog Sparepart
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchData,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                                const SizedBox(height: 12),
                                Text(
                                  'Gagal Terhubung ke Backend:\n$_errorMessage',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                                  onPressed: _fetchData,
                                  icon: const Icon(Icons.refresh, color: Colors.white),
                                  label: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                                ),
                                TextButton(
                                  onPressed: _showChangeBaseUrlDialog,
                                  child: const Text('Ubah Base URL Backend'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _spareparts.isEmpty
                          ? const Center(
                              child: Text('Tidak ada sparepart ditemukan.', style: TextStyle(color: AppTheme.textMuted)),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              itemCount: _spareparts.length,
                              itemBuilder: (context, index) {
                                final item = _spareparts[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () async {
                                      final updated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPage(sparepartId: item.id!),
                                        ),
                                      );
                                      if (updated == true) _fetchData();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          // Kontainer Gambar Thumbnail
                                          Container(
                                            width: 75,
                                            height: 75,
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor.withValues(alpha: 0.08),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: (item.imageUrl != null && item.imageUrl!.trim().isNotEmpty)
                                                  ? Image.network(
                                                      item.imageUrl!.trim(),
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) => Center(
                                                        child: Icon(
                                                          _getCategoryIcon(item.category),
                                                          color: AppTheme.primaryColor,
                                                          size: 32,
                                                        ),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Icon(
                                                        _getCategoryIcon(item.category),
                                                        color: AppTheme.primaryColor,
                                                        size: 32,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),

                                          // Detail Teks Sparepart
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        item.brand.toUpperCase(),
                                                        style: const TextStyle(
                                                          color: AppTheme.secondaryColor,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      'Stok: ${item.stock}',
                                                      style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  item.partName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: AppTheme.textDark,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  item.compatibleBike,
                                                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  currencyFormatter.format(item.price),
                                                  style: const TextStyle(
                                                    color: AppTheme.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Tombol Aksi Edit & Hapus
                                          Column(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit_outlined, size: 20, color: AppTheme.secondaryColor),
                                                onPressed: () async {
                                                  final updated = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => FormPage(sparepart: item),
                                                    ),
                                                  );
                                                  if (updated == true) _fetchData();
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                                                onPressed: () => _deleteItem(item),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),

      // Tombol Melayang Tambah Part Baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormPage()),
          );
          if (created == true) _fetchData();
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Part'),
      ),
    );
  }

  /// Menentukan ikon visual berdasarkan kategori sparepart.
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'knalpot':
        return Icons.speed;
      case 'pengereman':
        return Icons.disc_full;
      case 'ban & velg':
        return Icons.album;
      case 'mesin':
        return Icons.build;
      default:
        return Icons.settings;
    }
  }
}
