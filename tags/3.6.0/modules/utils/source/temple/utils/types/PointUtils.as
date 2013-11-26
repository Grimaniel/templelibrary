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
	import flash.geom.Point;
	
	/**
	 * This class contains some functions for Points.
	 * 
	 * @author Thijs Broerse
	 */
	public final class PointUtils
	{
		/**
		 *  Returns a point containing the intersection between two lines
		 */
		public static function getIntersection(p1:Point, p2:Point, p3:Point, p4:Point):Point
		{
			var a1:Number = p2.y - p1.y;
			var b1:Number = p1.x - p2.x;
			var a2:Number = p4.y - p3.y;
			var b2:Number = p3.x - p4.x;

			var denom:Number = a1 * b2 - a2 * b1;
			if (denom == 0) return null;

			var c1:Number = p2.x * p1.y - p1.x * p2.y;
			var c2:Number = p4.x * p3.y - p3.x * p4.y;
			
			var p:Point = new Point((b1 * c2 - b2 * c1) / denom, (a2 * c1 - a1 * c2) / denom);

			if ((p.x - p2.x) * (p.x - p2.x) + (p.y - p2.y) * (p.y - p2.y) > (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)) return null;
			if ((p.x - p1.x) * (p.x - p1.x) + (p.y - p1.y) * (p.y - p1.y) > (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)) return null;
			if ((p.x - p4.x) * (p.x - p4.x) + (p.y - p4.y) * (p.y - p4.y) > (p3.x - p4.x) * (p3.x - p4.x) + (p3.y - p4.y) * (p3.y - p4.y)) return null;
			if ((p.x - p3.x) * (p.x - p3.x) + (p.y - p3.y) * (p.y - p3.y) > (p3.x - p4.x) * (p3.x - p4.x) + (p3.y - p4.y) * (p3.y - p4.y)) return null;
			
			return p;
		}
		
		public static function squaredDistance(p0:Point, p1:Point):Number
		{
			return ((p0.x - p1.x) * (p0.x - p1.x) + (p0.y - p1.y) * (p0.y - p1.y));
		}
		
		public static function getDividersForQuad(p0:Point, p1:Point, p2:Point, p3:Point):Vector.<Number>
		{
			// Central point
			var pc:Point = PointUtils.getIntersection(p0, p3, p1, p2);

			// If no intersection between two diagonals, doesn't draw anything
			if (!Boolean(pc)) return null;

			// Lengths of first diagonal
			var ll1:Number = Point.distance(p0, pc);
			var ll2:Number = Point.distance(pc, p3);

			// Lengths of second diagonal
			var lr1:Number = Point.distance(p1, pc);
			var lr2:Number = Point.distance(pc, p2);

			// Ratio between diagonals
			var f:Number = (ll1 + ll2) / (lr1 + lr2);
			
			return Vector.<Number>([(1 / ll2) * f, (1 / lr2), (1 / lr1), (1 / ll1) * f]);
		}
		
		/**
		 * Rounds the x and y values of the Point
		 */
		public static function snapToPixels(point:Point):Point
		{
			point.x = Math.round(point.x);
			point.y = Math.round(point.y);
			return point;
		}
	}
}
