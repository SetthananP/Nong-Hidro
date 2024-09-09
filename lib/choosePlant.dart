import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nonghidro/homeScreen.dart';
import 'package:firebase_database/firebase_database.dart';

import 'inputData.dart';

class ChoosePlant extends StatelessWidget {
  ChoosePlant({Key? key, required this.data}) : super(key: key);

  final Map data;

  final List<String> imagePlant = [
    "assets/redOak.jpg",
    "assets/cosLettuce.jpg",
    "assets/GreenOakLettuce.jpg",
    "assets/butterhead.jpg"
  ];

  final List<String> titles = [
    "Red Oak",
    "Green Cos",
    "Green Oak",
    "Butterhead",
  ];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updatePlantData(BuildContext context, String plantType) async {
    Map<String, dynamic> plantData = {};

    switch (plantType) {
      case "Red Oak":
        plantData = {
          'Soil': {'Nitrogen': 120, 'Phosphorus': 50, 'Potassium': 20},
          'Light': {
            'minLux': 20000,
            'maxLux': 40000,
            'offTime': 1,
            'onTime': 6
          },
          'Temperature': {'minTem': 18, 'maxTem': 25},
          'Fan': {'OffTime': 1, 'onTime': 7},
        };
        break;
      case "Green Cos":
        plantData = {
          'Soil': {'Nitrogen': 150, 'Phosphorus': 50, 'Potassium': 20},
          'Light': {
            'minLux': 20000,
            'maxLux': 40000,
            'offTime': 1,
            'onTime': 6
          },
          'Temperature': {'minTem': 18, 'maxTem': 25},
          'Fan': {'OffTime': 1, 'onTime': 7},
        };
        break;
      case "Green Oak":
        plantData = {
          'Soil': {'Nitrogen': 150, 'Phosphorus': 47, 'Potassium': 20},
          'Light': {
            'minLux': 20000,
            'maxLux': 40000,
            'offTime': 1,
            'onTime': 6
          },
          'Temperature': {'minTem': 10, 'maxTem': 24},
          'Fan': {'OffTime': 1, 'onTime': 7},
        };
        break;
      case "Butterhead":
        plantData = {
          'Soil': {'Nitrogen': 130, 'Phosphorus': 49, 'Potassium': 20},
          'Light': {
            'minLux': 20000,
            'maxLux': 40000,
            'offTime': 1,
            'onTime': 6
          },
          'Temperature': {'minTem': 10, 'maxTem': 24},
          'Fan': {'OffTime': 1, 'onTime': 7},
        };
        break;
      default:
        break;
    }

    DocumentReference docRef = firestore.collection('Setup').doc('Plant');

    docRef.update({
      'Name': plantType,
      ...plantData,
    }).then((value) async {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data updated successfully for $plantType.'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamBuilder(
            stream: FirebaseDatabase.instance.ref('realtimeData').onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data!.snapshot.value != null) {
                Map<dynamic, dynamic> realtimeData =
                    Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value);
                return HomeScreen(data: realtimeData);
              } else {
                // Handle loading state or error
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      );
    }).catchError((error) {
      print("Failed to update document: $error");
    });
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
              height: height * 0.18,
              width: width,
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 20,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Color(0xFF013237)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StreamBuilder(
                              stream: FirebaseDatabase.instance
                                  .ref('realtimeData')
                                  .onValue,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData &&
                                    !snapshot.hasError &&
                                    snapshot.data!.snapshot.value != null) {
                                  Map<dynamic, dynamic> realtimeData =
                                      Map<dynamic, dynamic>.from(
                                          snapshot.data!.snapshot.value);
                                  return HomeScreen(data: realtimeData);
                                } else {
                                  // Handle loading state or error
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        );
                      },
                      iconSize: 35,
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        "assets/logo.png",
                        height: 50,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 100,
                    child: Text(
                      "Choose Your Plant.",
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF013237),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      updatePlantData(context, titles[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            imagePlant[index],
                            width: 100,
                          ),
                          Text(
                            titles[index],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Color(0xFF013237),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InputData()),
          );
        },
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Input data your Lettuce',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xFF013237),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
