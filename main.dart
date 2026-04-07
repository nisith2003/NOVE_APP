import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const NoveApp());
}

class NoveApp extends StatelessWidget {
  const NoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nove Fashion',

      home: SplashScreen(),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1714), // Dark Background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gold Circle Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC5A358), width: 1.5),
              ),
              child: const Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    fontSize: 50,
                    color: Color(0xFFC5A358),
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'N O V E',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                letterSpacing: 6,
              ),
            ),
            const Text(
              'CURATED FASHION',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 50),
            // Loading Bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: LinearProgressIndicator(
                backgroundColor: Color(0xFF212121),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC5A358)),
                minHeight: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
  import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_details.dart';
import 'cart_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'wishlist_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  final List<String> mainCategories = [
    "All",
    "Women",
    "Men",
    "Accessories",
    "Shoes",
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    String currentCategory = mainCategories[selectedCategoryIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "N O V E",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? "Welcome!",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text("My Wishlist"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WishlistScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text("My Cart"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "N O V E",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Controller එක මෙතනට දැම්මා
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Container(
              margin: const EdgeInsets.all(15),
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=1000',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Main Category Bar
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 15, bottom: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mainCategories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategoryIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mainCategories[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: selectedCategoryIndex == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          if (selectedCategoryIndex == index)
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              height: 2,
                              width: 15,
                              color: const Color(0xFFC5A358),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Real-time Product Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: (currentCategory == "All")
                    ? FirebaseFirestore.instance
                          .collection('products')
                          .snapshots()
                    : FirebaseFirestore.instance
                          .collection('products')
                          .where('category', isEqualTo: currentCategory)
                          .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return const Center(child: Text("Error loading products"));
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC5A358),
                      ),
                    );

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty)
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("No items found."),
                      ),
                    );

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                        ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data = docs[index].data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(productData: data),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      data['image'] ??
                                          'https://via.placeholder.com/150',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data['name'] ?? 'No Name',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "LKR ${data['price']}",
                              style: const TextStyle(
                                color: Color(0xFFC5A358),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 50),

            // --- NOVE PREMIUM FOOTER (Working Links) ---
            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
              child: Column(
                children: [
                  const Text(
                    "N O V E",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 70,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 12,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFooterColumn("Shop", [
                        "Men",
                        "Women",
                        "Accessories",
                        "Shoes",
                      ]),
                      _buildFooterColumn("Information", [
                        "Careers",
                        "FAQ",
                        "Shipping Policy",
                        "Contact Us",
                      ]),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    "BE BETTER EVERYDAY",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 10),
                  const Text(
                    "© 2026 NOVE Powered by Octagen",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 1)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          else if (index == 2)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WishlistScreen()),
            );
          else if (index == 3)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // Footer Column Helper (Navigation එකතු කළා)
  Widget _buildFooterColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 20),
        ...items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () {
                    // --- Footer Navigation Logic ---
                    if (title == "Shop") {
                      int index = mainCategories.indexOf(item);
                      if (index != -1) {
                        setState(() {
                          selectedCategoryIndex = index;
                        });

                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                        );
                      }
                    } else if (title == "Information") {
                      if (item == "FAQ" || item == "Contact Us") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductDetailsScreen({super.key, required this.productData});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String selectedSize;
  late List<String> availableSizes;
  late bool showSizeSelector;

  Color selectedColor = Colors.black;
  bool isLiked = false;

  final List<Color> colors = [
    Colors.black,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    String category = widget.productData['category'] ?? "";
    if (category == "Shoes") {
      availableSizes = ["UK 7", "UK 8", "UK 9", "UK 10", "UK 11"];
      selectedSize = "UK 8";
      showSizeSelector = true;
    } else if (category == "Accessories") {
      availableSizes = [];
      selectedSize = "N/A";
      showSizeSelector = false;
    } else {
      availableSizes = ["S", "M", "L", "XL"];
      selectedSize = "M";
      showSizeSelector = true;
    }
  }

  void _showReviewDialog(BuildContext context, String productName) {
    final TextEditingController _commentController = TextEditingController();
    int _currentRating = 5;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Rate & Comment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("How was your experience?"),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      Icons.star,
                      size: 30,
                      color: index < _currentRating
                          ? Colors.orange
                          : Colors.grey,
                    ),
                    onPressed: () =>
                        setDialogState(() => _currentRating = index + 1),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your comment here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_commentController.text.isEmpty) return;
                final user = FirebaseAuth.instance.currentUser;
                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(productName)
                    .collection('reviews')
                    .add({
                      'userEmail': user?.email ?? "Guest User",
                      'comment': _commentController.text,
                      'rating': _currentRating,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Thank you for your review!")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text("SUBMIT REVIEW"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.productData['name'] ?? 'No Name';
    final dynamic rawPrice = widget.productData['price'] ?? 0.0;
    final String imageUrl =
        widget.productData['image'] ?? 'https://via.placeholder.com/400';
    final String description =
        widget.productData['description'] ??
        "Premium quality product from NOVE collection.";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imageUrl,
                  height: 500,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "LKR $rawPrice",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC5A358),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "NOVE Exclusive Collection",
                        style: TextStyle(color: Colors.grey),
                      ),

                      if (showSizeSelector) ...[
                        const SizedBox(height: 25),
                        const Text(
                          "Select Size",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: availableSizes.map((size) {
                            bool isSelected = selectedSize == size;
                            return GestureDetector(
                              onTap: () => setState(() => selectedSize = size),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 25),
                      const Text(
                        "Select Color",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: colors.map((color) {
                          bool isSelected = selectedColor == color;
                          return GestureDetector(
                            onTap: () => setState(() => selectedColor = color),
                            child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFFC5A358),
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 25),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(color: Colors.grey, height: 1.5),
                      ),

                      // --- REVIEWS & COMMENTS SECTION ---
                      const Divider(height: 50),
                      const Text(
                        "CUSTOMER REVIEWS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .doc(name)
                            .collection('reviews')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          final reviews = snapshot.data!.docs;
                          if (reviews.isEmpty)
                            return const Text(
                              "No reviews yet.",
                              style: TextStyle(color: Colors.grey),
                            );

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              var rev = reviews[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  rev['userEmail'].split('@')[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(rev['comment']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      Icons.star,
                                      size: 14,
                                      color: i < rev['rating']
                                          ? Colors.orange
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: () => _showReviewDialog(context, name),
                        icon: const Icon(
                          Icons.rate_review_outlined,
                          color: Colors.black,
                        ),
                        label: const Text(
                          "WRITE A REVIEW",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Top Back & Wishlist Buttons ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        setState(() => isLiked = !isLiked);
                        if (isLiked) {
                          final wishItem = {
                            "name": name,
                            "price": rawPrice,
                            "image": imageUrl,
                          };
                          if (!WishlistScreen.wishListItems.any(
                            (item) => item['name'] == name,
                          ))
                            WishlistScreen.wishListItems.add(wishItem);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Bottom Add to Cart Button with SnackBar Action ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    final cartItem = {
                      "name": name,
                      "price": rawPrice,
                      "image": imageUrl,
                      "size": selectedSize,
                      "quantity": 1,
                    };
                    setState(() {
                      int index = CartScreen.globalCartItems.indexWhere(
                        (item) =>
                            item['name'] == name &&
                            item['size'] == selectedSize,
                      );
                      if (index == -1) {
                        CartScreen.globalCartItems.add(cartItem);
                      } else {
                        CartScreen.globalCartItems[index]['quantity'] += 1;
                      }
                    });

                    // SnackBar with View Cart Button
                    ScaffoldMessenger.of(
                      context,
                    ).clearSnackBars(); // පරණ මැසේජ් අයින් කරනවා
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Added $name ($selectedSize) to cart!"),
                        backgroundColor: Colors.black,
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: "VIEW CART",
                          textColor: const Color(0xFFC5A358),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "ADD TO CART",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search products...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            setState(() {
              _searchName = value
                  .toLowerCase(); // ටයිප් කරනකොටම UI එක update වෙනවා
            });
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFC5A358)),
            );
          }

          var docs = snapshot.data!.docs.where((doc) {
            String name = (doc['name'] ?? "").toString().toLowerCase();
            return name.contains(_searchName);
          }).toList();

          if (docs.isEmpty) {
            return const Center(child: Text("No products found."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(
                  data['image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(data['name']),
                subtitle: Text("LKR ${data['price']}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(productData: data),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  final Map<String, dynamic>? newItem;
  const WishlistScreen({super.key, this.newItem});

  static List<Map<String, dynamic>> wishListItems = [];

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.newItem != null) {
      bool isExist = WishlistScreen.wishListItems.any(
        (item) => item['name'] == widget.newItem!['name'],
      );
      if (!isExist) {
        WishlistScreen.wishListItems.add(widget.newItem!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "MY WISHLIST",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: WishlistScreen.wishListItems.isEmpty
          ? const Center(
              child: Text(
                "Your wishlist is empty",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: WishlistScreen.wishListItems.length,
              itemBuilder: (context, index) {
                var item = WishlistScreen.wishListItems[index];
                return _buildWishlistItem(item, index);
              },
            ),
    );
  }

  Widget _buildWishlistItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "LKR ${item['price']}",
                  style: const TextStyle(
                    color: Color(0xFFC5A358),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Delete Button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
            onPressed: () {
              setState(() {
                WishlistScreen.wishListItems.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }
}
