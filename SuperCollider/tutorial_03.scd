Server.local.boot;

Server.local.quit;

x = {SinOsc.ar};

y = x.play;

y.free;

z = { SinOsc.ar(800, SinOsc.ar(XLine.kr(1, 1000, 9), 0, 2pi), 0.25) };

zz = z.play;

x = {SinOsc.ar(700,0,0.125,9)}.play;

x.free;


(
z = {
	var freq, sig;
	freq = LFNoise0.kr(8).exprange(200,1000);
	sig = SinOsc.ar(freq);
}.play
)

z.free;

zz = { SinOsc.ar(800, SinOsc.ar(XLine.kr(1, 1000, 9), 0, 2pi), 0.25) };

(
w = {
	arg noiseHz=8;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(200,1000);
	amp = LFNoise1.kr(12).exprange(0.02, 1);
	sig = SinOsc.ar(freq) * amp;
}.play
)

w.set(\noiseHz, 8);

w.free;

(
SynthDef.new(\sineTest, {
	arg noiseHz=8;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(200,1000);
	amp = LFNoise1.kr(12).exprange(0.02, 1);
	sig = SinOsc.ar(freq) * amp;
	Out.ar(0,sig);
	Out.ar(1,sig);
}).add;
)

x = Synth.new(\sineTest);

x.free;
