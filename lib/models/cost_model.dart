class CostModel {
  final int id;
  final String costName;
  final double costPrice;
  final DateTime costDate;

  CostModel({
    required this.id,
    required this.costName,
    required this.costPrice,
    required this.costDate,
  });

  factory CostModel.fromMap(Map<String, dynamic> map) {
    return CostModel(
      id: map["id"],
      costName: map["costName"],
      costPrice: map["costPrice"],
      costDate: DateTime.parse(map["costDate"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "costName": costName,
      "costPrice": costPrice.toString(),
      "costDate": costDate.toString(),
    };
  }

  CostModel copyWith({
    int? id,
    String? costName,
    double? costPrice,
    DateTime? costDate,
  }) {
    return CostModel(
      id: id ?? this.id,
      costName: costName ?? this.costName,
      costPrice: costPrice ?? this.costPrice,
      costDate: costDate ?? this.costDate,
    );
  }
}
