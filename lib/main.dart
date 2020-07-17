import 'dart:convert';
import 'dart:ffi';

import 'package:covid/country.dart';
import 'package:covid/countryDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid19',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Country> countryes = [];
  Future<Country> fetchAlbum() async {
  final response =
      await http.get('https://pomber.github.io/covid19/timeseries.json');
  if (response.statusCode == 200) {
    Map<String, dynamic> myMap = new Map();
    myMap = json.decode(response.body);
    
    void iterateMapEntry(key, value) {
      myMap[key] = value;
      List<dynamic> days = value as List;
      List<Map<String, dynamic>> countryData= [];
      for(Map<String,dynamic> day in days)
      {
        countryData.add(day);
      }
       setState(() {
        countryes.add(new Country(days: countryData,name: "$key"));
      });
    }

    myMap.forEach(iterateMapEntry); 
  } else {
    throw Exception('Failed to load data');
  }
}
  @override
  void initState() {
    fetchAlbum();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff403944),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Covid19",textAlign: TextAlign.center,style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                ),),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text("Choose a country",style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w100
            ),),
            Container(
              margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height*0.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: countryes.length,
                  itemBuilder: (BuildContext context,int index){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CountryDetails(country: countryes[index],)));
                      },
                      child: Card(
                        margin: EdgeInsets.all(5),
                        child:Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(countryes[index].name),
                        )
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
    );
  }
}
