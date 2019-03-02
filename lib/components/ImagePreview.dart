import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  ImagePreview({this.imageList, this.page = 0});

  final List<String> imageList;
  final int page;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {Navigator.of(context).maybePop()},
        child: CarouselSlider(
          height: 400.0,
          initialPage: page,
          items: imageList.map((link) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Image.network(link,
                        width: 400, height: 400, fit: BoxFit.cover));
              },
            );
          }).toList(),
        ));
  }
}
