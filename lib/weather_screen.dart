import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weather_app/addtionalinfoitem.dart';
import 'package:weather_app/forecastitem.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/secretData.dart';

/* We can't create future funtion inside the build function
also we can't call that function inside the build function
so call outside of the bild funtion but inside the class
so calling the function should be done with initstate so changed 
to stateful widget so that we can use initstate(). */

/* Steps to get data from API
 
We need http package to get the Api

1.Go to https://pub.dev/packages/http
Copy the version (copy symbol near http
And paste that in pub spec.yaml  
        paste that under sdk (under dependencies) be careful with spacing 
              dependencies:
                flutter:
                  sdk: flutter
                http: ^1.2.2

2. As soon you copy, In http file(website) you will be having one line copy that and
paste in your file. and create a future function.

    import 'package:http/http.dart' as http;    . 

3. After creating future function. call it using initState()

4. Use SetState() to update the data. i.e To update the temp value in screen by rebuild the function.

if we use FutureBuilder() then 3 & 4 is skipped.

5. In future function.
      1. extract the data using http.get(Uri.parse('url'))
      2. convert the data from json format to machine readable using decode.
      */

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // To get the current weather created the future function.

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$secretApiKey'));

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw "An unexpected error occured";
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        /* we can also use gesture dectector but in gesture 
        dectector we need to do padding by ourself. But in IconButton
        its does padding by itself , on presssed method is used 
        to give some effect on pressing the refresh*/

        // setsate is used inside the iconbutton so that when we click on refresh icon. it will rebuild and update the value.
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),

      //wrapped with padding() to give some padding space on all our 3 children.

      /* after we restart the app we can see the current weather with bit of loading time like 
      first we see 0 K then our output. So to avoid that we use loading indicator in that
      bit of loding time -> temp == 0? CircularProgressIndicator() : padding()
      
      Wrap the LinearProgressIndicator() to centre to make loading indicator 
      to load it on centre (before it was on top left corner).

      Use CircularProgressIndicator.adaptive(), .adaptive() is used to make the loading indicator 
      according to its platform (ios/android). 
      
      Instead of loading indicator and lots of cat and throw error
      
      we can use FutureBuilder() where builder has to be declared and builder has context and 
      snapshot. Snapshot means getting status of code - copied old file in notepad and tried with
      FutureBuilder()*/

      body: LayoutBuilder(builder: (context, Constraints) {
        final isSmallScreen = Constraints.maxWidth < 600;
        return FutureBuilder(
          future:
              getCurrentWeather(), // future is similar like setstate. put the variable or method that need to call in future.
          builder: (context, snapshot) {
            //print(snapshot);
            // snapshot has 3 status. 1. connection state 2. data 3. error.

            // 1. if connection status is waiting then show loading indicator.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            // 2. if error occured then show error message.
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            // 3. if data is null then show error message.
            /* if(snapshot.data == null){
              return Text('An unexpected error occured');
            } */
            final currenttemp =
                snapshot.data?['list']?[0]?['main']?['temp'] ?? 0;
            final currentweather =
                snapshot.data?['list'][0]['weather'][0]['main'];
            final currentpressure =
                snapshot.data?['list'][0]['main']['pressure'];
            final currentwind = snapshot.data?['list'][0]['wind']['speed'];
            final currenthumidity =
                snapshot.data?['list'][0]['main']['humidity'];

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. To show current weather condition.
                  // card is used to give some shadow effect to the container.
                  // card has elevation control to give shadow effect.
                  // children is used here since we need 1. Temperature 2. symbol 3. weather condition.
                  // wrapped with sixed box on card() to get maximum width of the card.
                  /* wrapped with padding on column to get some spaces between them. also warp 
                   padding with backdrop filter to give blur effect.*/

                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // 1. Temperature
                              Text(
                                '$currenttemp K',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),

                              // 2. Symbol
                              const SizedBox(
                                height: 20,
                              ),
                              // used ternary operator to show the icon based on the weather condition.
                              Icon(
                                currentweather == 'Clouds' ||
                                        currentweather == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: isSmallScreen ? 48 : 64,
                              ),

                              // 3. Weather condition
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                currentweather,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 2. To show the weather forecast.
                  const SizedBox(
                    height: 20,
                  ), // To give some space between the current weather and forecast.

                  Text(
                    'Hourly Forecast',
                    style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 8,
                  ), // To give some space between the title and the forecast.
                  // 1. need to create a row to show the forecast.
                  // 2. used card effect to give shadow effect.
                  // 3. used column inside row to show the time and weather condition.

                  // 1. this is Row: with 3:00 card.
                  // 2. card (column : 1. time 2. cloud 3. weather).
                  // wrap card with sizes box to get maximum width of the card.
                  // wrap column with padding to get some space between them.
                  /* To make as scrollable wrap the row with SingleChildScrollView. And 
                set scroll direction */

                  /* Since we have used all the column for multiple time we are creating 
                a sperate class for it*/

                  /* SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
        
                      // for loop is used to fetch the data from api for 5 different time.
                      for(int i = 0; i < 6; i++)
                      
        
                      
                      
                      ForecastItem(
                        time: snapshot.data?['list'][i+1]['dt'].toString() ?? '',
                        icon: snapshot.data?['list'][i+1]['weather'][0]['main'] == "Clouds" || snapshot.data?['list'][i+1]['weather'][0]['main'] == "Rain" ? Icons.cloud : Icons.sunny,
                        temp: snapshot.data?['list'][i+1]['main']['temp'].toString() ?? '', 
                      ), // column1
          
                      
                      
                    ],
                  
                  ),
                ),*/

                  // ABOVE CODE IS CHANGE TO LISTVIEW BUILDER TO MAKE IT MORE EFFICIENT.
                  // ListView.builder() is used so that it will lazy load the data when we scroll to right. Instead of loading all the data at once.
                  // itemCount is used to get the number of items to be loaded.
                  // instead of i in for loop we can use index in ListView.builder().

                  SizedBox(
                      height: isSmallScreen ? 125 : 300,
                      child: isSmallScreen
                          ? ListView.builder(
                              itemCount:
                                  40, // itemCount is used to get the number of items to be loaded.
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                // converting string format to datetime format.
                                final time = DateTime.parse(snapshot
                                        .data?['list'][index + 1]['dt_txt']
                                        ?.toString() ??
                                    '');
                                return ForecastItem(
                                  // dt_text has date & time in string format. but we want only time so we are installing new
                                  // package intl same as http package installation.
                                  time: DateFormat.j().format(time),
                                  icon: snapshot.data?['list'][index + 1]
                                                  ['weather'][0]['main'] ==
                                              "Clouds" ||
                                          snapshot.data?['list'][index + 1]
                                                  ['weather'][0]['main'] ==
                                              "Rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  iconsize: isSmallScreen ? 48 : 64,

                                  temp: snapshot.data?['list'][index + 1]
                                              ['main']['temp']
                                          .toString() ??
                                      '',
                                );
                              },
                            )
                          : GridView.builder(
                              itemCount: 39,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,

                                //means each item's width will be 1.25 times its height.
                                mainAxisSpacing: 10, // add space between rows
                                childAspectRatio: 1.25, //width-to-height ratio
                              ), // spacing around each image within its grid.,
                              itemBuilder: (context, index) {
                                // converting string format to datetime format.
                                final time = DateTime.parse(snapshot
                                        .data?['list'][index + 1]['dt_txt']
                                        ?.toString() ??
                                    '');
                                return ForecastItem(
                                  // dt_text has date & time in string format. but we want only time so we are installing new
                                  // package intl same as http package installation.
                                  time: DateFormat.j().format(time),
                                  icon: snapshot.data?['list'][index + 1]
                                                  ['weather'][0]['main'] ==
                                              "Clouds" ||
                                          snapshot.data?['list'][index + 1]
                                                  ['weather'][0]['main'] ==
                                              "Rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  iconsize: isSmallScreen ? 48 : 64,
                                  temp: snapshot.data?['list'][index + 1]
                                              ['main']['temp']
                                          .toString() ??
                                      '',
                                );
                              },
                            )),

                  // 3. To show the Additional weather information.
                  const SizedBox(
                      height:
                          20), // To give some space between the forecast and additional information.

                  Text(
                    'Addtional Information',
                    style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  /*  we can create 3 column(Humidy,Wind speed and pressure) and each 
                column can have 3 row (symbol,name,tempreture) */

                  /* // To give some space between the columns used mainaxis alignment.Instead 
                of using padding. Since padding will give space between the column but if we 
                increase the column then it will go in scroll manner. Whereas mainaxis alignment
                will give equal space between the columns(whatever may be the number of columns). 
                */

                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: isSmallScreen
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceAround, // To give some space between the columns.Instead of using padding.

                              children: [
                                  // column 1. Humidity
                                  AddtionalInfoItem(
                                    icon: Icons.water_drop,
                                    title: 'Humidity',
                                    value: currenthumidity.toString(),
                                  ),
                                  // column 2. Wind speed
                                  AddtionalInfoItem(
                                    icon: Icons.air,
                                    title: 'Wind Speed',
                                    value: currentwind.toString(),
                                  ),
                                  // column 3. Pressure
                                  AddtionalInfoItem(
                                    icon: Icons.beach_access,
                                    title: 'Pressure',
                                    value: currentpressure.toString(),
                                  ),
                                ])
                          : SizedBox(
                              width: 600,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround, // To give some space between the columns.Instead of using padding.

                                  children: [
                                    // column 1. Humidity
                                    AddtionalInfoItem(
                                      icon: Icons.water_drop,
                                      title: 'Humidity',
                                      value: currenthumidity.toString(),
                                    ),
                                    // column 2. Wind speed
                                    AddtionalInfoItem(
                                      icon: Icons.air,
                                      title: 'Wind Speed',
                                      value: currentwind.toString(),
                                    ),
                                    // column 3. Pressure
                                    AddtionalInfoItem(
                                      icon: Icons.beach_access,
                                      title: 'Pressure',
                                      value: currentpressure.toString(),
                                    ),
                                  ]),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}


 /* Since we have used all the row for multiple time we are creating 
            a sperate class for it on spearate dart file*/
/*
class AddtionalInfoItem extends StatelessWidget {
  const AddtionalInfoItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Row 1 -> symbol. 
      Icon(Icons.water_drop, size: 35,),
      const SizedBox(height: 8,),
      // Row 2 -> name.
      Text('Humidity',
      style: TextStyle(
        fontSize: 20,                  
      ),),
      const SizedBox(height: 8,),
      // Row 3 -> tempreture.
      Text('94',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold                  
      ),),
    ],);
  }
} 
*/


 /* Since we have used all the row for multiple time we are creating 
            a sperate class for it on spearate dart file*/

 /*            
class ForecastItem extends StatelessWidget {
  const ForecastItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(21),
                        child: Column(
                          children: [
                        
                            // column 1. Time
                            Text('3:00',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),),
                            
                            // column 2. Cloud
                            const SizedBox(height: 8,),
                            Icon(Icons.cloud, size:32),
                        
                            // column 3. Weather
                            const SizedBox(height: 8,),
                            Text('301.17'),
                        
                        
                          ],
                          
                        ),
                      ),
                    );
  }
} */