import 'package:pizzeria/models/pizzas/option_item.dart';

class Boisson{
  final int id;
  final String title;
  final double sucre;
  final String image;
  final double price;
  
  bool hasGlacons = true;
  
  int volume = 0;

  static final List<OptionItem> volumes = [
    OptionItem(0, "33cl"),
    OptionItem(1, "50cl", supplement: 1),
    OptionItem(2, "100cl", supplement: 2),
  ];

  double get total{
    double total = price;

    total += volumes[volume].supplement;

    return total;
  }

  Boisson(this.id, this.title, this.sucre, this.image, this.price);

  //Ajout d'une nouvelle méthode pour créer une copie avec les mêmes options
  Boisson copyWith({int? volume, bool? hasGlacons}) {
    return Boisson(id, title, sucre, image, price)
      ..volume = volume ?? this.volume
      ..hasGlacons = hasGlacons ?? this.hasGlacons;
  }

  Boisson.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      sucre = (json['sucre'] as num).toDouble(),
      image = json['image'],
      price = (json["price"] as num).toDouble(); // Conversion explicite
  
  //Résout le problème des images
  static String fixUrl(String url) {
    return url.replaceAll('localhost', '10.0.2.2');
  }
}