import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SimpleTrainingApp()));
}

class Sample {
  final String imageUrl;
  final String answer;
  Sample(this.imageUrl, this.answer);

  factory Sample.fromList(List<String> list) {
    return Sample(list[0], list[1]);
  }
}

class SimpleTrainingApp extends StatefulWidget {
  const SimpleTrainingApp({super.key});
  @override
  State<SimpleTrainingApp> createState() => _SimpleTrainingAppState();
}

const String appTitle = 'TWICEメンバー試験';

class _SimpleTrainingAppState extends State<SimpleTrainingApp> {
  final List<List<String>> data = [
    ["https://upload.wikimedia.org/wikipedia/commons/4/45/251120_NAYEON.png", "〇 ナヨン"],
    ["https://hips.hearstapps.com/hmg-prod/images/chaeyoung-of-twice-attends-the-33th-golden-disc-awards-at-news-photo-1625564381.jpg", "〇 チェヨン"],
    ["https://prcdn.freetls.fastly.net/release_image/23861/86/23861-86-aefa06c70255c07b725eed7710b69bfd-1920x1281.png?width=1950&height=1350&quality=85%2C65&format=jpeg&auto=webp&fit=bounds&bg-color=fff", "〇 ジヒョ"],
    ["https://hips.hearstapps.com/hmg-prod/images/sana-of-twice-arrives-at-the-photocall-for-the-34th-golden-news-photo-1620971646.", "〇 サナ"],
    ["https://hips.hearstapps.com/hmg-prod/images/momo-of-k-pop-girl-group-twice-is-seen-leaving-incheon-news-photo-1699340285.jpg?crop=0.815xw:1.00xh;0.107xw,0", "〇 モモ"],
    ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6ccngn_Y4NZSnLwz3g75RZtHM0y4lkpbjbg&s", "〇 ミナ"],
    ["https://article-image-ix.nikkei.com/https%3A%2F%2Fimgix-proxy.n8s.jp%2FDSXZZO3673693020102018000000-PN1-3.jpg?s=ebe233e9613a3395e3b3977cd570dec3", "〇 ツウィ"],
    ["https://hips.hearstapps.com/hmg-prod/images/gettyimages-2129501048-6646aedf1f534.jpg", "〇 ダヒョン"],
    ["https://cdn.livedoor.jp/kstyle/2f9dbc6229031b97d05176f426e83532.jpg/r.580x0", "〇 ジョンヨン"],
  ];

  late final List<Sample> _samples;
  int _index = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _samples = data.map((e) => Sample.fromList(e)).toList();
    _samples.shuffle(Random());
  }

  void _onTap() {
    setState(() {
      if (_showAnswer) {
        _showAnswer = false;

        // 最後まで行ったら再シャッフルして先頭へ
        if (_index == _samples.length - 1) {
          _samples.shuffle(Random());
          _index = 0;
        } else {
          _index++;
        }
      } else {
        _showAnswer = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_samples.isEmpty) {
      return const Scaffold(body: Center(child: Text('データがありません')));
    }

    final sample = _samples[_index];

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                sample.imageUrl,
                // fit: BoxFit.cover,// 画面いっぱいに広げる代わりに上下左右が切れる
                fit: BoxFit.contain, // 画像全体が必ず画面内に収まる（余白が出ることはあるが切れない）
                loadingBuilder: (c, w, p) => p == null ? w : const Center(child: CircularProgressIndicator()),
                errorBuilder: (e1, e2, e3) => const Center(child: Text('画像を読み込めません')),
              ),
            ),

            if (_showAnswer)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    sample.answer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            Positioned(
              top: 10,
              right: 10,
              child: _hint(_showAnswer ? 'タップで次へ' : 'タップで正解表示'),
            ),

            Positioned(
              top: 10,
              left: 10,
              child: _hint('${_index + 1}/${_samples.length}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hint(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
