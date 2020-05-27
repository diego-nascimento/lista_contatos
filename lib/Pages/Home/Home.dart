import 'dart:io';

import 'package:flutter/material.dart';
import '../../Database/database.dart';
import '../../Model/Contato.dart';
import './Widgets/Card.dart';
import '../Contato/PageContato.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

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
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context){
              return <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem(
                    child: Text("Ordernar de A-Z"),
                    value: OrderOptions.orderaz
                ),
                const PopupMenuItem(
                    child: Text("Ordernar de Z-A"),
                    value: OrderOptions.orderza
                )
              ];
            },
            onSelected: _OrderList,
          )
        ],
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
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: (){
                          launch("tel: ${Contatos[index].phone}");
                          Navigator.pop(context);
                        },
                        child: Text("Ligar",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                          _showContatoPage(contato: Contatos[index]);
                        },
                        child: Text("Editar",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: (){
                          ContatoDB.deleteContato(Contatos[index].id);
                          setState(() {
                            Contatos.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Excluir",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20
                          ),
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

  void _OrderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        Contatos.sort((a, b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        Contatos.sort((a, b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }
}
