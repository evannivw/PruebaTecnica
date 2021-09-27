import 'dart:convert';
import 'dart:typed_data';

import 'package:prueba_tecnica/UnsplashHandler/UnsplashImageHandler.dart';
import 'package:sqflite/sqflite.dart';





///clase controlador de la base de datos local
///Guarda informacion de las imagenes agregadas como favoritos localmente
///SQL Local database utilizando el package sqflite
///
///[tablaFavoritos] tabla de los datos guardados como favoritos

class SQLiteDatabase
{
  static const String tablaFavoritos = "Favoritos";
  static var _database;


  ///Inicia la base de datos local
  Future initialize() async
  {
    //await deleteDatabase("localDB.db");
    _database =  await openDatabase(
     'localDB.db',
      onCreate: (Database db, int version)async
      {
        await db.execute(
        'CREATE TABLE $tablaFavoritos (id STRING PRIMARY KEY, idUser TEXT, searchQuery TEXT, url TEXT, data TEXT, image TEXT)');
        print("TABLA $tablaFavoritos CREADA");
      },
      version: 1,
    );
    print("LOCAL DATABASE INITIALIZED");
  }



  ///Guarda un dato en base de datos en tabla [tablaFavoritos]
  ///se asume que la informacion viene correctamente
  ///
  ///[unsplashImage] tipo UnsplashImage con la informacion de la imagen
  ///[idUser] id de usuario (sin usar)
  ///
  ///Ejemplo
  ///```dart
  ///await SQLiteDatabase().addToFavoritos(unsplashImage,"test");
  ///```
  Future<void> addToFavoritos(UnsplashImage unsplashImage, String idUser)async
  {
    String image = await UnsplashImageHandler().downloadImage(unsplashImage.imageURL_regular);
    try {
      await _database.transaction((txn) async {
        int id1 = await txn.rawInsert(
          'INSERT INTO $tablaFavoritos(id, idUser, searchQuery, url, data, image) VALUES(?,?,?,?,?,?)',
          [unsplashImage.id,idUser,unsplashImage.description,unsplashImage.imageURL_regular,jsonEncode(unsplashImage.data),image]
          );
          print('AGREGADO A $tablaFavoritos: $id1');
      });
      
    } catch (e) {
      print("ERROR AGREGANDO A FAVORITOS");
    } 
    
    
  }


  ///Borra datos de favoritos de la base de datos
  //////se asume que la informacion viene correctamente
  ///
  ///[unsplashImage] tipo UnsplashImage con la informacion de la imagen
  ///[idUser] id de usuario (sin usar)
  ///
  ///Ejemplo
  ///```dart
  ///await SQLiteDatabase().deleteFromFavoritos(unsplashImage,"test");
  ///```
  Future<void> deleteFromFavoritos(UnsplashImage unsplashImage, String idUser)async
  {
    var count = await _database
    .rawDelete('DELETE FROM $tablaFavoritos WHERE id = ?', [unsplashImage.id]);
    assert(count == 1);
  }





  ///Obtiene datos de la base de datos de la tabla [tablaFavoritos]
  ///Se obtienen imagenes de 10 en 10
  ///[localPage] la pagina que se desea obtener, se asume que es mayor a 1
  ///[searchQuery] el texto de busqueda a buscar 
  ///
  ///Devuelve una lista de [UnsplashImage]
  ///
  ///Ejemplo
  ///```dart
  ///var ejemplo = SQLiteDatabase().getFavoritos(2,"iphone");
  ///print(ejemplo[0].data);
  ///```
  Future<List<UnsplashImage>> getFavoritos({int localPage:1, String searchQuery:""})async
  {
    List<Map> list = [];
    List<UnsplashImage> listUnsplash=[];
    if(searchQuery=="")
    {
      list = await _database.rawQuery('SELECT * FROM $tablaFavoritos LIMIT ${localPage*10}');
      print("CANTIDAD FAVORITOS: "+list.length.toString());
    }else
    {
      var sublist = await _database.rawQuery('SELECT * FROM $tablaFavoritos ');
      for(int i =0; i < sublist.length; i++)
      {
        if(sublist[i]['data'].toString().toLowerCase()
          .contains(searchQuery.toLowerCase()))
        if(list.length < localPage*10)
        list.add(sublist[i]);
      }
    }

    list.forEach((element) {
      dynamic data = element['data'];
      UnsplashImage unsplashImage = new UnsplashImage.fromJson(jsonDecode(data));
      unsplashImage.bytesImage= Uint8List.fromList(jsonDecode(element['image']).cast<int>());
      listUnsplash.add(unsplashImage);
    });
    return listUnsplash;
  }


}