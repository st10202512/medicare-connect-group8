import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

class WebContactScreen extends StatefulWidget {
  const WebContactScreen({super.key});

  @override
  State<WebContactScreen> createState() => _WebContactScreenState();
}

class _WebContactScreenState extends State<WebContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _isSubmitting = false;
  bool _sent = false;

  // Register the iframe with a unique view type
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'google-map-iframe-${DateTime.now().millisecondsSinceEpoch}';

    // Register the HTML view factory using dart:ui_web
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
      // This is a real Google Maps embed URL for Johannesburg
        ..src = 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3578.285814853443!2d28.0473!3d-26.2041!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1e950c6f7c98a06f%3A0x2e8e3e9c8b3a5b0!2sJohannesburg!5e0!3m2!1sen!2sza!4v1234567890'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.borderRadius = '16px'
        ..allowFullscreen = true;
      return iframe;
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _sent = true;
      });
      _nameCtrl.clear();
      _emailCtrl.clear();
      _msgCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavbar(context),

            // --- HERO BANNER WITH IMAGE ---
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=2000&auto=format&fit=crop'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.85)),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Contact Us',
                          style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 16),
                      Text('We are here to help you',
                          style: TextStyle(
                              fontSize: 18, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),

            // --- CONTENT ---
            Container(
              padding: const EdgeInsets.all(60),
              constraints: const BoxConstraints(maxWidth: 1100),
              child: isDesktop
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _contactInfo()),
                  const SizedBox(width: 40),
                  Expanded(child: _contactForm()),
                ],
              )
                  : Column(
                children: [
                  _contactInfo(),
                  const SizedBox(height: 40),
                  _contactForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactInfo() {
    return FadeInLeft(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Get in Touch',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00897B))),
          const SizedBox(height: 20),
          const Text(
              'Have a question or need to book an appointment? Reach out to us through any of the channels below.',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 40),

          _contactItem(Icons.phone, 'Phone', '+27 12 345 6789'),
          _contactItem(
              Icons.email, 'Email', 'support@medicareconnect.co.za'),
          _contactItem(Icons.location_on, 'Address',
              '123 Main Road, Johannesburg, 2001'),
          _contactItem(
              Icons.access_time, 'Hours', 'Mon – Fri: 08:00 – 17:00'),

          const SizedBox(height: 40),
          const Text('Find Us Here',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00897B))),
          const SizedBox(height: 16),

          // --- REAL GOOGLE MAP EMBED ---
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              // This renders the actual Google Maps iframe
              child: HtmlElementView(viewType: _viewType),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFF00897B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF00897B), size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(value,
                  style:
                  const TextStyle(fontSize: 16, color: Colors.black87)),
            ],
          )
        ],
      ),
    );
  }

  Widget _contactForm() {
    return FadeInRight(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10))
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Send a Message',
                  style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(v)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _msgCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                    labelText: 'Message', border: OutlineInputBorder()),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Message is required'
                    : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SEND MESSAGE',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              if (_sent) ...[
                const SizedBox(height: 20),
                const Text('Thank you. Your message has been sent.',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
            child: const Text('MediCare Connect',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00897B))),
          ),
          Row(
            children: [
              _navLink(context, 'Home', '/'),
              _navLink(context, 'About', '/about'),
              _navLink(context, 'Services', '/services'),
              _navLink(context, 'Contact', '/contact'),
              const SizedBox(width: 20),
              ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16)),
                  child: const Text('Login to Portal')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navLink(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () {
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
      },
      child:
      Text(title, style: const TextStyle(color: Colors.black87, fontSize: 16)),
    );
  }
}