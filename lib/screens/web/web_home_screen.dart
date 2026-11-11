import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- NAVBAR ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    child: const Text(
                      'MediCare Connect',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B),
                      ),
                    ),
                  ),
                  if (isDesktop)
                    FadeInRight(
                      duration: const Duration(milliseconds: 800),
                      child: Row(
                        children: [
                          _navLink(context, 'Home', '/'),
                          _navLink(context, 'About', '/about'),
                          _navLink(context, 'Services', '/services'),
                          _navLink(context, 'Contact', '/contact'),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00897B),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                            ),
                            child: const Text('Login to Portal'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // --- HERO SECTION WITH BACKGROUND IMAGE ---
            Container(
              width: double.infinity,
              height: isDesktop ? 600 : 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // High-quality clinic/doctor background image
                  image: NetworkImage('https://images.unsplash.com/photo-1638202993928-7267aad84c31?q=80&w=2070&auto=format&fit=crop'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF00897B).withOpacity(0.85),
                      const Color(0xFF005f56).withOpacity(0.95),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          'Healthcare at your fingertips',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isDesktop ? 56 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          'Book appointments, request medication, and stay connected with HealthyLife Family Clinic.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 40),
                      BounceInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF00897B),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('Book an Appointment Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- FEATURES SECTION (CLICKABLE CARDS WITH IMAGES) ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
              child: Column(
                children: [
                  FadeInUp(
                    child: const Text(
                      'What you can do',
                      style: TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: [
                      _featureCard(
                        context: context,
                        imageUrl: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?q=80&w=800&auto=format&fit=crop', // Doctor image
                        title: 'Book Appointments',
                        desc: 'Choose a service, date, and time slot in seconds.',
                        delay: 0,
                      ),
                      _featureCard(
                        context: context,
                        imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=800&auto=format&fit=crop', // Medication image
                        title: 'Medication Requests',
                        desc: 'Request prescription collections without queuing.',
                        delay: 200,
                      ),
                      _featureCard(
                        context: context,
                        imageUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?q=80&w=800&auto=format&fit=crop', // Payment image
                        title: 'Secure Payments',
                        desc: 'Pay online before your visit — no cash, no wait.',
                        delay: 400,
                      ),
                      _featureCard(
                        context: context,
                        imageUrl: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=800&auto=format&fit=crop', // Feedback image
                        title: 'Feedback & Support',
                        desc: 'Share your experience and get help quickly.',
                        delay: 600,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- FOOTER ---
            Container(
              width: double.infinity,
              color: const Color(0xFF222222),
              padding: const EdgeInsets.all(40),
              child: const Center(
                child: Text(
                  '© 2026 HealthyLife Family Clinic — MediCare Connect',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
          ],
        ),
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
      child: Text(
        title,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
      ),
    );
  }

  // UPDATED: This function now takes an image URL and wraps the card in an InkWell to make it clickable
  Widget _featureCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String desc,
    required int delay,
  }) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: InkWell(
        onTap: () {
          // Clicking any card takes the user to the login page
          Navigator.pushNamed(context, '/login');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 260,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.medical_services, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
              // Text Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      desc,
                      style: const TextStyle(color: Colors.grey, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}