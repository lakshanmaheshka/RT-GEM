class Grocery {
  final String? productName;
  final int? quantity;
  final DateTime? expiryDate;
  final DateTime? manufacturedDate;
  final String? category;
  final bool? isConsumed;

  const Grocery(
      {this.productName, this.quantity, this.expiryDate, this.manufacturedDate, this.category, this.isConsumed});

  Map<String, dynamic> toMap(Grocery t) {
    return {
      'productName': t.productName,
      'quantity': t.quantity,
      'expiryDate': t.expiryDate,
      'manufacturedDate': t.manufacturedDate,
      'category': t.category,
      'isConsumed': t.isConsumed,

    };
  }
}