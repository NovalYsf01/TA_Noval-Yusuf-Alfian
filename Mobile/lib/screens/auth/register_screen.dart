import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../services/registration_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _houseCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  final RegistrationService _registrationService = RegistrationService.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _houseCodeController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
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

    final result = await _registrationService.register(
      name: _nameController.text,
      email: _emailController.text,
      username: _usernameController.text,
      houseCode: _houseCodeController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      passwordConfirmation: _passwordConfirmationController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!result.success) {
      setState(() {
        _errorMessage = result.message;
      });

      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.hourglass_top_rounded,
            color: AppColors.primary,
            size: 42,
          ),
          title: const Text('Registrasi Berhasil', textAlign: TextAlign.center),
          content: Text(result.message, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Kembali ke Login'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Registrasi Warga'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Setiap rumah hanya dapat memiliki satu akun. '
                            'Setelah registrasi, akun harus diverifikasi '
                            'terlebih dahulu oleh Pengurus RT sebelum '
                            'dapat digunakan untuk login.',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Data Warga',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Isi data sesuai dengan data rumah Anda.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  AppTextField(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama lengkap',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama lengkap wajib diisi.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Email',
                    hint: 'contoh@email.com',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final email = value?.trim() ?? '';

                      if (email.isEmpty) {
                        return 'Email wajib diisi.';
                      }

                      if (!email.contains('@') || !email.contains('.')) {
                        return 'Format email tidak valid.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Username',
                    hint: 'Contoh: warga05',
                    controller: _usernameController,
                    prefixIcon: Icons.account_circle_outlined,
                    validator: (value) {
                      final username = value?.trim() ?? '';

                      if (username.isEmpty) {
                        return 'Username wajib diisi.';
                      }

                      if (username.length < 4) {
                        return 'Username minimal 4 karakter.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Kode Rumah',
                    hint: 'Contoh: A05',
                    controller: _houseCodeController,
                    prefixIcon: Icons.home_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kode rumah wajib diisi.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Alamat',
                    hint: 'Masukkan alamat rumah',
                    controller: _addressController,
                    prefixIcon: Icons.location_on_outlined,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Alamat wajib diisi.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Nomor Telepon',
                    hint: 'Contoh: 081234567890',
                    controller: _phoneController,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nomor telepon wajib diisi.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Keamanan Akun',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Password',
                    hint: 'Minimal 8 karakter',
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi.';
                      }

                      if (value.length < 8) {
                        return 'Password minimal 8 karakter.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Konfirmasi Password',
                    hint: 'Masukkan kembali password',
                    controller: _passwordConfirmationController,
                    prefixIcon: Icons.lock_reset_rounded,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi password wajib diisi.';
                      }

                      if (value != _passwordController.text) {
                        return 'Konfirmasi password tidak sesuai.';
                      }

                      return null;
                    },
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
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
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: AppColors.danger,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  AppButton(
                    label: 'Daftar Akun',
                    icon: Icons.person_add_alt_1_rounded,
                    onPressed: _register,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      child: const Text('Sudah memiliki akun? Masuk'),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
