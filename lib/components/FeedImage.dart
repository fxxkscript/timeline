import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/components/ImagePreview.dart';

enum FeedImageType { normal, multiple }

class FeedImage extends StatelessWidget {
  FeedImage({this.imageList, this.type = FeedImageType.normal});

  final List<String> imageList;
  final FeedImageType type;

  List<Widget> getImageList(BuildContext context, List<String> links) {
    double width = 80;
    double height = 80;

    if (type == FeedImageType.multiple) {
      switch (links.length) {
        case 1:
          width = 74;
          height = 74;
          break;
        case 4:
          width = 36;
          height = 36;
          break;
      }
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
          child: CachedNetworkImage(
              imageUrl: links[i],
              placeholder: (context, url) => Container(
                  width: width,
                  height: height,
                  child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: width,
              height: height,
              fit: BoxFit.cover)));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    double spacing = 8;
    bool isMultipleType = type == FeedImageType.multiple;
    if (isMultipleType) {
      spacing = 2;
    }

    if (this.imageList.length == 4) {
      return Container(
          margin: isMultipleType
              ? EdgeInsets.all(0)
              : EdgeInsets.only(right: 10, bottom: 10, top: 10),
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
        margin: isMultipleType
            ? EdgeInsets.all(0)
            : EdgeInsets.only(right: 10, bottom: 10, top: 10),
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: getImageList(context, this.imageList),
        ));
  }
}
