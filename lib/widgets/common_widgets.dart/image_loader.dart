import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ImageLoader extends StatelessWidget {
  final String url;
  const ImageLoader({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      // placeholder: (context, url) {
      //   return 
      // },
    );
  }
}