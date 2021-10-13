import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_app/models/Model.dart';
import 'package:youtube_app/screens/nav_screen.dart';
import 'package:youtube_app/services/youtube_service.dart';
import 'package:youtube_app/widgets/video_card.dart';
import 'package:youtube_app/widgets/video_info.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key, required this.video}) : super(key: key);
  final Video video;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubeListResult<Video> videosRelated;
  static const double endReachedThreshold = 50;
  bool loading = true;
  final ScrollController scrollController = ScrollController();
  String nextPageToken = '';
  // late YoutubePlayerController youtubeController;
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
    _initVideo();
  }

  _initVideo() async {
    YoutubeListResult<Video> videoRes =
        await VideoClient.instance.getRelatedVideos(
      widget.video.id,
      8,
      '',
      null,
    );
    setState(() {
      videosRelated = videoRes;
      nextPageToken = videoRes.nextPageToken;
      loading = false;
    });
  }

  handleLoadMore() async {
    if (nextPageToken != '') {
      YoutubeListResult<Video> videoRes =
          await VideoClient.instance.getRelatedVideos(
        widget.video.id,
        8,
        nextPageToken,
        null,
      );
      List<Video> newList = videosRelated.list;
      if (videoRes.nextPageToken != nextPageToken) {
        videoRes.list.forEach((video) {
          newList.add(video);
        });
        setState(() {
          nextPageToken = videoRes.nextPageToken;
          videosRelated.list = newList;
          loading = false;
        });
      }
    }
  }

  void onScroll() {
    if (!scrollController.hasClients) return;

    final thresholdReached =
        scrollController.position.extentAfter < endReachedThreshold;
    if (thresholdReached) {
      setState(() {
        loading = true;
      });
      handleLoadMore();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read(miniPlayerControllerProvider)
          .state
          .animateToHeight(state: PanelState.MAX),
      child: Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            controller: scrollController,
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, watch, _) {
                    final selectedVideo = watch(selectedVideoProvider).state;
                    return SafeArea(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                selectedVideo!.mediumThumbnail,
                                height: 220.0,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onPressed: () => context
                                    .read(miniPlayerControllerProvider)
                                    .state
                                    .animateToHeight(state: PanelState.MIN),
                              ),
                            ],
                          ),
                          const LinearProgressIndicator(
                            value: 0.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                          VideoInfo(video: selectedVideo),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (loading == false) {
                    return VideoCard(
                      video: videosRelated.list[index],
                      hasPadding: true,
                      onTap: () => scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                      ),
                    );
                  } else {
                    return Text('No video related');
                  }
                },
                    childCount:
                        (loading == false) ? videosRelated.list.length : 1),
              )
            ],
          ),
        ),
      ),
    );
  }
}
