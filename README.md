Secure Notes App Documentation

1. Project Overview

App Name: Secure Notes

Version: 1.0.0+1

[![Flutter Version](https://img.shields.io/badge/flutter-3.29.2-blue)](https://flutter.dev)  
[![Dart Version](https://img.shields.io/badge/dart-3.7.2-blue)](https://dart.dev)  
[![Platform](https://img.shields.io/badge/platform-iOS%20|%20Android-lightgrey)]()  

Description: A cross-platform Flutter application enabling users to fetch notes from a remote REST API, add personal notes locally with end-to-end encryption, and view decrypted notes securely. The app uses a modular architecture with separate packages, BLoC for state management, and Hive for encrypted local storage.

Key Features:

Fetch and display remote notes via Dio HTTP client

Create, store, and decrypt personal notes locally

Modular folder and package structure for easy maintenance

Dependency injection via GetIt

State management using flutter_bloc and hydrated_bloc

Secure storage for encryption key using flutter_secure_storage

2. Getting Started

    Prerequisites

    Flutter 3.29.2

    Dart 3.7.2

    Android Studio / Xcode for emulator or device testing

    Git (for cloning repository)

    Installation & Setup

    1. Clone the repository:
        git clone https://github.com/yourusername/secure_notes.git
        cd secure_notes

    2.  Install Flutter dependencies:
        1. Clone the repository
            git clone https://github.com/yourusername/secure_notes.git
            cd secure_notes
        2. Install Flutter dependencies:
            ``` flutter pub get ```
    3. Initialization:
        The app initializes services at startup. No manual setup for encryption key is required.

    4. Run the app:

        Android: flutter run or via Android Studio

        iOS: flutter run (requires a connected iOS device or simulator)

```text
secure_notes/
├── android/
├── assets/
│   └── images/
├── build/
├── ios/
├── lib/
│   ├── app/
│   │   ├── config/
│   │   │   ├── constants/
│   │   │   ├── enums/
│   │   │   ├── routes/
│   │   │   └── utils/
│   │   ├── theme/
│   │   └── view/
│   ├── di/
│   ├── home/
│   │   ├── bloc/
│   │   └── view/
│   │       └── widgets/
│   ├── splash/
│   ├── widgets/
│   ├── bootstrap.dart
│   └── main.dart
├── packages/
│   ├── dio_client_handler/
│   ├── models/
│   ├── notes/
│   │   └── notes_data_src/
│   └── secure_storage_helper/
├── test/
├── pubspec.yaml
└── README.md
```

4. Architecture & Design
    4.1. Modular Packages
        dio_client_handler: Wraps Dio with interceptors, logging, and error handling.

        models: Defines data models (e.g. Note). Generated code via build_runner.

        notes_data_src: Provides NotesRemoteDataSrc (fetching from REST API) and LocalNotesDataSrc (Hive-based local storage + encryption service).

        secure_storage_helper: Manages secure storage of the encryption key using flutter_secure_storage.

    4.2. Dependency Injection
        Implemented in lib/di/di.dart using GetIt:
        final injector = GetIt.instance;

        Future<void> initServices() async {
        injector.registerLazySingleton<DioClientHandler>(() => DioClientHandler());

        final encryptionService = EncryptionService();
        await encryptionService.initialize();
        injector.registerSingleton<EncryptionService>(encryptionService);

        injector.registerLazySingleton<NotesRemoteDataSrc>(
            () => NotesRemoteDataSrc(dioClientHandler: injector<DioClientHandler>()),
        );

        injector.registerLazySingleton<LocalNotesDataSrc>(
            () => LocalNotesHive(),
        );
        }

    4.3. State Management
    flutter_bloc: For UI-driven state
    hydrated_bloc: Persists BLoC state across restarts
    BLoCs are organized under feature folders (e.g., home/bloc).

    4.4. Data Flow
    On startup: bootstrap.dart calls initServices(), then runs App().
    Remote fetch: HomeBloc uses NotesRemoteDataSrc to load notes.
    Local persistence: New notes are saved via LocalNotesHive, encrypted by EncryptionService.
    UI: Flutter widgets subscribe to BLoC states and display lists or forms.

5. Core Features
    5.1. Remote Notes
        NotesRemoteDataSrc:
        Method: Future<List<Note>> fetchNotes()
        Uses dioClientHandler.get('/notes')
        HomeBloc:
        Events: FetchRemoteNotes, FetchLocalNotes, AddNote
        States: HomeLoading, HomeLoaded, HomeError
    5.2. Local Notes
        LocalNotesHive implements LocalNotesDataSrc:
        Stores encrypted note objects in Hive box
        Uses EncryptionService to encrypt/decrypt Note.body
        EncryptionService:
        Generates AES key on first run, stored via flutter_secure_storage
        encrypt() / decrypt() methods wrap encrypt package
    5.3. UI Screen Flows
        Splash Screen: Initializes DI and routes to Home
        Home Screen: Tabbed view of remote vs local notes
        Add Note: Modal bottom sheet with text field and Save button
        Note Detail: Full view of decrypted note
6. UI Components & Styling
    Theme: Defined in lib/app/theme/theme.dart, includes primary/secondary colors and GoogleFonts integration.
    Responsive: Uses flutter_screenutil for scaling dimensions.
    Icons: line_awesome_flutter
    Navigation: go_router for declarative routing:
        final router = GoRouter(
        routes: [/* splash, home, detail routes */],
    );

7. Data Layer
    7.1. Models
    Data model for notes, supporting both JSON serialization and Hive storage:
        import 'package:hive/hive.dart';
        part 'note.g.dart';

        @HiveType(typeId: 0)
        class Note extends HiveObject {
        @HiveField(0)
        final int userId;

        @HiveField(1)
        final int id;

        @HiveField(2)
        final String title;

        @HiveField(3)
        final String body;

        Note({
            required this.userId,
            required this.id,
            required this.title,
            required this.body,
        });

        Note copyWith({int? userId, int? id, String? title, String? body}) {
            return Note(
            userId: userId ?? this.userId,
            id: id ?? this.id,
            title: title ?? this.title,
            body: body ?? this.body,
            );
        }
        /// Deserialize a list of notes from JSON
        static List<Note> listFromJson(List<dynamic> list) =>
            list.map((x) => Note.fromJson(x as Map<String, dynamic>)).toList();

        factory Note.fromJson(Map<String, dynamic> json) => Note(
                userId: json['userId'] as int,
                id: json['id'] as int,
                title: json['title'] as String,
                body: json['body'] as String,
            );

        Map<String, dynamic> toJson() => {
                'userId': userId,
                'id': id,
                'title': title,
                'body': body,
            };
        }
    Hive generates the adapter in note.g.dart, providing efficient binary storage and retrieval.

    7.2. APIs APIs
        Remote GET /notes
        (Optional) POST /notes for future remote note creation
    7.3. Local Storage
    Hive boxes:
    notesBox for Note objects
    Encrypted fields
    
8. Testing
    Unit Tests:
    Data sources (notes_data_src, secure_storage_helper)
    Widget Tests:
    Home screen renders states
    Running Tests:
        flutter test

9. Deployment
    Android
        Build release: flutter build apk --release
        Sign with keystore configured in android/app/build.gradle
    iOS
        Build IPA: flutter build ios --release
        Provisioning profiles managed via Xcode

10. Appendices
    Dependencies:
        See full list in pubspec.yaml.