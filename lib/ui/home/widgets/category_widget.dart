import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/app_colors.dart';

class CategoryWidget extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryWidget({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          Colors
              .transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: onTap,
        splashColor: AppColors.mainColor.withOpacity(0.3),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 105,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color.fromARGB(255, 107, 11, 162).withOpacity(0.3)
                    : AppColors.lightBackgroundColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color:
                  isSelected
                      ? AppColors.highlightTextColor
                      : AppColors.lightBackgroundColor,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/categories/${category.toLowerCase()}.png',
                height: 40,
              ),
              const SizedBox(height: 6),
              Tooltip(
                message: category,
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color:
                        isSelected
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : AppColors.highlightTextColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
