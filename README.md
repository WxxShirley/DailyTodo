# DailyTodo

> 上班摸鱼做的小玩具，其中心情贴纸的想法来源于上个月Microsoft Hackthon中同事的Outlook Stickers

## Features
- [x] Show daily todos in calendar mode
- [x] Add mood stickers for everyday
- [x] Store these todos and moods locally
- [x] Support right-slide deletion of todo
 
 
## Run
```
// Run locally
flutter run

// Android package 
flutter build apk
```

## Screenshots

 Screenshot1 | Screenshot2 | Screenshot3 | Screenshot4
 -|-|-|-
 ![sh1](https://github.com/WxxShirley/DailyTodo/blob/master/imgs/screenshot1.png)|![sh2](https://github.com/WxxShirley/DailyTodo/blob/master/imgs/screenshot2.png)|![sh3](https://github.com/WxxShirley/DailyTodo/blob/master/imgs/screenshot3.png)|![sh4](https://github.com/WxxShirley/DailyTodo/blob/master/imgs/screenshot4.png)


## Used Packages
 Name | Version | Usage
 -|-|-
 **emoji_picker** | 0.1.0 | Pick Emoji
 **shared_preferences** | 0.5.10 | Store data **locally** ( `(key,value)` mode)
 **oktoast** | 2.3.2 | Show **customized** toast
 **table_calendar** | 2.2.3 | Show calendar view, **extendable**


## Getting Started

This project is helpful for flutter-beginners,
it covers:
* Store data **locally** with json encode/decode
   > You can also store with sqlite dataset with `sqflite`
* **Abundant flutter widgets**, with (customized)AppBar, Form, modalBottomSheet, Customized-Dialog, Positioned, Dismissble...
* Router, State Management


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

