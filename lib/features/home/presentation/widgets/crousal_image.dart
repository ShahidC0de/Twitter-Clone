import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CrousalImage extends StatefulWidget {
  final List<String> imageLinks;
  const CrousalImage({super.key, required this.imageLinks});

  @override
  State<CrousalImage> createState() => _CrousalImageState();
}

class _CrousalImageState extends State<CrousalImage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
                items: widget.imageLinks
                    .map((image) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          margin: const EdgeInsets.all(10),
                          child: Image.network(
                            image,
                            fit: BoxFit.contain,
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                    height: 400,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    })),
            Row(
              children: widget.imageLinks.asMap().entries.map((e) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == e.key
                        ? Colors.white.withOpacity(0.9)
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }).toList(),
            )
          ],
        )
      ],
    );
  }
}
