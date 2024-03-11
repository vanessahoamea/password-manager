import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/bloc/manager/manager_bloc.dart';
import 'package:password_manager/bloc/manager/manager_event.dart';
import 'package:password_manager/services/passwords/password.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class PasswordsList extends StatelessWidget {
  final Iterable<Password> passwords;

  const PasswordsList({super.key, required this.passwords});

  @override
  Widget build(BuildContext context) {
    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;

    String trimText(String text, int length) {
      if (length > text.length) {
        return text;
      } else {
        return '${text.substring(0, length)}...';
      }
    }

    return passwords.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: passwords.length,
            itemExtent: 90.0,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 2.5),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.public),
                    title: Text(
                      trimText(passwords.elementAt(index).website, 30),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: passwords.elementAt(index).username != null
                        ? Text(
                            trimText(passwords.elementAt(index).username!, 30),
                            style: TextStyle(color: colors.secondaryTextColor),
                          )
                        : null,
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colors.secondaryTextColor,
                    ),
                  ),
                ),
                onTap: () {
                  context
                      .read<ManagerBloc>()
                      .add(ManagerEventGoToSinglePassword(
                        password: passwords.elementAt(index),
                      ));
                },
              );
            },
          )
        : Text(
            'Nothing to see here.',
            style: TextStyle(color: colors.secondaryTextColor),
          );
  }
}
