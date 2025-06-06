import 'package:flutter/material.dart';

class SliderImage extends StatelessWidget {
  final List<String?> imageUrls;

  const SliderImage({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    // Lọc bỏ các image null
    final validImageUrls = imageUrls.whereType<String>().toList();

    return SizedBox(
      height: 300.0,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: validImageUrls.length,
        itemBuilder: (context, index) {
          return Image.network(
            validImageUrls[index],
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }
}
