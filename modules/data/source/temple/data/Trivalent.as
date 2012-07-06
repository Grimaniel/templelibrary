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

package temple.data
{
	import temple.common.enum.Enumerator;

	/**
	 * In logic, a three-valued logic (also trivalent, ternary, or trinary logic, sometimes abbreviated 3VL) is any of
	 * several many-valued logic systems in which there are three truth values indicating true, false and some
	 * indeterminate third value. This is contrasted with the more commonly known bivalent logics (such as classical
	 * sentential or boolean logic) which provide only for true and false.
	 * 
	 * @see http://en.wikipedia.org/wiki/Ternary_logic
	 * 
	 * @author Thijs Broerse
	 */
	public final class Trivalent extends Enumerator
	{
		public static const TRUE:Trivalent = new Trivalent(true);
		
		public static const FALSE:Trivalent = new Trivalent(false);
		
		public static const UNDEFINED:Trivalent = null;
		
		/**
		 * Get a Trivalent by his value.
		 * @param value the value of the Trivalent
		 */
		public static function get(value:String):Trivalent
		{
			return Enumerator.get(Trivalent, value) as Trivalent;
		}
		
		/**
		 * @private
		 */
		public function Trivalent(value:Boolean)
		{
			super(value.toString());
		}
	}
}
