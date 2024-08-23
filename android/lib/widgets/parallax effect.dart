import 'package:flutter/material.dart';

class ParallaxEffect extends StatefulWidget {
  const ParallaxEffect({super.key});

  @override
  State<ParallaxEffect> createState() => _ParallaxEffectState();
}

class _ParallaxEffectState extends State<ParallaxEffect> {
  PageController pageController = PageController(viewportFraction: 0.8); // Increased viewportFraction

  double pageOffSet = 0;

  // List of image URLs and corresponding text
  final List<Map<String, String>> items = [
    {
      'image': 'https://media.istockphoto.com/id/1060410062/photo/freshly-cooked-french-fries-baked-with-cheddar-cheese-bacon-and-parsley-closeup-horizontal.jpg?s=612x612&w=0&k=20&c=Mn6i6EC67d48u6o7CcLibjl4J2Unwv69gpMpB9eHp5g=',
      'text': 'Delicious Fries',
    },
    {
      'image': 'https://www.willcookforsmiles.com/wp-content/uploads/2024/08/Quesadilla-Burger-horizontal.jpg',
      'text': 'Tasty Burger',
    },
    {
      'image': 'https://www.shutterstock.com/image-photo/closeup-home-made-burgers-fire-600nw-367962215.jpg',
      'text': 'Homemade Burger',
    },
  ];

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        pageOffSet = pageController.page!;
      });
      debugPrint(pageOffSet.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: pageController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          debugPrint("${-pageOffSet.abs() + index}");
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0), // Reduced padding
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 160, // Adjusted to match the SizedBox height
                    child: Image.network(
                      items[index]['image']!, // Load different image for each tile
                      fit: BoxFit.cover,
                      alignment: Alignment(-pageOffSet.abs() + index, 0),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      items[index]['text']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
