import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nonghidro/choosePlant.dart';
import 'package:nonghidro/inputTimeOnOff.dart';

class HomeScreen extends StatefulWidget {
  final dynamic data;

  const HomeScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _pumpButtonColor = Colors.red;

  Future<void> _updatePumpStatus() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Setup')
          .doc('Plant')
          .get();

      if (docSnapshot.exists) {
        bool currentStatus = docSnapshot['pumpStatus'];
        await FirebaseFirestore.instance
            .collection('Setup')
            .doc('Plant')
            .update({'pumpStatus': !currentStatus});
        print('Pump status updated to ${!currentStatus}');

        setState(() {
          _pumpButtonColor = currentStatus ? Colors.red : Color(0xFF013237);
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error updating pump status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Color(0xFFEAF9E7),
        child: Column(
          children: [
            Container(
              height: height * 0.25,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 20),
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InputTimeLightandFan(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.access_time,
                              size: 35,
                              color: Color(0xFF013237),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChoosePlant(
                                    data: {},
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 35,
                              color: Color(0xFF013237),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                "This is",
                                style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF013237),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Information.",
                                style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF013237),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Image.asset(
                            "assets/bg.png",
                            height: 105,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                height: height * 0.75,
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Setup')
                            .doc('Plant')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> firestoreSnapshot) {
                          if (firestoreSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: SizedBox.shrink());
                          }

                          if (firestoreSnapshot.hasError) {
                            return Center(
                                child:
                                    Text('Error: ${firestoreSnapshot.error}'));
                          }

                          if (firestoreSnapshot.hasData &&
                              firestoreSnapshot.data!.exists) {
                            Map<String, dynamic> plantData =
                                firestoreSnapshot.data!.data()
                                    as Map<String, dynamic>;

                            final int maxTemperature =
                                plantData['Temperature']['maxTem'] ?? 0;
                            final int minTemperature =
                                plantData['Temperature']['minTem'] ?? 0;
                            final int maxLight =
                                plantData['Light']['maxLux'] ?? 0;
                            final int minLight =
                                plantData['Light']['minLux'] ?? 0;

                            return Center(
                              child: StreamBuilder(
                                stream: FirebaseDatabase.instance
                                    .ref('realtimeData')
                                    .onValue,
                                builder: (context,
                                    AsyncSnapshot<DatabaseEvent> snapshot) {
                                  if (snapshot.hasData &&
                                      !snapshot.hasError &&
                                      snapshot.data!.snapshot.value != null) {
                                    Map<dynamic, dynamic> realtimeData =
                                        Map<dynamic, dynamic>.from(snapshot
                                            .data!.snapshot.value as Map);

                                    int temperature =
                                        (realtimeData['Temperature'] as num)
                                            .toInt();
                                    int light =
                                        (realtimeData['Lux'] as num).toInt();
                                    int humidity =
                                        (realtimeData['Humidity'] ?? 0).toInt();
                                    int water =
                                        (realtimeData['Water'] ?? 0).toInt();

                                    Color temperatureColor =
                                        _getTemperatureColor(temperature,
                                            maxTemperature, minTemperature);
                                    Color lightColor = _getLightColor(
                                        light, maxLight, minLight);
                                    Color waterColor = _getWaterColor(water);

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: 20,
                                          runSpacing: 30,
                                          children: [
                                            SizedBox(
                                              width: 160,
                                              height: 160,
                                              child: sensorCard(
                                                'Brightness',
                                                light,
                                                Icons.wb_sunny,
                                                lightColor,
                                                "LX",
                                              ),
                                            ),
                                            SizedBox(
                                              width: 160,
                                              height: 160,
                                              child: sensorCard(
                                                'Temperature',
                                                temperature,
                                                Icons.thermostat,
                                                temperatureColor,
                                                "°C",
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Wrap(
                                          spacing: 20,
                                          runSpacing: 30,
                                          children: [
                                            SizedBox(
                                              width: 160,
                                              height: 160,
                                              child: sensorCard(
                                                'Humidity',
                                                humidity,
                                                null,
                                                Color(0xFF013237),
                                                "%",
                                                imagePath:
                                                    'assets/raindrop.png',
                                              ),
                                            ),
                                            SizedBox(
                                              width: 160,
                                              height: 160,
                                              child: sensorCard(
                                                'Water Level',
                                                water,
                                                null,
                                                waterColor,
                                                "Liter",
                                                imagePath:
                                                    'assets/water-level.png',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                },
                              ),
                            );
                          }

                          return SizedBox.shrink();
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Soil Nutrient Levels:",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF013237),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      StreamBuilder(
                        stream: FirebaseDatabase.instance
                            .ref('realtimeData')
                            .onValue,
                        builder:
                            (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                          if (snapshot.hasData &&
                              !snapshot.hasError &&
                              snapshot.data!.snapshot.value != null) {
                            Map<dynamic, dynamic> realtimeData =
                                Map<dynamic, dynamic>.from(
                                    snapshot.data!.snapshot.value as Map);

                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Setup')
                                  .doc('Plant')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot>
                                      firestoreSnapshot) {
                                if (firestoreSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                }

                                if (firestoreSnapshot.hasError) {
                                  return Text(
                                      'Error: ${firestoreSnapshot.error}');
                                }

                                if (firestoreSnapshot.hasData &&
                                    firestoreSnapshot.data!.exists) {
                                  Map<String, dynamic> plantData =
                                      firestoreSnapshot.data!.data()
                                          as Map<String, dynamic>;

                                  int cloudNitrogen =
                                      plantData['Soil']['Nitrogen'];
                                  int realtimeNitrogen =
                                      realtimeData['Soil']['Nitrogen'] ?? 0;

                                  int cloudPhosphorus =
                                      plantData['Soil']['Phosphorus'];
                                  int realtimePhosphorus =
                                      realtimeData['Soil']['Phosphorus'] ?? 0;

                                  int cloudPotassium =
                                      plantData['Soil']['Potassium'];
                                  int realtimePotassium =
                                      realtimeData['Soil']['Potassium'] ?? 0;

                                  Color textColor =
                                      realtimeNitrogen < cloudNitrogen
                                          ? Colors.red
                                          : Color(0xFF013237);

                                  Color textColorPhos =
                                      realtimePhosphorus < cloudPhosphorus
                                          ? Colors.red
                                          : Color(0xFF013237);

                                  Color textColorPotass =
                                      realtimePotassium < cloudPotassium
                                          ? Colors.red
                                          : Color(0xFF013237);

                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nitrogen: $realtimeNitrogen',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            color: textColor,
                                          ),
                                        ),
                                        Text(
                                          'Phosphorus: $realtimePhosphorus',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            color: textColorPhos,
                                          ),
                                        ),
                                        Text(
                                          'Potassium: $realtimePotassium',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            color: textColorPotass,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return SizedBox.shrink();
                              },
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updatePumpStatus,
        backgroundColor: _pumpButtonColor,
        child: Icon(Icons.water_drop, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget sensorCard(
      String title, dynamic value, IconData? icon, Color color, String unit,
      {String? imagePath}) {
    String displayValue =
        value is num ? "${value.toInt()} $unit" : "$value $unit";

    Color iconColor = icon == Icons.wb_sunny ? Colors.yellow : Colors.blue;

    return SizedBox(
      width: 160,
      height: 160,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imagePath != null
                    ? Image.asset(
                        imagePath,
                        width: 55,
                        height: 55,
                      )
                    : Icon(icon, color: iconColor, size: 55),
                SizedBox(height: 10),
                Text(
                  displayValue,
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTemperatureColor(int temperature, int maxTemp, int minTemp) {
    if (temperature > maxTemp) {
      return Colors.red;
    } else if (temperature < minTemp) {
      return Color(0xFF013237);
    } else {
      return Color(0xFF013237);
    }
  }

  Color _getLightColor(int light, int maxLight, int minLight) {
    if (light > maxLight) {
      return Color(0xFF013237);
    } else if (light < minLight) {
      return Colors.red;
    } else {
      return Color(0xFF013237);
    }
  }

  Color _getWaterColor(int water) {
    if (water < 1) {
      return Colors.red;
    } else if (water > 4) {
      return Color(0xFF013237);
    } else {
      return Color(0xFF013237);
    }
  }
}
