import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool outlineBtn;
  final bool isloading;

  CustomBtn({this.text, this.onPressed, this.outlineBtn, this.isloading});

  @override
  Widget build(BuildContext context) {
    bool _outlineBtn = outlineBtn ?? false;
    bool _isloading = isloading ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: _outlineBtn ? Colors.transparent : Colors.black,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Stack(
          children: [
            Visibility(
              visible: _isloading ? false : true,
              child: Center(
                child: Text(
                  text ?? "Text",
                  style: TextStyle(
                      fontSize: 16,
                      color: _outlineBtn ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Visibility(
              visible: _isloading, 
              child: Center(
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator())),
            ),
          ],
        ),
      ),
    );
  }
}
