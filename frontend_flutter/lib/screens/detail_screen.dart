import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sparepart.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'form_screen.dart';

class DetailScreen extends StatefulWidget {
  final int sparepartId;

  const DetailScreen({super.key, required this.sparepartId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  Sparepart? _sparepart;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final item = await ApiService.getSparepartById(widget.sparepartId);
      setState(() {
        _sparepart = item;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem() async {
    if (_sparepart == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Sparepart?'),
        content: Text('Apakah Anda yakin ingin menghapus "${_sparepart!.partName}"?'),
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

    if (confirm == true) {
      try {
        await ApiService.deleteSparepart(_sparepart!.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sparepart berhasil dihapus')),
          );
          Navigator.pop(context, true);
        }
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
        title: const Text('Detail Sparepart'),
        actions: [
          if (_sparepart != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppTheme.secondaryColor),
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormScreen(sparepart: _sparepart)),
                );
                if (updated == true) _fetchDetail();
              },
            ),
        ],
      ),
      body: _isLoading
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
                        Text(_errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchDetail,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : _sparepart == null
                  ? const Center(child: Text('Data tidak ditemukan'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Hero Card Header with Network Image
                          Container(
                            height: 220,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.borderColor),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: (_sparepart!.imageUrl != null && _sparepart!.imageUrl!.trim().isNotEmpty)
                                  ? Image.network(
                                      _sparepart!.imageUrl!.trim(),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => _buildIconFallback(),
                                    )
                                  : _buildIconFallback(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Title & Badges
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _sparepart!.category,
                                  style: const TextStyle(
                                    color: AppTheme.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _sparepart!.stock > 0 ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _sparepart!.stock > 0 ? 'Stok Tersedia: ${_sparepart!.stock}' : 'Stok Habis',
                                  style: TextStyle(
                                    color: _sparepart!.stock > 0 ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Text(
                            _sparepart!.partName,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),

                          Text(
                            currencyFormatter.format(_sparepart!.price),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Specs Grid Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Spesifikasi Sparepart',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const Divider(height: 20),
                                  _buildSpecRow(Icons.two_wheeler, 'Kesesuaian Motor', _sparepart!.compatibleBike),
                                  _buildSpecRow(Icons.branding_watermark, 'Brand / Merk', _sparepart!.brand),
                                  _buildSpecRow(Icons.category, 'Kategori', _sparepart!.category),
                                  _buildSpecRow(Icons.inventory_2, 'Jumlah Stok', '${_sparepart!.stock} unit'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Description Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Deskripsi Produk',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    (_sparepart!.description != null && _sparepart!.description!.isNotEmpty)
                                        ? _sparepart!.description!
                                        : 'Tidak ada deskripsi tambahan.',
                                    style: const TextStyle(color: AppTheme.textDark, height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    side: const BorderSide(color: AppTheme.secondaryColor),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () async {
                                    final updated = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FormScreen(sparepart: _sparepart)),
                                    );
                                    if (updated == true) _fetchDetail();
                                  },
                                  icon: const Icon(Icons.edit, color: AppTheme.secondaryColor),
                                  label: const Text('Edit Part', style: TextStyle(color: AppTheme.secondaryColor)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: _deleteItem,
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  label: const Text('Hapus Part', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildIconFallback() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(_getCategoryIcon(_sparepart!.category), size: 72, color: AppTheme.primaryColor),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(20)),
          child: Text(
            _sparepart!.brand.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textMuted),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
        ],
      ),
    );
  }

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
