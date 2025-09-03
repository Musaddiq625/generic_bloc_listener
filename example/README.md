# Generic BLoC Listener Example

This example demonstrates how to use the `generic_bloc_listener` package in a Flutter application.

## Features Demonstrated

- Setting up a basic BLoC/Cubit with different state types
- Using GenericBlocListener to handle different states
- Custom toast notifications for error states
- Loading state handling
- Success state handling

## Running the Example

1. Ensure you have Flutter installed and configured
2. Navigate to the example directory:
   ```bash
   cd example
   ```
3. Get the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## How It Works

The example shows a simple UI with a button to fetch data. It demonstrates:

- Displaying a loading indicator while data is being fetched
- Showing a success message when data is loaded
- Displaying error messages in a custom toast
- Resetting the state

## Dependencies

- `flutter_bloc`: For state management
- `generic_bloc_listener`: The package being demonstrated (linked locally)
