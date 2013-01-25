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

package temple.common.enum 
{

	/**
	 * This class contains possible values for alignments. Not all alignments are valid for all alignable objects.
	 * 
	 * @author Thijs Broerse
	 */
	public final class Align 
	{
		/**
		 * Align to the left
		 */
		public static const LEFT:String = "left";
		
		/**
		 * Align to the center
		 */
		public static const CENTER:String = "center";
		
		/**
		 * Align to the right
		 */
		public static const RIGHT:String = "right";
		
		/**
		 * Align to the top
		 */
		public static const TOP:String = "top";
		
		/**
		 * Align to the middle
		 */
		public static const MIDDLE:String = "middle";
		
		/**
		 * Align to the bottom
		 */
		public static const BOTTOM:String = "bottom";
		
		/**
		 * Align to the top and the left
		 */
		public static const TOP_LEFT:String = "topLeft";
		
		/**
		 * Align to the top and the right
		 */
		public static const TOP_RIGHT:String = "topRight";
		
		/**
		 * Align to the bottom and the left
		 */
		public static const BOTTOM_LEFT:String = "bottomLeft";
		
		/**
		 * Align to the bottom and the right
		 */
		public static const BOTTOM_RIGHT:String = "bottomRight";
		
		/**
		 * No alignment
		 */
		public static const NONE:String = "none";
	}
}
