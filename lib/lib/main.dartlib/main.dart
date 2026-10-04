import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class Draw {
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

//模式二参数
int m2play=10；
int oddMode=0；//0不限1奇多2偶多3全奇4全偶
最终sumMinCtrl=TextEditingController(文本：'700')；
最终sumMaxCtrl=TextEditingController(文本：'950')；
final Set<int>include={}；
final Set<int>exclude={}；
int maxConsec=3；//0=不限
int prefer=1；//0偏热1均衡2偏冷
int m2sets=3；
list<List<int>>results2=[]；
int m2found=0；

静态常量strategyLabels={'hot'：'热号加权'，'冷“：”冷号遗漏'，'混合“：”均衡混合'，'Rand'：'纯随机'}；
静态常数playLabels=['选一'，'选二'，'选三'，'选四'，'选五'，'选六'，'选七'，'选八'，'选九'，'选十']；

列出<double>重量(Stats st){
交换机(策略){
案例“热”：
返回st.freq.map((f)=>f.toDouble()+0.5).toList()；
案例“冷”：
返回st.nisplion.map((o)=>o.toDouble()+0.5).toList()；
案例“rand”：
返回列表.filled(80，1.0)；
默认：//mix
        return List.generate(80, (i) => st.mixScore(i) + 0.1);
    }
  }

void genMode1(){
最终st=统计数据(widget.store.draws，win)；
最终w=重量for(st)；
final see=<String>{}；
final out=<List<int>>[]；
while(out.length<SetCount){
final s=weightedPick(play，w，rng)；
最终键=s.join('，')；
if(see.add(key))out.add；
    }
setState(()=>results=out)；
  }

bool validM2(列表<int>s){
如果(包括。isNotEmpty&&！包括。every(s.contains)返回false；
if(exclude.any(s.contains))返回false；
最终总和=s.fold<int>(0，(a，b)=>a+b)；
final min=int.TryParse(sumMinCtrl.text)？？0；
final max=int.TryParse(sumMaxCtrl.text)？？9999；
if(sum<min||sum>max)返回false；
最终奇数=s.where((n)=>n.isOdd).length；
开关(oddMode){
情况1:if(odd*2<=s.length)返回false；break；
情况2:if(odd*2>=s.length)返回false；break；
情况3:if(odd！=s.length)返回false；break；
情况4:if(odd！=0)返回假；中断；
    }
if(maxConsec>0){
var运行=1；
for(var i=1；i<s.length；i++){
if(s[i]==s[i-1]+1){run++；if(run>maxConsec)返回false；}
否则运行=1；
      }
    }
    return true;
  }

double scoreM2(List<int>s，Stats st){
开关(首选){
用例0:return s.fold<double>(0，(a，n)=>a+st.freq[n-1])；
情况2：返回s.fold<double>(0，(a，n)=>a+st.省略[n-1])；
默认值：返回s.fold<double>(0，(a，n)=>a+st.mixScore(n-1))；
    }
  }

void genMode2(){
final st=Stats(widget.store.draws，60)；
最终制服=填表(80，1.0)；
final cands=<String，List<int>>{}；
为(变量i=0；i<20000&&cads.Length<500；i++){
最终s=weightedPick(m2play，uniform，rng)；
if(validM2(s))cands[s.join('，')]=s；
    }
最终列表=cads.values.toList()
..sort((a，b)=>scoreM2(b，st).compareTo(scoreM2(a，st))；
setState((){
m2found=list.length；
results2=list.take(m2sets).toList()；
    });
  }

小组件sectionTitle(字符串t)=>填充(
填充：Const EdgeInsets.only(上：16，下：8)，
子项：文本(t，样式：constTextStyle(fontWeight:FontWeight.w600))，
      );

widget chipRow<T>(列表<T>值，T曲线，字符串函数(T)标签，void函数(T)ONTAP){
退货包装(
间距：8，
运行间距：8，
子级：values.map((v){
最终开启=v==cur；
返回ChoiceChip(
标签：文本(标签(v))，
已选择：打开，
在……之上 selected：(_)=>setState(()=>ONTAP(v))，
        );
}).toList()，
    );
  }

@override
小部件生成(BuildContext上下文){
返回ListView(
填充：常量EdgeInsets.all(16)，
儿童：[
SegmentedButton<bool>(
线段：常数[
ButtonSegment(值：false，标签：文本('模式一·智能分析推荐'))，
ButtonSegment(值：正确，标签：文本('模式二·按我的要求推荐'))，
          ],
已选择：{mode2}，
onSelectionChanged：(s)=>setState(()=>mode2=s。第一)，
        ),
Const SizedBox(高度：8)，
Mode2-BuildMode2()：buildMode1()，
      ],
    );
  }

widget buildMode1(){
返回列(
crossAxisAlignment:CrossAxisAlignment.start，
儿童：[
sectionTitle('推荐策略')，
chipRow(strategyLabels.keys.tolist()，strategy，(k)=>strategyLabels[k]！，(v)=>策略=v)，
sectionTitle('数据窗口')，
chipRow([30，60，90]，win，(v)=>'$v期'，(v)=>win=v)，
sectionTitle('玩法')，
chipRow(List.generate(10，(i)=>i+1)，play，(v)=>playLabels[v-1]，(v)=>play=v)，
sectionTitle('生成组数')，
chipRow([1，2，3，5]，SetCount，(v)=>'$v组'，(v)=>SetCount=v)，
Const SizedBox(高度：16)，
SizedBox(
宽度：double.finity，
子项：FilledButton.icon(
onPressed:genMode1，
图标：常量图标(icons.auto_awesome)，
标签：常量文本('生成参考号码')，
          ),
        ),
if(results.isNotEmpty)...[
Const SizedBox(高度：12)，
...结果。asMap()。条目。map((e)=>SetCard(索引：e.key，nums:e.value))，
        ],
Const SizedBox(高度：16)，
文本(
'回测提示：对近 60 期滚动回测显示，随机选 20 码平均命中 5.03，热号 4.93，'
          '遗漏 5.22，混合 5.18——各策略与随机无显著差异。每期开奖独立随机，结果仅供娱乐参考。',
样式：textStyle(字体大小：12，颜色：颜色.灰色[600]，高度：1.5)，
        ),
      ],
    );
  }

widget buildMode2(){
返回列(
crossAxisAlignment:CrossAxisAlignment.start，
儿童：[
sectionTitle('玩法')，
chipRow(List.generate(10，(i)=>i+1)，m2play，(v)=>playLabels[v-1]，(v)=>m2play=v)，
sectionTitle('奇偶要求')，
chipRow([0，1，2，3，4]，oddMode，(v)=>['不限'，'奇数偏多'，'偶数偏多'，'全奇'，'全偶'][v]，(v)=>oddMode=v)，
sectionTitle('和值范围（20码理论均值810）')，
行(子级：[
扩大(
子项：文本字段(
控制器：sumMinCtrl，
keyboardType:TextInputType.number，
inputFormatters：[FilteringTextInputFormatter.digitsOnly]，
装饰：常量InputDecoration(labelText：'最小和值'，边框：OutlineInputBorder())，
            ),
          ),
Const SizedBox(宽度：12)，
扩大(
子项：文本字段(
控制器：sumMaxCtrl，
keyboardType:TextInputType.number，
inputFormatters：[FilteringTextInputFormatter.digitsOnly]，
装饰：常量InputDecoration(labelText：'最大和值'，边框：OutlineInputBorder())，
            ),
          ),
        ]),
sectionTitle('胆码（必选，已选${include.length}个）')，
numToggleGrid(包括)，
sectionTitle('杀号（排除，已选${exclude.length}个）')，
numToggleGrid(排除)，
sectionTitle('连号上限（最多连续几个）')，
chipRow([0，1，2，3，4]，maxConsec，(v)=>v==0？'不限'：'$v个'，(v)=>maxConsec=v)，
sectionTitle('号码偏好（在满足条件的组合中优先）')，
chipRow([0，1，2]，优选，(v)=>['偏热号'，'均衡'，'偏冷号'][v]，(v)=>prefer=v)，
sectionTitle('生成组数')，
chipRow([1，2，3，5]，m2sets，(v)=>'$v组'，(v)=>m2sets=v)，
Const SizedBox(高度：16)，
SizedBox(
宽度：double.finity，
子项：FilledButton.icon(
onPressed:genMode2，
图标：常量图标(icons.auto_awesome)，
标签：常量文本('按条件生成')，
          ),
        ),
如果(results2.isNotEmpty)...[
Const SizedBox(高度：12)，
文本('共找到$m2ound组符合条件的组合，以下为其中最优${results2.length}组：'，
样式：textStyle(fontSize:13，colors:Colors。灰色[700])，
...结果2.AsMap().条目.map((e)=>SetCard(索引：e.key，nums:e.value))，
]其他如果(m2found==0&&results2.isEmpty)...[
Const SizedBox(高度：12)，
Const文本('没有找到符合条件的组合，请放宽条件（如扩大和值范围、减少胆码）。'),
        ],
      ],
    );
  }

小组件numToggleGrid(设置<int>sel){
最终方案=主题；(上下文)；色彩模式；
返回GridView.builder(
包覆面提取：真，
物理：Const NeverScrollableScrollPhysics()，
gridDelegate:ConstSliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount：10，mainAxisSpacing：4，crossAxisSpacing：4，childAspectRatio：1)，
itemCount:80，
itemBuilder：(_，i){
最终n=i+1；1；
最终的在……之上=sel.包含(n)；
返回手势检测器(
ONTAP：()=>setState(()=>on？sel.remove(n)：sel.add(n))，
子项：容器(
装饰：BoxDecoration(
形状：BoxShape.circle，
颜色：开？ 计划。 主要：计划。 曲面变量，
边框：边框.all(颜色：开？计划。主要：scheme.outline变量)，
            ),
子项：中心(
子项：文本(两(n)，
样式：textStyle(
字体大小：11，
fontWeight:FontWeight.w600，
颜色：在？ 颜色上。 白色：计划。 在表面上，
                  )),
            ),
          ),
        );
      },
    );
  }
}

///=====================走势统计页=====================
类TrendPage扩展StatefulWidget{
最终DrawStore存储；
Const TrendPage({超级.钥匙，必填这.商店})；
@override
状态<TrendPage>createState()=>_TrendPageState()；
}

class_TrendPageState扩展状态<趋势页面>{
int win=60；

@override
小部件生成(BuildContext上下文){
最终绘制=widget.store.draws；
如果(draws.isEmpty)返回常量中心(子级：文本('暂无数据'))；'暂无数据'))；'暂无数据'))；
最终st=统计数据(平局，获胜)；
最后一个=draws.first；
最终的odd=last.nums.where((n)=>n.isOdd).length；
最终平均值=win*0.25；0.25；0.25；0.25；
最终SD=sqrt((列表。产生(80，(i)=>功率(st.freat率[i]-平均值，2)).减少((a，b)=>a+b)/80).到两倍的())；80，(i)=>功率(st.freat率[i]-平均值，2)).减少((a，b)=>a+b)/80).到两倍的())；80，(i)=>功率(st.freat率[i]-平均值，2)).减少((a，b)=>a+b)/80).到两倍的())；80，(i)=>功率(st.freat率[i]-平均值，2)).减少((a，b)=>a+b)/80).到两倍的())；

@override
最终的omIdx=列表<int>。生成(80，(i)=>i)..排序((a，b)=>st.省略[b].比较到(st.省略[a]))；80，(i)=>i)..sort((a，b)=>st.省略[b].比较到(st.省略[a]))；80，(i)=>i)..sort((a，b)=>st.省略[b].比较到(st.省略[a]))；80，(i)=>i)..sort((a，b)=>st.省略[b].比较到(st.省略[a]))；

返回ListView(
填充：常量EdgeInsets.all(16)，16)，16)，16)，
儿童：[
行(
儿童：[
常量文本('统计窗口'，样式：textStyle(fontWeight：字体粗细。w600))，'统计窗口'，样式：textStyle(fontWeight:FontWeight.w600))，'统计窗口'，样式：textStyle(fontWeight:FontWeight.w600))，'统计窗口'，样式：textStyle(fontWeight:FontWeight.w600))，
Const SizedBox(宽度：12)，
...[30，60，90].map((w)=> 填充(30，60，90].map((w)=> 填充(30，60，90].map((w)=> 填充(
填充：Const EdgeInsets.only(右侧：8)，
子项：ChoiceChip(
标签：文本('$w期')，'$w期')，
已选择：win==w，
onselected：(_)=>setState(()=>win=w)，
                  ),
                )),
          ],
        ),
Const SizedBox(高度：8)，
卡片(
子项：填充(
填充：常量EdgeInsets.all(12)，12)，12)，12)，
子项：列(
crossAxisAlignment:CrossAxisAlignment.start，
儿童：[
文本('最新一期第${last.issue}期'，'最新一期第${last.issue}期'，'最新一期第${last.issue}期'，'最新一期第${last.issue}期'，
风格：ConsttextStyle(fontWeight:FontWeight.W600))，const textStyle(fontWeight:FontWeight.W600))，
Const SizedBox(高度：8)，
包(
间距：5，运行间距：5，
children:last.nums.map(n)=>Ball(n，小：正确)).tolist()，true)).toList()，
                ),
Const SizedBox(高度：8)，
文本('偶$奇数：${20奇怪的}·和值${last.NUMs.fold<int>(0，(a，b)=>a+b)}'，'偶$奇数：${20奇怪的}·和值${last.NUMs.fold<int>(0，(a，b)=>a+b)}'，'偶$奇数：${20奇怪的}·和值${last.NUMs.fold<int>(0，(a，b)=>a+b)}'，'偶$奇数：${20奇怪的}·和值${last.NUMs.fold<int>(0，(a，b)=>a+b)}'，
样式：textStyle(fontSize：样式：textStyle(fontSize：12，colors.grey[700])，，颜色：颜色。 灰色[700])，13，颜色：颜色。 灰色[700])，13，颜色：颜色。 灰色[700])，13，颜色：颜色。 灰色[700])，
              ],
            ),
          ),
        ),
Const SizedBox(高度：16)，
常量文本('冷热热力图'，样式：textStyle(fontWeight：字体粗细。w600))，'冷热热力图'，样式：textStyle(fontWeight:FontWeight.w600))，'冷热热力图'，样式：textStyle(fontWeight:FontWeight.w600))，'冷热热力图'，样式：textStyle(fontWeight:FontWeight.w600))，
Const SizedBox(高度：4)，
文本('红=低于均值(冷)蓝=高于均值(热)，窗口内理论均值${mean.toStringAsFixed(1)}次'，'红=低于均值(冷)蓝=高于均值(热)，窗口内理论均值${mean.toStringAsFixed(1)}次'，
样式：textStyle(fontSize:12，颜色。灰色[600])，12，颜色，灰色[600])，600])，12，颜色，灰色[600])，
Const SizedBox(高度：8)，
GridView.builder(
包覆面提取：真，
物理：Const NeverScrollableScrollPhysics()，
gridDelegate:ConstSliverGridDelegateWithFixedCrossAxisCount(ConstSliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount：10，mainAxisSpacing：3，crossAxisSpacing：3，childAspectRatio：1)，10，mainAxisSpacing:3，crossAxisSpacing：3，childAspectRatio：1)，3，crossAxisSpacing：3，childAspectRatio：1)，
itemCount：80，80，
itemBuilder：(_，i){{
最终Z=sd==0？0.0：(st.freq[i]-平均值)/sd；0？0.0：(st.freq[i]-平均值)/sd；0？0.0：(st.freq[i]-平均值)/sd；0？0.0：(st.freq[i]-平均值)/sd；
最终强度=min(0.55，z.abs()*0.32)；0.55，z.abs()*0.32)；
最终热态=z>0.3；0.3；0.3；0.3；
最终冷量=z<-0.3；0.3；0.3；0.3；
最终c=热色。蓝色：彩色。红色；
返回容器(
装饰：BoxDecoration(
形状：BoxShape.circle，
颜色：(热||冷)？c.不透明度(强度)：颜色。透明的，
边框：边框.all(颜色：colors.grey[300]！)，300]！)，300]！)，300]！)，
),
子项：中心(
子项：文本(二(i+1)，1)，1)，1)，
样式：textStyle(字体大小：10，颜色：灰色[800])，800])，800])，800])，
),
            );
          },
        ),
Const SizedBox(高度：16)，
常量文本('热号前10'，样式：textStyle(fontWeight:FontWeight.w600))，'热号前10'，样式：textStyle(fontWeight:FontWeight.w600))，
...hotIdx.take(10).map((i)=>rankRow(10).map((i)=>rankRow(
我+1，st.req[i]，st.freq[hotIdx[0]]，颜色。蓝色，'次'))，1，st.req[i]，st.freq[hotIdx[0]]，颜色。蓝色，'次'))，
Const SizedBox(高度：12)，
常量文本('当前遗漏Top10(理论平均遗漏3期)'，'当前遗漏Top10(理论平均遗漏3期)'，
样式：TextStyle(fontWeight:FontWeight.w600))，
...omIdx.take(10).map((i)=>rankRow(10).map((i)=>rankRow(
我+1，st.省略[i]，st.省略[omIdx[0]]，颜色。红色，'期')，1，st.省略[i]，st.省略[omIdx[0]]，颜色。红色，'期'))，
Const SizedBox(高度：16)，
常量文本('近10期开奖'，样式：textStyle(fontWeight:FontWeight.w600))，
Const SizedBox(高度：8)，
...draws.take(10).map((d)=>填充(
填充：Const EdgeInsets.symmetric(垂直：4)，
子项：行(
crossAxisAlignment:CrossAxisAlignment.start，
儿童：[
SizedBox(
宽度：76，
子级：文本("${d.issue}"，
样式：textStyle(fontSize：12，colors.grey[700])，
                  ),
扩大(
子项：换行(
，样式：textStyle(fontWeight:FontWeight.w600))，
文本(
'红=低于均值(冷)蓝=高于均值(热)，窗口内理论均值
Const SizedBox(高度：8)，
次'
              ),
            )),
      ],
    );
  }

小工具rankRow(int n，int v，int MaxV，颜色c，字符串单位){
回路填料(
填充：Const EdgeInsets.symmetric(垂直：3)，
子项：行(
儿童：[
球(n，小：真，颜色：c)，
Const SizedBox(宽度：8)，
扩大(
子项：ClipRect(
borderRadius:BorderRadius.circular(3)，
子项：线性进度指示器(
值：MaxV==0？0:v/MaxV，
最小高度：6，
backgroundColor:Colors.grey[200]，
valueColor:AlwaysStoppedAnimation(c.withOpacity(0.7))，
              ),
            ),
          ),
SizedBox(
宽度：56，
).map((i)=>rankRow(
textAlign:TextAlign.right，
样式：textStyle(fontSize:12，colors.grey[700])，
          ),
        ],
      ),
    );
  }
}

///=====================数据管理页=====================
类数据页扩展StatefulWidget{
最终DrawStore存储；
Const数据页({super.key，required this.store})；
@override
state<datapage>createState()=>_DataPageState()；
}

class_DataPageState扩展状态<datapage>{
@override
小部件生成(BuildContext上下文){
最终绘制=widget.store.draws；
最终的extraIssues=绘图。其中((d)=>！parseDraws(kEmbeddedRaw)。任何((e)=>e.issue==d.问题))。map((d)=>d.问题)。toset()；
返回ListView(
填充：Const EdgeInsets.all(16)，
儿童：[
卡片(
子项：填充(
填充：Const EdgeInsets.all(12)，
子项：列(
crossAxisAlignment:CrossAxisAlignment.start，
儿童：[
text('数据范围：第${draws.最后的。issue}-${draws。第一。问题}期·共${draws.length}期'，
style:const TextStyle(fontWeight:FontWeight.w600))，
Const SizedBox(高度：8)，
文本(
                    '内置 90 期官方开奖数据。每天开奖后可在下方手动录入最新一期，'
                    '数据保存在本机，无需联网。新录入的期号若与内置重复会自动覆盖。',
样式：textStyle(字体大小：13，颜色：颜色.灰色[700]，高度：1.5)，
              ],
            ),
          ),
        ),
Const SizedBox(高度：12)，
FilledButton.icon(
onPressed：()=>_showAddDialog(上下文)，
图标：常量图标(Icons.add)，
标签：常量文本('录入最新一期开奖号')，
        ),
Const SizedBox(高度：16)，
常量文本('历史开奖记录'，样式：textStyle(fontWeight:FontWeight.w600))，
Const SizedBox(高度：8)，
...draws.take(30).map((d)=>卡(
边距：Const EdgeInsets.symmetric(垂直：3)，
子项：填充(
填充：来自LTRB(12，8，4，8)的Const EdgeInsets，
子项：行(
crossAxisAlignment:CrossAxisAlignment.start，
儿童：[
SizedBox(
宽度：76，
子项：填充(
填充：Const EdgeInsets.only(顶部：4)，
子级：文本("${d.issue}"，
样式：textStyle(fontSize:13，colors.grey[800])，
                      ),
                    ),
扩大(
子项：换行(
间距：3，管路间距：3，
children:d.nums.map((n)=>Ball(n，small:true)).toList()，
                      ),
                    ),
if(extraIssues.contains(d.issuence))
图标按钮(
图标：常量图标(Icons.delete_outline，大小：18)，
工具提示：‘删除（仅手动录入的期号可删）'，
onPressed：()=>小工具。商店。removeDraw(d.问题)，
                      ),
                  ],
                ),
              ),
            )),
if(draws.length>30)
填充(
填充：Const EdgeInsets.all(8)，
子项：文本('…其余${draws.length-30}期从略'，
样式：textStyle(fontSize:12，colors.grey[600])，
          ),
      ],
    );
  }

void_showAddDialog(BuildContext上下文){
final issueCtrl=TextEditingController()；
final numsCtrl=TextEditingController()；
ShowDialog(
上下文：上下文，
builder：(ctx)=>AlertDialog(
标题：常量文本('录入新一期开奖号')，
内容：列(
mainAxisSize:MainAxisSize.min，
儿童：[
文本字段(
控制器：issueCtrl，
keyboardType:TextInputType.number，
inputFormatters：[FilteringTextInputFormatter.digitsOnly]，
装饰：Const InputDecoration(
labelText：'期号(7位，如2026264)'，border:OutlineInputBorder())，
            ),
Const SizedBox(高度：12)，
文本字段(
控制器：numsCtrl，
keyboardType:TextInputType.number，
装饰：Const InputDecoration(
labelText：'20个中奖号码(空格或逗号分隔)'，
提示文本：'如：0105122334… '，
边框：OutlineInputBorder())，
),
],
),
行动：[
TextButton(
onPressed：()=>Navigator.of(ctx).pop()，
子项：常量文本('取消')，
          ),
FilledButton(
onPressed：(){
最终问题=int.TryParse(issueCtrl.text)？？0；
final nums=RegExp(r'\d+')
.all匹配(numsCtrl.text)
.map((m)=>内部分析(m.group(0)！)
.tolist()；
字符串？犯错；
'IF(问题<2020001)err='期号格式不正确'；
final set=nums.toSet()；
if(nums.length！=20||set.length！=20||
set.any((n)=>n<1||n>80)){
err='需要恰好20个不重复的1-80号码'；
              }
if(err！=null){
ScaffoldMessenger.of(上下文)
.showSnackBar(SnackBar(内容：文本(错误)))；
返回；
              }
widget.store.addDraw(Draw(issue，nums))；
Navigator.of(ctx).pop()；
ScaffoldMessenger.of(上下文)
.showSnackBar(常量零食吧(内容：文本('已保存')))；
            },
子项：常量文本('保存')，
          ),
        ],
      ),
    );
  }
}
