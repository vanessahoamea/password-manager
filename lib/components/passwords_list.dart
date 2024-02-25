import 'package:flutter/material.dart';
import 'package:password_manager/services/passwords/password.dart';
import 'package:password_manager/utils/theme_extensions/global_colors.dart';

class PasswordsList extends StatelessWidget {
  final Iterable<Password> passwords;

  const PasswordsList({super.key, required this.passwords});

  @override
  Widget build(BuildContext context) {
    final GlobalColors colors = Theme.of(context).extension<GlobalColors>()!;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: passwords.length,
      itemExtent: 90.0,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 2.5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.public),
            title: Text(
              passwords.elementAt(index).website,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: passwords.elementAt(index).username != null
                ? Text(
                    passwords.elementAt(index).username!,
                    style: TextStyle(color: colors.secondaryTextColor),
                  )
                : null,
            trailing: Icon(
              Icons.chevron_right,
              color: colors.secondaryTextColor,
            ),
          ),
        );
      },
    );
  }
}
