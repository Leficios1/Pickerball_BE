import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String displayName;
  final String imageUrl;

  const PlayerCard({
    Key? key,
    required this.displayName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 25,
          ),
          const SizedBox(height: 10),
          Text(
            displayName.length > 20 ? '${displayName.substring(0, 20)}...' : displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
