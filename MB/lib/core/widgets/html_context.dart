import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';

class HtmlViewWidget extends StatelessWidget {
  final String htmlContent;
  final String? title;
  final TextStyle? textStyle;

  const HtmlViewWidget({super.key, required this.htmlContent, this.title, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: title != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: AppColors.primaryColor,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      title!,
                      style: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white
                      ),
                    ),
                  )
                ),
                Html(data: htmlContent, style: {
                  "body": Style(
                    fontSize: FontSize(textStyle != null ? textStyle!.fontSize! : AppTheme.getTheme(context).textTheme.titleLarge!.fontSize!),
                    color: textStyle != null ? textStyle!.color : Colors.black,
                    textAlign: TextAlign.start,
                  ),
                }),
              ],
            )
          : Html(data: htmlContent, style: {
        "body": Style(
          fontSize: FontSize(textStyle != null ? textStyle!.fontSize! : AppTheme.getTheme(context).textTheme.titleLarge!.fontSize!),
          color: textStyle != null ? textStyle!.color : Colors.black,
          textAlign: TextAlign.start,
        ),
      }),
    );
  }
}
