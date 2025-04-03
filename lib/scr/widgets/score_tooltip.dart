

import 'package:flutter/material.dart';

class ScoreTooltip extends StatefulWidget {
  final Widget child;
  final String message;

  const ScoreTooltip({
    Key? key,
    required this.child,
    required this.message,
  }) : super(key: key);

  @override
  State<ScoreTooltip> createState() => _ScoreTooltipState();
}

class _ScoreTooltipState extends State<ScoreTooltip> {
  bool _isTooltipVisible = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isHovering = false;
  bool _isLocked = false;

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  void _showTooltip() {
    if (_overlayEntry != null) return;
    
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isTooltipVisible = true;
    });
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isTooltipVisible = false;
      _isLocked = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    // Get the screen size to position tooltip properly
    final screenSize = MediaQuery.of(context).size;
    
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 300, // Wider tooltip to accommodate descriptive text
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 30),
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: screenSize.height * 0.8, // Allow taller tooltip for all descriptions
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5C),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF152A42),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Asset Evaluation",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _hideTooltip,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Scrollable content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: _buildTooltipContent(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTooltipContent() {
    List<Widget> contentWidgets = [];
    List<String> lines = widget.message.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      
      // Style for section headers (metric names)
      if (line.endsWith(':') && !line.contains('Score Breakdown:') && !line.contains('Final Score:')) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4, top: 8),
            child: Text(
              line,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      // Style for bullet points (descriptions)
      else if (line.startsWith('• ')) {
        Color textColor;
        if (line.contains('Long-term') || line.contains('Strong market') || 
            line.contains('Broad and healthy') || line.contains('long-term believers') ||
            line.contains('Clear upward') || line.contains('Holding strong') ||
            line.contains('Easy to buy') || line.contains('Well-distributed')) {
          textColor = Colors.green;
        } else if (line.contains('Heavy crash') || line.contains('Downward trend') ||
                  line.contains('Weak adoption') || line.contains('Low visibility') ||
                  line.contains('Very new') || line.contains('High whale') ||
                  line.contains('Low activity') || line.contains('short-term')) {
          textColor = Colors.red;
        } else {
          textColor = Colors.amber;
        }
        
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 2, left: 8),
            child: Text(
              line,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
              ),
            ),
          ),
        );
      }
      // Style for Score Breakdown header
      else if (line.contains('Score Breakdown:')) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      // Style for final score
      else if (line.contains('Final Score:')) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              line,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      // For empty lines, add space
      else if (line.trim().isEmpty) {
        contentWidgets.add(SizedBox(height: 2));
      }
      // Default style for other lines
      else {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              line,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 12,
              ),
            ),
          ),
        );
      }
    }
    
    return contentWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true;
          });
          if (!_isTooltipVisible) {
            _showTooltip();
          }
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
          });
          if (_isTooltipVisible && !_isLocked) {
            _hideTooltip();
          }
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (_isTooltipVisible) {
              setState(() {
                _isLocked = !_isLocked;
              });
              if (!_isLocked && !_isHovering) {
                _hideTooltip();
              }
            } else {
              setState(() {
                _isLocked = true;
              });
              _showTooltip();
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}