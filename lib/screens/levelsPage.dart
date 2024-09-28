import 'package:flutter/material.dart';
import 'package:sign_recognition/screens/quizQuestion.dart';

class levelPage extends StatefulWidget {
  const levelPage({super.key});

  @override
  State<levelPage> createState() => _levelPageState();
}

class _levelPageState extends State<levelPage> {
  final List<int> levels = List.generate(10, (index) => index + 1);
  ScrollController _scrollController = ScrollController();
  double _topBarOpacity = 1.0;

  void initState() {
    super.initState();

    // Scroll listener to change opacity of the top bar
    _scrollController.addListener(() {
      setState(() {
        _topBarOpacity = (_scrollController.offset <= 150)
            ? 1 - (_scrollController.offset / 150)
            : 0;
        _topBarOpacity = _topBarOpacity.clamp(0.0, 1.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title:_topBarOpacity>0.5?const Text(""):const Text("Quiz",style: TextStyle(color: Colors.white,fontSize: 30),),
            expandedHeight: 150.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  const SizedBox(height: 20,),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _topBarOpacity,
                    child: const Center(child: Text("Quiz",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return _buildLevelTile(context, levels[index]);
              },
              childCount: levels.length,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLevelTile(BuildContext context, int level) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          '$level',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      title: Text('Level $level'),
      subtitle: Text('Description or additional info for Level $level'),
      trailing: const CircleAvatar(
        radius: 15,
        backgroundColor: Colors.grey,
          child: Icon(Icons.keyboard_double_arrow_right)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>quizQuestion(level: level)));
      },

    );
  }
}
