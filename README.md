# Generic BLoC Listener

A Flutter package that provides a flexible BLoC listener widget with built-in state management for loading, success, and error states, including toast notifications and custom state handling.

## Features

- 🎯 Generic BLoC listener that works with any state type
- 🔒 Type safety with compile-time validation of distinct state types
- 🔄 Built-in state listener for custom state handling
- ⏳ Automatic loading state handling with circular progress indicator
- ✅ Success state callback with context and state access
- ❌ Flexible error handling with both state-based and custom error messages
- 🎨 Fully customizable toast notifications

![Before and after comparison](https://raw.githubusercontent.com/Musaddiq625/generic_bloc_listener/refs/heads/main/screenshots/before_after.jpg)

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  generic_bloc_listener: <latest-version>
```

## Type Parameters

The `GenericBlocListener` requires five type parameters:
- `B`: Your BLoC/Cubit type
- `S`: The base state type that your BLOC emits
- `L`: The loading state type
- `Su`: The success state type
- `F`: The failure/error state type

All state types (L, Su, F) must be distinct from each other.

## Usage

1. Import the package:

```dart
import 'package:generic_bloc_listener/generic_bloc_listener.dart';
```

2. Use the `GenericBlocListener` widget:

```dart
GenericBlocListener<ExampleBloc, ExampleState, LoadingState, SuccessState, ErrorState>(
  onState: (context, state) {
    // Handle state changes
    // Access context for navigation, showing dialogs, etc.
  },
  onSuccess: (context, state) {
    // Handle success state
  },
  // Required: Implement onError to show error toasts
  onError: (state) => state.errorMessage, // Extract error message from state
  // OR use a custom error message:
  // onError: (_) => 'Something went wrong. Please try again.',
  toastWidget: CustomToastWidget(), // Optional custom toast widget
  builder: (context, state) => ContentWidget(state: state),
)
```

## Example

```dart
class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExampleBloc(),
      child: GenericBlocListener<ExampleBloc, ExampleState, LoadingState, SuccessState, ErrorState>(
        onSuccess: (context, state) {
          // Handle success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Success: ${state.message}')),
          );
        },
        onError: (state) => state.errorMessage,
        builder: (context, state) => ContentWidget(state: state),
      ),
    );
  }
}
```

## Customization

### Custom Toast Widget

You can provide a custom toast widget:

```dart
GenericBlocListener(
  // ... other parameters
  toastWidget: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(Icons.error, color: Colors.white),
        SizedBox(width: 8),
        Text('Error!', style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
)
```

### Error Handling

Error toasts will only be shown if the `onError` callback is provided. If `onError` is not implemented, a warning will be logged to the console.

```dart
// Without onError (warning will be logged)
GenericBlocListener<ExampleBloc, ExampleState, LoadingState, SuccessState, ErrorState>(
  // onError not provided - warning will be logged
  builder: (state) => const SizedBox(),
);

// With onError (toast will be shown)
GenericBlocListener<ExampleBloc, ExampleState, LoadingState, SuccessState, ErrorState>(
  // Using state error message
  onError: (state) => state.errorMessage,
  builder: (state) => const SizedBox(),
);

// With custom error message
GenericBlocListener<ExampleBloc, ExampleState, LoadingState, SuccessState, ErrorState>(
  onError: (_) => 'An error occurred. Please try again later.',
  child: YourWidget(),
);
```

If you find it useful, a ⭐ on GitHub is appreciated.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Maintainer
Developed and maintained by Musaddiq625.

### License
This project is licensed under the MIT License.