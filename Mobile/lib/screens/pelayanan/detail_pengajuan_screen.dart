import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_format_utils.dart';
import '../../models/pengajuan_pelayanan_model.dart';
import '../../services/pelayanan_service.dart';
import '../../services/api_pelayanan_service.dart';

/// M-09 Detail Pengajuan
class DetailPengajuanScreen extends StatefulWidget {
  const DetailPengajuanScreen({super.key, required this.pengajuan});

  final PengajuanPelayananModel pengajuan;

  @override
  State<DetailPengajuanScreen> createState() => _DetailPengajuanScreenState();
}

class _DetailPengajuanScreenState extends State<DetailPengajuanScreen> {
  late PengajuanPelayananModel pengajuan;
  final PelayananService _service = PelayananService();
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    pengajuan = widget.pengajuan;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    final result = await _service.getById(pengajuan.id);
    if (!mounted) return;
    if (result.success && result.item != null) {
      setState(() {
        pengajuan = result.item!;
      });
    }
  }

  Color get _statusColor {
    switch (pengajuan.status) {
      case PengajuanStatus.menungguVerifikasi: return AppColors.warning;
      case PengajuanStatus.diproses: return AppColors.primary;
      case PengajuanStatus.ditolak: return AppColors.danger;
      case PengajuanStatus.selesai: return AppColors.accent;
    }
  }

  IconData get _statusIcon {
    switch (pengajuan.status) {
      case PengajuanStatus.menungguVerifikasi: return Icons.hourglass_empty_rounded;
      case PengajuanStatus.diproses: return Icons.autorenew_rounded;
      case PengajuanStatus.ditolak: return Icons.cancel_outlined;
      case PengajuanStatus.selesai: return Icons.check_circle_outline_rounded;
    }
  }

  /// Buka dokumen PDF dari URL.
  Future<void> _openDocument(BuildContext context, String url) async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);

    try {
      final filename = 'dokumen_hasil_${pengajuan.requestNumber ?? pengajuan.id}.pdf';
      final file = await ApiPelayananService.instance.downloadResultDocument(url, filename);
      
      if (!mounted) return;
      setState(() => _isDownloading = false);

      if (file != null) {
        final result = await OpenFilex.open(file.path);
        if (!context.mounted) return;
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal membuka file: ${result.message}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengunduh dokumen. Coba lagi.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      setState(() => _isDownloading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat mengunduh dokumen.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Download lampiran yang diupload warga
  Future<void> _downloadAttachment(BuildContext context, String url) async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);

    try {
      final filename = 'lampiran_${pengajuan.requestNumber ?? pengajuan.id}.jpg';
      final file = await ApiPelayananService.instance.downloadAttachment(url, filename);
      
      if (!mounted) return;
      setState(() => _isDownloading = false);

      if (file != null) {
        final result = await OpenFilex.open(file.path);
        if (!context.mounted) return;
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal membuka file: ${result.message}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengunduh lampiran. Coba lagi.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      setState(() => _isDownloading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat mengunduh lampiran.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(pengajuan.nomorPengajuan),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            _buildStatusCard(),
            const SizedBox(height: 16),

            // Detail pengajuan
            _buildInfoCard(
              title: 'Detail Pengajuan',
              children: [
                _infoRow(label: 'Nomor', value: pengajuan.nomorPengajuan, isHighlight: true),
                _infoRow(label: 'Keperluan', value: pengajuan.purpose),
                if (pengajuan.description != null && pengajuan.description!.isNotEmpty)
                  _infoRow(label: 'Keterangan', value: pengajuan.description!),
                _infoRow(
                    label: 'Tanggal Ajuan',
                    value: DateFormatUtils.formatDateTime(pengajuan.submittedAt)),
                if (pengajuan.processedAt != null)
                  _infoRow(
                      label: 'Diproses',
                      value: DateFormatUtils.formatDateTime(pengajuan.processedAt!)),
                if (pengajuan.completedAt != null)
                  _infoRow(
                      label: 'Selesai',
                      value: DateFormatUtils.formatDateTime(pengajuan.completedAt!)),
                if (pengajuan.hasAttachment && pengajuan.attachmentDownloadUrl != null)
                  GestureDetector(
                    onTap: () => _downloadAttachment(context, pengajuan.attachmentDownloadUrl!),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 110,
                            child: Text('Lampiran',
                                style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.attach_file_rounded, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                const Expanded(
                                  child: Text(
                                    'Lihat Lampiran',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                      decoration: TextDecoration.underline,
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
              ],
            ),
            const SizedBox(height: 16),

            // Admin note (jika ditolak - tampilkan jelas)
            if (pengajuan.status == PengajuanStatus.ditolak && pengajuan.adminNote != null)
              _buildRejectionCard(),

            // Admin note lainnya
            if (pengajuan.status != PengajuanStatus.ditolak && pengajuan.adminNote != null)
              _buildAdminNoteCard(),

            // Dokumen hasil (jika selesai)
            if (pengajuan.status == PengajuanStatus.selesai)
              _buildDocumentCard(context),

            // History Timeline
            if (pengajuan.statusHistory != null && pengajuan.statusHistory!.isNotEmpty)
              _buildHistoryTimeline(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _statusColor.withAlpha(12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _statusColor.withAlpha(60)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _statusColor.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_statusIcon, color: _statusColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Status Pengajuan',
                    style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                const SizedBox(height: 4),
                Text(pengajuan.status.label,
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700, color: _statusColor)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _statusColor.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(color: _statusColor, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text(pengajuan.status.label,
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600, color: _statusColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
    bool isHighlight = false,
    IconData? icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: iconColor ?? AppColors.textSecondary),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400,
                      color: isHighlight ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionCard() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.dangerLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.danger.withAlpha(80)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.cancel_outlined, color: AppColors.danger, size: 20),
                  SizedBox(width: 8),
                  Text('Alasan Penolakan',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.danger)),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Color(0x40E02424), height: 1),
              const SizedBox(height: 10),
              Text(pengajuan.adminNote!,
                  style: const TextStyle(fontSize: 13, color: AppColors.danger, height: 1.6)),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAdminNoteCard() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withAlpha(60)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.comment_outlined, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text('Catatan Ketua RT',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Color(0x401A56DB), height: 1),
              const SizedBox(height: 10),
              Text(pengajuan.adminNote!,
                  style: const TextStyle(fontSize: 13, color: AppColors.primary, height: 1.6)),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDocumentCard(BuildContext context) {
    final hasDocument = pengajuan.resultDocumentDownloadUrl != null &&
        pengajuan.resultDocumentDownloadUrl!.isNotEmpty;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accent.withAlpha(80)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.picture_as_pdf_rounded, color: AppColors.accent, size: 20),
                  SizedBox(width: 8),
                  Text('Dokumen Hasil',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.accent)),
                ],
              ),
              const SizedBox(height: 8),
              if (hasDocument) ...[
                const Text(
                  'Dokumen Anda telah selesai diproses dan siap dibuka.',
                  style: TextStyle(fontSize: 12, color: AppColors.accent, height: 1.5),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isDownloading
                        ? null
                        : () => _openDocument(context, pengajuan.resultDocumentDownloadUrl!),
                    icon: _isDownloading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Icon(Icons.open_in_new_rounded, size: 18),
                    label: Text(_isDownloading ? 'Mengunduh...' : 'Lihat Dokumen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.white,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ] else ...[
                const Text(
                  'Pengajuan selesai diproses. Dokumen akan tersedia setelah integrasi dengan sistem backend.',
                  style: TextStyle(fontSize: 12, color: AppColors.accent, height: 1.5),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hubungi Ketua RT untuk pengambilan dokumen fisik.',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.accent,
                      fontStyle: FontStyle.italic,
                      height: 1.5),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHistoryTimeline() {
    final histories = pengajuan.statusHistory!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Riwayat Status',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 6, offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            children: List.generate(histories.length, (index) {
              final history = histories[index];
              final isLast = index == histories.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40, // Estimasi tinggi
                          color: AppColors.border,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(history.newStatusLabel,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(DateFormatUtils.formatDateTime(history.createdAt),
                              style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                          if (history.note != null && history.note!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(history.note!,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                          ],
                          if (history.changedByName != null && history.changedByName!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text('Oleh: ${history.changedByName}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
