package
{
	import temple.facebook.data.vo.FacebookUserFields;
	import temple.facebook.data.vo.FacebookUserData;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import temple.core.display.StageProvider;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.system.ApplicationDomain;
	import temple.reflection.Reflection;
	import temple.core.display.CoreMovieClip;
	import temple.utils.types.VectorUtils;
	import temple.facebook.data.vo.IFacebookUserData;
	import flash.utils.describeType;
	import temple.core.templelibrary;
	import temple.reflection.ReflectionUtils;
	import temple.reflection.reflect;
	/**
	 * @author Thijs Broerse
	 */
	public class ReflectionExample extends DocumentClassExample
	{
		public function ReflectionExample()
		{
			super("Temple - ReflectionExample");
			
			
//			var data:Data = new Data();
//
//			trace(reflect(data));
//			trace("-----");
			//trace(reflect(Data));
			
//			trace("1a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", "left", "test2"));
//			trace("1b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", "left", "test2"));
//			trace("2a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", "left", "test"));
//			trace("2b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", "left", "test"));
//			trace("3a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", "left"));
//			trace("3b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", "left"));
//			trace("4a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", "top", "test"));
//			trace("4b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", "top", "test"));
//			trace("5a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", "middle", "test"));
//			trace("5b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", "middle", "test"));
//			trace("6a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias2", "left"));
//			trace("6b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias2", "left"));
//			trace("7a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias"));
//			trace("7b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias"));
//			trace("8a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", null, "test"));
//			trace("8b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", null, "test"));
//			trace("9a. " + ReflectionUtils.findVariablesWithMetaData(data, "Key"));
//			trace("9b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Key"));
//			
//			trace("10. " + ReflectionUtils.getMetaDataOfVariable(data, "x"));
//			trace("11. " + ReflectionUtils.getMetaDataOfVariable(data, "x", "Alias"));
//			trace("12. " + ObjectUtils.traceObject(ReflectionUtils.argsToObject(ReflectionUtils.getMetaDataOfVariable(data, "x", "Alias")), 3, false));
//			trace("13. " + ObjectUtils.traceObject(ReflectionUtils.argsToObject(ReflectionUtils.getMetaDataOfVariable(data, "z", "Alias")), 3, false));
			
//			var type:Class = ReflectionUtils.getTypeOfVariable(data, "list");
//			
//			trace(type);
//			
//			trace(String(type).indexOf("[class Vector.<") == 0);
//			
//			trace(getQualifiedSuperclassName(ReflectionUtils.getTypeOfVariable(data, "isSet")) );
//
//			trace(dump(this, 1));
			
//			trace(ReflectionUtils.hasNamespacedProperty(data, templelibrary, "myVar"));
//
//			trace(ReflectionUtils.getAccessorAccess(data, "getterOnly"));
//			trace(ReflectionUtils.getAccessorAccess(data, "setterOnly"));
//			trace(ReflectionUtils.getAccessorAccess(data, "getterAndSetter"));
//			
//			trace(ReflectionUtils.isReadable(data, "getterOnly"));
//			trace(ReflectionUtils.isReadable(data, "setterOnly"));
//			trace(ReflectionUtils.isReadable(data, "getterAndSetter"));
//			
//			trace(ReflectionUtils.isWritable(data, "getterOnly"));
//			trace(ReflectionUtils.isWritable(data, "setterOnly"));
//			trace(ReflectionUtils.isWritable(data, "getterAndSetter"));
//
//			trace(VectorUtils.getBaseType(Vector.<IFacebookUserData> as Class));

			Reflection.debug = true;
			
			
			var o:*;
			
			trace(reflect(o));
			trace(reflect(NaN));
			trace(reflect(FacebookUserFields));
			
			return;
			
			reflect(new BaseData());
			reflect(BaseData);
			//trace(dump(Reflection.templelibrary::cache, 1));
			
			trace("-----");
			reflect(new CoreMovieClip());

			//trace(dump(Reflection.templelibrary::cache, 1));
			
		}
	}
}
import temple.core.templelibrary;
import temple.data.Trivalent;

class BaseData
{
	internal var baseVar:Boolean;
}

class Data extends BaseData
{
	[Alias(test="left")]
	public var x:Number;
	
	[Alias(test="top")]
	public var y:Number;

	[Alias("depth")]
	public var z:Number;
	
	[Key]
	[Alias("uid")]
	public var id:int;
	
	public var date:Date;

	public var list:Vector.<String>;

	public var isSet:Trivalent;
	
	templelibrary var myVar:String;
	
	private var _getterOnly:String;
	private var _setterOnly:String;
	private var _getterAndSetter:String;
		

	public function get getterOnly():String
	{
		return _getterOnly;
	}

	public function set setterOnly(setterOnly:String):void
	{
		_setterOnly = setterOnly;
	}

	public function get getterAndSetter():String
	{
		return _getterAndSetter;
	}

	public function set getterAndSetter(getterAndSetter:String):void
	{
		_getterAndSetter = getterAndSetter;
	}
}
