class MyImage {
  static final MyImage _instance = MyImage._internal();

  MyImage._internal();

  factory MyImage() {
    return _instance;
  }

  static const String bgSplash = 'assets/images/bg_splash.png';
  static const String quran = 'assets/images/quran.png';
  static const String menu = 'assets/images/menu.png';
  static const String borderNum = 'assets/images/border_number.png';
  static const String bookmark = 'assets/images/bookmark.png';
  static const String bookCard = 'assets/images/book_card.png';
  static const String sholat = 'assets/images/sholat.png';
  static const String bookNav = 'assets/images/book_nav.png';
  static const String lamp = 'assets/images/lamp.png';
}
