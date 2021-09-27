import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tecnica/Constantes/ConstantesWidgets.dart';
import 'package:prueba_tecnica/UnsplashHandler/UnsplashImageHandler.dart';

class FullInfoUser extends StatefulWidget {
  FullInfoUser({Key? key, required this.title, required this.unsplashImage}) : super(key: key);
  final String title;
  final UnsplashImage unsplashImage;
  @override
  _Local createState() => _Local();
}

class _Local extends State<FullInfoUser> {
  ConstantesWidgets constWidgets = new ConstantesWidgets();
  var unsplashUser;
  String userURLImage = "";
  bool loadingUser=false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userURLImage = widget.unsplashImage.unsplashUser!.profile_image['medium']??"";
    getUserProfile();
  }
  void getUserProfile()async
  {
    loadingUser=true;
    unsplashUser = await UnsplashImageHandler().getUser(widget.unsplashImage.unsplashUser!.userName);
    loadingUser=false;
    if(mounted)
    setState(() {
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      body: 
      loadingUser?constWidgets.loadingGeneral():
      Padding(
        
        padding: EdgeInsets.only(left:10,right: 10),
        child: ListView(
          children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               constWidgets.backButton(context,
                color: Colors.black,
                useMargin: false,
                useShadow: false),
               Container(
                 width: 80,
                 height: 80,
                 child: constWidgets.networkImageOval(userURLImage),
               ),
               
               Container(
                 width: MediaQuery.of(context).size.width-150,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: 
                     [
                      Text(unsplashUser.name,
                      overflow: TextOverflow.clip,
                        style:TextStyle(fontSize: 20),
                      ),
                      unsplashUser.instagram_username==""?
                      Container():
                      Text("@"+unsplashUser.userName,
                        style:TextStyle(fontSize: 15),
                      ),
                   ],
                 ),
               )
             ],
            ),
            Divider(height: 30,),
            Text(unsplashUser.bio,
              style:TextStyle(fontSize: 15),
            ),
            Divider(height: 30,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  baseImageInfo(unsplashUser.total_likes.toString(), "Likes"),
                  baseImageInfo(unsplashUser.total_photos.toString(), "Fotos"),
                  baseImageInfo(unsplashUser.followers_count.toString(), "Seguidores"),
                  baseImageInfo(unsplashUser.following_count.toString(), "Siguiendo"),
                ],
              )
      
          ],
        ),
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