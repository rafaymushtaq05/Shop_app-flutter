import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  Future<void> _refreshOrders(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _IndicatorRefreshOrders(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return RefreshIndicator(
      onRefresh: () => _IndicatorRefreshOrders(context),
      backgroundColor: Colors.white,
      color: Colors.orange,
      edgeOffset: 100,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Your Orders'),
          actions: <Widget>[
            IconButton(
                onPressed: () => _refreshOrders(context),
                icon: const Icon(Icons.refresh_rounded)),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.orange,
              ))
            : ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
              ),
      ),
    );
  }
}
