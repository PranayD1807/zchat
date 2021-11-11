import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:gallery_saver/gallery_saver.dart';

class ImageDetail extends StatelessWidget {
  final String loadedImgUrl;
  ImageDetail(this.loadedImgUrl);
  // const ImageDetail({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _saveNetworkImage() async {
      try {
        var response = await Dio().get(loadedImgUrl,
            options: Options(responseType: ResponseType.bytes));
        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to Gallery'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save Image'),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              _saveNetworkImage();
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85),
              child: Image(
                  fit: BoxFit.fitWidth, image: NetworkImage(loadedImgUrl))),
        ),
      ),
    );
  }
}
