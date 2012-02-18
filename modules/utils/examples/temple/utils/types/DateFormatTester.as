package  
{
	import temple.core.display.CoreMovieClip;
	import temple.ui.buttons.MultiStateButton;
	import temple.ui.form.components.ComboBox;
	import temple.ui.form.components.DateSelector;
	import temple.ui.scroll.ScrollComponent;
	import temple.utils.types.DateUtils;

	import flash.events.Event;
	import flash.text.TextField;

	public class DateFormatTester extends CoreMovieClip 
	{
		public var mcDateSelector:DateSelector;
		public var txtFormat:TextField;
		public var txtOutput:TextField;
		
		
		public function DateFormatTester()
		{
			this.mcDateSelector.date = new Date();
			this.mcDateSelector.addEventListener(Event.CHANGE, handleChange);
			this.txtFormat.addEventListener(Event.CHANGE, handleChange);
			
			this.mcDateSelector.end = new Date(2100, 0, 1);
			
			this.mcDateSelector.monthFormat = DateSelector.MONTH_FORMAT_SHORT_EN;
			
			MultiStateButton(ScrollComponent(ComboBox(this.mcDateSelector.day).list).scrollbar.button).outOnDragOut = false;
			MultiStateButton(ScrollComponent(ComboBox(this.mcDateSelector.month).list).scrollbar.button).outOnDragOut = false;
			MultiStateButton(ScrollComponent(ComboBox(this.mcDateSelector.year).list).scrollbar.button).outOnDragOut = false;
			
			this.setOutput();
		}
		
		public function set format(value:String):void
		{
			this.txtFormat.text = value;
			this.setOutput();
		}

		override public function destruct():void
		{
			super.destruct();
			
			if (this.mcDateSelector)
			{
				this.mcDateSelector.destruct();
				this.mcDateSelector = null;
			}
			if (this.txtFormat)
			{
				this.txtFormat.removeEventListener(Event.CHANGE, handleChange);
				this.txtFormat = null;
			}
			this.txtOutput = null;
		}

		private function handleChange(event:Event):void
		{
			this.setOutput();
		}

		private function setOutput():void
		{
			this.txtOutput.text = this.mcDateSelector.date ? DateUtils.format(this.txtFormat.text, this.mcDateSelector.date) : 'Error, no valid date';
		}
	}
}
