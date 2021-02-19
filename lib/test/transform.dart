import 'package:flutter/material.dart';

class TransformDemo extends StatefulWidget {
  TransformDemo() : super();

  final String title = "Transform Demo";

  @override
  TransformDemoState createState() => TransformDemoState();
}

class TransformDemoState extends State<TransformDemo> {
  double sliderVal = 0;
  bool tap = false;
  @override
  initState() {
    super.initState();
    sliderVal = 0;
  }

  Container threeD() {
    return Container(
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, sliderVal / 1000)
          ..rotateX(3.14 / 20.0),
        alignment: FractionalOffset.center,
        child: Container(
          height: 100.0,
          width: 100.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  Container skew() {
    return Container(
      child: Transform(
        transform: Matrix4.skewX(sliderVal / 100),
        child: Container(
          height: 100.0,
          width: 100.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  Container translate() {
    return Container(
      child: Transform.translate(
        offset: Offset(sliderVal, 0.0),
        child: Container(
          height: 100.0,
          width: 100.0,
          color: Colors.yellow,
        ),
      ),
    );
  }

  Container scale() {
    return Container(
      child: Transform.scale(
        scale: sliderVal == 0 ? 1 : sliderVal / 50,
        origin: Offset(0.0, 0.0),
        child: Container(
          height: 100.0,
          width: 100.0,
          color: Colors.green,
        ),
      ),
    );
  }

  Container rotate() {
    return Container(
      child: InkWell(
        onTap: (){
          setState(() {
            tap = !tap;
          });
        },
        child: Transform.rotate(
          angle: tap?45:0,
          origin: Offset(0.0, 0.0),
          child: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Slider slider() {
    return Slider(
      value: sliderVal,
      min: 0,
      max: 100,
      onChanged: (val) {
        setState(() {
          sliderVal = val;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          slider(),
          rotate(),
          scale(),
          translate(),
          skew(),
          threeD(),
        ],
      ),
    );
  }
}