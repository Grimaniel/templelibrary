package  
{
	import flash.display.MovieClip;
	import temple.ui.form.components.ListRow;

	/**
	 * @author Thijs Broerse
	 */
	public class CustomListRow extends ListRow 
	{
		public var mcBackground:MovieClip;
		
		public function CustomListRow()
		{
			super();
			
			mcBackground.stop();
		}

		override public function set index(value:uint):void 
		{
			super.index = value;
			
			mcBackground.gotoAndStop(1 + value % mcBackground.totalFrames);
		}
	}
}
