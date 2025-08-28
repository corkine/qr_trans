// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferMetadata {

 String get transferId; String get fileName; int get totalChunks; int get fileSize; String get checksum; int get currentChunk;
/// Create a copy of TransferMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferMetadataCopyWith<TransferMetadata> get copyWith => _$TransferMetadataCopyWithImpl<TransferMetadata>(this as TransferMetadata, _$identity);

  /// Serializes this TransferMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferMetadata&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.totalChunks, totalChunks) || other.totalChunks == totalChunks)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.checksum, checksum) || other.checksum == checksum)&&(identical(other.currentChunk, currentChunk) || other.currentChunk == currentChunk));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transferId,fileName,totalChunks,fileSize,checksum,currentChunk);

@override
String toString() {
  return 'TransferMetadata(transferId: $transferId, fileName: $fileName, totalChunks: $totalChunks, fileSize: $fileSize, checksum: $checksum, currentChunk: $currentChunk)';
}


}

/// @nodoc
abstract mixin class $TransferMetadataCopyWith<$Res>  {
  factory $TransferMetadataCopyWith(TransferMetadata value, $Res Function(TransferMetadata) _then) = _$TransferMetadataCopyWithImpl;
@useResult
$Res call({
 String transferId, String fileName, int totalChunks, int fileSize, String checksum, int currentChunk
});




}
/// @nodoc
class _$TransferMetadataCopyWithImpl<$Res>
    implements $TransferMetadataCopyWith<$Res> {
  _$TransferMetadataCopyWithImpl(this._self, this._then);

  final TransferMetadata _self;
  final $Res Function(TransferMetadata) _then;

/// Create a copy of TransferMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transferId = null,Object? fileName = null,Object? totalChunks = null,Object? fileSize = null,Object? checksum = null,Object? currentChunk = null,}) {
  return _then(_self.copyWith(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,totalChunks: null == totalChunks ? _self.totalChunks : totalChunks // ignore: cast_nullable_to_non_nullable
as int,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,checksum: null == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String,currentChunk: null == currentChunk ? _self.currentChunk : currentChunk // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferMetadata].
extension TransferMetadataPatterns on TransferMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferMetadata value)  $default,){
final _that = this;
switch (_that) {
case _TransferMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _TransferMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transferId,  String fileName,  int totalChunks,  int fileSize,  String checksum,  int currentChunk)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferMetadata() when $default != null:
return $default(_that.transferId,_that.fileName,_that.totalChunks,_that.fileSize,_that.checksum,_that.currentChunk);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transferId,  String fileName,  int totalChunks,  int fileSize,  String checksum,  int currentChunk)  $default,) {final _that = this;
switch (_that) {
case _TransferMetadata():
return $default(_that.transferId,_that.fileName,_that.totalChunks,_that.fileSize,_that.checksum,_that.currentChunk);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transferId,  String fileName,  int totalChunks,  int fileSize,  String checksum,  int currentChunk)?  $default,) {final _that = this;
switch (_that) {
case _TransferMetadata() when $default != null:
return $default(_that.transferId,_that.fileName,_that.totalChunks,_that.fileSize,_that.checksum,_that.currentChunk);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferMetadata implements TransferMetadata {
  const _TransferMetadata({required this.transferId, required this.fileName, required this.totalChunks, required this.fileSize, required this.checksum, this.currentChunk = 0});
  factory _TransferMetadata.fromJson(Map<String, dynamic> json) => _$TransferMetadataFromJson(json);

@override final  String transferId;
@override final  String fileName;
@override final  int totalChunks;
@override final  int fileSize;
@override final  String checksum;
@override@JsonKey() final  int currentChunk;

/// Create a copy of TransferMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferMetadataCopyWith<_TransferMetadata> get copyWith => __$TransferMetadataCopyWithImpl<_TransferMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferMetadata&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.totalChunks, totalChunks) || other.totalChunks == totalChunks)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.checksum, checksum) || other.checksum == checksum)&&(identical(other.currentChunk, currentChunk) || other.currentChunk == currentChunk));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transferId,fileName,totalChunks,fileSize,checksum,currentChunk);

@override
String toString() {
  return 'TransferMetadata(transferId: $transferId, fileName: $fileName, totalChunks: $totalChunks, fileSize: $fileSize, checksum: $checksum, currentChunk: $currentChunk)';
}


}

/// @nodoc
abstract mixin class _$TransferMetadataCopyWith<$Res> implements $TransferMetadataCopyWith<$Res> {
  factory _$TransferMetadataCopyWith(_TransferMetadata value, $Res Function(_TransferMetadata) _then) = __$TransferMetadataCopyWithImpl;
@override @useResult
$Res call({
 String transferId, String fileName, int totalChunks, int fileSize, String checksum, int currentChunk
});




}
/// @nodoc
class __$TransferMetadataCopyWithImpl<$Res>
    implements _$TransferMetadataCopyWith<$Res> {
  __$TransferMetadataCopyWithImpl(this._self, this._then);

  final _TransferMetadata _self;
  final $Res Function(_TransferMetadata) _then;

/// Create a copy of TransferMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transferId = null,Object? fileName = null,Object? totalChunks = null,Object? fileSize = null,Object? checksum = null,Object? currentChunk = null,}) {
  return _then(_TransferMetadata(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,totalChunks: null == totalChunks ? _self.totalChunks : totalChunks // ignore: cast_nullable_to_non_nullable
as int,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,checksum: null == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String,currentChunk: null == currentChunk ? _self.currentChunk : currentChunk // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FileChunk {

 String get transferId; int get chunkIndex; String get data; String get checksum;
/// Create a copy of FileChunk
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileChunkCopyWith<FileChunk> get copyWith => _$FileChunkCopyWithImpl<FileChunk>(this as FileChunk, _$identity);

  /// Serializes this FileChunk to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileChunk&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.chunkIndex, chunkIndex) || other.chunkIndex == chunkIndex)&&(identical(other.data, data) || other.data == data)&&(identical(other.checksum, checksum) || other.checksum == checksum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transferId,chunkIndex,data,checksum);

@override
String toString() {
  return 'FileChunk(transferId: $transferId, chunkIndex: $chunkIndex, data: $data, checksum: $checksum)';
}


}

/// @nodoc
abstract mixin class $FileChunkCopyWith<$Res>  {
  factory $FileChunkCopyWith(FileChunk value, $Res Function(FileChunk) _then) = _$FileChunkCopyWithImpl;
@useResult
$Res call({
 String transferId, int chunkIndex, String data, String checksum
});




}
/// @nodoc
class _$FileChunkCopyWithImpl<$Res>
    implements $FileChunkCopyWith<$Res> {
  _$FileChunkCopyWithImpl(this._self, this._then);

  final FileChunk _self;
  final $Res Function(FileChunk) _then;

/// Create a copy of FileChunk
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transferId = null,Object? chunkIndex = null,Object? data = null,Object? checksum = null,}) {
  return _then(_self.copyWith(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,chunkIndex: null == chunkIndex ? _self.chunkIndex : chunkIndex // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,checksum: null == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FileChunk].
extension FileChunkPatterns on FileChunk {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileChunk value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileChunk() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileChunk value)  $default,){
final _that = this;
switch (_that) {
case _FileChunk():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileChunk value)?  $default,){
final _that = this;
switch (_that) {
case _FileChunk() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transferId,  int chunkIndex,  String data,  String checksum)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileChunk() when $default != null:
return $default(_that.transferId,_that.chunkIndex,_that.data,_that.checksum);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transferId,  int chunkIndex,  String data,  String checksum)  $default,) {final _that = this;
switch (_that) {
case _FileChunk():
return $default(_that.transferId,_that.chunkIndex,_that.data,_that.checksum);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transferId,  int chunkIndex,  String data,  String checksum)?  $default,) {final _that = this;
switch (_that) {
case _FileChunk() when $default != null:
return $default(_that.transferId,_that.chunkIndex,_that.data,_that.checksum);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileChunk implements FileChunk {
  const _FileChunk({required this.transferId, required this.chunkIndex, required this.data, required this.checksum});
  factory _FileChunk.fromJson(Map<String, dynamic> json) => _$FileChunkFromJson(json);

@override final  String transferId;
@override final  int chunkIndex;
@override final  String data;
@override final  String checksum;

/// Create a copy of FileChunk
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileChunkCopyWith<_FileChunk> get copyWith => __$FileChunkCopyWithImpl<_FileChunk>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileChunkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileChunk&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.chunkIndex, chunkIndex) || other.chunkIndex == chunkIndex)&&(identical(other.data, data) || other.data == data)&&(identical(other.checksum, checksum) || other.checksum == checksum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transferId,chunkIndex,data,checksum);

@override
String toString() {
  return 'FileChunk(transferId: $transferId, chunkIndex: $chunkIndex, data: $data, checksum: $checksum)';
}


}

/// @nodoc
abstract mixin class _$FileChunkCopyWith<$Res> implements $FileChunkCopyWith<$Res> {
  factory _$FileChunkCopyWith(_FileChunk value, $Res Function(_FileChunk) _then) = __$FileChunkCopyWithImpl;
@override @useResult
$Res call({
 String transferId, int chunkIndex, String data, String checksum
});




}
/// @nodoc
class __$FileChunkCopyWithImpl<$Res>
    implements _$FileChunkCopyWith<$Res> {
  __$FileChunkCopyWithImpl(this._self, this._then);

  final _FileChunk _self;
  final $Res Function(_FileChunk) _then;

/// Create a copy of FileChunk
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transferId = null,Object? chunkIndex = null,Object? data = null,Object? checksum = null,}) {
  return _then(_FileChunk(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,chunkIndex: null == chunkIndex ? _self.chunkIndex : chunkIndex // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,checksum: null == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TransferProgress {

 String get transferId; int get receivedChunks; int get totalChunks; Map<int, String> get chunks; TransferMetadata? get metadata;
/// Create a copy of TransferProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferProgressCopyWith<TransferProgress> get copyWith => _$TransferProgressCopyWithImpl<TransferProgress>(this as TransferProgress, _$identity);

  /// Serializes this TransferProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferProgress&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.receivedChunks, receivedChunks) || other.receivedChunks == receivedChunks)&&(identical(other.totalChunks, totalChunks) || other.totalChunks == totalChunks)&&const DeepCollectionEquality().equals(other.chunks, chunks)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transferId,receivedChunks,totalChunks,const DeepCollectionEquality().hash(chunks),metadata);

@override
String toString() {
  return 'TransferProgress(transferId: $transferId, receivedChunks: $receivedChunks, totalChunks: $totalChunks, chunks: $chunks, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $TransferProgressCopyWith<$Res>  {
  factory $TransferProgressCopyWith(TransferProgress value, $Res Function(TransferProgress) _then) = _$TransferProgressCopyWithImpl;
@useResult
$Res call({
 String transferId, int receivedChunks, int totalChunks, Map<int, String> chunks, TransferMetadata? metadata
});


$TransferMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$TransferProgressCopyWithImpl<$Res>
    implements $TransferProgressCopyWith<$Res> {
  _$TransferProgressCopyWithImpl(this._self, this._then);

  final TransferProgress _self;
  final $Res Function(TransferProgress) _then;

/// Create a copy of TransferProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transferId = null,Object? receivedChunks = null,Object? totalChunks = null,Object? chunks = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,receivedChunks: null == receivedChunks ? _self.receivedChunks : receivedChunks // ignore: cast_nullable_to_non_nullable
as int,totalChunks: null == totalChunks ? _self.totalChunks : totalChunks // ignore: cast_nullable_to_non_nullable
as int,chunks: null == chunks ? _self.chunks : chunks // ignore: cast_nullable_to_non_nullable
as Map<int, String>,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as TransferMetadata?,
  ));
}
/// Create a copy of TransferProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransferMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $TransferMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransferProgress].
extension TransferProgressPatterns on TransferProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferProgress value)  $default,){
final _that = this;
switch (_that) {
case _TransferProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferProgress value)?  $default,){
final _that = this;
switch (_that) {
case _TransferProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transferId,  int receivedChunks,  int totalChunks,  Map<int, String> chunks,  TransferMetadata? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferProgress() when $default != null:
return $default(_that.transferId,_that.receivedChunks,_that.totalChunks,_that.chunks,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transferId,  int receivedChunks,  int totalChunks,  Map<int, String> chunks,  TransferMetadata? metadata)  $default,) {final _that = this;
switch (_that) {
case _TransferProgress():
return $default(_that.transferId,_that.receivedChunks,_that.totalChunks,_that.chunks,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transferId,  int receivedChunks,  int totalChunks,  Map<int, String> chunks,  TransferMetadata? metadata)?  $default,) {final _that = this;
switch (_that) {
case _TransferProgress() when $default != null:
return $default(_that.transferId,_that.receivedChunks,_that.totalChunks,_that.chunks,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferProgress implements TransferProgress {
  const _TransferProgress({required this.transferId, required this.receivedChunks, required this.totalChunks, required final  Map<int, String> chunks, this.metadata}): _chunks = chunks;
  factory _TransferProgress.fromJson(Map<String, dynamic> json) => _$TransferProgressFromJson(json);

@override final  String transferId;
@override final  int receivedChunks;
@override final  int totalChunks;
 final  Map<int, String> _chunks;
@override Map<int, String> get chunks {
  if (_chunks is EqualUnmodifiableMapView) return _chunks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_chunks);
}

@override final  TransferMetadata? metadata;

/// Create a copy of TransferProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferProgressCopyWith<_TransferProgress> get copyWith => __$TransferProgressCopyWithImpl<_TransferProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferProgress&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.receivedChunks, receivedChunks) || other.receivedChunks == receivedChunks)&&(identical(other.totalChunks, totalChunks) || other.totalChunks == totalChunks)&&const DeepCollectionEquality().equals(other._chunks, _chunks)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transferId,receivedChunks,totalChunks,const DeepCollectionEquality().hash(_chunks),metadata);

@override
String toString() {
  return 'TransferProgress(transferId: $transferId, receivedChunks: $receivedChunks, totalChunks: $totalChunks, chunks: $chunks, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$TransferProgressCopyWith<$Res> implements $TransferProgressCopyWith<$Res> {
  factory _$TransferProgressCopyWith(_TransferProgress value, $Res Function(_TransferProgress) _then) = __$TransferProgressCopyWithImpl;
@override @useResult
$Res call({
 String transferId, int receivedChunks, int totalChunks, Map<int, String> chunks, TransferMetadata? metadata
});


@override $TransferMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$TransferProgressCopyWithImpl<$Res>
    implements _$TransferProgressCopyWith<$Res> {
  __$TransferProgressCopyWithImpl(this._self, this._then);

  final _TransferProgress _self;
  final $Res Function(_TransferProgress) _then;

/// Create a copy of TransferProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transferId = null,Object? receivedChunks = null,Object? totalChunks = null,Object? chunks = null,Object? metadata = freezed,}) {
  return _then(_TransferProgress(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,receivedChunks: null == receivedChunks ? _self.receivedChunks : receivedChunks // ignore: cast_nullable_to_non_nullable
as int,totalChunks: null == totalChunks ? _self.totalChunks : totalChunks // ignore: cast_nullable_to_non_nullable
as int,chunks: null == chunks ? _self._chunks : chunks // ignore: cast_nullable_to_non_nullable
as Map<int, String>,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as TransferMetadata?,
  ));
}

/// Create a copy of TransferProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransferMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $TransferMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
