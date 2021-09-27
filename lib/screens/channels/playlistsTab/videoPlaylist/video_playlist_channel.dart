import 'package:flutter/material.dart';
import 'package:youtube_app/models/Model.dart';
import 'package:youtube_app/screens/channels/playlistsTab/videoPlaylist/widgets/playlist_info_box.dart';
import 'package:youtube_app/screens/channels/playlistsTab/videoPlaylist/widgets/video_info_detail.dart';
import 'package:youtube_app/services/youtube_service.dart';
import 'package:youtube_app/widgets/loading.dart';

class VideoPlaylistChannel extends StatefulWidget {
  const VideoPlaylistChannel({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final Playlist playlist;

  @override
  _VideoPlaylistChannelState createState() => _VideoPlaylistChannelState();
}

class _VideoPlaylistChannelState extends State<VideoPlaylistChannel> {
  final ScrollController scrollController = ScrollController();
  static const double endReachedThreshold = 50;
  late List<Video> videoList;
  String nextPageToken = '';
  bool loadingFirst = true;
  bool isLoading = false;

  handleGetVideoListFormChannel() async {
    ListResultVideo res = await APIService.instance.getVideoList(
      channelId: '',
      playlistId: widget.playlist.id,
      max: 5,
      nextPageToken: nextPageToken,
    );
    setState(() {
      videoList = res.list;
      nextPageToken = res.nextPageToken;
      loadingFirst = false;
    });
  }

  _handleLoadMore() async {
    setState(() {
      isLoading = true;
    });
    ListResultVideo res = await APIService.instance.getVideoList(
      channelId: '',
      playlistId: widget.playlist.id,
      max: 5,
      nextPageToken: nextPageToken,
    );
    if (res.nextPageToken != nextPageToken && nextPageToken != '') {
      setState(() {
        videoList.addAll(res.list);
        nextPageToken = res.nextPageToken;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void onScroll() {
    if (!scrollController.hasClients) return;

    final thresholdReached =
        scrollController.position.extentAfter < endReachedThreshold;
    if (thresholdReached) {
      _handleLoadMore();
    }
  }

  @override
  void initState() {
    scrollController.addListener(onScroll);
    handleGetVideoListFormChannel();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loadingFirst) {
      return Loading();
    } else {
      return Scaffold(
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              leadingWidth: 30.0,
              title: Container(
                child: Text(
                  widget.playlist.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.cast_connected),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  PlaylistInfoBox(playlist: widget.playlist),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    width: double.infinity,
                    child: Text(
                      '${widget.playlist.count.toString()} videos',
                      style: TextStyle(fontSize: 16.0, color: Colors.white70),
                    ),
                  ),
                  const Divider(),
                  ..._generateChildren(videoList.length),
                  isLoading
                      ? Loading()
                      : SizedBox(
                          width: 0,
                          height: 0,
                        )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  List<Widget> _generateChildren(int count) {
    List<Widget> items = [];
    if (count == 0) {
      items.add(Text("This playlist doesn't have video."));
      return items;
    } else {
      for (int i = 0; i < count; i++) {
        items.add(VideoInfoDetail(videoList: videoList, index: i));
      }
      return items;
    }
  }
}
