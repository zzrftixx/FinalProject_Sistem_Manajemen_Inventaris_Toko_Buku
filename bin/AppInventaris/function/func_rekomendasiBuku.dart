//           --- ignore warning ---
// ignore_for_file: file_names
//           --- ignore warning ---

import '../class/class_riwayat_pembelian.dart';
import '../class/class_inventaris.dart';
import '../class/class_buku.dart';

void rekomendasiBuku(RiwayatPembelian riwayat, Inventaris inventaris) {
  if (riwayat.riwayat.isEmpty) {
    print(
        "\n    [!] Belum ada riwayat pembelian untuk memberikan rekomendasi.\n");
    return;
  }
//   // Implementasi rekomendasi buku sederhana (berdasarkan penulis yang sama)
  Map<String, int> penulisFrekuensi = {};
  for (var pembelian in riwayat.riwayat) {
    String penulis = pembelian['buku'].penulisBuku;
    penulisFrekuensi[penulis] = (penulisFrekuensi[penulis] ?? 0) + 1;
  }

  String penulisTeratas =
      penulisFrekuensi.entries.reduce((a, b) => a.value > b.value ? a : b).key;

  List<Buku> rekomendasi = inventaris.daftarbuku
      .where((buku) => buku.penulisBuku == penulisTeratas)
      .toList();
  if (rekomendasi.isNotEmpty) {
    print("\n     ▶ Rekomendasi buku berdasarkan penulis favorit Anda : \n");
    for (var buku in rekomendasi) {
      print(buku);
    }
  } else {
    print(
        "\n     [!] Tidak ada rekomendasi buku saat ini. Silakan coba lagi nanti atau tambahkan lebih banyak buku ke riwayat pembelian Anda.\n");
  }
}
