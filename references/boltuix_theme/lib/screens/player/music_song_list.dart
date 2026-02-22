import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'circular_album_music_player.dart';

class MusicSongList extends StatefulWidget {
  @override
  MusicSongListState createState() => new MusicSongListState();
}

class MusicSongListState extends State<MusicSongList> {
  double value1 = 0.4;

  void onItemClick(int index, MusicSong obj) {
    MyToast.show(obj.title, context, duration: MyToast.LENGTH_SHORT);
    // Navigate to a music player screen (mock)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CircularAlbumMusicPlayer(
          title: obj.title,
          artist: obj.brief,
          albumImage: 'assets/images/${obj.image}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<MusicSong> items = getMusicSong();
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: Text("Today's Hits"),
        leading: IconButton(
          icon: Icon(Icons.menu_rounded),
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset('assets/images/${items[index].image}',
                      fit: BoxFit.cover),
                  title: Text(items[index].title),
                  subtitle: Text(items[index].brief),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite_border_rounded),
                    color: Colors.green, // Set the icon color to green
                    onPressed: () {
                      // Handle heart icon press
                    },
                  ),
                  onTap: () => onItemClick(index, items[index]),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors
                      .green[100], // Very light green color for the divider
                  thickness: 1,
                );
              },
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.all(0),
            elevation: 10,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.expand_less_rounded,
                        color: Colors.green[900]),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Echo of the Sea",
                            style: TextStyle(
                                color: Colors.green[900],
                                fontWeight: FontWeight.bold)),
                        Container(height: 5),
                        Text("Calm Horizons",
                            style: TextStyle(color: Colors.green[700])),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.play_arrow_rounded,
                        color: Colors.green[900]),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 6, // Double the height of the progress indicator
            child: LinearProgressIndicator(
              value: value1,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[500]!),
              backgroundColor: Colors.green[100],
            ),
          ),
        ],
      ),
    );
  }

  List<MusicSong> getMusicSong() {
    List<MusicSong> items = [];
    for (int i = 0; i < album_cover.length; i++) {
      MusicSong obj = new MusicSong();
      obj.image = album_cover[i];
      obj.title = song_name[i];
      obj.brief = album_name[i];
      items.add(obj);
    }
    items.shuffle();
    return items;
  }

  // Updated music data --------------------------------------------------------

  static const List<String> album_cover = [
    "image_001.png",
    "image_002.png",
    "image_003.png",
    "image_004.png",
    "image_005.png",
    "image_006.png"
  ];

  static const List<String> song_name = [
    "Mountain Breeze",
    "Golden Sunset",
    "Rainforest Vibes",
    "Ocean Whisper",
    "Morning Light",
    "City Lights"
  ];

  static const List<String> album_name = [
    "Nature's Symphony",
    "Golden Hour",
    "Forest Echoes",
    "Waves of Serenity",
    "First Light",
    "Urban Harmony"
  ];
}

class MusicSong {
  late String image;
  late String title;
  late String brief;
}

class MyToast {
  static const LENGTH_SHORT = 1;

  static void show(String message, BuildContext context,
      {required int duration}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
  }
}

/*
class CircularAlbumMusicPlayer extends StatelessWidget {
  final String title;
  final String artist;
  final String albumImage;

  CircularAlbumMusicPlayer({required this.title, required this.artist, required this.albumImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(albumImage),
            ),
            SizedBox(height: 20),
            Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(artist, style: TextStyle(fontSize: 18, color: Colors.green[700])),
          ],
        ),
      ),
    );
  }
}
*/
