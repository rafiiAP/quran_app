import 'package:dartz/dartz.dart';

import 'package:equatable/equatable.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ResponseFailure extends Failure {
  const ResponseFailure(super.message);
}

abstract class RemoteRepository {
  Future<Either<Failure, List<SurahEntity>>> getSurah();

  Future<Either<Failure, DetailEntity>> getDetailSurah({required int nomor});

  Future<Either<Failure, JadwalSholatEntity>> getJadwalSholat({
    required double latitude,
    required double longitude,
    required String date,
  });
}
