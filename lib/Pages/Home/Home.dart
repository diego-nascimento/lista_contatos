import 'dart:io';

import 'package:flutter/material.dart';
import '../../Database/database.dart';
import '../../Model/Contato.dart';
import './Widgets/Card.dart';
import '../Contato/PageContato.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ContactHelper ContatoDB = ContactHelper();

  List<Contato> Contatos = List();


  @override
  void initState() {
    super.initState();
    _ListarContatos();

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContatoPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          itemCount: Contatos.length,
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index){
            return _CreateCard(context, index);
          }
      )
    );
  }

  Widget _CreateCard(BuildContext context, int index){
    return GestureDetector(
      child: ContatoCard(index, Contatos),
      onTap: (){
        _Opcoes(context, index);
      },
    );
  }

  void _Opcoes(BuildContext context,int index) {
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){

                      },
                      child: Text("Ligar",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: (){

                      },
                      child: Text("Editar",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: (){

                      },
                      child: Text("Excluir",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
    );
  }
  void _showContatoPage({Contato contato}) async{
    final recContato = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => PageContato(contato: contato))
    );
    if(recContato !=null){
      if(contato !=null){
        await ContatoDB.updateContato(recContato);
      }else{
        await ContatoDB.SalvarContato(recContato);
      }
      _ListarContatos();
    }
  }

  void _ListarContatos(){
    ContatoDB.ListarContatos().then((list){
      setState(() {
        Contatos = list;
      });
    });
  }
}
