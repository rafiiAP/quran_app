import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:quran_app/data/constant/config.dart';

import '../../data/constant/color.dart';
import '../../data/constant/enum.dart';
import '../function/main_function.dart';

part 'bottomsheet_widget.dart';
part 'text_widget.dart';
part 'button_widget.dart';
part 'padding_widget.dart';
part 'input_widget.dart';

MainWidget get W => MainWidget._internal();

class MainWidget with BottomsheetWidget, TextWidget, ButtonWidget, PaddingWidget, InputWidget {
  MainWidget._internal();
}
