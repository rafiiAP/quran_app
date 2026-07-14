// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)
        loaded,
    required TResult Function(int nomorSurah, int? indexTandai)
        navigateToDetail,
    required TResult Function(String message) showMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)?
        loaded,
    TResult? Function(int nomorSurah, int? indexTandai)? navigateToDetail,
    TResult? Function(String message)? showMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)?
        loaded,
    TResult Function(int nomorSurah, int? indexTandai)? navigateToDetail,
    TResult Function(String message)? showMessage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NavigateToDetail value) navigateToDetail,
    required TResult Function(_ShowMessage value) showMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NavigateToDetail value)? navigateToDetail,
    TResult? Function(_ShowMessage value)? showMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NavigateToDetail value)? navigateToDetail,
    TResult Function(_ShowMessage value)? showMessage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'HomeState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)
        loaded,
    required TResult Function(int nomorSurah, int? indexTandai)
        navigateToDetail,
    required TResult Function(String message) showMessage,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)?
        loaded,
    TResult? Function(int nomorSurah, int? indexTandai)? navigateToDetail,
    TResult? Function(String message)? showMessage,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)?
        loaded,
    TResult Function(int nomorSurah, int? indexTandai)? navigateToDetail,
    TResult Function(String message)? showMessage,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NavigateToDetail value) navigateToDetail,
    required TResult Function(_ShowMessage value) showMessage,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NavigateToDetail value)? navigateToDetail,
    TResult? Function(_ShowMessage value)? showMessage,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NavigateToDetail value)? navigateToDetail,
    TResult Function(_ShowMessage value)? showMessage,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements HomeState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String namaLatin,
      int nomorSurah,
      int nomorAyat,
      List<SurahEntity> surahList});
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? namaLatin = null,
    Object? nomorSurah = null,
    Object? nomorAyat = null,
    Object? surahList = null,
  }) {
    return _then(_$LoadedImpl(
      namaLatin: null == namaLatin
          ? _value.namaLatin
          : namaLatin // ignore: cast_nullable_to_non_nullable
              as String,
      nomorSurah: null == nomorSurah
          ? _value.nomorSurah
          : nomorSurah // ignore: cast_nullable_to_non_nullable
              as int,
      nomorAyat: null == nomorAyat
          ? _value.nomorAyat
          : nomorAyat // ignore: cast_nullable_to_non_nullable
              as int,
      surahList: null == surahList
          ? _value._surahList
          : surahList // ignore: cast_nullable_to_non_nullable
              as List<SurahEntity>,
    ));
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(
      {required this.namaLatin,
      required this.nomorSurah,
      required this.nomorAyat,
      required final List<SurahEntity> surahList})
      : _surahList = surahList;

  @override
  final String namaLatin;
  @override
  final int nomorSurah;
  @override
  final int nomorAyat;
  final List<SurahEntity> _surahList;
  @override
  List<SurahEntity> get surahList {
    if (_surahList is EqualUnmodifiableListView) return _surahList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_surahList);
  }

  @override
  String toString() {
    return 'HomeState.loaded(namaLatin: $namaLatin, nomorSurah: $nomorSurah, nomorAyat: $nomorAyat, surahList: $surahList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            (identical(other.namaLatin, namaLatin) ||
                other.namaLatin == namaLatin) &&
            (identical(other.nomorSurah, nomorSurah) ||
                other.nomorSurah == nomorSurah) &&
            (identical(other.nomorAyat, nomorAyat) ||
                other.nomorAyat == nomorAyat) &&
            const DeepCollectionEquality()
                .equals(other._surahList, _surahList));
  }

  @override
  int get hashCode => Object.hash(runtimeType, namaLatin, nomorSurah, nomorAyat,
      const DeepCollectionEquality().hash(_surahList));

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)
        loaded,
    required TResult Function(int nomorSurah, int? indexTandai)
        navigateToDetail,
    required TResult Function(String message) showMessage,
  }) {
    return loaded(namaLatin, nomorSurah, nomorAyat, surahList);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)?
        loaded,
    TResult? Function(int nomorSurah, int? indexTandai)? navigateToDetail,
    TResult? Function(String message)? showMessage,
  }) {
    return loaded?.call(namaLatin, nomorSurah, nomorAyat, surahList);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)?
        loaded,
    TResult Function(int nomorSurah, int? indexTandai)? navigateToDetail,
    TResult Function(String message)? showMessage,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(namaLatin, nomorSurah, nomorAyat, surahList);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NavigateToDetail value) navigateToDetail,
    required TResult Function(_ShowMessage value) showMessage,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NavigateToDetail value)? navigateToDetail,
    TResult? Function(_ShowMessage value)? showMessage,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NavigateToDetail value)? navigateToDetail,
    TResult Function(_ShowMessage value)? showMessage,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements HomeState {
  const factory _Loaded(
      {required final String namaLatin,
      required final int nomorSurah,
      required final int nomorAyat,
      required final List<SurahEntity> surahList}) = _$LoadedImpl;

  String get namaLatin;
  int get nomorSurah;
  int get nomorAyat;
  List<SurahEntity> get surahList;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NavigateToDetailImplCopyWith<$Res> {
  factory _$$NavigateToDetailImplCopyWith(_$NavigateToDetailImpl value,
          $Res Function(_$NavigateToDetailImpl) then) =
      __$$NavigateToDetailImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int nomorSurah, int? indexTandai});
}

/// @nodoc
class __$$NavigateToDetailImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$NavigateToDetailImpl>
    implements _$$NavigateToDetailImplCopyWith<$Res> {
  __$$NavigateToDetailImplCopyWithImpl(_$NavigateToDetailImpl _value,
      $Res Function(_$NavigateToDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nomorSurah = null,
    Object? indexTandai = freezed,
  }) {
    return _then(_$NavigateToDetailImpl(
      nomorSurah: null == nomorSurah
          ? _value.nomorSurah
          : nomorSurah // ignore: cast_nullable_to_non_nullable
              as int,
      indexTandai: freezed == indexTandai
          ? _value.indexTandai
          : indexTandai // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$NavigateToDetailImpl implements _NavigateToDetail {
  const _$NavigateToDetailImpl(
      {required this.nomorSurah, required this.indexTandai});

  @override
  final int nomorSurah;
  @override
  final int? indexTandai;

  @override
  String toString() {
    return 'HomeState.navigateToDetail(nomorSurah: $nomorSurah, indexTandai: $indexTandai)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavigateToDetailImpl &&
            (identical(other.nomorSurah, nomorSurah) ||
                other.nomorSurah == nomorSurah) &&
            (identical(other.indexTandai, indexTandai) ||
                other.indexTandai == indexTandai));
  }

  @override
  int get hashCode => Object.hash(runtimeType, nomorSurah, indexTandai);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavigateToDetailImplCopyWith<_$NavigateToDetailImpl> get copyWith =>
      __$$NavigateToDetailImplCopyWithImpl<_$NavigateToDetailImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)
        loaded,
    required TResult Function(int nomorSurah, int? indexTandai)
        navigateToDetail,
    required TResult Function(String message) showMessage,
  }) {
    return navigateToDetail(nomorSurah, indexTandai);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)?
        loaded,
    TResult? Function(int nomorSurah, int? indexTandai)? navigateToDetail,
    TResult? Function(String message)? showMessage,
  }) {
    return navigateToDetail?.call(nomorSurah, indexTandai);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)?
        loaded,
    TResult Function(int nomorSurah, int? indexTandai)? navigateToDetail,
    TResult Function(String message)? showMessage,
    required TResult orElse(),
  }) {
    if (navigateToDetail != null) {
      return navigateToDetail(nomorSurah, indexTandai);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NavigateToDetail value) navigateToDetail,
    required TResult Function(_ShowMessage value) showMessage,
  }) {
    return navigateToDetail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NavigateToDetail value)? navigateToDetail,
    TResult? Function(_ShowMessage value)? showMessage,
  }) {
    return navigateToDetail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NavigateToDetail value)? navigateToDetail,
    TResult Function(_ShowMessage value)? showMessage,
    required TResult orElse(),
  }) {
    if (navigateToDetail != null) {
      return navigateToDetail(this);
    }
    return orElse();
  }
}

abstract class _NavigateToDetail implements HomeState {
  const factory _NavigateToDetail(
      {required final int nomorSurah,
      required final int? indexTandai}) = _$NavigateToDetailImpl;

  int get nomorSurah;
  int? get indexTandai;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavigateToDetailImplCopyWith<_$NavigateToDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ShowMessageImplCopyWith<$Res> {
  factory _$$ShowMessageImplCopyWith(
          _$ShowMessageImpl value, $Res Function(_$ShowMessageImpl) then) =
      __$$ShowMessageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ShowMessageImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$ShowMessageImpl>
    implements _$$ShowMessageImplCopyWith<$Res> {
  __$$ShowMessageImplCopyWithImpl(
      _$ShowMessageImpl _value, $Res Function(_$ShowMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ShowMessageImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ShowMessageImpl implements _ShowMessage {
  const _$ShowMessageImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'HomeState.showMessage(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShowMessageImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShowMessageImplCopyWith<_$ShowMessageImpl> get copyWith =>
      __$$ShowMessageImplCopyWithImpl<_$ShowMessageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)
        loaded,
    required TResult Function(int nomorSurah, int? indexTandai)
        navigateToDetail,
    required TResult Function(String message) showMessage,
  }) {
    return showMessage(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)?
        loaded,
    TResult? Function(int nomorSurah, int? indexTandai)? navigateToDetail,
    TResult? Function(String message)? showMessage,
  }) {
    return showMessage?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String namaLatin, int nomorSurah, int nomorAyat,
            List<SurahEntity> surahList)?
        loaded,
    TResult Function(int nomorSurah, int? indexTandai)? navigateToDetail,
    TResult Function(String message)? showMessage,
    required TResult orElse(),
  }) {
    if (showMessage != null) {
      return showMessage(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NavigateToDetail value) navigateToDetail,
    required TResult Function(_ShowMessage value) showMessage,
  }) {
    return showMessage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NavigateToDetail value)? navigateToDetail,
    TResult? Function(_ShowMessage value)? showMessage,
  }) {
    return showMessage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NavigateToDetail value)? navigateToDetail,
    TResult Function(_ShowMessage value)? showMessage,
    required TResult orElse(),
  }) {
    if (showMessage != null) {
      return showMessage(this);
    }
    return orElse();
  }
}

abstract class _ShowMessage implements HomeState {
  const factory _ShowMessage(final String message) = _$ShowMessageImpl;

  String get message;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShowMessageImplCopyWith<_$ShowMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
