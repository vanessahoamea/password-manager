import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/bloc/manager/manager_state.dart';
import 'package:password_manager/components/password_container.dart';
import 'package:password_manager/components/password_option.dart';
import 'package:password_manager/components/primary_button.dart';
import 'package:password_manager/overlays/toast.dart';

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      Toast.show(context: context, text: 'Copied password to clipboard.');
    });
  }

  void _generatePassword(
    BuildContext context, {
    int? length,
    bool? includeLowercase,
    bool? includeUppercase,
    bool? includeNumbers,
    bool? includeSpecial,
  }) {
    context.read<ManagerBloc>().add(ManagerEventUpdateGeneratorState(
          length: length,
          includeLowercase: includeLowercase,
          includeUppercase: includeUppercase,
          includeNumbers: includeNumbers,
          includeSpecial: includeSpecial,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerBloc, ManagerState>(
      builder: (context, state) {
        state as ManagerStateGeneratorPage;
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // password container
              PasswordContainer(password: state.password),
              const SizedBox(height: 20),

              // copy and generate buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: 'Copy',
                      onTap: () => _copyToClipboard(context, state.password),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Generate',
                      onTap: () => _generatePassword(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // preferences
              PasswordOption(
                title: 'Length',
                widgets: [
                  Expanded(
                    child: Slider(
                      min: 8,
                      max: 64,
                      value: state.length.toDouble(),
                      onChanged: (value) =>
                          _generatePassword(context, length: value.toInt()),
                    ),
                  ),
                  Text(
                    '${state.length}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              PasswordOption(
                title: 'Lowercase letters (a-z)',
                widgets: [
                  Switch(
                    value: state.includeLowercase,
                    onChanged: (value) =>
                        _generatePassword(context, includeLowercase: value),
                  ),
                ],
              ),
              PasswordOption(
                title: 'Uppercase letters (A-Z)',
                widgets: [
                  Switch(
                    value: state.includeUppercase,
                    onChanged: (value) =>
                        _generatePassword(context, includeUppercase: value),
                  ),
                ],
              ),
              PasswordOption(
                title: 'Numbers (0-9)',
                widgets: [
                  Switch(
                    value: state.includeNumbers,
                    onChanged: (value) =>
                        _generatePassword(context, includeNumbers: value),
                  ),
                ],
              ),
              PasswordOption(
                title: r'Special characters (!@#$%^&*)',
                widgets: [
                  Switch(
                    value: state.includeSpecial,
                    onChanged: (value) =>
                        _generatePassword(context, includeSpecial: value),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
