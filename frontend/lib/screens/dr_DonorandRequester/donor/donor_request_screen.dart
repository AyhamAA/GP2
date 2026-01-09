import 'package:flutter/material.dart';
import '../../../../widgets/toggle_pill.dart';
import 'donor_items_list.dart';
import '../request/request_items_list.dart';

enum DonorTab { donor, request }

class DonorRequestScreen extends StatefulWidget {
  const DonorRequestScreen({super.key});

  @override
  State<DonorRequestScreen> createState() => _DonorRequestScreenState();
}

class _DonorRequestScreenState extends State<DonorRequestScreen> {
  DonorTab _tab = DonorTab.donor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              Center(
                child: _tab == DonorTab.donor
                    ? Text(
                        "Donor",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "Requester",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                ),
        
              const SizedBox(height: 25),
        
              _buildTopToggle(),
        
              const SizedBox(height: 20),
        
              Expanded(
                child: _tab == DonorTab.donor
                    ?  DonorItemsList()
                    : RequestItemsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopToggle() {
    return Row(
      children: [
        TogglePill(
          label: 'Donor',
          isSelected: _tab == DonorTab.donor,
          onTap: () => setState(() => _tab = DonorTab.donor),
        ),
        const SizedBox(width: 10),
        TogglePill(
          label: 'Request',
          isSelected: _tab == DonorTab.request,
          onTap: () => setState(() => _tab = DonorTab.request),
        ),
      ],
    );
  }
}

