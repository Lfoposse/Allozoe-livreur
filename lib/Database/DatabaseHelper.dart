import 'dart:async';
import 'dart:io' as io;

import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:allozoe_livreur/Models/CommandeNotif.dart';
import 'package:allozoe_livreur/Models/Produit.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "allozoeLivreur.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE Produit("
        "id INTEGER PRIMARY KEY, "
        "prod_id INTEGER UNIQUE, "
        "name TEXT, "
        "description TEXT, "
        "prix REAL, "
        "photo TEXT, "
        "favoris INTEGER, "
        "nbCmds INTEGER "
        ")");
    // create table client where store the connected account informations
    await db.execute("CREATE TABLE Client("
        "id INTEGER PRIMARY KEY, "
        "client_id INTEGER NOT NULL UNIQUE, "
        "username TEXT, "
        "firstname TEXT, "
        "lastname TEXT, "
        "email TEXT NOT NULL, "
        "phone TEXT "
        ")");
    // create table client where store the connected account informations
    await db.execute("CREATE TABLE commande("
        "id INTEGER PRIMARY KEY, "
        "client_id INTEGER, "
        "commande_id INTEGER NOT NULL UNIQUE, "
        "reference TEXT, "
        "client_name TEXT, "
        "delivery_address TEXT,"
        "date TEXT, "
        "hour TEXT, "
        "amount TEXT, "
        "restaurant_id INTEGER "
        ")");
  }

  /// FONCTION TO DEAL WITH THE CLIENT TABLE
  Future<Client> loadClient() async {
    var dbProduit = await db;
    List<Map> list = await dbProduit.rawQuery('SELECT * FROM Client ');
    print("client db :" + list.toString());
    if (list.length == 1) {
      return new Client(list[0]["client_id"], list[0]["username"].toString(),
          list[0]["lastname"].toString(), list[0]["email"].toString());
    }
    return null as Future<Client>;
  }

  ///l= List database tables
  Future<String> listTable() async {
    var tables = await db;
    List<Map> res = await tables.rawQuery("SELECT * FROM Client");
    print("table :" + res.toString());
    return res.toString();
  }

  /// get id livreur
  Future<int> getIdLivreur() async {
    var tables = await db;
    List<Map> list = await tables.rawQuery('SELECT * FROM Client ');
    if (list.length == 1) return list[0]["client_id"];
    return null;
  }

  Future<int> clearClient() async {
    var dbProduit = await db;
    int res = await dbProduit.rawDelete('DELETE FROM Client');
    return res;
  }

  Future<int> savenotif(Commande c) async {
    var dbProduit = await db;
    List<Map> list = await dbProduit.rawQuery(
        'SELECT * FROM  commande where commande_id=' + c.id.toString());
    if (list.length > 0) {
      return -1;
    } else {
      String sql =
          'INSERT INTO commande(client_id,commande_id,restaurant_id,client_name,delivery_address,date,hour,reference) VALUES(' +
              c.client.id.toString() +
              ',' +
              c.id.toString() +
              ',' +
              c.restaurant.id.toString() +
              ',\'null\',\'paris\',\'' +
              c.date.toString() +
              '\',\'' +
              c.heure.toString() +
              '\',\'' +
              c.reference.toString() +
              '\')';
      int res = await dbProduit.rawInsert(sql);
      print("saved notif id = " + sql.toString());
      return 0;
    }
  }

  /// FONCTION TO DEAL WITH THE CLIENT TABLE
  Future<List<CommandeNotif>> loadCommande() async {
    var dbProduit = await db;
    List<Map> list = await dbProduit.rawQuery('SELECT * FROM  commande');
    print("commande in database :" + list.toString());
    List<CommandeNotif> cmd = new List();
    for (int i = 0; i < list.length; i++) {
      var commande = new CommandeNotif(
          list[i]["client_id"],
          list[i]["commance_id"],
          list[i]["restaurant_id"],
          list[i]["client_name"],
          list[i]["reference"],
          list[i]["date"],
          list[i]["amount"],
          list[i]["delivery_address"],
          list[i]["hour"]);
      cmd.add(commande);
    }
    return cmd;
  }

  Future<int> clearNotif() async {
    var dbProduit = await db;
    print("commande vidé");
    int res = await dbProduit.rawDelete('DELETE FROM commande');
    return res;
  }

  Future<int> saveClient(Client c) async {
    var dbProduit = await db;
    String sql =
        'INSERT INTO Client(client_id, username, firstname, lastname,email,phone ) VALUES(' +
            c.id.toString() +
            ',\'' +
            c.username +
            '\',\'' +
            c.lastname +
            '\',\'' +
            c.lastname +
            '\',\'' +
            c.email +
            '\',\'' +
            c.email +
            '\')';
    //int res = await dbProduit.rawInsert(sql);
    print("saved client id = " + sql.toString());
    return 0;
  }

  Future<int> addProduit(Produit produit) async {
    var dbProduit = await db;
    int res = await dbProduit.insert("Produit", produit.toMap());
    return res;
  }

  Future<int> addClient(Client t) async {
    var dbProduit = await db;
    int res = await dbProduit.insert("Client", t.toMap());
    print("client " + t.email + "has add succesful to the database");
    return res;
  }

  Future<List<Produit>> getPanier() async {
    var dbProduit = await db;
    List<Map> list =
        await dbProduit.rawQuery('SELECT * FROM Produit ORDER BY id DESC ');
    List<Produit> panier = new List();
    for (int i = 0; i < list.length; i++) {
      var produit = new Produit(
          list[i]["nbCmds"],
          list[i]["favoris"] == 1,
          list[i]["prod_id"],
          list[i]["name"],
          list[i]["description"],
          list[i]["photo"],
          list[i]["prix"]);
      panier.add(produit);
    }
    return panier;
  }

  Future<List<Client>> getClient() async {
    var dbProduit = await db;
    List<Map> list =
        await dbProduit.rawQuery('SELECT * FROM Client ORDER BY id DESC ');
    List<Client> client = new List();
    for (int i = 0; i < list.length; i++) {
      var c = new Client(list[i]["client_id"], list[i]["username"],
          list[i]["lastname"], list[i]["email"]);
      client.add(c);
    }
    return client;
  }

  Future<int> deleteProduit(Produit produit) async {
    var dbProduit = await db;
    int res = await dbProduit
        .rawDelete('DELETE FROM Produit WHERE prod_id = ?', [produit.id]);
    return res;
  }

  Future<int> clearPanier() async {
    var dbProduit = await db;
    int res = await dbProduit.rawDelete('DELETE FROM Produit');
    return res;
  }

  Future<bool> updateQuantite(Produit produit) async {
    var dbProduit = await db;
    int res = await dbProduit.update("Produit", produit.toMap(),
        where: "prod_id = ?", whereArgs: <int>[produit.id]);
    return res > 0 ? true : false;
  }

  Future<bool> isInCart(Produit produit) async {
    var dbProduit = await db;
    int count = Sqflite.firstIntValue(await dbProduit.rawQuery(
        "SELECT COUNT(*) FROM Produit WHERE prod_id = ?", [produit.id]));
    return count > 0;
  }
}
