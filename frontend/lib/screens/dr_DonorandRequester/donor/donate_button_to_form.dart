import 'package:flutter/material.dart';
import 'package:test_app/screens/dr_DonorandRequester/donor/donate_new_item_sheet.dart';

class DonateHintCard extends StatelessWidget {
  const DonateHintCard({super.key, this.onDonate});

  final VoidCallback? onDonate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFBBD7FF), width: 1),
            ),
            child: const Icon(Icons.add, color: Color(0xFF34AFB7), size: 22),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Want to donate a new item?",
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Add your donation here.",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => DonateNewItemSheet(),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

              decoration: BoxDecoration(
                color: Color(0xFF34AFB7),
                borderRadius: BorderRadius.circular(999),
              ),

              child: const Text(
                "Donate",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
