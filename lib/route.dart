import 'package:flutter/material.dart';
import 'package:youtube_app/models/Model.dart';
import 'package:youtube_app/screens/channel_screen.dart';
import 'package:youtube_app/screens/channels/playlistsTab/playlist_channel_screen.dart';
import 'package:youtube_app/screens/channels/channlesTab/subscription_screen.dart';
import 'package:youtube_app/screens/channels/videosTab/video_channel_screen.dart';
import 'package:youtube_app/screens/channels/playlistsTab/videoPlaylist/video_playlist_channel.dart';
import 'package:youtube_app/screens/nav_screen.dart';
import 'package:youtube_app/screens/search_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => NavScreen());

      case '/search':
        return MaterialPageRoute(builder: (_) => SearchScreen());

      case '/channel':
        return MaterialPageRoute(
            builder: (_) => ChannelScreen(channelId: arguments as String));

      case '/channel/videos':
        return MaterialPageRoute(
            builder: (_) => VideoChannelScreen(channelId: arguments as String));

      case '/channel/playlists':
        return MaterialPageRoute(
            builder: (_) => PlaylistChannel(channelId: arguments as String));

      case '/channel/channels':
        return MaterialPageRoute(
            builder: (_) => Subscriptions(channelId: arguments as String));

      case '/channel/playlists/list':
        return MaterialPageRoute(
            builder: (_) =>
                VideoPlaylistChannel(playlist: arguments as Playlist));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
