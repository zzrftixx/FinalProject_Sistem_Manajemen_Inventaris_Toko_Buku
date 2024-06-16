//           --- ignore warning ---
// ignore_for_file: file_names
//           --- ignore warning ---

import 'dart:io';
import 'func_MenuKeranjang.dart';
import '../class/class_inventaris.dart';
import '../util/validasiInputAngka.dart';
import '../class/class_keranjang_belanja.dart';
import '../class/class_riwayat_pembelian.dart';

void kelolaKeranjangBelanja(KeranjangBelanja keranjang, Inventaris inventaris,
    RiwayatPembelian riwayat) {
  while (true) {
    tampilkanMenuKeranjang();
    stdout.write("\n    [-] Pilihan Anda : ");
    int pilihan = validasiInputAngka(stdin.readLineSync()!);

    if (pilihan == -1) {
      print("    [!] Input tidak valid.\n");
      continue;
    }

    switch (pilihan) {
      case 1:
        keranjang.tambahBukuKeKeranjang(inventaris);
        break;
      case 2:
        keranjang.hapusBukudariKeranjang();
        break;
      case 3:
        keranjang.lihatKeranjang();
        break;
      case 4:
        inventaris.tampilDaftarBuku();
        break;
      case 5:
        keranjang.checkoutBukudariKeranjang(inventaris, riwayat);
        break;
      case 0:
        return;
      default:
        print("    [!] Pilihan tidak valid.\n");
    }
  }
}
