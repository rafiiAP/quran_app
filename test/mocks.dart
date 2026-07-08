import 'package:mocktail/mocktail.dart';
import 'package:quran_app/data/datasources/crash_reporter.dart';
import 'package:quran_app/data/datasources/http_client.dart';
import 'package:quran_app/domain/repositories/remote_repository.dart';
import 'package:quran_app/domain/use_case/remote_usecase.dart';
import 'package:quran_app/data/datasources/remote_datasource/remote_datasource.dart';
import 'package:quran_app/data/db/database_helper.dart';

// Domain layer
class MockRemoteRepository extends Mock implements RemoteRepository {}

class MockRemoteUsecase extends Mock implements RemoteUsecase {}

// Data layer
class MockRemoteDatasource extends Mock implements RemoteDatasource {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

// Infrastructure
class MockAppHttpClient extends Mock implements AppHttpClient {}

class MockCrashReporter extends Mock implements CrashReporter {}
