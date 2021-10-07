import 'package:flutter/material.dart';

class ActionList extends StatelessWidget {
  const ActionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shuffle),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.replay),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.library_add),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.download),
        ),
      ],
    );
  }
}
