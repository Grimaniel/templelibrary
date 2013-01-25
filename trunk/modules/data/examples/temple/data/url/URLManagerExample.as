/**
 * @exampleText
 * 
 * <a name="URLManager"></a>
 * <h1>URLManager</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/doc/temple/data/url/URLManager.html" name="doc">URLManager</a>.
 * The URLManager is used to manage the URL's of a project in an XML file. With this XML file you can easily switch between different groups groups of URL's (for different environments).</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/url/URLManagerExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/url/URLManagerExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.data.url.URLEvent;
	import temple.data.url.URLManager;
	import temple.data.url.urlManagerInstance;
	import temple.data.xml.XMLServiceEvent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class URLManagerExample extends DocumentClassExample 
	{
		private var _urlManager:URLManager;
		
		public function URLManagerExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - URLManagerExample");
			
			// Create of new URLManager
			_urlManager = new URLManager();
			
			// Or you you use the "Singleton" urlManager
			//_urlManager = urlManagerInstance;
			
			// set debug mode to get debug log messages from the URLManager
			_urlManager.debug = true; 
			
			// add EventListeners
			_urlManager.addEventListenerOnce(XMLServiceEvent.COMPLETE, handleURLManagerComplete);
			_urlManager.addEventListener(URLEvent.OPEN, handleURLOpen);
			
			// load urls.xml
			_urlManager.load("urls.xml");
		}
		
		private function handleURLManagerComplete(event:XMLServiceEvent):void
		{
			// create a button, with listener
			var button:Sprite = createButton("Click here: Open URL!");
			button.addEventListener(MouseEvent.CLICK, handleButtonClick);
			addChild(button);
		}
		
		private function handleButtonClick(event:MouseEvent):void
		{
			// Open url
			_urlManager.openByName("website");
		}
		
		private function handleURLOpen(event:URLEvent):void
		{
			// Manual log URLManager information. See log message at: http://yalala.tyz.nl/
			logInfo("Open URL:" + event.url + "    Target window:" + event.targetFrame);
			
			tracker.trackEvent("URLManagerExample", "Open URL", event.name);
		}
		
		private function createButton(label:String):Sprite
		{
			var button:Sprite = new Sprite();
			button.graphics.beginFill(0xDEDEDA);
			button.graphics.lineStyle(1, 0x808080, 1, true);
			button.graphics.drawRoundRect(0, -4, 200, 28, 8);
			button.graphics.endFill();
			button.x = (stage.stageWidth - button.width) / 2;
			button.y = (stage.stageHeight - button.height) / 2;
			button.buttonMode = true;
			
			var buttonLabel:TextField = new TextField();
			buttonLabel.defaultTextFormat = new TextFormat("Arial", 12, 0x333333, true, null, null, null, null, "center");
			buttonLabel.width = 200;
			buttonLabel.height = 20;
			buttonLabel.selectable = buttonLabel.mouseEnabled = false;
			buttonLabel.text = label;
			button.addChild(buttonLabel);
			
			return button;
		}

	}
}
