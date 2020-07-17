class Country{
  String name;
  List<Map<String, dynamic>> days;
  
  Country({this.name,this.days});

  int getDeaths(){
    int _deaths = 0;
    _deaths = days[days.length-1]["deaths"];
    return _deaths;
  }

  int getConfirmed(){
    int _confirmed = 0;
    _confirmed = days[days.length-1]["confirmed"];
    return _confirmed;
  }

  int getRecovered(){
    int _recovered;
    _recovered = days[days.length-1]["recovered"];
    return _recovered;
  }

  List<Map<String, dynamic>> getData(){
    List<Map<String, dynamic>> _days = [];
    for(var day in days){
      if(day['confirmed'] >0)
      _days.add(day);
    }
    return _days;
  }

  List<Map<String, dynamic>> getDays(){
    return days;
  }
}