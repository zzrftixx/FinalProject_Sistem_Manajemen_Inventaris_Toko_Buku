//           --- ignore warning ---
// ignore_for_file: depend_on_referenced_packages
//           --- ignore warning ---

import 'dart:io';
import 'class/class_inventaris.dart';
import 'util/validasiInputAngka.dart';
import 'function/func_MenuUtama.dart';
import 'function/func_rekomendasiBuku.dart';
import 'class/class_keranjang_belanja.dart';
import 'class/class_riwayat_pembelian.dart';
import 'function/func_kelolaKeranjangBelanja.dart';

void main() {
  Inventaris inventaris = Inventaris();
  KeranjangBelanja keranjang = KeranjangBelanja();
  RiwayatPembelian riwayat = RiwayatPembelian();

  while (true) {
    tampilkanMenuUtama();
    stdout.write("\n    [-] Pilihan Anda : ");
    int pilihan = validasiInputAngka(stdin.readLineSync()!);

    if (pilihan == -1) {
      print("    [!] Pilihan tidak valid.\n");
      continue;
    }

    switch (pilihan) {
      case 1:
        inventaris.tambahBuku();
        break;
      case 2:
        inventaris.cariBuku();
        break;
      case 3:
        inventaris.ubahDataBuku();
        break;
      case 4:
        inventaris.hapusBuku();
        break;
      case 5:
        inventaris.tampilDaftarBuku();
        break;
      case 6:
        kelolaKeranjangBelanja(keranjang, inventaris, riwayat);
        break;
      case 7:
        rekomendasiBuku(riwayat, inventaris);
        break;
      case 8:
        riwayat.tampilkanRiwayatPembelian();
        break;
      case 0:
        print("\n    [!] Terima kasih telah menggunakan aplikasi ini! \n");
        return;
      default:
        print("    [!] Pilihan tidak valid.\n");
    }
  }
}
