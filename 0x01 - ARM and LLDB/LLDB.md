Why even learn LLDB?
In my eyes, i see it a little bit like web proxy tools like burp, but for binaries. Stop and intercepting memory (or even change it!)
It has cool features too, so you can run eg swift code straight up in the debugger!

## Setup LLDB
While its possible to rawdog lldb straight on the device, i prefer LLDB-server on the device, then hook up on my host.
That way, i can run LLDB scripts without having to add a bunch of py/library dependencies on the device.  [^1]

Get debugserver:
- hdiutil mount /Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport/16.0/DeveloperDiskImage.dmg
Ensure that the deviceSupport version is for a compatible platform.

ldid -sMyentitlements.xml debugserver

on mobile: ./debugserver 0.0.0.0:6666 --waitfor="Running App Here"

on host: process connect connect.//<ip>:6666

Or if you have Sileo/Zebra/Whatever, you might be able to get a compatible and already entitled LLDB-server in the repo.

## cheatsheet
**launching processes**
help process launch
lldb -n hello_world -w || lldb -f /tmp/hello_world + process launch

You can run Swiftcode!
(lldb):
```
ex -l swift -- import Foundation
ex -l swift -- import AppKit
```


[^1]:LLDB utils: https://github.com/etum-dev/LLDB - Fork will (eventually) be updated to be more ARM focused and probably replace x64/x86


