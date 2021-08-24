import 'package:flutter/material.dart';

import 'showloading.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController pageController = PageController();
  int flag = 0;
  @override
  Widget build(BuildContext context) {
    return PageView(
      pageSnapping: true,
      controller: pageController,
      onPageChanged: (index) {
        setState(() {
          flag = index;
        });
        print(flag);
      },
      children: [
        Scaffold(
          backgroundColor: Color(0xFF151515),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/logoname.png",
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                          const SizedBox(height: 40),
                          Image.asset(
                            "assets/images/search.png",
                            width: 180,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          RichText(
                            text: const TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Search',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat Alternates',
                                    )),
                                TextSpan(
                                  text: ' the crypto u \n     wanna follow',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            pageController.animateToPage(++flag,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          });
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF151515),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Color(0xFF151515),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/logoname.png",
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                          const SizedBox(height: 40),
                          Image.asset(
                            "assets/images/favorite.png",
                            width: 180,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          RichText(
                            text: const TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Search',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat Alternates',
                                    )),
                                TextSpan(
                                  text: ' the crypto u \n     wanna follow',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            pageController.animateToPage(++flag,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          });
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF151515),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Color(0xFF151515),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/logoname.png",
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                          const SizedBox(height: 40),
                          Image.asset(
                            "assets/images/binoculars.png",
                            width: 180,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          RichText(
                            text: const TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Search',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat Alternates',
                                    )),
                                TextSpan(
                                  text: ' the crypto u \n     wanna follow',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ShowLoading()));
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF151515),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
