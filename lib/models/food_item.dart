class FoodItem{
  final int id;
  final String name;
  final int price;
  final String image;
  final int orderCount = 0;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
  factory FoodItem.formJson(Map<String, dynamic> json){
    return FoodItem(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        image: json['image'],
    );
  }
}