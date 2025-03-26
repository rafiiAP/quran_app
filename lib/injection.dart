import 'package:get_it/get_it.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/style.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/data/datasources/remote_datasource/remote_datasource.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/data/repositories_impl/remote_repository_impl.dart';
import 'package:quran_app/domain/repositories/remote_repository.dart';
import 'package:quran_app/domain/use_case/remote_usecase.dart';

GetIt locator = GetIt.instance;

void setup() {
  // usecase
  locator.registerLazySingleton(() => RemoteUsecase(locator()));

  // repository
  locator.registerLazySingleton<RemoteRepository>(
      () => RemoteRepositoryImpl(quranDatasource: locator()));

  // data source
  locator.registerLazySingleton<RemoteDatasource>(RemoteDatasourceImpl.new);

  //main function
  locator.registerLazySingleton<MainFunction>(MainFunction.new);

  //style
  locator.registerLazySingleton<MainStyle>(MainStyle.new);

  //main widget
  locator.registerLazySingleton<MainWidget>(MainWidget.new);

  //color
  locator.registerLazySingleton<AppColorConfig>(AppColorConfig.new);

  //appconfig
  locator.registerLazySingleton<AppConfig>(AppConfig.new);

  //image
  locator.registerLazySingleton<MyImage>(MyImage.new);

  // database
  locator.registerLazySingleton<DatabaseHelper>(DatabaseHelper.new);
}
