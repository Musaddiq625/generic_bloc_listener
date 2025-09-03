import 'package:flutter/widgets.dart';

/// Creates a map entry for a state handler function.
///
/// The function [fn] takes a [BuildContext] and a state of type [T] and returns a
/// [Future] that completes when the action on the state is completed.
///
/// Returns a [MapEntry] where the key is the type [T] and the value is a function
/// that takes a [BuildContext] and a state of type [S] and invokes [fn] with
/// the state cast to type [T].
///
/// To do action on specific stat
MapEntry<Type, Future<void> Function(BuildContext, S)>
stateHandler<S, T extends S>(Future<void> Function(BuildContext, T) fn) {
  return MapEntry(T, (ctx, state) => fn(ctx, state as T));
}
