import 'dart:io';
import 'package:flutter/material.dart';
import '../../../Model/Contato.dart';


Widget ContatoCard(int index, List Contatos){
  return Card(
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit:BoxFit.cover,
                    image: Contatos[index].img != null
                        ?FileImage(File(Contatos[index].img)):
                    AssetImage("images/images.png")
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Contatos[index].name ?? "",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(Contatos[index].email ?? "",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal
                  ),
                ),
                Text(Contatos[index].phone ?? "",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}