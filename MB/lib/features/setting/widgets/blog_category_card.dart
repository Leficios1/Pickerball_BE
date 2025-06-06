import 'package:flutter/material.dart';
import 'package:pickleball_app/core/widgets/slider_image.dart';

class BlogCategoryCard extends StatelessWidget {
  final List<String?> imageUrls;
  final String title;

  const BlogCategoryCard(
      {super.key, required this.imageUrls, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SliderImage(imageUrls: imageUrls),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
