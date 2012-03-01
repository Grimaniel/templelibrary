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

package temple.ui.tooltip 
{
	import temple.common.interfaces.IShowable;
	import temple.core.display.ICoreDisplayObject;
	import temple.ui.label.ILabel;

	import flash.geom.Point;

	/**
	 * The tooltip is a graphical user interface element. It is used in conjunction with a cursor, usually a pointer.
	 * The user hovers the pointer over an item, without clicking it, and a tooltip may appear—a small "hover box" with
	 * information about the item being hovered over
	 * 
	 * @see http://en.wikipedia.org/wiki/Tooltip
	 * 
	 * @author Thijs Broerse
	 */
	public interface IToolTip extends ILabel, ICoreDisplayObject, IShowable
	{
		/**
		 * If ToolTip.minimumStageMargin is set and the ToolTip needs te be moved to keep it in the Stage.
		 * The offset which is used to move it will be passed through this function to the ToolTip.
		 * This is usefull when you use an arrow in the ToolTip which must be moved to match the new position.
		 */
		function setStageMarginOffset(offset:Point):void;
	}
}
