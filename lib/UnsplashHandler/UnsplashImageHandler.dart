import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:http/http.dart' as http;






///clase controlador de todo lo relacionado con llamadas a https://api.unsplash.com/
///[accessKey] el key de acceso a el api de https://api.unsplash.com/
///[listPhotosURL] el URL para busqueda de las ultimas imagenes subidas a https://unsplash.com/
///[searchPhotosURL] el URL para la busqueda de Fotos
///[listUsersURL] el URL para la busqueda de usuarios
///[getUserURL] el URL para la busqueda de usuarios
class UnsplashImageHandler
{
  final String accessKey = "hsPXEIm5zNZPX5zzl3_6oQgCADpBJ8i31BQBtGo03-0";
  final String listPhotosURL = "https://api.unsplash.com/photos/?";
  final String searchPhotosURL = "https://api.unsplash.com/search/photos/?";
  final String listUsersURL = "https://api.unsplash.com/users/";
  final String getUserURL = "https://api.unsplash.com/users/";
  static dynamic errordata = "";
  
  
  
  ///Obtiene [UnsplashUser] en base al [username]
  Future<UnsplashUser> getUser(String username)async
  {
    String url = getUserURL+"$username?client_id=$accessKey";
    var response = await http.get(Uri.parse(url));
    dynamic data = jsonDecode(response.body);
    return UnsplashUser.fromJson(data);
  }




  ///Manejo de errores de https://api.unsplash.com/
  ///
  ///Guarda la informacion en UnsplashImageHandler.errordata
  void _handleErrors(dynamic dataError)
  {
    if(dataError['errors'] != null)
    {
      if(dataError['errors'] is List<dynamic>)
      {
        switch(dataError['errors'][0].toString())
        {
          case "Couldn't find User":errordata="Username no encontrado";
          break;
          
        }
      }
    }
      
  }




  ///Descarga las imagenes desde https://api.unsplash.com/
  ///obtiene imagenes de 10 en 10
  ///
  ///[pageNumber] el numero de pagina que se desea descargar
  ///[searchQuery] el texto de busqueda
  ///[searchType] el tipo de busqueda (imagen[0], usuario[1])
  ///
  ///Devuelve una lista de [UnsplashImage] con la informacion
  ///En caso de error, guarda el error en [UnsplashImageHandler.errordata]
  ///
  ///Ejemplo
  ///```dart
  ///var example = UnsplashImageHandler().getListedImages(1,searchQuery:"iphone",searchType:0)
  ///print(example[0].data)
  ///```
  ///
  ///
  Future<List<UnsplashImage>?> getListedImages(
      int pageNumber,{String searchQuery:"", int searchType:0}
    ) async
  {
    print("GETTING LIST OF UNSPLASH IMAGES: PAGE $pageNumber");
    String url = "";
    print("TIPO BUSQUEDA: "+searchType.toString());
    if(searchType==0)
    {
       url = searchQuery==""?
        listPhotosURL+"client_id=$accessKey&page=$pageNumber&per_page=10"
        :
        searchPhotosURL+"client_id=$accessKey&page=$pageNumber&per_page=10&query=$searchQuery";
    }else
    {

       url = listUsersURL+searchQuery+"/photos/?"+"client_id=$accessKey&page=$pageNumber&per_page=10";
    }
    errordata="";
    var response = await http.get(Uri.parse(url));
    print("STATUS CODE: "+response.statusCode.toString());
    if(response == null || response.body ==null || response.statusCode!=200)
    {
      print(response.body);
      var dataError = jsonDecode(response.body);
      _handleErrors(dataError);
      return null;
    }
    
    dynamic data = jsonDecode(response.body);
    if(searchQuery != "" && searchType==0)
    {
      if(data['total'] != null && data['total']==0)
      return null;
      List<UnsplashImage> listaUnsplash = [];
      data['results'].forEach((element) {
        UnsplashImage unsplashImage = new UnsplashImage.fromJson(element);
        listaUnsplash.add(unsplashImage);
      });
      return listaUnsplash;
    }else
    {
     
      List<UnsplashImage> listaUnsplash = [];
      data.forEach((element) {
        
        UnsplashImage unsplashImage = new UnsplashImage.fromJson(element);
        if(unsplashImage.imageURL_small != "")
        listaUnsplash.add(unsplashImage);
      });
      return listaUnsplash;
    }
    
    
    
    
  }

  ///Descarga una imagen por medio de [url] tipo String
  ///Se asume que [url] es un enlace correcto a una imagen 
  Future<String> downloadImage(String url)async
  {
    var response = await http.get(Uri.parse(url));
    return jsonEncode(response.bodyBytes);
  }
}









///La clase de todas la informacion
///de las imagenes descargadas desde
///https://api.unsplash.com/
///Tiene toda la informacion de la imagen [data]
///Tiene un usuario [UnsplashUser] de la imagen
class UnsplashImage
{
  String id = "";
  dynamic data;
  String imageURL_small="";
  String imageURL_regular="";
  String imageURL_full="";
  String userImage="";
  String description="";
  String nameUser="";
  int likes = 0;
  num width = 0;
  num height = 0;
  Color color = new Color(0xFF808080);
  bool likedByUser = false;
  Uint8List bytesImage = new Uint8List(0);
  UnsplashUser? unsplashUser;


  ///Llena los valores de la clase desde informacion en formato json
  ///
  ///Guarda la informacion [json] en la variable [data]
  ///Ejemplo
  ///```dart
  ///var unsplashImage = UnsplashImage.fromJson(json);
  ///print(unsplashImage.data[id]??"")
  ///```
  ///
  UnsplashImage.fromJson (Map<String, dynamic> json)
  {
    
    data = json;
    id = json['id']??"";
    if(json['urls'] != null)
    { 
      imageURL_small = json['urls']['small']??"";
      imageURL_regular = json['urls']['regular']??"";
      imageURL_full = json['urls']['full']??"";
    }else if(json['cover_photo']['urls'] != null)
    {
      imageURL_small = json['cover_photo']['urls']['small']??"";
      imageURL_regular = json['cover_photo']['urls']['regular']??"";
      imageURL_full = json['cover_photo']['urls']['full']??"";
    }
    
    likes = json['likes']??0;
    width = json['width']??0;
    height = json['height']??0;
    likedByUser = json['likedByUser']??false;
    color = fromHex(json['color']??"#808080");
    description = json['description']??json['alt_description']??"";
    userImage = json['user']['profile_image']['small']??"";
    nameUser = json['user']['name']??"";
    unsplashUser = new UnsplashUser.fromJson(json['user']);
  }
  

  ///Obtiene el [Color] en base a un string en formato hexadecimal
  Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if(hexString=="#FFFFFF")
    hexString="808080";
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}







///clase usuario de dicha imagen
///tiene la informacion de un usuario que se encuentre en
///la base de datos de Unsplash
class UnsplashUser
{
  String id = "";
  dynamic data;
  String name = "";
  String userName="";
  String portafolioURL ="";
  int total_likes = 0;
  String instagram_username = "";
  dynamic profile_image = [];
  String bio="";
  int total_photos = 0;
  int followers_count = 0;
  int following_count = 0;
  int downloads = 0;



  ///Llena los valores de la clase desde informacion en formato json
  ///
  ///Guarda la informacion [json] en la variable [data]
  ///Ejemplo
  ///```dart
  ///var unsplashUser = UnsplashUser.fromJson(json);
  ///print(unsplashUser.data[id]??"")
  ///```
  ///
  UnsplashUser.fromJson (Map<String, dynamic> json)
  {
    data = json;
    id = json['id']??"";
    name = json['name']??"";
    portafolioURL = json['portafolioURL']??"";
    total_likes = json['total_likes']??0;
    bio = json['bio']??"";
    total_photos = json['total_photos']??0;
    followers_count = json['followers_count']??0;
    following_count = json['following_count']??0;
    downloads = json['downloads']??0;
    instagram_username = json['instagram_username']??"";
    profile_image = json['profile_image']??[];
    userName = json['username']??"";
  }

  
}