package temple.ui.buttons 
{
	import temple.CodeComponents;
	import temple.ui.style.CodeStyle;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeButton extends MultiStateButton 
	{
		public function CodeButton(width:Number = 14, height:Number = 14, x:Number = 0, y:Number = 0)
		{
			CodeComponents.checkVersion();
			
			this.graphics.beginFill(CodeStyle.buttonColor, CodeStyle.buttonAlpha);
			this.graphics.drawRoundRect(0, 0, width, height, CodeStyle.buttonRounding);
			this.graphics.endFill();
			this.filters = CodeStyle.buttonFilters;
			this.x = x;
			this.y = y;
			
			this.addChild(new ButtonFocusState(width, height));
			this.addChild(new ButtonOverState(width, height));
			this.addChild(new ButtonDownState(width, height));
		}
	}
}
import temple.ui.states.down.DownFadeState;
import temple.ui.states.focus.FocusFadeState;
import temple.ui.states.over.OverFadeState;
import temple.ui.style.CodeStyle;

class ButtonOverState extends OverFadeState
{
	public function ButtonOverState(width:Number, height:Number) 
	{
		super(.1);
		
		this.graphics.beginFill(CodeStyle.buttonOverstateColor, CodeStyle.buttonOverstateAlpha);
		this.graphics.drawRoundRect(0, 0, width, height, CodeStyle.buttonRounding);
		this.graphics.endFill();
	}
}

class ButtonDownState extends DownFadeState
{
	public function ButtonDownState(width:Number, height:Number) 
	{
		super(.1);
		
		this.graphics.beginFill(CodeStyle.buttonDownstateColor, CodeStyle.buttonDownstateAlpha);
		this.graphics.drawRoundRect(0, 0, width, height, CodeStyle.buttonRounding);
		this.graphics.endFill();
	}
}

class ButtonFocusState extends FocusFadeState
{
	public function ButtonFocusState(width:Number, height:Number) 
	{
		super(.2, .2);
		
		this.graphics.beginFill(0xFF0000, 1);
		this.graphics.drawRoundRect(-1, -1, width + 2, height + 2, CodeStyle.buttonRounding);
		this.graphics.endFill();
		
		this.filters = CodeStyle.focusFilters;
	}
}