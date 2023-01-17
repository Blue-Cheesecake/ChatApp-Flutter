import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final Stream<QuerySnapshot> _messages;

  @override
  void initState() {
    // TODO: implement initState
    _messages = FirebaseFirestore.instance
        .collection("chats/GkCfFuTyS8kEU7qhNOAU/messages")
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // List of message
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _messages,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // snapshot.data?.docs.forEach((element) {
            //   print((element.data() as Map<String, dynamic>)['text']);
            // });
            // print(snapshot.hasData);

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text("Error");
            }

            List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(8),
                child:
                    Text((docs[index].data() as Map<String, dynamic>)['text']),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.add),
      ),
    );
  }
}
