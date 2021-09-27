import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tecnica/Constantes/ConstantesWidgets.dart';
import 'package:prueba_tecnica/Database/SQLiteDatabase.dart';
import 'package:prueba_tecnica/Menus/FullInfoImage.dart';
import 'package:prueba_tecnica/UnsplashHandler/UnsplashImageHandler.dart';
import 'package:prueba_tecnica/UnsplashHandler/UnsplashImageListed.dart';

class Favoritos extends StatefulWidget {
  Favoritos({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _Local createState() => _Local();
}

class _Local extends State<Favoritos> {
  bool loadingImages =false;
  bool isSearching = false;
  String searchQuery = "";
  int localPage=1;
  bool enableScrollLoading=false;
  ConstantesWidgets constWidgets = new ConstantesWidgets();
  List<UnsplashImage> listUnsplash =[];
  List<UnsplashImage> listFavoritos =[];
  var _controller = ScrollController(); 





  @override
  void initState() {
    super.initState();
    loadImages();
     _controller.addListener(() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent
        &&enableScrollLoading
    ) {
      if (_controller.position.pixels == 0) {
        // top
      } else {
        print("BOTTOM"); 
        enableScrollLoading=false;
        nextPage();
      }
    }
  });
  }
  





  void loadImages() async
  {
    if(this.listUnsplash.length %10 != 0)
    return;
    loadingImages = true;
    List<UnsplashImage> data = await SQLiteDatabase().getFavoritos(
        localPage: localPage,
        searchQuery: searchQuery,    
    );
    if(data!=null)
    {
      data.forEach((element) {
        this.listUnsplash.add(element);
        this.listFavoritos.add(element);
      });
    }
    print("CANTIDAD IMAGENES: "+this.listUnsplash.length.toString());
    loadingImages=false;
    
    if(mounted)
    setState(() {
      
    });
    await Future.delayed(Duration(seconds: 1));
    enableScrollLoading=true;
    
  }



  void nextPage()
  {
    localPage++;
    searchQuery="";
    if(!isSearching)
    {
      searchQuery="";
    }
    loadImages();
  }
  



  void tapOnLike(UnsplashImage unsplashImage,String idUser)async
  {
    if(searchALike(idUser, unsplashImage))
    {
      SQLiteDatabase().deleteFromFavoritos(unsplashImage, idUser);
      listFavoritos.remove(unsplashImage);
      setState(() {
        
      });
      return;
    }
    SQLiteDatabase().addToFavoritos(unsplashImage, idUser);
    listFavoritos.add(unsplashImage);
    setState(() {
      
    });
  }





  bool searchALike(String idUser, UnsplashImage unsplashImage)
  {
    bool retorno = false;
    listFavoritos.forEach((element) {
      if(element.id==unsplashImage.id)
      {
        retorno=true;
      }
    });
    return retorno;
  }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: new Color(0xFFFFFFFF),
      appBar: constWidgets.appBar(context, searchQuery,
        onSubmitedTextFunction: (String value)
        {
          searchQuery=value;
          listUnsplash.clear();
          
          setState(() {
            
          });
          isSearching=true;
          localPage=1;
          loadImages();
          if(_controller.hasClients)
          _controller.jumpTo(0);
        }, 
        onChangeTextFunction:
        (String value)
        {
          searchQuery=value;
        },
        backFunction: 
          ()
          {
            localPage=1;
            isSearching=false;
            this.listUnsplash.clear();
            searchQuery="";
            loadImages();
          }, 
          onChangeFilterFunction: (int value)
          {
            localPage=1;
            this.listUnsplash.clear();
            loadImages();
          }
        ),
        
      body:
      
      loadingImages==false&&this.listUnsplash.length==0?
      Container(
        margin: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              searchQuery!=""?"Busqueda sin resultados":
              "Aun no tienes imagenes Favoritas"),
            //SizedBox(height: 10,),
            /*TextButton(
              onPressed: ()
              {
                listUnsplash.clear();
                searchQuery="";
                loadImages();
              },
              child: Text("Regresar",
                style: TextStyle(color: Colors.blue),
              ),
            ),*/
          ]
          )
      ):
      Padding(
        padding: EdgeInsets.only(left:14,right: 14),
        child: UnsplashImageListed(
          listUnsplash: this.listUnsplash,
          searchALikeFunction: searchALike,
          loadingFunction: loadImages, 
          tapOnLike: tapOnLike,
          scrollController: _controller,
          useImageBytes: true,
        ),
      )
    );
  }
}