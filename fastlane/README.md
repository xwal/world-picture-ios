fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios pgyer_beta
```
fastlane ios pgyer_beta
```
生成 adhoc 测试版本，提交到蒲公英，参数 => type:'adhoc/development'，默认adhoc
### ios pgyer_release
```
fastlane ios pgyer_release
```
生成 adhoc 预发版本，提交到蒲公英
### ios appstore_release
```
fastlane ios appstore_release
```
生成 appstore 版本，发布到 App Store
### ios add_devices_manual
```
fastlane ios add_devices_manual
```
手动批量添加设备到profile
### ios add_devices_file
```
fastlane ios add_devices_file
```
文件批量添加设备到profile
### ios export_devices
```
fastlane ios export_devices
```
批量导出设备
### ios refresh_profiles
```
fastlane ios refresh_profiles
```
更新 provisioning profiles
### ios sync_cert_profiles
```
fastlane ios sync_cert_profiles
```
同步 certificates 和 provisioning profiles
### ios remove_local_profiles
```
fastlane ios remove_local_profiles
```
移除本地描述文件
### ios generate_apns_cert
```
fastlane ios generate_apns_cert
```
生成APNs证书
### ios sync_metadata
```
fastlane ios sync_metadata
```
同步 metadata

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
