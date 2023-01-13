import 'package:flutter/material.dart';

@immutable
class Message1 {
  final String title;
  final String body;

  const Message1({
    required this.title,
    required this.body,
  });
}
