import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonImageViewWidget extends StatelessWidget {
  const CommonImageViewWidget({
    super.key,
    required this.imageUrl,
    this.color,
    this.borderRadius,
    this.placeholder,
    this.fit,
    this.padding,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    required this.height,
    required this.width,
    this.errorWidget,
    this.imageType = ImageType.network,
  });

  final String imageUrl;
  final BorderRadius? borderRadius;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, Object)? errorWidget;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final double height;
  final double width;
  final ImageType imageType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(0),
      child: (imageUrl.isEmpty || imageUrl == "null")
          ? Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: borderRadius ?? BorderRadius.circular(8.0),
                color: color ?? Colors.white,
                image: DecorationImage(
                    image: const AssetImage("assets/place_holder.png"),
                    fit: fit ?? BoxFit.cover,
                    onError: (exception, stackTrace) {}),
              ),
            )
          : imageType == ImageType.network
              ? CachedNetworkImage(
                  key: const Key("cached-image"),
                  maxWidthDiskCache: maxWidthDiskCache,
                  maxHeightDiskCache: maxHeightDiskCache,
                  imageUrl: imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
                      color: color ?? Colors.white,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: fit ?? BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: placeholder ??
                      (context, url) => Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius:
                                  borderRadius ?? BorderRadius.circular(8.0),
                              image: DecorationImage(
                                  image: const AssetImage(
                                    "assets/place_holder.png",
                                  ),
                                  fit: fit ?? BoxFit.cover),
                            ),
                          ),
                  errorWidget: errorWidget ??
                      (context, url, error) => Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius:
                                  borderRadius ?? BorderRadius.circular(8.0),
                              color: color ?? Colors.white,
                              image: DecorationImage(
                                  image: const AssetImage(
                                    "assets/place_holder.png",
                                  ),
                                  fit: fit ?? BoxFit.cover,
                                  onError: (exception, stackTrace) {}),
                            ),
                          ),
                )
              : imageType == ImageType.asset
                  ? Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius:
                            borderRadius ?? BorderRadius.circular(8.0),
                        color: color ?? Colors.white,
                        image: DecorationImage(
                            image: AssetImage(imageUrl),
                            fit: fit ?? BoxFit.cover,
                            onError: (exception, stackTrace) {}),
                      ),
                    )
                  : imageType == ImageType.file
                      ? Container(
                          height: height,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius:
                                borderRadius ?? BorderRadius.circular(8.0),
                            color: color ?? Colors.white,
                            image: DecorationImage(
                                image: FileImage(
                                  File(imageUrl),
                                ),
                                fit: fit ?? BoxFit.cover,
                                onError: (exception, stackTrace) {}),
                          ),
                        )
                      : Container(
                          height: height,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius:
                                borderRadius ?? BorderRadius.circular(8.0),
                            color: color ?? Colors.white,
                            image: DecorationImage(
                              image: MemoryImage(imageUrl as Uint8List),
                              fit: fit ?? BoxFit.cover,
                              onError: (exception, stackTrace) {},
                            ),
                          ),
                        ),
    );
  }
}

enum ImageType {
  network,
  asset,
  file,
  memory,
}
