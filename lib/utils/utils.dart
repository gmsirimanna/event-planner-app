import 'package:flutter/material.dart';
import 'package:event_planner/utils/dimensions.dart';

customSnackBar(BuildContext context, String msg, Color color) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        msg,
        style: TextStyle(
          fontSize: Dimensions.fontSizeSmall,
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
    ));
