import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:generic_bloc_listener/generic_bloc_listener.dart';

// Mock states for testing
abstract class TestState {}

class LoadingState implements TestState {}

class SuccessState implements TestState {
  final String message;
  SuccessState(this.message);
}

class ErrorState implements TestState {
  final String error;
  ErrorState(this.error);
}

// Mock bloc for testing
class MockBloc extends Bloc<TestState, TestState> {
  MockBloc(super.initialState);

  void emitState(TestState state) => emit(state);
}

void main() {
  late MockBloc bloc;

  setUp(() {
    // Initialize with a concrete state
    final initialState = LoadingState();
    bloc = MockBloc(initialState);
  });

  testWidgets('renders child widget', (tester) async {
    const testKey = Key('test');

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: GenericBlocListener<
            MockBloc,
            TestState,
            LoadingState,
            SuccessState,
            ErrorState
          >(builder: (context, state) => const SizedBox(key: testKey)),
        ),
      ),
    );

    expect(find.byKey(testKey), findsOneWidget);
  });

  testWidgets('calls onState when state changes', (tester) async {
    bool stateCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: GenericBlocListener<
            MockBloc,
            TestState,
            LoadingState,
            SuccessState,
            ErrorState
          >(
            onState: (context, state) => stateCalled = true,
            builder: (context, state) => const SizedBox(),
          ),
        ),
      ),
    );

    bloc.emitState(LoadingState());
    await tester.pump();

    expect(stateCalled, isTrue);
  });

  testWidgets('shows loader for loading state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: GenericBlocListener<
            MockBloc,
            TestState,
            LoadingState,
            SuccessState,
            ErrorState
          >(builder: (context, state) => const SizedBox()),
        ),
      ),
    );

    bloc.emitState(LoadingState());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('hides loader and calls onSuccess for success state', (
    tester,
  ) async {
    bool successCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: GenericBlocListener<
            MockBloc,
            TestState,
            LoadingState,
            SuccessState,
            ErrorState
          >(
            onSuccess: (context, state) {
              successCalled = true;
            },
            builder: (context, state) => const SizedBox(),
          ),
        ),
      ),
    );

    // First emit loading to show loader
    bloc.emitState(LoadingState());
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Then emit success
    bloc.emitState(SuccessState('Success!'));
    await tester.pump();

    expect(successCalled, isTrue);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows error toast for error state using state error', (
    tester,
  ) async {
    const errorMessage = 'Something went wrong';
    bool errorCallbackCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: GenericBlocListener<
            MockBloc,
            TestState,
            LoadingState,
            SuccessState,
            ErrorState
          >(
            onError: (state) {
              errorCallbackCalled = true;
              return state.error;
            },
            builder: (context, state) => const SizedBox(),
          ),
        ),
      ),
    );

    // First emit loading to show loader
    bloc.emitState(LoadingState());
    await tester.pump();

    // Then emit error
    bloc.emitState(ErrorState(errorMessage));
    await tester.pump();

    // Verify error callback was called
    expect(errorCallbackCalled, isTrue);

    // Verify error toast is shown with the error message from state
    expect(find.text(errorMessage), findsOneWidget);

    // Fast forward time to complete the toast animation
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('shows custom error message for error state', (tester) async {
    const customErrorMessage = 'Custom error message';
    const stateErrorMessage = 'State error message';
    bool errorCallbackCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: GenericBlocListener<
            MockBloc,
            TestState,
            LoadingState,
            SuccessState,
            ErrorState
          >(
            onError: (state) {
              errorCallbackCalled = true;
              return customErrorMessage;
            },
            builder: (context, state) => const SizedBox(),
          ),
        ),
      ),
    );

    // First emit loading to show loader
    bloc.emitState(LoadingState());
    await tester.pump();

    // Then emit error with a different message than our custom one
    bloc.emitState(ErrorState(stateErrorMessage));
    await tester.pump();

    // Verify error callback was called
    expect(errorCallbackCalled, isTrue);

    // Verify custom error toast is shown instead of state error message
    expect(find.text(customErrorMessage), findsOneWidget);
    expect(find.text(stateErrorMessage), findsNothing);

    // Fast forward time to complete the toast animation
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));
  });

  test('throws when type parameters are not distinct', () {
    // Test with L and Su being the same type
    expect(
      () => GenericBlocListener<
        MockBloc,
        TestState,
        LoadingState,
        LoadingState,
        ErrorState
      >(builder: (context, state) => const SizedBox()),
      throwsA(
        isA<AssertionError>().having(
          (e) => e.toString(),
          'error message',
          contains('The type parameters L, Su, and F must be distinct types'),
        ),
      ),
    );
  });

  testWidgets('logs warning when onError is not provided', (tester) async {
    final logMessages = <String>[];
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      logMessages.add(message!);
    };

    try {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: GenericBlocListener<
              MockBloc,
              TestState,
              LoadingState,
              SuccessState,
              ErrorState
            >(builder: (context, state) => const SizedBox()),
          ),
        ),
      );

      // Emit error state without onError handler
      bloc.emitState(ErrorState('Test error'));
      await tester.pump();

      // Verify warning was logged
      expect(
        logMessages.any(
          (m) => m.contains('⚠️ Implement onError function to show toast'),
        ),
        isTrue,
      );
    } finally {
      debugPrint = originalDebugPrint;
    }
  });
}
