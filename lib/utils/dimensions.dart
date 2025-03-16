// ignore_for_file: constant_identifier_names
import 'package:sizer/sizer.dart';

class Dimensions {
  static const double FONT_SIZE_EXTRA_SMALL = 10.0;
  static const double FONT_SIZE_SMALL = 12.0;
  static const double FONT_SIZE_DEFAULT = 13.0;
  static const double FONT_SIZE_LARGE = 15.0;
  static const double FONT_SIZE_EXTRA_LARGE = 18.0;
  static const double FONT_SIZE_OVER_LARGE = 24.0;

  static const double PADDING_SIZE_EXTRA_SMALL = 5.0;
  static const double PADDING_SIZE_SMALL = 10.0;
  static const double PADDING_SIZE_DEFAULT = 15.0;
  static const double PADDING_SIZE_LARGE = 20.0;
  static const double PADDING_SIZE_EXTRA_LARGE = 25.0;
  static const double PADDING_SIZE_XXL = 20.0;

  static double fontSizeXExtraSmall = (SizerUtil.deviceType == DeviceType.mobile) ? 8.5.sp : 6.sp;
  static double fontSizeExtraSmall = (SizerUtil.deviceType == DeviceType.mobile) ? 9.5.sp : 6.5.sp;
  static double fontSizeSmall = (SizerUtil.deviceType == DeviceType.mobile) ? 12.sp : 8.sp;
  static double fontSizeDefault = (SizerUtil.deviceType == DeviceType.mobile) ? 14.5.sp : 12.5.sp;
  static double fontSizeLarge = (SizerUtil.deviceType == DeviceType.mobile) ? 16.sp : 12.sp;
  static double fontSizeExtraLarge = (SizerUtil.deviceType == DeviceType.mobile) ? 17.5.sp : 14.5.sp;
  static double fontSizeOverLarge = (SizerUtil.deviceType == DeviceType.mobile) ? 22.sp : 24.sp;
  static double fontSizeXOverLarge = (SizerUtil.deviceType == DeviceType.mobile) ? 33.sp : 22.sp;

  static const double APP_BAR_HEIGHT = 70.0;
}
