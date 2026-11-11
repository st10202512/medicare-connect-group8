import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class WebServicesScreen extends StatelessWidget {
  const WebServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  image: NetworkImage('https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=2000&auto=format&fit=crop'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFF00897B).withOpacity(0.85)),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Our Services', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 16),
                      Text('Comprehensive healthcare for you and your family', style: TextStyle(fontSize: 18, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),

            // --- SERVICE CARDS WITH IMAGES ---
            Container(
              padding: const EdgeInsets.all(60),
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Wrap(
                spacing: 30,
                runSpacing: 30,
                alignment: WrapAlignment.center,
                children: [
                  _serviceCard(
                    image: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?q=80&w=800&auto=format&fit=crop',
                    title: 'Consultation',
                    desc: 'General medical consultation with a doctor.',
                    price: 'R350.00',
                    delay: 0,
                  ),
                  _serviceCard(
                    image: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=800&auto=format&fit=crop',
                    title: 'Chronic Care',
                    desc: 'Ongoing management of chronic conditions.',
                    price: 'R420.00',
                    delay: 100,
                  ),
                  _serviceCard(
                    image: 'https://images.unsplash.com/photo-1584515933487-779824d29309?q=80&w=800&auto=format&fit=crop',
                    title: 'Vaccination',
                    desc: 'Routine immunisations and travel vaccines.',
                    price: 'R180.00',
                    delay: 200,
                  ),
                  _serviceCard(
                    image: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=800&auto=format&fit=crop',
                    title: 'Prescription Collection',
                    desc: 'Collect repeat prescriptions without a consultation.',
                    price: 'R100.00',
                    delay: 300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard({required String image, required String title, required String desc, required String price, required int delay}) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: Image.network(image, height: 180, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(height: 180, child: Icon(Icons.medical_services, size: 50, color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(desc, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00897B))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNavbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(onTap: () => Navigator.pushReplacementNamed(context, '/'), child: const Text('MediCare Connect', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00897B)))),
          Row(
            children: [
              _navLink(context, 'Home', '/'),
              _navLink(context, 'About', '/about'),
              _navLink(context, 'Services', '/services'),
              _navLink(context, 'Contact', '/contact'),
              const SizedBox(width: 20),
              ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/login'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00897B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)), child: const Text('Login to Portal')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navLink(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () { if (ModalRoute.of(context)?.settings.name != route) Navigator.pushNamed(context, route); },
      child: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 16)),
    );
  }
}