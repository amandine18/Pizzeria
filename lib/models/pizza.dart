import 'package:pizzeria/models/option_item.dart';

class Pizza{
  final int id;
  final String title;
  final String garniture;
  final String image;
  final double price;

  int pate = 0;
  int taille = 1;
  int sauce = 0;

  static final List<OptionItem> pates = [
    OptionItem(0, "Pâte fine"),
    OptionItem(1, "Pâte épaisse", supplement: 2),
  ];
  static final List<OptionItem> tailles = [
    OptionItem(0, "Small", supplement: -1),
    OptionItem(1, "Medium"),
    OptionItem(2, "Large", supplement: 2),
    OptionItem(3, "Extra large", supplement: 4),
  ];
  static final List<OptionItem> sauces = [
    OptionItem(0, "Base sauce tomate"),
    OptionItem(1, "Sauce Samourai", supplement: 2),
  ];

  double get total{
    double total = price;

    total += pates[pate].supplement;
    total += tailles[taille].supplement;
    total += sauces[sauce].supplement;

    return total;
  }

  Pizza(this.id, this.title, this.garniture, this.image, this.price);

  //Ajout d'une nouvelle méthode pour créer une copie avec les mêmes options
  Pizza copyWith({int? pate, int? taille, int? sauce}) {
    return Pizza(id, title, garniture, image, price)
      ..pate = pate ?? this.pate
      ..taille = taille ?? this.taille
      ..sauce = sauce ?? this.sauce;
  }

  Pizza.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      garniture = json['garniture'],
      image = json['image'],
      price = (json["price"] as num).toDouble(); // Conversion explicite
  
  //Résout le problème des images
  static String fixUrl(String url) {
    return url.replaceAll('localhost', '10.0.2.2');
  }
  //ajouter un hassCode avec id, pate, taille et sauce
  //Ca n'a pas fonctionné
  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is Pizza &&
  //       other.id == id &&
  //       other.pate == pate &&
  //       other.taille == taille &&
  //       other.sauce == sauce;
  // }

  // @override
  // int get hashCode => id.hashCode ^ pate.hashCode ^ taille.hashCode ^ sauce.hashCode;
}