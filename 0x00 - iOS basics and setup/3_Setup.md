
## Bread n Butter
In short, we'll want
- A jailbroken device [^1]
- Frida [^2]
- LLDB-server on the device. I might give you debugserver as a treat if you're nice.
- ... And LLDB on the haxxor machine. Exists in most repos near you.

For these, you'll need an apple account:
- Linux? Xtools (my beloved)
- Sideloader - Sideloadly, https://github.com/Samadaeus/plumeimpactor (untested), https://github.com/claration/Impactor, https://github.com/ios-control/ios-deploy (maybe?)
- Some app extractor, i like https://github.com/londek/ipadecrypt.

Impactor or Sideloadly does the signing for you automagically, but you can also use xcode codesigner or https://github.com/DanTheMan827/ios-app-signer if you run into signing issues. xtools also work at least for your own apps
	
### Jailbreaking

- Untethered
- Semi-Untethered
- Semi-Tethered
- Tethered

Macbook:
If you don't have an iOS device, you can use https://github.com/Lakr233/vphone-cli to automatically install a jailbroken device. And it's modern iOS! I cannot guarantee it's "exactly" the same as an actual device

iOS Requirements:

### Tangent:
What even is a jailbreak?
Here are my slightly fangirly notes about them: [[opt_what_even_is_a_jb]]

### Frida

## Side note
There are a ton of interesting tools I've come across, but in the workshop these aren't touched.
Regardless, my squirrel brain has stored them all in a github repository you can access here:
https://github.com/stars/etum-dev/lists/ios
Some of them are severely broken and solely saved for either historical interest or because I will remake them one day :tm: :copyright: :star: 

[^1]: Or well to be fair there are still ways to do things like Frida/LLDB "without" a jailbreak, but for this course, unless I go on some deep interest tangent, it's based on Jailbreaks to reduce asspain

### tool no worky :(
bagbak common errors
https://github.com/ChiChou/bagbak/issues/152
export SSH_USERNAME="root"  
export SSH_PASSWORD="ur custom password"

ipadecrypt is annoying and dont take command line arg for ssh port
- can fix in config
- ive forked it to fix it here: 
	https://github.com/etum-dev/ipadecrypt

[^2]: This course is (so far) more focused on low-level, but Frida is still something you'll find really useful if you decide to stick along for reversing. Basically, Frida is great for finding higher-level functions called, and then we inspect deeper with LLDB if needed.
