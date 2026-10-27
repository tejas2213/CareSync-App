
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, String> chatData; // Contains patientId, doctorId, and doctorName

  const ChatScreen({
    super.key,
    required this.chatData,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  late final String patientId;
  late final String doctorId;
  late final String doctorName;

  @override
  void initState() {
    super.initState();
    // Initialize chat data
    patientId = widget.chatData['patientId'] ?? '';
    doctorId = widget.chatData['doctorId'] ?? '';
    doctorName = widget.chatData['name'] ?? '';

    // Debugging the initialized data
    debugPrint("Initialized Chat Data:");
    debugPrint("Patient ID: $patientId");
    debugPrint("Doctor ID: $doctorId");
    debugPrint("Doctor Name: $doctorName");
    debugPrint("Chat ID: $_chatId");

    // Validate the IDs
    if (patientId.isEmpty || doctorId.isEmpty) {
      debugPrint("Error: Either patientId or doctorId is empty.");
    }
  }

  String get _chatId => '${patientId}_$doctorId';

  Stream<QuerySnapshot> _chatStream() {
  // Debugging the chat path
  final path = 'chats/$_chatId/messages';
  debugPrint("Fetching messages from: $path");

  return _firestore
      .collection(path)
      .orderBy('timestamp', descending: true)
      .snapshots();
}


  Future<void> _sendMessage(String text) async {
  if (text.trim().isEmpty) return;

  try {
    final path = 'chats/$_chatId/messages';
    debugPrint("Sending message to: $path");

    await _firestore.collection(path).add({
      'senderId': patientId,
      'receiverId': doctorId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _messageController.clear();
  } catch (e) {
    debugPrint("Error sending message: $e");
  }
}
 
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(doctorName, style: GoogleFonts.poppins()),
      //   backgroundColor: Color.fromRGBO(97, 206, 255, 1),
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
                    "Dr. $doctorName",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            // Message list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint("Stream error: ${snapshot.error}");
                    return const Center(child: Text("Failed to load messages"));
                  }
        
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  final messages = snapshot.data!.docs;
                  if (messages.isEmpty) {
                    return Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/json/noOrder.json",height: 70),
                        const SizedBox(height: 10,),
                        Text("No messages yet",style: GoogleFonts.poppins(color: Colors.black),),
                      ],
                    ));
                  }
        
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSent = message['senderId'] == patientId;
        
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
                            message['text'] ?? '',
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
