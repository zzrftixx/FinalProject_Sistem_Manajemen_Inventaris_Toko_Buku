// ignore_for_file: depend_on_referenced_packages, unnecessary_brace_in_string_interps

import 'dart:io';
import 'package:csv/csv.dart';

final terminalColorReset = '\x1B[0m';
final terminalColorBright = '\x1B[1m';
final terminalColorRed = '\x1B[31m';
final terminalColorBlue = '\x1B[34m';
final terminalColorCyan = '\x1B[36m';
final terminalColorPink = '\x1b[38;5;200m';
final terminalColorWhite = '\x1B[37m';
final terminalColorGreen = '\x1B[32m';
final terminalColorYellow = '\x1B[33m';
final terminalColorMagenta = '\x1B[35m';
final terminalColor1 = '\x1b[38;2;r;g;bm';
final terminalColor2 = ' \x1b[48;2;r;g;bm';

class Buku {
  String judul;
  String penulis;
  int harga;
  int stok;

  Buku(this.judul, this.penulis, this.harga, this.stok);

  @override
  String toString() {
    return '''
      ◥ ⌈ Buku : $judul      
           » penulis: $penulis 
           » harga: Rp $harga 
        ⌊  » stok: $stok    
    ''';
  }

  List<String> toCsvRow() {
    return [judul, penulis, harga.toString(), stok.toString()];
  }

  static Buku fromCsvRow(List<String> row) {
    return Buku(row[0], row[1], int.parse(row[2]), int.parse(row[3]));
  }
}

class Inventaris {
  List<Buku> daftarBuku = [];
  final String csvFilePath = 'inventaris.csv';

  Inventaris() {
    _loadDataFromCsv();
  }

  void tambahBuku() {
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
    int stok = validasiInputAngka(stdin.readLineSync()!);
    if (stok == -1) {
      print("\n    [!] Stock harus berupa angka! \n");
      return;
    }
    daftarBuku.add(Buku(judul, penulis, harga, stok));
    _saveDataToCsv();
    print("\n    [✓] Buku berhasil ditambahkan! \n");
  }

  void cariBuku() {
    stdout.write("\n    [-] Masukkan kata kunci pencarian (judul/penulis) : ");
    String kataKunci = stdin.readLineSync()!.toLowerCase();
    List<Buku> hasilPencarian = daftarBuku
        .where((buku) =>
            buku.judul.toLowerCase().contains(kataKunci) ||
            buku.penulis.toLowerCase().contains(kataKunci))
        .toList();
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
    stdout.write("    [!] Masukkan judul buku yang akan diubah : ");
    String judul = stdin.readLineSync()!;
    Buku? buku = daftarBuku.firstWhere(
      (b) => b.judul == judul,
      orElse: () => Buku('', '', 0, 0),
    );
    if (buku.judul.isEmpty) {
      print("    [!] Buku tidak ditemukan.");
      return;
    }
    stdout.write(
        "    [⌂] Pilih data yang akan diubah ([1]: Harga, [2]: Stok) : ");
    int pilihan = validasiInputAngka(stdin.readLineSync()!);
    if (pilihan == 1) {
      stdout.write("        ↪ Harga baru : ");
      int hargaBaru = validasiInputAngka(stdin.readLineSync()!);
      if (hargaBaru == -1) {
        print("\n    [!] Harga harus berupa angka! \n");
        return;
      }
      buku.harga = hargaBaru;
      _saveDataToCsv();
      print("\n    [✓] Harga Buku berhasil di ubah! \n");
    } else if (pilihan == 2) {
      stdout.write("        ↪ Stock baru : ");
      int stokBaru = validasiInputAngka(stdin.readLineSync()!);
      if (stokBaru == -1) {
        print("\n    [!] Stock harus berupa angka! \n");
        return;
      }
      buku.stok = stokBaru;
      _saveDataToCsv();
      print("\n    [✓] Stock Buku berhasil di ubah! \n");
    } else {
      print("    [!] Pilihan tidak valid.\n");
    }
  }

  void hapusBuku() {
    stdout.write("    [-] Masukkan judul buku yang akan dihapus : ");
    String judul = stdin.readLineSync()!;
    int panjangAwal = daftarBuku.length;
    daftarBuku.removeWhere((buku) => buku.judul == judul);
    int panjangAkhir = daftarBuku.length;
    if (panjangAwal > panjangAkhir) {
      _saveDataToCsv();
      print("\n    [✓] Buku berhasil dihapus!");
    } else {
      print("\n    [!] Buku tidak ditemukan.");
    }
  }

  void tampilkanDaftarBuku() {
    if (daftarBuku.isEmpty) {
      print("\n    [!] » Belum ada buku dalam inventaris.");
      return;
    }
    print("\n     [Semua daftar Buku] ↴");
    for (var buku in daftarBuku) {
      print(buku);
    }
  }

  void kurangiStok(String judul, int jumlah) {
    Buku? buku = daftarBuku.firstWhere(
      (b) => b.judul == judul,
      orElse: () => Buku('', '', 0, 0),
    );
    if (buku.judul.isNotEmpty) {
      buku.stok -= jumlah;
      _saveDataToCsv();
    }
  }

  void _saveDataToCsv() {
    List<List<String>> csvData = [
      ['Judul', 'Penulis', 'Harga', 'Stok'],
      ...daftarBuku.map((buku) => buku.toCsvRow()).toList()
    ];
    String csv = const ListToCsvConverter().convert(csvData);
    File(csvFilePath).writeAsStringSync(csv);
  }

  void _loadDataFromCsv() {
    if (!File(csvFilePath).existsSync()) {
      return;
    }
    List<List<dynamic>> csvData = const CsvToListConverter().convert(
      File(csvFilePath).readAsStringSync(),
      eol: '\n',
    );
    if (csvData.isNotEmpty) {
      daftarBuku = csvData
          .skip(1)
          .map((row) => Buku.fromCsvRow(row.map((e) => e.toString()).toList()))
          .toList();
    }
  }
}

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

    Buku? buku = inventaris.daftarBuku.firstWhere(
      (b) => b.judul == judul,
      orElse: () => Buku('', '', 0, 0),
    );

    if (buku.judul.isNotEmpty && buku.stok >= jumlah) {
      keranjang.add({'buku': buku, 'jumlah': jumlah});
      print("\n    [✓] Buku berhasil ditambahkan ke keranjang! \n");
    } else {
      print("    [!] Stok tidak mencukupi atau buku tidak ditemukan.");
    }
  }

  void hapusBukuDariKeranjang() {
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
      print("   ⟬ ${item['buku'].judul} (Jumlah: ${item['jumlah']})");
    }
  }

  void checkout(Inventaris inventaris, RiwayatPembelian riwayat) {
    if (keranjang.isEmpty) {
      print("\n    [!] Keranjang belanja kosong.");
      return;
    }

    num totalHarga = 0;
    for (var item in keranjang) {
      totalHarga += item['buku'].harga * item['jumlah'];
      print(
          "   ⟬ ${item['buku'].judul} (Jumlah: ${item['jumlah']} x ${item['buku'].harga}");
    }
    print("     ◥ Total harga: Rp $totalHarga");

    stdout.write("    [-] Lanjutkan pembayaran? (y/n) y: ");
    String konfirmasi = stdin.readLineSync()!.toLowerCase();

    if (konfirmasi == 'y') {
      for (var item in keranjang) {
        inventaris.kurangiStok(item['buku'].judul, item['jumlah']);
        riwayat.tambahkanPembelian(item);
      }
      keranjang.clear();
      print("\n     [!] Pembayaran berhasil! Terima kasih telah berbelanja.\n");
    } else {
      print("\n     [!] Pembayaran dibatalkan.\n");
    }
  }
}

class RiwayatPembelian {
  List<Map<String, dynamic>> riwayat = [];

  void tambahkanPembelian(Map<String, dynamic> pembelian) {
    pembelian['tanggal'] = DateTime.now();
    riwayat.add(pembelian);
  }

  void tampilkanRiwayatPembelian() {
    if (riwayat.isEmpty) {
      print("\n    [!] Belum ada riwayat pembelian.\n");
      return;
    }

    print("\n     ◥ Riwayat Pembelian :");
    num totalHarga = 0;
    for (var item in riwayat) {
      totalHarga += item['buku'].harga * item['jumlah'];
      print(
          "- ${item['buku'].judul} (Jumlah: ${item['jumlah']}) pada ${item['tanggal']}");
      print("     ◥ Total harga: Rp $totalHarga");
    }
  }
}

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
        inventaris.tampilkanDaftarBuku();
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
        keranjang.hapusBukuDariKeranjang();
        break;
      case 3:
        keranjang.lihatKeranjang();
        break;
      case 4:
        keranjang.checkout(inventaris, riwayat);
        break;
      case 0:
        return;
      default:
        print("    [!] Pilihan tidak valid.\n");
    }
  }
}

void tampilkanMenuUtama() {
  print(''' \n
   ${terminalColorRed}              ______     __        ___       __       
   ${terminalColorGreen}             /_  __/__  / /_____  / _ )__ __/ /____ __
   ${terminalColorYellow}              / / / _ \\/  '_/ _ \\/ _  / // /  '_/ // /
   ${terminalColorMagenta}             /_/  \\___/_/\\_\\\\___/____/\\_,_/_/\\_\\\\_,_/ 
    ${terminalColorPink}
    ${terminalColorBright}
       ----=================================================----
       |    Aplikasi Management Sistem Inventaris Toko Buku    |
       ----=================================================----
    ${terminalColorCyan}
    ${terminalColorBright}
    
    | Dev : @andraariesfi | Github : https://github.com/zzrftixx |
  ''');
  print("\n    ============= PILIH MENU =============");
  print(
      "${terminalColorReset}    [${terminalColorGreen}1${terminalColorReset}]. Tambah Buku");
  print("    [${terminalColorGreen}2${terminalColorReset}]. Cari Buku");
  print("    [${terminalColorGreen}3${terminalColorReset}]. Ubah Data Buku");
  print("    [${terminalColorGreen}4${terminalColorReset}]. Hapus Buku");
  print(
      "    [${terminalColorGreen}5${terminalColorReset}]. Tampilkan Daftar Buku");
  print("    [${terminalColorGreen}6${terminalColorReset}]. Keranjang Belanja");
  print("    [${terminalColorGreen}7${terminalColorReset}]. Rekomendasi Buku");
  print("    [${terminalColorGreen}8${terminalColorReset}]. Riwayat Pembelian");
  print("    [${terminalColorGreen}0${terminalColorReset}]. Keluar");
}

void tampilkanMenuKeranjang() {
  print("\n\n   ========== KERANJANG BELANJA ==========");
  print("    [1]. Tambah Buku ke Keranjang");
  print("    [2]. Hapus Buku dari Keranjang");
  print("    [3]. Lihat Keranjang");
  print("    [4]. Checkout");
  print("    [0]. Kembali ke Menu Utama");
}

void rekomendasiBuku(RiwayatPembelian riwayat, Inventaris inventaris) {
  if (riwayat.riwayat.isEmpty) {
    print(
        "\n    [!] Belum ada riwayat pembelian untuk memberikan rekomendasi.\n");
    return;
  }

  // Implementasi rekomendasi buku sederhana (berdasarkan penulis yang sama)
  Map<String, int> penulisFrekuensi = {};
  for (var pembelian in riwayat.riwayat) {
    String penulis = pembelian['buku'].penulis;
    penulisFrekuensi[penulis] = (penulisFrekuensi[penulis] ?? 0) + 1;
  }

  String penulisTeratas =
      penulisFrekuensi.entries.reduce((a, b) => a.value > b.value ? a : b).key;

  List<Buku> rekomendasi = inventaris.daftarBuku
      .where((buku) => buku.penulis == penulisTeratas)
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

int validasiInputAngka(String input) {
  return int.tryParse(input) ?? -1;
}
