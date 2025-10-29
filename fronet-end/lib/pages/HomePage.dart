import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../util/smart_device_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double horizontalPadding = 40;
  final double verticalPadding = 10;

  List mySmartDevices = [
    // [ smartDeviceName, iconPath , powerStatus ]
    ["light", "lib/icons/light-bulb.png", true],
    ["fan", "lib/icons/fan.png", false],
  ];

  Future <void> updateDeviceState(apiUrl,data,headers) async{
    print(Uri.parse(apiUrl));
    print(json.encode(data));
    print(headers);

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(data),
    );
    print(response.statusCode);

    }
  void powerSwitchChanged(bool value, int index) {

    setState(() {

      mySmartDevices[index][2] = value;
      print(mySmartDevices[index][2]);
      print(mySmartDevices[index][0]);
      final String apiUrl = 'https://mobile-platform-eidmum11.onrender.com/api/v1/${mySmartDevices[index][0]}';
      final Map<String, String> headers = {
        'Content-Type': 'application/json', // You might need to adjust this based on your API requirements
      };
      final Map<String, dynamic> data = {
        'name': mySmartDevices[index][0],
        'state': mySmartDevices[index][2]?1:0,
        // Add other fields you want to update
      };
      updateDeviceState(apiUrl,data,headers);
      });
      

  }


  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("Home Page"),
      actions: [
        IconButton(onPressed: signOut, icon: Icon(Icons.logout))
      ],

      ),
      drawer: DrawerWidget(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // app bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menu icon
                  Image.asset(
                    'lib/icons/menu.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),

                  // account icon
                  Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.grey[800],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // welcome home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                  Text(
                    'বাপের হোটেল',

                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),

            const SizedBox(height: 25),

            // smart devices grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Smart Devices",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // grid
            Expanded(
              child: GridView.builder(
                itemCount: 2,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  return SmartDeviceBox(
                    smartDeviceName: mySmartDevices[index][0],
                    iconPath: mySmartDevices[index][1],
                    powerOn: mySmartDevices[index][2],
                    onChanged: (value) => powerSwitchChanged(value, index),

                  );
                },
              ),
            )
          ],
        ),
      ),




    );
  }
}
class DrawerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: CircleAvatar(
                    radius: 40, // Adjust the radius as needed
                    backgroundImage: AssetImage('lib/icons/user.webp'), // Replace with your image asset path
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${FirebaseAuth.instance.currentUser?.email}', // Replace with the user's email
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'U_id : ${FirebaseAuth.instance.currentUser?.uid}', // Replace with the user's email
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            title: Text('Temperature'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TemperaturePage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Humidity'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HumidityPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TemperaturePage extends StatefulWidget {
  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  List<Map<String, dynamic>> temperatureData = [];

  Future<void> fetchTemperatureData() async {
    var userId=await FirebaseAuth.instance.currentUser?.uid;
    print('${userId}');
    final response = await http.get(
      Uri.parse('https://mobile-platform-eidmum11.onrender.com/api/v1/temp/${userId}'),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      temperatureData = List<Map<String, dynamic>>.from(jsonResponse);
      setState(() {}); // Update the UI with the fetched data.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (temperatureData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Temperature Data'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: Text('Temperature Data'),
      ),
      body: ListView.builder(
        itemCount: temperatureData.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              "Temperature: ${temperatureData[index]['temp']}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),


                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text('Time: ${temperatureData[index]['time']}'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text('Date: ${temperatureData[index]['date']}'),
                          )
                        ],
                      ),

                    ),
                  )
                ],
              ),

            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchTemperatureData();

  }
}

class HumidityPage extends StatefulWidget {
  @override
  _HumidityPageState createState() => _HumidityPageState();
}

class _HumidityPageState extends State<HumidityPage> {
  List<Map<String, dynamic>> humidityData = [];

  Future<void> fetchHumidityData() async {
    var userId=await FirebaseAuth.instance.currentUser?.uid;
    print('${userId}');
    final response = await http.get(
      Uri.parse('https://mobile-platform-eidmum11.onrender.com/api/v1/humidity/${userId}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      humidityData = List<Map<String, dynamic>>.from(jsonResponse);
      setState(() {}); // Update the UI with the fetched data.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (humidityData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Humidity Data'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Humidity Data'),
      ),
      body: ListView.builder(
        itemCount: humidityData.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              "Humidity: ${humidityData[index]['humidity']}%",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),


                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text('Time: ${humidityData[index]['time']}'),

                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text('Date: ${humidityData[index]['date']}'),

                          ),
                        ],
                      ),

                    ),
                  )
                ],
              ),

            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchHumidityData();
  }
}

