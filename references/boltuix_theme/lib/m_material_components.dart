import 'package:flutter/material.dart';

class CustomComponent {
  final int id;
  final String title;
  final String description;
  final String tag;
  final String label;
  final String website;
  final String image;
  final Widget? widget; // Updated to CustomComponent

  CustomComponent({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.label,
    required this.website,
    required this.image,
    this.widget,
  });

  factory CustomComponent.fromJson(Map<String, dynamic> json) {
    return CustomComponent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      tag: json['tag'],
      label: json['label'],
      website: json['website'],
      image: json['image'],
      widget: json['widget'], // Ensure that 'widget' is of type CustomComponent
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tag': tag,
      'label': label,
      'website': website,
      'image': image,
      'widget': widget,
    };
  }
}
