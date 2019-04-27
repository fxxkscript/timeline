import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AssetView extends StatefulWidget {
  final Asset _asset;
  final DeleteCallback _delete;

  AssetView(Key key, this._asset, this._delete) : super(key: key);

  @override
  State<StatefulWidget> createState() => AssetState(this._asset, this._delete);
}

class AssetState extends State<AssetView> {
  Asset _asset;
  DeleteCallback _delete;
  ByteData _thumb;
  AssetState(this._asset, this._delete);

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    if (this.mounted) {
      var image = await this._asset.requestThumbnail(300, 300, quality: 50);
      setState(() {
        this._thumb = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (null != this._thumb) {
      return Container(
          width: 120,
          height: 120,
          child: Stack(
            overflow: Overflow.visible,
            fit: StackFit.expand,
            children: <Widget>[
              Image.memory(
                this._thumb.buffer.asUint8List(),
                fit: BoxFit.cover,
                gaplessPlayback: true,
                width: 120,
                height: 120,
              ),
              Positioned(
                child: IconButton(
                    iconSize: 24,
                    onPressed: () {
                      _delete(_asset.name);
                    },
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.close,
                      size: 24,
                    )),
                right: -12,
                top: -12,
              )
            ],
          ));
    }

    return Text(
      '',
      style: Theme.of(context).textTheme.headline,
    );
  }
}

typedef DeleteCallback = void Function(String name);
