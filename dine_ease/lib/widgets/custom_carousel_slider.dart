import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarouselSlider extends StatefulWidget {
  final List<String> images;
  CustomCarouselSlider({super.key, required this.images});

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
              items: widget.images.map((e) => Container(
                color: Colors.white,
                child: Image.asset(e, fit: BoxFit.contain),
                )
              ).toList(),
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 16/9,
                viewportFraction: 1,
                onPageChanged: (index, reason) => {
                  setState(() {
                    _current = index;
                  })
              },
            ),
            ),
          ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.map((e) {
            int index = widget.images.indexOf(e);
            return Container(
              width: 6,
              height: 6,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index ?
                  Colors.orange[700] : Colors.grey
              ),
            );
          }
        ).toList(),
        )

      ],
    );
  }
}