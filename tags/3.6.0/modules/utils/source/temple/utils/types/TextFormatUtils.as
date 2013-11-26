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

package temple.utils.types
{
	import flash.text.TextFormat;
	/**
	 * @author Thijs Broerse
	 */
	public final class TextFormatUtils
	{
		/**
		 * Creates a clone of a <code>TextFormat</code>
		 */
		public static function clone(textFormat:TextFormat):TextFormat
		{
			var clone:TextFormat = new TextFormat();
			
			clone.align = textFormat.align;
			clone.blockIndent = textFormat.blockIndent;
			clone.bold = textFormat.bold;
			clone.bullet = textFormat.bullet;
			clone.color = textFormat.color;
			clone.display = textFormat.display;
			clone.font = textFormat.font;
			clone.indent = textFormat.indent;
			clone.italic = textFormat.italic;
			clone.kerning = textFormat.kerning;
			clone.leading = textFormat.leading;
			clone.leftMargin = textFormat.leftMargin;
			clone.letterSpacing = textFormat.letterSpacing;
			clone.rightMargin = textFormat.rightMargin;
			clone.size = textFormat.size;
			clone.tabStops = textFormat.tabStops;
			clone.target = textFormat.target;
			clone.underline = textFormat.underline;
			clone.url = textFormat.url;
			
			return clone;
		}
	}
}
