import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/presentation/blocs/auth/auth_cubit.dart';
import 'package:nexust/presentation/blocs/auth/auth_state.dart';
import 'package:nexust/presentation/widgets/auth/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = "edit_profile";
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _imageChanged = false;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (!kDebugMode) return;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Opcional: recortar la imagen
      final croppedFile = await _cropImage(image.path);

      if (croppedFile != null) {
        setState(() {
          _imageBytes = croppedFile;
          _imageChanged = true;
        });
      }
    }
  }

  Future<Uint8List?> _cropImage(String sourcePath) async {
    final cropper = ImageCropper();
    final croppedFile = await cropper.cropImage(
      sourcePath: sourcePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: context.tr('edit_profile.crop_image'),
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: context.tr('edit_profile.crop_image'),
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );

    if (croppedFile != null) {
      return await croppedFile.readAsBytes();
    }

    return null;
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final authCubit = context.read<AuthCubit>();

      // Primero actualizar la imagen si cambió
      if (_imageChanged && _imageBytes != null) {
        await authCubit.uploadProfileImage(_imageBytes!);
      }

      // Actualizar el nombre si cambió
      if (name != FirebaseAuth.instance.currentUser?.displayName) {
        await authCubit.updateDisplayName(name);
      }

      if (mounted) {
        Navigator.pop(context);
        Toast.show(context.tr('edit_profile.profile_updated'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          Toast.show(state.errorMessage ?? context.tr('auth.errors.generic'));
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              context.tr('edit_profile.title'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            actions: [
              // Botón de guardar
              IconButton(
                icon: Icon(FontAwesomeIcons.lightFloppyDisk),
                onPressed: isLoading ? null : _saveProfile,
                tooltip: context.tr('common.save'),
              ),
            ],
          ),
          body:
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Foto de perfil
                          GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              children: [
                                // Avatar
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: theme.primaryColor
                                      .withOpacity(0.1),
                                  backgroundImage:
                                      _imageChanged && _imageBytes != null
                                          ? MemoryImage(_imageBytes!)
                                              as ImageProvider
                                          : user?.photoURL != null
                                          ? NetworkImage(user!.photoURL!)
                                              as ImageProvider
                                          : null,
                                  child:
                                      (_imageChanged && _imageBytes != null) ||
                                              user?.photoURL != null
                                          ? null
                                          : Icon(
                                            FontAwesomeIcons.lightUser,
                                            size: context.scaleIcon(50),
                                            color: theme.primaryColor,
                                          ),
                                ),

                                // Icono de cámara superpuesto
                                if (kDebugMode)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            isDark
                                                ? Colors.black
                                                : Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.lightCamera,
                                      size: context.scaleIcon(16),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Campo de nombre
                          CustomTextField(
                            controller: _nameController,
                            label: context.tr('edit_profile.name'),
                            hint: context.tr('edit_profile.name_hint'),
                            prefixIcon: FontAwesomeIcons.lightUser,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.tr('edit_profile.name_required');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Correo electrónico (no editable)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  isDark ? Colors.black12 : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade300,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr('edit_profile.email'),
                                  style: TextStyle(
                                    fontSize: context.scaleText(14),
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isDark
                                            ? Colors.grey.shade300
                                            : Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.lightEnvelope,
                                      size: context.scaleIcon(16),
                                      color:
                                          isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        user?.email ?? '',
                                        style: TextStyle(
                                          fontSize: context.scaleText(16),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.lightLock,
                                      size: context.scaleIcon(16),
                                      color:
                                          isDark
                                              ? Colors.grey.shade600
                                              : Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.tr('edit_profile.email_not_editable'),
                                  style: TextStyle(
                                    fontSize: context.scaleText(12),
                                    color:
                                        isDark
                                            ? Colors.grey.shade500
                                            : Colors.grey.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Botón de guardar
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child:
                                  isLoading
                                      ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        context.tr('edit_profile.save_button'),
                                        style: TextStyle(
                                          fontSize: context.scaleText(16),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        );
      },
    );
  }
}
