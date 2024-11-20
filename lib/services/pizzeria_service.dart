import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pizza.dart';

class PizzeriaService {
  //URL de base pour l'appel, ici 127.0.0.1 représente le localhost
  static const String url = 'http://10.0.2.2/api/';

  Future<List<Pizza>> fetchPizzas() async {
    List<Pizza> list = [];

    try {
      //Appel http bloquant
      final response = await http.get(Uri.parse('${url}pizzas'));

      if (response.statusCode == 200) {
        // var json = jsonDecode(response.body):
        //  --> problèmes avec les accents
        //Décodage des accents : utf8.decode
        var json = jsonDecode(utf8.decode(response.bodyBytes));
        for (final value in json) {
          //Création de l'objet pizza avec le JSON : Pizza.fromJson(json)
          //Puis ajout dans la liste
          list.add(Pizza.fromJson(value));
        }
      } else {
        throw Exception('Impossible de récupérer les pizzas');
      }
    } catch (e) {
        throw e;
    }
    return list;
  }

}