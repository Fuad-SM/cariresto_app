import 'package:flutter/material.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class ImageView extends StatelessWidget {
  final String urlImage;
  final String idPicture;
  final double width;
  final double height;

  const ImageView(
      {required this.urlImage,
      required this.idPicture,
      required this.width,
      required this.height,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      '$urlImage$idPicture',
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: Container(
            width: width,
            height: height,
            color: blackColor,
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object? exception, StackTrace? stackTrace) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: greyColor,
              ),
              Text(
                'No Image\nAvailable',
                style: greyTextStyle.copyWith(fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }
}
