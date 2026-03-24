import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/widgets/loading_spinner.dart';
import '../../domain/entities/address_entity.dart';
import '../cubit/address_cubit.dart';
import '../cubit/address_state.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Addresses')),
      body: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state.failureMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.failureMessage!)));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: LoadingSpinner());
          }

          final addresses = state.addresses;
          return Column(
            children: [
              if (addresses.isEmpty)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 64,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'No saved addresses yet',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          FilledButton(
                            onPressed: () => _showAddressForm(context),
                            child: const Text('Add Address'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          title: Text(address.label),
                          subtitle: Text(
                            '${address.recipientName}\n${address.line1}${address.line2 != null && address.line2!.isNotEmpty ? '\n${address.line2}' : ''}\n${address.city}, ${address.state} ${address.postalCode}\n${address.country}\n${address.phone}',
                            style: theme.textTheme.bodySmall,
                          ),
                          isThreeLine: true,
                          leading: Icon(
                            address.isDefault
                                ? Icons.check_circle
                                : Icons.home_outlined,
                            color: address.isDefault
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'edit':
                                  _showAddressForm(context, address: address);
                                  break;
                                case 'delete':
                                  _confirmDelete(context, address);
                                  break;
                                case 'default':
                                  context
                                      .read<AddressCubit>()
                                      .setDefaultAddress(address.id);
                                  break;
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'default',
                                child: Text('Set as default'),
                              ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _showAddressForm(context),
                    icon: const Icon(Icons.add_location_alt),
                    label: const Text('Add new address'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, AddressEntity address) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete address'),
        content: const Text('Are you sure you want to remove this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AddressCubit>().deleteAddress(address.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddressForm(BuildContext context, {AddressEntity? address}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
        ),
        child: AddressForm(
          address: address,
          onSave: (updated) {
            if (address == null) {
              context.read<AddressCubit>().addAddress(updated);
            } else {
              context.read<AddressCubit>().updateAddress(updated);
            }
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }
}

class AddressForm extends StatefulWidget {
  const AddressForm({super.key, required this.onSave, this.address});

  final void Function(AddressEntity) onSave;
  final AddressEntity? address;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _line1Controller;
  late final TextEditingController _line2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _labelController = TextEditingController(text: address?.label ?? 'Home');
    _nameController = TextEditingController(text: address?.recipientName ?? '');
    _phoneController = TextEditingController(text: address?.phone ?? '');
    _line1Controller = TextEditingController(text: address?.line1 ?? '');
    _line2Controller = TextEditingController(text: address?.line2 ?? '');
    _cityController = TextEditingController(text: address?.city ?? '');
    _stateController = TextEditingController(text: address?.state ?? '');
    _postalCodeController = TextEditingController(
      text: address?.postalCode ?? '',
    );
    _countryController = TextEditingController(text: address?.country ?? '');
    _isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.address != null;
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditing ? 'Edit address' : 'Add address',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildTextField(_labelController, 'Label (Home / Work)'),
              const SizedBox(height: AppSpacing.sm),
              _buildTextField(_nameController, 'Recipient name'),
              const SizedBox(height: AppSpacing.sm),
              _buildTextField(
                _phoneController,
                'Phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildTextField(_line1Controller, 'Address line 1'),
              const SizedBox(height: AppSpacing.sm),
              _buildTextField(_line2Controller, 'Address line 2 (optional)'),
              const SizedBox(height: AppSpacing.sm),
              _buildTextField(_cityController, 'City'),
              const SizedBox(height: AppSpacing.sm),
              _buildTextField(_stateController, 'State/Province'),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_postalCodeController, 'ZIP/Postal'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildTextField(_countryController, 'Country'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (value) =>
                        setState(() => _isDefault = value ?? false),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(child: Text('Set as default address')),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _onSave,
                  child: Text(isEditing ? 'Save changes' : 'Add address'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: InputDecoration(labelText: label),
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final address = AddressEntity(
      id:
          widget.address?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      label: _labelController.text.trim(),
      recipientName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      line1: _line1Controller.text.trim(),
      line2: _line2Controller.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      country: _countryController.text.trim(),
      isDefault: _isDefault,
    );

    widget.onSave(address);
  }
}
