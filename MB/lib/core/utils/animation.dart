import 'package:entry/entry.dart';
import 'package:flutter/material.dart';

class ScaleAnimationWidget extends StatelessWidget {
  final Widget child;

  const ScaleAnimationWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Entry.scale(
      duration: const Duration(milliseconds: 400),
      child: child,
    );
  }
}

class OffsetAnimationWidget extends StatelessWidget {
  final Widget child;

  const OffsetAnimationWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Entry.offset(
      duration: const Duration(milliseconds: 400),
      child: child,
    );
  }
}

class OpacityAnimationWidget extends StatelessWidget {
  final Widget child;

  const OpacityAnimationWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Entry.opacity(
      duration: const Duration(milliseconds: 400),
      child: child,
    );
  }
}

class AllAnimationWidget extends StatelessWidget {
  final Widget child;

  const AllAnimationWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Entry.opacity(
      duration: const Duration(milliseconds: 400),
      child: child,
    );
  }
}

class ListAnimationWidget extends StatelessWidget {
  final Widget child;

  const ListAnimationWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Entry.opacity(
      duration: const Duration(milliseconds: 400),
      child: child,
    );
  }
}
