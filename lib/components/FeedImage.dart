import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wshop/components/ImagePreview.dart';

class FeedImage extends StatelessWidget {
  FeedImage({this.imageList});

  final List<String> imageList;

  List<Widget> getImageList(BuildContext context, List<String> links) {
    double width = 80;
    double height = 80;

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
    if (this.imageList.length == 4) {
      return Container(
          margin: EdgeInsets.only(right: 10, bottom: 10, top: 10),
          child: Column(
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: getImageList(context, this.imageList.sublist(0, 2)),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: getImageList(context, this.imageList.sublist(2)),
              )
            ],
          ));
    }

    return Container(
        margin: EdgeInsets.only(right: 10, bottom: 10, top: 10),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: getImageList(context, this.imageList),
        ));
  }
}