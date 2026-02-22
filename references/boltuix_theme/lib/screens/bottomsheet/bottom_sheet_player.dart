import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/grid_music_album.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/model/music_album.dart';
import 'package:get/get.dart';

class BottomSheetPlayer extends StatefulWidget {
  @override
  BottomSheetPlayerState createState() => new BottomSheetPlayerState();
}

class BottomSheetPlayerState extends State<BottomSheetPlayer> {
  late BuildContext _scaffoldCtx;
  bool showSheet = false;
  late List<MusicAlbum> items;

  void onItemClick(int index, MusicAlbum obj) {
    // Handle item click
  }

  @override
  void initState() {
    super.initState();
    items = Dummy.getMusicAlbum();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCustomSheet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0.0,
        title: Text(
          "Albums",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Builder(builder: (BuildContext ctx) {
        _scaffoldCtx = ctx;
        return GridMusicAlbum(items, onItemClick).getView();
      }),
    );
  }

  var expand = false.obs;

  void showCustomSheet() {
    showBottomSheet(
      context: _scaffoldCtx,
      elevation: 10,
      backgroundColor: Colors.white,
      builder: (BuildContext bc) {
        return Wrap(
          children: [
            Container(
              height: 4,
              color: Colors.green[50],
              child: LinearProgressIndicator(
                value: 0.4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                backgroundColor: Colors.green[100],
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[700]!, Colors.green[400]!],
                ),
              ),
              child: Row(
                children: [
                  Container(width: 3),
                  IconButton(
                    icon: Obx(
                      () => Icon(
                        expand.value
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      expand.value = !expand.value;
                    },
                  ),
                  Container(width: 5),
                  Text(
                    "Calm Waters",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "-1:20",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Container(width: 10),
                  IconButton(
                    icon: Icon(Icons.pause_circle_rounded, color: Colors.white),
                    onPressed: () {},
                  ),
                  Container(width: 10),
                ],
              ),
            ),
            Obx(
              () => expand.value
                  ? Column(
                      children: [
                        SizedBox(height: 10),
                        _buildSongRow("01", "Whisper of the Forest", "5:05"),
                        _buildSongRow("02", "Echoes of Serenity", "3:36",
                            isCurrent: true),
                        _buildSongRow("03", "Harmony in the Breeze", "3:50"),
                        _buildSongRow("04", "Tranquil Nights", "2:48"),
                        SizedBox(height: 10),
                      ],
                    )
                  : Container(height: 0),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSongRow(String number, String title, String duration,
      {bool isCurrent = false}) {
    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            number,
            style: TextStyle(
                color: isCurrent ? Colors.green[800] : Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              color: isCurrent ? Colors.green[800] : Colors.grey[600],
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Spacer(),
          Text(
            duration,
            style: TextStyle(
                color: isCurrent ? Colors.green[800] : Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.equalizer_rounded,
                color: isCurrent ? Colors.green : Colors.grey[400]),
            onPressed: () {},
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
