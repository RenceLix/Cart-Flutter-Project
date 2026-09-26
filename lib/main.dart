import 'package:flutter/material.dart';

void main() => runApp(const ShoppingCartApp());

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
      ),
      home: const CartHomePage(),
    );
  }
}

///  constant colors + breakpoint

class AppColors {
  static const primary = Color(0xFF067aec);
  static const background = Color(0xFFF6FCFF);
  static const cardBorder = Color(0xFFE3E8F0);
  static const selectedFill = Color(0xFFe8f2fd);
  static const heart = Color(0xFFfe2f31);
  static const success = Color(0xFF1FAA59);
  static const textDark = Color(0xFF1B2430);
  static const textGrey = Color(0xFF7C8798);
}

class Breakpoints {
  // Below this width -> phone (single column list).
  // At/above this width -> tablet / desktop (grid layout).
  static const tablet = 700.0;
}

/// Product Model
class Product {
  final String name;
  final String subtitle;
  final String priceLabel;
  final String imagePath;
  final int initialLikes;
  final int initialQuantity;

  const Product({
    required this.name,
    required this.subtitle,
    required this.priceLabel,
    required this.imagePath,
    required this.initialLikes,
    required this.initialQuantity,
  });
}

const List<Product> demoProducts = [
  Product(
    name: 'iPhone 18 Pro Max',
    subtitle: 'Apple',
    priceLabel: 'Rp 29.990.000',
    imagePath: 'assets/images/iphone-18-pro-max.jpg',
    initialLikes: 12,
    initialQuantity: 1,
  ),
  Product(
    name: 'Laptop Lenovo LOQ',
    subtitle: 'Lenovo',
    priceLabel: 'Rp 12.500.000',
    imagePath: 'assets/images/lenovo-loq.jpg',
    initialLikes: 8,
    initialQuantity: 1,
  ),
  Product(
    name: 'Samsung Buds FE',
    subtitle: 'Samsung',
    priceLabel: 'Rp 550.000',
    imagePath: 'assets/images/samsung-buds-fe.jpg',
    initialLikes: 5,
    initialQuantity: 1,
  ),
];

/// Homepage
class CartHomePage extends StatefulWidget {
  const CartHomePage({super.key});

  @override
  State<CartHomePage> createState() => _CartHomePageState();
}

class _CartHomePageState extends State<CartHomePage> {
  int _selectedNavIndex = 0;
  bool _showInfoBanner = false;
  String _infoMessage = '';

  void _handleLongPress(String productName) {
    setState(() {
      _infoMessage = '$productName telah dipilih.';
      _showInfoBanner = true;
    });
  }

  void _dismissBanner() {
    setState(() => _showInfoBanner = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( makan bakso
        child: Stack(
          children: [
            // Main page content: header + product area + summary bar.
            Column(
              children: [
                const CartAppBar(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isTablet = constraints.maxWidth >= Breakpoints.tablet;
                      return ProductArea(
                        isTablet: isTablet,
                        onLongPressProduct: _handleLongPress,
                      );
                    },
                  ),
                ),
                const CartSummaryBar(
                  itemCountLabel: 'Total (3 produk)',
                  totalPriceLabel: 'Rp 43.040.000',
                ),
                CartBottomNavBar(
                  selectedIndex: _selectedNavIndex,
                  onTap: (index) => setState(() => _selectedNavIndex = index),
                ),
              ],
            ),

            // Overlay info banner shown after a long-press (Stack + Positioned).
            if (_showInfoBanner)
              Positioned(
                top: 8,
                left: 16,
                right: 16,
                child: InfoBanner(
                  message: _infoMessage,
                  onClose: _dismissBanner,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// APP BAR (header section)
class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'My Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Belanja lebih mudah setiap hari',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.search, color: Colors.white),
        ],
      ),
    );
  }
}


/// Product Areea switches between a phone list and a tablet/desktop grid.

class ProductArea extends StatefulWidget {
  final bool isTablet;
  final ValueChanged<String> onLongPressProduct;

  const ProductArea({
    super.key,
    required this.isTablet,
    required this.onLongPressProduct,
  });

  @override
  State<ProductArea> createState() => _ProductAreaState();
}

class _ProductAreaState extends State<ProductArea> {
  int? _selectedProductIndex;

  void _selectProduct(int index) {
    setState(() {
      _selectedProductIndex =
          _selectedProductIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: widget.isTablet ? 32 : 16,
      vertical: 16,
    );

    if (widget.isTablet) {
      return GridView.builder(
        padding: padding,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          mainAxisExtent: 130,
        ),
        itemCount: demoProducts.length,
        itemBuilder: (context, index) => ProductCard(
          key: ValueKey(demoProducts[index].name),
          product: demoProducts[index],
          isSelected: _selectedProductIndex == index,
          onTap: () => _selectProduct(index),
          onLongPress: widget.onLongPressProduct,
        ),
      );
    }

    return ListView.separated(
      padding: padding,
      itemCount: demoProducts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => ProductCard(
        key: ValueKey(demoProducts[index].name),
        product: demoProducts[index],
        isSelected: _selectedProductIndex == index,
        onTap: () => _selectProduct(index),
        onLongPress: widget.onLongPressProduct,
      ),
    );
  }
}

/// Product Card (StatefulWidget + GestureDetector)
///   - tap          -> selected highlight/border
///   - double tap   -> like
///   - long press   -> info/notification

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<String> onLongPress;

  const ProductCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late int _likes;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _likes = widget.product.initialLikes;
    _quantity = widget.product.initialQuantity;
  }

  void _handleDoubleTap() => setState(() => _likes += 1);

  void _handleLongPress() => widget.onLongPress(widget.product.name);

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: _handleDoubleTap,
      onLongPress: _handleLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.selectedFill : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: widget.isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductThumbnail(imagePath: product.imagePath),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.subtitle,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.priceLabel,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _likes > product.initialLikes
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 16,
                        color: AppColors.heart,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_likes',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      QuantityStepper(
                        quantity: _quantity,
                        // UI only: buttons are visual, no add/remove logic.
                        onDecrease: () {},
                        onIncrease: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// thumbnail box standing in for a product image.
class ProductThumbnail extends StatelessWidget {
  static const double _size = 72;
  final String imagePath;

  const ProductThumbnail({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          width: _size,
          height: _size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// quantity stepper
class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(icon: Icons.remove, onTap: onDecrease, filled: false),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        _StepperButton(icon: Icons.add, onTap: onIncrease, filled: true),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 14,
          color: filled ? Colors.white : AppColors.textGrey,
        ),
      ),
    );
  }
}


/// Summary bar (total + checkout button) — UI only, values are static.
class CartSummaryBar extends StatelessWidget {
  final String itemCountLabel;
  final String totalPriceLabel;

  const CartSummaryBar({
    super.key,
    required this.itemCountLabel,
    required this.totalPriceLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  itemCountLabel,
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
                Text(
                  totalPriceLabel,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {}, // UI only, no checkout logic.
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }
}

/// Bottom navigation bar
class CartBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CartBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItemData(icon: Icons.home_rounded, label: 'Beranda'),
    _NavItemData(icon: Icons.grid_view_rounded, label: 'Kategori'),
    _NavItemData(icon: Icons.shopping_cart_outlined, label: 'Keranjang', badgeCount: 3),
    _NavItemData(icon: Icons.person_outline, label: 'Akun'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isActive = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        item.icon,
                        color: isActive ? AppColors.primary : AppColors.textGrey,
                      ),
                      if (item.badgeCount != null)
                        Positioned(
                          right: -6,
                          top: -4,
                          child: NavBadge(count: item.badgeCount!),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? AppColors.primary : AppColors.textGrey,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  final int? badgeCount;

  const _NavItemData({required this.icon, required this.label, this.badgeCount});
}

class NavBadge extends StatelessWidget {
  final int count;

  const NavBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.heart,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// INFO Banner for notification in long press
class InfoBanner extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const InfoBanner({super.key, required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2430),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.success,
              child: Icon(Icons.check, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Produk dipilih!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onClose,
              child: const Icon(Icons.close, color: Colors.white70, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}