import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/view_state.dart';
import '../../core/utils/date_format_utils.dart';
import '../../models/informasi_model.dart';
import '../../services/informasi_service.dart';
import 'detail_informasi_screen.dart';

/// M-04 Informasi RT
class InformasiScreen extends StatefulWidget {
  const InformasiScreen({super.key});

  @override
  State<InformasiScreen> createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  final InformasiService _service = InformasiService();
  ViewState _viewState = ViewState.loading;
  List<InformasiModel> _list = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _viewState = ViewState.loading);
    final result = await _service.getAll();
    if (!mounted) return;
    if (result.success && result.data != null) {
      setState(() {
        _list = result.data!;
        _viewState = _list.isEmpty ? ViewState.empty : ViewState.loaded;
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
      appBar: AppBar(
        title: const Text('Informasi RT'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_viewState) {
      case ViewState.loading:
        return _buildShimmer();
      case ViewState.empty:
        return _buildEmpty();
      case ViewState.error:
        return _buildError();
      case ViewState.loaded:
        return _buildList();
    }
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, i) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.article_outlined, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          const Text('Belum Ada Informasi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Informasi dari RT 20 akan muncul di sini',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: AppColors.textHint),
            const SizedBox(height: 16),
            const Text('Gagal Memuat Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(_errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _list.length,
      itemBuilder: (_, i) => _buildCard(_list[i]),
    );
  }

  Widget _buildCard(InformasiModel info) {
    final categoryColor = _categoryColor(info.categoryDisplay);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailInformasiScreen(informasi: info)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: categoryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(info.categoryDisplay,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: categoryColor)),
                  ),
                  const Spacer(),
                  Text(DateFormatUtils.timeAgo(info.publishedAt),
                      style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                ],
              ),
              const SizedBox(height: 8),
              Text(info.title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              if (info.imageUrl != null && info.imageUrl!.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 140,
                  margin: const EdgeInsets.only(bottom: 8),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: info.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: AppColors.background, child: const Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Container(color: AppColors.background, child: const Center(child: Icon(Icons.broken_image_outlined, color: AppColors.textHint))),
                  ),
                ),
              Text(info.contentPreview,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(DateFormatUtils.formatDate(info.publishedAt),
                      style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  const Spacer(),
                  const Text('Selengkapnya →',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary)),
                ],
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
}
