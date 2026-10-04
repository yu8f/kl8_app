进口 '飞镖：数学';
进口 '包：颤振/material.dart';
进口 '包：flutter/services.dart';
进口 '包：shared_preferences/shared_preferences。飞镖';

void main() => runApp(const Kl8App());

/// 内置历史开奖数据
const String kEmbeddedRaw = '''
2026263 0708091011132224252631333745505162677080
2026262 0406091215172033424449545559616572737880
2026261 0111172123272835374245464861727375787980
2026260 0207161921253031333542455052535556606372
2026259 0506132629303436445054566162667374767980
2026258 0713141517192024283035445051545760647578
2026257 0104070810132324313339404748586165747679
2026256 0102061112141522243233353846676871737476
2026255 0209121618232631364447525455596061667277
2026254 0204101318202126323743495057626669737880
2026253 0102081723242931404146475154596265727479
2026252 0203040836384041464950525356576263656872
2026251 0104080910111826282943495152535462667076
2026250 0405060817222331354749515960626567687678
2026249 0408101113262934415051525357596566737477
2026248 0305091523283133343539424850537073747678
2026247 0507192228293839414243445558616566717273
2026246 0308101618202329313551535456586970757880
2026245 0506091518252627303134363943444854636577
2026244 0104070810123446475355565961636571737879
2026243 0102030921293136374143465055646768707476
2026242 0420283235373944485052535556576371727677
2026241 0709151618193233363740525360626366686973
2026240 0206091016212728323338395563646667707578
2026239 1417202126272930374445475455616568697779
2026238 0104061112161720223241475152626364687275
2026237 0206091315171820213037434851535558687477
2026236 1519242528293137455055566162646570757680
2026235 0211141921233648505153606264667273757880
2026234 0308152136374244465052555657606168727579
2026233 0305071719242630313435364244525355636566
2026232 0105091114272932364154555761636769717379
2026231 1217262831343742445152555960616268747579
2026230 0307081314212428333538445051545969747778
2026229 1426333941474856596164656668717276777880
2026228 0813151719232427283540414245464752566780
2026227 0409101217182228333842444748616364677374
2026226 0809101516203034363743454647485053626566
2026225 0304071213162021252632414344475360687376
2026224 0306151920222324272936424546495556757678
2026223 0319222728333435364050515457646768697579
2026222 0205070917182125283132333435385157586165
2026221 0102030510182125283435414851545859607779
2026220 0506101217202123242533353839404143496771
2026219 0203050613152035363947485158656772737980
2026218 0305071115171819222429414347495059627880
2026217 0708101114182021242829334146676874767778
2026216 0203131922242528294243454962636970727680
2026215 0109141921222427364144515560616971767880
2026214 0207121820212325323435374045475155596171
2026213 0607081112131821333637424456575860667180
2026212 0108101214152631374245485861667172747779
2026211 0405081214202324253035374651536074757778
2026210 0304071214151721222427294547566072747880
2026209 0204101114161823323537454751525359677580
2026208 0811121314151623252834373843454858707377
2026207 0210161819202833394146495157606364657176
2026206 0106071617212732333644475051556264767879
2026205 0405091011192831323536394347535659707779
2026204 0310132122242837384651525456596065667073
2026203 0209102122242932384042505153586063677074
2026202 0104071012151617262932404244496568737778
2026201 0203121317202427313240455052616771767980
2026200 0204172529313233353742444551565759606466
2026199 0414171820212627293444485053555962677679
2026198 0509181924263034424647495154555662737475
2026197 0206111213171927353942444553586471727475
2026196 0406142932363940424344535661676869707379
2026195 0710141718192324273031374041464749636475
2026194 0205061219202935373946474851545966727478
2026193 0307152229303740424851526162646671747578
2026192 0410121516181927283236464951546269707375
2026191 0102050613152328323437424546535571737577
2026190 0203071023303239404142444546515359616780
2026189 0105061214182227293235424955575969717478
2026188 0411131718202123252729384456616265677579
2026187 0203080911121525273133343855576269727578
2026186 0107111821232628303437414445465865677180
2026185 0406121524303335394042454858606166676980
2026184 0304060709101113253233435759666972737778
2026183 0109101114152242455557626566686973767780
2026182 0102030612172325283948495253556368697378
2026181 0610121822283033353842485859636465717679
2026180 0102051219233637414250535659646872737477
2026179 0110121314151927293240434953596269727380
2026178 0510121920262730353844454647495456617277
2026177 1115162033353739424649505456616271737679
2026176 0708142122262933363940575963646770727376
2026175 0915162127323334363839444554606777787980
2026174 0207111318212325303148535455616269767780
''';

班级绘制{
  final int issue;
  final List<int> nums;
  Draw(this.issue, this.nums);
  String get numsCompact => nums.map((n) => two(n)).join();
}

List<Draw> parseDraws(String raw) {
  final list = <Draw>[];
  for (var line in raw.trim().split('\n')) {
    final p = line.trim().split(RegExp(r'\s+'));
    if (p.length < 2) continue;
    final issue = int.tryParse(p[0]) ?? 0;
    if (issue == 0 || p[1].length < 40) continue;
    final nums = <int>[];
    for (var i = 0; i + 2 <= p[1].length && nums.length < 20; i += 2) {
      final n = int.tryParse(p[1].substring(i, i + 2));
      if (n == null || n < 1 || n > 80) break;
      nums.add(n);
    }
    if (nums.length != 20 || nums.toSet().length != 20) continue;
    nums.sort();
    list.add(Draw(issue, nums));
  }
  list.sort((a, b) => b.issue.compareTo(a.issue));
  return list;
}

String two(int n) => n.toString().padLeft(2, '0');

class DrawStore extends ChangeNotifier {
  List<Draw> draws = parseDraws(kEmbeddedRaw);
  static const _keyExtra = 'extra_draws';
  static const _keyDisclaimer = 'disclaimer_shown';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final extraRaw = (prefs.getStringList(_keyExtra) ?? []).join('\n');
    final merged = <int, Draw>{};
    for (final d in parseDraws(kEmbeddedRaw)) merged[d.issue] = d;
    for (final d in parseDraws(extraRaw)) merged[d.issue] = d;
    draws = merged.values.toList()
      ..sort((a, b) => b.issue.compareTo(a.issue));
    notifyListeners();
  }

  Future<void> addDraw(Draw d) async {
    final prefs = await SharedPreferences.getInstance();
    final extra = prefs.getStringList(_keyExtra) ?? [];
    extra.removeWhere((e) => e.startsWith('${d.issue} '));
    extra.add('${d.issue} ${d.numsCompact}');
    await prefs.setStringList(_keyExtra, extra);
    await load();
  }

  Future<void> removeDraw(int issue) async {
    final prefs = await SharedPreferences.getInstance();
    final extra = prefs.getStringList(_keyExtra) ?? [];
    extra.removeWhere((e) => e.startsWith('$issue '));
    await prefs.setStringList(_keyExtra, extra);
    await load();
  }

  Future<bool> disclaimerShown() async =>
      (await SharedPreferences.getInstance()).getBool(_keyDisclaimer) ?? false;

  Future<void> markDisclaimerShown() async =>
      (await SharedPreferences.getInstance()).setBool(_keyDisclaimer, true);
}

class Stats {
  final List<int> freq = List.filled(80, 0);
  final List<int> omission = List.filled(80, 0);
  final int window;

  Stats(List<Draw> drawsNewestFirst, this.window) {
    final w = min(window, drawsNewestFirst.length);
    for (var i = 0; i < w; i++) {
      for (final n in drawsNewestFirst[i].nums) {
        freq[n - 1]++;
      }
    }
    for (var c = 0; c < 80; c++) {
      var k = 0;
      while (k < w && !drawsNewestFirst[k].nums.contains(c + 1)) k++;
      omission[c] = k;
    }
  }

  double get _freqMean {
    var s = 0;
    for (final f in freq) s += f;
    return s / 80;
  }

  double get _omMean {
    var s = 0;
    for (final o in omission) s += o;
    return s / 80;
  }

  double mixScore(int i) {
    final fm = _freqMean == 0 ? 1 : _freqMean;
    final om = _omMean == 0 ? 1 : _omMean;
    return freq[i] / fm + omission[i] / om;
  }
}

List<int> weightedPick(int k, List<double> weights, Random rng) {
  final pool = List<int>.generate(80, (i) => i);
  final out = <int>[];
  for (var t = 0; t < k; t++) {
    var total = 0.0;
    for (final j in pool) total += weights[j];
    if (total <= 0) {
      out.add(pool.removeAt(rng.nextInt(pool.length)) + 1);
      continue;
    }
    var r = rng.nextDouble() * total;
    var idx = pool.length - 1;
    for (var j = 0; j < pool.length; j++) {
      r -= weights[pool[j]];
      if (r <= 0) {
        idx = j;
        break;
      }
    }
    out.add(pool.removeAt(idx) + 1);
  }
  out.sort();
  return out;
}

class Kl8App extends StatelessWidget {
  const Kl8App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '快乐8 · 数据分析',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD32F2F)),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = DrawStore();
  int nav = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await store.load();
    if (!mounted) return;
    if (!await store.disclaimerShown()) _showDisclaimer();
  }

  void _showDisclaimer() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('重要提示'),
        content: const Text(
            '每期开奖均为独立随机事件，历史数据无法预测未来号码。'
            '本应用所有"推荐"仅为统计意义上的随机参考，不构成任何购彩建议。'
            '请理性购彩，量力而行。'),
        actions: [
          FilledButton(
            onPressed: () {
              store.markDisclaimerShown();
              Navigator.of(ctx).pop();
            },
            child: const Text('我已了解'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PickPage(store: store),
      TrendPage(store: store),
      DataPage(store: store),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('快乐8 · 数据分析'), centerTitle: true),
      body: AnimatedBuilder(
        animation: store,
        builder: (_, __) => pages[nav],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: nav,
        onDestinationSelected: (i) => setState(() => nav = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.tune), label: '选号'),
          NavigationDestination(icon: Icon(Icons.query_stats), label: '走势'),
          NavigationDestination(icon: Icon(Icons.storage), label: '数据'),
        ],
      ),
    );
  }
}

class Ball extends StatelessWidget {
  final int n;
  final bool small;
  final Color? color;
  const Ball(this.n, {super.key, this.small = false, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    final size = small ? 24.0 : 30.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.withOpacity(0.12),
        border: Border.all(color: c.withOpacity(0.55)),
      ),
      child: Center(
        child: Text(
          two(n),
          style: TextStyle(
            fontSize: small ? 11 : 13,
            fontWeight: FontWeight.w600,
            color: c,
          ),
        ),
      ),
    );
  }
}

class SetCard extends StatelessWidget {
  final int index;
  final List<int> nums;
  const SetCard({super.key, required this.index, required this.nums});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('第 ${index + 1} 组',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  tooltip: '复制号码',
                  onPressed: () {
                    final s = nums.map(two).join(' ');
                    Clipboard.setData(ClipboardData(text: s));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已复制')),
                    );
                  },
                ),
              ],
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: nums.map((n) => Ball(n)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===================== 选号页：模式一 智能分析 / 模式二 条件定制 =====================
class PickPage extends StatefulWidget {
  final DrawStore store;
  const PickPage({super.key, required this.store});
  @override
  State<PickPage> createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  bool mode2 = false; // false=模式一 智能分析
  final rng = Random();

  // 模式一参数
  String strategy = 'mix'; // hot / cold / mix / rand
  int win = 60;
  int play = 10;
  int setCount = 3;
  List<List<int>> results = [];

  // 模式二参数
  int m2play = 10;
  int oddMode = 0; // 0不限 1奇多 2偶多 3全奇 4全偶
  final sumMinCtrl = TextEditingController(text: '700');
  final sumMaxCtrl = TextEditingController(text: '950');
  final Set<int> include = {};
  final Set<int> exclude = {};
  int maxConsec = 3; // 0=不限
  int prefer = 1; // 0偏热 1均衡 2偏冷
  int m2sets = 3;
  List<List<int>> results2 = [];
  int m2found = 0;

  static const strategyLabels = {'hot': '热号加权', 'cold': '冷号遗漏', 'mix': '均衡混合', 'rand': '纯随机'};
  static const playLabels = ['选一', '选二', '选三', '选四', '选五', '选六', '选七', '选八', '选九', '选十'];

  List<double> weightsFor(Stats st) {
    switch (strategy) {
      case 'hot':
        return st.freq.map((f) => f.toDouble() + 0.5).toList();
      case 'cold':
        return st.omission.map((o) => o.toDouble() + 0.5).toList();
      case 'rand':
        return List.filled(80, 1.0);
      default: // mix
        return List.generate(80, (i) => st.mixScore(i) + 0.1);
    }
  }

  void genMode1() {
    final st = Stats(widget.store.draws, win);
    final w = weightsFor(st);
    final seen = <String>{};
    final out = <List<int>>[];
    while (out.length < setCount) {
      final s = weightedPick(play, w, rng);
      final key = s.join(',');
      if (seen.add(key)) out.add(s);
    }
    setState(() => results = out);
  }

  bool validM2(List<int> s) {
    if (include.isNotEmpty && !include.every(s.contains)) return false;
    if (exclude.any(s.contains)) return false;
    final sum = s.fold<int>(0, (a, b) => a + b);
    final min = int.tryParse(sumMinCtrl.text) ?? 0;
    final max = int.tryParse(sumMaxCtrl.text) ?? 9999;
    if (sum < min || sum > max) return false;
    final odd = s.where((n) => n.isOdd).length;
    switch (oddMode) {
      case 1: if (odd * 2 <= s.length) return false; break;
      case 2: if (odd * 2 >= s.length) return false; break;
      case 3: if (odd != s.length) return false; break;
      case 4: if (odd != 0) return false; break;
    }
    if (maxConsec > 0) {
      var run = 1;
      for (var i = 1; i < s.length; i++) {
        if (s[i] == s[i - 1] + 1) { run++; if (run > maxConsec) return false; }
        else run = 1;
      }
    }
    return true;
  }

  double scoreM2(List<int> s, Stats st) {
    switch (prefer) {
      case 0: return s.fold<double>(0, (a, n) => a + st.freq[n - 1]);
      case 2: return s.fold<double>(0, (a, n) => a + st.omission[n - 1]);
      default: return s.fold<double>(0, (a, n) => a + st.mixScore(n - 1));
    }
  }

  void genMode2() {
    final st = Stats(widget.store.draws, 60);
    final uniform = List.filled(80, 1.0);
    final cands = <String, List<int>>{};
    for (var i = 0; i < 20000 && cands.length < 500; i++) {
      final s = weightedPick(m2play, uniform, rng);
      if (validM2(s)) cands[s.join(',')] = s;
    }
    final list = cands.values.toList()
      ..sort((a, b) => scoreM2(b, st).compareTo(scoreM2(a, st)));
    setState(() {
      m2found = list.length;
      results2 = list.take(m2sets).toList();
    });
  }

  Widget sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  Widget chipRow<T>(List<T> values, T cur, String Function(T) label, void Function(T) onTap) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((v) {
        final on = v == cur;
        return ChoiceChip(
          label: Text(label(v)),
          selected: on,
          onSelected: (_) => setState(() => onTap(v)),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('模式一 · 智能分析推荐')),
            ButtonSegment(value: true, label: Text('模式二 · 按我的要求推荐')),
          ],
          selected: {mode2},
          onSelectionChanged: (s) => setState(() => mode2 = s.first),
        ),
        const SizedBox(height: 8),
        mode2 ? buildMode2() : buildMode1(),
      ],
    );
  }

  Widget buildMode1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('推荐策略'),
        chipRow(strategyLabels.keys.toList(), strategy, (k) => strategyLabels[k]!, (v) => strategy = v),
        sectionTitle('数据窗口'),
        chipRow([30, 60, 90], win, (v) => '$v 期', (v) => win = v),
        sectionTitle('玩法'),
        chipRow(List.generate(10, (i) => i + 1), play, (v) => playLabels[v - 1], (v) => play = v),
        sectionTitle('生成组数'),
        chipRow([1, 2, 3, 5], setCount, (v) => '$v 组', (v) => setCount = v),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: genMode1,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('生成参考号码'),
          ),
        ),
        if (results.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...results.asMap().entries.map((e) => SetCard(index: e.key, nums: e.value)),
        ],
        const SizedBox(height: 16),
        Text(
          '回测提示：对近 60 期滚动回测显示，随机选 20 码平均命中 5.03，热号 4.93，'
          '遗漏 5.22，混合 5.18——各策略与随机无显著差异。每期开奖独立随机，结果仅供娱乐参考。',
          style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget buildMode2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('玩法'),
        chipRow(List.generate(10, (i) => i + 1), m2play, (v) => playLabels[v - 1], (v) => m2play = v),
        sectionTitle('奇偶要求'),
        chipRow([0, 1, 2, 3, 4], oddMode, (v) => ['不限', '奇数偏多', '偶数偏多', '全奇', '全偶'][v], (v) => oddMode = v),
        sectionTitle('和值范围（20 码理论均值 810）'),
        Row(children: [
          Expanded(
            child: TextField(
              controller: sumMinCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: '最小和值', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: sumMaxCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: '最大和值', border: OutlineInputBorder()),
            ),
          ),
        ]),
        sectionTitle('胆码（必选，已选 ${include.length} 个）'),
        numToggleGrid(include),
        sectionTitle('杀号（排除，已选 ${exclude.length} 个）'),
        numToggleGrid(exclude),
        sectionTitle('连号上限（最多连续几个）'),
        chipRow([0, 1, 2, 3, 4], maxConsec, (v) => v == 0 ? '不限' : '$v 个', (v) => maxConsec = v),
        sectionTitle('号码偏好（在满足条件的组合中优先）'),
        chipRow([0, 1, 2], prefer, (v) => ['偏热号', '均衡', '偏冷号'][v], (v) => prefer = v),
        sectionTitle('生成组数'),
        chipRow([1, 2, 3, 5], m2sets, (v) => '$v 组', (v) => m2sets = v),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
子项：FilledButton.icon(
            onPressed: genMode2,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('按条件生成'),
          ),
        ),
        if (results2.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('共找到 $m2found 组符合条件的组合，以下为其中最优 ${results2.length} 组：',
              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          ...results2.asMap().entries.map((e) => SetCard(index: e.key, nums: e.value)),
        ] else if (m2found == 0 && results2.isEmpty) ...[
          const SizedBox(height: 12),
          const Text('没有找到符合条件的组合，请放宽条件（如扩大和值范围、减少胆码）。'),
        ],
      ],
    );
  }

  Widget numToggleGrid(Set<int> sel) {
    final scheme = Theme.of(context).colorScheme;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10, mainAxisSpacing: 4, crossAxisSpacing: 4, childAspectRatio: 1),
      itemCount: 80,
      itemBuilder: (_, i) {
        final n = i + 1;
        final on = sel.contains(n);
        return GestureDetector(
          onTap: () => setState(() => on ? sel.remove(n) : sel.add(n)),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: on ? scheme.primary : scheme.surfaceVariant,
              border: Border.all(color: on ? scheme.primary : scheme.outlineVariant),
            ),
            child: Center(
              child: Text(two(n),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: on ? Colors.white : scheme.onSurface,
                  )),
            ),
          ),
        );
      },
    );
  }
}

/// ===================== 走势统计页 =====================
class TrendPage extends StatefulWidget {
  final DrawStore store;
  const TrendPage({super.key, required this.store});
  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  int win = 60;

  @override
  Widget build(BuildContext context) {
    final draws = widget.store.draws;
    if (draws.isEmpty) return const Center(child: Text('暂无数据'));
    final st = Stats(draws, win);
    final last = draws.first;
    final odd = last.nums.where((n) => n.isOdd).length;
    final mean = win * 0.25;
    final sd = sqrt((List.generate(80, (i) => pow(st.freq[i] - mean, 2)).reduce((a, b) => a + b) / 80).toDouble());

    最终的hotIdx=列表<int>.generate(80，(i)=>i)..sort((a，b)=>st.freq[b].compareTo(st.freq[a])；
    最终的omIdx=List<int>.generate(80，(i)=>i)..sort((a，b)=>st.omission[b].compareTo(st.omission[a])；

    返回ListView(
填充：ConstEdgeInsets.all(16),
儿童：[
行(
儿童：[
            Const文本('统计窗口'，样式：TextStyle(fontWeight:FontWeight.w600))，
            ConstSizedBox(宽度：12),
            ...[30, 60, 90].map((w)=>填充(
填充：ConstEdgeInsets.only(右侧：8),
子项：ChoiceChip(
标签：文本('$w期'),
已选择：win==w，
onselected：(_)=>setState(()=>win=w)，
                  ),
                )),
          ],
        ),
        ConstSizedBox(高度：8),
卡片(
子项：填充(
填充：ConstEdgeInsets.all(12),
子项：列(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('最新一期 第 ${last.issue} 期',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5, runSpacing: 5,
                  children: last.nums.map((n) => Ball(n, small: true)).toList(),
                ),
                const SizedBox(height: 8),
                Text('奇偶 $odd:${20 - odd} · 和值 ${last.nums.fold<int>(0, (a, b) => a + b)}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('冷热热力图', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('红=低于均值（冷）  蓝=高于均值（热），窗口内理论均值 ${mean.toStringAsFixed(1)} 次',
            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10, mainAxisSpacing: 3, crossAxisSpacing: 3, childAspectRatio: 1),
          itemCount: 80,
          itemBuilder: (_, i) {
            final z = sd == 0 ? 0.0 : (st.freq[i] - mean) / sd;
            final intensity = min(0.55, z.abs() * 0.32);
            final hot = z > 0.3;
            final cold = z < -0.3;
            final c = hot ? Colors.blue : Colors.red;
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (hot || cold) ? c.withOpacity(intensity) : Colors.transparent,
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Text(two(i + 1),
                    style: TextStyle(fontSize: 10, color: Colors.grey[800])),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        const Text('热号 Top 10', style: TextStyle(fontWeight: FontWeight.w600)),
        ...hotIdx.take(10).map((i) => rankRow(
            i + 1, st.freq[i], st.freq[hotIdx[0]], Colors.blue, '次')),
        const SizedBox(height: 12),
        const Text('当前遗漏 Top 10（理论平均遗漏 3 期）',
            style: TextStyle(fontWeight: FontWeight.w600)),
        ...omIdx.take(10).map((i) => rankRow(
            i + 1, st.omission[i], st.omission[omIdx[0]], Colors.red, '期')),
        const SizedBox(height: 16),
        const Text('近 10 期开奖', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...draws.take(10).map((d) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 76,
                    child: Text('${d.issue}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 3, runSpacing: 3,
                      children: d.nums.map((n) => Ball(n, small: true)).toList(),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget rankRow(int n, int v, int maxV, Color c, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Ball(n, small: true, color: c),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: maxV == 0 ? 0 : v / maxV,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(c.withOpacity(0.7)),
              ),
            ),
          ),
          SizedBox(
            width: 56,
            child: Text('$v $unit',
textAlign:TextAlign.right，
样式：textStyle(fontSize:12，colors:Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}

///=====================数据管理页=====================
班级数据页延伸StatefulWidget{
最终的DrawStore存储；
Const数据页({超级.钥匙，必需的这.商店})；
  @override
state<datapage>createState()=>_DataPageState()；
}

班级_DataPageState延伸状态<datapage>{
  @override
小部件生成(BuildContext上下文){
最终的draws=widget.store.draws；
最终的extraIssues=绘图。其中((d)=>！parseDraws(kEmbeddedRaw)。任何((e)=>e.issue==d.问题))。map((d)=>d.问题)。toset()；
    返回ListView(
填充：ConstEdgeInsets.all(16),
儿童：[
卡片(
子项：填充(
填充：ConstEdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('数据范围：第 ${draws.last.issue} – ${draws.first.issue} 期 · 共 ${draws.length} 期',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(
                    '内置 90 期官方开奖数据。每天开奖后可在下方手动录入最新一期，'
                    '数据保存在本机，无需联网。新录入的期号若与内置重复会自动覆盖。',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5)),
              ],
            ),
          ),
        ),
        ConstSizedBox(高度：12),
FilledButton.icon(
onPressed：()=>_showAddDialog(上下文)，
图标：Const图标(Icons.add)，
标签：Const文本('录入最新一期开奖号'),
        ),
        ConstSizedBox(高度：16),
        Const文本('历史开奖记录'，样式：TextStyle(fontWeight:FontWeight.w600))，
        ConstSizedBox(高度：8),
...draws.take(30).map((d)=>卡(
边缘：ConstEdgeInsets.symmetric(垂直：3)，
子项：填充(
填充：ConstEdgeInsets.fromLTRB(12, 8, 4, 8),
子项：行(
crossAxisAlignment:CrossAxisAlignment.start，
儿童：[
SizedBox(
宽度：76,
子项：填充(
填充：ConstEdgeInsets.only(顶部：4),
子项：文本('${d.issue}',
样式：TextStyle(fontSize：13，color:Colors.grey[800])),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 3, runSpacing: 3,
                        children: d.nums.map((n) => Ball(n, small: true)).toList(),
                      ),
                    ),
                    if (extraIssues.contains(d.issue))
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        tooltip: '删除（仅手动录入的期号可删）',
                        onPressed: () => widget.store.removeDraw(d.issue),
                      ),
                  ],
                ),
              ),
            )),
如果(draws.length>30)30)
填充(
填充：ConstEdgeInsets.all(8)，8)，
子项：文本('…其余${draws.length-30}期从略'，'...其余${draws.length-30}期从略'，
样式：textStyle(fontSize：12，颜色：颜色.灰色[600]))，600])),
),
      ],
    );
  }

void_showAddDialog(BuildContext上下文){
最终的issueCtrl=TextEditingController()；
最终的numsCtrl=TextEditingController()；
ShowDialog(
上下文：上下文，
builder：(ctx)=>AlertDialog(
标题：Const文本('录入新一期开奖号'),'录入新一期开奖号'),
内容：列(
mainAxisSize:MainAxisSize.min，
儿童：[
文本字段(
控制器：issueCtrl，
keyboardType:TextInputType.number，
inputFormatters：[FilteringTextInputFormatter.digitsOnly]，
装饰：ConstInputDecoration(
labelText：'期号（7位，如2026264）'，边框：OutlineInputBorder())，'期号（7位，如2026264）'子项：常量文本('期号（7位，如2026264）'，边框：OutlineInputBorder())，'期号（7位，如2026264）'子项：常量文本('期号（7位，如2026264）'，边框：OutlineInputBorder())，'期号（7位，如2026264）'子项：常量文本('期号（7位，如2026264）'，边框：OutlineInputBorder())，'期号（7位，如2026264）'子项：常量文本(
            ),
constsizedbox(高度：12)，
文本字段(
控制器：numsCtrl，
keyboardType:TextInputType.number，
装饰：ConstInputDecoration(
labelText：'20个中奖号码(空格或逗号分隔)'，'20个中奖号码(空格或逗号分隔)'，'20个中奖号码(空格或逗号分隔)'，'20个中奖号码(空格或逗号分隔)'，'20个中奖号码(空格或逗号分隔)'，'20个中奖号码(空格或逗号分隔)'，'20个中奖号码(空格或逗号分隔)'，'20个中奖号码(空格或逗号分隔)'，
提示文本：'如：0105122334… '，'如：0105122334… '，'如：0105122334… '，'如：0105122334… '，'如：0105122334… '，'如：0105122334… '，'如：0105122334… '，'如：0105122334… '，
边框：OutlineInputBorder())，
Const
],
),
行动：[
TextButton(
onPressed：()=>导航器。……的(ctx).pop()，共(ctx).pop()，
子项：常量文本('取消')，常量文本('取消'),'取消')，常量文本('取消'),'取消')，常量文本('取消'),'取消')，常量文本('取消'),
          ),
FilledButton(
onPressed：(){
最终问题=int.TryParse(issueCtrl.text)？？0；最终发出=int.TryParse(issueCtrl.text)？？0；
最终的NUMs=RegExp(R'\d+')最终的NUMs=RegExp(R'\d+')'\d+')最终的NUMs=RegExp(R'\d+')'\d+')最终的NUMs=RegExp(R'\d+')'\d+')最终的NUMs=RegExp(R'\d+')
.all匹配(numsCtrl.text)
.map((m)=>内部分析(m.group(0)！))0)！)0)！))0)！)0)！))0)！)0)！))0)！)
.tolist()；
字符串？犯错；
如果(问题<2020001)err='期号格式不正确'；if(发布<2020001)err='期号格式不正确'；2020001)err='期号格式不正确'；if(发布<2020001)err='期号格式不正确'；2020001)err='期号格式不正确'；if(发布<2020001)err='期号格式不正确'；2020001)err='期号格式不正确'；if(发布<2020001)err='期号格式不正确'；
最终的设置=nums.toSet()；final设置=nums.toSet()；
如果(nums.长度！=20||设置.长度！=20||如果(nums.长度！=20||设置.长度！=20||20||设置.长度！=20||如果(nums.长度！=20||设置.长度！=20||20||设置.长度！=20||如果(nums.长度！=20||设置.长度！=20||20||设置.长度！=20||如果(nums.长度！=20||设置.长度！=20||
设施.任何((n)=>n<1||n>80)){设置.((n)=>n<1||n>80)){1||n>80)){设置.任何((n)=>n<1||n>80)){1||n>80)){设置.((n)=>n<1||n>80)){1||n>80)){设置.任何((n)=>n<1||n>80)){
犯错='需要恰好20个不重复的1-80号码'；'需要恰好 20 个不重复的 1–80 号码';'需要恰好20个不重复的1-80号码'； '需要恰好 20 个不重复的 1–80 号码';'需要恰好20个不重复的1-80号码'；'需要恰好 20 个不重复的 1–80 号码'; '需要恰好20个不重复的1-80号码'；'需要恰好 20 个不重复的 1–80 号码';
              }
如果(err！=无效的){如果(err！=无效的){
脚手架使者。……的(上下文)……的(上下文)
.showSnackBar(SnackBar(内容：文本(错误)))；
返回；返回；
              }
widget.store.addDraw(Draw(issue，nums))；
领航员。……的(ctx).pop()；共(ctx).pop()；
脚手架使者。……的(上下文)……的(上下文)
.showSnackBar(常量零食吧(内容：文本('已保存')；Const SnackBar(内容：文本('已保存')))；'已保存')；Const SnackBar(内容：文本('已保存')))；'已保存')；Const SnackBar(内容：文本('已保存')))；'已保存')；Const SnackBar(内容：文本('已保存')))；
            },
子项：常量文本('保存')，常量文本('保存'),'保存')，常量文本('保存'),'保存')，常量文本('保存'),'保存')，常量文本('保存'),
          ),
        ],
      ),
    );
  }
}
