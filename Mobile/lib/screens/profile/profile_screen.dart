import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../auth/login_screen.dart';

/// M-12 Profil Screen
///
/// READ ONLY: Nama, Alamat, Username
/// EDITABLE: Nomor Telepon, Email, Password
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = true;
  bool _isSaving = false;

  final _contactFormKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  late TextEditingController _currentPwController;
  late TextEditingController _newPwController;
  late TextEditingController _confirmPwController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _currentPwController = TextEditingController();
    _newPwController = TextEditingController();
    _confirmPwController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _currentPwController.dispose();
    _newPwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final result = await _profileService.getProfile();
    if (mounted && result.success && result.user != null) {
      setState(() {
        _user = result.user;
        _phoneController.text = result.user!.phone ?? '';
        _emailController.text = result.user!.email ?? '';
        _isLoading = false;
      });
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
        // Tampilkan pesan error jika gagal memuat profil
        if (result.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message!),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _saveContact() async {
    // Validasi form sebelum menyimpan
    if (!_contactFormKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final result = await _profileService.updateContact(
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Selesai'),
        backgroundColor: result.success ? AppColors.accent : AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (result.success) {
      if (result.user != null) {
        // Gunakan user dari response PATCH jika tersedia
        setState(() => _user = result.user);
      } else {
        // Fallback: refresh dari backend untuk data terbaru
        await _loadProfile();
      }
    }
  }

  Future<void> _showChangePasswordDialog() async {
    _currentPwController.clear();
    _newPwController.clear();
    _confirmPwController.clear();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Ganti Password',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: 'Password Lama',
                hint: 'Masukkan password lama',
                controller: _currentPwController,
                isPassword: true,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Password Baru',
                hint: 'Min. 8 karakter',
                controller: _newPwController,
                isPassword: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password baru tidak boleh kosong';
                  if (v.length < 8) return 'Min. 8 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Konfirmasi Password',
                hint: 'Ulangi password baru',
                controller: _confirmPwController,
                isPassword: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Konfirmasi password tidak boleh kosong';
                  if (v != _newPwController.text) return 'Password tidak cocok';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              
              // Simpan nilai teks sebelum dialog ditutup
              final currentPw = _currentPwController.text;
              final newPw = _newPwController.text;
              final confirmPw = _confirmPwController.text;

              Navigator.pop(ctx);
              final result = await _profileService.changePassword(
                currentPassword: currentPw,
                newPassword: newPw,
                passwordConfirmation: confirmPw,
              );
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result.message ?? 'Selesai'),
                  backgroundColor:
                      result.success ? AppColors.accent : AppColors.danger,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              minimumSize: Size.zero,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAvatarSection(),
                        const SizedBox(height: 24),
                        _buildReadOnlySection(),
                        const SizedBox(height: 16),
                        _buildEditableSection(),
                        const SizedBox(height: 16),
                        _buildSecuritySection(),
                        const SizedBox(height: 24),
                        _buildLogoutButton(),
                      ],
                    ),
                  ),
                ),
              ],
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
          AppStrings.profil,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(60),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    (_user?.name.isNotEmpty == true)
                        ? _user!.name[0].toUpperCase()
                        : 'W',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _user?.name ?? '-',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '@${_user?.username ?? ''}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlySection() {
    return _buildCard(
      title: 'Data Warga',
      subtitle: AppStrings.readOnlyInfo,
      subtitleIcon: Icons.lock_outline_rounded,
      children: [
        _readOnlyField(
          label: AppStrings.nama,
          value: _user?.name ?? '-',
          icon: Icons.person_outline_rounded,
        ),
        const Divider(height: 24),
        _readOnlyField(
          label: 'Username',
          value: _user?.username ?? '-',
          icon: Icons.alternate_email_rounded,
        ),
        const Divider(height: 24),
        _readOnlyField(
          label: 'Kode Rumah',
          value: _user?.houseCode ?? '-',
          icon: Icons.cottage_outlined,
        ),
        const Divider(height: 24),
        _readOnlyField(
          label: AppStrings.alamat,
          value: _user?.address ?? '-',
          icon: Icons.home_outlined,
        ),
      ],
    );
  }

  Widget _buildEditableSection() {
    return _buildCard(
      title: 'Kontak',
      children: [
        Form(
          key: _contactFormKey,
          child: Column(
            children: [
              AppTextField(
                label: AppStrings.nomorTelepon,
                hint: 'Contoh: 08123456789',
                controller: _phoneController,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: AppStrings.email,
                hint: 'Contoh: nama@email.com',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  final emailRegex = RegExp(r'^[\w\-\.]+@[\w\-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(v.trim())) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppButton(
          label: AppStrings.simpan,
          onPressed: _saveContact,
          isLoading: _isSaving,
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildCard(
      title: 'Keamanan',
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              color: AppColors.warning,
              size: 22,
            ),
          ),
          title: const Text(
            AppStrings.gantiPassword,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          subtitle: const Text(
            'Perbarui password secara berkala',
            style: TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textHint,
          ),
          onTap: _showChangePasswordDialog,
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return AppButton(
      label: AppStrings.keluar,
      onPressed: _handleLogout,
      color: AppColors.dangerLight,
      textColor: AppColors.danger,
      icon: Icons.logout_rounded,
    );
  }

  Widget _buildCard({
    required String title,
    String? subtitle,
    IconData? subtitleIcon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (subtitleIcon != null)
                    Icon(subtitleIcon, size: 13, color: AppColors.textHint),
                  if (subtitleIcon != null) const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textHint,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _readOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.textSecondary),
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
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
