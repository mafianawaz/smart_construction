import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    // Define disabled color
    final Color bgColor = isDisabled
        ? Colors.grey.shade400
        : (color ?? AppColors.primaryOrange);

    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(.12),
              blurRadius: 10,
              offset: const Offset(0, 7),
            )
          ]
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: isDisabled ? 0 : 5,
          padding: const EdgeInsets.symmetric(vertical: 17),
          shadowColor: Colors.black.withOpacity(isDisabled ? 0 : 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}


class CustomIconButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;

  const CustomIconButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    // Define disabled color
    final Color bgColor = isDisabled
        ? Colors.grey.shade400
        : (color ?? AppColors.primaryOrange);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(.12),
              blurRadius: 10,
              offset: const Offset(0, 7),
            )
          ]
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: isDisabled ? 0 : 5,
          shadowColor: Colors.black.withOpacity(isDisabled ? 0 : 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, color: Colors.white,width: 18, height: 18,),
            SizedBox(width: 10,),
            Text(text, style: const TextStyle(fontSize: 16, color: Colors.white),),
          ],
        ),
      ),
    );
  }
}