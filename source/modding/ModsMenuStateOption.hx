package modding;

#if MODS_ALLOWED
import modding.ModList;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup;

class ModsMenuStateOption extends FlxTypedGroup<FlxSprite>
{
	// variables //
	public var Alphabet_Text:Alphabet;
	public var Mod_Icon:ModIcon;

	public var Mod_Enabled:Bool = false;

	// options //
	public var Option_Row:Int = 0;

	public var Option_Name:String = "";
	public var Option_Value:String = "Template Mod";

	public function new(_Option_Name:String = "", _Option_Value:String = "Template Mod", _Option_Row:Int = 0)
	{
		super();

		// SETTING VALUES //
		this.Option_Name = _Option_Name;
		this.Option_Value = _Option_Value;
		this.Option_Row = _Option_Row;

		// CREATING OTHER OBJECTS //
		Alphabet_Text = new Alphabet(20, 20 + (Option_Row * 100), Option_Name, true);
		Alphabet_Text.isMenuItem = true;
		Alphabet_Text.targetY = Option_Row;
		add(Alphabet_Text);

		Mod_Icon = new ModIcon(Option_Value);
		Mod_Icon.sprTracker = Alphabet_Text;
		add(Mod_Icon);

		Mod_Enabled = ModList.modList.get(Option_Value);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && Alphabet_Text.targetY == 0)
		{
			Mod_Enabled = !Mod_Enabled;
			ModList.setModEnabled(Option_Value, Mod_Enabled);
		}

		if (Mod_Enabled)
		{
			Alphabet_Text.alpha = 1;
			Mod_Icon.alpha = 1;
		}
		else
		{
			Alphabet_Text.alpha = 0.6;
			Mod_Icon.alpha = 0.6;
		}
	}
}
#end