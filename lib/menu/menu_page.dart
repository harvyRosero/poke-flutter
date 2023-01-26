import 'package:flutter/material.dart';


class MenuScreen extends StatefulWidget{
  const MenuScreen({super.key});
  
  @override
  State<MenuScreen> createState() => ListPokemon();
}
  
class ListPokemon extends State<MenuScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu')
        ),
     
    );
  }
}
