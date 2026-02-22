import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

// ! Routing
int currentIndex = 0; // 🌟 Current index for navigation
// ! Routing

// 🧭 Bottom navigation bar icons
List bottomBar = [
  const Icon(
    Ionicons.home_outline, // 🏠 Home icon
    color: Colors.white,
  ),
  const Icon(
    Ionicons.compass_outline, // 🧭 Compass icon for exploration
    color: Colors.white,
  ),
  const Icon(
    Ionicons.bookmark_outline, // 📌 Bookmark icon
    color: Colors.white,
  ),
  const Icon(
    Ionicons.person_outline, // 👤 Profile icon
    color: Colors.white,
  ),
];

// 📍 Travel data with city, country, rating, and image
List data = [
  {
    "city": 'Nassau', // 🏝️ A city in the Bahamas
    "country": 'Bahamas',
    "rating": '4.8', // ⭐ Rating for Nassau
    'image': 'assets/app_travel/nassau.jpg', // 🖼️ Path to the image
  },
  {
    "city": 'Mykonos', // 🌊 Beautiful island in Greece
    "country": 'Greece',
    "rating": '4.5',
    'image': 'assets/app_travel/mykonos.jpg',
  },
  {
    "city": 'Colosseum', // 🏛️ Historic landmark in Rome
    "country": 'Rome',
    "rating": '4.5',
    'image': 'assets/app_travel/rome.jpg',
  },
  {
    "city": 'London', // 🏙️ Iconic city in England
    "country": 'England',
    "rating": '4.9',
    'image': 'assets/app_travel/london.jpg',
  },
];

// 🌟 Additional categories for travel destinations
List data_2 = [
  {
    "name": 'Beach',
    'image': 'assets/app_travel/beach.png'
  }, // 🏖️ Beach category
  {"name": 'Park', 'image': 'assets/app_travel/park.png'}, // 🌳 Park category
  {
    "name": 'Camp',
    'image': 'assets/app_travel/camp.png'
  }, // 🏕️ Camping category
  {
    "name": 'Flaye',
    'image': 'assets/app_travel/flaye.png'
  }, // ✈️ Flight category
  {
    "name": 'Beach',
    'image': 'assets/app_travel/beach.png'
  }, // 🏖️ Repeat Beach category
  {
    "name": 'Park',
    'image': 'assets/app_travel/park.png'
  }, // 🌳 Repeat Park category
  {
    "name": 'Camp',
    'image': 'assets/app_travel/camp.png'
  }, // 🏕️ Repeat Camping category
];

// 🗂️ List of categories for filtering destinations
final categoryList = ['Popular', 'Recommended', 'Most Viewed', 'Most Liked'];

// 🎨 Color palette for the app
const kAvatarColor = Color(0xffe1edf8); // 👤 Avatar background color
const kPrimaryColor = Color(0xFFEEF7FF); // 🌈 Primary background color
const kSecondaryColor = Color(0xFF010917); // 🖤 Secondary text/icon color
