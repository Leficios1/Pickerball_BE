import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';

class PlayerInfo extends StatelessWidget {
  final String avatarUrl;
  final String displayName;
  final VoidCallback? onTap;

  const PlayerInfo({
    super.key,
    required this.avatarUrl,
    required this.displayName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    displayName,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: onTap,
                    ),
                ],
              ),
            )));
  }
}
