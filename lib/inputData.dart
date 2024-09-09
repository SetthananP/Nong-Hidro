import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'choosePlant.dart';
import 'homeScreen.dart';

class InputData extends StatefulWidget {
  const InputData({Key? key}) : super(key: key);

  @override
  _InputDataState createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  RangeValues values = const RangeValues(10000, 40000);
  RangeValues valuesTem = const RangeValues(0, 40);

  final nameController = TextEditingController();
  final nitrogenNumberController = TextEditingController();
  final phosphorusNumberController = TextEditingController();
  final potassiumNumberController = TextEditingController();

  bool isNumericAndNonNegative(String? value) {
    if (value == null) {
      return false;
    }
    double? number = double.tryParse(value);
    return number != null && number >= 0;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    RangeLabels labels = RangeLabels(
      '${values.start.toInt()}',
      '${values.end.toInt()}',
    );

    RangeLabels labelsTem = RangeLabels(
      '${valuesTem.start.toInt()}',
      '${valuesTem.end.toInt()}',
    );

    return Scaffold(
      backgroundColor: Color(0xFFEAF9E7),
      body: Container(
        color: Color(0xFFEAF9E7),
        child: SingleChildScrollView(
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
                              builder: (context) => ChoosePlant(
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
                        "Input Data",
                        style: GoogleFonts.poppins(
                          fontSize: 30,
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
                      Text(
                        'Name',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color(0xFF013237),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Ex. Red Coral',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Light Range(10000-40000)",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color(0xFF013237),
                        ),
                      ),
                      Center(
                        child: RangeSlider(
                          values: values,
                          min: 10000,
                          max: 40000,
                          divisions: 12,
                          labels: labels,
                          activeColor: Color(0xFF013237),
                          onChanged: (newValues) {
                            setState(() {
                              values = newValues;
                              labels = RangeLabels(
                                '${values.start.toInt()}',
                                '${values.end.toInt()}',
                              );
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Temperature Range(0-40)",
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Color(0xFF013237)),
                      ),
                      Center(
                        child: RangeSlider(
                          values: valuesTem,
                          divisions: 8,
                          min: 0,
                          max: 40,
                          labels: labelsTem,
                          activeColor: Color(0xFF013237),
                          onChanged: (newTemValues) {
                            setState(() {
                              valuesTem = newTemValues;
                              labelsTem = RangeLabels(
                                '${valuesTem.start.toInt()}',
                                '${valuesTem.end.toInt()}',
                              );
                            });
                          },
                        ),
                      ),
                      buildNumericFormField(
                        label: 'Nitrogen number',
                        controller: nitrogenNumberController,
                        hintText: 'Ex. 0-150',
                        errorText: isNumericAndNonNegative(
                                nitrogenNumberController.text)
                            ? null
                            : '*Nitrogen value must be a number.',
                      ),
                      buildNumericFormField(
                        label: 'Phosphorus number',
                        controller: phosphorusNumberController,
                        hintText: 'Ex. 0-20',
                        errorText: isNumericAndNonNegative(
                                phosphorusNumberController.text)
                            ? null
                            : '*Phosphorus value must be a number.',
                      ),
                      buildNumericFormField(
                        label: 'Potassium number',
                        controller: potassiumNumberController,
                        hintText: 'Ex. 0-50',
                        errorText: isNumericAndNonNegative(
                                potassiumNumberController.text)
                            ? null
                            : '*Potassium value must be a number.',
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    String plantName = nameController.text.trim();
                    String nitrogenValue = nitrogenNumberController.text.trim();
                    String phosphorusValue =
                        phosphorusNumberController.text.trim();
                    String potassiumValue =
                        potassiumNumberController.text.trim();

                    if (plantName.isNotEmpty &&
                        isNumericAndNonNegative(nitrogenValue) &&
                        isNumericAndNonNegative(phosphorusValue) &&
                        isNumericAndNonNegative(potassiumValue)) {
                      int nitrogen = int.parse(nitrogenValue);
                      int phosphorus = int.parse(phosphorusValue);
                      int potassium = int.parse(potassiumValue);

                      DocumentReference docRef = FirebaseFirestore.instance
                          .collection('Setup')
                          .doc('Plant');
                      Map<String, dynamic> soilData = {
                        'Nitrogen': nitrogen,
                        'Phosphorus': phosphorus,
                        'Potassium': potassium,
                      };

                      docRef.update({
                        'Name': plantName,
                        'Soil': soilData,
                        'Light': {
                          'minLux': values.start.toInt(),
                          'maxLux': values.end.toInt(),
                        },
                        'Temperature': {
                          'minTem': valuesTem.start.toInt(),
                          'maxTem': valuesTem.end.toInt(),
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

                        nameController.clear();
                        nitrogenNumberController.clear();
                        phosphorusNumberController.clear();
                        potassiumNumberController.clear();
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
      ),
    );
  }

  Widget buildNumericFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Color(0xFF013237),
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            errorText: controller.text.isEmpty ? null : errorText,
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    nitrogenNumberController.dispose();
    phosphorusNumberController.dispose();
    potassiumNumberController.dispose();
    super.dispose();
  }
}
