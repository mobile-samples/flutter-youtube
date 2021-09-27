import 'package:flutter/material.dart';
import 'package:youtube_app/models/Model.dart';
import 'package:youtube_app/screens/channels/playlistsTab/videoPlaylist/widgets/action_list.dart';

class PlaylistInfoBox extends StatelessWidget {
  const PlaylistInfoBox({Key? key, required this.playlist}) : super(key: key);
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 10, 10, 10),
      decoration: BoxDecoration(color: Colors.black87),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15.0),
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    playlist.title,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                Text(
                  playlist.channelTitle,
                  style: TextStyle(fontSize: 16.0, color: Colors.white70),
                ),
              ],
            ),
          ),
          ActionList(),
        ],
      ),
    );
  }
}
