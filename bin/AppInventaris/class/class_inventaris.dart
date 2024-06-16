//           --- ignore warning ---
// ignore_for_file: depend_on_referenced_packages
//           --- ignore warning ---

import 'dart:io';
import 'class_buku.dart';
import 'package:csv/csv.dart';
import '../util/validasiInputAngka.dart';

class Inventaris {
  List<Buku> daftarbuku = [];
  final String filePathCsv = 'dataBuku.csv';

  Inventaris() {
    _loadDatatoCsv();
  }

  // ==================================== CSV METHOD ====================================
  //!! save data ke csv
  void _saveDatatoCsv() {
    List<List<String>> csvData = [
      ['Judul', 'Penulis', 'Harga', 'Stok'],
      ...daftarbuku.map((buku) => buku.convertToCsvrow()).toList()
    ];
    String csv = const ListToCsvConverter().convert(csvData);
    File(filePathCsv).writeAsStringSync(csv);
  }

  //!! load data dari csv
  void _loadDatatoCsv() {
    if (!File(filePathCsv).existsSync()) {
      return;
    }
    List<List<dynamic>> csvData = const CsvToListConverter().convert(
      File(filePathCsv).readAsStringSync(),
      eol: '\n',
    );
    if (csvData.isNotEmpty) {
      daftarbuku = csvData
          .skip(1)
          .map((row) =>
              Buku.converterToBuku(row.map((e) => e.toString()).toList()))
          .toList();
    }
  }
  // ==================================== CSV METHOD ====================================

  void tambahBuku() {
    // ** mengbuat fungsi tambah buku **
    stdout.write("\n    [-] judul : ");
    String judul = stdin.readLineSync()!;
    stdout.write("    [-] Penulis : ");
    String penulis = stdin.readLineSync()!;
    stdout.write("    [-] Harga : ");
    int harga = validasiInputAngka(stdin.readLineSync()!);
    if (harga == -1) {
      print("\n    [!] Harga harus berupa angka! \n");
      return;
    }
    stdout.write("    [-] Stock : ");
    int stock = validasiInputAngka(stdin.readLineSync()!);
    if (stock == -1) {
      print("\n    [!] Stock harus berupa angka! \n");
      return;
    }
    daftarbuku.add(Buku(judul, penulis, harga, stock));
    _saveDatatoCsv();
    print("\n    [✓] Buku berhasil ditambahkan! \n");
  }

  void cariBuku() {
    // **bagian (Linear Search) **
    stdout.write("\n    [-] Masukkan kata kunci pencarian (judul/penulis) : ");
    String kataKunci = stdin.readLineSync()!.toLowerCase();
    List<Buku> hasilPencarian = [];
    for (var buku in daftarbuku) {
      if (buku.judulBuku.toLowerCase().contains(kataKunci) ||
          buku.penulisBuku.toLowerCase().contains(kataKunci)) {
        hasilPencarian.add(buku);
      }
    }

    if (hasilPencarian.isNotEmpty) {
      print("\n   ▶ Hasil Pencarian ↴ \n");
      for (var buku in hasilPencarian) {
        print(buku);
      }
    } else {
      print("    [!] Buku tidak ditemukan.\n");
    }
  }

  void ubahDataBuku() {
    // **fungsi ubah data buku **
    stdout.write("    [!] Masukkan judul buku yang akan diubah : ");
    String judul = stdin.readLineSync()!;
    Buku buku = daftarbuku.firstWhere(
      (buku) => buku.judulBuku == judul,
      orElse: () => Buku('', '', 0, 0),
    );
    if (buku.judulBuku.isEmpty) {
      print("    [!] Buku tidak ditemukan.");
      return;
    }
    stdout.write(
        "    [⌂] Pilih data yang akan diubah ([1]: Harga, [2]: Stok) : ");
    int pilihUbah = validasiInputAngka(stdin.readLineSync()!);
    if (pilihUbah == 1) {
      stdout.write("        ↪ Harga baru : ");
      int hargaBaru = validasiInputAngka(stdin.readLineSync()!);
      if (hargaBaru == -1) {
        print("\n    [!] Harga harus berupa angka! \n");
        return;
      }
      buku.hargaBuku = hargaBaru;
      _saveDatatoCsv();
      print("\n    [✓] Harga Buku berhasil di ubah! \n");
    } else if (pilihUbah == 2) {
      stdout.write("        ↪ Stock baru : ");
      int stockBaru = validasiInputAngka(stdin.readLineSync()!);
      if (stockBaru == -1) {
        print("\n    [!] Stock harus berupa angka! \n");
        return;
      }
      buku.stokBuku = stockBaru;
      _saveDatatoCsv();
      print("\n    [✓] Stock Buku berhasil di ubah! \n");
    } else {
      print("    [!] Pilihan tidak valid.\n");
    }
  }

  void hapusBuku() {
    // **fungsi hapus buku **
    stdout.write("    [-] Masukkan judul buku yang akan dihapus : ");
    String judul = stdin.readLineSync()!;
    int panjangAwal = daftarbuku.length;
    daftarbuku.removeWhere((buku) => buku.judulBuku == judul);
    int panjangAkhir = daftarbuku.length;
    if (panjangAwal > panjangAkhir) {
      _saveDatatoCsv();
      print("\n    [✓] Buku berhasil dihapus!");
    } else {
      print("\n    [!] Buku tidak ditemukan.");
    }
  }

  void tampilDaftarBuku() {
    // **fungsi tampil buku **
    if (daftarbuku.isEmpty) {
      print("\n    [!] » Belum ada buku dalam inventaris.");
      return;
    } else {
      print("\n     [Semua daftar Buku] ↴");
      for (var buku in daftarbuku) {
        print(buku);
      }
    }
  }

  void kurangiStock(String judul, int jumlah) {
    // **fungsi kurangi stock buku dengan liniar search**
    Buku? buku;
    bool found = false;
    for (var b in daftarbuku) {
      if (b.judulBuku == judul) {
        buku = b;
        found = true;
        break;
      }
    }

    if (!found) {
      buku = Buku('', '', 0, 0);
    }
    if (buku!.judulBuku.isNotEmpty) {
      buku.stokBuku -= jumlah;
      _saveDatatoCsv();
    }
  }
}
