import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/sparepart.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern('id');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanText.isEmpty) {
      return const TextEditingValue();
    }

    int value = int.parse(cleanText);
    String newText = _formatter.format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class FormScreen extends StatefulWidget {
  final Sparepart? sparepart; // If null = Add mode, If not null = Edit mode

  const FormScreen({super.key, this.sparepart});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numFormatter = NumberFormat.decimalPattern('id');

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _bikeController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descController;
  late TextEditingController _imageController;

  String _selectedCategory = 'Knalpot';
  final List<String> _categories = ['Knalpot', 'Pengereman', 'Ban & Velg', 'Mesin', 'Aksesoris'];

  bool _isSaving = false;
  String? _serverError;

  bool get isEdit => widget.sparepart != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sparepart?.partName ?? '');
    _brandController = TextEditingController(text: widget.sparepart?.brand ?? '');
    _bikeController = TextEditingController(text: widget.sparepart?.compatibleBike ?? 'Yamaha Vixion Old Gen 2 (2011)');
    _priceController = TextEditingController(
      text: widget.sparepart?.price != null ? _numFormatter.format(widget.sparepart!.price.toInt()) : '',
    );
    _stockController = TextEditingController(text: widget.sparepart?.stock != null ? widget.sparepart!.stock.toString() : '');
    _descController = TextEditingController(text: widget.sparepart?.description ?? '');
    _imageController = TextEditingController(text: widget.sparepart?.imageUrl ?? '');

    if (widget.sparepart != null && _categories.contains(widget.sparepart!.category)) {
      _selectedCategory = widget.sparepart!.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _bikeController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _serverError = null;
    });

    String cleanPrice = _priceController.text.replaceAll('.', '').replaceAll(',', '').trim();

    final newPart = Sparepart(
      id: widget.sparepart?.id,
      partName: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      category: _selectedCategory,
      compatibleBike: _bikeController.text.trim(),
      price: double.parse(cleanPrice),
      stock: int.parse(_stockController.text.trim()),
      description: _descController.text.trim(),
      imageUrl: _imageController.text.trim(),
    );

    try {
      if (isEdit) {
        await ApiService.updateSparepart(widget.sparepart!.id!, newPart);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sparepart berhasil diperbarui!')),
          );
        }
      } else {
        await ApiService.createSparepart(newPart);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sparepart baru berhasil ditambahkan!')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _serverError = e.toString().replaceAll('Exception: ', '');
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Data Sparepart' : 'Tambah Sparepart Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_serverError != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _serverError!,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

              // Part Name
              const Text('Nama Sparepart *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'e.g. Master Rem Daytona 17mm'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Nama sparepart tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Brand & Category Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Brand / Merk *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _brandController,
                          decoration: const InputDecoration(hintText: 'e.g. Daytona, RCB'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Brand wajib diisi' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Kategori *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(),
                          items: _categories.map((cat) {
                            return DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13)));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Compatible Bike
              const Text('Kesesuaian Motor *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _bikeController,
                decoration: const InputDecoration(hintText: 'e.g. Yamaha Vixion Old Gen 2 (2011)'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Kesesuaian motor tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Price & Stock Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Harga (Rp) *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            ThousandsSeparatorInputFormatter(),
                          ],
                          decoration: const InputDecoration(hintText: '1.250.000', prefixText: 'Rp '),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Harga wajib diisi';
                            String clean = val.replaceAll('.', '').replaceAll(',', '').trim();
                            if (double.tryParse(clean) == null) return 'Harga harus angka';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Stok Unit *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(hintText: '10'),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Stok wajib diisi';
                            if (int.tryParse(val.trim()) == null) return 'Stok harus angka bulat';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Image URL Field
              const Text('URL Gambar Produk (Optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(hintText: 'https://link-gambar.com/foto.jpg'),
              ),
              const SizedBox(height: 16),

              // Description
              const Text('Deskripsi Spesifikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Jelaskan material, performa, atau catatan teknis lainnya...',
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isSaving ? null : _saveData,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEdit ? 'Perbarui Data Sparepart' : 'Simpan Data Sparepart Baru',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
