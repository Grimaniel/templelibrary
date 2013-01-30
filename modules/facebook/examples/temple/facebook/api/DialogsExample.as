/**
 * @exampleText
 * 
 * <a name="Dialogs"></a>
 * <h1>Dialogs</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/doc/temple/facebook/api/IFacebookDialogAPI.html">FacebookDialogAPI.</a></p>
 * 
 * <p>This example uses the Temple's <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/readme.html">CodeComponents</a> for the UI elements.
 * This examples loads friends from Facebook and displays their names in a list.</p>
 * 
 * <p>This example will only run from the HTML file in a browser. Since we are not using a channel.html, this example might not work in all browsers.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/facebook/api/DialogsExample.html" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/examples/temple/facebook/api/DialogsExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodeLabelButton;
	import temple.codecomponents.form.components.CodeComboBox;
	import temple.facebook.adapters.FacebookAdapter;
	import temple.facebook.api.FacebookAPI;
	import temple.facebook.data.enum.FacebookDisplayMode;
	import temple.ui.layout.VBox;
	import temple.utils.Enum;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class DialogsExample extends DocumentClassExample
	{
		private var _facebook:FacebookAPI;
		private var _displayModeComboBox : CodeComboBox;
		private var _feedDialogButton:CodeLabelButton;
		private var _friendsDialogButton:CodeLabelButton;
		private var _requestDialogButton:CodeLabelButton;
		private var _oauthDialogButton:CodeLabelButton;

		public function DialogsExample()
		{
			super("Temple - Facebook - DialogsExample");
			
			_facebook = new FacebookAPI(new FacebookAdapter(loaderInfo.url.indexOf("https:") == 0));
			_facebook.init(loaderInfo.parameters.appId);
			
			var box:VBox = new VBox(10);
			
			addChild(box);
			box.x = box.y = 20;
			
			_displayModeComboBox = new CodeComboBox(160, 18, Enum.getArray(FacebookDisplayMode));
			_displayModeComboBox.hintText = "Display mode";
			box.addChild(_displayModeComboBox);
			_displayModeComboBox.addEventListener(Event.CHANGE, handleDisplayModeChange);
			
			// Create buttons (using CodeComponents)
			_feedDialogButton = new CodeLabelButton("Feed Dialog");
			box.addChild(_feedDialogButton);
			_feedDialogButton.addEventListener(MouseEvent.CLICK, handleClick);
			
			_friendsDialogButton = new CodeLabelButton("Friends Dialog");
			box.addChild(_friendsDialogButton);
			_friendsDialogButton.addEventListener(MouseEvent.CLICK, handleClick);
			
			_requestDialogButton = new CodeLabelButton("Request Dialog");
			box.addChild(_requestDialogButton);
			_requestDialogButton.addEventListener(MouseEvent.CLICK, handleClick);
			
			_oauthDialogButton = new CodeLabelButton("Oauth Dialog");
			box.addChild(_oauthDialogButton);
			_oauthDialogButton.addEventListener(MouseEvent.CLICK, handleClick);
		}

		private function handleDisplayModeChange(event:Event):void
		{
			_facebook.dialogs.displayMode = _displayModeComboBox.value;
		}

		private function handleClick(event:MouseEvent):void
		{
			switch (event.target)
			{
				case _feedDialogButton:
					_facebook.dialogs.feedDialog();
					break;
					
				case _friendsDialogButton:
					_facebook.dialogs.friendsDialog("100004032744210");
					break;
					
				case _requestDialogButton:
					_facebook.dialogs.requestDialog("Check this out!");
					break;
					
				case _oauthDialogButton:
					_facebook.dialogs.oauthDialog("http://code.google.com/p/templelibrary");
					break;
			}
		}

	}
}
