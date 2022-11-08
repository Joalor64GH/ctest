/*
 * Apache License, Version 2.0
 *
 * Copyright (c) 2022 MemeHoovy, Joalor64 and Wither362
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package;

#if sys
import modding.ModIcon;
import modding.ModList;
import modding.PolymodHandler;
import flixel.group.FlxGroup;
import ChartingState;
import flixel.system.FlxSound;
import AnimationDebug;
import Controls;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import Alphabet;
import Song;
import Highscore;

class ModsMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var page:FlxTypedGroup<ModsMenuStateOption> = new FlxTypedGroup<ModsMenuStateOption>();

	public static var instance:ModsMenu;

	var descriptionText:FlxText;
	var descBg:FlxSprite;

	override function create()
	{
		instance = this;

		var menuBG:FlxSprite;
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		super.create();

		add(page);

		PolymodHandler.loadModMetadata();

		loadMods();

		descBg = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, 0xFF000000);
		descBg.alpha = 0.6;
		add(descBg);

		descriptionText = new FlxText(descBg.x, descBg.y + 4, FlxG.width, "Template Description", 18);
		descriptionText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER);
		descriptionText.borderColor = FlxColor.BLACK;
		descriptionText.borderSize = 1;
		descriptionText.borderStyle = OUTLINE;
		descriptionText.scrollFactor.set();
		descriptionText.screenCenter(X);
		add(descriptionText);

		var leText:String = "Press ENTER to enable / disable the currently selected mod.";

		var text:FlxText = new FlxText(0, FlxG.height - 22, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		text.borderColor = FlxColor.BLACK;
		text.borderSize = 1;
		text.borderStyle = OUTLINE;
		add(text);
	}

	function loadMods()
	{
		page.forEachExists(function(option:ModsMenuStateOption)
		{
			page.remove(option);
			option.kill();
			option.destroy();
		});

		var optionLoopNum:Int = 0;

		for(modId in PolymodHandler.metadataArrays)
		{
			var ModsMenuStateOption = new ModsMenuStateOption(ModList.modMetadatas.get(modId).title, modId, optionLoopNum);
			page.add(ModsMenuStateOption);
			optionLoopNum++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(-1 * Math.floor(FlxG.mouse.wheel) != 0)
		{
			curSelected -= 1 * Math.floor(FlxG.mouse.wheel);
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (controls.UP_P)
		{
			curSelected -= 1;
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (controls.DOWN_P)
		{
			curSelected += 1;
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (controls.BACK)
		{
			PolymodHandler.loadMods();
			FlxG.switchState(new MainMenuState());
		}

		if (curSelected < 0)
			curSelected = page.length - 1;

		if (curSelected >= page.length)
			curSelected = 0;

		var bruh = 0;

		for (x in page.members)
		{
			x.Alphabet_Text.targetY = bruh - curSelected;

			if(x.Alphabet_Text.targetY == 0)
			{
				descriptionText.screenCenter(X);

				@:privateAccess
				descriptionText.text = 
				ModList.modMetadatas.get(x.Option_Value).description 
				+ "\nAuthor: " + ModList.modMetadatas.get(x.Option_Value)._author 
				+ "\nLeather Engine Version: " + ModList.modMetadatas.get(x.Option_Value).apiVersion 
				+ "\nMod Version: " + ModList.modMetadatas.get(x.Option_Value).modVersion 
				+ "\n";
			}

			bruh++;
		}
	}
}
#end