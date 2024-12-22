import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pizzeria/models/boissons/boisson.dart';

class BoissonsService {
  //URL de base pour l'appel, ici 10.0.2.2 représente le localhost
  static const String url = 'http://10.0.2.2/api/';

  Future<List<Boisson>> fetchBoissons() async {
    List<Boisson> list = [];

    try {
      //Appel http bloquant
      final response = await http.get(Uri.parse('${url}boissons'));

      if (response.statusCode == 200) {
        // var json = jsonDecode(response.body):
        //  --> problèmes avec les accents

        //Décodage des accents : utf8.decode
        var json = jsonDecode(utf8.decode(response.bodyBytes));
        
        for (final value in json) {
          //Création de l'objet pizza avec le JSON : Pizza.fromJson(json)
          //Puis ajout dans la liste
          list.add(Boisson.fromJson(value));
        }
      } else {
        throw Exception('Impossible de récupérer les boissons');
      }
    } catch (e) {
      throw e;
    }
    return list;
  }

}