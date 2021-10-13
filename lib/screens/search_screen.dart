import 'package:flutter/material.dart';
import 'package:youtube_app/models/Model.dart';
import 'package:youtube_app/services/youtube_service.dart';
import 'package:youtube_app/widgets/video_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final myController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  final double endReachedThreshold = 200;

  List<Video> videoList = [];
  bool loadingFirst = true;
  String nextPageToken = '';

  @override
  void initState() {
    scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    scrollController.removeListener(onScroll);
    super.dispose();
  }

  _handleSearch(search) async {
    YoutubeListResult<Video> res =
        await VideoClient.instance.searchVideos(search, 5, '', null);
    List<Video> videos = [];
    videos.addAll(res.list);
    setState(() {
      videoList = videos;
      nextPageToken = res.nextPageToken;
    });
  }

  _handleLoadMore() async {
    if (nextPageToken != '') {
      YoutubeListResult<Video> res = (await VideoClient.instance
          .searchVideos(myController.text, 1, nextPageToken, null));
      if (res.nextPageToken != nextPageToken) {
        setState(() {
          videoList.addAll(res.list);
          nextPageToken = res.nextPageToken;
        });
      }
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
            autofocus: true,
            controller: myController,
            decoration: InputDecoration(
              hintText: "Search....",
              suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    myController.text = '';
                  }),
            ),
            onSubmitted: (value) {
              _handleSearch(value);
            }),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _handleSearch(myController.text);
                FocusScope.of(context).requestFocus(FocusNode());
                scrollController
                    .jumpTo(scrollController.position.minScrollExtent);
              })
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (videoList.length != 0) {
                          return VideoCard(video: videoList[index]);
                        }
                      },
                      childCount:
                          (videoList.length != 0) ? videoList.length : 0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
