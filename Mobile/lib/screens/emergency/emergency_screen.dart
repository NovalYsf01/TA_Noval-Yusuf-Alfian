import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../models/laporan_darurat_model.dart';
import '../../services/laporan_darurat_service.dart';

/// Halaman Laporan Darurat Warga.
///
/// Fitur:
/// - Membuat laporan darurat.
/// - Melihat riwayat laporan milik warga.
/// - Melihat status penanganan.
/// - Melihat feedback Pengurus RT.
/// - Melihat foto bukti penanganan.
/// - Melihat waktu ditangani dan selesai.
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();

  final LaporanDaruratService _service = LaporanDaruratService();

  EmergencyType? _selectedType;

  bool _isSubmitting = false;
  bool _submitted = false;

  String _submitMessage = '';

  int _selectedSection = 0;

  bool _isLoadingReports = false;
  String? _reportsError;

  List<LaporanDaruratModel> _reports = [];

  @override
  void initState() {
    super.initState();

    _loadReports();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadReports() async {
    if (_isLoadingReports) {
      return;
    }

    setState(() {
      _isLoadingReports = true;
      _reportsError = null;
    });

    final result = await _service.getMyReports(page: 1, perPage: 50);

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoadingReports = false;

      if (result.success) {
        _reports = result.items;
      } else {
        _reportsError = result.message ?? 'Gagal memuat riwayat laporan.';
      }
    });
  }

  Future<void> _handleRefresh() async {
    await _loadReports();
  }

  Future<void> _handleSubmit() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kategori kejadian darurat'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
        ),
      );

      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final result = await _service.submit(
      emergencyType: _selectedType!,
      description: _descriptionController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;

      if (result.success) {
        _submitted = true;

        _submitMessage =
            result.message ?? 'Laporan keadaan darurat berhasil dikirim.';
      }
    });

    if (result.success) {
      await _loadReports();
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Gagal mengirim laporan.'),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _submitted = false;
      _selectedType = null;

      _descriptionController.clear();
    });
  }

  void _openHistory() {
    setState(() {
      _selectedSection = 1;
      _submitted = false;
    });

    _loadReports();
  }

  void _openForm() {
    setState(() {
      _selectedSection = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _buildSectionSelector(),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _selectedSection == 0
                    ? (_submitted ? _buildSuccessState() : _buildForm())
                    : _buildHistory(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppColors.danger,
      leading: Navigator.of(context).canPop()
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFB91C1C), Color(0xFFE02424)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.emergency_rounded,
                        color: AppColors.white,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Laporan Darurat',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RT 20 - Laporan dan penanganan keadaan darurat',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSectionButton(
              label: 'Buat Laporan',
              icon: Icons.add_alert_rounded,
              selected: _selectedSection == 0,
              onTap: _openForm,
            ),
          ),
          Expanded(
            child: _buildSectionButton(
              label: 'Riwayat',
              icon: Icons.history_rounded,
              selected: _selectedSection == 1,
              onTap: _openHistory,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionButton({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.danger : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.dangerLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.danger.withAlpha(60)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.danger,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Gunakan fitur ini hanya untuk kejadian darurat nyata di lingkungan RT 20. Laporan palsu dapat dikenai sanksi.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.danger,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Kategori Kejadian *',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 10),

        _buildCategoryGrid(),

        const SizedBox(height: 20),

        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keterangan Kejadian *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 6),

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Keterangan kejadian wajib diisi';
                  }

                  if (value.trim().length < 20) {
                    return 'Deskripsikan kejadian minimal 20 karakter';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  hintText:
                      'Jelaskan lokasi, kondisi saat ini, dan informasi penting lainnya...',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 28),

              AppButton(
                label: 'Kirim Laporan Darurat',
                onPressed: _handleSubmit,
                isLoading: _isSubmitting,
                color: AppColors.danger,
                icon: Icons.send_rounded,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    final categories = EmergencyType.values;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: categories.length,
      itemBuilder: (_, index) {
        return _buildCategoryCard(categories[index]);
      },
    );
  }

  Widget _buildCategoryCard(EmergencyType type) {
    final bool isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.dangerLight : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.danger : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.danger.withAlpha(30)
                  : Colors.black.withAlpha(5),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _categoryIcon(type),
              color: isSelected ? AppColors.danger : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              type.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.danger : AppColors.textSecondary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(EmergencyType type) {
    switch (type) {
      case EmergencyType.kebakaran:
        return Icons.local_fire_department_outlined;

      case EmergencyType.sakitKecelakaan:
        return Icons.local_hospital_outlined;

      case EmergencyType.pencurian:
        return Icons.no_encryption_gmailerrorred_outlined;

      case EmergencyType.tindakKejahatan:
        return Icons.gavel_outlined;

      case EmergencyType.kematian:
        return Icons.sentiment_very_dissatisfied_outlined;

      case EmergencyType.lainnya:
        return Icons.more_horiz_rounded;
    }
  }

  Widget _buildSuccessState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),

          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: AppColors.accentLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.accent,
              size: 56,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Laporan Terkirim',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _submitMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 28),

          AppButton(
            label: 'Lihat Status Laporan',
            onPressed: _openHistory,
            color: AppColors.primary,
            icon: Icons.history_rounded,
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: _resetForm,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Buat Laporan Baru'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    if (_isLoadingReports && _reports.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_reportsError != null && _reports.isEmpty) {
      return _buildHistoryError();
    }

    if (_reports.isEmpty) {
      return _buildEmptyHistory();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riwayat Laporan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Pantau status dan feedback Pengurus RT.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Refresh',
              onPressed: _isLoadingReports ? null : _loadReports,
              icon: _isLoadingReports
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded),
            ),
          ],
        ),

        const SizedBox(height: 16),

        ..._reports.map(_buildReportCard),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildHistoryError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 52,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 14),
            Text(
              _reportsError ?? 'Gagal memuat laporan.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _loadReports,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.history_toggle_off_rounded,
              size: 60,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Laporan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Laporan darurat yang Anda kirim akan tampil di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _openForm,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Buat Laporan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(LaporanDaruratModel report) {
    final Color statusColor = _statusColor(report.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.dangerLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _categoryIcon(report.emergencyType),
            color: AppColors.danger,
            size: 23,
          ),
        ),
        title: Text(
          report.emergencyType.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(24),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  report.statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatDateTime(report.reportedAt),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        children: [
          const Divider(height: 1),

          const SizedBox(height: 16),

          _buildDetailRow(
            icon: Icons.description_outlined,
            label: 'Keterangan',
            value: report.description,
          ),

          const SizedBox(height: 14),

          _buildDetailRow(
            icon: Icons.flag_outlined,
            label: 'Status Penanganan',
            value: report.statusLabel,
            valueColor: statusColor,
          ),

          if (report.handledByName != null) ...[
            const SizedBox(height: 14),
            _buildDetailRow(
              icon: Icons.person_outline,
              label: 'Ditangani Oleh',
              value: report.handledByName!,
            ),
          ],

          if (report.handledAt != null) ...[
            const SizedBox(height: 14),
            _buildDetailRow(
              icon: Icons.schedule_rounded,
              label: 'Mulai Ditangani',
              value: _formatDateTime(report.handledAt!),
            ),
          ],

          if (report.hasFeedback) ...[
            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 18,
                        color: Color(0xFF0369A1),
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Feedback Pengurus RT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report.feedback!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (report.hasEvidencePhoto) ...[
            const SizedBox(height: 18),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Foto Bukti Penanganan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                report.evidencePhotoUrl!,
                width: double.infinity,
                height: 210,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    alignment: Alignment.center,
                    color: AppColors.background,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Foto tidak dapat dimuat',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],

          if (report.resolvedAt != null) ...[
            const SizedBox(height: 14),

            _buildDetailRow(
              icon: Icons.check_circle_outline_rounded,
              label: 'Selesai Ditangani',
              value: _formatDateTime(report.resolvedAt!),
              valueColor: const Color(0xFF15803D),
            ),
          ],

          if (report.isArchived) ...[
            const SizedBox(height: 14),

            _buildDetailRow(
              icon: Icons.archive_outlined,
              label: 'Arsip',
              value: 'Laporan telah diarsipkan oleh Pengurus RT',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'in_progress':
        return const Color(0xFFD97706);

      case 'resolved':
        return const Color(0xFF15803D);

      case 'waiting':
      default:
        return const Color(0xFFDC2626);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();

    return DateFormat('dd/MM/yyyy HH:mm').format(local);
  }
}
