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
	import temple.codecomponents.buttons.CodeButton;
	import temple.codecomponents.buttons.CodeCloseButton;
	import temple.codecomponents.buttons.CodeCollapseButton;
	import temple.codecomponents.buttons.CodeExpandButton;
	import temple.codecomponents.labels.CodeLabel;
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
	import temple.ui.behaviors.show.IShowBehavior;
	import temple.ui.buttons.BaseButton;
	import temple.ui.focus.FocusManager;
	import temple.ui.layout.LayoutContainer;
	import temple.ui.layout.liquid.LiquidBehavior;
	import temple.ui.layout.liquid.LiquidContainer;
	import temple.ui.scroll.ScrollBehavior;
	import temple.ui.tooltip.ToolTip;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;



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
		private var _destructOnClose:Boolean = true;
		private var _showBehavior:IShowBehavior;

		public function CodeWindow(width:Number = 200, height:Number = 100, label:String = null, closable:Boolean = true, setInnerSize:Boolean = false)
		{
			if (setInnerSize) width += HORIZONTAL_MARGIN;
			if (setInnerSize) height += VERTICAL_MARGIN;
			
			super(width, height, ScaleMode.NO_SCALE, Align.TOP_LEFT, true);
			
			_content = addChild(new LiquidContainer(10, 10, ScaleMode.NO_SCALE, Align.TOP_LEFT, true)) as LiquidContainer;
			_content.background = true;
			_content.backgroundColor = CodeStyle.windowBackgroundColor;
			_content.backgroundAlpha = CodeStyle.windowBackgroundAlpha;
			_content.top = HEADER_SIZE;
			_content.left = BORDER_SIZE;
			_content.right = BORDER_SIZE;
			_content.bottom = BORDER_SIZE;
			
			_border = addChild(new CoreSprite()) as CoreSprite;
			_border.filters = CodeStyle.windowBorderFilters;
			
			_header = _border.addChild(new BaseButton()) as BaseButton;
			_header.graphics.beginFill(CodeStyle.windowBorderBackgroundColor);
			_header.graphics.drawRect(0, 0, 1, HEADER_SIZE);
			_header.graphics.endFill();
			_header.addEventListener(MouseEvent.DOUBLE_CLICK, handleClick);
			_header.doubleClickEnabled = true;
			new LiquidBehavior(_header, {left:0, top:0, right: 0}, this);
			
			/**
			 * Sides
			 */
			_topSide = _border.addChild(new BaseButton()) as BaseButton;
			_topSide.graphics.beginFill(CodeStyle.windowBorderBackgroundColor);
			_topSide.graphics.drawRect(0, 0, 1, BORDER_SIZE);
			_topSide.graphics.endFill();
			new LiquidBehavior(_topSide, {left:0, top:0, right: 0}, this);
			
			_leftSide = _border.addChild(new BaseButton()) as BaseButton;
			_leftSide.graphics.beginFill(CodeStyle.windowBorderBackgroundColor);
			_leftSide.graphics.drawRect(0, 0, BORDER_SIZE, 1);
			_leftSide.graphics.endFill();
			new LiquidBehavior(_leftSide, {left:0, top:HEADER_SIZE, bottom: 0}, this);

			_rightSide = _border.addChild(new BaseButton()) as BaseButton;
			_rightSide.graphics.beginFill(CodeStyle.windowBorderBackgroundColor);
			_rightSide.graphics.drawRect(0, 0, BORDER_SIZE, 1);
			_rightSide.graphics.endFill();
			new LiquidBehavior(_rightSide, {right:0, top:HEADER_SIZE, bottom: 0}, this);

			_bottomSide = _border.addChild(new BaseButton()) as BaseButton;
			_bottomSide.graphics.beginFill(CodeStyle.windowBorderBackgroundColor);
			_bottomSide.graphics.drawRect(0, 0, BORDER_SIZE, BORDER_SIZE);
			_bottomSide.graphics.endFill();
			new LiquidBehavior(_bottomSide, {left:0, right:0, bottom: 0}, this);

			_resizeButton = _border.addChild(new BaseButton()) as BaseButton;
			_resizeButton.graphics.beginFill(CodeStyle.windowBorderBackgroundColor, 1);
			const size:uint = 15;
			_resizeButton.graphics.moveTo(size, 0);
			_resizeButton.graphics.lineTo(size, size);
			_resizeButton.graphics.lineTo(0, size);
			_resizeButton.graphics.lineTo(size, 0);
			_resizeButton.graphics.endFill();
			new LiquidBehavior(_resizeButton, {right:0, bottom:0}, this);
			
			new ScaleBehavior(this, _topSide, new Point(0, height), false, false, true, false);
			new ScaleBehavior(this, _leftSide, new Point(width, 0), false, true, false, false);
			new ScaleBehavior(this, _rightSide, new Point(0, 0), false, true, false, false);
			new ScaleBehavior(this, _bottomSide, new Point(0, 0), false, false, true, false);
			new ScaleBehavior(this, _resizeButton, new Point(0, 0), true, true, true, false).addEventListener(ScaleBehaviorEvent.SCALING, handleScaling);
			
			_label = addChild(new CodeLabel(label)) as CodeLabel;
			_label.mouseEnabled = _label.mouseChildren = false;
			_label.addEventListener(Event.CHANGE, dispatchEvent);

			_dragBehavior = new DragBehavior(this, null, _header);
			_dragBehavior.addEventListener(DragBehaviorEvent.DRAG_START, handleDragStart);
			_moveBehavior = new MoveBehavior(this, null, _header);
			_moveBehavior.addEventListener(MoveBehaviorEvent.MOVE, handleMove);
			
			/**
			 * Buttons
			 */
			_buttonContainer = new LayoutContainer(NaN, NaN, Orientation.HORIZONTAL, Direction.DESCENDING, 3);
			_buttonContainer.top = 3;
			_buttonContainer.right = 4;
			_buttonContainer.ignoreInvisibleChildren = true;
			addChild(_buttonContainer);
			
			_closeButton = _buttonContainer.addChild(new CodeCloseButton()) as CodeButton;
			_closeButton.addEventListener(MouseEvent.CLICK, handleClick);

			_collapseButton = _buttonContainer.addChild(new CodeCollapseButton()) as CodeButton;
			_collapseButton.addEventListener(MouseEvent.CLICK, handleClick);

			_expandButton = _buttonContainer.addChild(new CodeExpandButton()) as CodeButton;
			_expandButton.addEventListener(MouseEvent.CLICK, handleClick);

			/**
			 * Scrolling
			 */
			_scrollBehavior = new ScrollBehavior(_content, _content.scrollRect);
			
			_verticalScrollBar = addChild(new CodeScrollBar(Orientation.VERTICAL, 160, true, _scrollBehavior)) as CodeScrollBar;
			_verticalScrollBar.top = HEADER_SIZE;
			_verticalScrollBar.right = BORDER_SIZE;
			_verticalScrollBar.bottom = BORDER_SIZE + _verticalScrollBar.width;

			_horizontalScrollBar = addChild(new CodeScrollBar(Orientation.HORIZONTAL, 160, true, _scrollBehavior)) as CodeScrollBar;
			_horizontalScrollBar.left = BORDER_SIZE;
			_horizontalScrollBar.right = BORDER_SIZE + _verticalScrollBar.width;
			_horizontalScrollBar.bottom = BORDER_SIZE;
			
			minimalWidth = 40;
			minimalHeight = 28;
			
			addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
			
			filters = CodeStyle.windowFilters;
			expand();
			
			/**
			 * ToolTip info
			 */
			if (ToolTip.clip)
			{
				ToolTip.add(_closeButton, "Close window");
				ToolTip.add(_expandButton, "Open window");
				ToolTip.add(_collapseButton, "Minimize window");
				ToolTip.add(_resizeButton, "Resize window");
			}
			
			this.closable = closable;
		}

		public function get text():String
		{
			return _label ? _label.text : null;
		}

		public function set text(value:String):void
		{
			_label.text = value;
		}

		public function get draggable():Boolean
		{
			return _dragBehavior.enabled;
		}

		public function set draggable(value:Boolean):void
		{
			_dragBehavior.enabled = value;
		}

		public function expand():void
		{
			expanded = true;
		}

		public function collapse():void
		{
			expanded = false;
		}

		public function get expanded():Boolean
		{
			return _content.visible;
		}

		public function set expanded(value:Boolean):void
		{
			_resizeButton.visible = 
			_content.visible = 
			_leftSide.visible = 
			_rightSide.visible = 
			_bottomSide.visible = 
			_collapseButton.visible = 
			value;
			_expandButton.visible = !value;
			_buttonContainer.layoutChildren();
			this.overflow = overflow; 
		}

		public function close():void
		{
			if (_destructOnClose)
			{
				destruct();
			}
			else
			{
				hide();
			}
		}
		
		public function get content():LiquidContainer
		{
			return _content;
		}
		
		public function add(child:DisplayObject, x:Number = 0, y:Number = 0):DisplayObject
		{
			_content.addChild(child);
			child.x = x;
			child.y = y;
			return child;
		}

		public function get scaleHorizontal():Boolean
		{
			return _rightSide.enabled;
		}

		public function set scaleHorizontal(value:Boolean):void
		{
			_leftSide.enabled = _rightSide.enabled = _resizeButton.enabled = _resizeButton.visible = value;
		}

		public function get scaleVertical():Boolean
		{
			return _bottomSide.enabled;
		}

		public function set scaleVertical(value:Boolean):void
		{
			_topSide.enabled = _bottomSide.enabled = _resizeButton.enabled = _resizeButton.visible = value;
		}

		public function get scalable():Boolean
		{
			return scaleHorizontal || scaleVertical;
		}

		public function set scalable(value:Boolean):void
		{
			scaleHorizontal = scaleVertical = value;
		}

		public function get closable():Boolean
		{
			return _closeButton.visible;
		}

		public function set closable(value:Boolean):void
		{
			_closeButton.visible = value;
		}
		
		public function get focus():Boolean
		{
			return _focus;
		}

		public function set focus(value:Boolean):void
		{
			if (value)
			{
				FocusManager.focus = _header;
			}
			else if (_focus)
			{
				FocusManager.focus = null;
			}
		}
		
		public function get overflow():String
		{
			if (!clipping)
			{
				return Overflow.VISIBLE;
			}
			else if (_verticalScrollBar.autoHide)
			{
				return Overflow.AUTO;
			}
			else if (_verticalScrollBar.visible)
			{
				return Overflow.SCROLL;
			}
			return Overflow.HIDDEN;
		}

		public function set overflow(value:String):void
		{
			if (expanded)
			{
				switch(value)
				{
					case Overflow.VISIBLE:
					{
						clipping = false;
						_verticalScrollBar.autoHide = false;
						_horizontalScrollBar.autoHide = false;
						_verticalScrollBar.visible = false;
						_horizontalScrollBar.visible = false;
						_scrollBehavior.disable();
						break;
					}
					case Overflow.HIDDEN:
					{
						clipping = true;
						_verticalScrollBar.autoHide = false;
						_horizontalScrollBar.autoHide = false;
						_verticalScrollBar.visible = false;
						_horizontalScrollBar.visible = false;
						_scrollBehavior.disable();
						break;
					}
					case Overflow.AUTO:
					{
						clipping = true;
						_verticalScrollBar.autoHide = true;
						_horizontalScrollBar.autoHide = true;
						_verticalScrollBar.visible = contentHeight > height;
						_horizontalScrollBar.visible = contentWidth > width;
						_scrollBehavior.enable();
						break;
					}
					case Overflow.SCROLL:
					{
						clipping = true;
						_verticalScrollBar.autoHide = false;
						_horizontalScrollBar.autoHide = false;
						_verticalScrollBar.visible = true;
						_horizontalScrollBar.visible = true;
						_scrollBehavior.enable();
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
				_verticalScrollBar.visible = false;
				_horizontalScrollBar.visible = false;
			}
		}
		
		public function get destructOnClose():Boolean
		{
			return _destructOnClose;
		}

		public function set destructOnClose(value:Boolean):void
		{
			_destructOnClose = value;
		}
		
		public function show(instant:Boolean = false, onComplete:Function = null):void
		{
			if (_showBehavior)
			{
				_showBehavior.show(instant, onComplete);
			}
			else
			{
				visible = true;
				if (onComplete != null) onComplete();
			}
		}

		public function hide(instant:Boolean = false, onComplete:Function = null):void
		{
			if (_showBehavior)
			{
				_showBehavior.hide(instant, onComplete);
			}
			else
			{
				visible = false;
				if (onComplete != null) onComplete();
			}
		}

		public function get shown():Boolean
		{
			return _showBehavior ? _showBehavior.shown : visible;
		}
		
		public function get showBehavior():IShowBehavior
		{
			return _showBehavior;
		}

		public function set showBehavior(value:IShowBehavior):void
		{
			_showBehavior = value;
		}
		
		private function handleClick(event:MouseEvent):void
		{
			switch (event.target)
			{
				case _closeButton:
					close();
					break;
				case _expandButton:
					expand();
					break;
				case _collapseButton:
					collapse();
					break;
				case _header:
					expanded = !expanded;
					break;
			}
		}
		
		private function handleFocusIn(event:FocusEvent):void
		{
			_focus = true;
			if (parent) parent.addChild(this);
		}

		private function handleFocusOut(event:FocusEvent):void
		{
			_focus = false;
		}
		
		private function handleDragStart(event:DragBehaviorEvent):void
		{
			liquidBehavior.enabled = false;
		}

		private function handleMove(event:MoveBehaviorEvent):void
		{
			liquidBehavior.enabled = false;
		}
		
		private function handleScaling(event:ScaleBehaviorEvent):void
		{
			if (ToolTip.clip) ToolTip.add(_resizeButton, "Resize window (" + width + ", " + height + ")");
		}
		
		override public function destruct():void
		{
			_label = null;
			_dragBehavior = null;
			_moveBehavior = null;
			_content = null;
			_border = null;
			_header = null;
			_topSide = null;
			_leftSide = null;
			_rightSide = null;
			_bottomSide = null;
			_resizeButton = null;
			_closeButton = null;
			_collapseButton = null;
			_expandButton = null;
			_buttonContainer = null;
			_scrollBehavior = null;
			_verticalScrollBar = null;
			_horizontalScrollBar = null;
			
			super.destruct();
		}
	}
}
