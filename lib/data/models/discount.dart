class Discount {
  final int? id;
  final String title;
  final String description;
  final double percentage;
  final String categoryId;
  final String storeName;
  final String imageUrl;
  final String? couponCode;
  final DateTime expirationDate;
  final bool isFavorite;
  final DateTime createdAt;

  Discount({
    this.id,
    required this.title,
    required this.description,
    required this.percentage,
    required this.categoryId,
    required this.storeName,
    required this.imageUrl,
    this.couponCode,
    required this.expirationDate,
    this.isFavorite = false,
    required this.createdAt,
  });

  // Crea una copia del objeto cambiando solo los campos necesarios
  Discount copyWith({
    int? id,
    String? title,
    String? description,
    double? percentage,
    String? categoryId,
    String? storeName,
    String? imageUrl,
    String? couponCode,
    DateTime? expirationDate,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Discount(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      percentage: percentage ?? this.percentage,
      categoryId: categoryId ?? this.categoryId,
      storeName: storeName ?? this.storeName,
      imageUrl: imageUrl ?? this.imageUrl,
      couponCode: couponCode ?? this.couponCode,
      expirationDate: expirationDate ?? this.expirationDate,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convierte el objeto a un Map para guardar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'percentage': percentage,
      'category_id': categoryId,
      'store_name': storeName,
      'image_url': imageUrl,
      'coupon_code': couponCode,
      'expiration_date': expirationDate.toIso8601String(),
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Crea un objeto Discount desde un Map (proveniente de la base de datos)
  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      percentage: (map['percentage'] as num).toDouble(),
      categoryId: map['category_id'] as String,
      storeName: map['store_name'] as String,
      imageUrl: map['image_url'] as String,
      couponCode: map['coupon_code'] as String?,
      expirationDate: DateTime.parse(map['expiration_date'] as String),
      isFavorite: map['is_favorite'] == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Comparación de objetos por ID
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Discount && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Representación en texto del objeto
  @override
  String toString() =>
      'Discount(id: $id, title: $title, percentage: $percentage)';
}
