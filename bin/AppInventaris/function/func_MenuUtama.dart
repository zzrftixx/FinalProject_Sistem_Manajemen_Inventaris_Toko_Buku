//           --- ignore warning ---
// ignore_for_file: unnecessary_brace_in_string_interps, file_names
//           --- ignore warning ---

import '../color/colorSchema.dart';

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
