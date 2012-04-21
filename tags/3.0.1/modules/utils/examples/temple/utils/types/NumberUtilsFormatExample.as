/**
 * @exampleText
 * 
 * <a name="NumberUtilsFormat"></a>
 * <h1>NumberUtils.format()</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/doc/temple/utils/types/NumberUtils.html#format()">NumberUtils.format()</a> method.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/types/NumberUtilsFormatExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/types/NumberUtilsFormatExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.utils.types.NumberUtils;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class NumberUtilsFormatExample extends DocumentClassExample
	{
		public function NumberUtilsFormatExample()
		{
			super("Temple - NumberUtilsExample");
			
			var numbers:Vector.<Number> = Vector.<Number>([
				342345,
				-1000,
				-100,
				-10,
				-1,
				0,
				Math.PI,
				2/3,
				1,
				25.23523,
				1.34535e10,
				1.34e-4,
				0x004553,
				1e10,
				1/9,
				25,
				Math.random(),
				Math.random() * Math.random(),
				1 / Math.random(),
				Math.random() * 1e6
			]);
			
			var output:TextField;
			var outputs:Vector.<TextField> = new Vector.<TextField>(4, true); 
			for (i = 0, leni = outputs.length; i < leni; i++)
			{
				output = new TextField();
				outputs[i] = output;
				
				addChild(output);
				output.width = int(stage.stageWidth / leni);
				output.x = output.width * i;
				output.autoSize = TextFieldAutoSize.LEFT;
					
				switch(i)
				{
					case 0:
						output.text = "number\n";
						break;
					case 1:
						output.text = "format: , . 2\n";
						break;
					case 2:
						output.text = "format: . , 0 6\n";
						break;
					case 3:
						output.text = "format: , . NaN\n";
						break;
				}
			}
			
			var number:Number;
			for (var i:int = 0, leni:int = numbers.length; i < leni; i++)
			{
				number = numbers[i];
				outputs[0].appendText(number + "\n");
				outputs[1].appendText(NumberUtils.format(number,",",".", 2) + "\n");
				outputs[2].appendText(NumberUtils.format(number,".",",", 0, 6) + "\n");
				outputs[3].appendText(NumberUtils.format(number,",",".", NaN) + "\n");
			}
		}
	}
}
