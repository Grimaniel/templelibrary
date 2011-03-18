/**
 * @exampleText
 * 
 * <h1>Enumerator</h1>
 * 
 * <p>This is an example of the usages of an <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/data/Enumerator.html">Enumerator</a>.</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/enumerator/EnumeratorExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/enumerator/EnumeratorExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/enumerator/EnumeratorExample.as" target="_blank">Download source</a>.
 * This example also uses the class <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/enumerator/Gender.as" target="_blank">Gender</a> and <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/enumerator/Person.as" target="_blank">Person</a>.</p>
 */
package
{
	import temple.data.Enumerator;
	
	public class EnumeratorExample extends DocumentClassExample 
	{
		public function EnumeratorExample()
		{
			super("Temple - EnumeratorExample");
			
			// create a new instance of Person
			var person:Person = new Person();
			
			// the 'gender' property is an Enumerable value. Only the values inside the Gender class are allowed
			person.gender = Gender.FEMALE;
			
			// it is not possible to create an instance of Gender outside the class definition of Gender. This will cause a runtime error:
			try
			{
				person.gender = new Gender("some value");
			}
			catch (error:Error)
			{
				this.logError(error.message);
				// view this error at http://yalala.tyz.nl
			}
			
			// if you want to lookup a valid value of gender by the String value you can do the following:
			var gender:Gender = Enumerator.get(Gender, "male") as Gender;
			
			this.logInfo("gender = " + gender);
			// view this message at http://yalala.tyz.nl
		}

	}
}
