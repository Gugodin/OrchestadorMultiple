// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orchestrator_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrchestratorEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrchestratorEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrchestratorEvent()';
}


}

/// @nodoc
class $OrchestratorEventCopyWith<$Res>  {
$OrchestratorEventCopyWith(OrchestratorEvent _, $Res Function(OrchestratorEvent) __);
}


/// Adds pattern-matching-related methods to [OrchestratorEvent].
extension OrchestratorEventPatterns on OrchestratorEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _TaskCompleted value)?  taskCompleted,TResult Function( _TaskFailed value)?  taskFailed,TResult Function( _Retry value)?  retry,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TaskCompleted() when taskCompleted != null:
return taskCompleted(_that);case _TaskFailed() when taskFailed != null:
return taskFailed(_that);case _Retry() when retry != null:
return retry(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _TaskCompleted value)  taskCompleted,required TResult Function( _TaskFailed value)  taskFailed,required TResult Function( _Retry value)  retry,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _TaskCompleted():
return taskCompleted(_that);case _TaskFailed():
return taskFailed(_that);case _Retry():
return retry(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _TaskCompleted value)?  taskCompleted,TResult? Function( _TaskFailed value)?  taskFailed,TResult? Function( _Retry value)?  retry,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TaskCompleted() when taskCompleted != null:
return taskCompleted(_that);case _TaskFailed() when taskFailed != null:
return taskFailed(_that);case _Retry() when retry != null:
return retry(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( UserRole role)?  started,TResult Function()?  taskCompleted,TResult Function( String error)?  taskFailed,TResult Function()?  retry,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.role);case _TaskCompleted() when taskCompleted != null:
return taskCompleted();case _TaskFailed() when taskFailed != null:
return taskFailed(_that.error);case _Retry() when retry != null:
return retry();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( UserRole role)  started,required TResult Function()  taskCompleted,required TResult Function( String error)  taskFailed,required TResult Function()  retry,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.role);case _TaskCompleted():
return taskCompleted();case _TaskFailed():
return taskFailed(_that.error);case _Retry():
return retry();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( UserRole role)?  started,TResult? Function()?  taskCompleted,TResult? Function( String error)?  taskFailed,TResult? Function()?  retry,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.role);case _TaskCompleted() when taskCompleted != null:
return taskCompleted();case _TaskFailed() when taskFailed != null:
return taskFailed(_that.error);case _Retry() when retry != null:
return retry();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements OrchestratorEvent {
  const _Started(this.role);
  

 final  UserRole role;

/// Create a copy of OrchestratorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'OrchestratorEvent.started(role: $role)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $OrchestratorEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 UserRole role
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of OrchestratorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? role = null,}) {
  return _then(_Started(
null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}


}

/// @nodoc


class _TaskCompleted implements OrchestratorEvent {
  const _TaskCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrchestratorEvent.taskCompleted()';
}


}




/// @nodoc


class _TaskFailed implements OrchestratorEvent {
  const _TaskFailed(this.error);
  

 final  String error;

/// Create a copy of OrchestratorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskFailedCopyWith<_TaskFailed> get copyWith => __$TaskFailedCopyWithImpl<_TaskFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskFailed&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'OrchestratorEvent.taskFailed(error: $error)';
}


}

/// @nodoc
abstract mixin class _$TaskFailedCopyWith<$Res> implements $OrchestratorEventCopyWith<$Res> {
  factory _$TaskFailedCopyWith(_TaskFailed value, $Res Function(_TaskFailed) _then) = __$TaskFailedCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$TaskFailedCopyWithImpl<$Res>
    implements _$TaskFailedCopyWith<$Res> {
  __$TaskFailedCopyWithImpl(this._self, this._then);

  final _TaskFailed _self;
  final $Res Function(_TaskFailed) _then;

/// Create a copy of OrchestratorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_TaskFailed(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Retry implements OrchestratorEvent {
  const _Retry();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Retry);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrchestratorEvent.retry()';
}


}




/// @nodoc
mixin _$OrchestratorState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrchestratorState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrchestratorState()';
}


}

/// @nodoc
class $OrchestratorStateCopyWith<$Res>  {
$OrchestratorStateCopyWith(OrchestratorState _, $Res Function(OrchestratorState) __);
}


/// Adds pattern-matching-related methods to [OrchestratorState].
extension OrchestratorStatePatterns on OrchestratorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Running value)?  running,TResult Function( _Success value)?  success,TResult Function( _Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Running() when running != null:
return running(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Running value)  running,required TResult Function( _Success value)  success,required TResult Function( _Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Running():
return running(_that);case _Success():
return success(_that);case _Failure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Running value)?  running,TResult? Function( _Success value)?  success,TResult? Function( _Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Running() when running != null:
return running(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( OrchestratorTask currentTask,  List<OrchestratorTask> pendingTasks,  int completedCount,  int totalCount,  UserRole role)?  running,TResult Function( UserRole role)?  success,TResult Function( OrchestratorTask failedTask,  String error,  UserRole role)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Running() when running != null:
return running(_that.currentTask,_that.pendingTasks,_that.completedCount,_that.totalCount,_that.role);case _Success() when success != null:
return success(_that.role);case _Failure() when failure != null:
return failure(_that.failedTask,_that.error,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( OrchestratorTask currentTask,  List<OrchestratorTask> pendingTasks,  int completedCount,  int totalCount,  UserRole role)  running,required TResult Function( UserRole role)  success,required TResult Function( OrchestratorTask failedTask,  String error,  UserRole role)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Running():
return running(_that.currentTask,_that.pendingTasks,_that.completedCount,_that.totalCount,_that.role);case _Success():
return success(_that.role);case _Failure():
return failure(_that.failedTask,_that.error,_that.role);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( OrchestratorTask currentTask,  List<OrchestratorTask> pendingTasks,  int completedCount,  int totalCount,  UserRole role)?  running,TResult? Function( UserRole role)?  success,TResult? Function( OrchestratorTask failedTask,  String error,  UserRole role)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Running() when running != null:
return running(_that.currentTask,_that.pendingTasks,_that.completedCount,_that.totalCount,_that.role);case _Success() when success != null:
return success(_that.role);case _Failure() when failure != null:
return failure(_that.failedTask,_that.error,_that.role);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements OrchestratorState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrchestratorState.initial()';
}


}




/// @nodoc


class _Running implements OrchestratorState {
  const _Running({required this.currentTask, required final  List<OrchestratorTask> pendingTasks, required this.completedCount, required this.totalCount, required this.role}): _pendingTasks = pendingTasks;
  

 final  OrchestratorTask currentTask;
 final  List<OrchestratorTask> _pendingTasks;
 List<OrchestratorTask> get pendingTasks {
  if (_pendingTasks is EqualUnmodifiableListView) return _pendingTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingTasks);
}

 final  int completedCount;
 final  int totalCount;
 final  UserRole role;

/// Create a copy of OrchestratorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunningCopyWith<_Running> get copyWith => __$RunningCopyWithImpl<_Running>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Running&&(identical(other.currentTask, currentTask) || other.currentTask == currentTask)&&const DeepCollectionEquality().equals(other._pendingTasks, _pendingTasks)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,currentTask,const DeepCollectionEquality().hash(_pendingTasks),completedCount,totalCount,role);

@override
String toString() {
  return 'OrchestratorState.running(currentTask: $currentTask, pendingTasks: $pendingTasks, completedCount: $completedCount, totalCount: $totalCount, role: $role)';
}


}

/// @nodoc
abstract mixin class _$RunningCopyWith<$Res> implements $OrchestratorStateCopyWith<$Res> {
  factory _$RunningCopyWith(_Running value, $Res Function(_Running) _then) = __$RunningCopyWithImpl;
@useResult
$Res call({
 OrchestratorTask currentTask, List<OrchestratorTask> pendingTasks, int completedCount, int totalCount, UserRole role
});




}
/// @nodoc
class __$RunningCopyWithImpl<$Res>
    implements _$RunningCopyWith<$Res> {
  __$RunningCopyWithImpl(this._self, this._then);

  final _Running _self;
  final $Res Function(_Running) _then;

/// Create a copy of OrchestratorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentTask = null,Object? pendingTasks = null,Object? completedCount = null,Object? totalCount = null,Object? role = null,}) {
  return _then(_Running(
currentTask: null == currentTask ? _self.currentTask : currentTask // ignore: cast_nullable_to_non_nullable
as OrchestratorTask,pendingTasks: null == pendingTasks ? _self._pendingTasks : pendingTasks // ignore: cast_nullable_to_non_nullable
as List<OrchestratorTask>,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}


}

/// @nodoc


class _Success implements OrchestratorState {
  const _Success({required this.role});
  

 final  UserRole role;

/// Create a copy of OrchestratorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'OrchestratorState.success(role: $role)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $OrchestratorStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 UserRole role
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of OrchestratorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? role = null,}) {
  return _then(_Success(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}


}

/// @nodoc


class _Failure implements OrchestratorState {
  const _Failure({required this.failedTask, required this.error, required this.role});
  

 final  OrchestratorTask failedTask;
 final  String error;
 final  UserRole role;

/// Create a copy of OrchestratorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.failedTask, failedTask) || other.failedTask == failedTask)&&(identical(other.error, error) || other.error == error)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,failedTask,error,role);

@override
String toString() {
  return 'OrchestratorState.failure(failedTask: $failedTask, error: $error, role: $role)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $OrchestratorStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 OrchestratorTask failedTask, String error, UserRole role
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of OrchestratorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failedTask = null,Object? error = null,Object? role = null,}) {
  return _then(_Failure(
failedTask: null == failedTask ? _self.failedTask : failedTask // ignore: cast_nullable_to_non_nullable
as OrchestratorTask,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}


}

// dart format on
