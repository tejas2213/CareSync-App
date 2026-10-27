import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'select_slot_page.dart';

class BookAppointment extends StatefulWidget {
  final String doctorName;
  final String clinicName;
  final String specialty;
  final String doctorImage;
  final String doctorId;

  const BookAppointment({
    super.key,
    required this.doctorName,
    required this.clinicName,
    required this.specialty,
    required this.doctorImage,
    required this.doctorId,
  });

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        child: Container(
          padding: EdgeInsets.only(
              right: screenWidth * 0.04,
              left: screenWidth * 0.04,
              top: screenHeight * 0.04,
              bottom: screenHeight * 0.01),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.3, 0.7, 1.0],
              colors: [
                Color.fromRGBO(97, 206, 255, 1),
                Colors.white,
                Colors.white,
                Color.fromRGBO(14, 190, 126, 1),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button and Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: screenWidth * 0.1,
                      width: screenWidth * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Colors.transparent,
                          border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 1),
                              width: 1)),
                      child: const Icon(
                        size: 30,
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.14),
                  Center(
                    child: Text(
                      "Appointment",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 15, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/Book online doctor appointment.gif",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Doctor Details
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDoctorDetails(screenHeight, screenWidth),
                      // Form Fields
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015),
                        child: Text(
                          "Appointment For",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  label: 'Patient Name',
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  label: 'Contact Number',
                                  controller: numberController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your mobile number';
                                    } else if (!RegExp(r'^\d{10}$')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid 10-digit mobile number';
                                    }
                                    return null;
                                  },
                                ),
                                _buildDateField(screenWidth),
                              ],
                            ),
                          ),
                          // Next Button
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectTime(
                                        patientName: nameController.text.trim(),
                                        number: numberController.text.trim(),
                                        selectedDate:
                                            dateController.text.trim(),
                                        doctorId: widget.doctorId,
                                        doctorName: widget.doctorName,
                                        specialty: widget.specialty,
                                        clinicName: widget.clinicName,
                                        doctorImage: widget.doctorImage,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                margin:
                                    EdgeInsets.only(top: screenHeight * 0.019),
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                alignment: Alignment.center,
                                width: screenWidth * 0.8,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(14, 190, 127, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Next",
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorDetails(double screenHeight, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.03),
      height: screenHeight * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            16), // Increased border radius for smoother corners
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.blue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ), // Subtle gradient for background
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8), // Softer shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: screenHeight * 0.13,
            width: screenWidth * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ], // Shadow for image
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              widget.doctorImage,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center-align content
                children: [
                  Text(
                    "Dr. ${widget.doctorName}",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: screenWidth * 0.05,
                        color: Colors.white,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        widget.clinicName,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_hospital_rounded,
                          size: screenWidth * 0.05, color: Colors.white),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        widget.specialty,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDateField(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: dateController,
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Date',
          labelStyle: const TextStyle(color: Colors.grey),
          suffixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          dateController.text =
              DateFormat('MMMM dd, yyyy').format(pickedDate!);
                },
      ),
    );
  }
}
