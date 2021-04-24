import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
class PercentIndicatorDemo extends StatefulWidget {
  @override
  _PercentIndicatorDemoState createState() => _PercentIndicatorDemoState();
}

class _PercentIndicatorDemoState extends State<PercentIndicatorDemo> {

  double percent = 0.0;

  double _height;

  @override
  void initState() {
    Timer timer;
    timer = Timer.periodic(Duration(milliseconds:10000),(_){
      setState(() {
        percent+=10;
        if(percent >= 100){
          timer.cancel();
          // percent=0;
        }
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;

    return Scaffold(

        body:Container(
            child:Center(
              child: Column(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: <Widget>[

                  Column(
                    children: [
                      Text(
                        'Circular Percent Indicator',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: CircularPercentIndicator(
                            radius: 120.0,
                            lineWidth: 10.0,
                            animation: true,
                            percent: percent/100,
                            center: Text(
                              percent.toString() + "%",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            backgroundColor: Colors.grey[300],
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.redAccent,
                          )
                      ),
                    ],
                  ),


                ],
              ),
            )
        )
    );
  }
}