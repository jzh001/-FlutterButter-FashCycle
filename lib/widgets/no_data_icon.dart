import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

class NoDataIcon extends StatelessWidget {
  const NoDataIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyWidget(
        image: null,
        packageImage: PackageImage.Image_1,
        title: 'No Data Found',
        //subTitle: 'No  notification available yet',
        titleTextStyle: const TextStyle(
          fontSize: 22,
          color: Color(0xff9da9c7),
          fontWeight: FontWeight.w500,
        ),
        //  subtitleTextStyle: TextStyle(
        //    fontSize: 14,
        //    color: Color(0xffabb8d6),
        //  ),
      ),
    );
  }
}
