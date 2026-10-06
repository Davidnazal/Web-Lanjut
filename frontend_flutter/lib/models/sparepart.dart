class Sparepart {
  final int? id;
  final String partName;
  final String brand;
  final String category;
  final String compatibleBike;
  final double price;
  final int stock;
  final String? description;
  final String? imageUrl;

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
