import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/screens/home/event_card.dart';
import 'package:cafe_app/widgets/custom_widgets.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/apiFile.dart';
import '../../components/dimensions.dart';
import '../../services/api_response.dart';
import '../../services/event_service.dart';
import 'home.dart';

class EventBody extends StatefulWidget {
  const EventBody({super.key});

  @override
  State<EventBody> createState() => _EventBodyState();
}

class _EventBodyState extends State<EventBody> {
  PageController pageController = PageController(viewportFraction: 0.89);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;
  List<dynamic> _eventsList = [].obs;
  bool _loading = true;
  int dotCount= 1;
  
  @override
  void initState() {
    super.initState();
    retrieveEvents();
    pageController.addListener(() { 
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

   Future<void> retrieveEvents() async{
    ApiResponse response = await getEvents();
    if(response.error == null)
    {
      setState(() {
        _eventsList = response.data as List<dynamic>;
        print("EventList Length");
        dotCount =_eventsList.length;
        print(dotCount);
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if(response.error == ApiConstants.unauthorized){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                      builder: (context) => Home()
                                                                ), 
                                                (route) => false);
     
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }
   

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Column(
      children: [
        Container(
            height: Dimensions.pageView-40,
            child: PageView.builder(
              controller: pageController,
              itemCount: _eventsList.length,
              itemBuilder: ((context, index) {
               
                 Matrix4 matrix = new Matrix4.identity();
                  if(index == _currPageValue.floor()){
                      var currScale = 1-(_currPageValue-index)*(1-_scaleFactor);
                      var currTrans = _height * (1-currScale)/2;
                      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);

                  }else if(index == _currPageValue.floor()+1){
                      var currScale = _scaleFactor+(_currPageValue-index+1)*(1-_scaleFactor);
                      var currTrans = _height * (1-currScale)/2;
                      //matrix = Matrix4.diagonal3Values(1, currScale, 1);
                      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);

                  }else if(index == _currPageValue.floor()-1){
                      var currScale = 1-(_currPageValue-index)*(1-_scaleFactor);
                      var currTrans = _height * (1-currScale)/2;
                      //matrix = Matrix4.diagonal3Values(1, currScale, 1);
                      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
                  }
                  else{
                      var currScale = 0.8;
                      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height*(1-_scaleFactor)/2, 1);
                  }
                return EventCard(event: _eventsList[index], matrix: matrix,);
              }
              ),
        )),
        DotsIndicator(
          dotsCount: dotCount,
          position: _currPageValue,
          decorator: DotsDecorator(
            color: iconColors4.withOpacity(0.3),
            activeColor: iconColors4,
            size: const Size.square(6.0),
            activeSize: const Size(10.0, 7.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius5)),
          ),
        )
      ],
    );
  }
}