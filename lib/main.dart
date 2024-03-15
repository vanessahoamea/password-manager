import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:password_manager/bloc/ad/ad_cubit.dart';
import 'package:password_manager/bloc/auth/auth_bloc.dart';
import 'package:password_manager/bloc/auth/auth_event.dart';
import 'package:password_manager/bloc/auth/auth_state.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/bloc/theme/theme_cubit.dart';
import 'package:password_manager/components/page_wrapper.dart';
import 'package:password_manager/overlays/loading_screen.dart';
import 'package:password_manager/overlays/toast.dart';
import 'package:password_manager/pages/generator.dart';
import 'package:password_manager/pages/login.dart';
import 'package:password_manager/pages/passwords.dart';
import 'package:password_manager/pages/register.dart';
import 'package:password_manager/pages/settings.dart';
import 'package:password_manager/pages/single_password.dart';
import 'package:password_manager/pages/verify_email.dart';
import 'package:password_manager/services/ad/ad_service.dart';
import 'package:password_manager/services/auth/auth_service.dart';
import 'package:password_manager/services/biometrics/biometrics_service.dart';
import 'package:password_manager/services/local_storage/local_storage_service.dart';
import 'package:password_manager/services/passwords/password_service.dart';
import 'package:password_manager/utils/themes.dart';

void main() {
  runApp(BlocProvider<ThemeCubit>(
    create: (context) => ThemeCubit(LocalStorageService()),
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Password Manager',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(
                  AuthService.fromFirebase(),
                  LocalStorageService(),
                  BiometricsService(),
                  AdService<Ad>.fromAdMob(),
                ),
              ),
              BlocProvider<ManagerBloc>(
                create: (context) => ManagerBloc(
                  PasswordService.fromFirestore(),
                  LocalStorageService(),
                  BiometricsService(),
                ),
              ),
              BlocProvider<AdCubit>(
                create: (context) => AdCubit(AdService<Ad>.fromAdMob()),
              ),
            ],
            child: const HomePage(),
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState.isLoading) {
          LoadingScreen.show(
            context: context,
            text: authState.loadingMessage,
          );
        } else {
          LoadingScreen.hide();
        }
      },
      builder: (context, authState) {
        switch (authState.runtimeType) {
          case AuthStateLoggedOut:
            return const LoginPage();
          case AuthStateRegistering:
            return const RegisterPage();
          case AuthStateVerifyEmail:
            return const VerifyEmailPage();
          case AuthStateLoggedIn:
            final user = (authState as AuthStateLoggedIn).user;
            context.read<ManagerBloc>().add(ManagerEventInitialize(user: user));

            return BlocConsumer<ManagerBloc, ManagerState>(
              listener: (context, managerState) {
                // loading screen when performing an action on a password
                if (managerState is ManagerStateSinglePasswordPage &&
                    managerState.isLoading) {
                  Future.delayed(const Duration(seconds: 5));
                  LoadingScreen.show(
                    context: context,
                    text: managerState.loadingMessage,
                  );
                } else {
                  LoadingScreen.hide();
                }

                // toast messages when the action is finished
                if (managerState.showToast) {
                  Toast.show(
                    context: context,
                    text: managerState.toastMessage,
                  );
                }
              },
              builder: (context, managerState) {
                switch (managerState.runtimeType) {
                  case ManagerStatePasswordsPage:
                    managerState as ManagerStatePasswordsPage;
                    return PageWrapper(
                      title: managerState.title ?? 'My Passwords',
                      body: PasswordsPage(searchTerm: managerState.searchTerm),
                      navbarIndex: managerState.navbarIndex ?? 0,
                    );
                  case ManagerStateGeneratorPage:
                    return PageWrapper(
                      title: managerState.title ?? 'Generate Password',
                      body: const GeneratorPage(),
                      navbarIndex: managerState.navbarIndex ?? 1,
                    );
                  case ManagerStateSettingsPage:
                    return PageWrapper(
                      title: managerState.title ?? 'Settings',
                      body: const SettingsPage(),
                      navbarIndex: managerState.navbarIndex ?? 2,
                    );
                  case ManagerStateSinglePasswordPage:
                    managerState as ManagerStateSinglePasswordPage;
                    return SinglePasswordPage(
                      password: managerState.password,
                      decryptedPassword: managerState.decryptedPassword,
                    );
                  default:
                    return PageWrapper(
                      title: managerState.title ?? 'My Passwords',
                      body: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                      navbarIndex: managerState.navbarIndex ?? 0,
                    );
                }
              },
            );
          default:
            return const Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
        }
      },
    );
  }
}
