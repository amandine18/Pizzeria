import 'package:flutter/material.dart';
import 'package:pizzeria/services/pizzeria_service.dart';
import 'package:pizzeria/ui/pizzas/pizza_details.dart';
import 'package:pizzeria/ui/share/buy_button_widget.dart';
import 'package:pizzeria/ui/share/pizzeria_style.dart';

import '../../models/share/cart.dart';
import '../../models/pizzas/pizza.dart';
import '../share/bottom_navigation_bar_widget.dart';
import '../share/appbar_widget.dart';

class PizzaList extends StatefulWidget {
  final Cart _cart;
  const PizzaList(this._cart, {super.key});

  @override
  State<PizzaList> createState() => _PizzaListState();
}

class _PizzaListState extends State<PizzaList> {
  final String title = 'Nos Pizzas';

  late Future<List<Pizza>> _pizzas;
  final PizzeriaService _service = PizzeriaService();
  final TextEditingController _searchController = TextEditingController();

  List<Pizza> _filteredPizzas = [];
  List<Pizza> _allPizzas = [];

  @override
  void initState() {
    super.initState();
    _pizzas = _service.fetchPizzas();
    _pizzas.then((pizzas) {
      setState(() {
        _allPizzas = pizzas;
        _filteredPizzas = pizzas;
      });
    });
    _searchController.addListener(_filterPizzas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPizzas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPizzas = List.from(_allPizzas);
      } else {
        _filteredPizzas = _allPizzas.where((pizza) {
          return pizza.title.toLowerCase().contains(query) ||
                 pizza.garniture.toLowerCase().contains(query);
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
                labelText: 'Rechercher une pizza',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterPizzas(); //Réinitialise les pizzas affichées
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
            // child: FutureBuilder<List<Pizza>>(
            //   future: _pizzas, 
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return _buildListView(snapshot.data!);
            //     } else if (snapshot.hasError) {
            //       return Center(
            //         child: Text(
            //           'Impossible de récupérer les données : ${snapshot.error}',
            //           style : PizzeriaStyle.errorTextStyle,
            //         ),
            //       );
            //     }
            //     return const Center(child: CircularProgressIndicator());
            //   },
            // )
            child: _buildListView(_filteredPizzas),
          ),
        ]
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(0, pageNum: 1),
    );
  }
  
  _buildRow(Pizza pizza) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10.0), top: Radius.circular(10.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PizzaDetails(pizza),
                ),
              );
            },
            child: _builPizzaDetails(pizza),
          ),
          // BuyButtonWidget(pizza),
          BuyButtonWidget<Pizza>(pizza)
        ],
      ),
    );
  }

  _builPizzaDetails(Pizza pizza){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(pizza.title),
          subtitle: Text(pizza.garniture),
          leading: const Icon(Icons.local_pizza),
        ),
        Image.network(
            Pizza.fixUrl(pizza.image),
            height: 120,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Text(pizza.garniture),
        ),
      ],
    );
  }

  _buildListView(List<Pizza> pizzas) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: pizzas.length,
      itemBuilder: (context, index){
        return _buildRow(pizzas[index]);
      }
    );
  }

}