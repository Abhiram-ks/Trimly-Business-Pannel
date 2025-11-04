
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/delete_post_cubit/delete_post_cubit.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc.dart';
import '../../state/bloc/image_picker_bloc/image_picker_bloc.dart';
import '../../state/bloc/lauch_service_bloc/lauch_service_bloc.dart';
import '../../state/bloc/upload_post_bloc/upload_post_bloc.dart';
import '../../widget/settings_widget/taps_widgets/tab_bar_image_show_widget.dart';
import '../../widget/settings_widget/taps_widgets/tab_bar_post_add_widget.dart';
import '../../widget/settings_widget/taps_widgets/tab_bar_setting_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return Scaffold(
          body: BlocBuilder<FetchBarberBloc, FetchBarberState>(
            builder: (context, state) {
              if (state is FetchBarberLoading) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          color: AppPalette.hintColor,
                          backgroundColor: AppPalette.buttonColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                      ConstantWidgets.width20(context),
                      Text(
                        'Please wait...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is FetchBarberLoaded) {
                return ProfileScrollView(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  barber: state.barber,
                );
              }
              return ProfileScrollView(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                barber: BarberEntity(
                  barberName: '',
                  image: '',
                  ventureName: '',
                  email: '',
                  address: '',
                  uid: '',
                  phoneNumber: '',
                  isVerified: false,
                  isBloc: false,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ProfileScrollView extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final BarberEntity barber;

  const ProfileScrollView({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.barber,
  });

  @override
  State<ProfileScrollView> createState() => _ProfileScrollViewState();
}

class _ProfileScrollViewState extends State<ProfileScrollView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final bool isWebView = widget.screenWidth > 900;
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ImagePickerBloc>()),
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => sl<UploadPostBloc>()),
        BlocProvider(create: (context) => sl<DeletePostCubit>()),
        BlocProvider(create: (context) => sl<LauchServiceBloc>()),
      ],
      child: isWebView ? _buildWebLayout() : _buildMobileLayout(),
    );
  }
  
  // Mobile Layout - Original Design
  Widget _buildMobileLayout() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: AppPalette.blackColor,
          expandedHeight: widget.screenHeight * 0.35,
          pinned: true,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              bool isCollapsed =
                  constraints.biggest.height <=
                  kToolbarHeight + MediaQuery.of(context).padding.top;
              return FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                title:
                    isCollapsed
                        ? Row(
                          children: [
                            ConstantWidgets.width40(context),
                            Text(
                              widget.barber.barberName,
                              style: TextStyle(color: AppPalette.whiteColor),
                            ),
                          ],
                        )
                        : Text(''),
                titlePadding: EdgeInsets.only(left: widget.screenWidth * .04),
                background: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.screenWidth * 0.08,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstantWidgets.hight30(context),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  color: AppPalette.greyColor,
                                  width: 60,
                                  height: 60,
                                  child:
                                      (widget.barber.image != null &&
                                              widget.barber.image!.startsWith(
                                                'http',
                                              ))
                                          ? imageshow(
                                            imageUrl: widget.barber.image!,
                                            imageAsset: AppImages.appLogo,
                                          )
                                          : Image.asset(
                                            AppImages.appLogo,
                                            fit: BoxFit.cover,
                                          ),
                                ),
                              ),
                              ConstantWidgets.width40(context),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  profileviewWidget(
                                    widget.screenWidth,
                                    context,
                                    Icons.lock_person_outlined,
                                    "Hello, ${widget.barber.barberName}",
                                    AppPalette.whiteColor,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.profile,
                                        arguments: true,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppPalette.whiteColor,
                                      minimumSize: const Size(0, 0),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0,
                                        vertical: 2.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                        color: AppPalette.buttonColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ConstantWidgets.hight30(context),
                          profileviewWidget(
                            widget.screenWidth,
                            context,
                            Icons.add_business_rounded,
                            widget.barber.ventureName,
                            AppPalette.whiteColor,
                          ),
                          profileviewWidget(
                            widget.screenWidth,
                            context,
                            Icons.attach_email,
                            widget.barber.email,
                            AppPalette.whiteColor,
                          ),
                          profileviewWidget(
                            widget.screenWidth,
                            context,
                            Icons.location_on_rounded,
                            widget.barber.address,
                            AppPalette.whiteColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: TabBarDelegate(
            TabBar(
              controller: _tabController,
              automaticIndicatorColorAdjustment: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: AppPalette.buttonColor,
              labelColor: AppPalette.whiteColor,
              unselectedLabelColor: const Color.fromARGB(255, 128, 128, 128),
              tabs: const [
                Tab(icon: Icon(Icons.grid_view_rounded)),
                Tab(icon: Icon(CupertinoIcons.photo)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: true,
          child: AnimatedBuilder(
            animation: _tabController,
            builder: (context, child) {
              return _buildTabContent(
                _tabController.index,
                widget.screenHeight,
                widget.screenWidth,
                context,
                _scrollController,
                widget.barber,
              );
            },
          ),
        ),
      ],
    );
  }
  
  // Web Layout - Two Column Design
  Widget _buildWebLayout() {
    return Container(
      color: AppPalette.blackColor,
      child: Row(
        children: [
          Container(
            width: widget.screenWidth * 0.30,
            decoration: BoxDecoration(
              color: AppPalette.blackColor,
            ),
            child: _buildWebProfileSidebar(),
          ),
          
          Expanded(
            child: Container(
              color: AppPalette.whiteColor,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppPalette.blackColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      automaticIndicatorColorAdjustment: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: AppPalette.buttonColor,
                      labelColor: AppPalette.whiteColor,
                      unselectedLabelColor: const Color.fromARGB(255, 128, 128, 128),
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.grid_view_rounded),
                          text: 'Gallery',
                        ),
                        Tab(
                          icon: Icon(CupertinoIcons.photo),
                          text: 'Add Post',
                        ),
                        Tab(
                          icon: Icon(Icons.settings),
                          text: 'Settings',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _tabController,
                      builder: (context, child) {
                        return _buildTabContent(
                          _tabController.index,
                          widget.screenHeight,
                          widget.screenWidth * 0.70,
                          context,
                          _scrollController,
                          widget.barber,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWebProfileSidebar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
         ConstantWidgets.hight20(context),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              color: AppPalette.greyColor,
              width: 120,
              height: 120,
              child: (widget.barber.image != null &&
                      widget.barber.image!.startsWith('http'))
                  ? imageshow(
                      imageUrl: widget.barber.image!,
                      imageAsset: AppImages.noImage,
                    )
                  : Image.asset(
                      AppImages.noImage,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
         ConstantWidgets.hight20(context),
          Text(
            widget.barber.barberName,
            style: const TextStyle(
              color: AppPalette.whiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
         ConstantWidgets.hight10(context),
          if (widget.barber.isVerified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppPalette.buttonColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    color: AppPalette.buttonColor,
                    size: 16,
                  ),
                  ConstantWidgets.width10(context),
                  Text(
                    'Verified',
                    style: TextStyle(
                      color: AppPalette.buttonColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          
         ConstantWidgets.hight20(context),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.profile,
                  arguments: true,
                );
              },
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.buttonColor,
                foregroundColor: AppPalette.whiteColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
         ConstantWidgets.hight20(context),
          Divider(color: AppPalette.hintColor),
         ConstantWidgets.hight20(context),
          _buildWebProfileInfo(
            Icons.add_business_rounded,
            'Venture',
            widget.barber.ventureName,
          ),
         ConstantWidgets.hight10(context),
          _buildWebProfileInfo(
            Icons.attach_email,
            'Email',
            widget.barber.email,
          ),
          ConstantWidgets.hight10(context),
          _buildWebProfileInfo(
            Icons.phone,
            'Phone',
            widget.barber.phoneNumber,
          ),
          const SizedBox(height: 20),
          _buildWebProfileInfo(
            Icons.location_on_rounded,
            'Address',
            widget.barber.address,
          ),
          
         ConstantWidgets.hight20(context),
        ],
      ),
    );
  }
  
  Widget _buildWebProfileInfo(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppPalette.buttonColor,
              size: 18,
            ),
            ConstantWidgets.width10(context),
            Text(
              label,
              style: TextStyle(
                color: AppPalette.greyColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(
            value,
            style: const TextStyle(
              color: AppPalette.whiteColor,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  TabBarDelegate(this.tabBar);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppPalette.blackColor, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

//Tabbar bodys

Widget _buildTabContent(
  int tabIndex,
  double screenHeight,
  double screenWidth,
  BuildContext context,
  ScrollController scrollController,
  BarberEntity barber,
) {
  switch (tabIndex) {
    case 0:
      return TabbarImageShow();
    case 1:
      return TabbarAddPost(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        scrollController: scrollController,
      );
    case 2:
      return TabbarSettings(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      );
    default:
      return Center(child: Text("Unknown Tab"));
  }
}

Image imageshow({required String imageUrl, required String imageAsset}) {
  return Image.network(
    imageUrl,
    fit: BoxFit.fill  ,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          color: AppPalette.buttonColor,
          value:
              loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(imageAsset, fit: BoxFit.cover);
    },
  );
}

SizedBox profileviewWidget(
  double screenWidth,
  BuildContext context,
  IconData icons,
  String heading,
  Color iconclr, {
  Color? textColor,
  int? maxLines,
}) {
  return SizedBox(
    width: screenWidth * 0.55,
    child: Row(
      children: [
        Icon(icons, color: iconclr, size: 15),
        ConstantWidgets.width20(context),
        Expanded(
          child: Text(
            heading,
            style: TextStyle(color: textColor ?? AppPalette.whiteColor),
            maxLines: maxLines ?? 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

IconButton iconsFilledDetail({
  required BuildContext context,
  required Color fillColor,
  required double borderRadius,
  required Color forgroudClr,
  required double padding,
  required VoidCallback onTap,
  required IconData icon,
}) {
  return IconButton.filled(
    onPressed: onTap,
    icon: Icon(icon),
    style: IconButton.styleFrom(
      backgroundColor: fillColor,
      foregroundColor: forgroudClr,
      padding: EdgeInsets.all(padding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}

Column detailsPageActions({
  required BuildContext context,
  required double screenWidth,
  required IconData icon,
  required VoidCallback onTap,
  Color? colors,
  required String text,
}) {
  return Column(
    children: [
      iconsFilledDetail(
        icon: icon,
        forgroudClr: colors ?? AppPalette.buttonColor,
        context: context,
        borderRadius: 15,
        padding: screenWidth > 600 ? 30 : screenWidth * .05,
        fillColor: Color.fromARGB(255, 237, 216, 248),
        onTap: onTap,
      ),
      Text(text),
    ],
  );
}
