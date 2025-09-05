import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_bloc_listener/generic_bloc_listener.dart';

// Example States
abstract class ExampleState {}

class ExampleInitial extends ExampleState {}

class ExampleLoading extends ExampleState {}

class ExampleSuccess extends ExampleState {
  final String message;
  ExampleSuccess(this.message);
}

class ExampleError extends ExampleState {
  final String error;
  ExampleError(this.error);
}

// Example Cubit
class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit() : super(ExampleInitial());

  Future<void> fetchData() async {
    emit(ExampleLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      emit(ExampleSuccess('Data loaded successfully!'));
    } catch (e) {
      emit(ExampleError('Failed to load data: $e'));
    }
  }

  void reset() => emit(ExampleInitial());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generic BLoC Listener Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => ExampleCubit(),
        child: const ExamplePage(),
      ),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generic BLoC Listener Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The GenericBlocListener wraps our content
            GenericBlocListener<ExampleCubit, ExampleState, ExampleLoading,
                    ExampleSuccess, ExampleError>(
                onState: (context, state) {
                  debugPrint('State changed: $state');
                },
                onSuccess: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Success! ${state.message}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                onError: (state) => state.error,
                toastWidget: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.redAccent,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.white),
                      SizedBox(width: 12.0),
                      Text('Error!', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state is ExampleInitial)
                        const Text('Press the button to load data')
                      else if (state is ExampleLoading)
                        const Text('Loading...')
                      else if (state is ExampleSuccess)
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        )
                      else if (state is ExampleError)
                        Text(
                          state.error,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ElevatedButton(
                        onPressed: state is ExampleLoading
                            ? null
                            : () => context.read<ExampleCubit>().fetchData(),
                        child: const Text('Fetch Data'),
                      ),
                      TextButton(
                        onPressed: state is ExampleInitial
                            ? null
                            : () => context.read<ExampleCubit>().reset(),
                        child: const Text('Reset'),
                      )
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
