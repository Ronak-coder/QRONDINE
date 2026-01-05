import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/category.dart';
import '../../utils/responsive.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(responsive.sp(4)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: responsive.hp(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Category Image
              category.image.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: category.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.category, size: responsive.sp(30)),
                      ),
                    )
                  : Image.asset(
                      category.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.category, size: responsive.sp(30)),
                      ),
                    ),
              
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
              
              // Category Info
              Padding(
                padding: EdgeInsets.all(responsive.sp(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.sp(15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: responsive.sp(3)),
                    Text(
                      '${category.productCount}\nProducts',
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: responsive.sp(11),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
