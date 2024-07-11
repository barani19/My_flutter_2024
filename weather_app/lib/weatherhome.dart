import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additionalinfo.dart';
import 'package:weather_app/mycard.dart';

import 'package:http/http.dart' as http;

class weatherhome extends StatefulWidget {
  const weatherhome({super.key});

  @override
  State<weatherhome> createState() => _weatherhomeState();
}

class _weatherhomeState extends State<weatherhome> {

  @override
  void initState() {
    super.initState();
    getCurrentweather();
  }

  Future<Map<String,dynamic>> getCurrentweather() async{
    try{
     
    final res = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=India,puducherry&APPID=9639e72826f8596dfc154875c5adc5f0'));

      final data = jsonDecode(res.body);

      if(data['cod']!='200'){
        throw 'An error occured at me';
      }
      return data;
    }
    catch(e){
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            )),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentweather(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return LinearProgressIndicator();
          }    

          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          if(!snapshot.hasData){
            return Center(child: Text(snapshot.error.toString()));
          }

       final data = snapshot.data!;
       final currentemp = data['list'][0]['main']['temp'];
       final climate = data['list'][0]['weather'][0]['main'];
       final humidity = data['list'][0]['main']['humidity'];
       final wind = data['list'][0]['wind']['speed'];
       final pressure = data['list'][0]['main']['pressure'];

        return  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child: Column(
                          children: [
                            Text('$currentemp k',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            Icon(climate == 'Clouds'?Icons.cloud: climate=='Rain' ?Icons.cloudy_snowing: Icons.sunny,size: 30),
                            SizedBox(height: 10,),
                            Text('$climate',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Text('Hourly Forecast',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       Mycard(
              //         time: '09:00',
              //         icon: Icons.cloud,
              //         temp: '300.2',
              //       ),
              //       Mycard(
              //         time: '09:00',
              //         icon: Icons.cloud,
              //         temp: '300.2',
              //       ),
              //        Mycard(
              //         time: '09:00',
              //         icon: Icons.cloud,
              //         temp: '300.2',
              //       ),
              //        Mycard(
              //         time: '09:00',
              //         icon: Icons.cloud,
              //         temp: '300.2',
              //       ),
              //        Mycard(
              //         time: '09:00',
              //         icon: Icons.cloud,
              //         temp: '300.2',
              //       ),
              //        Mycard(
              //         time: '09:00',
              //         icon: Icons.cloud,
              //         temp: '300.2',
              //       ),
              //        Mycard(
              //         time: '09:00',
              //         icon: Icons.cloud,
              //         temp: '300.2',
              //       ),
              //        Mycard(
              //         time: '09:00',
              //         icon: Icons.cloud,
              //         temp: '300.2',
              //       ),
              //        Mycard(
              //         time: '09:00',
              //         icon: Icons.cloud,
              //         temp: '300.2',
              //       ),
              //        Mycard(
              //         time: '09:00',
              //         icon: Icons.cloud,
              //         temp: '300.2',
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: data['list'].length-1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    final time = data['list'][index+1]['dt_txt'];
                    final weather = data['list'][index+1]['weather'][0]['main'];
                    final temp = data['list'][index+1]['main']['temp'].toString();
                    final realtiem = DateTime.parse(time.toString());
                     return Mycard(
                      time: DateFormat('j').format(realtiem), 
                      icon: weather == 'Clouds'?Icons.cloud: weather=='Rain' ?Icons.cloudy_snowing: Icons.sunny,
                       temp: temp
                       );
                  }
                  ),
              ),
              SizedBox(height: 10,),
              Text('Additional Information',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  additionalinfo(
                    logo: Icons.water_drop,
                    climate: 'Humidty',
                    temp: '$humidity',
                  ),
                  additionalinfo(
                    logo: Icons.air,
                    climate: 'Wind speed',
                    temp: '$wind',
                  ),
                  additionalinfo(
                    logo: Icons.beach_access,
                    climate: 'Pressure',
                    temp: '$pressure',
                  ),
                ],
              )
            ],
          ),
        );
        },
      ),
    );
  }
}


