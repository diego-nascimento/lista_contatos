import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listadecontatos/Model/Contato.dart';
import 'package:image_picker/image_picker.dart';

class PageContato extends StatefulWidget {

  final Contato contato;
  PageContato({this.contato});

  @override
  _PageContatoState createState() => _PageContatoState();
}

class _PageContatoState extends State<PageContato> {

  Contato _editedContato;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool edited = false;
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if(widget.contato == null){
      _editedContato = Contato();
    }else{
      _editedContato = Contato.fromMap(widget.contato.toMap());
      _nameController.text = _editedContato.name;
      _emailController.text = _editedContato.email;
      _phoneController.text = _editedContato.phone;
    }
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: (){
        return _requestPop();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContato.name == null ? "Novo Contato" : _editedContato.name),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              if(_editedContato.name !=null && _editedContato.name.isNotEmpty){
                Navigator.pop(context, _editedContato);
              }else{
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body:SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                      if(file == null){
                        return;
                      }else{
                        setState(() {
                          _editedContato.img = file.path;
                        });
                      }
                    });
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContato.img != null ?
                            FileImage(File(_editedContato.img)):
                            AssetImage("images/images.png")
                        )
                    ),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(
                      labelText: "Nome"
                  ),
                  onChanged: (text){
                    edited = true;
                    setState(() {
                      _editedContato.name = text;
                      if(_editedContato.name == ""){
                        _editedContato.name = null;
                      }
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email"
                  ),
                  onChanged: (text){
                    edited = true;
                    _editedContato.email = text;

                  },
                ),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: "Phone"
                  ),
                  onChanged: (text){
                    edited = true;
                    _editedContato.phone = text;
                  },
                ),
              ],
            ),
          )
      ),
    );


  }
  Future<bool> _requestPop(){
    if(edited){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: <Widget>[
                FlatButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")
                ),
                FlatButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Sim")
                )
              ],
            );
          }
      );
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

}
