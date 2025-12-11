# Setup Environment Variables

## Untuk Developer Baru

1. Copy file `.env.example` menjadi `.env`:
   ```bash
   cp .env.example .env
   ```

2. Isi nilai API keys di file `.env` dengan credentials yang benar

3. Jangan commit file `.env` ke repository

## File yang Diabaikan Git

File-file berikut sudah di-ignore dan tidak akan ter-commit:
- `.env` - Environment variables
- `lib/firebase_options.dart` - Firebase configuration
- `android/app/google-services.json` - Google Services Android
- `ios/Runner/GoogleService-Info.plist` - Google Services iOS
