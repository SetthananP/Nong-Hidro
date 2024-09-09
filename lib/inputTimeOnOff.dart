import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nonghidro/HomeScreen.dart';

class InputTimeLightandFan extends StatefulWidget {
  const InputTimeLightandFan({super.key});

  @override
  State<InputTimeLightandFan> createState() => _InputTimeLightandFanState();
}

class _InputTimeLightandFanState extends State<InputTimeLightandFan> {
  RangeValues valuesLight = const RangeValues(1, 10);
  RangeValues valuesFan = const RangeValues(1, 10);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    RangeLabels labelsLight = RangeLabels(
      '${valuesLight.start.toInt()}',
      '${valuesLight.end.toInt()}',
    );

    RangeLabels labelsFan = RangeLabels(
      '${valuesFan.start.toInt()}',
      '${valuesFan.end.toInt()}',
    );

    return Scaffold(
      backgroundColor: Color(0xFFEAF9E7),
      body: Container(
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
                            builder: (context) => HomeScreen(
                              data: {},
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
                      "Set Light and Fans Time",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF013237),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 590,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Off Light & On Light",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Color(0xFF013237),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "(Off 1 hour - On 10 hour)",
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Color(0xFF013237),
                          fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: RangeSlider(
                        values: valuesLight,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        labels: labelsLight,
                        activeColor: Color(0xFF013237),
                        onChanged: (newValues) {
                          setState(() {
                            valuesLight = newValues;
                            labelsLight = RangeLabels(
                              '${valuesLight.start.toInt()}',
                              '${valuesLight.end.toInt()}',
                            );
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Off Fans & On Fans",
                      style: GoogleFonts.poppins(
                          fontSize: 20, color: Color(0xFF013237)),
                    ),
                    Text(
                      "Off 1 hour - On 10 hour",
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Color(0xFF013237),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: RangeSlider(
                        values: valuesFan,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        labels: labelsFan,
                        activeColor: Color(0xFF013237),
                        onChanged: (newTemValues) {
                          setState(() {
                            valuesFan = newTemValues;
                            labelsFan = RangeLabels(
                              '${valuesFan.start.toInt()}',
                              '${valuesFan.end.toInt()}',
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Color(0xFFEAF9E7),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF013237),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  if (valuesLight.end >= valuesLight.start &&
                      valuesFan.end >= valuesFan.start) {
                    DocumentReference docRef = FirebaseFirestore.instance
                        .collection('Setup')
                        .doc('Plant');

                    docRef.update({
                      'Light': {
                        'offTime': valuesLight.start.toInt(),
                        'onTime': valuesLight.end.toInt(),
                      },
                      'Fan': {
                        'offTime': valuesFan.start.toInt(),
                        'onTime': valuesFan.end.toInt(),
                      },
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Send Data Successful.'),
                          duration: Duration(seconds: 2),
                        ),
                      );

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
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      );
                    }).catchError((error) {
                      print("Failed to update document: $error");
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please input valid data.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text(
                  'Send Data',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
