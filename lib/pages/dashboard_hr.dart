import 'package:flutter/material.dart';

class DashboardHR extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const DashboardHR({
    super.key,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        return _buildDashboard(context, isTablet);
      },
    );
  }

  Widget _buildDashboard(BuildContext context, bool isTablet) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                'https://picsum.photos/seed/logo/40/40',
                width: 32,
                height: 32,
                errorBuilder: (_, __, ___) => const Icon(Icons.business, size: 32),
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text('PT Maju Bersama', overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        actions: [
          // TUGAS 1: Tombol Toggle Tema
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode_outlined,
            ),
            onPressed: onToggleTheme,
            tooltip: 'Ganti Tema',
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://picsum.photos/seed/user/50/50'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TUGAS 2 & 5: Header Bergelombang (WaveClipper) dengan Kontras Warna Terjaga
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [colors.primaryContainer, colors.surfaceContainerHighest]
                        : [colors.primary, colors.tertiary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Pagi, Admin!',
                            style: TextStyle(
                              color: isDark ? colors.onPrimaryContainer : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Senin, 7 Oktober 2024',
                            style: TextStyle(
                              color: isDark
                                  ? colors.onPrimaryContainer.withValues(alpha: 0.8)
                                  : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.waving_hand,
                        color: isDark
                            ? colors.onPrimaryContainer.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.5),
                        size: 54,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grid Statistik Responsif (2 kolom di HP, 4 kolom di Tablet)
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isTablet ? 4 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isTablet ? 1.4 : 1.3,
                    children: [
                      _kartuStat('248', 'Karyawan', Icons.people, colors.primary),
                      _kartuStat('95%', 'Hadir', Icons.check_circle, colors.secondary),
                      _kartuStat('12', 'Cuti', Icons.beach_access, colors.tertiary),
                      _kartuStat('3', 'Rekrut', Icons.person_add, colors.error),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // TUGAS 3: Bar Chart Kehadiran per Divisi
                  Text(
                    'Kehadiran per Divisi',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildBarChartDivisi(context, colors),
                  const SizedBox(height: 20),

                  // Seksi Aktivitas Terkini
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Aktivitas Terkini',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                  ...List.generate(
                    _aktivitas.length,
                    (i) => _kartuAktivitas(_aktivitas[i]),
                  ),
                  const SizedBox(height: 16),

                  // TUGAS 4: Dua Kartu Berdampingan (Vertikal di HP, Horizontal di Tablet)
                  if (isTablet) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildKartuMini(
                            'Terbaru Absen',
                            'Citra Dewi (08:02)',
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKartuMini(
                            'Terbaru Cuti',
                            'Budi Santoso (09:14)',
                            Icons.beach_access,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    _buildKartuMini(
                      'Terbaru Absen',
                      'Citra Dewi (08:02)',
                      Icons.check_circle,
                      Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildKartuMini(
                      'Terbaru Cuti',
                      'Budi Santoso (09:14)',
                      Icons.beach_access,
                      Colors.orange,
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget Tugas 3: Horizontal Bar Chart
  Widget _buildBarChartDivisi(BuildContext context, ColorScheme colors) {
    final divisiData = [
      {'nama': 'Engineering', 'persen': 92},
      {'nama': 'Sales', 'persen': 85},
      {'nama': 'HR', 'persen': 97},
      {'nama': 'Finance', 'persen': 90},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: divisiData.map((item) {
            final int persen = item['persen'] as int;
            final String nama = item['nama'] as String;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      nama,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: persen,
                            child: Container(
                              height: 12,
                              color: colors.primary,
                            ),
                          ),
                          Expanded(
                            flex: 100 - persen,
                            child: Container(
                              height: 12,
                              color: colors.primary.withValues(alpha: 0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 35,
                    child: Text(
                      '$persen%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Helper Widget Tugas 4: Mini Card
  Widget _buildKartuMini(String judul, String subjudul, IconData icon, Color warna) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: warna.withValues(alpha: 0.15),
          child: Icon(icon, color: warna, size: 20),
        ),
        title: Text(judul, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text(subjudul, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _kartuStat(String nilai, String label, IconData icon, Color warna) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: warna.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: warna, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nilai,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: warna,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const _aktivitas = [
    (
      nama: 'Budi Santoso',
      aksi: 'Mengajukan cuti',
      waktu: '09:14',
      icon: Icons.beach_access,
      warna: Colors.orange
    ),
    (
      nama: 'Citra Dewi',
      aksi: 'Check-in absensi',
      waktu: '08:02',
      icon: Icons.check_circle,
      warna: Colors.green
    ),
    (
      nama: 'Eko Wahyudi',
      aksi: 'Upload kontrak baru',
      waktu: '07:45',
      icon: Icons.description,
      warna: Colors.blue
    ),
  ];

  Widget _kartuAktivitas(
    ({String nama, String aksi, String waktu, IconData icon, MaterialColor warna}) d,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: d.warna.withValues(alpha: 0.15),
          child: Icon(d.icon, color: d.warna, size: 20),
        ),
        title: Text(d.nama, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(d.aksi),
        trailing: Text(
          d.waktu,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      ),
    );
  }
}

// TUGAS 5: Custom Clipper Gelombang (Wave Shape)
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 15);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 35);
    var secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}