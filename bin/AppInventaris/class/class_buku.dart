class Buku {
  String judulBuku;
  String penulisBuku;
  int hargaBuku;
  int stokBuku;

  Buku(
    this.judulBuku,
    this.penulisBuku,
    this.hargaBuku,
    this.stokBuku,
  );
  @override
  String toString() {
    return '''
      ◥ ⌈ Buku : $judulBuku      
           » penulis: $penulisBuku 
           » harga: Rp $hargaBuku 
        ⌊  » stok: $stokBuku    
    ''';
  }

  List<String> convertToCsvrow() {
    return [judulBuku, penulisBuku, hargaBuku.toString(), stokBuku.toString()];
  }

  static Buku converterToBuku(List<String> row) {
    return Buku(row[0], row[1], int.parse(row[2]), int.parse(row[3]));
  }
}
