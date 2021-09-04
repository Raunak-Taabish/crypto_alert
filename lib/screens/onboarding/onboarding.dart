import 'package:crypto_alert/screens/home.dart';
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

  Scaffold pages(String image, String btext, String text) {
    return Scaffold(
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
                        "assets/images/$image",
                        width: 180,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$btext",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "$text",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              //fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
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
                      flag <= 1
                          ? setState(() {
                              pageController.animateToPage(++flag,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);

                              //   Navigator.push(context,
                              //       MaterialPageRoute(builder: (context) {
                              //     return Home();
                              //   }));
                            })
                          : Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => ShowLoading()),
                              (Route<dynamic> route) => false);
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
    );
  }

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
        pages(
          'search.png',
          'Search',
          'the crypto u\nwanna follow',
        ),
        pages(
          'favorite.png',
          'Add',
          'your crypto to\nfavorites list',
        ),
        pages(
          'inoculars.png',
          'Follow',
          'your crypto to\nget latest updates',
        ),

        // Scaffold(
        //   backgroundColor: Color(0xFF151515),
        //   body: SafeArea(
        //     child: Padding(
        //       padding: const EdgeInsets.fromLTRB(25, 30, 25, 40),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Column(
        //             children: [
        //               Column(
        //                 children: [
        //                   Image.asset(
        //                     "assets/images/logoname.png",
        //                     width: MediaQuery.of(context).size.width / 2,
        //                   ),
        //                   const SizedBox(height: 40),
        //                   Image.asset(
        //                     "assets/images/favorite.png",
        //                     width: 180,
        //                   ),
        //                   const SizedBox(
        //                     height: 50,
        //                   ),
        //                   RichText(
        //                     text: const TextSpan(
        //                       // Note: Styles for TextSpans must be explicitly defined.
        //                       // Child text spans will inherit styles from parent
        //                       style: TextStyle(
        //                         fontSize: 16.0,
        //                         color: Colors.white,
        //                       ),
        //                       children: <TextSpan>[
        //                         TextSpan(
        //                             text: 'Add',
        //                             style: TextStyle(
        //                               fontWeight: FontWeight.w600,
        //                               fontFamily: 'Montserrat',
        //                             )),
        //                         TextSpan(
        //                           text: ' your crypto to \n     favorites list',
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //           Container(
        //             width: double.infinity,
        //             color: Colors.transparent,
        //             child: Align(
        //               alignment: Alignment.bottomRight,
        //               child: FloatingActionButton(
        //                 backgroundColor: Colors.white,
        //                 onPressed: () {
        //                   setState(() {
        //                     pageController.animateToPage(++flag,
        //                         duration: const Duration(milliseconds: 500),
        //                         curve: Curves.easeIn);
        //                   });
        //                 },
        //                 child: const Icon(
        //                   Icons.arrow_forward_ios,
        //                   color: Color(0xFF151515),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // Scaffold(
        //   backgroundColor: Color(0xFF151515),
        //   body: SafeArea(
        //     child: Padding(
        //       padding: const EdgeInsets.fromLTRB(25, 30, 25, 40),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Column(
        //             children: [
        //               Column(
        //                 children: [
        //                   Image.asset(
        //                     "assets/images/logoname.png",
        //                     width: MediaQuery.of(context).size.width / 2,
        //                   ),
        //                   const SizedBox(height: 40),
        //                   Image.asset(
        //                     "assets/images/binoculars.png",
        //                     width: 180,
        //                   ),
        //                   const SizedBox(
        //                     height: 50,
        //                   ),
        //                   RichText(
        //                     text: const TextSpan(
        //                       // Note: Styles for TextSpans must be explicitly defined.
        //                       // Child text spans will inherit styles from parent
        //                       style: TextStyle(
        //                         fontSize: 16.0,
        //                         color: Colors.white,
        //                       ),
        //                       children: <TextSpan>[
        //                         TextSpan(
        //                             text: 'Follow',
        //                             style: TextStyle(
        //                               fontWeight: FontWeight.w600,
        //                               fontFamily: 'Montserrat',
        //                             )),
        //                         TextSpan(
        //                           text:
        //                               ' your crypto to \n    get latest updates',
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //           Container(
        //             width: double.infinity,
        //             color: Colors.transparent,
        //             child: Align(
        //               alignment: Alignment.bottomRight,
        //               child: FloatingActionButton(
        //                 backgroundColor: Colors.white,
        //                 onPressed: () {
        //                   Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                           builder: (BuildContext context) =>
        //                               ShowLoading()));
        //                 },
        //                 child: const Icon(
        //                   Icons.arrow_forward_ios,
        //                   color: Color(0xFF151515),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
