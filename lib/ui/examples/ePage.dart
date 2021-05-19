

import 'package:flutter/material.dart';

abstract class EPage extends StatelessWidget {
  const EPage(this.leading, this.title);

  final Widget leading;
  final String title;
}
