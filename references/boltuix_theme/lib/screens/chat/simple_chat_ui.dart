import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/simple_chat_ui_adapter.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/message.dart';
import 'package:boltuix/utils/tools.dart';
import 'package:boltuix/widgets/my_text.dart';

class SimpleChatUI extends StatefulWidget {
  SimpleChatUI();

  @override
  SimpleChatUIState createState() => new SimpleChatUIState();
}

class SimpleChatUIState extends State<SimpleChatUI> {
  bool showSend = false;
  final TextEditingController inputController = new TextEditingController();
  List<Message> items = [];
  late SimpleChatUIAdapter adapter;

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
    adapter = SimpleChatUIAdapter(context, items, onItemClick);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.green,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("John Smith",
                  style: MyText.medium(context).copyWith(color: Colors.white)),
              Container(height: 2),
              Text("Active now",
                  style: MyText.caption(context)!
                      .copyWith(color: MyColors.grey_10)),
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
                icon: const Icon(Icons.videocam_rounded), onPressed: () {}),
            IconButton(icon: const Icon(Icons.call_rounded), onPressed: () {}),
            IconButton(icon: const Icon(Icons.info_rounded), onPressed: () {}),
          ]),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: adapter.getView(),
            ),
            Divider(height: 2, color: Colors.limeAccent),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.text_format_rounded,
                        color: MyColors.grey_40, size: 25),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.image_rounded,
                        color: MyColors.grey_40, size: 25),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.camera_alt_rounded,
                        color: MyColors.grey_40, size: 25),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.emoji_emotions_rounded,
                        color: MyColors.grey_40, size: 25),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.mic_none_rounded,
                        color: MyColors.grey_40, size: 25),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.attach_file_rounded,
                        color: MyColors.grey_40, size: 25),
                    onPressed: () {}),
              ],
            ),
            Row(
              children: <Widget>[
                Container(width: 10),
                Expanded(
                  child: TextField(
                    controller: inputController,
                    maxLines: 1,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: new InputDecoration.collapsed(
                        hintText: 'Write a message...'),
                    onChanged: (term) {
                      setState(() {
                        showSend = (term.length > 0);
                      });
                    },
                  ),
                ),
                IconButton(
                    icon: Icon(
                        showSend ? Icons.send_rounded : Icons.thumb_up_rounded,
                        color: Colors.green,
                        size: 20),
                    onPressed: () {
                      if (showSend) sendMessage();
                    }),
              ],
            ),
          ],
        ),
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
