import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/screens/service/service_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

/// Web Layout - Split two-column design for Service Screen
class ServiceWebLayout extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const ServiceWebLayout({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Side - Ratings & Service Info
        Expanded(
          flex: 4,
          child: ColoredBox(
            color: AppPalette.whiteColor,
            child: ServiceWebLeftSection(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ),

        // Right Side - Service Management Form
        Expanded(
          flex: 6,
          child: Container(
            color: AppPalette.whiteColor,
            child: ServiceWebRightSection(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ),
      ],
    );
  }
}

/// Left Section - Ratings and Service Information
class ServiceWebLeftSection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const ServiceWebLeftSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Row(
              children: [
                Container(
                  width: 4,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppPalette.buttonColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ConstantWidgets.width20(context),
                Expanded(
                  child: Text(
                    'Service Management',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.blackColor,
                    ),
                  ),
                ),
              ],
            ),
            ConstantWidgets.hight10(context),

            // Description
            Text(
              'Manage your barber shop services, ratings, and detailed information. Upload service images and generate comprehensive documentation.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppPalette.blackColor,
                height: 1.6,
              ),
            ),
            ConstantWidgets.hight20(context),

            // Ratings Section Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppPalette.buttonColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppPalette.buttonColor.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.blackColor.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ratings & Reviews',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: AppPalette.blueColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'by verified Customers',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppPalette.greyColor,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showReviewDetisSheet(
                            context,
                            screenHeight,
                            screenWidth,
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppPalette.buttonColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  ConstantWidgets.hight20(context),
                  Row(
                    children: [
                      Text(
                        '0.0 / 5',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: RatingBarIndicator(
                          rating: 0.0,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: AppPalette.buttonColor,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                      ),
                    ],
                  ),
                  ConstantWidgets.hight10(context),
                  Text(
                    'Ratings and reviews are verified and are from people who use the same type of device that you use ⓘ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppPalette.blackColor.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ConstantWidgets.hight20(context),

            // Service Features Title
            Text(
              'Service Features',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppPalette.blackColor,
              ),
            ),
            ConstantWidgets.hight10(context),

            // Feature Cards
            _buildFeatureCard(
              context: context,
              icon: Icons.upload_file,
              title: 'Service Images',
              description: 'Upload detailed images of your barber shop and services',
              color: AppPalette.buttonColor,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context: context,
              icon: Icons.people,
              title: 'Gender Options',
              description: 'Specify service availability: Male, Female, or Unisex',
              color: AppPalette.orengeColor,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context: context,
              icon: Icons.picture_as_pdf,
              title: 'Documentation',
              description: 'Generate professional PDF for service management',
              color: AppPalette.greenColor,
            ),
            ConstantWidgets.hight20(context),

            // Additional Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppPalette.buttonColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppPalette.buttonColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppPalette.buttonColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'The generated BarberDocs will compile all submitted information, serving as an official reference for service management.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppPalette.blackColor.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
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

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.blackColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppPalette.blackColor.withValues(alpha: 0.6),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Right Section - Service Management Form
class ServiceWebRightSection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const ServiceWebRightSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppPalette.buttonColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ConstantWidgets.width20(context),
                Text(
                  'Barber Details',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Text(
              'Please provide complete details of your barber shop. This information will be used for service documentation.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppPalette.blackColor.withValues(alpha: 0.6),
                height: 1.6,
              ),
            ),
            ConstantWidgets.hight20(context),

            // Service Details Form
            ViewServiceDetailsPage(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ],
        ),
      ),
    );
  }
}

