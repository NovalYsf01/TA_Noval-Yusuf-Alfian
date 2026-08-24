import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/view_state.dart';
import '../../models/nomor_penting_model.dart';
import '../../services/nomor_penting_service.dart';

/// M-11 Nomor Penting
class NomorPentingScreen extends StatefulWidget {
  const NomorPentingScreen({super.key});

  @override
  State<NomorPentingScreen> createState() => _NomorPentingScreenState();
}

class _NomorPentingScreenState extends State<NomorPentingScreen> {
  final NomorPentingService _service = NomorPentingService();
  ViewState _viewState = ViewState.loading;
  List<NomorPentingModel> _list = [];
  Map<String, List<NomorPentingModel>> _grouped = {};
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
        _grouped = _groupByCategory(_list);
        _viewState = _list.isEmpty ? ViewState.empty : ViewState.loaded;
      });
    } else {
      setState(() {
        _errorMessage = result.message ?? 'Gagal memuat data';
        _viewState = ViewState.error;
      });
    }
  }

  Map<String, List<NomorPentingModel>> _groupByCategory(List<NomorPentingModel> list) {
    final Map<String, List<NomorPentingModel>> grouped = {};
    for (final item in list) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    return grouped;
  }

  Future<void> _callNumber(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tidak dapat membuka dialer untuk $phone'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka dialer'), behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nomor Penting'),
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
        return _buildGroupedList();
    }
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, i) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 76,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text('Belum ada nomor penting', style: TextStyle(color: AppColors.textSecondary)),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 56, color: AppColors.textHint),
          const SizedBox(height: 16),
          const Text('Gagal Memuat Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(_errorMessage, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: _grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryHeader(entry.key),
            const SizedBox(height: 8),
            ...entry.value.map((item) => _buildContactCard(item)),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCategoryHeader(String category) {
    final color = _categoryColor(category);
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(8)),
          child: Icon(_categoryIcon(category), size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Text(category,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _buildContactCard(NomorPentingModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _categoryColor(item.category).withAlpha(18),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(_categoryIcon(item.category), color: _categoryColor(item.category), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(item.phoneNumber,
                    style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
                if (item.description != null) ...[
                  const SizedBox(height: 3),
                  Text(item.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _callNumber(context, item.phoneNumber),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: AppColors.accent.withAlpha(60), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: const Icon(Icons.phone_rounded, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'RT': return AppColors.primary;
      case 'Keamanan': return AppColors.danger;
      case 'Kesehatan': return AppColors.accent;
      case 'Darurat': return const Color(0xFFE02424);
      case 'Utilitas': return AppColors.warning;
      default: return AppColors.textSecondary;
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'RT': return Icons.home_work_outlined;
      case 'Keamanan': return Icons.shield_outlined;
      case 'Kesehatan': return Icons.health_and_safety_outlined;
      case 'Darurat': return Icons.local_fire_department_outlined;
      case 'Utilitas': return Icons.electrical_services_outlined;
      default: return Icons.phone_outlined;
    }
  }
}
