import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../services/pelayanan_service.dart';
import 'riwayat_pengajuan_screen.dart';

/// M-07 Ajukan Pelayanan Administrasi
class AjukanPelayananScreen extends StatefulWidget {
  const AjukanPelayananScreen({super.key});

  @override
  State<AjukanPelayananScreen> createState() => _AjukanPelayananScreenState();
}

class _AjukanPelayananScreenState extends State<AjukanPelayananScreen> {
  final _formKey = GlobalKey<FormState>();
  final _purposeController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  String? _attachmentName;
  String? _attachmentPath;

  final PelayananService _service = PelayananService();

  /// Ukuran maksimal lampiran: 5 MB
  static const int _maxFileSizeBytes = 5 * 1024 * 1024;

  /// Ekstensi yang diizinkan
  static const List<String> _allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

  @override
  void dispose() {
    _purposeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Validasi ukuran file
        final filePath = file.path;
        if (filePath != null) {
          final fileSize = File(filePath).lengthSync();
          if (fileSize > _maxFileSizeBytes) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ukuran file terlalu besar. Maksimal 5 MB.'),
                  backgroundColor: AppColors.danger,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            return;
          }
        }

        setState(() {
          _attachmentName = file.name;
          _attachmentPath = filePath;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Gagal memilih file'),
              behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  void _removeAttachment() {
    setState(() {
      _attachmentName = null;
      _attachmentPath = null;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _service.submit(
      purpose: _purposeController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      // attachmentPath disiapkan untuk multipart upload saat API tersedia.
      // TODO: API INTEGRATION – kirim sebagai multipart/form-data ke POST /api/v1/pelayanan
      attachmentPath: _attachmentPath,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      await _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Gagal mengirim pengajuan'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.accentLight,
              child: Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 44),
            ),
            SizedBox(height: 16),
            Text(
              'Pengajuan Terkirim!',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8),
            Text(
              'Pengajuan Anda berhasil dikirim dan sedang menunggu verifikasi dari Ketua RT.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RiwayatPengajuanScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Lihat Status'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ajukan Pelayanan'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Isi formulir pengajuan pelayanan administrasi RT 20. Pengajuan akan diproses oleh Ketua RT.',
                          style: TextStyle(fontSize: 12, color: AppColors.primary, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Form fields
                AppTextField(
                  label: 'Keperluan Pelayanan *',
                  hint: 'Contoh: Surat Keterangan Domisili untuk...',
                  controller: _purposeController,
                  prefixIcon: Icons.description_outlined,
                  maxLines: 3,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Keperluan pelayanan wajib diisi';
                    if (v.trim().length < 10) return 'Minimal 10 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Keterangan Tambahan (Opsional)',
                  hint: 'Informasi tambahan yang perlu diketahui Ketua RT...',
                  controller: _descriptionController,
                  prefixIcon: Icons.notes_outlined,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),

                // Attachment section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lampiran (Opsional)',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Format: PDF, JPG, JPEG, PNG · Maks. 5 MB',
                      style: TextStyle(fontSize: 11, color: AppColors.textHint),
                    ),
                    const SizedBox(height: 8),
                    if (_attachmentName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.accentLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.accent.withAlpha(80)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_file_rounded,
                                color: AppColors.accent, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _attachmentName!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            GestureDetector(
                              onTap: _removeAttachment,
                              child: const Icon(Icons.close_rounded,
                                  color: AppColors.accent, size: 20),
                            ),
                          ],
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: _pickFile,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.border,
                                width: 1.5,
                                style: BorderStyle.solid),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.cloud_upload_outlined,
                                  size: 36, color: AppColors.textHint),
                              SizedBox(height: 8),
                              Text(
                                'Ketuk untuk memilih file',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'PDF, JPG, JPEG, PNG (maks. 5 MB)',
                                style: TextStyle(
                                    fontSize: 11, color: AppColors.textHint),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Kirim Pengajuan',
                  onPressed: _handleSubmit,
                  isLoading: _isLoading,
                  icon: Icons.send_rounded,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
