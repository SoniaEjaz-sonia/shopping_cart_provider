class CartTotalModel {
  final int? id;
  final int? itemCount;
  final double? cartTotal;

  CartTotalModel({
    required this.id,
    required this.itemCount,
    required this.cartTotal,
  });

  CartTotalModel.fromJson(Map<dynamic, dynamic> res)
      : id = res['id'],
        itemCount = res['itemCount'],
        cartTotal = res['cartTotal'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'itemCount': itemCount,
      'cartTotal': cartTotal,
    };
  }
}
