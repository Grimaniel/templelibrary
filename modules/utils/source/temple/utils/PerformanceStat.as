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

package temple.utils
{
	import temple.core.display.CoreSprite;

	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * Basic performance meter (FPS + memory history).
	 * 
	 * @example
	 * <p>Self-contained, set .redraw to enable graph redraw (dont forget to addChild() somewhere).</p>
	 * <listing version="3.0">
	 * var stat:PerformanceStat = new PerformanceStat();
	 * stage.addChild(stat);
	 * </listing> 
	 *		
	 *	<p>also:</p>
	 *	
	 *	<listing version="3.0">	
	 *	stat.redraw = true/false; // set to false when not showing
	 *	stat.resetGraph(); // clear history after excessive load
	 *	</listing>
	 *	
	 *	@includeExample ../ui/animation/FrameStableMovieClipExample.as
	 *
	 * 	@author Bart van der Schoor, Geert Fokke
	 */
	public class PerformanceStat extends CoreSprite
	{
		// The memorygraph is aligned along the avarage memory in the history.
		// Here you can define how much Kb difference the graph shows.
		private static const _GRAPH_MEMORY_HEIGHT:int = 25000;
		private static const _EXTENDED_GRAPH_MEMORY_HEIGHT:int = 40000;

		private static const _UPDATE_FREQUENCY_MILLISECONDS:int = 250;

		private var _fpsField:TextField;
		private var _memoryField:TextField;

		private var _frameMilliMin:Number = 0;
		private var _frameMilliMax:Number = 0;
		private var _frameMilliTotal:Number = 0;

		private var _memoryKiloByteMin:Number = 0;
		private var _memoryKiloByteMax:Number = 0;
		private var _memoryKiloByteTotal:Number = 0;

		private var _avarageKiloByteMemory:Number = 0;

		private var _currentHistoryData:Vector.<Number>;
		private var _memoryKiloByteHistory:Vector.<Number>;
		private var _memoryKiloByteExtendedHistory:Vector.<Number>;
		private var _frameMilliSecondsHistory:Vector.<Number>;
		private var _frameMilliSecondsExtendedHistory:Vector.<Number>;

		private var _graph:Shape;
		private var _graphics:Graphics;
		private var _graphRect:Rectangle;
		private var _drawGraphLineCommands:Vector.<int>;
		private var _drawingFillCommands:Vector.<int>;
		private var _drawingLineCoordinates:Vector.<Number>;
		private var _drawingFillCoordinates:Vector.<Number>;

		// set the intial value high, so the initial state is added
		// to the extended history at the first enter frame event
		private var _updateTicks:int = 999;
		private var _frameTicks:int = 0;
		private var _lastUpdateTime:int;
		private var _maxHistoryItems:int;
		private var _fieldHeight:Number = 16;
		private var _mouseDownPosition:Point;
		private var _showExtendedHistory:Boolean;
		private var _drawGraph:Boolean = true;

		// reusables
		private var _i:int;
		private var _dx:Number;
		private var _dy:Number;
		private var _tmpY:Number;

		/**
		 * Creates a new PerformanceStat
		 * 
		 * @param visible Sets the intial visibility of the PerformanceStat, this can later be toggled by pressing Shift + ESC. 
		 * @param x Sets the x location of the PerformanceStat.
		 * @param y Sets the y location of the PerformanceStat.
		 */
		public function PerformanceStat(visible:Boolean = true, x:int = 2, y:int = 2, draggable:Boolean = true, hideable:Boolean = true)
		{
			this.visible = visible;
			this.x = x; 
			this.y = y;
			buttonMode = useHandCursor = true;

			// create and set fields
			_fpsField = new TextField();
			_memoryField = new TextField();
			_memoryField.text = _fpsField.text = "";

			addChild(_fpsField);
			addChild(_memoryField);

			_fpsField.x = _memoryField.x = _fpsField.y = 3;
			_memoryField.y = _fpsField.y + _fieldHeight;
			_memoryField.mouseEnabled = _fpsField.mouseEnabled = false;

			_graphRect = new Rectangle(3, _memoryField.y + _fieldHeight + 3, 135, 40);

			setFieldFormat(_fpsField, _graphRect.width, _fieldHeight, 0xae6800);
			setFieldFormat(_memoryField, _graphRect.width, _fieldHeight, 0x0068b0);

			_graph = new Shape();
			_graphics = _graph.graphics;
			addChild(_graph);

			// draw background
			graphics.lineStyle(1, 0x808080, .5, true);
			graphics.beginFill(0xFFFFFF, .45);
			graphics.drawRoundRect(0, 0, _graphRect.width + 6, _graphRect.bottom + 3, 4);

			graphics.lineStyle(0, 0x808080, .4, true);
			graphics.beginFill(0xFFFFFF, .8);
			graphics.drawRoundRect(_fpsField.x, _fpsField.y, _fpsField.width, _fpsField.height + _memoryField.height, 2);

			graphics.drawRect(_graphRect.x, _graphRect.y, _graphRect.width, _graphRect.height);
			graphics.endFill();

			// draw a line for the target framerate
			graphics.lineStyle(0, 0x808080, .4, true, LineScaleMode.NORMAL);
			graphics.moveTo(_graphRect.left, _graphRect.y + _graphRect.height / 2);
			graphics.lineTo(_graphRect.right, _graphRect.y + _graphRect.height / 2);


			var currentMemoryUse:Number = System.totalMemory / 1024;

			_frameMilliSecondsHistory = Vector.<Number>([1000]);
			_frameMilliSecondsExtendedHistory = Vector.<Number>([1000]);
			_memoryKiloByteHistory = Vector.<Number>([currentMemoryUse]);
			_memoryKiloByteExtendedHistory = Vector.<Number>([currentMemoryUse]);

			// already add 3 extra lineTo commands to make a full shape
			_drawingFillCommands = Vector.<int>([1, 2, 2, 2]);
			_drawGraphLineCommands = Vector.<int>([1]);
			_drawingLineCoordinates = new Vector.<Number>();
			_drawingFillCoordinates = new Vector.<Number>();


			_maxHistoryItems = _graphRect.width / 2;

			// Prefill the Command and History collections so we don't need to worry
			// about the length being too short and the need of adding new drawing commands.
			for (_i = 0; _i < _maxHistoryItems - 1; _i++)
			{
				_drawGraphLineCommands.push(2);
				_drawingFillCommands.push(2);

				_frameMilliSecondsHistory.push(1000);
				_memoryKiloByteHistory.push(currentMemoryUse);

				_frameMilliSecondsExtendedHistory.push(1000);
				_memoryKiloByteExtendedHistory.push(currentMemoryUse);
			}

			_lastUpdateTime = getTimer();

			if (hideable && stage) stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDownEvents);

			if (draggable) addEventListener(MouseEvent.MOUSE_DOWN, handleMouseEvents, false, -1000);
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, -1000);
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, -1000);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage, false, -1000);
		}

		private function handleMouseEvents(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					addEventListener(MouseEvent.MOUSE_UP, handleMouseEvents, false, -1000);

					startDrag();
					_mouseDownPosition = position;
					break;
				case MouseEvent.MOUSE_UP:
					removeEventListener(MouseEvent.MOUSE_UP, handleMouseEvents);

					stopDrag();
					// toggle the short history view / extended history view on click
					if (_mouseDownPosition.x == x && _mouseDownPosition.y == y) _showExtendedHistory = !_showExtendedHistory;
					break;
			}
		}
		
		/**
		 * 	Handles key down events.
		 * 	Shift + ESC: toggles visibility.
		 */
		private function handleKeyDownEvents(event:KeyboardEvent):void
		{
			// 27 == Keyboard.ESCAPE
			if (event.shiftKey && event.keyCode == 27) visible = !visible;
		}

		private function handleAddedToStage(event:Event):void
		{
			drawGraph = true;
		}

		private function handleRemovedFromStage(event:Event):void
		{
			drawGraph = false;
		}

		/**
		 * 	Keep track of the number of frames and memory usage
		 * 	Update the GUI if needed.
		 */ 
		private function handleEnterFrame(event:Event):void
		{
			_memoryKiloByteTotal += (System.totalMemory / 1024);
			_frameTicks++;
			
			var time:int = getTimer();

			if (time > _lastUpdateTime + _UPDATE_FREQUENCY_MILLISECONDS)
			{
				// UPDATE HISTORY INFORMATION

				_updateTicks++;

				// update fps & memory
				_frameMilliSecondsHistory.unshift((time - _lastUpdateTime) / _frameTicks);
				_memoryKiloByteHistory.unshift(_memoryKiloByteTotal / _frameTicks);

				_lastUpdateTime = time;

				if (_frameMilliSecondsHistory.length > _maxHistoryItems) _frameMilliSecondsHistory.length = _memoryKiloByteHistory.length = _maxHistoryItems;

				// check if it is time to save the current state for the extended graph
				if (_updateTicks >= 10)
				{
					_frameMilliSecondsExtendedHistory.unshift(_frameMilliSecondsHistory[0]);
					_memoryKiloByteExtendedHistory.unshift(_memoryKiloByteHistory[0]);

					if (_frameMilliSecondsExtendedHistory.length > _maxHistoryItems) _frameMilliSecondsExtendedHistory.length = _memoryKiloByteExtendedHistory.length = _maxHistoryItems;

					_updateTicks = 0;
				}

				// calculate min/max
				_frameMilliMin = _frameMilliMax = _frameMilliSecondsHistory[0];
				_memoryKiloByteMin = _memoryKiloByteMax = _memoryKiloByteHistory[0];

				// Since both the framerate history and the memory history have
				// the same length we can calculate the min and max in the same loop
				for (_i = 0;_i < _maxHistoryItems; _i++)
				{
					_frameMilliMin = _frameMilliSecondsHistory[_i] < _frameMilliMin ? _frameMilliSecondsHistory[_i] : _frameMilliMin;
					_frameMilliMax = _frameMilliSecondsHistory[_i] > _frameMilliMax ? _frameMilliSecondsHistory[_i] : _frameMilliMax;

					_memoryKiloByteMin = _memoryKiloByteHistory[_i] < _memoryKiloByteMin ? _memoryKiloByteHistory[_i] : _memoryKiloByteMin;
					_memoryKiloByteMax = _memoryKiloByteHistory[_i] > _memoryKiloByteMax ? _memoryKiloByteHistory[_i] : _memoryKiloByteMax;

					_avarageKiloByteMemory += _showExtendedHistory ? _memoryKiloByteExtendedHistory[_i] : _memoryKiloByteHistory[_i];
				}

				_avarageKiloByteMemory = _avarageKiloByteMemory / _maxHistoryItems;

				// reset these
				_memoryKiloByteTotal = 0;
				_frameTicks = 0;

				// UPDATE GUI

				// update the current info
				_fpsField.text = "FPS: " + (1000 / _frameMilliSecondsHistory[0]).toFixed(2) + "  (" + (1000 / _frameMilliMax).toFixed(1) + "/" + (1000 / _frameMilliMin).toFixed(1) + ")";
				_memoryField.text = "MB:  " + (_memoryKiloByteHistory[0] / 1024).toFixed(2) + "  (" + (_memoryKiloByteMin / 1024).toFixed(1) + "/" + (_memoryKiloByteMax / 1024).toFixed(1) + ")";

				if (_drawGraph)
				{
					// prepare the graph
					_graphics.clear();

					_dx = _graphRect.width / (_maxHistoryItems - 1);

					// Memory Usage Graph

					_dy = _graphRect.height / (_showExtendedHistory ? _EXTENDED_GRAPH_MEMORY_HEIGHT : _GRAPH_MEMORY_HEIGHT);

					// set the current history data according to the viewing mode
					_currentHistoryData = _showExtendedHistory ? _memoryKiloByteExtendedHistory : _memoryKiloByteHistory;

					_tmpY = _graphRect.bottom - _graphRect.height / 2 - (_dy * (_currentHistoryData[0] - _avarageKiloByteMemory));

					if (_tmpY > _graphRect.bottom)
					{
						_tmpY = _graphRect.bottom;
					}
					else if (_tmpY < _graphRect.top)
					{
						_tmpY = _graphRect.top;
					}

					_drawingLineCoordinates.length = _drawingFillCoordinates.length = 0;
					_drawingLineCoordinates.push(_graphRect.right, _tmpY);
					_drawingFillCoordinates.push(_graphRect.right, _tmpY);

					// calculate the current Memory history drawing coordinates
					for (_i = 1;_i < _maxHistoryItems;_i++)
					{
						_tmpY = _graphRect.bottom - _graphRect.height / 2 - (_dy * (_currentHistoryData[_i] - _avarageKiloByteMemory));

						if (_tmpY > _graphRect.bottom)
						{
							_tmpY = _graphRect.bottom;
						}
						else if (_tmpY < _graphRect.top)
						{
							_tmpY = _graphRect.top;
						}

						_drawingLineCoordinates.push(_graphRect.right - _dx * _i, _tmpY);
						_drawingFillCoordinates.push(_graphRect.right - _dx * _i, _tmpY);
					}

					// complete the fill shape coordinates
					_tmpY = _graphRect.bottom - _graphRect.height / 2 - (_dy * (_currentHistoryData[0] - _avarageKiloByteMemory));
					_drawingFillCoordinates.push(_graphRect.left, _graphRect.bottom, _graphRect.right, _graphRect.bottom, _graphRect.right, _tmpY);

					_graphics.lineStyle();
					_graphics.beginFill(_showExtendedHistory ? 0x5a9ac6 : 0x0090f5, .2);
					_graphics.drawPath(_drawingFillCommands, _drawingFillCoordinates);
					_graphics.endFill();

					_graphics.lineStyle(1, _showExtendedHistory ? 0x5a9ac6 : 0x0090f5, 1, false, LineScaleMode.NORMAL);
					_graphics.drawPath(_drawGraphLineCommands, _drawingLineCoordinates);


					// FPS Stats Graph

					// set the current history data according to the viewing mode
					_currentHistoryData = _showExtendedHistory ? _frameMilliSecondsExtendedHistory : _frameMilliSecondsHistory;

					// Calculate the FPS history line coordinates
					_dy = _graphRect.height / (stage.frameRate * 2);
					_tmpY = _graphRect.bottom - (_dy * (1000 / _currentHistoryData[0]));

					if (_tmpY > _graphRect.bottom)
					{
						_tmpY = _graphRect.bottom;
					}
					else if (_tmpY < _graphRect.top)
					{
						_tmpY = _graphRect.top;
					}

					_drawingLineCoordinates.length = 0;
					_drawingLineCoordinates.push(_graphRect.right, _tmpY);

					for (_i = 1;_i < _maxHistoryItems;_i++)
					{
						_tmpY = _graphRect.bottom - (_dy * (1000 / _currentHistoryData[_i]));

						if (_tmpY > _graphRect.bottom)
						{
							_tmpY = _graphRect.bottom;
						}
						else if (_tmpY < _graphRect.top)
						{
							_tmpY = _graphRect.top;
						}

						_drawingLineCoordinates.push(_graphRect.right - _i * _dx, _tmpY);
					}

					// draw current fps history
					_graphics.lineStyle(0, _showExtendedHistory ? 0xbe8839 : 0xF59200, 1, false, LineScaleMode.NORMAL);
					_graphics.drawPath(_drawGraphLineCommands, _drawingLineCoordinates);
				}
			}
		}

		/**
		 * clear the graph history, or maybe chop last X items
		 */
		public function resetGraph(chop:int = -1):void
		{
			if (chop <= 0) chop = _maxHistoryItems;

			var chopLength:int = _maxHistoryItems - chop;
			var currentMemory:Number = System.totalMemory / 1024;

			if (chopLength < 0) chopLength = 0;

			for (_i = chopLength; _i < _maxHistoryItems; _i++)
			{
				_frameMilliSecondsHistory[_i] = 1000;
				_frameMilliSecondsExtendedHistory[_i] = 1000;
				_memoryKiloByteHistory[_i] = currentMemory;
				_memoryKiloByteExtendedHistory[_i] = currentMemory;
			}
		}

		/**
		 * 	lazy setter
		 */ 
		private function setFieldFormat(field:TextField, width:Number = 50, height:Number = 20, color:Number = 0x000000):void
		{
			field.textColor = 0x000000;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.selectable = false;
			field.width = width;
			field.height = height;
			field.defaultTextFormat = new TextFormat("Lucida Sans", 9, color);
		}
		
		/**
		 * 	Indicates if the graph should be drawn.
		 */
		public function set drawGraph(value:Boolean):void
		{
			_drawGraph = value;
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = drawGraph = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (stage) stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDownEvents);

			if (_drawGraphLineCommands)
			{
				_drawGraphLineCommands.length = 0;
				_drawGraphLineCommands = null;
			}
			if (_drawingFillCommands)
			{
				_drawingFillCommands.length = 0;
				_drawingFillCommands = null;
			}
			if (_drawingLineCoordinates)
			{
				_drawingLineCoordinates.length = 0;
				_drawingLineCoordinates = null;
			}
			if (_drawingFillCoordinates)
			{
				_drawingFillCoordinates.length = 0;
				_drawingFillCoordinates = null;
			}
			if (_currentHistoryData)
			{
				_currentHistoryData.length = 0;
				_currentHistoryData = null;
			}
			if (_frameMilliSecondsHistory)
			{
				_frameMilliSecondsHistory.length = 0;
				_frameMilliSecondsHistory = null;
			}
			if (_memoryKiloByteHistory)
			{
				_memoryKiloByteHistory.length = 0;
				_memoryKiloByteHistory = null;
			}
			if (_frameMilliSecondsExtendedHistory)
			{
				_frameMilliSecondsExtendedHistory.length = 0;
				_frameMilliSecondsExtendedHistory = null;
			}
			if (_memoryKiloByteExtendedHistory)
			{
				_memoryKiloByteExtendedHistory.length = 0;
				_memoryKiloByteExtendedHistory = null;
			}

			_graph = null;
			_mouseDownPosition = null;
			_fpsField = null;
			_graphRect = null;
			_memoryField = null;
			_graphics = null;

			_dx = NaN;
			_dy = NaN;
			_tmpY = NaN;
			_fieldHeight = NaN;
			_memoryKiloByteTotal = NaN;
			_memoryKiloByteMin = NaN;
			_frameMilliMax = NaN;
			_memoryKiloByteMax = NaN;
			_maxHistoryItems = NaN;
			_frameMilliTotal = NaN;
			_frameMilliMin = NaN;
			_avarageKiloByteMemory = NaN;

			super.destruct();
		}
	}
}

