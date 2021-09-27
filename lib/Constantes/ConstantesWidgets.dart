import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tecnica/UnsplashHandler/UnsplashImageHandler.dart';


///Tamano de las imagenes
enum ImageSize{
  small,
  regular,
  full
}




///clase de constantes usadas en la aplicacion
///
///
class ConstantesWidgets
{
  static const Color colorBase = Color(0x7F737373);
  static const Color colorSoftShadow = Color(0x2F737373);
  static const Color colorRed = Color(0xFFe34d42);
  static const Color colorWhite = Color(0xFFFFFFFF);



  ///Realiza un push con la ruta especificada
  void Push(context,route)
  {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => route),
    );
  }

  ///Realiza un pop de la ultima ruta
  void Pop(context)
  {
    Navigator.of(context).pop();
  }


  ///Devuelve un diseno de appBar
  PreferredSizeWidget appBar(context,String searchQuery,{
    required dynamic backFunction,
    required dynamic onSubmitedTextFunction,
    required dynamic onChangeTextFunction,
    required dynamic onChangeFilterFunction,

  })
  {
    return AppBar(
        shadowColor: new Color(0x00737373),
        backgroundColor: new Color(0xFFFFFFFF),
        actions:searchQuery!=""?null: [
          CupertinoButton(
            child: Text('Filtro'),
            onPressed: () {
                final act = CupertinoActionSheet(
                          title: Text('Tipo de busqueda'),
                          
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text('Por imagen'),
                              onPressed: () {
                                Navigator.pop(context);
                                onChangeFilterFunction(0);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text('Por usuario'),
                              onPressed: () {
                                Navigator.pop(context);
                                onChangeFilterFunction(1);
                              },
                            )
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ));
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => act);
            },
                  
            
          )
        ],
        leading:searchQuery==""?null:
          backButton(context,
            color: Colors.black,
            useShadow: false,
            useMargin: false,
            backFunction: backFunction,
          ),
        title:  CupertinoSearchTextField(
                    onChanged:onChangeTextFunction,
                    onSubmitted: onSubmitedTextFunction,
                  ),
      );
  }



  ///Devuelve un diseno de boton de back
  ///[backFunction] funcion de retorno al oprimir el boton de back
  Widget backButton(context,
  {
    dynamic backFunction, Color color:Colors.white,
    bool useShadow:true,bool useMargin:true
  })
  {
    return Container(
            decoration: BoxDecoration(
              boxShadow:!useShadow?null: [
                BoxShadow(
                  color: ConstantesWidgets.colorSoftShadow,
                  blurRadius: 15,
                  spreadRadius: 5
                )
              ]
            ),
            margin:!useMargin?null: EdgeInsets.only(left:10,right: 0,top:10),
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed:backFunction!=null?backFunction: ()
              {
                ConstantesWidgets().Pop(context);
              },
              icon:Icon(Icons.arrow_back_ios,color: color,),
            ),
          );
  }
  
  
  
  ///Devuelve un diseno de texto
  Widget constTexto({required String texto})
  {
    return Text(texto);
  }
  
  
  
  ///Devuelve un diseno de widget tipo loading
  Widget loadingGeneral()
  {
    return Center(
      child: CupertinoActivityIndicator(),
    );
  }

  
  
  
  
  ///Devuelve un widget imagen
  ///[unsplashImage] se asume que hay una imagen cargada en [unsplashImage.bytesImage]
  Widget bytesImage(UnsplashImage unsplashImage,
  {imageSize:ImageSize.small, double borderRadius=10})
  {
    String url = "";
    switch(imageSize)
    {
      case ImageSize.full: url=unsplashImage.imageURL_full;
      break;
      case ImageSize.small: url=unsplashImage.imageURL_small;
      break;
      case ImageSize.regular: url=unsplashImage.imageURL_regular;
      break;
    }
    return Container(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.memory(unsplashImage.bytesImage,fit: BoxFit.fill,
            errorBuilder: (BuildContext context, Object child,StackTrace? loadingProgress) {
              return Container(
                    color: unsplashImage.color,
                  );
            },
            /*loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child:loadingProgress==null?child:
                  Container(
                    color: unsplashImage.color,
                  ),
                );
            }*/
            ),
          )
        );
  }


  ///Devuelve un widget imagen
  ///[unsplashImage] se asume que hay un URL de imagen en [unsplashImage.imageURL_full]
  Widget networkImage(UnsplashImage unsplashImage,
  {imageSize:ImageSize.small, double borderRadius=10})
  {
    String url = "";
    switch(imageSize)
    {
      case ImageSize.full: url=unsplashImage.imageURL_full;
      break;
      case ImageSize.small: url=unsplashImage.imageURL_small;
      break;
      case ImageSize.regular: url=unsplashImage.imageURL_regular;
      break;
    }
    return Container(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.network(url,fit: BoxFit.fill,
            errorBuilder: (BuildContext context, Object child,StackTrace? loadingProgress) {
              return Container(
                    width: double.infinity,
                    height: 300,
                    color: unsplashImage.color,
                  );
            },
            loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child:loadingProgress==null?child:
                  Container(
                    width: double.infinity,
                    height: 300,
                    color: unsplashImage.color,
                  ),
                );
            }),
          )
        );
  }



  ///Devuelve un widget imagen con forma de Ovalo
  ///[url] se asume que hay un URL de imagen 
  Widget networkImageOval(String url ,
  {imageSize:ImageSize.small})
  {
    
    return Container(
          alignment: Alignment.center,
          child: ClipOval(
            child: Image.network(url,fit: BoxFit.fill,
            errorBuilder: (BuildContext context, Object child,StackTrace? loadingProgress) {
              return Container(
                    color: colorBase,
                  );
            },
            loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child:loadingProgress==null?child:
                  Container(
                    color: colorBase,
                  ),
                );
            }),
          )
        );
  }
}