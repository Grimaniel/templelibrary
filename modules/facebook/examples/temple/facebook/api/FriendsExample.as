/**
 * @exampleText
 * 
 * <a name="Friends"></a>
 * <h1>Friends</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/doc/temple/facebook/api/IFacebookFriendAPI.html">IFacebookFriendAPI.</a></p>
 * 
 * <p>This example uses the Temple's <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/readme.html">CodeComponents</a> for the UI elements.
 * This examples loads friends from Facebook and displays their names in a list.</p>
 * 
 * <p>This example will only run from the HTML file in a browser. Since we are not using a channel.html, this example might not work in all browsers.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/examples/temple/facebook/api/FriendsExample.html" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/examples/temple/facebook/api/FriendsExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.utils.types.VectorUtils;
	import temple.facebook.data.vo.IFacebookUserData;
	import temple.codecomponents.form.components.CodeInputField;
	import temple.facebook.data.vo.IFacebookResult;
	import temple.codecomponents.buttons.CodeLabelButton;
	import temple.facebook.adapters.FacebookAdapter;
	import temple.facebook.api.FacebookAPI;

	import flash.events.MouseEvent;

	public class FriendsExample extends DocumentClassExample
	{
		private var _facebook:FacebookAPI;
		private var _button:CodeLabelButton;
		private var _output:CodeInputField;
		
		public function FriendsExample()
		{
			super("Temple - Facebook - FriendsExample");
			
			_facebook = new FacebookAPI(new FacebookAdapter(loaderInfo.url.indexOf("https:") == 0));
			_facebook.init(loaderInfo.parameters.appId);
			
			// Create a button (using CodeComponents)
			_button = new CodeLabelButton("Click here to load friends");
			_button.horizontalCenter = 0;
			_button.verticalCenter = 0;
			addChild(_button);
			_button.addEventListener(MouseEvent.CLICK, handleClick);
			
			// Create an output field for displaying the result
			_output = new CodeInputField(stage.stageWidth, stage.stageHeight, true);
			addChildAt(_output, 0);
			_output.editable = false;
		}

		private function handleClick(event:MouseEvent):void
		{
			_button.enabled = false;
			
			// load friends
			_facebook.friends.getFriends(this.onFriends);
		}

		private function onFriends(result:IFacebookResult):void
		{
			_button.visible = false;
			_output.visible = true;
			
			if (result.success)
			{
				// get friends from data
				var friends:Vector.<IFacebookUserData> = Vector.<IFacebookUserData>(result.data);
				
				// sort by name
				VectorUtils.sortOn(friends, "name");
				
				// show in output
				for (var i:int = 0, leni:int = friends.length; i < leni; i++)
				{
					_output.appendText(" - " + friends[i].name + "\n");
				}
			}
			else
			{
				_output.text = result.message;
			}
		}
	}
}
