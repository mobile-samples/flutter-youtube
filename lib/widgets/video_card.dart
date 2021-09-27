import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_app/models/Model.dart';
import 'package:youtube_app/screens/nav_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_app/utils/format_duration.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  final bool hasPadding;
  final VoidCallback? onTap;

  const VideoCard({
    Key? key,
    required this.video,
    this.hasPadding = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.read(selectedVideoProvider).state = video;
          context
              .read(miniPlayerControllerProvider)
              .state
              .animateToHeight(state: PanelState.MAX);
          if (onTap != null) onTap!();
        },
        child: builtPortraitList(context));
  }

  Widget builtPortraitList(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hasPadding ? 12.0 : 0,
              ),
              child: Image.network(
                video.mediumThumbnail,
                height: 220.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 8.0,
              right: hasPadding ? 20.0 : 8.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black54,
                ),
                child: Text(
                    FormatDuration.getTimeString(int.parse(video.duration)),
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white)),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GestureDetector(
              //   onTap: () => print('Navigate profive'),
              //   child: CircleAvatar(
              //     foregroundImage: NetworkImage(video.mediumThumbnail),
              //   ),
              // ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 15.0),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${video.channelTitle}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 15.0),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.more_vert,
                  size: 20.0,
                ),
              ),
            ],
          ),
        ),
        // (isLoading == null || isLoading == true)
        //     ? Loading()
        //     : SizedBox(
        //         width: 0,
        //         height: 0,
        //       ),
      ],
    );
  }
}
