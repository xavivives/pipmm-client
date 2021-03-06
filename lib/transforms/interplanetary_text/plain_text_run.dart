import 'package:flutter/material.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/interplanetary_text.dart';

class PlainTextRun implements IptRun {
  @override
  List<IptRun> iptRuns = [];
  String text;
  PlainTextRun(this.text);

  @override
  bool isStaticTransclusion() {
    return false;
  }

  @override
  bool isDynamicTransclusion() {
    return false;
  }

  @override
  bool isPlainText() {
    return true;
  }

  @override
  TextSpan renderTransclusion(Repo repo) {
    return TextSpan(
        text: text,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
        ));
  }
}
