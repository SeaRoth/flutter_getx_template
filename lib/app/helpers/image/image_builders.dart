import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/helpers/print_debug/build_print.dart';

import '../../globals.dart' show colorSurface;

Widget buildMyImage(String imageUrl,
    {double? height, double? width, double? opacity, bool? isLoading = false, int? cacheHeight, int? cacheWidth}) {
  try {
    if (imageUrl.isEmpty && isLoading == false) {
      return returnImageError();
    } else if ((isLoading == true && imageUrl.isEmpty) || imageUrl == "null") {
      return Center(
        child: returnImageLoading(),
      );
    }
    if (!imageUrl.contains("http") && imageUrl.contains("assets")) {
      return Image.asset(imageUrl, height: height, width: width, cacheHeight: cacheHeight, cacheWidth: cacheWidth);
    }
    return Opacity(
      opacity: opacity ?? 1,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => returnImageLoading(),
          errorWidget: (context, url, error) => Image.asset("assets/icon.png", height: height, width: width, cacheHeight: cacheHeight, cacheWidth: cacheWidth),
        ),
      ),
    );
  } catch (e) {
    myPrint("Error loading: $imageUrl");
    return returnImageError();
  }
}

Widget buildMyCircularImage(String imageUrl, {double? height = 40, double? width = 40, double? radius = 40, bool? showLoading = true}) {
  try {
    if (imageUrl.isEmpty) {
      return returnImageLoading();
    }
    if (!imageUrl.contains("http") && imageUrl.contains("assets")) {
      return Image.asset(imageUrl, height: height, width: width);
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => returnImageLoading(),
      imageBuilder: (context, image) => CircleAvatar(
        backgroundImage: image,
        radius: radius,
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        backgroundColor: Colors.grey,
        radius: radius,
        child: returnImageError(),
      ),
    );
  } catch (e) {
    myPrint("Error loading: $imageUrl");
    return returnImageError();
  }
}

Widget returnImageError() {
  return Image.asset("assets/error.png", height: 20, width: 20);
}

Widget returnImageLoading({ImageChunkEvent? loadingProgress, double radius = 20.0, double width = 20.0}) {
  if (Platform.isIOS) {
    return CupertinoActivityIndicator(
      radius: radius,
    );
  } else {
    return SizedBox(
      width: width,
      height: width,
      child: Center(
          child: CircularProgressIndicator(
        color: colorSurface,
      )),
    );
  }
}
