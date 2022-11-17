package utilities;

import haxe.Json;
import openfl.Assets;
import flixel.util.FlxSave;
import game.Conductor;

typedef DefaultOptions =
{
    var options:Array<DefaultOption>;
}

typedef DefaultOption = 
{
    var option:String; // option name
    var value:Dynamic; // self explanatory

    var save:Null<String>; // the save (KEY NAME) to use, by default is 'main'
}

class Options
{
    public static var bindNamePrefix:String = "chocolateengine";
    public static var bindPath:String = "joalor64gh";

    public static var saves:Map<String, FlxSave> = [];

    public static function init()
    {
        createSave("modlist", "modlist");

        for(option in defaultOptions.options)
        {
            var saveKey = option.save != null ? option.save : "main";
            var dataKey = option.option;

            if(Reflect.getProperty(Reflect.getProperty(saves.get(saveKey), "data"), dataKey) == null)
                setData(option.value, option.option, saveKey);
        }

        if(getData("modlist", "modlist") == null)
            setData(new Map<String, Bool>(), "modlist", "modlist");
    }

    public static function createSave(key:String, bindNameSuffix:String)
    {
        var save = new FlxSave();
        save.bind(bindNamePrefix + bindNameSuffix, bindPath);

        saves.set(key, save);
    }

    public static function getData(dataKey:String, ?saveKey:String = "main"):Dynamic
    {
        if(saves.exists(saveKey))
            return Reflect.getProperty(Reflect.getProperty(saves.get(saveKey), "data"), dataKey);

        return null;
    }

    public static function setData(value:Dynamic, dataKey:String, ?saveKey:String = "main")
    {
        if(saves.exists(saveKey))
        {
            Reflect.setProperty(Reflect.getProperty(saves.get(saveKey), "data"), dataKey, value);

            saves.get(saveKey).flush();
        }
    }
}