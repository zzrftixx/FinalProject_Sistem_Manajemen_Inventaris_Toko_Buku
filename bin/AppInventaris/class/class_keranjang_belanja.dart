import 'dart:io';
import 'class_buku.dart';
import 'class_inventaris.dart';
import 'class_riwayat_pembelian.dart';
import '../util/validasiInputAngka.dart';

class KeranjangBelanja {
  List<Map<String, dynamic>> keranjang = [];

  void tambahBukuKeKeranjang(Inventaris inventaris) {
    stdout.write("\n    [-] Masukan judul Buku : ");
    String judul = stdin.readLineSync()!;
    stdout.write("    [-] Masukkan jumlah : ");
    int jumlah = validasiInputAngka(stdin.readLineSync()!);

    if (jumlah == -1) {
      print("    [!] Jumlah harus berupa angka.");
      return;
    }
    Buku? buku = inventaris.daftarbuku.firstWhere(
      (b) => b.judulBuku == judul,
      orElse: () => Buku('', '', 0, 0),
    );
    if (buku.judulBuku.isNotEmpty && buku.stokBuku >= jumlah) {
      keranjang.add({'buku': buku, 'jumlah': jumlah});
      print("\n    [✓] Buku berhasil ditambahkan ke keranjang! \n");
    } else {
      print("    [!] Stok tidak mencukupi atau buku tidak ditemukan.");
    }
  }

  void hapusBukudariKeranjang() {
    if (keranjang.isEmpty) {
      print("\n    [!] Keranjang belanja kosong.");
      return;
    }
    keranjang.removeLast();
    print("\n    [!] Buku terakhir berhasil dihapus dari keranjang!");
  }

  void lihatKeranjang() {
    if (keranjang.isEmpty) {
      print("\n    [!] Keranjang belanja kosong.");
      return;
    }
    print("\n    [!] Isi Keranjang Belanja:");
    for (var item in keranjang) {
      print("   ⟬ ${item['buku'].judulBuku} (Jumlah: ${item['jumlah']})");
    }
  }

  void checkoutBukudariKeranjang(
      Inventaris inventaris, RiwayatPembelian riwayat) {
    if (keranjang.isEmpty) {
      print("\n    [!] Keranjang belanja kosong.");
      return;
    }
    num totalHarga = 0;
    for (var item in keranjang) {
      totalHarga += item['buku'].hargaBuku * item['jumlah'];
      print(
          "   ⟬ ${item['buku'].judulBuku} (Jumlah: ${item['jumlah']} x ${item['buku'].hargaBuku}");
    }
    print("     ◥ Total harga: Rp $totalHarga");
    stdout.write("    [-] Lanjutkan pembayaran? (y/n) y: ");
    String konformasi = stdin.readLineSync()!.toLowerCase();
    if (konformasi == 'y') {
      for (var item in keranjang) {
        inventaris.kurangiStock(item['buku'].judulBuku, item['jumlah']);
        riwayat.tambahkanPembelian(item);
      }
      keranjang.clear();
      print("\n     [!] Pembayaran berhasil! Terima kasih telah berbelanja.\n");
    } else {
      print("\n     [!] Pembayaran dibatalkan.\n");
    }
  }
}
