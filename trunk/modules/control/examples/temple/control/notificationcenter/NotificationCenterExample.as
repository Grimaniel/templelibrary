/**
 * @exampleText
 * 
 * <a name="NotificationCenter"></a>
 * <h1>NotificationCenter</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/control/notificationcenter/NotificationCenter.html">NotificationCenter</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/control/examples/temple/control/notificationcenter/NotificationCenterExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/control/examples/temple/control/notificationcenter/NotificationCenterExample.as" target="_blank">View source</a></p>
 */
package
{
	import flash.events.KeyboardEvent;

	import temple.control.notificationcenter.Notification;
	import temple.core.debug.log.LogEvent;
	import temple.core.debug.log.Log;
	import temple.control.notificationcenter.NotificationCenter;

	import flash.text.TextField;

	public class NotificationCenterExample extends DocumentClassExample
	{
		private var _output:TextField;

		public function NotificationCenterExample()
		{
			super("Temple - NotificationCenterExample");

			_output = new TextField();
			_output.width = stage.stageWidth;
			_output.height = stage.stageHeight;
			addChild(_output);
			_output.text = "Press a key to send a Notification\n\n";

			Log.addLogListener(handleLogEvent);

			NotificationCenter.getInstance().debug = true;

			NotificationCenter.getInstance().addObserver("key-press", handleNotifications);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}

		private function handleLogEvent(event:LogEvent):void
		{
			_output.appendText(event.data + "\n");
		}

		private function handleNotifications(note:Notification):void
		{
			_output.appendText("Received Notification: '" + note.type + "', data = " + note.data + "\n");
		}

		private function handleKeyDown(event:KeyboardEvent):void
		{
			NotificationCenter.post("key-press", String.fromCharCode(event.charCode));
		}
	}
}
