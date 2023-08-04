import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/screens/home/home_screen.dart';
import 'package:cafe_app/services/api_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/faq_service.dart';
import '../../widgets/custom_widgets.dart';
import '../../components/news_card_skelton.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<dynamic> _faqList = [].obs;
  bool _isLoading = true; // flag to track loading state
  final controller = ScrollController();
  final double itemSize = 150;
  late double opacity;
  late double scale;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = true;
        _loadFaqs();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor, // set background color to black
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _isLoading // show loading spinner if data is loading
            ? ListView.separated(
                itemCount: 5,
                itemBuilder: (context, index) => const NewsCardSkelton(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
              )
            : Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                        itemCount: _faqList.length,
                        controller: controller,
                        itemBuilder: (context, index) {
                          final itemOffset = index * itemSize;
                          final difference = controller.offset - itemOffset;
                          final percent = 1 - (difference / (itemSize / 2));
                          scale = percent;
                          opacity = percent;
                          if (opacity > 1.0) opacity = 1.0;
                          if (opacity < 0.0) opacity = 0.0;
                          if (scale > 1.0) scale = 1.0;
                          return faqs(_faqList[index]);
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 30),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _loadFaqs() async {
    ApiResponse response = await getFaqs(); // call order service to get orders
    if (response.error == null) {
      setState(() {
        _faqList = response.data as List<dynamic>;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = true;
        print("Response Error ______________________________");
        showSnackBar(title: '${response.error}', message: '');
      });
    }
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      centerTitle: false,
      title: Text(
        "FAQS",
        style: TextStyle(color: textColor, fontSize: 18),
      ),
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const HomeScreen()));
        },
        icon:const Icon(Icons.arrow_back),
        color: textColor,
      ),
    );
  }

  faqs(faq) {
    return Opacity(
      opacity: opacity,
      child: Transform(
        transform: Matrix4.identity()..scale(scale, 1.0),
        alignment: Alignment.center,
        child: SizedBox(
          height: itemSize,
          width: double.infinity,
          child: Card(
            color: greyColor9,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 140,
                      width: MediaQuery.of(context).size.width - 50,
                      child: ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${faq['question']}",
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            Text(" ${faq['answer']} ",
                                style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
