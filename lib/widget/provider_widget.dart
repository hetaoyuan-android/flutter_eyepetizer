import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T model;//控件对应的数据
  final Widget child;

  final Widget Function(BuildContext context, T model, Widget child) builder;//绑定数据的控件
  final Function(T) onModelInit; //数据初始化方法

  const ProviderWidget(
      {Key key,
        @required this.model,
        @required this.builder,
        this.onModelInit,
        this.child})
      : super(key: key);

  @override
  _ProviderWidgetState createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T>> {
  T model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    if (widget.onModelInit != null && model != null) {
      widget.onModelInit(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => model,
        child: Consumer<T>(
            builder: widget.builder,
            child: widget.child));
  }
}
