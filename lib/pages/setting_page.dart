import 'package:audio_store/database/supabase_controller.dart';
import 'package:audio_store/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  final _supabase = Supabase.instance.client;

  bool isChanging = false;
  bool isSaved = false;

  String fullNameState = '';
  String addressState = '';
  String countryCodeState = '';
  String phoneState = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: getUserProfile(
                uid: Supabase.instance.client.auth.currentUser!.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final userProfile = snapshot.data as UserProfile;
                Logger().i(userProfile.address);
                Logger().i(userProfile.fullName);
                Logger().i(userProfile.phone);
                _fullNameController.text = userProfile.fullName ?? '';
                _addressController.text = userProfile.address ?? '';
                _phoneController.text = userProfile.phone ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                _supabase.auth.currentUser!.email!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: () {
                                logoutUser();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    content: Text(
                                      'You have been logged out',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                  ),
                                );
                                context.go('/');
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text('Logout'),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/change_password');
                          },
                          child: const Text('Change password'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            // controller: _fullNameController,
                            initialValue: userProfile.fullName,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              border: OutlineInputBorder(),
                            ),
                            autofillHints: const [AutofillHints.name],
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {
                              fullNameState = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            // // controller: _addressController,
                            initialValue: userProfile.address,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                            autofillHints: const [
                              AutofillHints.streetAddressLine1
                            ],
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {
                              addressState = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  initialValue: (userProfile.phone != null &&
                                          userProfile.phone != '')
                                      ? userProfile.phone?.substring(0, 2)
                                      : null,
                                  decoration: const InputDecoration(
                                    labelText: 'Code',
                                    border: OutlineInputBorder(),
                                  ),
                                  autofillHints: const [
                                    AutofillHints.telephoneNumber
                                  ],
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onTapOutside: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  onChanged: (value) {
                                    countryCodeState = value;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 6,
                                child: TextFormField(
                                  // controller: _phoneController,

                                  initialValue: (userProfile.phone != null &&
                                          userProfile.phone != '')
                                      ? userProfile.phone?.substring(2)
                                      : null,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone',
                                    border: OutlineInputBorder(),
                                  ),
                                  autofillHints: const [
                                    AutofillHints.telephoneNumber
                                  ],
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onTapOutside: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  onChanged: (value) {
                                    phoneState = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                final phoneNumber =
                                    '$countryCodeState$phoneState';

                                if ((countryCodeState.isEmpty) &&
                                    phoneState.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                      content: Text(
                                        'Please fill the country code',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onError),
                                      ),
                                    ),
                                  );
                                  return;
                                } else if (phoneNumber.isNotEmpty &&
                                    phoneNumber.length < 8) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                      content: Text(
                                        'Phone number must be at least 8 digits',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onError),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  updateUserProfile(
                                    uid: _supabase.auth.currentUser!.id,
                                    userProfile: UserProfile(
                                      fullName: fullNameState,
                                      address: addressState,
                                      phone: '$countryCodeState$phoneState',
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      content: Text(
                                        'Profile updated',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                      content: Text(
                                        'Failed to update profile',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onError),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text('Error occured\nPlease refresh the page');
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
