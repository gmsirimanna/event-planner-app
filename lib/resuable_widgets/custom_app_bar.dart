import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:event_planner/utils/dimensions.dart';
import 'package:event_planner/utils/images.dart';
import 'package:event_planner/utils/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackVisible;
  final bool isCenter;
  final bool isElevation;

  final Function? onBackPressed;
  final Function? onBTPressed;

  CustomAppBar({
    required this.title,
    this.isBackVisible = true,
    this.onBackPressed,
    this.onBTPressed,
    this.isCenter = true,
    this.isElevation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorResources.backgroundColor,
      padding: const EdgeInsets.all(8.0),
      child: AppBar(
        elevation: isElevation ? 2 : 0,
        centerTitle: isCenter ? true : false,
        titleSpacing: 0,
        leading: isBackVisible
            ? IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.arrow_back_ios),
                color: Theme.of(context).textTheme.bodyMedium!.color,
                onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
              )
            : Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  Images.app_icon,
                  fit: BoxFit.contain,
                ),
              ),
        backgroundColor: ColorResources.backgroundColor,
        title: Text(title,
            style: poppinsMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE + 1,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            )),
        actions: [],
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 56);
}
