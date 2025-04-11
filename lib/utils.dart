import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;


// Define section enum
enum AppSection {
  home,
  calculator,
  contact
}


final Map<String, Map<String, String>> metricDescriptionsDetailed = {
  'Age': {
    'high': 'Long-term project with proven stability',
    'medium': 'Some maturity, but still growing',
    'low': 'Very new or untested project',
  },
  'Dominance': {
    'high': 'Strong market presence and recognition',
    'medium': 'Gaining traction, but not widely adopted yet',
    'low': 'Low visibility and influence in the market',
  },
  'Adoption': {
    'high': 'Broad and healthy user base',
    'medium': 'Some user activity, but room to grow',
    'low': 'Weak adoption and limited real-world use',
  },
  'Loyalty': {
    'high': 'Most holders are long-term believers',
    'medium': 'Mixed sentiment among holders',
    'low': 'Mostly short-term or speculative holders',
  },
  'Momentum': {
    'high': 'Clear upward trend across timeframes',
    'medium': 'Mixed or inconsistent trend signals',
    'low': 'Downward trend in recent months',
  },
  'Crash': {
    'high': 'Holding strong near past highs',
    'medium': 'Significant drop, possible recovery zone',
    'low': 'Heavy crash, confidence likely broken',
  },
  'Liquidity': {
    'high': 'Easy to buy and sell with minimal slippage',
    'medium': 'Tradable but may experience some price impact',
    'low': 'Low activity, harder to exit positions safely',
  },
  'Whale Control': {
    'high': 'Well-distributed supply, low whale influence',
    'medium': 'Some concentration among large holders',
    'low': 'High whale control, risk of manipulation',
  },
};

 // Import for web-specific implementation

// Function to send email - with web fallback
Future<void> sendEmail() async {
  final recipientEmail = 'contact@terencebumah.com';
  final subject = '';
  final body = '';
  
  // Create the mailto URI
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: recipientEmail,
    query: encodeQueryParameters({
      'subject': subject,
      'body': body
    }),
  );
  
  // First try using url_launcher
  try {
    final launched = await launchUrl(emailLaunchUri);
    if (!launched) {
      // Fallback for web
      _launchEmailWeb(recipientEmail, subject, body);
    }
  } catch (e) {
    print('Error with url_launcher: $e');
    // Fallback for web
    _launchEmailWeb(recipientEmail, subject, body);
  }
}

// Web-specific email launcher
void _launchEmailWeb(String email, String subject, String body) {
  try {
    final mailtoLink = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    html.window.open(mailtoLink, '_blank');
  } catch (e) {
    print('Could not open email client: $e');
  }
}

// Helper function to encode query parameters
String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) => 
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
