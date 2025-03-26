import 'package:dartz/dartz.dart';

import 'package:equatable/equatable.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => <Object>[message];
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

  Future<Either<Failure, DetailEntity>> getDetailSurah(
      {required final int nomor});

  Future<Either<Failure, JadwalSholatEntity>> getJadwalSholat({
    required final double latitude,
    required final double longitude,
    required final String date,
  });
}
