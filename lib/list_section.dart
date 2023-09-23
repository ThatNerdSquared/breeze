import 'package:flutter/material.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

class ListSection extends StatelessWidget {
  final Text header;
  final List<Widget> children;
  const ListSection({
    super.key,
    required this.header,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
            left: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
            right: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
            bottom: BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.only(
          top: PretConfig.thinElementSpacing,
          bottom: PretConfig.thinElementSpacing,
          left: PretConfig.defaultElementSpacing,
          right: PretConfig.defaultElementSpacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const Padding(
                padding: EdgeInsets.only(bottom: PretConfig.minElementSpacing)),
            Column(
              children: children,
            )
          ],
        ));
  }
}
