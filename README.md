# JZTPerformanceMonitor
性能检测 接口抓包

1.记录启动时间 在 AppDelegate didFinishLaunchingWithOptions：方法里执行
[[JZTLaunchTimeManager manager] startRecord];
viewDidAppear:
[[JZTLaunchTimeManager manager] endRecord];

2.开启app内部接口抓包
[JZTSessionConfiguration configurationURLProtocol];

3.记录app崩溃
[JZTCaptureException start];

4.开启可视化窗口实时观测以上数据 在RootViewController viewDidAppear:方法里执行
JZTDragWindow *dragWindow = [JZTDragWindow window];
[dragWindow makeKeyAndVisible];
