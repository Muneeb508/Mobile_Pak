import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/exchange_tier.dart';
import '../shared/exchange_tier_chip.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  int _currentStep = 0;
  final List<String> _images = [];
  String? _selectedListingType;
  Set<ExchangeTier> _selectedExchangeTiers = {};
  final _exchangeDescriptionController = TextEditingController();

  @override
  void dispose() {
    _exchangeDescriptionController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentStep > 0) {
          _previousStep();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Post Your Phone'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildProgressBar(),
              SizedBox(height: AppDimensions.padding),
              Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: _buildStepContent(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildStepButtons(),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppDimensions.padding),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 4,
            minHeight: 6,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(AppColors.accent),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentStep + 1} of 4',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                _getStepTitle(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStepTitle() {
    const titles = [
      'Upload Photos',
      'Device Details',
      'Listing Type',
      'Price & Location'
    ];
    return titles[_currentStep];
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildImageUploadStep();
      case 1:
        return _buildDetailsStep();
      case 2:
        return _buildListingTypeStep();
      case 3:
        return _buildPriceLocationStep();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildImageUploadStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Phone Images',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: AppDimensions.gapMedium),
        Text(
          'Add at least 2 real photos of your phone. Clear, well-lit images get more inquiries.',
          style: TextStyle(color: AppColors.secondary),
        ),
        SizedBox(height: AppDimensions.padding),
        Container(
          padding: EdgeInsets.all(AppDimensions.padding),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          ),
          child: Column(
            children: [
              Icon(Icons.image_outlined, size: 48, color: AppColors.accent),
              SizedBox(height: AppDimensions.gapMedium),
              Text(
                'Tap to add photos',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimensions.gapSmall),
              Text(
                '${_images.length}/6 photos added',
                style: TextStyle(color: AppColors.secondary, fontSize: 12),
              ),
            ],
          ),
        ),
        if (_images.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: AppDimensions.padding),
            child: Container(
              padding: EdgeInsets.all(AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: AppColors.error, size: 18),
                  SizedBox(width: AppDimensions.gapMedium),
                  Expanded(
                    child: Text(
                      'Minimum 2 photos required',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: AppDimensions.padding),
        _buildFormField('Brand', 'e.g., Apple, Samsung'),
        _buildFormField('Model', 'e.g., iPhone 14 Pro Max'),
        _buildFormField('Storage', 'e.g., 256GB'),
        _buildFormField('Color', 'e.g., Space Black'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Condition',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.gapMedium),
            Wrap(
              spacing: AppDimensions.gapMedium,
              runSpacing: AppDimensions.gapMedium,
              children: ['Like New', 'Excellent', 'Good', 'Fair']
                  .map((condition) => ChoiceChip(
                label: Text(condition),
                selected: false,
                onSelected: (_) {},
              ))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListingTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How do you want to list?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: AppDimensions.padding),
        _buildListingTypeCard(
          'Sell Only',
          'Straightforward sale for cash',
          'sell',
          Icons.attach_money,
        ),
        SizedBox(height: AppDimensions.gapMedium),
        _buildListingTypeCard(
          'Exchange Only',
          'Trade for another phone',
          'exchange',
          Icons.swap_horiz,
        ),
        SizedBox(height: AppDimensions.gapMedium),
        _buildListingTypeCard(
          'Sell or Exchange',
          'Accept both offers',
          'both',
          Icons.swap_calls,
        ),
        if (_selectedListingType == 'exchange' || _selectedListingType == 'both') ...[
          SizedBox(height: AppDimensions.padding),
          Container(
            padding: EdgeInsets.all(AppDimensions.padding),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exchange Preferences',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: AppDimensions.padding),
                Text(
                  'Select price ranges you\'ll accept in exchange',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: AppDimensions.gapMedium),
                Wrap(
                  spacing: AppDimensions.gapMedium,
                  runSpacing: AppDimensions.gapMedium,
                  children: ExchangeTier.values
                      .map((tier) => ExchangeTierChip(
                    tier: tier,
                    isActive: _selectedExchangeTiers.contains(tier),
                    onTap: () {
                      setState(() {
                        if (_selectedExchangeTiers.contains(tier)) {
                          _selectedExchangeTiers.remove(tier);
                        } else {
                          _selectedExchangeTiers.add(tier);
                        }
                      });
                    },
                  ))
                      .toList(),
                ),
                SizedBox(height: AppDimensions.padding),
                TextField(
                  controller: _exchangeDescriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Optional: Specific models or conditions you\'re looking for\n(e.g., "Samsung S24", "iPhone 13 or newer")',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildListingTypeCard(
    String title,
    String subtitle,
    String type,
    IconData icon,
  ) {
    final isSelected = _selectedListingType == type;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedListingType = type);
      },
      child: Container(
        padding: EdgeInsets.all(AppDimensions.padding),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withValues(alpha: 0.08) : AppColors.card,
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.gapMedium),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : AppColors.background,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.accent : AppColors.secondary,
                size: 28,
              ),
            ),
            SizedBox(width: AppDimensions.padding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: AppDimensions.gapSmall),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.accent, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price & Location',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: AppDimensions.padding),
        _buildFormField('Price (Rs)', '120000'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.gapMedium),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: AppColors.secondary),
                  SizedBox(width: AppDimensions.gapMedium),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Select your city',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: AppColors.secondary),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.padding),
        Row(
          children: [
            Checkbox(value: false, onChanged: (_) {}),
            Expanded(
              child: Text(
                'PTA Approved (Higher buyer confidence)',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormField(String label, String hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppDimensions.gapMedium),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                borderSide: BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepButtons() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.padding),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: Text('Back'),
              ),
            ),
          if (_currentStep > 0) SizedBox(width: AppDimensions.gapMedium),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep < 3 ? _nextStep : _submitForm,
              child: Text(_currentStep < 3 ? 'Next' : 'Post Listing'),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Listing posted successfully!')),
    );
    Navigator.pop(context);
  }
}
