# Task Manager

A modern, professional task management application built with Flutter and BLoC state management pattern.

## Features

- **Task Management**: Create, update, and complete tasks with due dates and priorities
- **Priority System**: Organize tasks by Low, Medium, and High priority levels
- **Task Statistics**: Visual overview of task distribution and completion status
- **Persistent Storage**: Tasks are saved locally using SharedPreferences
- **Modern UI**: Dark theme with intuitive design and smooth animations
- **Date/Time Selection**: iOS-style pickers for setting due dates and times
- **Status Indicators**: Visual cues for overdue, due today, and completed tasks

## Architecture

This application follows a clean architecture approach with:

- **BLoC Pattern**: For predictable state management
- **Repository Pattern**: For data abstraction and testability
- **Model Classes**: Using Equatable for value equality
- **Separation of Concerns**: Clear separation between UI, business logic, and data

## Project Structure

```
lib/
├── bloc/                 # BLoC state management
│   ├── task_bloc.dart
│   ├── task_event.dart
│   └── task_state.dart
├── core/
│   ├── constants/        # App-wide constants
│   ├── theme/           # Application theming
│   └── utils/           # Utility functions
├── models/              # Data models
│   └── task.dart
├── repositories/        # Data layer abstraction
│   └── task_repository.dart
├── screens/             # UI screens
│   ├── home_screen.dart
│   └── add_task_screen.dart
├── widgets/             # Reusable UI components
│   ├── task_item.dart
│   └── task_summary_card.dart
└── main.dart           # Application entry point
```

## Dependencies

### Core Dependencies
- `flutter_bloc` - State management
- `equatable` - Value equality for models
- `shared_preferences` - Local data persistence
- `intl` - Date/time formatting

### Development Dependencies
- `flutter_lints` - Code linting rules
- `bloc_test` - BLoC testing utilities
- `mocktail` - Mocking for tests

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/task_manager.git
```

2. Navigate to the project directory:
```bash
cd task_manager
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

## Usage

### Adding Tasks
1. Tap the floating action button or the + icon in the app bar
2. Enter task title, select due date and time
3. Choose priority level (Low, Medium, High)
4. Tap "Add Task" to save

### Managing Tasks
- Tap the checkbox to mark tasks as complete
- View task statistics on the home screen dashboard
- Tasks are automatically sorted and filtered

### Task Status Indicators
- **Green Check**: Completed task
- **Red Warning**: Overdue task
- **Orange Today**: Due today
- **Priority Colors**: Blue (Low), Green (Medium), Pink (High)

## Testing

Run the test suite:
```bash
flutter test
```

## Code Quality

This project maintains high code quality through:
- Strict linting rules (analysis_options.yaml)
- Consistent code formatting
- Type safety with null safety
- Comprehensive error handling

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the excellent framework
- BLoC library contributors for state management patterns
- The open-source community for inspiration and best practices