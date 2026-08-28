import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/app_color.dart';
import '../utils/app_icons.dart';

class AppPrimaryBar extends StatelessWidget implements PreferredSizeWidget {
  const AppPrimaryBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBackButton = false,
    this.onBack,
    this.centerTitle = false,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.elevation = 0,
    this.bottom,
    this.height = 64,
  });

  final String? title;
  final String? subtitle;

  final Widget? leading;
  final List<Widget>? actions;

  final bool showBackButton;
  final VoidCallback? onBack;

  final bool centerTitle;

  final Color backgroundColor;
  final Color foregroundColor;

  final double elevation;

  final PreferredSizeWidget? bottom;

  final double height;

  @override
  Size get preferredSize => Size.fromHeight(
    height + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    Widget? effectiveLeading = leading;

    if (effectiveLeading == null && showBackButton) {
      effectiveLeading = Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: AppColors.fieldBorder),
            shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            icon:  Icon(Icons.arrow_back_ios_new_rounded,size: 15,),
            color: foregroundColor,
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      toolbarHeight: height,
      leading: effectiveLeading,
      automaticallyImplyLeading: false,
      actions: actions,
      bottom: bottom,
      title: title == null
          ? null
          : subtitle == null
          ? Text(
        title!,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 12,
              color: foregroundColor.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}


class SecondaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SecondaryAppbar({
    super.key,
    this.onSearchPressed,
    this.onNotificationPressed,
    this.bottom,
    this.height = 64,
  });

  final VoidCallback? onSearchPressed;
  final VoidCallback? onNotificationPressed;
  final PreferredSizeWidget? bottom;

  final double height;

  @override
  Size get preferredSize => Size.fromHeight(
    height + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {

    return AppBar(
      toolbarHeight: height,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(13),
            image: DecorationImage(image: AssetImage(AppImages.person),fit: BoxFit.contain)
          ),
          // child: Image.asset(AppImages.person,),
        ),
        title:  Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Good Morning', style: TextStyle(
                color: AppColors.primaryOrange,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5
            ),),
            SizedBox(width: 5,),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: SvgPicture.asset(AppIcons.morning,height: 15,),
            ),
          ],
        ),
        subtitle: Text('Field Worker', style: TextStyle(
            color: AppColors.textDark,
            fontSize: 15,
            fontWeight: FontWeight.w600,
        ),),

      ),
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            children: [
              InkWell(
                onTap: onSearchPressed,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.fieldBorder),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(child: SvgPicture.asset(AppIcons.search,height: 18,)),
                ),
              ),
              SizedBox(width: 5,),
              InkWell(
                onTap: onNotificationPressed,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.fieldBorder),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(child: SvgPicture.asset(AppIcons.notification,height: 15,)),
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: bottom,
    );
  }
}