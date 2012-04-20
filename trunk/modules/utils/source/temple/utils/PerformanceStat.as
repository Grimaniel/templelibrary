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

	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.System;
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
	 * this.stage.addChild(stat);
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
	 * 	@author Bart van der Schoor
	 */
	public class PerformanceStat extends CoreSprite
	{
		private var _fpsField:TextField;		
		private var _memoryField:TextField;		
		private var _frameMilliTotal:Number = 0;
		private var _memoryKiloByteTotal:Number = 0;
		private var _frameMilliMin:Number = 0;
		private var _memoryKiloByteMin:Number = 0;
		private var _frameMilliMax:Number = 0;
		private var _memoryKiloByteMax:Number = 0;
		private var _frameMilliHistory:Array;
		private var _memoryKiloByteHistory:Array;
		//utils
		private var _updateFrequency:Number = 1000 / 4;
		private var _nextUpdateTime:Number = 0;
		private var _previousTime:Number = 0;
		private var _ticks:Number = 0;
		private var _maxHistoryItems:Number = 50;
		private var _graphRect:Rectangle;
		private var _fieldHeight:Number = 16;
		private var _redraw:Boolean = true;
		private var _graph:Boolean;

		public function PerformanceStat(graph:Boolean = true) 
		{
			this._graph = graph;
			
			this.x = this.y = 2;
			
			//create and set fields
			this._fpsField = new TextField();
			this._memoryField = new TextField();
			
			this._fpsField.text = ' ';
			this._memoryField.text = ' ';
			
			this.addChild(this._fpsField);
			this.addChild(this._memoryField);
			
			this._memoryField.y = this._fpsField.y + this._fieldHeight + 2;
			this._graphRect = new Rectangle(0, this._memoryField.y + this._fieldHeight + 2, 120, 20);
			
			this.setFieldFormat(this._fpsField, this._graphRect.width, this._fieldHeight, 0xBB0000);
			this.setFieldFormat(this._memoryField, this._graphRect.width, this._fieldHeight, 0x0000BB);
			
			//init/set some datas
			this._frameMilliHistory = new Array();
			this._memoryKiloByteHistory = new Array();
			
			this._previousTime = getTimer();
			
			this._maxHistoryItems = this._graphRect.width / 4;
			
			this.calculate();
			
			this.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame, false, -1000);
			this.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage, false, -1000);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false, -1000);
		}

		private function handleAddedToStage(event:Event):void
		{
			this.redraw = true;
		}

		private function handleRemovedFromStage(event:Event):void
		{
			this.redraw = false;
		}

		private function handleEnterFrame(event:Event):void
		{
			this.calculate();
		}

		private function calculate():void
		{
			//add stats to history
			var delta:Number = (getTimer() - this._previousTime);			
			this._previousTime += delta;
			this._ticks++;
			
			this._frameMilliTotal += delta;
			this._memoryKiloByteTotal += (System.totalMemory / 1024);
			
			//check if it's update time again
			if (this._previousTime > this._nextUpdateTime )
			{
				//reusables
				var i:int;
				var iLim:int;
				var dx:Number;
				var dy:Number;
				var tmpY:Number;
				var avgTmp:Number;
				
				//calc new update time
				this._nextUpdateTime = this._previousTime + this._updateFrequency;
				
				if (this._redraw && this._graph)
				{			
					//prepare the graph
					this.graphics.clear();
					this.graphics.lineStyle(1, 0x000000, 1);
					this.graphics.beginFill(0xFFFFFF, 1);
					this.graphics.drawRect(this._graphRect.x, this._graphRect.y, this._graphRect.width, this._graphRect.height);
					this.graphics.endFill();
				}
				
				//update fps
				avgTmp = this._frameMilliTotal / this._ticks;
								
				this._fpsField.text = 'FPS: ' + String(Math.round(1000 / avgTmp * 100) / 100);
				this._frameMilliHistory.push(avgTmp);	
							
				if (this._frameMilliHistory.length > this._maxHistoryItems)
				{
					this._frameMilliHistory.splice(0, this._frameMilliHistory.length - this._maxHistoryItems);
				}
				
				//calc min/max							
				this._frameMilliMin = this._frameMilliHistory[0];
				this._frameMilliMax = this._frameMilliHistory[0];			
				iLim = this._frameMilliHistory.length;
				for (i = 1;i < iLim;i++)
				{
					this._frameMilliMin = Math.min(this._frameMilliHistory[i], this._frameMilliMin); 
					this._frameMilliMax = Math.max(this._frameMilliHistory[i], this._frameMilliMax);
				}
				
				if (this._redraw)
				{
					//add text
					this._fpsField.appendText(' [ ' + String(Math.round(1000 / this._frameMilliMax * 100) / 100) + ' / ' + String(Math.round(1000 / this._frameMilliMin * 100) / 100) + ' ]');
					
					if (this._graph)
					{
						//calc some more & draw				
						this.graphics.lineStyle(0, 0xCC3300, 1, false, LineScaleMode.NORMAL);
						dx = this._graphRect.width / iLim;
						dy = this._graphRect.height / (this._frameMilliMax - this._frameMilliMin);
						for (i = 0;i < iLim;i++)
						{
							tmpY = this._graphRect.bottom - dy * (this._frameMilliHistory[i] - this._frameMilliMin);
							this.graphics.moveTo(this._graphRect.left + dx * i, tmpY);
							this.graphics.lineTo(this._graphRect.left + dx * (i + 1), tmpY);
						}
					}
				}
				
				//update memory
				avgTmp = this._memoryKiloByteTotal / this._ticks;
				
				this._memoryField.text = 'MB: ' + String(Math.round(avgTmp / 1024 * 100) / 100);				
				this._memoryKiloByteHistory.push(avgTmp);
				
				if (this._memoryKiloByteHistory.length > this._maxHistoryItems)
				{
					this._memoryKiloByteHistory.splice(0, this._memoryKiloByteHistory.length - this._maxHistoryItems);
				}
				
				//calc min/max							
				this._memoryKiloByteMin = this._memoryKiloByteHistory[0];
				this._memoryKiloByteMax = this._memoryKiloByteHistory[0];				
				iLim = this._memoryKiloByteHistory.length;
				for (i = 1;i < iLim;i++)
				{
					this._memoryKiloByteMin = Math.min(this._memoryKiloByteHistory[i], this._memoryKiloByteMin); 
					this._memoryKiloByteMax = Math.max(this._memoryKiloByteHistory[i], this._memoryKiloByteMax); 
				}
				
				if (this._redraw)
				{
					//add text
					this._memoryField.appendText(' [ ' + String(Math.round(this._memoryKiloByteMin / 1024 * 100) / 100) + ' / ' + String(Math.round(this._memoryKiloByteMax / 1024 * 100) / 100) + ' ]');
					
					if (this._graph)
					{
						//calc some more & draw
						this.graphics.lineStyle(0, 0x0099FF, 1, false, LineScaleMode.NORMAL);
						dx = this._graphRect.width / iLim;
						dy = this._graphRect.height / (this._memoryKiloByteMax - this._memoryKiloByteMin);
						for (i = 0;i < iLim;i++)
						{
							tmpY = this._graphRect.bottom - dy * (this._memoryKiloByteHistory[i] - this._memoryKiloByteMin);
							this.graphics.moveTo(this._graphRect.left + dx * i, tmpY);
							this.graphics.lineTo(this._graphRect.left + dx * (i + 1), tmpY);
						}
					}
				}			
					
				//reset these
				this._frameMilliTotal = 0;		
				this._memoryKiloByteTotal = 0;
				this._ticks = 0;
			}
		}

		/**
		 * clear the graph history, or maybe chop first X items
		 */
		public function resetGraph(chop:int = 0):void
		{
			if (chop == 0)
			{
				this._frameMilliHistory = new Array();
				this._memoryKiloByteHistory = new Array();
			}
			else
			{
				//both are same length (so one check is fine)
				if (this._frameMilliHistory.length > chop)
				{
					this._frameMilliHistory.splice(0, this._frameMilliHistory.length - chop);	
					this._memoryKiloByteHistory.splice(0, this._memoryKiloByteHistory.length - chop);	
				}
				else
				{
					this._frameMilliHistory = new Array();	
					this._memoryKiloByteHistory = new Array();
				}
			}
		}

		//lazy setter
		private function setFieldFormat(field:TextField, width:Number = 50, height:Number = 20, color:Number = 0x000000):void
		{
			field.textColor = 0x000000;
			field.background = this._graph;
			field.backgroundColor = 0xFFFFFF;
			field.border = this._graph;
			
			field.selectable = false;
			field.width = width;
			field.height = height;
			field.defaultTextFormat = new TextFormat('_sans', 9, color);
		}

		public function get redraw():Boolean
		{
			return this._redraw;
		}

		public function set redraw(value:Boolean):void
		{
			this._redraw = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);

			this._fieldHeight = NaN;
			this._memoryKiloByteTotal = NaN;
			this._fpsField = null;
			this._memoryKiloByteMin = NaN;
			this._graphRect = null;
			this._frameMilliMax = NaN;
			this._updateFrequency = NaN;
			this._memoryKiloByteMax = NaN;
			this._maxHistoryItems = NaN;
			this._frameMilliTotal = NaN;
			this._redraw = false;
			this._frameMilliMin = NaN;
			this._memoryKiloByteHistory = null;
			this._frameMilliHistory = null;
			this._nextUpdateTime = NaN;
			this._previousTime = NaN;
			this._memoryField = null;
			this._ticks = NaN;
		}
	}
}

