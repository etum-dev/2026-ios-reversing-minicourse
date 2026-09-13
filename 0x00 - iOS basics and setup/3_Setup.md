
## Bread n Butter
In short, we'll want
- A jailbroken device [^1]
- Frida [^2]
- LLDB-server on the device. I might give you debugserver as a treat if you're nice.
- ... And LLDB on the haxxor machine. Exists in most repos near you.
- HTTP Proxying
- Application extraction tools
- Application signing tools

For these, you'll need an apple account:
- Linux? Xtools (my beloved)
- Sideloader - Sideloadly, https://github.com/Samadaeus/plumeimpactor (untested), https://github.com/claration/Impactor, https://github.com/ios-control/ios-deploy (maybe?)
- Some app extractor, i like https://github.com/londek/ipadecrypt.

Impactor or Sideloadly does the signing for you automagically, but you can also use xcode codesigner or https://github.com/DanTheMan827/ios-app-signer if you run into signing issues. xtools also work at least for your own apps
	
## Jailbreaking
We can tierlist the jailbreaks:

- Untethered - S, Hard to find exploits for but survives reboots.
- Semi-Untethered - A, The jailbreaks works but will disappear on a reboot/shutoff from the device.
- Semi-Tethered - A, Just requires the exploit to be run from a computer. Which, lets be honest, we are all probably sitting with anyway.
- Tethered - D, this might make your phone dependant on being eg hooked into a PC all the time. It's mostly a primer to develop a more stable jailbreak.

You can get a list of compatible JBs here: https://theapplewiki.com/wiki/Jailbreak

Macbook:
If you don't have an iOS device, you can use https://github.com/Lakr233/vphone-cli to automatically install a jailbroken device. And it's modern iOS! I cannot guarantee it's "exactly" the same as an actual device.

vphone CLI does have a "vm create" command, but I'd advice doing it manually, because vm create does not return good errors if stuff go wrong. (as of writing at least)

iOS Requirements:
You can find jailbreakable phones on 2nd hand (I just found 4 that were vulnerable for Dopamine, for less than 130$!)
The most stable purchases are the devices that are vulnerable for issues targetting hardware that apple cannot patch, like palera1n. 
That way you can be a little less paranoid for a forced/unintended update.

### Tangent:
What even is a jailbreak?
Here are my slightly fangirly notes about them: [[opt_what_even_is_a_jb]]

## Frida
Frida is a PITA when it comes to versions.
I made a script so you can kind of "brute force" frida versions until one works:
https://github.com/etum-dev/DroidSH/blob/main/ios_frida.sh

Deploy frida-server on the phone. You can do this using scp or with a Sileo package, but opt towards scp from a file you control, since you'll know exactly what version is used. 

Once you got frida up and running, on a plugged in iOS, you can run:
`frida-ps -Uai` 

## Proxy
Funnily enough, iOS is easier than Android to proxy.
If you run testing from your host, the OOTB documentation works:
- https://portswigger.net/burp/documentation/desktop/mobile/config-ios-device
- https://docs.caido.io/app/tutorials/ios_configuration

## My VM Setup
Sometimes, if I have had enough ugg boots and starbucks, i just rawdog on my Mac host,
but I prefer Linux+VMs.
- Host: Arch (btw)
- Virt-manager/KVM, Debian guest

### Proxying from device to VM
First, to have the iphone get a proxy IP, we expose the VM with a bridge. 

Get device id to bridge:
`ip -br a #should return something like enpXYZ`

Then, setup bridge. Make sure to backup your hosts network conf beforehand in case you get locked out of the internet. ... Or don't backup. Might benefit us all.
```
sudo ip link set enp42s0 nomaster
sudo ip link del br0
sudo systemctl restart systemd-networkd
```
Then, ensure your VM is off.
Edit the VM network conf to use the bridge: 

Change `<source bridge='virbr0'/>` to ` <source bridge='br0'/> `

Start VM, you should have an IP address part of your Lan.
Set this IP to be the proxy address on your iPhone. 

## Troubleshooting
bagbak common errors
https://github.com/ChiChou/bagbak/issues/152
export SSH_USERNAME="root"  
export SSH_PASSWORD="ur custom password"

ipadecrypt is annoying and dont take command line arg for ssh port
- can fix in config
- ive forked it to fix it here: 
	https://github.com/etum-dev/ipadecrypt

## Side note
There are a ton of interesting tools I've come across, but in the workshop these aren't touched.
Regardless, my squirrel brain has stored them all in a github repository you can access here:
https://github.com/stars/etum-dev/lists/ios
Some of them are severely broken and solely saved for either historical interest or because I will remake them one day :tm: :copyright: :star: 

[^1]: Or well to be fair there are still ways to do things like Frida/LLDB "without" a jailbreak, but for this course, unless I go on some deep interest tangent, it's based on Jailbreaks to reduce asspain

[^2]: This course is (so far) more focused on low-level, but Frida is still something you'll find really useful if you decide to stick along for reversing. Basically, Frida is great for finding higher-level functions called, and then we inspect deeper with LLDB if needed.
