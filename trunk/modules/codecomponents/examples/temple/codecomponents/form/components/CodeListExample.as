/**
 * @exampleText
 * 
 * <a name="CodeList"></a>
 * <h1>CodeList</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeList.html">CodeList</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeListExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeListExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.codecomponents.form.components.CodeList;
	import temple.codecomponents.label.CodeLabel;
	import temple.utils.ValueBinder;

	public class CodeListExample extends DocumentClassExample 
	{
		public function CodeListExample()
		{
			super("Temple - CodeListExample");
			
			var list:CodeList;
			
			list = new CodeList();
			this.addChild(list);
			list.x = 20;
			list.y = 20;
			list.addItems(["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"]);

			list = new CodeList(100);
			this.addChild(list);
			list.x = 200;
			list.y = 20;
			list.addItems(["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"]);
			
			// easy way to handle the selected value is by using a ValueBinder
			var output:CodeLabel = new CodeLabel();
			output.x = 200;
			output.y = 220;
			this.addChild(output);
			
			// When the list is changed, the value will be set in the "label" property of output
			new ValueBinder(list, output, "label");
			
			// Create a 'liquid' List by setting some liquid properties. Resize the SWF to see the list resize.
			list = new CodeList();
			this.addChild(list);
			list.x = 20;
			list.top = 220;
			list.bottom = 20;
			list.addItems(["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"]);
			list.addItems(["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"]);
		}

	}
}
