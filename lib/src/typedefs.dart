import 'package:flutter/widgets.dart';

/// A callback function that takes a [BuildContext] and a state of type [T]
/// and returns a [Future] that completes when the action on the state is
/// completed.
typedef OnSuccess<T, S> = void Function(BuildContext context, T state);

/// A callback function that takes a [BuildContext] and a state of type [S] and performs an action
/// on that state.
typedef OnState<S> = void Function(BuildContext context, S state);

/// A callback function that takes a state of type [F] and returns a string
/// that represents the error message associated with that state.
typedef OnError<F> = String Function(F failure);
