import 'package:flutter/material.dart';
import '../../features/auth/data/Cart/add_to_cart_dto.dart';
import '../../features/auth/data/Cart/cart_response_model.dart';
import '../../features/auth/data/Cart/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  late Future<CartResponseModel> _cartFuture;

  @override
  void initState() {
    super.initState();
    _cartFuture = _cartService.getMyCart();
  }

  void _reloadCart() {
    setState(() {
      _cartFuture = _cartService.getMyCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Cart",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<CartResponseModel>(
              future: _cartFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                final equipmentCartItems = snapshot.data!.equipment
                    .map((e) => CartItem(
                  name: e.itemName,
                  quantity: e.quantity,
                  image: Icons.medical_services,
                  donationId: e.donationId,
                  cartType: 1,
                ))
                    .toList();

                final medicineCartItems = snapshot.data!.medicine
                    .map((e) => CartItem(
                  name: e.itemName,
                  quantity: e.quantity,
                  image: Icons.medication,
                  donationId: e.donationId,
                  cartType: 2,
                ))
                    .toList();


                if (equipmentCartItems.isEmpty &&
                    medicineCartItems.isEmpty) {
                  return _buildEmptyCart();
                }

                return SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCartSection(
                        title: "Equipment Cart",
                        items: equipmentCartItems,
                      ),
                      const SizedBox(height: 18),
                      _buildCartSection(
                        title: "Medicine Cart",
                        items: medicineCartItems,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Checkout Button
          SizedBox(
            height: 56,
            width: 360,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await _cartService.checkout();
                _reloadCart();
              },
              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index, List<CartItem> list) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF34AFB7).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.image, color: const Color(0xFF34AFB7), size: 30),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantity: ${item.quantity}',
                  style:
                  TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: const Color(0xFF34AFB7),
                onPressed: () async {
                  await _cartService.removeFromCart(
                    AddToCartDto(
                      donationId: item.donationId,
                      quantity: 1,
                      cartType: item.cartType,
                    ),
                  );
                  _reloadCart();
                },
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: const Color(0xFF34AFB7),
                onPressed: () async {
                  await _cartService.addToCart(
                    AddToCartDto(
                      donationId: item.donationId,
                      quantity: 1,
                      cartType: item.cartType,
                    ),
                  );
                  _reloadCart();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartSection({
    required String title,
    required List<CartItem> items,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildCartItem(item, index, items);
        }),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  String name;
  int quantity;
  IconData image;
  int donationId;
  int cartType;

  CartItem({
    required this.name,
    required this.quantity,
    required this.image,
    required this.donationId,
    required this.cartType,
  });
}
