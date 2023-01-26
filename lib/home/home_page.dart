import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nego/menu/menu_page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:io';
import 'package:nego/home/pokemon_detail.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _SearchPokemon();
}

class _SearchPokemon extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _listPokemonData = [];
  List<Map<String, String>> _filteredPokemons = [];
  List<dynamic> _listPokemonsUrl = [];
  String _searchTerm = '';

  String _urlSprite = "";
  String _name = "";
  String _height = "";
  String _baseExperience = "";
  String _weight = "";
  String _urlSprite2 = "";

  Future<void> _getData() async {
    var client = HttpClient();
    var request = await client
        .getUrl(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=200"));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    var jsonResponse = jsonDecode(responseBody);

    _listPokemonsUrl = jsonResponse['results'];

    for (var item in _listPokemonsUrl) {
      _getDataPokemons(item['url']);
    }
  }

  Future<void> _getDataPokemons(url) async {
    var client = HttpClient();
    var request = await client.getUrl(Uri.parse(url));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    var jsonResponse = jsonDecode(responseBody);

    _urlSprite = jsonResponse['sprites']['front_default'];
    _urlSprite2 = jsonResponse['sprites']['front_shiny'];
    _name = jsonResponse['name'];
    _height = jsonResponse['height'].toString();
    _weight = jsonResponse['weight'].toString();
    _baseExperience = jsonResponse['base_experience'].toString();

    _listPokemonData.add({
      'name': _name,
      'image': _urlSprite,
      'image2': _urlSprite2,
      'height': _height,
      'weight': _weight,
      'base_experience': _baseExperience
    });


  }

  void _filterList() {
    _filteredPokemons = _listPokemonData.where((name) {
      return name['name']
          .toString()
          .toLowerCase()
          .contains(_searchTerm.toLowerCase());
    }).toList();

  }

  @override
  void initState() {
    super.initState();
    _getData();

  }

  Widget _buildText() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _controller,
          decoration:
              const InputDecoration.collapsed(hintText: 'Buscar pokemon'),
          autofocus: false,
          onChanged: (value) {
            setState(() {
              _searchTerm = value;
              _filterList();
            });
          },
        )),
        ButtonBar(
          children: [
            IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(Icons.search),
            )
          ],
        )
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuScreen()),
                );
              },
              icon: const Icon(Icons.menu))
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
            ),
            child: _buildText(),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _filteredPokemons.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PokemonDetail(
                                        data: _filteredPokemons[index],
                                      )));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(_filteredPokemons[index]['name']!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Image.network(
                                            _filteredPokemons[index]['image']!)
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            " ${_filteredPokemons[index]['name']!} Pro"),
                                        Image.network(
                                            _filteredPokemons[index]['image2']!)
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            "Peso : ${_filteredPokemons[index]['weight']!}"),
                                        Text(
                                            "Altura : ${_filteredPokemons[index]['height']!}"),
                                        Text(
                                            "Exp : ${_filteredPokemons[index]['base_experience']!}"),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ));
                  }))
        ]),
      ),
    );
  }
}
