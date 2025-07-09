import 'package:flutter/material.dart';

class CurrencyText extends StatelessWidget {
  final double amount;
  final TextStyle? style;
  final TextAlign? textAlign;

  const CurrencyText({
    super.key,
    required this.amount,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '₹${amount.toStringAsFixed(0)}',
      style: style?.copyWith(
        fontFamilyFallback: const ['Noto Sans', 'Arial', 'Roboto', 'sans-serif'],
      ) ?? const TextStyle(
        fontFamilyFallback: ['Noto Sans', 'Arial', 'Roboto', 'sans-serif'],
      ),
      textAlign: textAlign,
    );
  }
}

class CurrencySpan extends TextSpan {
  CurrencySpan({
    required double amount,
    TextStyle? style,
  }) : super(
    text: '₹${amount.toStringAsFixed(0)}',
    style: style?.copyWith(
      fontFamilyFallback: const ['Noto Sans', 'Arial', 'Roboto', 'sans-serif'],
    ) ?? const TextStyle(
      fontFamilyFallback: ['Noto Sans', 'Arial', 'Roboto', 'sans-serif'],
    ),
  );
}
