# 📱 Minimarket POS Mobile App (Flutter)

Aplikasi **Minimarket POS Mobile** adalah aplikasi mobile berbasis **Flutter** yang berfungsi sebagai client untuk sistem **Minimarket POS System**.  
Aplikasi ini dirancang untuk mendukung kebutuhan operasional minimarket melalui fitur seperti **login**, **manajemen produk**, **inventory**, **purchase order**, dan **supplier**, serta terintegrasi langsung ke backend API (Laravel).

Project ini menggunakan pendekatan **feature-first architecture** agar struktur kode lebih rapi, mudah dikembangkan, dan scalable.

---

## ✨ Features

Berikut modul utama yang tersedia pada aplikasi:

- 🔐 **Authentication**
  - Login (email & password)
  - (Opsional) Google Sign-In / OTP / session management sesuai backend
- 📦 **Products**
  - Menampilkan daftar produk
  - Detail produk
  - Integrasi image URL dari storage (MinIO)
- 🧾 **Purchase**
  - Menampilkan dan mengelola Purchase Order
  - Detail Purchase Order & items
- 🏪 **Suppliers**
  - Daftar supplier
  - Detail supplier
- 📊 **Inventory**
  - Stock overview
  - Inventory movements
  - Stock adjustments
- 🧭 **Dashboard**
  - Navigasi modul utama melalui dashboard

> Catatan: Fitur dapat berkembang sesuai integrasi endpoint backend yang tersedia.

---

## 🧰 Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Riverpod
- **Networking**: Dio / HTTP Client (tergantung implementasi project)
- **Local Storage**: Secure Storage / Shared Preferences (untuk token/session)
- **Architecture**: Feature-based (modular per fitur)
- **Platform**: Android, iOS, Web (opsional)

---

## 📂 Project Structure (Based on Current Folder)

Struktur project mengikuti pola modular per fitur:

```text
MINIMARKET/
├── android/
├── ios/
├── web/
├── test/
├── lib/
│   ├── bootstrap/
│   │   ├── providers.dart
│   │   └── (app bootstrap / dependency injection)
│   ├── core/
│   │   ├── network/
│   │   ├── storage/
│   │   ├── constants/
│   │   └── (shared utilities / base classes)
│   ├── features/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── inventory/
│   │   ├── products/
│   │   ├── purchase/
│   │   └── suppliers/
│   ├── app.dart
│   └── main.dart
├── pubspec.yaml
└── README.md
