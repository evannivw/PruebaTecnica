import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tecnica/Constantes/ConstantesWidgets.dart';
import 'package:prueba_tecnica/Menus/FullInfoImage.dart';
import 'package:prueba_tecnica/Menus/FullInfoUser.dart';
import 'package:prueba_tecnica/UnsplashHandler/UnsplashImageHandler.dart';

class UnsplashImageListed extends StatefulWidget {

  UnsplashImageListed({Key? key, 
    required this.loadingFunction, 
    required this.listUnsplash,
    required this.searchALikeFunction,
    required this.tapOnLike,
    required this.scrollController,
    this.useImageBytes:false,
  }) : super(key: key);
  final ScrollController scrollController;
  final Function loadingFunction;
  final Function searchALikeFunction;
  final Function tapOnLike;
  final List<UnsplashImage> listUnsplash;
  final bool useImageBytes ;
  @override
  _Local createState() => _Local();
}

class _Local extends State<UnsplashImageListed> {
  ConstantesWidgets constWidgets = new ConstantesWidgets();
  bool loadingImages =false;
  @override
  Widget build(BuildContext context) {
    return 
    CustomScrollView(
          controller:widget.scrollController ,
          slivers: [
           
            SliverPadding(padding: EdgeInsets.only(top: 20)),

            widget.listUnsplash.length==0 && loadingImages?
            SliverToBoxAdapter(child: constWidgets.loadingGeneral()):
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index)
                {
                  bool isLikedByUser = widget.searchALikeFunction("test",widget.listUnsplash[index]);
                  return GestureDetector(
                    onDoubleTap: ()
                    {
                      widget.tapOnLike(widget.listUnsplash[index], "test");
                    },
                    onTap: ()
                    {
                      constWidgets.Push(context, FullInfoImage(
                        title: widget.listUnsplash[index].description, 
                        unsplashImage: widget.listUnsplash[index]));
                    },
                    child: Column(
                      children: 
                        [
                          GestureDetector(
                            onTap: ()
                            {
                              constWidgets.Push(context, 
                              FullInfoUser(
                                title: widget.listUnsplash[index].unsplashUser!.name, 
                                unsplashImage: widget.listUnsplash[index]));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left:15,bottom: 15,),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: constWidgets.networkImageOval(
                                      widget.listUnsplash[index].userImage
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(widget.listUnsplash[index].nameUser)
                                ],
                              ),
                            ),
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: 
                              [
                                Container(
                                  margin: EdgeInsets.only(bottom: 50),
                                  child: Hero(
                                    tag: widget.listUnsplash[index].id+(widget.useImageBytes?"local":""),
                                    child: 
                                      widget.useImageBytes?
                                      constWidgets.bytesImage(
                                        widget.listUnsplash[index],
                                        borderRadius: 5
                                        )
                                      :
                                      constWidgets.networkImage(
                                        widget.listUnsplash[index],
                                        borderRadius: 5
                                        )
                                    ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                    onPressed: ()
                                    {

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ConstantesWidgets.colorSoftShadow,
                                            blurRadius: 15,
                                            spreadRadius: 5
                                          )
                                        ]
                                      ),
                                      margin: EdgeInsets.only(right: 10,bottom: 10),
                                      child: Column(
                                        children: [
                                          Icon(CupertinoIcons.heart_solid,
                                            color: ConstantesWidgets.colorRed,
                                          ),
                                          Text(
                                            widget.listUnsplash[index].likes==0?"":
                                            widget.listUnsplash[index].likes.toString(),
                                            style: TextStyle(color: ConstantesWidgets.colorRed
                                            ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -10,
                                  left: (MediaQuery.of(context).size.width/2) - 45,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      enableFeedback: false,
                                      
                                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      foregroundColor: MaterialStateProperty.all(Colors.transparent),
                                    ),
                                    onPressed: ()
                                    {
                                      //tap on like
                                      widget.tapOnLike(widget.listUnsplash[index], "test");
                                    },
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: 15,top: 0),
                                      decoration: BoxDecoration(
                                        color: 
                                          isLikedByUser?
                                            ConstantesWidgets.colorRed:
                                            ConstantesWidgets.colorWhite,
                                        borderRadius: BorderRadius.circular(5),
                                        border: 
                                        isLikedByUser?null:
                                        Border.all(color: ConstantesWidgets.colorBase)
                                      ),
                                      child: 
                                        Icon(
                                          isLikedByUser?
                                            CupertinoIcons.heart_fill:
                                            CupertinoIcons.heart,
                                          
                                          color: 
                                          isLikedByUser?
                                            ConstantesWidgets.colorWhite:
                                            ConstantesWidgets.colorBase,
                                          
                                        ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                          SizedBox(height: 20)
                      ],
                    )
                  );
                },
                childCount: widget.listUnsplash.length,
              ),
              
            ),
            
            
            
            SliverPadding(padding: EdgeInsets.only(top: 50)),
            SliverFillRemaining(fillOverscroll: false,hasScrollBody: false,
              child: 
              widget.listUnsplash.length %10 != 0?
              Container():
              constWidgets.loadingGeneral(),
            ),
            SliverPadding(padding: EdgeInsets.only(top: 150))
            
          ],
        );
  }
  
}