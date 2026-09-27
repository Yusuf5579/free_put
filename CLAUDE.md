# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                      # install dependencies
flutter run                          # run on a connected device/simulator
flutter analyze                      # lint (flutter_lints; android/ios/web/desktop dirs are excluded)
flutter test                         # run all tests
flutter test test/widget_test.dart   # run a single test file
flutter test --plain-name "<name>"   # run a single test by name
dart run build_runner build --delete-conflicting-outputs   # regenerate lib/gen/assets.gen.dart
```

Dart SDK `^3.11.0` — the code uses dot-shorthand syntax (e.g. `.initial`, `.light(...)`), so an older SDK will not compile it.

## Architecture

A small Flutter file-sharing app ("free_put"): the user picks a file, it is uploaded to storage, and a record of it is listed on the home screen. Storage and metadata deliberately live in **two different backends**:

- **Appwrite** (`lib/src/core/appwrite/appwrite_client.dart`) stores the file bytes. `AppwriteClient` is a static singleton with hard-coded endpoint, project ID and bucket ID; `AppwriteClient.init()` must run before use (called in `main()`).
- **Firebase Firestore** (`files` collection, initialised via `lib/firebase_options.dart` / `firebase.json`) stores metadata: `{name, url}`. Only Android and iOS are configured in `firebase_options.dart`.

Upload flow (`UploadCubit.fileYuborish`): `createFile` in the Appwrite bucket → build a public `/view?project=...` URL from the returned file ID → `add` a `{name, url}` doc to Firestore. The list side (`HomeCubit.getFiles`) reads the whole `files` collection as `List<Map>` — there is no typed model.

State management is `flutter_bloc` Cubits with hand-written `copyWith` state classes (no Equatable/freezed), organised per feature under `lib/src/features/<feature>/{cubit,screens,widgets}`. Currently only `home` exists:
- `UploadCubit` (file picking + upload) is provided in `main.dart`, but `HomeScreen` also reads it via `BlocBuilder<UploadCubit, UploadState>`.
- `HomeCubit` is created locally in `HomeScreen`'s `BlocProvider` (`HomeCubit()..getFiles()`), and the recent-files widget consumes it. After a successful upload, the list must be refreshed by calling `getFiles()` again — Firestore is not streamed.

Assets: SVGs in `assets/icons/`, PNGs in `assets/images/`; access them through the generated `lib/gen/assets.gen.dart` (flutter_gen) rather than string paths. Re-run build_runner after adding assets.
