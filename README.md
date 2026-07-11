<div align="center">

# GalaxMovie

Flutter kullanılarak geliştirilmiş modern bir film keşfetme uygulamasıdır.

Kullanıcılar güncel filmleri inceleyebilir, film arayabilir, detaylarını görüntüleyebilir ve beğendikleri filmleri favorilerine ekleyebilir.

</div>

## Özellikler

* Kullanıcı kaydı ve giriş işlemleri
* E-posta doğrulama
* Şifre sıfırlama
* Popüler filmleri görüntüleme
* Vizyondaki filmleri görüntüleme
* Yakında çıkacak filmleri görüntüleme
* En yüksek puanlı filmleri görüntüleme
* Film arama
* Film detaylarını görüntüleme
* Filmleri favorilere ekleme ve kaldırma
* Favorileri kullanıcı hesabına göre saklama
* Film görsellerini önbelleğe alma

## Kullanılan Teknolojiler

* Flutter
* Dart
* Provider
* MVVM mimarisi
* Firebase Authentication
* Cloud Firestore
* TMDB API
* HTTP
* Cached Network Image
* Carousel Slider
* Shared Preferences

## Proje Yapısı

```text
lib/
├── model
├── service
├── view
│   ├── screens
│   └── widgets
├── view_model
└── main.dart
```

## Ekran Görüntüleri

<div align="center">
  <img src="https://raw.githubusercontent.com/AbdulkadirAkansu/AbdulkadirAkansu/23b3d72da5f10b071f8f16ec5d7e7dd982608f5e/Screenshot_1727368325.png" width="190">
  <img src="https://raw.githubusercontent.com/AbdulkadirAkansu/AbdulkadirAkansu/23b3d72da5f10b071f8f16ec5d7e7dd982608f5e/Screenshot_1727368328.png" width="190">
  <img src="https://raw.githubusercontent.com/AbdulkadirAkansu/AbdulkadirAkansu/23b3d72da5f10b071f8f16ec5d7e7dd982608f5e/Screenshot_1727368372.png" width="190">
  <img src="https://raw.githubusercontent.com/AbdulkadirAkansu/AbdulkadirAkansu/23b3d72da5f10b071f8f16ec5d7e7dd982608f5e/Screenshot_1727368382.png" width="190">
</div>

<br>

<div align="center">
  <img src="https://raw.githubusercontent.com/AbdulkadirAkansu/AbdulkadirAkansu/23b3d72da5f10b071f8f16ec5d7e7dd982608f5e/Screenshot_1727368402.png" width="190">
  <img src="https://raw.githubusercontent.com/AbdulkadirAkansu/AbdulkadirAkansu/23b3d72da5f10b071f8f16ec5d7e7dd982608f5e/Screenshot_1727368407.png" width="190">
  <img src="https://raw.githubusercontent.com/AbdulkadirAkansu/AbdulkadirAkansu/23b3d72da5f10b071f8f16ec5d7e7dd982608f5e/Screenshot_1727368422.png" width="190">
  <img src="https://raw.githubusercontent.com/AbdulkadirAkansu/AbdulkadirAkansu/23b3d72da5f10b071f8f16ec5d7e7dd982608f5e/Screenshot_1727368432.png" width="190">
</div>

## Kurulum

Projeyi klonlayın:

```bash
git clone https://github.com/AbdulkadirAkansu/galaxmovie.git
```

Proje klasörüne girin:

```bash
cd galaxmovie/galaxmovie
```

Bağımlılıkları yükleyin:

```bash
flutter pub get
```

Projeyi çalıştırın:

```bash
flutter run
```

Uygulamayı çalıştırabilmek için:

* Kendi Firebase projenizi yapılandırın.
* TMDB üzerinden bir API anahtarı oluşturun.
* API anahtarını doğrudan kaynak kodda paylaşmayın.

## Planlanan Geliştirmeler

* API anahtarının güvenli yapılandırılması
* Birim ve arayüz testleri
* GitHub Actions entegrasyonu
* Hata ve yüklenme ekranlarının geliştirilmesi
* Sayfalama desteği
* Film fragmanlarının eklenmesi
* Performans iyileştirmeleri
