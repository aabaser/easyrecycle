import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For SVG support
import 'package:boltuix/adapter/chat_adapter.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/message.dart';
import 'package:boltuix/utils/tools.dart';
import 'package:boltuix/widgets/circle_image.dart';
import 'package:boltuix/widgets/my_text.dart';

class ChatBackgroundAbstract extends StatefulWidget {
  ChatBackgroundAbstract();

  @override
  ChatBackgroundAbstractState createState() =>
      new ChatBackgroundAbstractState();
}

class ChatBackgroundAbstractState extends State<ChatBackgroundAbstract> {
  bool showSend = false;
  final TextEditingController inputController = new TextEditingController();
  List<Message> items = [];
  late ChatAdapter adapter;

  @override
  void initState() {
    super.initState();
    items.add(Message.time(items.length, "Hai..", false, items.length % 5 == 0,
        Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
    items.add(Message.time(items.length, "Hello!", true, items.length % 5 == 0,
        Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
  }

  @override
  Widget build(BuildContext context) {
    adapter = ChatAdapter(context, items, onItemClick);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleImage(
              imageProvider: AssetImage(Img.get('image_001.png')),
              size: 40,
            ),
            Container(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("John Smith",
                    style:
                        MyText.medium(context).copyWith(color: Colors.black)),
                Container(height: 2),
                Text("Online",
                    style: MyText.caption(context)!
                        .copyWith(color: MyColors.grey_40)),
              ],
            )
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.call_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.attach_file_rounded),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Settings",
                child: Text("Settings"),
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/bg_abstract.svg', // Path to your SVG
            fit: BoxFit.cover, // Ensures the SVG covers the entire screen
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.white
                .withOpacity(0.8), // Overlay with white and reduced opacity
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: adapter.getView(),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 1,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                icon: const Icon(
                                    Icons.sentiment_satisfied_rounded,
                                    color: MyColors.grey_40,
                                    size: 25),
                                onPressed: () {}),
                            Expanded(
                              child: TextField(
                                controller: inputController,
                                maxLines: 1,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Write a message',
                                ),
                                onChanged: (term) {
                                  setState(() {
                                    showSend = (term.length > 0);
                                  });
                                },
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.photo_camera_rounded,
                                    color: Colors.green, size: 25),
                                onPressed: () {}),
                          ],
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      heroTag: "fab1",
                      elevation: 1,
                      mini: true,
                      backgroundColor: Colors.green,
                      child: Icon(
                          showSend ? Icons.send_rounded : Icons.mic_rounded,
                          color: Colors.white),
                      onPressed: () {
                        if (showSend) sendMessage();
                      },
                    ),
                    Container(width: 5),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onItemClick(int index, String obj) {}

  void sendMessage() {
    String message = inputController.text;
    inputController.clear();
    showSend = false;
    setState(() {
      adapter.insertSingleItem(Message.time(
          adapter.getItemCount(),
          message,
          true,
          adapter.getItemCount() % 5 == 0,
          Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
    });
    generateReply(message);
  }

  void generateReply(String msg) {
    Timer(Duration(seconds: 1), () {
      setState(() {
        adapter.insertSingleItem(Message.time(
            adapter.getItemCount(),
            msg,
            false,
            adapter.getItemCount() % 5 == 0,
            Tools.getFormattedTimeEvent(
                DateTime.now().millisecondsSinceEpoch)));
      });
    });
  }
}
