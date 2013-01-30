package
{
	import temple.reflection.ReflectionUtils;
	import temple.reflection.description.DescriptionUtils;
	import temple.reflection.description.Descriptor;
	import temple.reflection.description.IDescription;
	import temple.utils.types.ObjectUtils;
	/**
	 * @author Thijs Broerse
	 */
	public class ReflectionExample extends DocumentClassExample
	{
		public function ReflectionExample()
		{
			super("Temple - ReflectionExample");
			
			
			var data:Data = new Data();
//
//			trace(reflect(data));
//			trace("-----");
//			trace(reflect(Data));
//			
			var description:IDescription = Descriptor.get(data);
			trace(dump(description, 6));
			
			
			trace("1a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", "left", "test2"));
			trace("1b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", "left", "test2"));
			trace("1c. " + DescriptionUtils.findVariablesWithMetadata(description, "Alias", "left", "test2"));
			trace("--------");
			trace("2a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", "left", "test"));
			trace("2b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", "left", "test"));
			trace("2c. " +  DescriptionUtils.findVariablesWithMetadata(description, "Alias", "left", "test"));
			trace("--------");
			trace("3a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", "left"));
			trace("3b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", "left"));
			trace("3c. " +  DescriptionUtils.findVariablesWithMetadata(description, "Alias", "left"));
			trace("--------");
			trace("4a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", "top", "test"));
			trace("4b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", "top", "test"));
			trace("4c. " +  DescriptionUtils.findVariablesWithMetadata(description, "Alias", "top", "test"));
			trace("--------");
			trace("5a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", "middle", "test"));
			trace("5b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", "middle", "test"));
			trace("5c. " +  DescriptionUtils.findVariablesWithMetadata(description, "Alias", "middle", "test"));
			trace("--------");
			trace("6a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias2", "left"));
			trace("6b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias2", "left"));
			trace("6c. " +  DescriptionUtils.findVariablesWithMetadata(description, "Alias2", "left"));
			trace("--------");
			trace("7a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias"));
			trace("7b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias"));
			trace("7c. " + DescriptionUtils.findVariablesWithMetadata(description, "Alias"));
			trace("--------");
			trace("8a. " + ReflectionUtils.findVariablesWithMetaData(data, "Alias", null, "test"));
			trace("8b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Alias", null, "test"));
			trace("8c. " + DescriptionUtils.findVariablesWithMetadata(description, "Alias", null, "test"));
			trace("--------");
			trace("9a. " + ReflectionUtils.findVariablesWithMetaData(data, "Key"));
			trace("9b. " + ReflectionUtils.findVariablesWithMetaData(Data, "Key"));
			trace("9c. " + DescriptionUtils.findVariablesWithMetadata(description, "Key"));
			trace("--------");
			trace("10. " + ReflectionUtils.getMetaDataOfVariable(data, "x"));
			trace("11. " + ReflectionUtils.getMetaDataOfVariable(data, "x", "Alias"));
			trace("12. " + dump(ReflectionUtils.argsToObject(ReflectionUtils.getMetaDataOfVariable(data, "x", "Alias")), 3, false));
			trace("13. " + dump(ReflectionUtils.argsToObject(ReflectionUtils.getMetaDataOfVariable(data, "z", "Alias")), 3, false));
			
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

//			Reflection.debug = true;
//			
//			
//			var o:*;
//			
//			trace(reflect(o));
//			trace(reflect(NaN));
//			trace(reflect(FacebookUserFields));
//			
//			return;
//			
//			reflect(new BaseData());
//			reflect(BaseData);
//			//trace(dump(Reflection.templelibrary::cache, 1));
//			
//			trace("-----");
//			reflect(new CoreMovieClip());

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
	[Alias(test="left",test2="left2")]
	public var x:Number;
	
	[Alias(test="top")]
	public var y:Number;

	[Alias("depth","depth2")]
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
