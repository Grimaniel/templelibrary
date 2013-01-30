/**
 * @exampleText
 * 
 * <a name="Enumerator"></a>
 * <h1>Enumerator</h1>
 * 
 * <p>This is an example of the usages of an <a href="http://templelibrary.googlecode.com/svn/trunk/modules/common/doc/temple/common/enum/Enumerator.html">Enumerator</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/common/examples/temple/common/enum/EnumeratorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/common/examples/temple/common/enum/EnumeratorExample.as" target="_blank">View source</a></p>
 * 
 * <p>This example also uses the class <a href="http://templelibrary.googlecode.com/svn/trunk/modules/common/examples/temple/common/enum/Gender.as" target="_blank">Gender</a>
 * and <a href="http://templelibrary.googlecode.com/svn/trunk/modules/common/examples/temple/common/enum/Person.as" target="_blank">Person</a>.</p>
 */
package
{
	import temple.core.debug.log.LogEvent;
	import temple.common.enum.Enumerator;
	import temple.core.debug.log.Log;

	import flash.text.TextField;
	
	public class EnumeratorExample extends DocumentClassExample 
	{
		private var _output:TextField;
		
		public function EnumeratorExample()
		{
			super("Temple - EnumeratorExample");
			
			// Create a TextField for displaying the output of the Log
			_output = new TextField();	
			_output.width = stage.stageWidth;
			_output.height = stage.stageHeight;
			addChild(_output);
			
			// Set a listener on the Log
			Log.addLogListener(handleLogEvent);
			
			// create a new instance of Person
			var person:Person = new Person();
			
			// the 'gender' property is an Enumerable value. Only the values inside the Gender class are allowed
			person.gender = Gender.FEMALE;
			
			logInfo("person.gender = " + person.gender);
			
			// it is not possible to create an instance of Gender outside the class definition of Gender. This will cause a runtime error:
			try
			{
				person.gender = new Gender("some value");
			}
			catch (error:Error)
			{
				logError(error.message);
			}
			
			// if you want to lookup a valid value of gender by the String value you can do the following:
			var gender:Gender = Enumerator.get(Gender, "male") as Gender;
			
			// view this message at http://yalala.tyz.nl
			logInfo("gender = " + gender);
		}

		private function handleLogEvent(event:LogEvent):void
		{
			_output.appendText(event.data + "\n\n");
		}

	}
}
