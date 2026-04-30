import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/api_cubit.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ApiCubit>().fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiCubit, ApiState>(
      builder: (context, state) {
        if (state is ApiLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ApiError) {
          return Center(child: Text(state.message));
        }

        if (state is ApiLoaded) {
          return RefreshIndicator(
            onRefresh: () => context.read<ApiCubit>().fetchItems(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.body),
                    leading: const Icon(Icons.public),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}