import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/injection.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/constant/color.dart';
import '../../data/constant/enum.dart';
import '../function/main_function.dart';

part 'bottomsheet_widget.dart';
part 'text_widget.dart';
part 'button_widget.dart';
part 'padding_widget.dart';
part 'input_widget.dart';

MainWidget get W => locator<MainWidget>();

class MainWidget
    with
        BottomsheetWidget,
        TextWidget,
        ButtonWidget,
        PaddingWidget,
        InputWidget {
  Widget shimmer({required final double width, required final double height}) {
    return Shimmer.fromColors(
      baseColor: colorConfig.lightGrey,
      highlightColor: colorConfig.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: colorConfig.lightGrey,
        ),
      ),
    );
  }
}
