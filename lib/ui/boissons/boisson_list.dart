import 'package:flutter/material.dart';
import 'package:pizzeria/models/boissons/boisson.dart';
import 'package:pizzeria/models/share/cart.dart';
import 'package:pizzeria/services/boissons_service.dart';
import 'package:pizzeria/ui/boissons/boisson_details.dart';
import 'package:pizzeria/ui/share/appbar_widget.dart';
import 'package:pizzeria/ui/share/bottom_navigation_bar_widget.dart';
import 'package:pizzeria/ui/share/buy_button_widget.dart';

class BoissonList extends StatefulWidget {
  final Cart _cart;
  const BoissonList(this._cart, {super.key});

  @override
  State<BoissonList> createState() => _BoissonListState();
}

class _BoissonListState extends State<BoissonList> {
  final String title = 'Nos Boissons';

  late Future<List<Boisson>> _boissons;
  final BoissonsService _service = BoissonsService();
  final TextEditingController _searchController = TextEditingController();

  List<Boisson> _filteredBoissons = [];
  List<Boisson> _allBoissons = [];

  @override
  void initState() {
    super.initState();
    _boissons = _service.fetchBoissons(); // Récupère les boissons
    _boissons.then((boissons) {
      setState(() {
        _allBoissons = boissons;
        _filteredBoissons = boissons;
      });
    });
    _searchController.addListener(_filterBoissons);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBoissons() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBoissons = List.from(_allBoissons);
      } else {
        _filteredBoissons = _allBoissons.where((boisson) {
          bool titleMatch = boisson.title.toLowerCase().contains(query);

          // Comparaison du sucre avec la chaîne de recherche convertie en nombre
          bool sucreMatch = boisson.sucre.toString().contains(query); // Conversion de sucre en String ici

          return titleMatch || sucreMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher une boisson',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterBoissons(); // Réinitialise les boissons affichées
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildListView(_filteredBoissons),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(0, pageNum: 1),
    );
  }

  _buildRow(Boisson boisson) {
    return Card(
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     bottom: Radius.circular(5.0), top: Radius.circular(5.0)),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoissonDetails(boisson: boisson),
                ),
              );
            },
            child: _buildBoissonDetails(boisson),
          ),
          BuyButtonWidget<Boisson>(boisson)
        ],
      ),
    );
  }

  _buildBoissonDetails(Boisson boisson) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0), // Arrondi des bords
          child: Image.network(
            Boisson.fixUrl(boisson.image),
            height: 150,
            width: 150, // Vous pouvez ajuster la largeur si nécessaire
            fit: BoxFit.cover, // Pour un meilleur ajustement de l'image
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  boisson.title,
                  style: const TextStyle(fontSize: 18),
                ),
                SizedBox(height: 35.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Teneur en sucre'),
                  ],
                ),
                SizedBox(height: 20.0),
                SliderTheme(
                  data: SliderThemeData(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0), // Pas de curseur visible
                    overlayShape: SliderComponentShape.noOverlay,
                    trackHeight: 8.0,
                    activeTrackColor: _getSliderColor(boisson.sucre), // Couleur dynamique
                    inactiveTrackColor: Colors.grey[300],
                  ),
                  child: Slider(
                    value: boisson.sucre,
                    min: 0,
                    max: 50,
                    divisions: 50,
                    onChanged: (double value) {},
                  ),
                ),
              ],
            ),
          )
        )
      ],
    );
  }

  Color _getSliderColor(double sucreValue) {
    if (sucreValue < 15) {
      return Colors.green;
    } else if (sucreValue < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  _buildListView(List<Boisson> boissons) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: boissons.length,
      itemBuilder: (context, index) {
        return _buildRow(boissons[index]);
      },
    );
  }
}