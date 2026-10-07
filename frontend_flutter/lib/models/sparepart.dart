/// Model data [Sparepart] mewakili entitas sparepart motor
/// yang dikonsumsi dari Laravel REST API backend.
class Sparepart {
  /// ID unik sparepart (diberikan oleh database)
  final int? id;

  /// Nama sparepart / barang
  final String partName;

  /// Merk atau brand pembuat
  final String brand;

  /// Kategori sparepart (contoh: Knalpot, Pengereman, Mesin, dll)
  final String category;

  /// Jenis motor yang cocok / kompatibel
  final String compatibleBike;

  /// Harga sparepart dalam Rupiah
  final double price;

  /// Jumlah stok unit yang tersedia
  final int stock;

  /// Deskripsi rinci spesifikasi sparepart
  final String? description;

  /// URL opsional gambar produk
  final String? imageUrl;

  /// Konstruktor utama untuk menginisialisasi objek [Sparepart].
  Sparepart({
    this.id,
    required this.partName,
    required this.brand,
    required this.category,
    required this.compatibleBike,
    required this.price,
    required this.stock,
    this.description,
    this.imageUrl,
  });

  /// Membuat instance [Sparepart] dari struktur Map JSON.
  factory Sparepart.fromJson(Map<String, dynamic> json) {
    return Sparepart(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      partName: json['part_name'] ?? '',
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
      compatibleBike: json['compatible_bike'] ?? 'Yamaha Vixion Old Gen 2 (2011)',
      price: double.parse((json['price'] ?? 0).toString()),
      stock: int.parse((json['stock'] ?? 0).toString()),
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }

  /// Mengonversi instance [Sparepart] menjadi objek Map JSON
  /// untuk dikirimkan dalam payload HTTP Request ke backend.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'part_name': partName,
      'brand': brand,
      'category': category,
      'compatible_bike': compatibleBike,
      'price': price,
      'stock': stock,
      'description': description ?? '',
      'image_url': imageUrl ?? '',
    };
  }
}
