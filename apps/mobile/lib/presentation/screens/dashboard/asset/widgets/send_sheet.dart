/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/models/asset.dart';
import '../../../../../utils/defai_themes.dart';

class SendSheet extends ConsumerStatefulWidget {
  final Asset asset;

  const SendSheet({super.key, required this.asset});

  @override
  ConsumerState createState() => _SendSheetState();
}

class _SendSheetState extends ConsumerState<SendSheet> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint, Color color, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: NeonColors.textGrey.withValues(alpha: 0.4),
        fontSize: 13,
      ),
      suffixIcon: suffix != null
          ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix)
          : null,
      suffixIconConstraints: const BoxConstraints(),
      filled: true,
      fillColor: NeonColors.darkBg,
      contentPadding: const EdgeInsets.all(14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: NeonColors.textGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'SEND ${widget.asset.symbol}',
              style: TextStyle(
                color: widget.asset.color,
                fontSize: 13,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Address field
          Text(
            'RECIPIENT ADDRESS',
            style: TextStyle(
              color: NeonColors.textGrey,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
            decoration: _inputDecoration(
              'Liquid address...',
              widget.asset.color,
            ),
          ),

          const SizedBox(height: 16),

          // Amount field
          Text(
            'AMOUNT',
            style: TextStyle(
              color: NeonColors.textGrey,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: _inputDecoration(
              '0.00',
              widget.asset.color,
              suffix: Text(
                widget.asset.symbol,
                style: TextStyle(
                  color: widget.asset.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Send button — routes through Sovereign Handshake
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                // TODO: wire to agent_provider.executeStrategy()
                // which will trigger the Sovereign Handshake before signing
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: widget.asset.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.asset.color.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedFingerPrint,
                        color: widget.asset.color,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SOVEREIGN HANDSHAKE TO SEND',
                        style: TextStyle(
                          color: widget.asset.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
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
