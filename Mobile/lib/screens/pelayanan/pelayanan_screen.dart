import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_format_utils.dart';
import '../../core/utils/view_state.dart';
import '../../models/pengajuan_pelayanan_model.dart';
import '../../services/pelayanan_service.dart';
import 'ajukan_pelayanan_screen.dart';
import 'detail_pengajuan_screen.dart';
import 'riwayat_pengajuan_screen.dart';

/// M-06 Pelayanan Administrasi
/// Tab kedua Bottom Navigation - landing page pelayanan
class PelayananScreen extends StatefulWidget {
  const PelayananScreen({super.key});

  @override
  State<PelayananScreen> createState() => _PelayananScreenState();
}

class _PelayananScreenState extends State<PelayananScreen> {
  final PelayananService _service = PelayananService();

  ViewState _viewState = ViewState.loading;
  List<PengajuanPelayananModel> _list = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _viewState = ViewState.loading;
      _errorMessage = '';
    });

    final result = await _service.getAll();

    if (!mounted) return;

    if (result.success && result.data != null) {
      setState(() {
        _list = result.data!;
        _viewState =
            _list.isEmpty ? ViewState.empty : ViewState.loaded;
      });
    } else {
      setState(() {
        _errorMessage = result.message ?? 'Gagal memuat data';
        _viewState = ViewState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildHeader(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildRiwayatSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AjukanPelayananScreen(),
            ),
          ).then((_) => _loadData());
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(
          Icons.add_rounded,
          color: AppColors.white,
        ),
        label: const Text(
          'Ajukan Baru',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.headerGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pelayanan Administrasi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'RT 20 - Ajukan kebutuhan administrasi Anda',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Aksi Cepat',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _quickActionButton(
                icon: Icons.add_circle_outline_rounded,
                label: 'Ajukan Pelayanan',
                color: AppColors.primary,
                bgColor: AppColors.primarySurface,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const AjukanPelayananScreen(),
                    ),
                  ).then((_) => _loadData());
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _quickActionButton(
                icon: Icons.history_rounded,
                label: 'Semua Riwayat',
                color: const Color(0xFF7C3AED),
                bgColor: const Color(0xFFEDE9FE),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const RiwayatPengajuanScreen(),
                    ),
                  ).then((_) => _loadData());
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Pengajuan Terbaru',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const RiwayatPengajuanScreen(),
                  ),
                ).then((_) => _loadData());
              },
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildRiwayatContent(),
      ],
    );
  }

  Widget _buildRiwayatContent() {
    if (_viewState == ViewState.loading) {
      return _buildRiwayatShimmer();
    }

    if (_viewState == ViewState.error) {
      return _buildRiwayatError();
    }

    if (_viewState == ViewState.empty || _list.isEmpty) {
      return _buildRiwayatEmpty();
    }

    final displayed = _list.take(3).toList();

    return Column(
      children: displayed
          .map(
            (item) => _buildRiwayatCard(item),
          )
          .toList(),
    );
  }

  Widget _buildRiwayatShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          3,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayatEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.assignment_outlined,
            size: 40,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 10),
          const Text(
            'Belum ada pengajuan',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const AjukanPelayananScreen(),
                ),
              ).then((_) => _loadData());
            },
            child: const Text('Ajukan Sekarang'),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 36,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 10),
          const Text(
            'Gagal memuat pengajuan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _loadData,
            icon: const Icon(
              Icons.refresh_rounded,
              size: 18,
            ),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatCard(
    PengajuanPelayananModel item,
  ) {
    final statusColor = _statusColor(item.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPengajuanScreen(
              pengajuan: item,
            ),
          ),
        ).then((_) => _loadData());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: statusColor.withAlpha(18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _statusIcon(item.status),
                color: statusColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.nomorPengajuan,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 120,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.status.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.purpose,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    DateFormatUtils.formatDate(
                      item.submittedAt,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(PengajuanStatus status) {
    switch (status) {
      case PengajuanStatus.menungguVerifikasi:
        return Icons.hourglass_empty_rounded;

      case PengajuanStatus.diproses:
        return Icons.autorenew_rounded;

      case PengajuanStatus.ditolak:
        return Icons.cancel_outlined;

      case PengajuanStatus.selesai:
        return Icons.check_circle_outline_rounded;
    }
  }

  Color _statusColor(PengajuanStatus status) {
    switch (status) {
      case PengajuanStatus.menungguVerifikasi:
        return AppColors.warning;

      case PengajuanStatus.diproses:
        return AppColors.primary;

      case PengajuanStatus.ditolak:
        return AppColors.danger;

      case PengajuanStatus.selesai:
        return AppColors.accent;
    }
  }
}