import 'package:flutter/material.dart';

// Fungsi utama: titik awal aplikasi
void main() => runApp(const GymBuddyApp());

// ===================== MODEL DATA =====================

// Model untuk program latihan
class Program {
  final String name;
  final String muscle;
  final int minutes;
  final String level;
  final IconData icon;

  const Program(this.name, this.muscle, this.minutes, this.level, this.icon);
}

// Model untuk jadwal harian
class ScheduleItem {
  String day;
  String time;
  String title;
  bool done;

  ScheduleItem(this.day, this.time, this.title, this.done);
}

// ===================== ROOT APP =====================

class GymBuddyApp extends StatelessWidget {
  const GymBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: widget root yang mengatur tema & halaman utama
    return MaterialApp(
      title: 'GymBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ===================== HALAMAN UTAMA =====================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // tab yang sedang aktif
  bool _reminderOn = true; // status switch pengingat
  final TextEditingController _titleController = TextEditingController();

  // Daftar program latihan
  final List<Program> _programs = const [
    Program('Push Day', 'Dada, Bahu, Triceps', 60, 'Menengah', Icons.fitness_center),
    Program('Pull Day', 'Punggung, Biceps', 55, 'Menengah', Icons.sports_gymnastics),
    Program('Leg Day', 'Paha, Betis, Glutes', 70, 'Lanjut', Icons.directions_run),
    Program('Cardio HIIT', 'Seluruh tubuh', 30, 'Pemula', Icons.favorite),
    Program('Core & Abs', 'Perut, Core', 25, 'Pemula', Icons.self_improvement),
  ];

  // Daftar jadwal harian
  final List<ScheduleItem> _schedule = [
    ScheduleItem('Senin', '07:00', 'Push Day', true),
    ScheduleItem('Selasa', '17:30', 'Cardio HIIT', true),
    ScheduleItem('Rabu', '07:00', 'Pull Day', false),
    ScheduleItem('Kamis', '18:00', 'Core & Abs', false),
    ScheduleItem('Jumat', '07:00', 'Leg Day', false),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Hitung jumlah sesi yang sudah selesai
  int get _doneCount => _schedule.where((s) => s.done).length;

  @override
  Widget build(BuildContext context) {
    final pages = [_buildHome(), _buildPrograms(), _buildSchedule()];

    // Scaffold: kerangka dasar halaman (appbar, body, drawer, FAB, bottom bar)
    return Scaffold(
      // AppBar: bar judul di atas
      appBar: AppBar(
        title: const Text('GymBuddy'), // Text: judul aplikasi
        centerTitle: true,
        actions: [
          // IconButton: tombol ikon di AppBar
          IconButton(
            icon: const Icon(Icons.notifications_active), // Icon: ikon lonceng
            onPressed: () {
              // SnackBar: pesan singkat di bagian bawah layar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Jangan lupa latihan hari ini!')),
              );
            },
          ),
        ],
      ),
      // Drawer: menu samping
      drawer: _buildDrawer(),
      body: pages[_currentIndex],
      // FloatingActionButton: tombol tambah jadwal (hanya di tab Jadwal)
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              onPressed: _showAddDialog,
              child: const Icon(Icons.add),
            )
          : null,
      // BottomNavigationBar: navigasi antar tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Program'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Jadwal'),
        ],
      ),
    );
  }

  // ===================== DRAWER =====================

  Widget _buildDrawer() {
    return Drawer(
      // ListView: daftar item menu yang bisa di-scroll
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // DrawerHeader: bagian atas drawer
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            // Row: susunan horizontal (foto + nama)
            child: Row(
              children: [
                // ClipOval: memotong gambar menjadi lingkaran
                ClipOval(
                  // Image.network: menampilkan gambar dari internet
                  child: Image.network(
                    'https://picsum.photos/100',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    // errorBuilder: fallback jika gambar gagal dimuat / offline
                    errorBuilder: (context, error, stack) => const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 12), // SizedBox: jarak kosong
                // Column: susunan vertikal (nama + email)
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gym Buddy User',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('user@gymbuddy.id', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          // ListTile: item menu
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Beranda'),
            onTap: () {
              setState(() => _currentIndex = 0);
              Navigator.pop(context); // menutup drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Program Latihan'),
            onTap: () {
              setState(() => _currentIndex = 1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Jadwal Harian'),
            onTap: () {
              setState(() => _currentIndex = 2);
              Navigator.pop(context);
            },
          ),
          const Divider(), // Divider: garis pemisah
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Tentang GymBuddy'),
            subtitle: Text('Versi 1.0.0'),
          ),
        ],
      ),
    );
  }

  // ===================== TAB 1: BERANDA =====================

  Widget _buildHome() {
    final total = _schedule.length;
    final progress = total == 0 ? 0.0 : _doneCount / total;

    // ListView: seluruh konten beranda bisa di-scroll
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // SizedBox: membatasi tinggi banner
        SizedBox(
          height: 170,
          // Stack: menumpuk widget (background, ikon, teks)
          child: Stack(
            children: [
              // Positioned.fill: background memenuhi seluruh Stack
              Positioned.fill(
                // Container: kotak dengan gradient & sudut membulat
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepOrange, Colors.orangeAccent],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              // Positioned: menaruh ikon dekoratif di pojok kanan bawah
              const Positioned(
                right: 12,
                bottom: 8,
                child: Icon(Icons.fitness_center, size: 100, color: Colors.white24),
              ),
              // Padding: memberi jarak di dalam banner
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Halo, Atlet! 💪',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('$_doneCount dari $total sesi minggu ini selesai',
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 14),
                    // LinearProgressIndicator: bar progres latihan mingguan
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white30,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Statistik Ringkas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        // GridView.count: kartu statistik 2 kolom
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true, // supaya muat di dalam ListView
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            _statCard(Icons.local_fire_department, 'Kalori', '1.240 kkal', Colors.red),
            _statCard(Icons.timer, 'Durasi', '4 jam 20 m', Colors.blue),
            _statCard(Icons.bolt, 'Streak', '5 hari', Colors.amber),
            _statCard(Icons.monitor_weight, 'Berat', '68 kg', Colors.green),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Fokus Otot Minggu Ini',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        // Wrap: chip otomatis pindah baris jika penuh
        const Wrap(
          spacing: 8,
          children: [
            // Chip: label kecil
            Chip(avatar: Icon(Icons.fitness_center, size: 16), label: Text('Dada')),
            Chip(avatar: Icon(Icons.fitness_center, size: 16), label: Text('Punggung')),
            Chip(avatar: Icon(Icons.fitness_center, size: 16), label: Text('Kaki')),
          ],
        ),
        const SizedBox(height: 20),
        // Center: menengahkan tombol
        Center(
          // ElevatedButton.icon: tombol dengan ikon
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _currentIndex = 1),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Mulai Latihan'),
          ),
        ),
      ],
    );
  }

  // Kartu statistik reusable
  Widget _statCard(IconData icon, String label, String value, Color color) {
    // Card: kartu dengan bayangan
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 10),
            // Expanded: teks mengisi sisa ruang agar tidak overflow
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.grey)),
                  Text(value,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== TAB 2: PROGRAM =====================

  Widget _buildPrograms() {
    // ListView.builder: daftar program latihan
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _programs.length,
      itemBuilder: (context, index) {
        final p = _programs[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            // CircleAvatar: ikon bulat di sisi kiri
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(p.icon),
            ),
            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${p.muscle}\n${p.minutes} menit'),
            isThreeLine: true,
            trailing: Chip(label: Text(p.level)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${p.name} dipilih')),
              );
            },
          ),
        );
      },
    );
  }

  // ===================== TAB 3: JADWAL =====================

  Widget _buildSchedule() {
    return Column(
      children: [
        // SwitchListTile: saklar pengingat latihan
        SwitchListTile(
          title: const Text('Pengingat Latihan'),
          subtitle: Text(_reminderOn ? 'Aktif' : 'Nonaktif'),
          secondary: const Icon(Icons.alarm),
          value: _reminderOn,
          onChanged: (v) => setState(() => _reminderOn = v),
        ),
        const Divider(height: 1),
        // Expanded: daftar jadwal mengisi sisa layar
        Expanded(
          // ListView.separated: daftar jadwal dengan pemisah otomatis
          child: ListView.separated(
            itemCount: _schedule.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = _schedule[index];
              return ListTile(
                // Container: badge hari & jam
                leading: Container(
                  width: 56,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.day.substring(0, 3),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(item.time, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    decoration: item.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(item.day),
                // Checkbox: tandai sesi selesai
                trailing: Checkbox(
                  value: item.done,
                  onChanged: (v) => setState(() => item.done = v ?? false),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ===================== DIALOG TAMBAH JADWAL =====================

  void _showAddDialog() {
    // showDialog + AlertDialog: form tambah jadwal
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Jadwal'),
        // TextField: input nama latihan
        content: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Nama latihan',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          // TextButton: tombol batal
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          // ElevatedButton: tombol simpan
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.trim().isNotEmpty) {
                setState(() {
                  _schedule.add(
                    ScheduleItem('Sabtu', '09:00', _titleController.text.trim(), false),
                  );
                });
                _titleController.clear();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
