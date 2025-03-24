import 'package:flutter/material.dart';
import 'package:form_login/services/mahasiswa_service.dart';
import 'package:form_login/models/mahasiswa_model.dart';

class MahasiswaScreen extends StatefulWidget {
  const MahasiswaScreen({super.key});

  @override
  _MahasiswaScreenState createState() => _MahasiswaScreenState();
}

class _MahasiswaScreenState extends State<MahasiswaScreen> {
  final MahasiswaService _mahasiswaService = MahasiswaService();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();
  List<Mahasiswa> _mahasiswaList = [];
  Mahasiswa? _selectedMahasiswa;

  @override
  void initState() {
    super.initState();
    _loadMahasiswa();
  }

  void _loadMahasiswa() async {
    final mahasiswa = await _mahasiswaService.getAllMahasiswa();
    setState(() {
      _mahasiswaList = mahasiswa;
    });
  }

  void _deleteMahasiswa(int id) async {
    await _mahasiswaService.deleteMahasiswa(id);
    setState(() {
      _mahasiswaList.removeWhere((m) => m.id == id);
    });
  }

  void _showMahasiswaModal({Mahasiswa? mahasiswa}) {
    if (mahasiswa != null) {
      _selectedMahasiswa = mahasiswa;
      _namaController.text = mahasiswa.nama;
      _nimController.text = mahasiswa.nim;
      _jurusanController.text = mahasiswa.jurusan;
    } else {
      _selectedMahasiswa = null;
      _namaController.clear();
      _nimController.clear();
      _jurusanController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _jurusanController,
                decoration: const InputDecoration(
                  labelText: 'Jurusan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 6,
                  ),
                  onPressed: _saveMahasiswa,
                  child: Text(
                    _selectedMahasiswa == null
                        ? 'Tambah Mahasiswa'
                        : 'Update Mahasiswa',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteMahasiswa(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus mahasiswa ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMahasiswa(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _saveMahasiswa() async {
    if (_namaController.text.isNotEmpty &&
        _nimController.text.isNotEmpty &&
        _jurusanController.text.isNotEmpty) {
      if (_selectedMahasiswa == null) {
        Mahasiswa newMahasiswa = Mahasiswa(
          nama: _namaController.text,
          nim: _nimController.text,
          jurusan: _jurusanController.text,
        );
        int newId = await _mahasiswaService.insertMahasiswa(newMahasiswa);
        newMahasiswa.id = newId;
        setState(() {
          _mahasiswaList.add(newMahasiswa);
        });
      } else {
        _selectedMahasiswa!.nama = _namaController.text;
        _selectedMahasiswa!.nim = _nimController.text;
        _selectedMahasiswa!.jurusan = _jurusanController.text;
        await _mahasiswaService.updateMahasiswa(_selectedMahasiswa!);
        setState(() {
          int index =
              _mahasiswaList.indexWhere((m) => m.id == _selectedMahasiswa!.id);
          if (index != -1) {
            _mahasiswaList[index] = _selectedMahasiswa!;
          }
        });
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahasiswa', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _mahasiswaList.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.blue.shade900),
                      title: Text(
                        _mahasiswaList[index].nama,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '${_mahasiswaList[index].nim} - ${_mahasiswaList[index].jurusan}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showMahasiswaModal(
                                mahasiswa: _mahasiswaList[index]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDeleteMahasiswa(
                                _mahasiswaList[index].id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMahasiswaModal(),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue.shade900,
      ),
    );
  }
}
