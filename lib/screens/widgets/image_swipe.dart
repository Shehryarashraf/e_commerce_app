import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;
  ImageSwipe({this.imageList});
  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (num) {
              setState(() {
                _selectedPage = num;
              });
            },
            //itemcount: imageList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  child: Image.network(
                "${widget.imageList[index]}",
                fit: BoxFit.cover,
              ));
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.imageList.length; i++)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: _selectedPage == i ? 35 : 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
