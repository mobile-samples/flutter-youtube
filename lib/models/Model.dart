class Video {
  String id;
  String title;
  String duration;
  String mediumThumbnail;
  String categoryId;
  String channelTitle;
  String channelId;

  Video(
    this.id,
    this.title,
    this.duration,
    this.mediumThumbnail,
    this.categoryId,
    this.channelTitle,
    this.channelId,
  );

  factory Video.fromMap(Map<String, dynamic> json) {
    return Video(
      json['id'],
      json['title'],
      json['duration'],
      json['mediumThumbnail'] != null
          ? json['mediumThumnail']
          : 'https://i.ytimg.com/vi/' + json['id'] + '/mqdefault.jpg',
      json['categoryId'],
      json['channelTitle'],
      json['channelId'],
    );
  }
}

class Playlist {
  String id;
  String title;
  String mediumThumbnail;
  int count;
  String channelTitle;
  String channelId;

  Playlist(
    this.id,
    this.title,
    this.mediumThumbnail,
    this.count,
    this.channelTitle,
    this.channelId,
  );

  factory Playlist.fromMap(Map<String, dynamic> json) => Playlist(
        json['id'],
        json['title'],
        json['meiumThumnail'] != null
            ? json['mediumThumnail']
            : 'https://i.ytimg.com/vi/' +
                json['mediumThumbnail'] +
                '/mqdefault.jpg',
        json['count'] != null ? json['count'] : 0,
        json['channelTitle'],
        json['channelId'],
      );
}

class Channel {
  String id;
  String title;
  String mediumThumbnail;
  List<SubChannel> channels;

  Channel(
    this.id,
    this.title,
    this.mediumThumbnail,
    this.channels,
  );
  factory Channel.fromMap(Map<String, dynamic> json) {
    return Channel(
      json['id'],
      json['title'],
      json['mediumThumbnail'],
      json['channels'] != null
          ? List<SubChannel>.from(
              json['channels'].map((x) => SubChannel.fromMap(x)))
          : [],
    );
  }
}

class SubChannel {
  String id;
  String title;
  String mediumThumbnail;

  SubChannel(
    this.id,
    this.title,
    this.mediumThumbnail,
  );
  factory SubChannel.fromMap(Map<String, dynamic> item) {
    return SubChannel(
      item['id'],
      item['title'],
      item['mediumThumbnail'],
    );
  }
}

class VideoCategory {
  final String id;
  final String title;
  final bool assignable;
  final String channelId;

  VideoCategory(
    this.id,
    this.title,
    this.assignable,
    this.channelId,
  );

  factory VideoCategory.fromMap(Map<String, dynamic> json) {
    return VideoCategory(
      json['id'],
      json['title'],
      json['assignable'],
      json['channelId'],
    );
  }
}

class YoutubeListResult<T> {
  List<T> list;
  String nextPageToken;

  YoutubeListResult(
    this.list,
    this.nextPageToken,
  );

  factory YoutubeListResult.fromMap(Map<String, dynamic> json) {
    final _build = () {
      switch (T) {
        case Video:
          return List<T>.from(json['list'].map((x) => Video.fromMap(x)));
        case Playlist:
          return List<T>.from(json['list'].map((x) => Playlist.fromMap(x)));
        default:
          return null;
      }
    };
    return YoutubeListResult(
      json['list'] != null ? _build() ?? [] : [],
      json['nextPageToken'] != null ? json['nextPageToken'] : '',
    );
  }
}

abstract class Title {
  final String? title;
  final String? description;
  final DateTime? publishedAt;

  Title(this.title, this.description, this.publishedAt);
}

abstract class LocalizedTitle {
  final String? localizedTitle;
  final String? localizedDescription;

  LocalizedTitle(this.localizedTitle, this.localizedDescription);
}

abstract class ChannelInfo {
  final String? channelId;
  final String? channelTitle;

  ChannelInfo(this.channelId, this.channelTitle);
}

abstract class ListDetail {
  int itemCount;

  ListDetail(this.itemCount);
}

abstract class PageInfo {
  final int? totalResults;
  final int? resultsPerPage;

  PageInfo(this.totalResults, this.resultsPerPage);
}

abstract class ChannelDetail {
  final RelatedPlaylists? relatedPlaylists;

  ChannelDetail(this.relatedPlaylists);
}

abstract class RelatedPlaylists {
  final String? likes;
  final String? favorites;
  final String? uploads;

  RelatedPlaylists(this.likes, this.favorites, this.uploads);
}

abstract class VideoItemDetail {
  final String? videoId;
  final DateTime? videoPublishedAt;

  VideoItemDetail(this.videoId, this.videoPublishedAt);
}

abstract class RegionRestriction {
  final List<String>? allow;
  final List<String>? blocked;

  RegionRestriction(this.allow, this.blocked);
}

abstract class YoutubeVideoDetail {
  final String? duration;
  final String? dimension;
  final String? definition;
  final String? caption;
  final bool? licensedContent;
  final String? projection;
  final RegionRestriction? regionRestriction;

  YoutubeVideoDetail(
    this.duration,
    this.dimension,
    this.definition,
    this.caption,
    this.licensedContent,
    this.projection,
    this.regionRestriction,
  );
}
