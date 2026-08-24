import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_format_utils.dart';
import '../../core/widgets/section_header.dart';
import '../../models/user_model.dart';
import '../../models/informasi_model.dart';
import '../../services/auth_service.dart';
import '../../services/informasi_service.dart';
import '../informasi/informasi_screen.dart';
import '../informasi/detail_informasi_screen.dart';
import '../pelayanan/ajukan_pelayanan_screen.dart';
import '../pelayanan/riwayat_pengajuan_screen.dart';
import '../emergency/emergency_screen.dart';
import '../nomor_penting/nomor_penting_screen.dart';

/// M-03 Beranda
///
/// Menampilkan sapaan warga, shortcut utama, dan informasi RT terbaru.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final InformasiService _informasiService = InformasiService();
  UserModel? _user;
  List<InformasiModel> _infoList = [];
  bool _infoLoading = true;
  bool _infoError = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadInfo();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getCurrentUser();
    if (mounted) setState(() => _user = user);
  }

  Future<void> _loadInfo() async {
    setState(() {
      _infoLoading = true;
      _infoError = false;
    });
    final result = await _informasiService.getAll();
    if (!mounted) return;
    if (result.success && result.data != null) {
      setState(() {
        _infoList = result.data!.take(3).toList();
        _infoLoading = false;
      });
    } else {
      setState(() {
        _infoLoading = false;
        _infoError = true;
      });
    }
  }

  Future<void> _refresh() async {
    await Future.wait([_loadUser(), _loadInfo()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShortcutGrid(),
                    const SizedBox(height: 24),
                    _buildInfoSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final firstName = _user?.name.split(' ').first ?? 'Warga';

    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.headerGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row – greeting (notifikasi inbox dihapus: belum tersedia)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withAlpha(200),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            firstName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon aplikasi – dekoratif, bukan tombol
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withAlpha(40),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.location_city_rounded,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // RT info card
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withAlpha(40),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'RT 20 · Warga Aktif',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Aktif',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutGrid() {
    // Lima shortcut yang benar-benar tersedia – "Lainnya" dihapus (dead button)
    final shortcuts = [
      _ShortcutItem(
        label: 'Informasi RT',
        icon: Icons.info_outline_rounded,
        color: AppColors.primary,
        bgColor: AppColors.primarySurface,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InformasiScreen())),
      ),
      _ShortcutItem(
        label: 'Ajukan\nPelayanan',
        icon: Icons.assignment_add,
        color: AppColors.accent,
        bgColor: AppColors.accentLight,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AjukanPelayananScreen())),
      ),
      _ShortcutItem(
        label: 'Status\nPengajuan',
        icon: Icons.pending_actions_outlined,
        color: const Color(0xFF7C3AED),
        bgColor: const Color(0xFFEDE9FE),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RiwayatPengajuanScreen())),
      ),
      _ShortcutItem(
        label: 'Laporan\nDarurat',
        icon: Icons.emergency_outlined,
        color: AppColors.danger,
        bgColor: AppColors.dangerLight,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyScreen())),
      ),
      _ShortcutItem(
        label: 'Nomor\nPenting',
        icon: Icons.contact_phone_outlined,
        color: AppColors.warning,
        bgColor: AppColors.warningLight,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NomorPentingScreen())),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const SectionHeader(title: 'Menu Utama'),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: shortcuts.length,
          itemBuilder: (context, i) => _buildShortcutCard(shortcuts[i]),
        ),
      ],
    );
  }

  Widget _buildShortcutCard(_ShortcutItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: item.color, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.infoTerbaru,
          actionLabel: AppStrings.lihatSemua,
          onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InformasiScreen())),
        ),
        const SizedBox(height: 14),
        if (_infoLoading)
          const Center(child: CircularProgressIndicator())
        else if (_infoError)
          _buildInfoErrorState()
        else if (_infoList.isEmpty)
          _buildInfoEmptyState()
        else
          ...(_infoList.map((info) => _buildInfoCard(info))),
      ],
    );
  }

  Widget _buildInfoErrorState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 36, color: AppColors.textHint),
          const SizedBox(height: 8),
          const Text('Gagal memuat informasi',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadInfo,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: Text('Belum ada informasi',
            style: TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }

  Widget _buildInfoCard(InformasiModel info) {
    final catColor = _categoryColor(info.categoryDisplay);
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => DetailInformasiScreen(informasi: info))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: catColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.article_outlined, color: catColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: catColor.withAlpha(20), borderRadius: BorderRadius.circular(6)),
                          child: Text(info.categoryDisplay,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: catColor)),
                        ),
                        const Spacer(),
                        Text(DateFormatUtils.timeAgo(info.publishedAt),
                            style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(info.title,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(info.contentPreview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary, height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Pengumuman': return AppColors.primary;
      case 'Kesehatan': return const Color(0xFF0E9F6E);
      case 'Kegiatan': return const Color(0xFF7C3AED);
      case 'Keamanan': return AppColors.danger;
      case 'Sosial': return AppColors.warning;
      default: return AppColors.textSecondary;
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi,';
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }
}

class _ShortcutItem {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ShortcutItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });
}
