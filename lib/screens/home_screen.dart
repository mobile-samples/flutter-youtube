import 'package:youtube_app/models/Model.dart';
import 'package:youtube_app/services/youtube_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_app/widgets/custom_silver_app_bar.dart';
import 'package:youtube_app/widgets/video_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double endReachedThreshold = 200;
  bool loadingFirst = true;
  final ScrollController scrollController = ScrollController();
  String categorySelected = '';
  String nextPageToken = '';
  List<VideoCategory> categories = [];
  late YoutubeListResult<Video> videos;
  @override
  void initState() {
    super.initState();
    _initVideo();
    scrollController.addListener(onScroll);
  }

  _initVideo() async {
    YoutubeListResult<Video> videosRes =
        (await VideoClient.instance.getPopularVideos('US', '', 10, '', null));
    List<VideoCategory> categoriesRes =
        await VideoClient.instance.getCatagories('US');
    setState(() {
      videos = videosRes;
      categories = categoriesRes;
      nextPageToken = videosRes.nextPageToken;
      loadingFirst = false;
    });
  }

  handleGetVideoFromCategory(String categoryId) async {
    setState(() {
      loadingFirst = true;
    });
    YoutubeListResult<Video> videosRes = (await VideoClient.instance
        .getPopularVideos('US', categoryId, 5, '', null));
    setState(() {
      categorySelected = categoryId;
      videos = videosRes;
      nextPageToken = videosRes.nextPageToken;
      loadingFirst = false;
    });
  }

  handleLoadMore() async {
    if (nextPageToken != '') {
      YoutubeListResult<Video> videosRes = (await VideoClient.instance
          .getPopularVideos('US', categorySelected, 5, nextPageToken, null));
      List<Video> newList = videos.list;
      if (videosRes.nextPageToken != nextPageToken) {
        videosRes.list.forEach((video) {
          newList.add(video);
        });
        setState(() {
          nextPageToken = videosRes.nextPageToken;
          videos.list = newList;
          // loadingFirst = false;
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              CustomSliverAppBar(),
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) =>
                          GestureDetector(
                              onTap: () => handleGetVideoFromCategory(
                                  categories[index].id),
                              child: (categorySelected == categories[index].id)
                                  ? chipForRow(categories[index].title, true)
                                  : chipForRow(
                                      categories[index].title, false))),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (loadingFirst == false) {
                    return VideoCard(video: videos.list[index]);
                  }
                },
                    childCount:
                        (loadingFirst == false) ? videos.list.length : 0),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget chipForRow(String label, bool isSelected) {
    return Chip(
        labelPadding: EdgeInsets.all(5.0),
        label: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.black : Colors.white),
        ),
        backgroundColor: isSelected ? Colors.white : Colors.grey[60],
        elevation: 4.0,
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0));
  }
}
