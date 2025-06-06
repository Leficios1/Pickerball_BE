import 'package:flutter/material.dart';
import 'package:pickleball_app/generated/assets.dart';

class ImgStartedWidget extends StatefulWidget {
  bool isViewedTab2 = false;
  bool isViewedTab1 = false;

  ImgStartedWidget({
    super.key,
    required this.isViewedTab2,
    required this.isViewedTab1,
  });

  @override
  _ImgStartedWidgetState createState() => _ImgStartedWidgetState();
}

class _ImgStartedWidgetState extends State<ImgStartedWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.isViewedTab1
            ? Center(
                child: Container(
                  height: 450,
                  width: 325,
                  alignment: Alignment.center,
                  child: widget.isViewedTab2
                      ? Image.asset(Assets.imagesImgOnboardingT3)
                      : Stack(
                          children: [
                            Image.asset(
                              Assets.imagesImgOnboardingT2,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ],
                        ),
                ),
              )
            : Container(),
      ],
    );
  }
}
