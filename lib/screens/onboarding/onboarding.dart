import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151515),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          "images/logoname.png",
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        SizedBox(height: 40),
                        Image.asset(
                          "images/search.png",
                          width: 180,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        RichText(
                          text: new TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                            children: <TextSpan>[
                              new TextSpan(
                                  text: 'Search',
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat Alternates',
                                  )),
                              new TextSpan(
                                text: ' the crypto u \n     wanna follow',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
