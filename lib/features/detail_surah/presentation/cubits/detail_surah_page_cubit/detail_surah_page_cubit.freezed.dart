// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_surah_page_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DetailSurahPageState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? lastActionMessage) idle,
    required TResult Function(String message) actionCompleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? lastActionMessage)? idle,
    TResult? Function(String message)? actionCompleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? lastActionMessage)? idle,
    TResult Function(String message)? actionCompleted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_ActionCompleted value) actionCompleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_ActionCompleted value)? actionCompleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_ActionCompleted value)? actionCompleted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailSurahPageStateCopyWith<$Res> {
  factory $DetailSurahPageStateCopyWith(DetailSurahPageState value,
          $Res Function(DetailSurahPageState) then) =
      _$DetailSurahPageStateCopyWithImpl<$Res, DetailSurahPageState>;
}

/// @nodoc
class _$DetailSurahPageStateCopyWithImpl<$Res,
        $Val extends DetailSurahPageState>
    implements $DetailSurahPageStateCopyWith<$Res> {
  _$DetailSurahPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailSurahPageState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$IdleImplCopyWith<$Res> {
  factory _$$IdleImplCopyWith(
          _$IdleImpl value, $Res Function(_$IdleImpl) then) =
      __$$IdleImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? lastActionMessage});
}

/// @nodoc
class __$$IdleImplCopyWithImpl<$Res>
    extends _$DetailSurahPageStateCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of DetailSurahPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastActionMessage = freezed,
  }) {
    return _then(_$IdleImpl(
      lastActionMessage: freezed == lastActionMessage
          ? _value.lastActionMessage
          : lastActionMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$IdleImpl implements _Idle {
  const _$IdleImpl({this.lastActionMessage});

  /// Transient message from the last completed action.
  /// UI should consume this (e.g., show SnackBar) and then call
  /// [DetailSurahPageCubit.clearLastAction] to reset.
  @override
  final String? lastActionMessage;

  @override
  String toString() {
    return 'DetailSurahPageState.idle(lastActionMessage: $lastActionMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdleImpl &&
            (identical(other.lastActionMessage, lastActionMessage) ||
                other.lastActionMessage == lastActionMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lastActionMessage);

  /// Create a copy of DetailSurahPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IdleImplCopyWith<_$IdleImpl> get copyWith =>
      __$$IdleImplCopyWithImpl<_$IdleImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? lastActionMessage) idle,
    required TResult Function(String message) actionCompleted,
  }) {
    return idle(lastActionMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? lastActionMessage)? idle,
    TResult? Function(String message)? actionCompleted,
  }) {
    return idle?.call(lastActionMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? lastActionMessage)? idle,
    TResult Function(String message)? actionCompleted,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(lastActionMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_ActionCompleted value) actionCompleted,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_ActionCompleted value)? actionCompleted,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_ActionCompleted value)? actionCompleted,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle implements DetailSurahPageState {
  const factory _Idle({final String? lastActionMessage}) = _$IdleImpl;

  /// Transient message from the last completed action.
  /// UI should consume this (e.g., show SnackBar) and then call
  /// [DetailSurahPageCubit.clearLastAction] to reset.
  String? get lastActionMessage;

  /// Create a copy of DetailSurahPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IdleImplCopyWith<_$IdleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ActionCompletedImplCopyWith<$Res> {
  factory _$$ActionCompletedImplCopyWith(_$ActionCompletedImpl value,
          $Res Function(_$ActionCompletedImpl) then) =
      __$$ActionCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ActionCompletedImplCopyWithImpl<$Res>
    extends _$DetailSurahPageStateCopyWithImpl<$Res, _$ActionCompletedImpl>
    implements _$$ActionCompletedImplCopyWith<$Res> {
  __$$ActionCompletedImplCopyWithImpl(
      _$ActionCompletedImpl _value, $Res Function(_$ActionCompletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DetailSurahPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ActionCompletedImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ActionCompletedImpl implements _ActionCompleted {
  const _$ActionCompletedImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'DetailSurahPageState.actionCompleted(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionCompletedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DetailSurahPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionCompletedImplCopyWith<_$ActionCompletedImpl> get copyWith =>
      __$$ActionCompletedImplCopyWithImpl<_$ActionCompletedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? lastActionMessage) idle,
    required TResult Function(String message) actionCompleted,
  }) {
    return actionCompleted(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? lastActionMessage)? idle,
    TResult? Function(String message)? actionCompleted,
  }) {
    return actionCompleted?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? lastActionMessage)? idle,
    TResult Function(String message)? actionCompleted,
    required TResult orElse(),
  }) {
    if (actionCompleted != null) {
      return actionCompleted(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_ActionCompleted value) actionCompleted,
  }) {
    return actionCompleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_ActionCompleted value)? actionCompleted,
  }) {
    return actionCompleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_ActionCompleted value)? actionCompleted,
    required TResult orElse(),
  }) {
    if (actionCompleted != null) {
      return actionCompleted(this);
    }
    return orElse();
  }
}

abstract class _ActionCompleted implements DetailSurahPageState {
  const factory _ActionCompleted({required final String message}) =
      _$ActionCompletedImpl;

  String get message;

  /// Create a copy of DetailSurahPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionCompletedImplCopyWith<_$ActionCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
