import 'package:quran_app/injection.dart';

MyImage get imageConfig => locator<MyImage>();

class MyImage {
  String bgSplash = 'assets/images/bg_splash.png';
  String quran = 'assets/images/quran.png';
  String menu = 'assets/images/menu.png';
  String borderNum = 'assets/images/border_number.png';
  String bookmark = 'assets/images/bookmark.png';
  String bookCard = 'assets/images/book_card.png';
  String sholat = 'assets/images/sholat.png';
  String bookNav = 'assets/images/book_nav.png';
  String lamp = 'assets/images/lamp.png';
  String shalat = 'assets/images/shalat.png';
  String masjid = 'assets/images/masjid.png';
}
