import 'package:cafe_app/screens/menu/coffee_card.dart';
import 'package:flutter/material.dart';

 class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20),
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 620,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.menu,color: Colors.white,),
                      ),
                      // Image.asset("Images/cafe3.jpg",
                      //       height: 50,
                      //       width: 50,
                      //   )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Find Best Cafe for you", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 6.8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15),
                     ),
                     child: TextField(
                      decoration: InputDecoration(
                        hintText: "Find your Coffee...",
                        hintStyle: TextStyle(
                          color: Colors.white
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search,color: Colors.grey[600],)
                        ),
                     )
                     ,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TabBar(
                    controller: tabController,
                    isScrollable: true,
                    labelColor: Color(0xffd17842),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelColor: Color(0xff3c4846),
                    indicator: CircleTabIndicator(color: Color(0xffd17842), radius : 4),
                    tabs: [
                      Tab(
                        text: "Table",
                      ),
                      Tab(
                        text: "Conference",
                      ),
                      Tab(
                        text: "Coffee & Convo",
                      ),
                      Tab(
                        text: "Entire Floor",
                      )
                    ]
                  ),
                  CoffeeCard(),
                ],
              ),
            )
          ],
        )),
    );
  }
}

class CircleTabIndicator extends Decoration{
  late final BoxPainter _painter;

  // ignore: non_constant_identifier_names
  CircleTabIndicator({required Color color, required double radius}):
            _painter= _CirclePainter(color,radius);

  
  @override
  BoxPainter createBoxPainter([ VoidCallback? onChanged]) => _painter;

}

class _CirclePainter extends BoxPainter{
    late final Paint _paint;
    late double radius;

    _CirclePainter(Color color, this.radius): _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

    @override
    void paint(Canvas canvas, Offset offset, ImageConfiguration configuration){
          final Offset circleOffset = offset + Offset(configuration.size!.width / 2, configuration.size!.height - radius);
          canvas.drawCircle(circleOffset, radius, _paint);
    }
}