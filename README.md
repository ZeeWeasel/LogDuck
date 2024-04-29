<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->


<!-- PROJECT LOGO -->
<div align="center">
    <img src="https://github.com/ZeeWeasel/LogDuck/blob/main/images/icon.png?raw=true" alt="Logo" width="240" height="240">

<h3 align="center">LogDuck for GodotEngine</h3>

  <p align="center">
    A straight-forward logging addon for Godot 4.x to centralize and manage your Debug output for your project.
    <br />
    ·
    <a href="https://github.com/ZeeWeasel/LogDuck/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/ZeeWeasel/LogDuck/issues/new?labels=enhancement&template=feature-request---.md">Request Features</a>
     ·
    <a href="https://discord.gg/XSWkS2fWJc">Discord Server</a>
	</p>
</div>

<br>
<br>



## Installation

* Download the .zip file and extract the LogDuck folder into your addons folder in your Godot Project.<br><br>At the top of LogDuck.gd are the settings to change how you'd like LogDuck to behave and how to format it. Every entry has a short explanation what it does. By default LogDuck will push warnings and errors automatically into the Debugger and rich output is enabled. 

* Alternatively, you can take the LogDuck.gd script and drag it into your project, and add it as an autoloaded script. 
Make sure to set it as high as possible in the Load Order, so it can be ready for other autoloaded scripts.

**Note: **You can adjust the desired class name either inside of plugin.gd or inside the autoloaded script list, if you prefer a different way to call the logger. _(Log.d() instead of LogDuck.d() for example)_<br><br>

### Compatibility

Currently LogDuck supports Godot 4.0.1+ with GDScript. I have yet to look into making sure it plays along nicely with C# scripts. If you'd like to tackle that, feel free to <a href="#contributing">contribute</a>!

<br>

## Using LogDuck

By default, LogDuck will output anything sent to LogDuck with d() w() and e() into the output / console, errors and warnings also into the Debugger if you are in the Editor. LogDuck, however, will **not** automatically catch any output sent to print(), printerr() or print_rich() calls. A careful Search and Replace of these functions with LogDuck.d, usually fixes this quickly.

If you need help with the setup, I will try my best to help out on the [Discord server](https://discord.gg/XSWkS2fWJc). If LogDuck is useful for you, please give me a shout on [Twitter](https://twitter.com/zee_weasel)!

<br>

## Planned Features

- Logging to files (Per Session / Continuing)
- Output of images into the output when in print_rich mode
- Being fully compatible with C# scripts
- Useful functions like printing system specs to console

See the [open issues](https://github.com/ZeeWeasel/LogDuck/issues) for a full list of proposed features and known issues.

<br>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. I especially am looking to make this more robust and able to simplify debugging overall with the least amount of setup.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement". Don't forget to give the project a star if you enjoy it! 

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<br>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.



<!-- CONTACT -->
## Contact

[Follow @zee_weasel on Twitter](https://twitter.com/zee_weasel)<br>
[Join Discord Server]((https://discord.gg/XSWkS2fWJc))
