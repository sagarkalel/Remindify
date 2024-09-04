import 'package:Remindify/pages/add_contact_info_page/add_contact_info_page.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../utils/global_constants.dart';

class AddFabButton extends StatelessWidget {
  const AddFabButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddContactInfoPage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(-2, 2),
                ),
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(-2, -2),
                ),
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(2, -2),
                ),
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
              gradient: RadialGradient(
                  colors: [Colors.greenAccent, kColorScheme.inversePrimary]),
            ),
            child: const Icon(Icons.add_card_outlined),
          ),
        ).padYBottom(45));
  }
}
