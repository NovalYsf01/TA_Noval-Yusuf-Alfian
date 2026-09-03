import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../navigation/main_navigation.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';

/// M-02 Login Screen
///
/// Login warga menggunakan username dan password.
///
/// Warga yang belum memiliki akun dapat melakukan registrasi
/// melalui aplikasi mobile. Akun yang baru didaftarkan harus
/// diverifikasi terlebih dahulu oleh Pengurus RT.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _authService.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );

      return;
    }

    setState(() {
      _errorMessage = result.message ?? AppStrings.errorLogin;
    });
  }

  Future<void> _openRegister() async {
    FocusScope.of(context).unfocus();

    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(size),

                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _buildFormCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      height: size.height * 0.35,
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withAlpha(50),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.location_city_rounded,
                size: 44,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              AppStrings.appSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          const Text(
            'Masuk ke Akun Anda',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Masukkan username dan password akun warga Anda.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),

          const SizedBox(height: 28),

          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: AppStrings.username,
                  hint: AppStrings.usernameHint,
                  controller: _usernameController,
                  prefixIcon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.text,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.errorUsernameEmpty;
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                AppTextField(
                  label: AppStrings.password,
                  hint: AppStrings.passwordHint,
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.errorPasswordEmpty;
                    }

                    return null;
                  },
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorMessage(),
                ],

                const SizedBox(height: 24),

                AppButton(
                  label: AppStrings.login,
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum memiliki akun?',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    TextButton(
                      onPressed: _isLoading ? null : _openRegister,
                      child: const Text(
                        'Daftar',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _buildAccountInformation(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.dangerLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.danger,
            size: 18,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: AppColors.danger,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInformation() {
    return Container(
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
              'Belum memiliki akun? Silakan lakukan registrasi melalui aplikasi. '
              'Setelah mendaftar, akun akan diperiksa dan diverifikasi oleh Pengurus RT.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
