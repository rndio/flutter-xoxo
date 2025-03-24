class Mahasiswa {
  int? id;
  String nama;
  String nim;
  String jurusan;

  Mahasiswa(
      {this.id, required this.nama, required this.nim, required this.jurusan});

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      id: map['id'],
      nama: map['nama'],
      nim: map['nim'],
      jurusan: map['jurusan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'jurusan': jurusan,
    };
  }
}
