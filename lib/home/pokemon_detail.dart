import 'package:flutter/material.dart';

class PokemonDetail extends StatelessWidget {
  final Map<String, dynamic> data;

  const PokemonDetail({Key? key, required this.data}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
      ),
      body: SafeArea(
        child: Image.network(data['image2'])
        ),
    );
  }
}
