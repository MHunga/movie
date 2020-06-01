import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimateTitle extends StatefulWidget {
final ScrollController scrollController;
final String title;
  const AnimateTitle({Key key, this.scrollController, this.title}) : super(key: key);

  @override
  AnimateTitleState createState() => AnimateTitleState();
}

class AnimateTitleState extends State<AnimateTitle> {
  get offset => widget.scrollController.hasClients?widget.scrollController.offset:0;
  bool _isScroll = false;
  bool _isScroll2 = true;
@override
  void initState() {
  widget.scrollController.addListener(_listenToScrollChange);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  AnimatedBuilder(
      animation: widget.scrollController,
      builder: (context, child) {
        return AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          top:_isScroll2?(MediaQuery.of(context).padding.top+AppBar().preferredSize.height-widget.scrollController.offset/3) : (_isScroll? MediaQuery.of(context).padding.top+15: MediaQuery.of(context).padding.top+AppBar().preferredSize.height),
          left: _isScroll?50 :170,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height:(_isScroll?AppBar().preferredSize.height-30:70),

            child: Container(
              width:_isScroll ? MediaQuery.of(context).size.width-50 :MediaQuery.of(context).size.width-180,
              height: 70,
              child:  AutoSizeText(
                  widget.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 30),
                  //minFontSize: 18,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),


            ),
          ),
        );
      }
    );
  }

  void _listenToScrollChange() {
   if(widget.scrollController.offset>=100&&!_isScroll&&_isScroll2){
      setState(() {
        _isScroll = true;
        _isScroll2 = false;
      });
    }
    else if(widget.scrollController.offset<100&&_isScroll){
      setState(() {
        _isScroll2 = true;
        _isScroll = false;
      });
    }

  }
}