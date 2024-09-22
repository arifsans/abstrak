import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? const EdgeInsets.all(0)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .3,
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRIVACY NOTICE',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 20),
          Text(
            'Last updated September 21, 2024',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.withOpacity(.4),
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            'Thank you for choosing to be part of our community at LaFlame Enterprises, Inc. (“Company”, “we”, “us”, or “our”). We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about this privacy notice, or our practices with regards to your personal information, please contact us at arifsanix@gmail.com.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'When you visit our website https://arifsani.xyz (the "Website"), and more generally, use any of our services (the "Services", which include the Website), we appreciate that you are trusting us with your personal information. We take your privacy very seriously. In this privacy notice, we seek to explain to you in the clearest way possible what information we collect, how we use it and what rights you have in relation to it. We hope you take some time to read through it carefully, as it is important. If there are any terms in this privacy notice that you do not agree with, please discontinue use of our Services immediately.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'This privacy notice applies to all information collected through our Services (which, as described above, includes our Website), as well as any related services, sales, marketing or events.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Please read this privacy notice carefully as it will help you understand what we do with the information that we collect.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            'TABLE OF CONTENTS',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            '1. WHAT INFORMATION DO WE COLLECT?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            '2. HOW DO WE USE YOUR INFORMATION?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            '3. WILL YOUR INFORMATION BE SHARED WITH ANYONE?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            '4. IS YOUR INFORMATION TRANSFERRED INTERNATIONALLY?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            '5. HOW LONG DO WE KEEP YOUR INFORMATION?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            '6. DO WE COLLECT INFORMATION FROM MINORS?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            '7. WHAT ARE YOUR PRIVACY RIGHTS?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 40),
          Text(
            '1. WHAT INFORMATION DO WE COLLECT?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            'Personal information you disclose to us',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            'In Short:  We collect information that you provide to us.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          SizedBox(height: 20),
          Text(
            'We collect personal information that you voluntarily provide to us when you express an interest in obtaining information about us or our products and Services, when you participate in activities on the Website or otherwise when you contact us.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'The personal information that we collect depends on the context of your interactions with us and the Website, the choices you make and the products and features you use. The personal information we collect may include the following:',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Personal Information Provided by You. We collect email addresses; and other similar information.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 20),
          Text(
            'Payment Data. We may collect data necessary to process your payment if you make purchases, such as your payment instrument number (such as a credit card number), and the security code associated with your payment instrument. All payment data is stored by shopify.com. You may find their privacy notice link(s) here: https://www.shopify.com/legal/privacy.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'All personal information that you provide to us must be true, complete and accurate, and you must notify us of any changes to such personal information.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 20),
          Text(
            'AS BETWEEN YOU AND US, ALL RIGHT, TITLE, AND INTEREST IN AND TO OUR WEBSITE AND ITS CONTENT, FEATURES, FUNCTIONALITY, INCLUDING, BUT NOT LIMITED TO, ALL TRADEMARKS, SERVICE MARKS, TRADE NAMES, LOGOS, COPYRIGHT AND OTHER INTELLECTUAL PROPERTY RIGHTS IN OUR WEBSITE AND ITS CONTENT ARE EITHER OWNED BY US OR LICENSED TO US. ALL SUCH RIGHTS ARE PROTECTED BY INTELLECTUAL PROPERTY LAWS AROUND THE WORLD, AND ALL RIGHTS ARE RESERVED. ANY USE OF THE WEBSITE AND ITS CONTENTS, OTHER THAN AS SPECIFICALLY AUTHORISED HEREIN, IS STRICTLY PROHIBITED. ANY RIGHTS NOT EXPRESSLY GRANTED HEREIN ARE RESERVED BY US. THE TRADE MARKS, SERVICE MARKS, TRADE NAMES, LOGOS AND OTHER BRANDING OWNED BY THIRD PARTIES AND USED OR DISPLAYED ON OR VIA OUR WEBSITE (COLLECTIVELY, “THIRD PARTY MARK(S)”) MAY BE TRADE MARKS OF THEIR RESPECTIVE OWNERS, WHO MAY OR MAY NOT ENDORSE OR BE AFFILIATED WITH OR CONNECTED WITH US. EXCEPT AS EXPRESSLY PROVIDED IN THESE TERMS OF USE, OR IN TERMS PROVIDED BY THE OWNER OF A THIRD PARTY MARK, NOTHING IN THESE TERMS OF USE OR ON OR VIA THE WEBSITE SHOULD BE CONSTRUED AS GRANTING, BY IMPLICATION, ESTOPPEL, OR OTHERWISE, ANY LICENCE OR RIGHT TO USE ANY OF OUR OR ANY THIRD PARTY MARKS THAT ARE USED OR DISPLAYED ON THE WEBSITE, WITHOUT THE RESPECTIVE OWNER’S PRIOR WRITTEN PERMISSION, IN EACH INSTANCE. ALL GOODWILL GENERATED FROM THE USE OF OUR TRADE MARKS WILL BENEFIT US EXCLUSIVELY.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Information automatically collected',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            'In Short:  Some information — such as your Internet Protocol (IP) address and/or browser and device characteristics — is collected automatically when you visit our Website.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'We automatically collect certain information when you visit, use or navigate the Website. This information does not reveal your specific identity (like your name or contact information) but may include device and usage information, such as your IP address, browser and device characteristics, operating system, language preferences, referring URLs, device name, country, location, information about who and when you use our Website and other technical information. This information is primarily needed to maintain the security and operation of our Website, and for our internal analytics and reporting purposes. Like many businesses, we also collect information through cookies and similar technologies. You can find out more about this in our Cookie Notice: https://arifsani.xyz/cookie-policy. The information we collect includes:',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Log and Usage Data. Log and usage data is service-related, diagnostic usage and performance information our servers automatically collect when you access or use our Website and which we record in log files. Depending on how you interact with us, this log data may include your IP address, device information, browser type and settings and information about your activity in the Website (such as the date/time stamps associated with your usage, pages and files viewed, searches and other actions you take such as which features you use), device event information (such as system activity, error reports (sometimes called "crash dumps") and hardware settings).',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Device Data. We collect device data such as information about your computer, phone, tablet or other device you use to access the Website. Depending on the device used, this device data may include information such as your IP address (or proxy server), device application identification numbers, location, browser type, hardware model Internet service provider and/or mobile carrier, operating system configuration information.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Location Data. We collect information data such as information about your device‘s location, which can be either precise or imprecise. How much information we collect depends on the type of settings of the device you use to access the Website. For example, we may use GPS and other technologies to collect geolocation data that tells us your current location (based on your IP address). You can opt out of allowing us to collect this information either by refusing access to the information or by disabling your Locations settings on your device. Note however, if you choose to opt out, you may not be able to use certain aspects of the Services.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            '2. HOW DO WE USE YOUR INFORMATION?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            'In Short:  We process your information for purposes based on legitimate business interests, the fulfillment of our contract with you, compliance with our legal obligations, and/or your consent.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'We use personal information collected via our Website for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations. We indicate the specific processing grounds we rely on next to each purpose listed below.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'We use the information we collect or receive:',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            'To facilitate account creation and logon process. If you choose to link your account with us to a third-party account (such as your Google or Facebook account), we use the information you allowed us to collect from those third parties to facilitate account creation and logon process for the performance of the contract.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'To post testimonials. We post testimonials on our Website that may contain personal information. Prior to posting a testimonial, we will obtain your consent to use your name and the consent of the testimonial. If you wish to update, or delete your testimonial, please contact us at arifsanix@gmail.com and be sure to include your name, testimonial location, and contact information.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Request feedback. We may use your information to request feedback and to contact you about your use of our Website.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'To enable user-to-user communications. We may use your information in order to enable user-to-user communications with each user‘s consent.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'To manage user accounts. We may use your information for the purposes of managing our account and keeping it in working order.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            'To send administrative information to you. We may use your personal information to send you product, service and new feature information and/or information about changes to our terms, conditions, and policies.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'To protect our Services. We may use your information as part of our efforts to keep our Website safe and secure (for example, for fraud monitoring and prevention).',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'To enforce our terms, conditions and policies for business purposes, to comply with legal and regulatory requirements or in connection with our contract.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'To respond to legal requests and prevent harm. If we receive a subpoena or other legal request, we may need to inspect the data we hold to determine how to respond.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            'Fulfill and manage your orders. We may use your information to fulfill and manage your orders, payments, returns, and exchanges made through the Website.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Administer prize draws and competitions. We may use your information to administer prize draws and competitions when you elect to participate in our competitions.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'To deliver and facilitate delivery of services to the user. We may use your information to provide you with the requested service.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'To respond to user inquiries/offer support to users. We may use your information to respond to your inquiries and solve any potential issues you might have with the use of our Services.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            'To send you marketing and promotional communications. We and/or our third-party marketing partners may use the personal information you send to us for our marketing purposes, if this is in accordance with your marketing preferences. For example, when expressing an interest in obtaining information about us or our Website, subscribing to marketing or otherwise contacting us, we will collect personal information from you. You can opt-out of our marketing emails at any time (see the "WHAT ARE YOUR PRIVACY RIGHTS" below).',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Deliver targeted advertising to you. We may use your information to develop and display personalized content and advertising (and work with third parties who do so) tailored to your interests and/or location and to measure its effectiveness. For more information, see our Cookie Notice: https://arifsan-.xyz/cookie-policy.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            'For other business purposes. We may use your information for other business purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Website, products, marketing and your experience. We may use and store this information in aggregated and anonymized form so that it is not associated with individual end users and does not include personal information. We will not use identifiable personal information without your consent.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            '3. WILL YOUR INFORMATION BE SHARED WITH ANYONE?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            'In Short:  We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'We may process or share your data that we hold based on the following legal basis:',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 20),
          Text(
            'Consent: We may process your data if you have given us specific consent to use your personal information in a specific purpose.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Legitimate Interests: We may process your data when it is reasonably necessary to achieve our legitimate business interests.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Performance of a Contract: Where we have entered into a contract with you, we may process your personal information to fulfill the terms of our contract.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Legal Obligations: We may disclose your information where we are legally required to do so in order to comply with applicable law, governmental requests, a judicial proceeding, court order, or legal process, such as in response to a court order or a subpoena (including in response to public authorities to meet national security or law enforcement requirements).',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Vital Interests: We may disclose your information where we believe it is necessary to investigate, prevent, or take action regarding potential violations of our policies, suspected fraud, situations involving potential threats to the safety of any person and illegal activities, or as evidence in litigation in which we are involved.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'More specifically, we may need to process your data or share your personal information in the following situations:',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Business Transfers. We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Vendors, Consultants and Other Third-Party Service Providers. We may share your data with third-party vendors, service providers, contractors or agents who perform services for us or on our behalf and require access to such information to do that work. Examples include: payment processing, data analysis, email delivery, hosting services, customer service and marketing efforts. We may allow selected third parties to use tracking technology on the Website, which will enable them to collect data on our behalf about how you interact with our Website over time. This information may be used to, among other things, analyze and track data, determine the popularity of certain content, pages or features, and better understand online activity. Unless described in this notice, we do not share, sell, rent or trade any of your information with third parties for their promotional purposes. We have contracts in place with our data processors, which are designed to help safegaurd your personal information. This means that they cannot do anything with your personal information unless we have instructed them to do it. They will also not share your personal information with any organization apart from us. They also commit to protect the data they hold on our behalf and to retain it for the period we instruct.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Affiliates. We may share your information with our affiliates, in which case we will require those affiliates to honor this privacy notice. Affiliates include our parent company and any subsidiaries, joint venture partners or other companies that we control or that are under common control with us.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Business Partners. We may share your information with our business partners to offer you certain products, services or promotions.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            '4. DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            'In Short:  We may use cookies and other tracking technologies to collect and store your information.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'We may use cookies and similar tracking technologies (like web beacons and pixels) to access or store information. Specific information about how we use such technologies and how you can refuse certain cookies is set out in our Cookie Notice: https://arifsani.xyz/cookie-policy.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            '4. DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            'In Short:  We may use cookies and other tracking technologies to collect and store your information.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'We may use cookies and similar tracking technologies (like web beacons and pixels) to access or store information. Specific information about how we use such technologies and how you can refuse certain cookies is set out in our Cookie Notice: https://arifsani.xyz/cookie-policy.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            '5. IS YOUR INFORMATION TRANSFERRED INTERNATIONALLY?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            'In Short:  We may transfer, store, and process your information in countries other than your own.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'Our servers are located in United States. If you are accessing our Website from outside United States, please be aware that your information may be transferred to, stored, and processed by us in our facilities and by those third parties with whom we may share your personal information (see "WILL YOUR INFORMATION BE SHARED WITH ANYONE?" above), in and other countries.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'If you are a resident in the European Economic Area, then these countries may not necessarily have data protection laws or other similar laws as comprehensive as those in your country. We will however take all necessary measures to protect your personal information in accordance with this privacy notice and applicable law.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            '6. HOW LONG DO WE KEEP YOUR INFORMATION?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            'In Short:  We keep your information for as long as necessary to fulfill the purposes outlined in this privacy notice unless otherwise required by law.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'We will only keep your personal information for as long as it is necessary for the purposes set out in this privacy notice, unless a longer retention period is required or permitted by law (such as tax, accounting or other legal requirements). No purpose in this notice will require us keeping your personal information for longer than 2 years.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'When we have no ongoing legitimate business need to process your personal information, we will either delete or anonymize such information, or, if this is not possible (for example, because your personal information has been stored in backup archives), then we will securely store your personal information and isolate it from any further processing until deletion is possible.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 40),
          Text(
            '7. DO WE COLLECT INFORMATION FROM MINORS?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 20),
          Text(
            'In Short:  We do not knowingly collect data from or market to children under 18 years of age.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Text(
            'We do not knowingly solicit data from or market to children under 18 years of age. By using the Website, you represent that you are at least 18 or that you are the parent or guardian of such a minor and consent to such minor dependent’s use of the Website. If we learn that personal information from users less than 18 years of age has been collected, we will deactivate the account and take reasonable measures to promptly delete such data from our records. If you become aware of any data we may have collected from children under age 18, please contact us at arifsanix@gmail.com.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
