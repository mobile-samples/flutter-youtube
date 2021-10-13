import 'package:flutter/material.dart';
import 'package:youtube_app/models/Model.dart';
import 'package:youtube_app/services/youtube_service.dart';
import 'package:youtube_app/widgets/loading.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  final String channelId;

  @override
  _SubscriptionsState createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  late ScrollController controller;
  late List<SubChannel> channels = [];
  bool _isLoading = true;

  handleGetSubscriptions() async {
    Channel res = await VideoClient.instance.getChannel(widget.channelId, null);
    if (res.channels.length > 0) {
      setState(() {
        channels.addAll(res.channels);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    handleGetSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Loading();
    } else {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Text(
                  'Subscriptions',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              const Divider(),
              ..._generateChildren(channels.length),
            ]))
          ],
        ),
      );
    }
  }

  Widget _generateItem(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/channel',
            arguments: channels[index].id);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                margin: const EdgeInsets.symmetric(horizontal: 50.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(!_isLoading
                      ? channels[index].mediumThumbnail
                      : 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/YouTube_social_white_square_%282017%29.svg/1200px-YouTube_social_white_square_%282017%29.svg.png'),
                  radius: 50.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 180),
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      channels[index].title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _generateChildren(int count) {
    List<Widget> items = [];
    if (count == 0) {
      items.add(Text("This channel doesn't feature any other channels."));
      return items;
    } else {
      for (int i = 0; i < count; i++) {
        items.add(_generateItem(i));
      }
      return items;
    }
  }
}
