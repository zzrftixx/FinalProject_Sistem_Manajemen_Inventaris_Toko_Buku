class RiwayatPembelian {
  List<Map<String, dynamic>> riwayat = [];

  void tambahkanPembelian(Map<String, dynamic> pembelian) {
    pembelian['tanggal'] = DateTime.now();
    riwayat.add(pembelian);
  }

  void tampilkanRiwayatPembelian() {
    if (riwayat.isEmpty) {
      print("\n     [!] Belum ada riwayat pembelian.\n");
      return;
    } else {
      print("\n     ◥ Riwayat Pembelian :");
      num totalHarga = 0;
      for (var item in riwayat) {
        totalHarga += item['buku'].hargaBuku * item['jumlah'];
        print('''
                  ◉ ${item['buku'].judulBuku} 
                  (Jumlah: ${item['jumlah']}) pada ${item['tanggal']}
              ''');
        print("     ◥ Total harga: Rp $totalHarga");
      }
    }
  }
}
