import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../models/laporan_darurat_model.dart';
import '../../services/laporan_darurat_service.dart';

/// M-10 Laporan Darurat
///
/// Dapat dibuka dari:
/// 1. Bottom Navigation tab (index 2) – tidak ada back button
/// 2. Home shortcut push – ada back button untuk kembali
///
/// Perilaku back button ditentukan oleh context Navigator secara otomatis.
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  EmergencyType? _selectedType;
  bool _isLoading = false;
  bool _submitted = false;
  String _submitMessage = '';

  final LaporanDaruratService _service = LaporanDaruratService();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
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

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _service.submit(
      emergencyType: _selectedType!,
      description: _descriptionController.text.trim(),
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (result.success) {
        _submitted = true;
        _submitMessage = result.message ?? 'Laporan keadaan darurat berhasil dikirim.';
      }
    });

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Gagal mengirim laporan'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _submitted = false;
      _selectedType = null;
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Deteksi apakah layar ini punya parent Navigator yang bisa di-pop
    // (dibuka via push dari Home), agar back button muncul secara otomatis.
    // Ketika menjadi tab Bottom Navigation, automaticallyImplyLeading default (true)
    // tidak akan menampilkan back button karena tidak ada route di bawahnya.
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppColors.danger,
            // Biarkan Flutter menentukan back button secara otomatis
            // berdasarkan Navigator stack.
            leading: Navigator.of(context).canPop()
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
                    onPressed: () => Navigator.of(context).pop(),
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
                            Icon(Icons.emergency_rounded, color: AppColors.white, size: 28),
                            SizedBox(width: 10),
                            Text('Laporan Darurat',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.white)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('RT 20 – Laporkan kejadian darurat di lingkungan',
                            style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(200))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _submitted ? _buildSuccessState() : _buildForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Warning notice
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
              Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Gunakan fitur ini hanya untuk kejadian darurat nyata di lingkungan RT 20. Laporan palsu dapat dikenai sanksi.',
                  style: TextStyle(fontSize: 12, color: AppColors.danger, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Pilih kategori
        const Text('Kategori Kejadian *',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        _buildCategoryGrid(),
        const SizedBox(height: 20),

        // Deskripsi
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Keterangan Kejadian *',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Keterangan kejadian wajib diisi';
                  if (v.trim().length < 20) return 'Deskripsikan kejadian minimal 20 karakter';
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Jelaskan kejadian darurat secara singkat dan jelas: lokasi, kondisi saat ini, dll...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 28),
              AppButton(
                label: 'Kirim Laporan Darurat',
                onPressed: _handleSubmit,
                isLoading: _isLoading,
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
      itemBuilder: (_, i) => _buildCategoryCard(categories[i]),
    );
  }

  Widget _buildCategoryCard(EmergencyType type) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.dangerLight : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.danger : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.danger.withAlpha(30), blurRadius: 8, offset: const Offset(0, 2))]
              : [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_categoryIcon(type),
                color: isSelected ? AppColors.danger : AppColors.textSecondary, size: 28),
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
      case EmergencyType.kebakaran: return Icons.local_fire_department_outlined;
      case EmergencyType.sakitKecelakaan: return Icons.local_hospital_outlined;
      case EmergencyType.pencurian: return Icons.no_encryption_gmailerrorred_outlined;
      case EmergencyType.tindakKejahatan: return Icons.gavel_outlined;
      case EmergencyType.kematian: return Icons.sentiment_very_dissatisfied_outlined;
      case EmergencyType.lainnya: return Icons.more_horiz_rounded;
    }
  }

  Widget _buildSuccessState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(color: AppColors.accentLight, shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 56),
          ),
          const SizedBox(height: 20),
          const Text('Laporan Terkirim',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _submitMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: _resetForm,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Buat Laporan Baru'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
