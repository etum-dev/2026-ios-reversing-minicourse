
## Bread n Butter
In short, we'll want
- A jailbroken device [^1]
- Frida [^2]
- LLDB-server on the device. I might give you debugserver as a treat if you're nice.
- ... And LLDB on the haxxor machine. Exists in most repos near you.

For these, you'll need an apple account:
- Linux? Xtools (my beloved)
- Mac/Windows - Sideloadly 
	- ... When I am not lazy maybe I will look into making better OSS alternatives who knows
- Some app extractor, i like https://github.com/londek/ipadecrypt.
	
### Jailbreaking
Macbook:
If you don't have an iOS device, you can use https://github.com/Lakr233/vphone-cli to automatically install a jailbroken device. And it's modern iOS! I cannot guarantee it's "exactly" the same as an actual device

iOS Requirements:



### Frida

## Side note
There are a ton of interesting tools I've come across, but in the workshop these aren't touched.
Regardless, my squirrel brain has stored them all in a github repository you can access here:
https://github.com/stars/etum-dev/lists/ios
Some of them are severely broken and solely saved for either historical interest or because I will remake them one day :tm: :copyright: :star: 

[^1]: Or well to be fair there are still ways to do things like Frida/LLDB "without" a jailbreak, but for this course, unless I go on some deep interest tangent, it's based on Jailbreaks to reduce asspain
	

[^2]: This course is (so far) more focused on low-level, but Frida is still something you'll find really useful if you decide to stick along for reversing. Basically, Frida is great for finding higher-level functions called, and then we inspect deeper with LLDB if needed.
