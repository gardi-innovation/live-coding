s.boot;
s.options.numInputBusChannels = 0;
s.reboot;

(
SynthDef.new(\sine, {
	arg freq=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.5, 0.15, 0.15], inf).trace,
	\freq, Pseq([330, 247, 370, 220], inf).trace,
).play;
)

s.plotTree;

p.stop;

// midicps
(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.5, 0.15, 0.15], inf).trace,
	\freq, Pseq([60, 65, 67, 74].midicps, inf).trace,
).play;
)

// midinote
(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.5, 0.15, 0.15], inf).trace,
	\midinote, Pseq([60, 65, 67, 74], inf).trace,
).play;
)

// pexprand
(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.5, 0.15, 0.15], inf).trace,
	\freq, Pexprand(50, 4000, inf).trace,
).play;
)

// pwhite
(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf).trace,
	\freq, Pexprand(50, 4000, inf).trace,
).play;
)

// attack and release
(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\freq, Pexprand(50, 4000, inf).trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
	\pan, Pwhite(-0.8, 0.8, inf)
).play;
)

// Round to harmonic series
(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\freq, Pexprand(50, 4000, inf).round(55).trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
	\pan, Pwhite(-0.8, 0.8, inf)
).play;
)

// MIDI Note + harmonic
(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\midinote, 33,
	\harmonic, Pexprand(1, 80, inf).round.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
	\pan, Pwhite(-0.8, 0.8, inf)
).play;
)

// Reduce high harmonics
(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\midinote, 33,
	\harmonic, Pexprand(1, 80, inf).round.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pkey(\harmonic).reciprocal * 0.3,
	\pan, Pwhite(-0.8, 0.8, inf)
).play;
)


// Sinepath
(
Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pwhite(0.05, 0.5, inf),
		\midinote, Pseq([20], inf).trace,
		\harmonic, Pexprand(1, 40, inf).round.trace,
		\atk, Pwhite(2.0, 3.0, inf),
		\rel, Pwhite(5.0, 10.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8, 0.8, inf)
	);
).play;
)



//
(
d = Dictionary.new;
d.add(\l -> PathName("/Users/edmundigardi/Documents/Audio/Audio-Library/Atmos/Knocks/low").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
  });
);
d.add(\m -> PathName("/Users/edmundigardi/Documents/Audio/Audio-Library/Atmos/Knocks/mid").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
  });
);
d.add(\h -> PathName("/Users/edmundigardi/Documents/Audio/Audio-Library/Atmos/Knocks/high").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
  });
);
)

d[\m].choose.play;

(
SynthDef.new(\sine, {
	arg freq=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
}).add;

SynthDef.new(\bufplay, {
	arg buf=0, rate=1, amp=1;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = sig * amp;
	Out.ar(0, sig);
}).add;
)

Synth.new(\bufplay, [\buf, d[\m].choose.bufnum]);


(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
	    \stretch, (60/128) * 4,
	    \buf, Prand(d[\h]++d[\l]++d[\m], inf),
	    \rate, 1,
	    \amp, 1,
);
).stop;
)

(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
	    \stretch, (60/128) * 4,
	    \buf, Pxrand(d[\h]++d[\l]++d[\m], inf),
	    \rate, 1,
	    \amp, 1,
);
).stop;
)

[0.8]++(0.1!7)

(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
	    \stretch, (60/128) * 4,
		\buf, Pwrand([d[\h][0],d[\l][0],d[\m][0]], [8,2,1].normalizeSum, inf),
	    \rate, 1,
	    \amp, 1,
);
).stop;
)


// Pshuf - dyi





