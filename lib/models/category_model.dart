import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String title;
  final dynamic icon; // Changed from IconData to dynamic to support FaIconData
  final Color color;

  ServiceCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}
