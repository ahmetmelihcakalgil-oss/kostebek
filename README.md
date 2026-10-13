# 🕵️ Köstebek — Türkçe "Impostor" Parti Oyunu

Tek bir telefon üzerinden, arkadaş grubuyla oynanan Türkçe **"Kim Köstebek?"** (Impostor / Spyfall tarzı) parti oyunu. Uygulama tamamen **Flutter (Dart)** ile geliştirilmiştir ve Android, iOS, Windows, Linux, macOS ve Web hedeflerine derlenebilir.

Her turda tüm oyunculara aynı **gizli kelime** verilir — bir kişi hariç. O kişi (**köstebek / sahtekâr**) farklı bir kelime alır ve diğerleri köstebeği bulmaya çalışır.

> Bu proje, [Among Us](https://en.wikipedia.org/wiki/Among_Us) ve *Impostor Who* tarzı parti oyunlarının Türkçe, tek cihazda oynanabilen bir yorumudur.

---

## ✨ Özellikler

- 👥 **3–20 oyuncu** desteği (sıra tabanlı, tek cihaz)
- 🗂️ **7 kategori** ve yüzlerce kelimeden oluşan geniş kelime havuzu
- 🕵️ **Otomatik köstebek sayısı** (oyuncu sayısına göre 1–3 arası)
- 🎲 Rastgele kategori ve kelime seçimi (köstebek farklı kelimeyi alır)
- 🔄 "Telefonu sıradaki oyuncuya ver" akışıyla gizliliği koruyan rol gösterimi
- 📦 `provider` paketi ile temiz state yönetimi
- 📱 Çapraz platform: Android / iOS / Windows / Linux / macOS / Web

### Kategoriler

| Kategori | Örnek içerik |
|---|---|
| Diziler | Leyla ile Mecnun, Breaking Bad, Çukur, Squid Game |
| Ünlüler | Cem Yılmaz, Tarkan, C. Ronaldo, Elon Musk |
| Kitaplar | Suç ve Ceza, 1984, Kürk Mantolu Madonna |
| Oyunlar | Valorant, Minecraft, GTA V, Satranç |
| Filmler | Esaretin Bedeli, Interstellar, İnception |
| Animeler | Naruto, Attack on Titan, One Piece |
| Ülkeler | Türkiye, Almanya, Japonya, Brezilya |

---

## 🎮 Nasıl Oynanır?

1. **Oyunu Başlat** → oyuncu sayısını ve varsa köstebek sayısını seç.
2. Kategorilerden istediklerini işaretle (en az bir kategori zorunlu).
3. Telefon sırayla her oyuncuya geçer:
   - Oyuncu **"Kelimeyi Görmek İçin Dokun"** butonuna basar, gizli kelimesini görür ve telefonu bir sonrakine verir.
   - Kelimen diğerlerinden **farklıysa sen köstebeksin!**
4. Tüm oyuncular kelimesini gördükten sonra sırayla birer ipucu verir.
5. Oylama sonucu **köstebek bulunmaya çalışılır**.

---

## 🗂️ Proje Yapısı

```
kostebek/
├── lib/
│   ├── main.dart                      → uygulama başlangıcı, Provider kurulumu
│   ├── models/
│   │   ├── game_model.dart            → GameCategory enum, Player, GameModel
│   │   └── player_model.dart          → yardımcı Player modeli
│   ├── providers/
│   │   └── game_state_provider.dart   → oyun mantığı, kelime havuzu, rol ataması
│   └── screens/
│       ├── home_screen.dart           → giriş ekranı
│       ├── player_count_screen.dart   → oyuncu / köstebek / kategori seçimi
│       └── reveal_role_screen.dart    → sırayla kelime gösterme ekranı
├── android/ · ios/ · windows/ · linux/ · macos/ · web/   → platform dosyaları
├── pubspec.yaml
└── README.md
```

---

## 🧠 Oyun Mantığı

Oyun mantığı `GameStateProvider` içinde toplanmıştır:

- `setTotalPlayers(count)` — oyuncu sayısını ayarlar ve köstebek üst limitini günceller.
- `setImpostorCount(count)` — köstebek sayısını sınırlar içinde tutar.
- `startGame()` — oyuncuları oluşturur, rastgele kategori/kelime seçer ve rolleri atar.
- `nextPlayer()` / `resetGame()` — sıra ilerletme ve sıfırlama.

**Köstebek sayısı kuralı:**

| Oyuncu sayısı | Köstebek sayısı |
|---|---|
| 3 – 5 | 1 |
| 6 – 10 | 2 |
| 11 – 20 | 3 |

---

## 🛠️ Teknolojiler

- **Flutter** (SDK `>=3.0.0 <4.0.0`)
- **Dart**
- [`provider`](https://pub.dev/packages/provider) — state yönetimi

---

## 🚀 Kurulum ve Çalıştırma

```bash
# Bağımlılıkları kur
flutter pub get

# Uygulamayı çalıştır (bağlı cihaz / emülatör)
flutter run

# Android APK derle
flutter build apk --release

# Web için derle
flutter build web
```

---



## 📄 Lisans

MIT
