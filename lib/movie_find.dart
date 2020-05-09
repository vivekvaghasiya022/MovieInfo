import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'movie.dart';

class MovieFind extends StatelessWidget {
  var rng = Random();
  final Mname = TextEditingController();
  final Myear = TextEditingController();

  void getMovieData(mname, myear, context) async {
    http.Response response = await http
        .get("http://www.omdbapi.com/?apikey=6e793766&t=$mname&y=$myear");
    if (response.statusCode == 200) {
      var data = response.body;
      if (jsonDecode(data)['Response'] == "True") {
        Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 1000),
              transitionsBuilder: (context, animation, secAnimation, child) {
                animation = CurvedAnimation(
                    parent: animation, curve: Curves.elasticInOut);
                return ScaleTransition(
                    alignment: Alignment.center,
                    scale: animation,
                    child: child);
              },
              pageBuilder: (context, animation, secAnimation) {
                return Movie(data: response);
              }),
//            MaterialPageRoute(
//                builder: (context) => Movie(
//                      data: response,
//                    ))
        );
      } else {
        Alert(
                context: context,
                title: 'Error',style: AlertStyle(titleStyle: TextStyle(fontFamily: 'Rubik' , fontSize: 24),descStyle: TextStyle(fontFamily: 'Rubik', fontSize: 17)),
                desc: 'Please enter something!',
                buttons: [
                  DialogButton(child: Text('Okay', style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Rubik'),), onPressed: () => Navigator.pop(context))
                ]
        )
            .show();
      }
    } else {
      Alert(
              context: context,
              title: response.statusCode.toString(),
              desc: 'Issue with server')
          .show();
    }
  }

  @override
  Widget build(BuildContext context) {
    int x = rng.nextInt(2);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
//          color: Color(0xEEFCFCFC),
          image: DecorationImage(
            image: AssetImage('assets/bg_main_0.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Center(
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: EdgeInsets.all(30),
                      height: 300,
                      width: 340,
                      decoration: BoxDecoration(
                    color: Color(0x553F4852),
//                          gradient: LinearGradient(colors: [Color(0xEF3F4852), Color(0xEF161D23)], begin: Alignment.topLeft, end: Alignment.bottomRight),
//                          borderRadius: BorderRadius.only(
//                              topRight: Radius.circular(40),
//                              bottomLeft: Radius.circular(40))
                              ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Movie',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Rubik'),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          TextField(
                            controller: Mname,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Rubik"),
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.movie,
                                  color: Colors.white,
                                ),
                                contentPadding: EdgeInsets.all(10.0),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color(0xFF37EF50),
                                  width: 2.0,
                                )),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 2.0),
                                ),
                                hintText: "Movie name",
                                hintStyle: TextStyle(
                                    color: Colors.white, fontFamily: "Rubik", fontSize: 18)),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4)
                            ],
                            controller: Myear,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Rubik"),
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                contentPadding: EdgeInsets.all(10.0),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color(0xFF37EF50),
                                  width: 2.0,
                                )),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 2.0),
                                ),
                                hintText: "Release Year",
                                hintStyle: TextStyle(
                                    color: Colors.white, fontFamily: "Rubik", fontSize: 18)),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                getMovieData(Mname.text, Myear.text, context);
                              },
                              padding: EdgeInsets.symmetric(vertical: 13),
                              color: Colors.white,
                              child: Text('FIND DETAILS',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: "Rubik",
                                  )),
                            ),
                          )
                        ],
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
}
