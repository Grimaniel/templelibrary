package temple.ui.scroll 
{
	import temple.CodeComponents;
	import temple.ui.buttons.CodeButton;
	import temple.ui.form.components.CodeBackground;
	import temple.ui.layout.Direction;
	import temple.ui.layout.Orientation;

	import flash.display.InteractiveObject;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeScrollBar extends ScrollBar 
	{
		CodeComponents;
		
		public function CodeScrollBar(orientation:String = Orientation.VERTICAL, autoHide:Boolean = true, scrollPane:IScrollPane = null)
		{
			this.orientation = orientation;
			
			switch (this.orientation)
			{
				case Orientation.HORIZONTAL:
				{
					this.width = 160;
					break;
				}
				case Orientation.VERTICAL:
				{
					this.height = 160;
					break;
				}
			}
			
			this.autoHide = autoHide;
			
			this.createUI();
			
			this.scrollPane = scrollPane;
		}

		private function createUI():void 
		{
			this.track = this.addChild(new CodeBackground()) as InteractiveObject;
			if (this.orientation == Orientation.VERTICAL)
			{
				this.button = this.addChild(new CodeButton()) as InteractiveObject;
				this.upButton = this.addChild(new CodeScrollButton(Orientation.VERTICAL, Direction.DESCENDING)) as InteractiveObject;
				this.downButton = this.addChild(new CodeScrollButton(Orientation.VERTICAL, Direction.ASCENDING)) as InteractiveObject;
			}
			else
			{
				this.button = this.addChild(new CodeButton()) as InteractiveObject;
				this.leftButton = this.addChild(new CodeScrollButton(Orientation.HORIZONTAL, Direction.DESCENDING)) as InteractiveObject;
				this.rightButton = this.addChild(new CodeScrollButton(Orientation.HORIZONTAL, Direction.ASCENDING)) as InteractiveObject;
			}
			CodeButton(this.button).outOnDragOut = false;
			this.autoSizeButton = true;
			this.minimalButtonSize = 20;
		}
	}
}