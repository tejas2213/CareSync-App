// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class DoctorChatScreen extends StatefulWidget {
//   final String doctorId;
//   final String patientId;
//   final String patientName;

//   const DoctorChatScreen({
//     super.key,
//     required this.doctorId,
//     required this.patientId,
//     required this.patientName,
//   });

//   @override
//   State<DoctorChatScreen> createState() => _DoctorChatScreenState();
// }

// class _DoctorChatScreenState extends State<DoctorChatScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _messageController = TextEditingController();

//   String get _chatId => '${widget.patientId}_${widget.doctorId}';

//   Stream<QuerySnapshot> _chatStream() {
//     return _firestore
//         .collection('chats/$_chatId/messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }

//   Future<void> _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;

//     await _firestore.collection('chats/$_chatId/messages').add({
//       'senderId': widget.doctorId,
//       'receiverId': widget.patientId,
//       'text': text,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//     _messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.patientName, style: GoogleFonts.poppins()),
//         backgroundColor: const Color(0xFF4A49E8),
//       ),
//       body: Column(
//         children: [
//           // Chat messages
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _chatStream(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final messages = snapshot.data!.docs;
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     final isSent = message['senderId'] == widget.doctorId;
//                     return Align(
//                       alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: isSent ? const Color(0xFF4A49E8) : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           message['text'],
//                           style: GoogleFonts.poppins(color: isSent ? Colors.white : Colors.black),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // Message input
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Color(0xFF4A49E8)),
//                   onPressed: () => _sendMessage(_messageController.text),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class DoctorChatScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;
  final String patientName;

  const DoctorChatScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  String get _chatId => '${widget.patientId}_${widget.doctorId}';

  Stream<QuerySnapshot> _chatStream() {
    log('----chat id -> $_chatId');
    return _firestore
        .collection('chats/$_chatId/messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    try {
      await _firestore.collection('chats/$_chatId/messages').add({
        'senderId': widget.doctorId,
        'receiverId': widget.patientId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    } catch (e) {
      debugPrint("Error sending message: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.patientName, style: GoogleFonts.poppins()),
      //   backgroundColor: const Color(0xFF4A49E8),
      // ),
      body: Container(
        padding: EdgeInsets.only(
              right: screenWidth * 0.04,
              left: screenWidth * 0.04,
              top: screenHeight * 0.05,
              bottom: screenHeight * 0.01),
          width: double.infinity,
          height: double.infinity,
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
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: screenWidth * 0.1,
                    width: screenWidth * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: Colors.transparent,
                        border: Border.all(
                            color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
                    child: const Icon(
                      size: 30,
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Center(
                  child: Text(
                    widget.patientName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top:8),
              height:screenHeight*0.0006,
              color: Colors.black
            ),
            // Chat messages
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
        
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return  Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/json/noOrder.json",height: 70),
                        const SizedBox(height: 10,),
                        Text("No messages yet",style: GoogleFonts.poppins(color: Colors.black),),
                      ],
                    ));
                  }
        
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSent = message['senderId'] == widget.doctorId;
                      return Align(
                        alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSent ? const Color(0xFF4A49E8) : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message['text'],
                            style: GoogleFonts.poppins(
                                color: isSent ? Colors.white : Colors.black),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        
            // Message input
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
