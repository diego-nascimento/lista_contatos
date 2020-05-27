import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/Contato.dart';

final String contatoTabela = "contato";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contatos.db");

   return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute((
      "CREATE TABLE $contatoTabela("
          "$idColumn INTEGER PRIMARY KEY,"
          " $nameColumn TEXT, "
          "$emailColumn Text,"
          " $phoneColumn TEXT,"
          "$imgColumn TEXT)"
      ));
    });
  }


  Future<Contato>  SalvarContato(Contato contato) async{
    Database dbContato = await db;
    contato.id = await dbContato.insert(contatoTabela, contato.toMap());
    return contato;
  }

  Future<Contato> getContato(int id) async {
    Database dbContato = await db;
    List<Map> maps = await dbContato.query(contatoTabela,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id]
    );

    if(maps.length > 0){
      return Contato.fromMap(maps.first);
    }else {
      return null;
    }
  }

  Future<int> deleteContato(int id)async{
    Database dbContato = await db;
    return await dbContato.delete(contatoTabela,
        where: "$idColumn = ?",
        whereArgs: [id]
    );
  }

  Future<int> updateContato(Contato contato) async {
    Database dbContato = await db;
    return await dbContato.update(contatoTabela,
        contato.toMap(),
        where: "$idColumn = ?",
        whereArgs: [contato.id]
    );
  }

  Future<List> ListarContatos() async {
    Database dbContato = await db;
    List ListMap = await dbContato.rawQuery("SELECT * FROM $contatoTabela");
    List<Contato> ListaContatos = List();
    for(Map m in ListMap){
      ListaContatos.add(Contato.fromMap(m));
    }
    return ListaContatos;
  }

  Future<int> getQuantidade() async{
    Database dbContato = await db;
    return Sqflite.firstIntValue(await
      dbContato.rawQuery("SELECT COUNT(*) FROM $contatoTabela"));
  }

  Future close() async {
    Database dbContato = await db;
    await dbContato.close();
  }

}
