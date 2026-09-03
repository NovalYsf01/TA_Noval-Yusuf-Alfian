import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../auth/login_screen.dart';

/// Halaman profil warga.
///
/// Editable:
/// - Nama
/// - Username
/// - Email
/// - Nomor telepon
/// - Foto profil
/// - Password
///
/// Read only:
/// - Kode rumah
/// - Alamat
/// - Role / hak akses
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  final AuthService _authService = AuthService();

  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _currentPasswordController =
      TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  UserModel? _user;

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final ProfileResult result = await _profileService.getProfile();

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (!result.success || result.user == null) {
      _showMessage(result.message ?? 'Gagal memuat profil.', success: false);

      return;
    }

    _applyUser(result.user!);
  }

  void _applyUser(UserModel user) {
    setState(() {
      _user = user;

      _nameController.text = user.name;

      _usernameController.text = user.username;

      _emailController.text = user.email ?? '';

      _phoneController.text = user.phone ?? '';
    });
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    if (!_profileFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final ProfileResult result = await _profileService.updateProfile(
      name: _nameController.text,
      username: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    if (result.success && result.user != null) {
      _applyUser(result.user!);
    }

    _showMessage(
      result.message ??
          (result.success
              ? 'Profil berhasil diperbarui.'
              : 'Profil gagal diperbarui.'),
      success: result.success,
    );
  }

  Future<void> _pickAvatar() async {
    if (_isUploadingAvatar) {
      return;
    }

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final PlatformFile file = result.files.single;

      if (file.size > 2 * 1024 * 1024) {
        _showMessage('Ukuran foto profil maksimal 2 MB.', success: false);

        return;
      }

      final String? path = file.path;

      if (path == null || path.isEmpty) {
        _showMessage('File foto tidak dapat dibaca.', success: false);

        return;
      }

      setState(() {
        _isUploadingAvatar = true;
      });

      final ProfileResult uploadResult = await _profileService.updateAvatar(
        filePath: path,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isUploadingAvatar = false;
      });

      if (uploadResult.success && uploadResult.user != null) {
        _applyUser(uploadResult.user!);
      }

      _showMessage(
        uploadResult.message ??
            (uploadResult.success
                ? 'Foto profil berhasil diperbarui.'
                : 'Foto profil gagal diperbarui.'),
        success: uploadResult.success,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isUploadingAvatar = false;
      });

      _showMessage('Gagal memilih foto profil.', success: false);
    }
  }

  Future<void> _showChangePasswordDialog() async {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        bool savingPassword = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Ganti Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextField(
                        label: 'Password Saat Ini',
                        hint: 'Masukkan password saat ini',
                        controller: _currentPasswordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Password saat ini wajib diisi.';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      AppTextField(
                        label: 'Password Baru',
                        hint: 'Minimal 8 karakter',
                        controller: _newPasswordController,
                        prefixIcon: Icons.lock_reset_rounded,
                        isPassword: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Password baru wajib diisi.';
                          }

                          if (value.length < 8) {
                            return 'Password baru minimal 8 karakter.';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      AppTextField(
                        label: 'Konfirmasi Password',
                        hint: 'Ulangi password baru',
                        controller: _confirmPasswordController,
                        prefixIcon: Icons.lock_reset_rounded,
                        isPassword: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password wajib diisi.';
                          }

                          if (value != _newPasswordController.text) {
                            return 'Konfirmasi password tidak sesuai.';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: savingPassword
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop();
                        },
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: savingPassword
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          setDialogState(() {
                            savingPassword = true;
                          });

                          final ProfileResult result = await _profileService
                              .changePassword(
                                currentPassword:
                                    _currentPasswordController.text,
                                newPassword: _newPasswordController.text,
                                passwordConfirmation:
                                    _confirmPasswordController.text,
                              );

                          if (!mounted) {
                            return;
                          }

                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }

                          _showMessage(
                            result.message ??
                                (result.success
                                    ? 'Password berhasil diperbarui.'
                                    : 'Password gagal diperbarui.'),
                            success: result.success,
                          );
                        },
                  child: savingPassword
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Keluar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _authService.logout();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _showMessage(String message, {required bool success}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? AppColors.accent : AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama lengkap wajib diisi.';
    }

    return null;
  }

  String? _validateUsername(String? value) {
    final String username = value?.trim() ?? '';

    if (username.isEmpty) {
      return 'Username wajib diisi.';
    }

    if (username.length < 4) {
      return 'Username minimal 4 karakter.';
    }

    final RegExp regex = RegExp(r'^[a-zA-Z0-9_-]+$');

    if (!regex.hasMatch(username)) {
      return 'Username hanya boleh berisi huruf, angka, - dan _.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final String email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email wajib diisi.';
    }

    final RegExp regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!regex.hasMatch(email)) {
      return 'Format email tidak valid.';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    final String phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Nomor telepon wajib diisi.';
    }

    if (phone.length < 10) {
      return 'Nomor telepon tidak valid.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfile,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      child: Column(
                        children: [
                          _buildAvatarSection(),

                          const SizedBox(height: 22),

                          _buildProfileForm(),

                          const SizedBox(height: 16),

                          _buildHouseSection(),

                          const SizedBox(height: 16),

                          _buildSecuritySection(),

                          const SizedBox(height: 24),

                          AppButton(
                            label: AppStrings.keluar,
                            onPressed: _handleLogout,
                            color: AppColors.dangerLight,
                            textColor: AppColors.danger,
                            icon: Icons.logout_rounded,
                          ),
                        ],
                      ),
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
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    final String? avatarUrl = _user?.avatarUrl;

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 22),

          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildAvatarImage(avatarUrl),
              ),

              if (_isUploadingAvatar)
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0x66000000),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),

              Positioned(
                right: -3,
                bottom: -3,
                child: Material(
                  color: AppColors.primary,
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _isUploadingAvatar ? null : _pickAvatar,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.photo_camera_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            _user?.name ?? '-',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '@${_user?.username ?? '-'}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          TextButton.icon(
            onPressed: _isUploadingAvatar ? null : _pickAvatar,
            icon: const Icon(Icons.image_outlined, size: 18),
            label: const Text('Ubah Foto Profil'),
          ),

          const Text(
            'JPG, PNG atau WEBP • Maksimal 2 MB',
            style: TextStyle(fontSize: 11, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(String? avatarUrl) {
    if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
      return Image.network(
        avatarUrl,
        width: 104,
        height: 104,
        fit: BoxFit.cover,
        loadingBuilder:
            (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }

              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              );
            },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return _buildAvatarFallback();
            },
      );
    }

    return _buildAvatarFallback();
  }

  Widget _buildAvatarFallback() {
    final String initial = (_user?.name.isNotEmpty == true)
        ? _user!.name.substring(0, 1).toUpperCase()
        : 'W';

    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 38,
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return _buildCard(
      title: 'Data Profil',
      subtitle: 'Data berikut dapat diperbarui oleh warga.',
      children: [
        Form(
          key: _profileFormKey,
          child: Column(
            children: [
              AppTextField(
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap',
                controller: _nameController,
                prefixIcon: Icons.person_outline_rounded,
                keyboardType: TextInputType.name,
                validator: _validateName,
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Username',
                hint: 'Masukkan username',
                controller: _usernameController,
                prefixIcon: Icons.alternate_email_rounded,
                validator: _validateUsername,
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Email',
                hint: 'nama@email.com',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Nomor Telepon',
                hint: 'Contoh: 08123456789',
                controller: _phoneController,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),

              const SizedBox(height: 22),

              AppButton(
                label: 'Simpan Perubahan',
                icon: Icons.save_outlined,
                onPressed: _saveProfile,
                isLoading: _isSaving,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHouseSection() {
    return _buildCard(
      title: 'Data Rumah',
      subtitle:
          'Data rumah telah diverifikasi oleh Pengurus RT dan tidak dapat diubah melalui aplikasi.',
      children: [
        _readOnlyField(
          label: 'Kode Rumah',
          value: _user?.houseCode ?? '-',
          icon: Icons.cottage_outlined,
        ),

        const Divider(height: 28),

        _readOnlyField(
          label: 'Alamat',
          value: _user?.address.isNotEmpty == true ? _user!.address : '-',
          icon: Icons.home_outlined,
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildCard(
      title: 'Keamanan',
      subtitle: 'Kelola keamanan akun warga.',
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              color: AppColors.warning,
            ),
          ),
          title: const Text(
            'Ganti Password',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: const Text(
            'Masukkan password saat ini sebelum membuat password baru.',
            style: TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: _showChangePasswordDialog,
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11.5,
                height: 1.4,
                color: AppColors.textHint,
              ),
            ),
          ],

          const SizedBox(height: 18),

          ...children,
        ],
      ),
    );
  }

  Widget _readOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.textSecondary),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        const Icon(
          Icons.lock_outline_rounded,
          size: 16,
          color: AppColors.textHint,
        ),
      ],
    );
  }
}
