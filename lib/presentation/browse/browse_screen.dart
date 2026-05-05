import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive_utils.dart';
import '../../data/models/product_model.dart';
import '../product_detail/product_detail_screen.dart';
import '../shared/product_card.dart';
import '../shared/filter_pill.dart';
import '../shared/widgets/empty_state.dart';
import '../../core/controllers/browse_controller.dart';
import '../../core/controllers/wishlist_controller.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final browseController = Get.find<BrowseController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredListings = browseController.filteredListings;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(AppDimensions.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.appName,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Row(
                            children: [
                              Icon(Icons.notifications_outlined, color: AppColors.primary),
                              SizedBox(width: AppDimensions.padding),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.person, color: Colors.white, size: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.padding),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: AppColors.secondary),
                            SizedBox(width: AppDimensions.gapMedium),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  browseController.setSearchQuery(value);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search phones...',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: AppColors.secondary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimensions.padding),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Obx(() => Row(
                          children: [
                            FilterPill(
                              label: 'All',
                              isSelected: browseController.selectedFilter.value == null,
                              onTap: () {
                                browseController.setFilter(null);
                              },
                            ),
                            SizedBox(width: AppDimensions.gapMedium),
                            FilterPill(
                              label: 'PTA Approved',
                              isSelected: browseController.selectedFilter.value == 'pta',
                              onTap: () {
                                browseController.setFilter('pta');
                              },
                            ),
                            SizedBox(width: AppDimensions.gapMedium),
                            FilterPill(
                              label: 'Under 100K',
                              isSelected: browseController.selectedFilter.value == 'under100k',
                              onTap: () {
                                browseController.setFilter('under100k');
                              },
                            ),
                            SizedBox(width: AppDimensions.gapMedium),
                            FilterPill(
                              label: 'Deals',
                              isSelected: browseController.selectedFilter.value == 'deals',
                              onTap: () {
                                browseController.setFilter('deals');
                              },
                            ),
                            SizedBox(width: AppDimensions.gapMedium),
                            FilterPill(
                              label: 'Nearby',
                              isSelected: browseController.selectedFilter.value == 'nearby',
                              onTap: () {
                                browseController.setFilter('nearby');
                              },
                            ),
                            SizedBox(width: AppDimensions.gapMedium),
                            FilterPill(
                              label: 'Verified',
                              isSelected: browseController.selectedFilter.value == 'verified',
                              onTap: () {
                                browseController.setFilter('verified');
                              },
                            ),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
                if (filteredListings.isEmpty)
                  EmptyState(
                    type: EmptyStateType.noSearchResults,
                    onAction: () {
                      browseController.setFilter(null);
                      browseController.setSearchQuery('');
                    },
                    actionLabel: 'Clear Filters',
                  )
                else
                  AnimationLimiter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.getHorizontalPadding(context)),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredListings.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: ResponsiveUtils.getGridMaxCrossAxisExtent(context),
                          childAspectRatio: ResponsiveUtils.getChildAspectRatioForExtent(context),
                          crossAxisSpacing: AppDimensions.gapMedium,
                          mainAxisSpacing: AppDimensions.gapMedium,
                        ),
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: (MediaQuery.of(context).size.width / ResponsiveUtils.getGridMaxCrossAxisExtent(context)).ceil(),
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: ProductCard(
                                  product: filteredListings[index],
                                  onTap: () {
                                    Get.to(() => ProductDetailScreen(
                                      product: filteredListings[index],
                                    ));
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                SizedBox(height: AppDimensions.padding),
              ],
            ),
          ),
        ),
      );
    });
  }
}
