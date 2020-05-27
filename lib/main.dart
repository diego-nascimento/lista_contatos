import 'package:flutter/material.dart';
import 'Pages/Home/Home.dart';
import 'Pages/Contato/PageContato.dart';
void main(){
  runApp(MaterialApp(
    title: "Lista de Contatos",
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}