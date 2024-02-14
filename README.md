
<div align="center">

![BlackSheep](/images/logo.png)


<sup>a World of Warcraft blacklisting addon</sup> 
</div>



<h4 align="center">A simple WoW add-on for blacklisting people you don't want to play with.</h4>

<p align="center">
<a href="https://saythanks.io/to/gokaybalci">
<img src="https://img.shields.io/badge/SayThanks.io-%E2%98%BC-1EAEDB.svg">
<a href="https://www.buymeacoffee.com/gokay" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="20" width="100"></a>
</p>

<p align="center">
  <a href="#key-features">Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#download">Download</a> •
  <a href="#license">License</a>
</p>


## Key Features

* Blacklist people for leaving, scamming or any reason whatsoever.
* Your list works on across all your characters.

## How to Use

![Baine](/images/Baine.png)

- Write /bs in-game chat
- Write the name of the player and blacklisting reason
- Enjoy!

## How to Integrate a Custom List
- Enter into the Addon directory *(.../World of Warcraft/_retail_/Interface/AddOns/BlackSheep/)*
- Open **CustomList.lua** file
- Manually enter the name of the player and a reason. It should look like this:

```
CustomList = {
    ["custom_retail_DATA"] = {
        {
			"NameofthePlayer", -- [1]
			"ReasonforBlacklisting", -- [2]
		}, -- [1]
    }
} 
```
- You can enter as many names as you like:

```
CustomList = {
    ["custom_retail_DATA"] = {
        {
			"NameofthePlayer", -- [1]
			"ReasonforBlacklisting", -- [2]
		}, -- [1]
		{
			"NameofthePlayer2", -- [1]
			"ReasonforBlacklisting2", -- [2]
		}, -- [2]    
    }
} 
```

## Todo
- [X] Character-wide blacklist
- [X] Custom player list integration
- [　] Right-click context menu
- [　] Warning screen when they are in your group


## Download
- Or go to [Releases](https://github.com/gokaybalci/BlackSheep/releases) and download.


## License

GPL-3.0 license
