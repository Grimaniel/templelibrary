/**
 * @exampleText
 * 
 * <a name="JSON"></a>
 * <h1>JSON</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/doc/temple/data/encoding/json/JSONDecoder.html">JSONDecoder</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/encoding/json/JSONExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/encoding/json/JSONExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.data.encoding.json.JSONDecoder;
	import temple.data.encoding.json.JSONEncoder;
	import temple.utils.types.ObjectUtils;

	import flash.net.registerClassAlias;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class JSONExample extends DocumentClassExample
	{
		public function JSONExample()
		{
			super("Temple - JSONExample");
			
			// register class alias for Person so het typed JSON
			registerClassAlias("Person", Person);
			
			// Create some people
			var erik:Person = new Person();
			erik.name = "Erik Ooten";
			erik.birthdate = new Date(1980, 5, 2);
			erik.gender = Gender.MALE;

			var jessie:Person = new Person();
			jessie.name = "Jessie Paskett";
			jessie.gender = Gender.FEMALE;
			
			var julio:Person = new Person();
			julio.name = "Julio Poche";
			julio.gender = Gender.MALE;
			
			erik.friends = Vector.<Person>([jessie,julio]);
			
			// Output Erik
			var erikOutput:TextField = new TextField();
			erikOutput.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(erikOutput);
			erikOutput.width = 300;
			erikOutput.text = ObjectUtils.traceObject(erik, 2, false);
			
			// convert to JSON string
			var encoder:JSONEncoder = new JSONEncoder(null, true);
			encoder.setExplicitEncoder(Date, new DateCoder());
			var json:String = encoder.stringify(erik);
			
			// output JSON
			var jsonOutput:TextField = new TextField();
			jsonOutput.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(jsonOutput);
			jsonOutput.width = 600;
			jsonOutput.y = erikOutput.y + erikOutput.height + 4;
			jsonOutput.text = json;
			
			// convert back to object
			var decoder:JSONDecoder = new JSONDecoder();
			decoder.setExplicitDecoder(Date, new DateCoder());
			
			var person:Person = decoder.destringify(json) as Person;
			
			var personOutput:TextField = new TextField();
			personOutput.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(personOutput);
			personOutput.width = 600;
			personOutput.y = jsonOutput.y + jsonOutput.height + 4;
			personOutput.text =  ObjectUtils.traceObject(person, 2, false);
		}
	}
}
import temple.data.encoding.IDestringifier;
import temple.data.encoding.IStringifier;

class DateCoder implements IStringifier, IDestringifier
{
	public function stringify(value:*):String
	{
		var date:Date = value as Date;
		
		return "\"" + date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + "\"";
	}

	public function destringify(value:String):*
	{
		if (value && value.indexOf("-"))
		{
			var a:Array = value.split("-");
			return new Date(a[0], (a[1]-1),a[2]);
		}
		return null;
	}
	
}
