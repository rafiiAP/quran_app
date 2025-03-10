# Mencegah ProGuard menghapus kelas dari GSON
-keep class com.google.gson.** { *; }

# Mencegah ProGuard menghapus kelas dari flutter_local_notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }