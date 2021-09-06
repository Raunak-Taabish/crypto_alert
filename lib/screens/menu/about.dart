import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF151515),
        body: Container(
          width: double.infinity,
          // height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  "assets/images/logoname.png",
                  width: MediaQuery.of(context).size.width / 2,
                ),
              ),
              card("Raunak Singh", "- UI / Ux Designer\n- Frontend Developer",
                  "Portfolio", "Front-End"),
              card(
                  "Taabish Sutriwala",
                  "- Backend Developer\n- Frontend Developer",
                  "LinkedIn",
                  "Back-End"),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextButton(
                  child: Text(
                    "Cryptlert Github link",
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container card(String name, String desig, String button, String post) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFF202020),
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15.0),
                )),
            height: 30,
            width: double.infinity,
            child: Center(
              child: Text(
                "$post",
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Text(
                          "$name",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          "$desig",
                          style: TextStyle(
                              fontSize: 10,
                              height: 1.8,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Montserrat',
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
            width: double.infinity,
            child: Text(
              '"kajalklkn alskna sa s xlakslnxans alksxl alsknx alksnx lanslkxlansx asnx kjnsas casjca sckjascjasc jasj aj skx a"',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                  child: TextButton(
                    child: Text(
                      "$button",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {},
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                  child: TextButton(
                    child: Text(
                      "Github",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
