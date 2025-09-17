import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/helper/date_formatter.dart';
import 'package:abstrak/main.dart';
import 'package:abstrak/widgets/x_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const Color primaryCyan = Color(0xFF00bcd5);

  @override
  void initState() {
    super.initState();
    userNotifier.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? const EdgeInsets.all(16)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .2,
              vertical: 32,
            ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryCyan),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                child: Column(
                  children: [
                    // Avatar
                    GestureDetector(
                      onTap: () => _handleChangeAvatar(),
                      child: Badge(
                        padding: const EdgeInsets.all(2),
                        alignment: Alignment.topRight,
                        backgroundColor: primaryCyan,
                        label: Icon(Icons.edit),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF00bcd5),
                              width: 2,
                            ),
                            color: Colors.black,
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: userNotifier.user,
                            builder: (context, user, child) {
                              final data = user.data?.data;
                              if (user.status == ApiStatus.loading) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF00bcd5),
                                  ),
                                );
                              }

                              if (user.status == ApiStatus.error) {
                                return const Icon(
                                  Icons.error,
                                  size: 50,
                                  color: Colors.red,
                                );
                              }

                              if ((data?.avatar ?? '').isNotEmpty) {
                                return ClipOval(
                                  child: Image.network(
                                    data?.avatar ?? '',
                                    filterQuality: FilterQuality.high,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }

                              return const Icon(
                                Icons.person,
                                size: 50,
                                color: Color(0xFF00bcd5),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Welcome Message
                    ValueListenableBuilder(
                      valueListenable: userNotifier.user,
                      builder: (context, value, child) {
                        final data = value.data?.data;
                        return Column(
                          children: [
                            Text(
                              (data?.name ?? 'User').toUpperCase(),
                              style: customTextTheme.displayMedium?.copyWith(
                                fontSize:
                                    ResponsiveBreakpoints.of(context).isDesktop
                                        ? 48
                                        : 36,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              (data?.email ?? 'User').toUpperCase(),
                              style: courierText.bodyMedium,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome to CAPTIVE',
                      style: customTextTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF00bcd5),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Profile Information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACCOUNT INFORMATION',
                      style: customTextTheme.titleLarge?.copyWith(
                        fontFamily: 'Kenzo',
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: userNotifier.user,
                      builder: (context, value, child) {
                        final data = value.data?.data;
                        return _buildInfoRow(
                            'RANK', (data?.roles ?? 'USER').toUpperCase());
                      },
                    ),
                    const SizedBox(height: 12),
                    ValueListenableBuilder(
                      valueListenable: userNotifier.user,
                      builder: (context, value, child) {
                        final data = value.data?.data;
                        return _buildInfoRow('PHONE', _formatPhoneNumber(data?.phone ?? 'Unknown'));
                      },
                    ),
                    const SizedBox(height: 12),
                    ValueListenableBuilder(
                      valueListenable: userNotifier.user,
                      builder: (context, value, child) {
                        final data = value.data?.data;
                        return _buildInfoRow(
                            'JOINED',
                            DateFormatterHelper.formatDate(
                                data?.createdAt ?? ''));
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('GUILD POINTS', '1,337'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'QUICK ACTIONS',
                style: customTextTheme.titleLarge?.copyWith(
                  fontFamily: 'Kenzo',
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: userNotifier.user,
                    builder: (context, value, child) {
                      final data = value.data?.data;
                      if (data?.roles != 'admin') {
                        return const SizedBox.shrink();
                      }
                      return XButton(
                        text: 'ADMIN',
                        textStyle: customTextTheme.titleSmall?.copyWith(
                          fontFamily: 'Kenzo',
                        ),
                        borderColor: Colors.orangeAccent,
                        onPressed: () {
                          context.goNamed('admin');
                        },
                      );
                    },
                  ),
                  XButton(
                    text: 'MY ARTWERKS',
                    textStyle: customTextTheme.titleSmall?.copyWith(
                      fontFamily: 'Kenzo',
                    ),
                    borderColor: const Color.fromARGB(255, 3, 199, 19),
                    onPressed: () {
                      context.goNamed('my-artwerks');
                    },
                  ),
                  XButton(
                    text: 'EDIT PROFILE',
                    textStyle: customTextTheme.titleSmall?.copyWith(
                      fontFamily: 'Kenzo',
                    ),
                    borderColor: const Color(0xFF00bcd5),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Edit profile functionality coming soon!'),
                          backgroundColor: Color(0xFF00bcd5),
                        ),
                      );
                    },
                  ),
                  XButton(
                    text: 'SETTINGS',
                    textStyle: customTextTheme.titleSmall?.copyWith(
                      fontFamily: 'Kenzo',
                    ),
                    borderColor: Colors.grey,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings functionality coming soon!'),
                          backgroundColor: Colors.grey,
                        ),
                      );
                    },
                  ),
                  XButton(
                    text: 'SIGN OUT',
                    textStyle: customTextTheme.titleSmall?.copyWith(
                      fontFamily: 'Kenzo',
                    ),
                    borderColor: Colors.red,
                    onPressed: () {
                      _showSignOutDialog(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Guild Activities
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECENT ACTIVITIES',
                      style: customTextTheme.titleLarge?.copyWith(
                        fontFamily: 'Kenzo',
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildActivityItem(
                        'Participated in guild war', '2 hours ago'),
                    _buildActivityItem('Completed TP calculation', '1 day ago'),
                    _buildActivityItem('Viewed artwork gallery', '3 days ago'),
                    _buildActivityItem('Joined CAPTIVE guild', '1 week ago'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: courierText.bodyMedium?.copyWith(
            color: Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: courierText.bodyMedium?.copyWith(
            color: const Color(0xFF00bcd5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatPhoneNumber(String phone) {
    if (phone == 'Unknown') return phone;
    if (phone.startsWith('0')) {
      phone = phone.replaceFirst('0', '');
    }
    return '+62$phone';
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00bcd5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity,
              style: courierText.bodyMedium,
            ),
          ),
          Text(
            time,
            style: courierText.bodySmall?.copyWith(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white),
          ),
          title: Text(
            'SIGN OUT',
            style: customTextTheme.titleLarge?.copyWith(
              fontFamily: 'Kenzo',
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: courierText.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'CANCEL',
                style: customTextTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await authNotifier.signOut();
                Navigator.of(context).pop();
                context.goNamed('home');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully signed out'),
                    backgroundColor: Color(0xFF00bcd5),
                  ),
                );
              },
              child: Text(
                'SIGN OUT',
                style: customTextTheme.bodyMedium?.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleChangeAvatar() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );

      if (result != null) {
        // Handle the selected file
        PlatformFile file = result.files.first;

        await userNotifier.updateUserAvatar(file);
        final updateAvatarState = userNotifier.updateAvatar.value;
        
        if (!mounted) return; // Check if widget is still mounted
        
        switch (updateAvatarState.status) {
          case ApiStatus.success:
            // Refresh user data to show new avatar
            await userNotifier.getUser();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Avatar updated successfully!'),
                backgroundColor: Color(0xFF00bcd5),
              ),
            );
            break;
          case ApiStatus.error:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(updateAvatarState.error ?? 'Failed to update avatar. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
            break;
          case ApiStatus.loading:
          case ApiStatus.initial:
            // Handle loading and initial states in UI
            break;
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
