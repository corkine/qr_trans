// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

 double get qrSize; int get playbackSpeed;// milliseconds between frames
 int get errorCorrectionLevel; double get chunkSizeRatio;// 0-100 ratio for chunk size
 bool get autoPlay; bool get darkMode;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.qrSize, qrSize) || other.qrSize == qrSize)&&(identical(other.playbackSpeed, playbackSpeed) || other.playbackSpeed == playbackSpeed)&&(identical(other.errorCorrectionLevel, errorCorrectionLevel) || other.errorCorrectionLevel == errorCorrectionLevel)&&(identical(other.chunkSizeRatio, chunkSizeRatio) || other.chunkSizeRatio == chunkSizeRatio)&&(identical(other.autoPlay, autoPlay) || other.autoPlay == autoPlay)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,qrSize,playbackSpeed,errorCorrectionLevel,chunkSizeRatio,autoPlay,darkMode);

@override
String toString() {
  return 'AppSettings(qrSize: $qrSize, playbackSpeed: $playbackSpeed, errorCorrectionLevel: $errorCorrectionLevel, chunkSizeRatio: $chunkSizeRatio, autoPlay: $autoPlay, darkMode: $darkMode)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 double qrSize, int playbackSpeed, int errorCorrectionLevel, double chunkSizeRatio, bool autoPlay, bool darkMode
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? qrSize = null,Object? playbackSpeed = null,Object? errorCorrectionLevel = null,Object? chunkSizeRatio = null,Object? autoPlay = null,Object? darkMode = null,}) {
  return _then(_self.copyWith(
qrSize: null == qrSize ? _self.qrSize : qrSize // ignore: cast_nullable_to_non_nullable
as double,playbackSpeed: null == playbackSpeed ? _self.playbackSpeed : playbackSpeed // ignore: cast_nullable_to_non_nullable
as int,errorCorrectionLevel: null == errorCorrectionLevel ? _self.errorCorrectionLevel : errorCorrectionLevel // ignore: cast_nullable_to_non_nullable
as int,chunkSizeRatio: null == chunkSizeRatio ? _self.chunkSizeRatio : chunkSizeRatio // ignore: cast_nullable_to_non_nullable
as double,autoPlay: null == autoPlay ? _self.autoPlay : autoPlay // ignore: cast_nullable_to_non_nullable
as bool,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double qrSize,  int playbackSpeed,  int errorCorrectionLevel,  double chunkSizeRatio,  bool autoPlay,  bool darkMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.qrSize,_that.playbackSpeed,_that.errorCorrectionLevel,_that.chunkSizeRatio,_that.autoPlay,_that.darkMode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double qrSize,  int playbackSpeed,  int errorCorrectionLevel,  double chunkSizeRatio,  bool autoPlay,  bool darkMode)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.qrSize,_that.playbackSpeed,_that.errorCorrectionLevel,_that.chunkSizeRatio,_that.autoPlay,_that.darkMode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double qrSize,  int playbackSpeed,  int errorCorrectionLevel,  double chunkSizeRatio,  bool autoPlay,  bool darkMode)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.qrSize,_that.playbackSpeed,_that.errorCorrectionLevel,_that.chunkSizeRatio,_that.autoPlay,_that.darkMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings implements AppSettings {
  const _AppSettings({this.qrSize = 200.0, this.playbackSpeed = 1000, this.errorCorrectionLevel = 1, this.chunkSizeRatio = 50.0, this.autoPlay = true, this.darkMode = false});
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

@override@JsonKey() final  double qrSize;
@override@JsonKey() final  int playbackSpeed;
// milliseconds between frames
@override@JsonKey() final  int errorCorrectionLevel;
@override@JsonKey() final  double chunkSizeRatio;
// 0-100 ratio for chunk size
@override@JsonKey() final  bool autoPlay;
@override@JsonKey() final  bool darkMode;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.qrSize, qrSize) || other.qrSize == qrSize)&&(identical(other.playbackSpeed, playbackSpeed) || other.playbackSpeed == playbackSpeed)&&(identical(other.errorCorrectionLevel, errorCorrectionLevel) || other.errorCorrectionLevel == errorCorrectionLevel)&&(identical(other.chunkSizeRatio, chunkSizeRatio) || other.chunkSizeRatio == chunkSizeRatio)&&(identical(other.autoPlay, autoPlay) || other.autoPlay == autoPlay)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,qrSize,playbackSpeed,errorCorrectionLevel,chunkSizeRatio,autoPlay,darkMode);

@override
String toString() {
  return 'AppSettings(qrSize: $qrSize, playbackSpeed: $playbackSpeed, errorCorrectionLevel: $errorCorrectionLevel, chunkSizeRatio: $chunkSizeRatio, autoPlay: $autoPlay, darkMode: $darkMode)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 double qrSize, int playbackSpeed, int errorCorrectionLevel, double chunkSizeRatio, bool autoPlay, bool darkMode
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qrSize = null,Object? playbackSpeed = null,Object? errorCorrectionLevel = null,Object? chunkSizeRatio = null,Object? autoPlay = null,Object? darkMode = null,}) {
  return _then(_AppSettings(
qrSize: null == qrSize ? _self.qrSize : qrSize // ignore: cast_nullable_to_non_nullable
as double,playbackSpeed: null == playbackSpeed ? _self.playbackSpeed : playbackSpeed // ignore: cast_nullable_to_non_nullable
as int,errorCorrectionLevel: null == errorCorrectionLevel ? _self.errorCorrectionLevel : errorCorrectionLevel // ignore: cast_nullable_to_non_nullable
as int,chunkSizeRatio: null == chunkSizeRatio ? _self.chunkSizeRatio : chunkSizeRatio // ignore: cast_nullable_to_non_nullable
as double,autoPlay: null == autoPlay ? _self.autoPlay : autoPlay // ignore: cast_nullable_to_non_nullable
as bool,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AppState {

 AppSettings get settings; TransferStatus get status; TransferProgress? get activeTransfer;// 改为单个传输
 String? get currentTransferId; String? get errorMessage;
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppStateCopyWith<AppState> get copyWith => _$AppStateCopyWithImpl<AppState>(this as AppState, _$identity);

  /// Serializes this AppState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppState&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.status, status) || other.status == status)&&(identical(other.activeTransfer, activeTransfer) || other.activeTransfer == activeTransfer)&&(identical(other.currentTransferId, currentTransferId) || other.currentTransferId == currentTransferId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,settings,status,activeTransfer,currentTransferId,errorMessage);

@override
String toString() {
  return 'AppState(settings: $settings, status: $status, activeTransfer: $activeTransfer, currentTransferId: $currentTransferId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AppStateCopyWith<$Res>  {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) _then) = _$AppStateCopyWithImpl;
@useResult
$Res call({
 AppSettings settings, TransferStatus status, TransferProgress? activeTransfer, String? currentTransferId, String? errorMessage
});


$AppSettingsCopyWith<$Res> get settings;$TransferProgressCopyWith<$Res>? get activeTransfer;

}
/// @nodoc
class _$AppStateCopyWithImpl<$Res>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._self, this._then);

  final AppState _self;
  final $Res Function(AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? settings = null,Object? status = null,Object? activeTransfer = freezed,Object? currentTransferId = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,activeTransfer: freezed == activeTransfer ? _self.activeTransfer : activeTransfer // ignore: cast_nullable_to_non_nullable
as TransferProgress?,currentTransferId: freezed == currentTransferId ? _self.currentTransferId : currentTransferId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<$Res> get settings {
  
  return $AppSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransferProgressCopyWith<$Res>? get activeTransfer {
    if (_self.activeTransfer == null) {
    return null;
  }

  return $TransferProgressCopyWith<$Res>(_self.activeTransfer!, (value) {
    return _then(_self.copyWith(activeTransfer: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppState].
extension AppStatePatterns on AppState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppState value)  $default,){
final _that = this;
switch (_that) {
case _AppState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppState value)?  $default,){
final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppSettings settings,  TransferStatus status,  TransferProgress? activeTransfer,  String? currentTransferId,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that.settings,_that.status,_that.activeTransfer,_that.currentTransferId,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppSettings settings,  TransferStatus status,  TransferProgress? activeTransfer,  String? currentTransferId,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AppState():
return $default(_that.settings,_that.status,_that.activeTransfer,_that.currentTransferId,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppSettings settings,  TransferStatus status,  TransferProgress? activeTransfer,  String? currentTransferId,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that.settings,_that.status,_that.activeTransfer,_that.currentTransferId,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppState implements AppState {
  const _AppState({this.settings = const AppSettings(), this.status = TransferStatus.idle, this.activeTransfer, this.currentTransferId, this.errorMessage});
  factory _AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);

@override@JsonKey() final  AppSettings settings;
@override@JsonKey() final  TransferStatus status;
@override final  TransferProgress? activeTransfer;
// 改为单个传输
@override final  String? currentTransferId;
@override final  String? errorMessage;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStateCopyWith<_AppState> get copyWith => __$AppStateCopyWithImpl<_AppState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppState&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.status, status) || other.status == status)&&(identical(other.activeTransfer, activeTransfer) || other.activeTransfer == activeTransfer)&&(identical(other.currentTransferId, currentTransferId) || other.currentTransferId == currentTransferId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,settings,status,activeTransfer,currentTransferId,errorMessage);

@override
String toString() {
  return 'AppState(settings: $settings, status: $status, activeTransfer: $activeTransfer, currentTransferId: $currentTransferId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) _then) = __$AppStateCopyWithImpl;
@override @useResult
$Res call({
 AppSettings settings, TransferStatus status, TransferProgress? activeTransfer, String? currentTransferId, String? errorMessage
});


@override $AppSettingsCopyWith<$Res> get settings;@override $TransferProgressCopyWith<$Res>? get activeTransfer;

}
/// @nodoc
class __$AppStateCopyWithImpl<$Res>
    implements _$AppStateCopyWith<$Res> {
  __$AppStateCopyWithImpl(this._self, this._then);

  final _AppState _self;
  final $Res Function(_AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? settings = null,Object? status = null,Object? activeTransfer = freezed,Object? currentTransferId = freezed,Object? errorMessage = freezed,}) {
  return _then(_AppState(
settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,activeTransfer: freezed == activeTransfer ? _self.activeTransfer : activeTransfer // ignore: cast_nullable_to_non_nullable
as TransferProgress?,currentTransferId: freezed == currentTransferId ? _self.currentTransferId : currentTransferId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<$Res> get settings {
  
  return $AppSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransferProgressCopyWith<$Res>? get activeTransfer {
    if (_self.activeTransfer == null) {
    return null;
  }

  return $TransferProgressCopyWith<$Res>(_self.activeTransfer!, (value) {
    return _then(_self.copyWith(activeTransfer: value));
  });
}
}

// dart format on
