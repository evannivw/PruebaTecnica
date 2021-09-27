import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tecnica/Constantes/ConstantesWidgets.dart';
import 'package:prueba_tecnica/Menus/Favoritos.dart';
import 'package:prueba_tecnica/Menus/Home.dart';

class TabBarMenu extends StatefulWidget {
  TabBarMenu({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _Local createState() => _Local();
}

class _Local extends State<TabBarMenu> {
  PageController pageController = new PageController();
  int paginaPageView = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: 
            [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Center(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: (p)
                {
                  paginaPageView=p;
                  setState(() {
                    
                  });
                },
                children: [
                  Home(title: "Home"),
                  Favoritos(title: "Favoritos"),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                width:MediaQuery.of(context).size.width<700?
                 MediaQuery.of(context).size.width-150:
                 400,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: new Color(0xFFFFFFFF),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      spreadRadius: 3,
                      color: new Color(0x7F737373)
                    )
                  ]
                ),
                child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: (){
                        pageController.animateToPage(
                          0, duration: Duration(milliseconds: 150), 
                          curve: Curves.linear);
                      }, 
                      child: 
                        Column(
                          children: 
                          [
                            Icon(Icons.home,
                              color: 
                              paginaPageView==0?
                              Colors.blue:
                              ConstantesWidgets.colorBase,),
                            Text("Home",
                              style: TextStyle(
                                color: 
                                paginaPageView==0?
                                Colors.blue:
                                ConstantesWidgets.colorBase),
                            ),
                          ]
                        )
                    ),
                    TextButton(
                      onPressed: (){
                        pageController.animateToPage(
                          1, duration: Duration(milliseconds: 150), 
                          curve: Curves.linear);
                      }, 
                      child: 
                        Column(
                          children: 
                          [
                            Icon(CupertinoIcons.heart_fill,
                              color: 
                              paginaPageView==1?
                              Colors.blue:
                              ConstantesWidgets.colorBase,),
                            Text("Favoritos",
                              style: TextStyle(
                                color: 
                                paginaPageView==1?
                                Colors.blue:
                                ConstantesWidgets.colorBase),
                            ),
                          ]
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
      )
    );
  }
}
