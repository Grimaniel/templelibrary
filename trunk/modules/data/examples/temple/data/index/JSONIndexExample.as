/**
 * @exampleText
 * 
 * <a name="JSON Indexer"></a>
 * <h1>JSON and Indexer</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/doc/temple/data/encoding/json/JSONCoder.html" name="doc">JSONCoder</a>
 * in combination with the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/data/index/Indexer.html" name="doc">Indexer</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/index/JSONIndexExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/index/JSONIndexExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.data.encoding.json.JSONCoder;

	import flash.net.registerClassAlias;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class JSONIndexExample extends DocumentClassExample
	{
		public function JSONIndexExample()
		{
			super("Temple - JSONIndexExample");
			
			// register class alias for Person so het typed JSON
			registerClassAlias("Person", Person);
			
			// Create some people			
			var erik:Person = new Person();
			erik.id = "1";
			erik.name = "Erik Ooten";

			// Out put Erik
			var erikOutput:TextField = new TextField();
			erikOutput.autoSize = TextFieldAutoSize.LEFT;
			addChild(erikOutput);
			erikOutput.width = 300;
			erikOutput.text = dump(erik);
			
			// convert to JSON string
			var json:String = JSONCoder.encode(erik, true);
			
			// out put JSON
			var jsonOutput:TextField = new TextField();
			jsonOutput.autoSize = TextFieldAutoSize.LEFT;
			addChild(jsonOutput);
			jsonOutput.width = 600;
			jsonOutput.y = erikOutput.y + erikOutput.height + 4;
			jsonOutput.text = json;
			
			// convert back to object
			var person:Person = JSONCoder.decode(json) as Person;
			
			var personOutput:TextField = new TextField();
			personOutput.autoSize = TextFieldAutoSize.LEFT;
			addChild(personOutput);
			personOutput.width = 600;
			personOutput.y = jsonOutput.y + jsonOutput.height + 4;
			personOutput.text =  dump(person);
			
			// check if person and erik are the same object
			if (erik === person)
			{
				logInfo("erik === person");
			}
			else
			{
				logError("erik != person");
			}
		}
	}
}
