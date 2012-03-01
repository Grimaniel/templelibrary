/**
 * @exampleText
 * 
 * <a name="XMLManager"></a>
 * <h1>XMLManager</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/doc/temple/data/xml/XMLManager.html" name="doc">XMLManager</a>.
 * The XMLManager is used for easily loading and parsing XML files to typed objects.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/xml/XMLManagerExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/xml/XMLManagerExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.data.url.URLManager;
	import temple.data.xml.XMLManager;

	import flash.text.TextField;
	import flash.text.TextFormat;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class XMLManagerExample extends DocumentClassExample 
	{
		public function XMLManagerExample()
		{
			// The super class connects to Yalog, so we can see the output of the log in Yalala: http://yalala.tyz.nl/
			super("Temple - XMLManagerExample");
			
			// load urls.xml. XMLManager waits till the urls.xml are loaded, so we don't need to add listeners
			URLManager.loadURLs("urls.xml");
			
			// set debug mode to get debug log messages from the XMLManager
			XMLManager.getInstance().debug = true;
			
			// load XML named "people" (see urls.xml) and parse it to PersonData objects.
			XMLManager.loadListByName("people", Person, "person", this.onData);
		}

		private function onData(list:Array):void
		{
			// This method is called after loading and parsing is complete, with the list of all PersonData objects.
			log("XML loaded and parsed: ", list, 3, false);
			
			// Show xml content in a TextField.
			var label:TextField = new TextField();
			label.defaultTextFormat = new TextFormat("Arial", 11, 0x333333);
			label.height = this.stage.stageHeight;
			label.width = this.stage.stageWidth;
			label.text = list.join('\n'); // Note the toStringProps inside PersonData are used to output friendly
			this.addChild(label);
		}
	}
}


import temple.core.CoreObject;
import temple.common.interfaces.IXMLParsable;

class Person extends CoreObject implements IXMLParsable 
{
	private var _id:uint;
	private var _name:String;
	private var _age:uint;
	private var _gender:String;

	public function Person()
	{
		// Add the properties you want to be returned in the 'toString()' method
		this.toStringProps.push('id', 'name', 'age', 'gender');
	}
	
	public function parseXML(xml:XML):Boolean
	{
		// map XML values to properties
		this._id = xml.@id;
		this._name = xml['name'];
		this._age = xml['age'];
		this._gender = xml['gender'];
		
		// check if id and name are filled
		return this._id && this._name != null;
	}
	
	public function get id():uint
	{
		return this._id;
	}
	
	public function get name():String
	{
		return this._name;
	}
	
	public function get age():uint
	{
		return this._age;
	}
	
	public function get gender():String
	{
		return this._gender;
	}
}
