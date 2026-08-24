import 'dart:io';
import '../core/network/api_client.dart';
import '../models/pengajuan_pelayanan_model.dart';
import 'pelayanan_service.dart';
import 'package:path_provider/path_provider.dart';

/// Implementasi API nyata untuk pelayanan administrasi.
class ApiPelayananService implements PelayananService {
  ApiPelayananService._internal();
  static final ApiPelayananService _instance = ApiPelayananService._internal();
  static ApiPelayananService get instance => _instance;

  final ApiClient _api = ApiClient.instance;

  @override
  Future<PengajuanResult> getAll() async {
    try {
      final response = await _api.get('/pelayanan');
      final dataList = response['data'] as List?;
      if (dataList != null) {
        final List<PengajuanPelayananModel> pelayanans = dataList
            .whereType<Map<String, dynamic>>()
            .map((json) => PengajuanPelayananModel.fromJson(json))
            .toList();
        return PengajuanResult(success: true, data: pelayanans);
      }
      return const PengajuanResult(
          success: false, message: 'Format respons tidak valid');
    } on ApiException catch (e) {
      return PengajuanResult(success: false, message: e.message);
    } catch (e) {
      return const PengajuanResult(
          success: false, message: 'Terjadi kesalahan saat memuat data');
    }
  }

  @override
  Future<PengajuanResult> getById(int id) async {
    try {
      final response = await _api.get('/pelayanan/$id');
      final data = response['data'] as Map<String, dynamic>?;
      if (data != null) {
        final item = PengajuanPelayananModel.fromJson(data);
        return PengajuanResult(success: true, item: item);
      }
      return const PengajuanResult(
          success: false, message: 'Detail pengajuan tidak ditemukan');
    } on ApiException catch (e) {
      return PengajuanResult(success: false, message: e.message);
    } catch (e) {
      return const PengajuanResult(
          success: false, message: 'Terjadi kesalahan saat memuat detail');
    }
  }

  @override
  Future<PengajuanResult> submit({
    required String purpose,
    String? description,
    String? attachmentPath,
  }) async {
    try {
      final fields = <String, String>{
        'purpose': purpose,
      };
      if (description != null && description.isNotEmpty) {
        fields['description'] = description;
      }

      final response = await _api.postMultipart(
        '/pelayanan',
        fields: fields,
        fileField: 'attachment',
        filePath: attachmentPath,
      );

      final data = response['data'] as Map<String, dynamic>?;
      if (data != null) {
        final item = PengajuanPelayananModel.fromJson(data);
        return PengajuanResult(
            success: true, item: item, message: 'Pengajuan berhasil dikirim');
      }
      return const PengajuanResult(
          success: false, message: 'Gagal memproses respons server');
    } on ApiException catch (e) {
      return PengajuanResult(success: false, message: e.message);
    } catch (e) {
      return const PengajuanResult(
          success: false, message: 'Terjadi kesalahan saat mengirim pengajuan');
    }
  }

  /// Mengunduh dokumen hasil PDF dan menyimpannya di device.
  Future<File?> downloadResultDocument(String url, String filename) async {
    try {
      final dir = await getTemporaryDirectory();
      final savePath = '${dir.path}/$filename';

      final uri = Uri.tryParse(url);
      if (uri == null) return null;
      
      final pathWithQuery = uri.hasQuery ? '${uri.path}?${uri.query}' : uri.path;
      final apiPrefix = '/api/v1';
      String apiPath = pathWithQuery;
      if (pathWithQuery.contains(apiPrefix)) {
        apiPath = pathWithQuery.substring(pathWithQuery.indexOf(apiPrefix) + apiPrefix.length);
      }

      final file = await _api.downloadFile(apiPath, savePath: savePath);
      return file;
    } catch (e) {
      return null;
    }
  }

  /// Mengunduh lampiran pengajuan dan menyimpannya di device.
  Future<File?> downloadAttachment(String url, String filename) async {
    try {
      final dir = await getTemporaryDirectory();
      final savePath = '${dir.path}/$filename';

      final uri = Uri.tryParse(url);
      if (uri == null) return null;
      
      final pathWithQuery = uri.hasQuery ? '${uri.path}?${uri.query}' : uri.path;
      final apiPrefix = '/api/v1';
      String apiPath = pathWithQuery;
      if (pathWithQuery.contains(apiPrefix)) {
        apiPath = pathWithQuery.substring(pathWithQuery.indexOf(apiPrefix) + apiPrefix.length);
      }

      final file = await _api.downloadFile(apiPath, savePath: savePath);
      return file;
    } catch (e) {
      return null;
    }
  }
}
