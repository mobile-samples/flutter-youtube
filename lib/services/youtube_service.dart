import 'dart:convert';
import 'dart:io';
import 'package:youtube_app/models/Model.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class VideoClient {
  VideoClient._instantiate();
  static final VideoClient instance = VideoClient._instantiate();

  final String baseUrlIOS = 'localhost:7070';
  final String baseUrlAndroid = '10.0.2.2:7070';

  getUrl() {
    if (Platform.isAndroid) {
      return baseUrlAndroid;
    } else if (Platform.isIOS) {
      return baseUrlIOS;
    }
  }

  Future<List<VideoCategory>> getCatagories(String? regionCode) async {
    Map<String, String> parameters = {
      'regionCode': regionCode ?? '',
    };
    late String baseUrl = getUrl();
    Uri uri = Uri.http(baseUrl, '/tube/category', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      List<dynamic> categoryRes = json.decode(res.body);
      List<VideoCategory> categories = [];
      categoryRes.forEach((item) {
        categories.add(VideoCategory.fromMap(item));
      });
      return categories;
    } else {
      throw json.decode(res.body)['error']['message'];
    }
  }

  Future<List<Channel>> getChannels(
      List<String> ids, List<String>? fields) async {
    Map<String, String> parameters = {
      'id': ids.join(),
      'fields': fields!.isNotEmpty ? fields.join() : 'id,title,mediumThumbnail'
    };
    late String baseUrl = getUrl();
    Uri uri = Uri.http(baseUrl, '/tube/channels/list', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      List<dynamic> channelRes = json.decode(res.body);
      List<Channel> channelList = [];
      channelRes.forEach((item) {
        channelList.add(Channel.fromMap(item));
      });
      return channelList;
    } else {
      throw json.decode(res.body)['error']['message'];
    }
  }

  Future<Channel> getChannel(String id, List<String>? fields) async {
    Map<String, String> parameters = {
      'fields': 'id,title,mediumThumbnail,channels'
    };
    late String baseUrl = getUrl();
    Uri uri = Uri.http(baseUrl, '/tube/channels/$id', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      Map<String, dynamic> channelRes = json.decode(res.body);
      Channel channel = Channel.fromMap(channelRes);
      return channel;
    } else {
      throw json.decode(res.body)['error']['message'];
    }
  }

  Future<YoutubeListResult<Playlist>> getChannelPlaylists(String channelId,
      int? max, String? nextPageToken, List<String>? fields) async {
    Map<String, String> parameters = {
      'channelId': channelId,
      'limit': max!.isNaN ? '' : max.toString(),
      'nextPageToken': (nextPageToken!.length > 0) ? nextPageToken : '',
      'fields':
          'id,title,mediumThumbnail,duration,categoryId,channelTitle,channelId,count',
    };
    late String baseUrl = getUrl();
    Uri uri = Uri.http(baseUrl, '/tube/playlists', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      return YoutubeListResult.fromMap(json.decode(res.body));
    } else {
      throw json.decode(res.body)['error']['message'];
    }
  }

  Future<YoutubeListResult<Video>> getPopularVideos(
      String? regionCode,
      String? categoryId,
      int? max,
      String? nextPageToken,
      List<String>? fields) async {
    Map<String, String> parameters = {
      'regionCode': regionCode!.isNotEmpty ? regionCode : '',
      'categoryId': (categoryId!.length > 0) ? categoryId : '',
      'nextPageToken': (nextPageToken!.length > 0) ? nextPageToken : '',
      'limit': max.toString(),
      'fields':
          'id,title,mediumThumbnail,duration,categoryId,channelTitle,channelId'
    };
    late String baseUrl = getUrl();
    Uri uri = Uri.http(baseUrl, '/tube/videos/popular', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      return YoutubeListResult.fromMap(json.decode(res.body));
    } else {
      throw json.decode(res.body)['error']['message'];
    }
  }

  Future<YoutubeListResult<Video>> getRelatedVideos(String videoId, int? max,
      String? nextPageToken, List<String>? fields) async {
    Map<String, String> parameters = {
      'nextPageToken': (nextPageToken!.length > 0) ? nextPageToken : '',
      'limit': max!.isNaN ? '' : max.toString(),
      'fields':
          'id,title,mediumThumbnail,duration,categoryId,channelTitle,channelId'
    };
    late String baseUrl = getUrl();
    Uri uri = Uri.http(baseUrl, '/tube/videos/$videoId/related', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      return YoutubeListResult.fromMap(json.decode(res.body));
    } else {
      throw json.decode(res.body)['error']['message'];
    }
  }

  Future<YoutubeListResult<Video>> searchVideos(
      String q, int? max, String? nextPageToken, List<String>? fields) async {
    Map<String, String> parameters = {
      'nextPageToken': (nextPageToken!.length > 0) ? nextPageToken : '',
      'limit': max!.isNaN ? '' : max.toString(),
      'fields':
          'id,title,mediumThumbnail,duration,categoryId,channelTitle,channelId',
      'q': q,
    };
    late String baseUrl = getUrl();
    Uri uri = Uri.http(baseUrl, '/tube/videos/search', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      return YoutubeListResult.fromMap(json.decode(res.body));
    } else {
      throw json.decode(res.body)['error']['message'];
    }
  }

  Future<YoutubeListResult<Video>> getVideoList(
      String? playlistId,
      String? channelId,
      int? max,
      String? nextPageToken,
      List<String>? fields) async {
    Map<String, String> parameters = {
      'nextPageToken': (nextPageToken!.length > 0) ? nextPageToken : '',
      'limit': max!.isNaN ? '' : max.toString(),
      'fields':
          'id,title,mediumThumbnail,duration,categoryId,channelTitle,channelId',
      'playlistId': playlistId!.isEmpty ? '' : playlistId,
      'channelId': channelId!.isEmpty ? '' : channelId,
    };
    late String baseUrl = getUrl();
    Uri uri = Uri.http(baseUrl, '/tube/videos', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      return YoutubeListResult.fromMap(json.decode(res.body));
    } else {
      throw json.decode(res.body)['error']['message'];
    }
  }

  Future<List<Channel>> getSubscriptions(String channelId) async {
    late String baseUrl = getUrl();
    Uri uri = Uri.http(baseUrl, '/tube/channels/subscriptions/$channelId');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      List<dynamic> results = json.decode(res.body);
      List<Channel> subscriptions = [];
      results.forEach((item) {
        subscriptions.add(Channel.fromMap(item));
      });
      return subscriptions;
    } else {
      throw json.decode(res.body)['error']['message'];
    }
  }
}

// Future<ListResultVideo> getPopularVideoByRegion({
  //   required String regionCode,
  //   required int max,
  //   required String categoryId,
  //   required String nextPageToken,
  //   List<String>? fields,
  // }) async {
  //   Map<String, String> parameters = {
  //     'regionCode': regionCode,
  //     'categoryId': (categoryId.length > 0) ? categoryId : '',
  //     'nextPageToken': (nextPageToken.length > 0) ? nextPageToken : '',
  //     'limit': max.toString(),
  //     'fields':
  //         'id,title,mediumThumbnail,duration,categoryId,channelTitle,channelId'
  //   };
  //   late String baseUrl = '';
  //   if (Platform.isAndroid) {
  //     baseUrl = baseUrlAndroid;
  //   } else if (Platform.isIOS) {
  //     baseUrl = baseUrlIOS;
  //   }
  //   Uri uri = Uri.http(baseUrl, '/tube/videos/popular', parameters);
  //   Map<String, String> headers = {
  //     HttpHeaders.contentTypeHeader: 'application/json',
  //   };
  //   var res = await http.get(uri, headers: headers);
  //   if (res.statusCode == 200) {
  //     Map<String, dynamic> result = json.decode(res.body);
  //     ListResultVideo listRes = ListResultVideo.fromMap(result);

  //     // Filter Videos have channelId in DB
  //     String channelIds = listRes.list.map((e) => e.channelId).join(',');
  //     List<Channel> channels = await getChannels(channelIds);
  //     List<String> filterTerms = channels.map((e) => e.id).toList();

  //     List<Video> newlistVideo = [];

  //     filterTerms.forEach((id) {
  //       newlistVideo.addAll(
  //           listRes.list.where((item) => item.channelId == id).toList());
  //     });

  //     ListResultVideo formResult = new ListResultVideo(
  //       list: newlistVideo,
  //       nextPageToken: listRes.nextPageToken,
  //     );

  //     return formResult;
  //   } else {
  //     throw json.decode(res.body)['error']['message'];
  //   }
  // }