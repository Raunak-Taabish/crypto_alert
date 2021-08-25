import 'package:flutter/material.dart';

class ShowAllData extends StatefulWidget {
  const ShowAllData(this.cryptoname);
  final cryptoname;
  //const ShowAllData({Key? key, required this.cryptoname}) : super(key: key);

  @override
  _ShowAllDataState createState() => _ShowAllDataState();
}

class _ShowAllDataState extends State<ShowAllData> {
  @override
  void initState() {
    super.initState();
    return widget.cryptoname;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Container(),
      ),
    );
  }
}
