import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../services/user_service.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _service = UserService();
  String _searchQuery = '';
  UserRole? _selectedRole;

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  List<User> _filterUsers(List<User> users) {
    if (_searchQuery.isEmpty) return users;
    return users
        .where(
          (user) =>
              user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void _showAddUserDialog() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _studentIdController.clear();
    _selectedRole = null;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
          ),
          title: const Text(
            'Add User',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeConfig.primaryBlue,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                      borderSide: const BorderSide(color: ThemeConfig.primaryBlue),
                    ),
                  ),
                ),
                const SizedBox(height: ThemeConfig.spaceMedium),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                      borderSide: const BorderSide(color: ThemeConfig.primaryBlue),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: ThemeConfig.spaceMedium),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                      borderSide: const BorderSide(color: ThemeConfig.primaryBlue),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: ThemeConfig.spaceMedium),
                DropdownButtonFormField<UserRole>(
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                      borderSide: const BorderSide(color: ThemeConfig.primaryBlue),
                    ),
                  ),
                  value: _selectedRole,
                  items: UserRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedRole = value);
                  },
                ),
                if (_selectedRole == UserRole.student) ...[
                  const SizedBox(height: ThemeConfig.spaceMedium),
                  TextField(
                    controller: _studentIdController,
                    decoration: InputDecoration(
                      labelText: 'Student ID',
                      hintText: 'e.g., mit/ur/004/12',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                        borderSide: const BorderSide(color: ThemeConfig.primaryBlue),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: ThemeConfig.primaryBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty &&
                    _selectedRole != null) {
                  try {
                    await _service.createUser(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      role: _selectedRole!,
                      studentId: _selectedRole == UserRole.student && _studentIdController.text.isNotEmpty 
                          ? _studentIdController.text 
                          : null,
                    );
                    if (mounted) {
                      ref.invalidate(usersProvider);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User created successfully'),
                          backgroundColor: ThemeConfig.successGreen,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error creating user: ${e.toString()}'),
                          backgroundColor: ThemeConfig.errorRed,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConfig.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                ),
              ),
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUser(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
        ),
        title: const Text(
          'Delete User',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ThemeConfig.errorRed,
          ),
        ),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ThemeConfig.primaryBlue),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.errorRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _service.deleteUser(user.id);
        if (mounted) {
          ref.invalidate(usersProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User deleted successfully'),
              backgroundColor: ThemeConfig.successGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting user: ${e.toString()}'),
              backgroundColor: ThemeConfig.errorRed,
            ),
          );
        }
      }
    }
  }

  Widget _buildUserCard(User user) {
    return ModernCard(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(user.role),
          child: Icon(
            _getRoleIcon(user.role),
            color: Colors.white,
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getRoleColor(user.role).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user.role.name.toUpperCase(),
                style: TextStyle(
                  color: _getRoleColor(user.role),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _deleteUser(user),
          icon: const Icon(
            Icons.delete_outline,
            color: ThemeConfig.errorRed,
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.administrator:
        return ThemeConfig.errorRed;
      case UserRole.staff:
        return ThemeConfig.warningOrange;
      case UserRole.student:
        return ThemeConfig.primaryBlue;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.administrator:
        return Icons.admin_panel_settings;
      case UserRole.staff:
        return Icons.person_outline;
      case UserRole.student:
        return Icons.school;
    }
  }
  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: ThemeConfig.headerGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'User Management',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48), // Balance the back button
                        ],
                      ),
                      const SizedBox(height: ThemeConfig.spaceMedium),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search users...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: ThemeConfig.spaceMedium),
                  child: usersAsync.when(
                    data: (users) {
                      final filteredUsers = _filterUsers(users);
                      
                      if (filteredUsers.isEmpty) {
                        return Center(
                          child: ModernCard(
                            child: Padding(
                              padding: const EdgeInsets.all(ThemeConfig.spaceMedium * 2),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 64,
                                    color: ThemeConfig.primaryBlue.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: ThemeConfig.spaceMedium),
                                  Text(
                                    _searchQuery.isEmpty ? 'No users found' : 'No users match your search',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: ThemeConfig.spaceMedium * 4),
                        itemCount: filteredUsers.length,
                        separatorBuilder: (context, index) => const SizedBox(height: ThemeConfig.spaceSmall),
                        itemBuilder: (context, index) {
                          return _buildUserCard(filteredUsers[index]);
                        },
                      );
                    },
                    loading: () => const LoadingWidget(message: 'Loading users...'),
                    error: (error, stackTrace) => Center(
                      child: ModernCard(
                        child: Padding(
                          padding: const EdgeInsets.all(ThemeConfig.spaceMedium * 2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: ThemeConfig.errorRed,
                              ),
                              const SizedBox(height: ThemeConfig.spaceMedium),
                              const Text(
                                'Error loading users',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeConfig.errorRed,
                                ),
                              ),
                              const SizedBox(height: ThemeConfig.spaceSmall),
                              Text(
                                error.toString(),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUserDialog,
        backgroundColor: ThemeConfig.primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
      ),
    );
  }
}
