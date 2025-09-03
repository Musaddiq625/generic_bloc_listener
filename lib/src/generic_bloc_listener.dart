import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'typedefs.dart';
import 'ui/app_loader.dart';
import 'ui/app_toast.dart';

/// A widget that listens to a [StateStreamable] bloc and performs actions
/// based on the state emitted.
class GenericBlocListener<B extends StateStreamable<S>, S, L, Su, F>
    extends StatelessWidget {
  /// The child widget to display.
  final Widget child;

  /// Callback function called when a state is emitted.
  final OnState<S>? onState;

  /// Callback function called when a success state is emitted.
  final OnSuccess<Su, S>? onSuccess;

  /// Callback function called when an error state is emitted.
  final OnError<F>? onError;

  /// The widget to display as a toast when an error state is emitted.
  final Widget? toastWidget;

  const GenericBlocListener({
    required this.child,
    super.key,
    this.onState,
    this.onSuccess,
    this.onError,
    this.toastWidget,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      listener: (context, state) {
        onState?.call(state);
        _handleState(context, state);
      },
      builder: (context, state) => child,
    );
  }

  /// Handles the state emitted by the bloc.
  Future<void> _handleState(BuildContext context, S state) async {
    if (state is L) {
      // Show a loader when the state is of type L.
      AppLoader.show(context);
    } else if (state is Su) {
      // Hide the loader when the state is of type Su and perform onSuccess action.
      AppLoader.hide(context);
      await onSuccess?.call(context, state);
    } else if (state is F) {
      // Hide the loader when the state is of type F and display a toast with the error message.
      AppLoader.hide(context);
      if (onError == null) {
        debugPrint('GenericBlocListener: ⚠️ Implement onError function to show toast');
      } else {
        final message = onError!(state);
        AppToast.show(context, message, child: toastWidget);
      }
    }
  }
}
