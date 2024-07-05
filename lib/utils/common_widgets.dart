import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/constants/numbers.dart';
import 'package:todolist_with_riverpod/constants/strings.dart';

//Representation du logo
Widget logo(){
  return Container(
    decoration: const BoxDecoration(
      color: primary,
      borderRadius: BorderRadius.all(Radius.circular(radiusLogo)),
    ),
    padding: const EdgeInsets.all(paddingLogo),
    width: logoSize,
    height: logoSize,
    child: const Column(
      children: [
        Icon(
          Icons.task_alt,
          color: secondary,
        ),
        Text(
          appName,
          style: TextStyle(color: secondary,fontSize: 10),
        )
      ],
    )
  );
}


Widget texEditingField(
    {
      required BuildContext context,
      required  TextEditingController ctrl,
      required String label,
      required int maxLines,
      required FocusNode focusNode,
      required TextInputAction textInputAction,
      required void Function(String value) onChanged,
      required String? Function(String?) validator,
      required void Function(String) onFieldSubmitted,
      bool focused=false
    })
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,style: Theme.of(context).textTheme.headlineSmall,),
      TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      autofocus: focused,
      cursorColor: primary,
      style: Theme.of(context).textTheme.bodyLarge,
      focusNode: focusNode,
      scrollPhysics: BouncingScrollPhysics(),
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        errorBorder: _inputBorder(borderColor: danger),
        enabledBorder: _inputBorder(borderColor: black),
        focusedBorder: _inputBorder(borderColor: primary),
        focusedErrorBorder: _inputBorder(borderColor: danger)),
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted)

  ],);

}


ElevatedButton elevatedButton(
  {required String label,
    required VoidCallback? action,
    Color? background,
    required icon,
    required iconColor,
    required colorText,
    Color borderColor=primary
  }){
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: background,
      side: BorderSide(color: borderColor)
    ),
    icon: Icon(icon,color: iconColor,),
    onPressed: action,
    label: Text(label,style: TextStyle(color: colorText),),
  );
}


OutlineInputBorder _inputBorder({required Color borderColor}){
  return OutlineInputBorder(
    borderSide: BorderSide(
      width: borderSideTextInput,
      color: borderColor
    ),
    borderRadius: BorderRadius.all(Radius.circular(roundedTextInput)),
  );
}


Widget getGif(GifController controller,double gifSize,String fileName){
  return SizedBox(
    width: gifSize,
    height: gifSize,
    child: Gif(
      controller: controller,
      width: gifSize,
      height: gifSize,
      duration: Duration(seconds: 2),
      autostart: Autostart.once,
      placeholder: (context) =>
      const Center(child: CircularProgressIndicator()),
      image:  AssetImage('assets/images/$fileName.gif'),
    ),
  );
}

Widget getContentCta({required BuildContext context,required String screenMode}){
  double sizedBox1=15.0;
  double sizedBox2=121.0;

  double ctaWidth=ctaButtonnWidth;

  if(screenMode == "l"){
    sizedBox1=10;
    sizedBox2=60;
    ctaWidth=ctaButtonnWidthLandscape;
  }
  return Container(
    width: 315,
    child: Column(
    children: [
      Text(welcome,style: Theme.of(context).textTheme.headlineLarge,),
      SizedBox(height: sizedBox1,),
      Text(startTextCta,
        style: Theme.of(context).textTheme.bodyLarge,
        maxLines: 4, textAlign: TextAlign.justify,
        overflow: TextOverflow.visible,

      ),
      SizedBox(height: sizedBox2,),
      ElevatedButton(
          onPressed: (){
            context.replace('/task');
          },
          style:ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(roundedCardTask)
              ),
              minimumSize: Size(ctaWidth, ctaButtonnHeight)

          ),
          child: Text(startNow,style: Theme.of(context).textTheme.labelLarge,))
    ],
  ));
}