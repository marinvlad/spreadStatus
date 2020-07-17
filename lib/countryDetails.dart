import 'package:covid/country.dart';
import 'package:covid/grafic.dart';
import 'package:covid/regresion.dart';
import 'package:flutter/material.dart';
import 'package:gradient_progress/gradient_progress.dart';
import 'package:gradient_text/gradient_text.dart';
class CountryDetails extends StatefulWidget {
  final Country country;
  CountryDetails({this.country});
  @override
  _CountryDetailsState createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {

  int confirmed;
  int deaths;
  int recovered;
  void setData(){
    setState(() {
      confirmed = widget.country.getConfirmed();
      deaths = widget.country.getDeaths();
      recovered = widget.country.getRecovered();
    });
  }
  void calcRegression(){
    try{
    Regression regression = new Regression();
    setState(() {
      confirmed = regression.getFutureConfirmed(widget.country);
      deaths = regression.getFutureDeaths(widget.country);
      recovered = regression.getFutureHealed(widget.country);
    });
    }catch(e){

    }
  }
  void _handleTapDown(TapDownDetails details){
    calcRegression();       
  }
  void _handleTapUp(TapUpDetails details){
    setData();
  }
  @override
  void initState() {
    setData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff403944),
        elevation: 0,
      ),
      backgroundColor: Color(0xff403944),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:30.0),
                child: Text("Overview " + widget.country.name,style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold
                ),textAlign: TextAlign.start,),
              ),
             
              Container(
                height: MediaQuery.of(context).size.height*0.25,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[ 
                          GradientText(
                            confirmed.toString(),
                            gradient:LinearGradient(
                              colors: [
                                Color(0xffFF8C00),
                                Color(0xffFF0080)
                              ]
                            ),
                            style: TextStyle(             
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                          Text("Confirmed",style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                            ),)
                        ],
                      )                
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GradientText(
                            deaths.toString(),
                            gradient:LinearGradient(
                              colors: [
                                Color(0xff12c2e9),
                                Color(0xfff64f59)
                              ]
                            ),
                            style: TextStyle(             
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),                        
                          Text("Dead",style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                            ),)                      
                        ],
                      )
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[                     
                        GradientText(
                            recovered.toString(),
                            gradient:LinearGradient(
                              colors: [
                                Color(0xff11998e),
                                Color(0xff38ef7d)
                              ]
                            ),
                            style: TextStyle(             
                            fontSize: 40,
                            fontWeight: FontWeight.bold)), 
                          Text("Healed",style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),)
                        ],
                      )
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                child: Container(
                  margin: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffc31432),
                        Color(0x636FA4)
                      ]
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  height: 80,
                  child: Center(child: Text("See how statistics could look in 7 days", textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Spread evolution",style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(left:15),
                child: Text("The following data are not official",style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              child: Grafic(country: widget.country,)),
          )
        ],
      ),
    );
  }
}