import 'package:cafe_app/components/colors.dart';
import 'package:flutter/material.dart';

import '../constraints/constants.dart';

class ProfileSkelton extends StatelessWidget {
  const ProfileSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 50,
        ),
        CircleSkeleton(
          size: 124,
        ),
        SizedBox(height: defaultPadding),
        Skeleton(width: 150),
        SizedBox(height: defaultPadding),
        Skeleton(
          width: 50,
        ),
        SizedBox(height: defaultPadding),
        Skeleton(
          width: 250,
        ),
        SizedBox(height: defaultPadding),
        Row(
          children: [
            Expanded(
              child: Skeleton(),
            ),
            SizedBox(width: defaultPadding),
            Expanded(
              child: Skeleton(),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Row(
          children: [
            Expanded(
              child: Skeleton(),
            ),
            SizedBox(width: defaultPadding),
            Expanded(
              child: Skeleton(),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Skeleton(width: 150),
        SizedBox(height: defaultPadding),
        Skeleton( width: 250),
      ],
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          color:const Color.fromARGB(255, 243, 239, 239).withOpacity(0.1),
          borderRadius:
              const BorderRadius.all(Radius.circular(defaultPadding))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
    );
  }
}
