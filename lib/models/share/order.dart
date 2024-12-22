import 'package:pizzeria/models/share/cart.dart';

class Order {
  final List<CartItem> items; // Contient les éléments de la commande
  final String deliveryType; // Ex : 'Sur place', 'A emporter'
  final String paymentMethod; // Ex : 'Carte de crédit', 'PayPal'

  Order({
    required this.items,
    required this.deliveryType,
    required this.paymentMethod,
  });
}