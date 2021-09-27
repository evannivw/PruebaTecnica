import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tecnica/Constantes/ConstantesWidgets.dart';
import 'package:prueba_tecnica/Menus/FullInfoUser.dart';
import 'package:prueba_tecnica/UnsplashHandler/UnsplashImageHandler.dart';

class FullInfoImage extends StatefulWidget {
  FullInfoImage({Key? key, required this.title, required this.unsplashImage}) : super(key: key);
  final String title;
  final UnsplashImage unsplashImage;
  @override
  _Local createState() => _Local();
}

class _Local extends State<FullInfoImage> {
  ConstantesWidgets constWidgets = new ConstantesWidgets();
  String userURLImage = "";
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userURLImage = widget.unsplashImage.unsplashUser!.profile_image['medium']??"";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Stack(
            children: 
              [
                Hero(
                  tag: widget.unsplashImage.id,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    
                    child: constWidgets.networkImage(
                          widget.unsplashImage,
                          imageSize: ImageSize.regular,
                          borderRadius: 0,
                          ),
                  ),
                ),
                constWidgets.backButton(context),
                
                
            ],
          ),
          Container(
            //height: 80,
            padding: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: ConstantesWidgets.colorWhite,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: 
                [
                  GestureDetector(
                    onTap: ()
                    {
                      constWidgets.Push(context, 
                        FullInfoUser(
                          title: widget.unsplashImage.unsplashUser!.userName, unsplashImage: widget.unsplashImage));
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: constWidgets.networkImageOval(
                            userURLImage
                          ),
                        ),
                        SizedBox(width: 15,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                              Text(widget.unsplashImage.nameUser),
                              widget.unsplashImage.unsplashUser!.userName==""?
                              Container():
                              Text("@"+widget.unsplashImage.unsplashUser!.userName),
                              SizedBox(height: 10,),
                              
                            ]
                        )
                      ],
                                  ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.unsplashImage.description,
                          
                          style: TextStyle(fontSize: 15),
                        ),
                  ),
                  Divider(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      baseImageInfo(widget.unsplashImage.likes.toString(), "Likes"),
                      baseImageInfo(
                        widget.unsplashImage.width.toString()+"x"+
                        widget.unsplashImage.height.toString(), "Size"),
                    ],
                  )
              ],
            ),
          ),
          SizedBox(height: 200,)
        ],
      ),
    );
  }

  Widget baseImageInfo(String mainText, String text)
  {
    return Column(
      children: [
        Text(mainText,
        style: TextStyle(fontSize: 20),
        ),
        Text(text),
      ],
    );
  }

}