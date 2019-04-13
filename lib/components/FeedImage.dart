import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/components/ImagePreview.dart';

enum FeedImageSize { normal, mini }

class FeedImage extends StatelessWidget {
  FeedImage({this.imageList, this.size = FeedImageSize.normal});

  final List<String> imageList;
  final FeedImageSize size;

  List<Widget> getImageList(BuildContext context, List<String> links) {
    double width = 80;
    double height = 80;

    if (size == FeedImageSize.mini) {
      width = 36;
      height = 36;
    }

    List<Widget> result = [];
    for (var i = 0; i < links.length; i++) {
      result.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) =>
                    ImagePreview(imageList: links, page: i)));
          },
          child: Image.network(links[i],
              width: width, height: height, fit: BoxFit.cover)));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    double spacing = 8;

    if (size == FeedImageSize.mini) {
      spacing = 2;
    }

    if (this.imageList.length == 4) {
      return Container(
          margin: EdgeInsets.only(right: 10, bottom: 10, top: 10),
          child: Column(
            children: [
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: getImageList(context, this.imageList.sublist(0, 2)),
              ),
              SizedBox(height: spacing),
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: getImageList(context, this.imageList.sublist(2)),
              )
            ],
          ));
    }

    return Container(
        margin: EdgeInsets.only(right: 10, bottom: 10, top: 10),
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: getImageList(context, this.imageList),
        ));
  }
}
