import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/category_model.dart';
import '../providers/service_provider.dart';
import 'order_screen.dart';

class ServiceListScreen extends StatelessWidget {
  final ServiceCategory category;

  const ServiceListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final services = Provider.of<ServiceProvider>(context).getServicesByCategory(category.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
        backgroundColor: category.color,
        foregroundColor: Colors.white,
      ),
      body: services.isEmpty
          ? const Center(child: Text('خدماتی در این دسته یافت نشد.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      service.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(service.description),
                        const SizedBox(height: 8),
                        Text(
                          'قیمت هر ۱۰۰۰ عدد: ${service.pricePer1000.toInt()} تومان',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderScreen(service: service),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
