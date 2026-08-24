import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_format_utils.dart';
import '../../models/informasi_model.dart';
import '../../services/informasi_service.dart';

/// M-05 Detail Informasi RT
class DetailInformasiScreen extends StatefulWidget {
  const DetailInformasiScreen({super.key, required this.informasi});

  final InformasiModel informasi;

  @override
  State<DetailInformasiScreen> createState() => _DetailInformasiScreenState();
}

class _DetailInformasiScreenState extends State<DetailInformasiScreen> {
  final InformasiService _service = InformasiService();
  
  late InformasiModel _info;

  @override
  void initState() {
    super.initState();
    _info = widget.informasi; // Tampilkan data awal (preview) sambil loading detail
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    // Tetap tampilkan UI menggunakan data awal (_info), tapi munculkan indikator loading jika perlu
    // Untuk skenario ini, kita update secara silent di background atau tampilkan loading kecil.
    // Karena instruksi meminta kita load detail, kita fetch dari API.
    try {
      final detail = await _service.getById(_info.id);
      if (!mounted) return;
      
      if (detail != null) {
        setState(() {
          _info = detail;
        });
      }
    } catch (e) {
      // Abaikan error, tetap tampilkan preview
    }
  }

  Color get _categoryColor {
    switch (_info.categoryDisplay) {
      case 'Pengumuman': return AppColors.primary;
      case 'Keuangan': return AppColors.accent;
      case 'Kesehatan': return const Color(0xFF0E9F6E);
      case 'Kegiatan': return const Color(0xFF7C3AED);
      case 'Keamanan': return AppColors.danger;
      case 'Sosial': return AppColors.warning;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar dengan gradient
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.headerGradient),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _info.categoryDisplay,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _info.title,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _categoryColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.label_outline_rounded, size: 14, color: _categoryColor),
                              const SizedBox(width: 4),
                              Text(_info.categoryDisplay,
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _categoryColor)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(DateFormatUtils.formatDateLong(_info.publishedAt),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Image
                  if (_info.imageUrl != null && _info.imageUrl!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: _info.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 200,
                          color: AppColors.background,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          color: AppColors.background,
                          child: const Center(
                            child: Icon(Icons.broken_image_outlined, size: 48, color: AppColors.textHint),
                          ),
                        ),
                      ),
                    ),
                  // Content card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      _info.contentPlainText, // Gunakan plain text di detail karena HTML mentah terlihat buruk tanpa renderer
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        height: 1.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
