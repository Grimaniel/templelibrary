/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.codecomponents.windows
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import temple.codecomponents.buttons.CodeButton;
	import temple.codecomponents.buttons.CodeCloseButton;
	import temple.codecomponents.buttons.CodeCollapseButton;
	import temple.codecomponents.buttons.CodeExpandButton;
	import temple.codecomponents.label.CodeLabel;
	import temple.codecomponents.scroll.CodeScrollBar;
	import temple.codecomponents.style.CodeStyle;
	import temple.common.enum.Align;
	import temple.common.enum.Direction;
	import temple.common.enum.Orientation;
	import temple.common.enum.ScaleMode;
	import temple.core.display.CoreSprite;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.DragBehavior;
	import temple.ui.behaviors.DragBehaviorEvent;
	import temple.ui.behaviors.MoveBehavior;
	import temple.ui.behaviors.MoveBehaviorEvent;
	import temple.ui.behaviors.ScaleBehavior;
	import temple.ui.behaviors.ScaleBehaviorEvent;
	import temple.ui.buttons.BaseButton;
	import temple.ui.focus.FocusManager;
	import temple.ui.layout.LayoutContainer;
	import temple.ui.layout.liquid.LiquidBehavior;
	import temple.ui.layout.liquid.LiquidContainer;
	import temple.ui.scroll.ScrollBehavior;
	import temple.ui.tooltip.ToolTip;



	/**
	 * @author Thijs Broerse
	 */
	public class CodeWindow extends LiquidContainer implements IWindow
	{
		public static const HEADER_SIZE:Number = 20;
		public static const BORDER_SIZE:Number = 4;
		
		public static const HORIZONTAL_MARGIN:Number = 2 * BORDER_SIZE;
		public static const VERTICAL_MARGIN:Number = HEADER_SIZE + BORDER_SIZE;
		
		private var _label:CodeLabel;
		private var _dragBehavior:DragBehavior;
		private var _moveBehavior:MoveBehavior;
		private var _content:LiquidContainer;
		
		private var _border:CoreSprite;
		private var _header:BaseButton;
		
		private var _topSide:BaseButton;
		private var _leftSide:BaseButton;
		private var _rightSide:BaseButton;
		private var _bottomSide:BaseButton;
		private var _resizeButton:BaseButton;
		
		private var _closeButton:CodeButton;
		private var _collapseButton:CodeButton;
		private var _expandButton:CodeButton;
		private var _buttonContainer:LayoutContainer;
		private var _focus:Boolean;
		private var _scrollBehavior:ScrollBehavior;
		private var _verticalScrollBar:CodeScrollBar;
		private var _horizontalScrollBar:CodeScrollBar;

		public function CodeWindow(width:Number = 200, height:Number = 100, label:String = null, closable:Boolean = true, setInnerSize:Boolean = false)
		{
			if (setInnerSize) width += HORIZONTAL_MARGIN;
			if (setInnerSize) height += VERTICAL_MARGIN;
			
			super(width, height, ScaleMode.NO_SCALE, Align.TOP_LEFT, true);
			
			this._content = this.addChild(new LiquidContainer(10, 10, ScaleMode.NO_SCALE, Align.TOP_LEFT, true)) as LiquidContainer;
			this._content.background = true;
			this._content.backgroundColor = CodeStyle.windowBackgroundColor;
			this._content.backgroundAlpha = CodeStyle.windowBackgroundAlpha;
			this._content.top = HEADER_SIZE;
			this._content.left = BORDER_SIZE;
			this._content.right = BORDER_SIZE;
			this._content.bottom = BORDER_SIZE;
			
			this._border = this.addChild(new CoreSprite()) as CoreSprite;
			this._border.filters = CodeStyle.windowBorderFilters;
			
			this._header = this._border.addChild(new BaseButton()) as BaseButton;
			this._header.graphics.beginFill(CodeStyle.windowBorderBackgroundColor);
			this._header.graphics.drawRect(0, 0, 1, HEADER_SIZE);
			this._header.graphics.endFill();
			this._header.addEventListener(MouseEvent.DOUBLE_CLICK, this.handleClick);
			this._header.doubleClickEnabled = true;
			new LiquidBehavior(this._header, {left:0, top:0, right: 0}, this);
			
			/**
			 * Sides
			 */
			this._topSide = this._border.addChild(new BaseButton()) as BaseButton;
			this._topSide.graphics.beginFill(CodeStyle.windowBorderBackgroundColor);
			this._topSide.graphics.drawRect(0, 0, 1, BORDER_SIZE);
			this._topSide.graphics.endFill();
			new LiquidBehavior(this._topSide, {left:0, top:0, right: 0}, this);
			
			this._leftSide = this._border.addChild(new BaseButton()) as BaseButton;
			this._leftSide.graphics.beginFill(CodeStyle.windowBorderBackgroundColor);
			this._leftSide.graphics.drawRect(0, 0, BORDER_SIZE, 1);
			this._leftSide.graphics.endFill();
			new LiquidBehavior(this._leftSide, {left:0, top:HEADER_SIZE, bottom: 0}, this);

			this._rightSide = this._border.addChild(new BaseButton()) as BaseButton;
			this._rightSide.graphics.beginFill(CodeStyle.windowBorderBackgroundColor);
			this._rightSide.graphics.drawRect(0, 0, BORDER_SIZE, 1);
			this._rightSide.graphics.endFill();
			new LiquidBehavior(this._rightSide, {right:0, top:HEADER_SIZE, bottom: 0}, this);

			this._bottomSide = this._border.addChild(new BaseButton()) as BaseButton;
			this._bottomSide.graphics.beginFill(CodeStyle.windowBorderBackgroundColor);
			this._bottomSide.graphics.drawRect(0, 0, BORDER_SIZE, BORDER_SIZE);
			this._bottomSide.graphics.endFill();
			new LiquidBehavior(this._bottomSide, {left:0, right:0, bottom: 0}, this);

			this._resizeButton = this._border.addChild(new BaseButton()) as BaseButton;
			this._resizeButton.graphics.beginFill(CodeStyle.windowBorderBackgroundColor, 1);
			const size:uint = 15;
			this._resizeButton.graphics.moveTo(size, 0);
			this._resizeButton.graphics.lineTo(size, size);
			this._resizeButton.graphics.lineTo(0, size);
			this._resizeButton.graphics.lineTo(size, 0);
			this._resizeButton.graphics.endFill();
			new LiquidBehavior(this._resizeButton, {right:0, bottom:0}, this);
			
			new ScaleBehavior(this, this._topSide, new Point(0, this.height), false, false, true, false);
			new ScaleBehavior(this, this._leftSide, new Point(this.width, 0), false, true, false, false);
			new ScaleBehavior(this, this._rightSide, new Point(0, 0), false, true, false, false);
			new ScaleBehavior(this, this._bottomSide, new Point(0, 0), false, false, true, false);
			new ScaleBehavior(this, this._resizeButton, new Point(0, 0), true, true, true, false).addEventListener(ScaleBehaviorEvent.SCALING, this.handleScaling);
			
			this._label = this.addChild(new CodeLabel(label)) as CodeLabel;
			this._label.mouseEnabled = this._label.mouseChildren = false;
			this._label.addEventListener(Event.CHANGE, this.dispatchEvent);

			this._dragBehavior = new DragBehavior(this, null, this._header);
			this._dragBehavior.addEventListener(DragBehaviorEvent.DRAG_START, this.handleDragStart);
			this._moveBehavior = new MoveBehavior(this, null, this._header);
			this._moveBehavior.addEventListener(MoveBehaviorEvent.MOVE, this.handleMove);
			
			/**
			 * Buttons
			 */
			this._buttonContainer = new LayoutContainer(NaN, NaN, Orientation.HORIZONTAL, Direction.DESCENDING, 3);
			this._buttonContainer.top = 3;
			this._buttonContainer.right = 4;
			this._buttonContainer.ignoreInvisibleChildren = true;
			this.addChild(this._buttonContainer);
			
			this._closeButton = this._buttonContainer.addChild(new CodeCloseButton()) as CodeButton;
			this._closeButton.addEventListener(MouseEvent.CLICK, this.handleClick);

			this._collapseButton = this._buttonContainer.addChild(new CodeCollapseButton()) as CodeButton;
			this._collapseButton.addEventListener(MouseEvent.CLICK, this.handleClick);

			this._expandButton = this._buttonContainer.addChild(new CodeExpandButton()) as CodeButton;
			this._expandButton.addEventListener(MouseEvent.CLICK, this.handleClick);

			/**
			 * Scrolling
			 */
			this._scrollBehavior = new ScrollBehavior(this._content, this._content.scrollRect);
			
			this._verticalScrollBar = this.addChild(new CodeScrollBar(Orientation.VERTICAL, 160, true, this._scrollBehavior)) as CodeScrollBar;
			this._verticalScrollBar.top = HEADER_SIZE;
			this._verticalScrollBar.right = BORDER_SIZE;
			this._verticalScrollBar.bottom = BORDER_SIZE + this._verticalScrollBar.width;

			this._horizontalScrollBar = this.addChild(new CodeScrollBar(Orientation.HORIZONTAL, 160, true, this._scrollBehavior)) as CodeScrollBar;
			this._horizontalScrollBar.left = BORDER_SIZE;
			this._horizontalScrollBar.right = BORDER_SIZE + this._verticalScrollBar.width;
			this._horizontalScrollBar.bottom = BORDER_SIZE;
			
			this.minimalWidth = 40;
			this.minimalHeight = 28;
			
			this.addEventListener(FocusEvent.FOCUS_IN, this.handleFocusIn);
			this.addEventListener(FocusEvent.FOCUS_OUT, this.handleFocusOut);
			
			this.filters = CodeStyle.windowFilters;
			this.expand();
			
			/**
			 * ToolTip info
			 */
			if (ToolTip.clip)
			{
				ToolTip.add(this._closeButton, "Close window");
				ToolTip.add(this._expandButton, "Open window");
				ToolTip.add(this._collapseButton, "Minimize window");
				ToolTip.add(this._resizeButton, "Resize window");
			}
			
			this.closable = closable;
		}

		public function get label():String
		{
			return this._label ? this._label.label : null;
		}

		public function set label(value:String):void
		{
			this._label.label = value;
		}

		public function get draggable():Boolean
		{
			return this._dragBehavior.enabled;
		}

		public function set draggable(value:Boolean):void
		{
			this._dragBehavior.enabled = value;
		}

		public function expand():void
		{
			this.expanded = true;
		}

		public function collapse():void
		{
			this.expanded = false;
		}

		public function get expanded():Boolean
		{
			return this._content.visible;
		}

		public function set expanded(value:Boolean):void
		{
			this._resizeButton.visible = 
			this._content.visible = 
			this._leftSide.visible = 
			this._rightSide.visible = 
			this._bottomSide.visible = 
			this._collapseButton.visible = 
			value;
			this._expandButton.visible = !value;
			this._buttonContainer.layoutChildren();
			this.overflow = this.overflow; 
		}

		public function close():void
		{
			this.destruct();
		}
		
		public function get content():LiquidContainer
		{
			return this._content;
		}
		
		public function add(child:DisplayObject, x:Number = 0, y:Number = 0):DisplayObject
		{
			this._content.addChild(child);
			child.x = x;
			child.y = y;
			return child;
		}

		public function get scaleHorizontal():Boolean
		{
			return this._rightSide.enabled;
		}

		public function set scaleHorizontal(value:Boolean):void
		{
			this._leftSide.enabled = this._rightSide.enabled = this._resizeButton.enabled = this._resizeButton.visible = value;
		}

		public function get scaleVertical():Boolean
		{
			return this._bottomSide.enabled;
		}

		public function set scaleVertical(value:Boolean):void
		{
			this._topSide.enabled = this._bottomSide.enabled = this._resizeButton.enabled = this._resizeButton.visible = value;
		}

		public function get scalable():Boolean
		{
			return this.scaleHorizontal || this.scaleVertical;
		}

		public function set scalable(value:Boolean):void
		{
			this.scaleHorizontal = this.scaleVertical = value;
		}

		public function get closable():Boolean
		{
			return this._closeButton.visible;
		}

		public function set closable(value:Boolean):void
		{
			this._closeButton.visible = value;
		}
		
		public function get focus():Boolean
		{
			return this._focus;
		}

		public function set focus(value:Boolean):void
		{
			if (value)
			{
				FocusManager.focus = this._header;
			}
			else if (this._focus)
			{
				FocusManager.focus = null;
			}
		}
		
		public function get overflow():String
		{
			if (!this.clipping)
			{
				return Overflow.VISIBLE;
			}
			else if (this._verticalScrollBar.autoHide)
			{
				return Overflow.AUTO;
			}
			else if (this._verticalScrollBar.visible)
			{
				return Overflow.SCROLL;
			}
			return Overflow.HIDDEN;
		}

		public function set overflow(value:String):void
		{
			if (this.expanded)
			{
				switch(value)
				{
					case Overflow.VISIBLE:
					{
						this.clipping = false;
						this._verticalScrollBar.autoHide = false;
						this._horizontalScrollBar.autoHide = false;
						this._verticalScrollBar.visible = false;
						this._horizontalScrollBar.visible = false;
						this._scrollBehavior.disable();
						break;
					}
					case Overflow.HIDDEN:
					{
						this.clipping = true;
						this._verticalScrollBar.autoHide = false;
						this._horizontalScrollBar.autoHide = false;
						this._verticalScrollBar.visible = false;
						this._horizontalScrollBar.visible = false;
						this._scrollBehavior.disable();
						break;
					}
					case Overflow.AUTO:
					{
						this.clipping = true;
						this._verticalScrollBar.autoHide = true;
						this._horizontalScrollBar.autoHide = true;
						this._verticalScrollBar.visible = this.contentHeight > this.height;
						this._horizontalScrollBar.visible = this.contentWidth > this.width;
						this._scrollBehavior.enable();
						break;
					}
					case Overflow.SCROLL:
					{
						this.clipping = true;
						this._verticalScrollBar.autoHide = false;
						this._horizontalScrollBar.autoHide = false;
						this._verticalScrollBar.visible = true;
						this._horizontalScrollBar.visible = true;
						this._scrollBehavior.enable();
						break;
					}
					default:
					{
						throwError(new TempleArgumentError(this, "Invalid value for overflow: '" + value + "'"));
						break;
					}
				}
			}
			else
			{
				this._verticalScrollBar.visible = false;
				this._horizontalScrollBar.visible = false;
			}
		}
		
		private function handleClick(event:MouseEvent):void
		{
			switch (event.target)
			{
				case this._closeButton:
					this.close();
					break;
				case this._expandButton:
					this.expand();
					break;
				case this._collapseButton:
					this.collapse();
					break;
				case this._header:
					this.expanded = !this.expanded;
					break;
			}
		}
		
		private function handleFocusIn(event:FocusEvent):void
		{
			this._focus = true;
			if (this.parent) this.parent.addChild(this);
		}

		private function handleFocusOut(event:FocusEvent):void
		{
			this._focus = false;
		}
		
		private function handleDragStart(event:DragBehaviorEvent):void
		{
			this.liquidBehavior.enabled = false;
		}

		private function handleMove(event:MoveBehaviorEvent):void
		{
			this.liquidBehavior.enabled = false;
		}
		
		private function handleScaling(event:ScaleBehaviorEvent):void
		{
			if (ToolTip.clip) ToolTip.add(this._resizeButton, "Resize window (" + this.width + ", " + this.height + ")");
		}
		
		override public function destruct():void
		{
			this._label = null;
			this._dragBehavior = null;
			this._moveBehavior = null;
			this._content = null;
			this._border = null;
			this._header = null;
			this._topSide = null;
			this._leftSide = null;
			this._rightSide = null;
			this._bottomSide = null;
			this._resizeButton = null;
			this._closeButton = null;
			this._collapseButton = null;
			this._expandButton = null;
			this._buttonContainer = null;
			this._scrollBehavior = null;
			this._verticalScrollBar = null;
			this._horizontalScrollBar = null;
			
			super.destruct();
		}
	}
}
