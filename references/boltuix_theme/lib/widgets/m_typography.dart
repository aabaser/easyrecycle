import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleExample extends StatelessWidget {
  const TextStyleExample({
    super.key,
    required this.name,
    required this.style,
    this.align, // Nullable parameter for text alignment
  });

  final String name;
  final TextStyle style;
  final TextAlign? align; // Nullable type for text alignment

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        name,
        textAlign: align ??
            TextAlign
                .justify, // Set default value to TextAlign.center if align is null
        //style: style.copyWith(letterSpacing: 1.0)
        style: GoogleFonts.rosario().merge(style.copyWith(letterSpacing: 1.0)),
      ),
    );
  }
}
