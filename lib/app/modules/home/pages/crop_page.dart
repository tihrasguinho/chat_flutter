import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_crop/image_crop.dart';

class CropPage extends StatefulWidget {
  const CropPage({Key? key, required this.file, this.needAspectRatio = false})
      : super(key: key);

  final File file;
  final bool needAspectRatio;

  @override
  _CropPageState createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final key = GlobalKey<CropState>();

  Future<void> cropping() async {
    final state = key.currentState;

    final area = state!.area;

    if (area == null) return Modular.to.pop();

    final sampleFile = await ImageCrop.sampleImage(
      file: widget.file,
      preferredWidth: 512,
      preferredHeight: 512,
    );

    final croppedFile = await ImageCrop.cropImage(
      file: sampleFile,
      area: area,
    );

    return Modular.to.pop(croppedFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        centerTitle: true,
        title: Text(
          'Ajustar',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Crop(
        key: key,
        image: FileImage(widget.file),
        aspectRatio: widget.needAspectRatio ? 1.0 / 1.0 : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => cropping(),
        child: Icon(Icons.crop),
      ),
    );
  }
}
