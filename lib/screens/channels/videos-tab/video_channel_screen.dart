import 'package:flutter/material.dart';
import 'package:youtube_app/models/Model.dart';
import 'package:youtube_app/services/youtube_service.dart';
import 'package:youtube_app/widgets/video_card.dart';

class VideoChannelScreen extends StatefulWidget {
  const VideoChannelScreen({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  final String channelId;

  @override
  _VideoChannelScreenState createState() => _VideoChannelScreenState();
}

class _VideoChannelScreenState extends State<VideoChannelScreen> {
  final ScrollController scrollController = ScrollController();
  static const double endReachedThreshold = 200;
  late YoutubeListResult<Video> videosChannel;
  String nextPageToken = '';
  bool loadingFirst = true;

  handleGetVideoFromChannel() async {
    YoutubeListResult<Video> res = (await VideoClient.instance
        .getVideoList('', widget.channelId, 4, '', null));
    setState(() {
      nextPageToken = res.nextPageToken;
      videosChannel = res;
      loadingFirst = false;
    });
  }

  handleLoadMore() async {
    if (nextPageToken != '') {
      YoutubeListResult<Video> res = (await VideoClient.instance
          .getVideoList('', widget.channelId, 1, nextPageToken, null));
      List<Video> newList = videosChannel.list;
      if (res.nextPageToken != nextPageToken) {
        res.list.forEach((video) {
          newList.add(video);
        });
        setState(() {
          nextPageToken = res.nextPageToken;
          videosChannel.list = newList;
        });
      }
    }
  }

  void onScroll() {
    if (!scrollController.hasClients) return;

    final thresholdReached =
        scrollController.position.extentAfter < endReachedThreshold;
    if (thresholdReached) {
      handleLoadMore();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    super.dispose();
  }

  @override
  void initState() {
    scrollController.addListener(onScroll);
    handleGetVideoFromChannel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (loadingFirst == false) {
                        return VideoCard(
                          video: videosChannel.list[index],
                        );
                      }
                    },
                    childCount:
                        (loadingFirst == false) ? videosChannel.list.length : 0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
