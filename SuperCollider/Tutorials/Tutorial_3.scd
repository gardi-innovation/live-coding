s.boot;

(
z = {
	arg noiseHz=8;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(200, 1000);
	amp = LFNoise1.kr(12).exprange(0.02,1);
	sig = SinOsc.ar(freq) * amp;
}.play;
)

// Changing it to synthdef

(
SynthDef.new(\sineTest, {
	arg noiseHz=8;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(200, 1000);
	amp = LFNoise1.kr(12).exprange(0.02,1);
	sig = SinOsc.ar(freq) * amp;
	Out.ar(0, sig); //This is mandatory when using SynthDef!
}).add;
)

x = Synth.new(\sineTest);
x.free;

y = Synth.new(\sineTest, [\noiseHz, 32]);
y.set(\noiseHz, 12);
y.free;


// Pulse test

(
SynthDef.new(\pulseTest, {
	arg ampHz=4, fund=40, maxPartial=4, width=0.5;
	var amp1, amp2, freq1, freq2, sig1, sig2;
	amp1 = LFPulse.kr(ampHz, 0 , 0.12) * 0.75;
	amp2 = LFPulse.kr(ampHz, 0.5, 0.12) * 0.75;
	freq1 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq2 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq1 = freq1 * LFPulse.kr(8, add:1);
	freq2 = freq2 * LFPulse.kr(6, add:1);
	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp2);
	sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
	Out.ar(0, sig1);
	Out.ar(1, sig2);
}).add;
)

w = Synth.new(\pulseTest);

w.set(\width, 0.25);
w.set(\fund, 120);
w.set(\maxPartial, 24);
w.set(\ampHz, 0.5);
w.free;

x = Synth.new(\pulseTest, \ampHz, 3.3, \fund, 48, \maxPartial, 4, \width, 0.15]);





