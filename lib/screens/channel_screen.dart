import 'package:flutter/material.dart';
import 'package:youtube_app/models/Model.dart';
import 'package:youtube_app/screens/channels/playlistsTab/playlist_channel_screen.dart';
import 'package:youtube_app/screens/channels/channlesTab/subscription_screen.dart';
import 'package:youtube_app/screens/channels/videosTab/video_channel_screen.dart';
import 'package:youtube_app/services/youtube_service.dart';
import 'package:youtube_app/widgets/loading.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({
    Key? key,
    required this.channelId,
  }) : super(key: key);
  final String channelId;
  @override
  _ChannelScreenState createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Channel channel;
  bool _loading = true;
  int selectedIndex = 0;

  static const List<Tab> tabs = <Tab>[
    Tab(child: Text('VIDEOS')),
    Tab(child: Text('PLAYLISTS')),
    Tab(child: Text('CHANNELS')),
  ];

  late List<Widget> _screen = [];

  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    _screen = [
      VideoChannelScreen(channelId: widget.channelId),
      PlaylistChannel(channelId: widget.channelId),
      Subscriptions(channelId: widget.channelId),
    ];
    super.initState();
    _getChannelFromYoutube();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  _getChannelFromYoutube() async {
    Channel channelRes = await APIService.instance.getChannel(
      channelId: widget.channelId,
    );
    setState(() {
      channel = channelRes;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Loading();
    return Scaffold(
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                leadingWidth: 30.0,
                title: Container(
                  child: Text(
                    channel.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  controller: tabController,
                  tabs: tabs,
                ),
              ),
            ];
          },
          body: TabBarView(
            children: _screen,
            controller: tabController,
          ),
        ),
      ),
    );
  }
}
