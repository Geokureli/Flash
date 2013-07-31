package music.fft {
	import flash.utils.ByteArray;

	/**
	 * Performs an in-place complex FFT.
	 *
	 * Released under the MIT License
	 *
	 * Copyright (c) 2010 Gerald T. Beauregard
	 *
	 * Permission is hereby granted, free of charge, to any person obtaining a copy
	 * of this software and associated documentation files (the "Software"), to
	 * deal in the Software without restriction, including without limitation the
	 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
	 * sell copies of the Software, and to permit persons to whom the Software is
	 * furnished to do so, subject to the following conditions:
	 *
	 * The above copyright notice and this permission notice shall be included in
	 * all copies or substantial portions of the Software.
	 *
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
	 * IN THE SOFTWARE.
	 */
	public class FFT {
		public static const FORWARD:Boolean = false;
		public static const INVERSE:Boolean = true;
		
		private var logN:uint = 0;			// log2 of FFT size
		private var numSamples:uint = 0;				// FFT size
		private var invNumSamples:Number;				// Inverse of FFT length
		
		private var elements:Vector.<FFTElement>;	// Vector of linked list elements
		
		/**
		 *
		 */
		public function FFT(){}
		
		/**
		 * Initialize class to perform FFT of specified size.
		 *
		 * @param	logN	Log2 of FFT length. e.g. for 512 pt FFT, logN = 9.
		 */
		public function init(logN:uint):void {
			this.logN = logN;
			numSamples = 1 << logN;
			invNumSamples = 1.0/numSamples;
			
			// Allocate elements for linked list of complex numbers.
			elements = new Vector.<FFTElement>(numSamples);
			for (var k:uint = 0; k < numSamples; k++)
				elements[k] = new FFTElement();
			
			// Set up "next" pointers.
			for (k = 0; k < numSamples-1; k++)
				elements[k].next = elements[k+1];
			
			// Specify target for bit reversal re-ordering.
			for (k = 0; k < numSamples; k++)
				elements[k].revTgt = BitReverse(k,logN);
		}
		
		/**
		 * Performs in-place complex FFT.
		 *
		 * @param	xRe		Real part of input/output
		 * @param	xIm		Imaginary part of input/output
		 * @param	inverse	If true (INVERSE), do an inverse FFT
		 */
		public function run(xRe:Vector.<Number>, xIm:Vector.<Number>, inverse:Boolean = false):void {
			
			var numFlies:uint = numSamples >> 1;	// Number of butterflies per sub-FFT
			var span:uint = numSamples >> 1;		// Width of the butterfly
			var spacing:uint = numSamples;			// Distance between start of sub-FFTs
			var wIndexStep:uint = 1; 		// Increment for twiddle table index
			
			// Copy data into linked complex number objects
			// If it's an IFFT, we divide by N while we're at it
			var x:FFTElement = elements[0];
			var k:uint = 0;
			var scale:Number = inverse ? invNumSamples : 1.0;
			while (x != null) {
				x.re = scale * xRe[k];
				x.im = scale * xIm[k];
				x = x.next;
				k++;
			}
			
			var start:uint, flyCount:uint;
			
			var wAngleInc:Number, tRe:Number,
				wMulRe:Number,	wMulIm:Number,
				wRe:Number,		wIm:Number,
				xTopRe:Number,	xTopIm:Number,
				xBotRe:Number,	xBotIm:Number;
			
			var xTop:FFTElement,
				xBot:FFTElement;
			
			for (var stage:uint = 0; stage < logN; stage++) {
				// Compute a multiplier factor for the "twiddle factors".
				// The twiddle factors are complex unit vectors spaced at
				// regular angular intervals. The angle by which the twiddle
				// factor advances depends on the FFT stage. In many FFT
				// implementations the twiddle factors are cached, but because
				// vector lookup is relatively slow in ActionScript, it's just
				// as fast to compute them on the fly.
				wAngleInc = wIndexStep * 2 * Math.PI / numSamples;
				if (!inverse) // Corrected 3 Aug 2011. Had this condition backwards before, so FFT was IFFT, and vice-versa!
					wAngleInc *= -1;
				wMulRe = Math.cos(wAngleInc);
				wMulIm = Math.sin(wAngleInc);
				
				for (start = 0; start < numSamples; start += spacing) {
					xTop = elements[start];
					xBot = elements[start + span];
					
					wRe = 1.0;
					wIm = 0.0;
					
					// For each butterfly in this stage
					for (flyCount = 0; flyCount < numFlies; ++flyCount) {
						// Get the top & bottom values
						xTopRe = xTop.re;
						xTopIm = xTop.im;
						xBotRe = xBot.re;
						xBotIm = xBot.im;
						
						// Top branch of butterfly has addition
						xTop.re = xTopRe + xBotRe;
						xTop.im = xTopIm + xBotIm;
						
						// Bottom branch of butterly has subtraction,
						// followed by multiplication by twiddle factor
						xBotRe = xTopRe - xBotRe;
						xBotIm = xTopIm - xBotIm;
						xBot.re = xBotRe*wRe - xBotIm*wIm;
						xBot.im = xBotRe*wIm + xBotIm*wRe;
						
						// Advance butterfly to next top & bottom positions
						xTop = xTop.next;
						xBot = xBot.next;
						
						// Update the twiddle factor, via complex multiply
						// by unit vector with the appropriate angle
						// (wRe + j wIm) = (wRe + j wIm) x (wMulRe + j wMulIm)
						tRe = wRe;
						wRe = wRe*wMulRe - wIm*wMulIm;
						wIm = tRe*wMulIm + wIm*wMulRe;
					}
				}
				
				numFlies >>= 1; 	// Divide by 2 by right shift
				span >>= 1;
				spacing >>= 1;
				wIndexStep <<= 1;  	// Multiply by 2 by left shift
			}
			
			// The algorithm leaves the result in a scrambled order.
			// Unscramble while copying values from the complex
			// linked list elements back to the input/output vectors.
			var target:uint;
			x = elements[0];
			while (x != null) {
				target = x.revTgt;
				xRe[target] = x.re;
				xIm[target] = x.im;
				x = x.next;
			}
		}
		
		public function runBytes(bytes:ByteArray):Vector.<Number> {
			var input:Vector.<Number> = new Vector.<Number>();
			while (bytes.bytesAvailable > 0 && input.length < numSamples)
				input.push(bytes.readFloat());
			
			var output:Vector.<Number> = new Vector.<Number>(numSamples);
			run(input, output);
			return output;
		}
		
		/**
		 * Do bit reversal of specified number of places of an int
		 * For example, 1101 bit-reversed is 1011
		 *
		 * @param	x		Number to be bit-reverse.
		 * @param	numBits	Number of bits in the number.
		 */
		private function BitReverse(x:uint, numBits:uint):uint {
			var y:uint = 0;
			for (var i:uint = 0; i < numBits; i++) {
				y <<= 1;
				y |= x & 0x0001;
				x >>= 1;
			}
			return y;
		}
	}
}