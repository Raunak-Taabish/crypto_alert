import 'package:flutter/material.dart';

class BackWhiteButton extends StatelessWidget {
  const BackWhiteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 30,
        color: Colors.transparent,
        child: Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
    // ElevatedButton(
    //   child: Icon(
    //     Icons.arrow_back_ios_rounded,
    //     color: Colors.black,
    //   ),
    //   style: ElevatedButton.styleFrom(
    //     padding: EdgeInsets.all(0),
    //     primary: Colors.white,
    //     elevation: 0,
    //     //elevation of button
    //     // shape: RoundedRectangleBorder(
    //     //     //to set border radius to button
    //     //     borderRadius: BorderRadius.circular(30)),
    //   ),
    //   onPressed: () {
    //     Navigator.pop(context);
    //   },
    // );
  }
}
