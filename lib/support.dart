import 'package:abstrak/x_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
          ? const EdgeInsets.all(0)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .2,
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'ALL SALES FINAL. NO RETURNS, EXCHANGES, OR MODIFICATIONS TO YOUR ORDER AFTER PLACED.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'FOR CUSTOMER SERVICE PLEASE CLICK BELOW:',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          XButton(
            text: 'CONTACT CUSTOMER SERVICE',
            borderColor: Colors.white,
            textStyle: Theme.of(context).textTheme.bodyLarge,
            paddingButton: EdgeInsets.fromLTRB(
              MediaQuery.sizeOf(context).width * .1,
              12,
              MediaQuery.sizeOf(context).width * .1,
              10,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'YOU WILL RECEIVE TRACKING ONCE THE ORDER SHIPS.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'ORDERS WITH MULTIPLE ITEMS WILL HAVE EACH ITEM INDIVIDUALLY SHIPPED AS RECEIVED AT THE WAREHOUSE IN ORDER TO GET YOU YOUR ORDER AS QUICKLY AS POSSIBLE. SHIPPING EACH ITEM SEPARATELY ALLOWS US TO DELIVER YOUR ORDER IN THE MOST TIME EFFICIENT MANNER.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'INTERNATIONAL CUSTOMERS ARE RESPONSIBLE FOR DUTY AND TAX ON DELIVERY. DUTY AND TAX MAY VARY BY COUNTRY.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'REFUSED PACKAGES WILL BE CONSIDERED FORFEITED AND ARE NOT ELIGIBLE FOR REFUND OR CREDIT.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'WE ARE NOT RESPONSIBLE FOR ANY LOST, STOLEN OR DAMAGED SHIPMENTS. CUSTOMERS ARE RESPONSIBLE FOR PAYING ADDITIONAL SHIPPING AND HANDLING FEES TO HAVE THE ORDER RE-SHIPPED, IF AVAILABLE.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'THE BUYER ASSUMES ALL RESPONSIBILITIES OF CLAIMS MADE WITH THE SHIPPING CARRIER. PLEASE CONTACT CUSTOMER SERVICE WITH ANY QUESTIONS REGARDING CARRIER CLAIMS.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'IN ORDER TO PROVIDE THE BEST CUSTOMER SERVICE, ANY CONCERNS REGARDING ORDERS MUST BE RECEIVING IN WRITING WITHIN 7 DAYS WITHIN THE DELIVERY OF THE ORDER.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
