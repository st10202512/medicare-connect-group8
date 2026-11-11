import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class WebAboutScreen extends StatelessWidget {
  const WebAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavbar(context),

            // --- HERO ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
              color: const Color(0xFF00897B).withOpacity(0.05),
              child: FadeInDown(
                child: const Column(
                  children: [
                    Text('About Us', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF00897B))),
                    SizedBox(height: 16),
                    Text('Learn more about HealthyLife Family Clinic', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              ),
            ),

            // --- CONTENT WITH IMAGE ---
            Container(
              padding: const EdgeInsets.all(60),
              constraints: const BoxConstraints(maxWidth: 1100),
              child: isDesktop
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _textContent()),
                  const SizedBox(width: 60),
                  Expanded(
                    child: FadeInRight(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=800&auto=format&fit=crop',
                          fit: BoxFit.cover,
                          height: 500,
                          errorBuilder: (_, __, ___) => const Icon(Icons.local_hospital, size: 100, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Column(
                children: [
                  _textContent(),
                  const SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=800&auto=format&fit=crop',
                      fit: BoxFit.cover,
                      height: 300,
                      errorBuilder: (_, __, ___) => const Icon(Icons.local_hospital, size: 100, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textContent() {
    return FadeInLeft(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HealthyLife Family Clinic',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF00897B)),
          ),
          const SizedBox(height: 20),
          const Text(
            'HealthyLife Family Clinic is a small private medical facility offering medical consultations, chronic-condition management, and prescription services. We are committed to providing high-quality care to our community.',
            style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.6),
          ),
          const SizedBox(height: 40),
          const Text('Our Mission', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text(
            'To deliver quality healthcare with minimal waiting time, using modern digital tools that put the patient first.',
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.6),
          ),
          const SizedBox(height: 40),
          const Text('Our Values', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _valueItem('Patient-first care'),
          _valueItem('Respect and confidentiality'),
          _valueItem('Digital convenience'),
          _valueItem('Continuous improvement'),
        ],
      ),
    );
  }

  Widget _valueItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF00897B), size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildNavbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
            child: const Text('MediCare Connect', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00897B))),
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
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00897B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                child: const Text('Login to Portal'),
              ),
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
      child: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 16)),
    );
  }
}