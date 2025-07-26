s.boot;

~b0 = Buffer.read(s, "/Users/edmundigardi/Documents/Audio/Audio-Library/351422__diramus__wood-crack.wav");
~b0.play;
~b0.zero;
~b0.play;
//

~b0.read("/Users/edmundigardi/Documents/Audio/Audio-Library/351422__diramus__wood-crack.wav");
~b0.play;
~b0.free;

// Remove all
Buffer.freeAll;

// Shortcut to load files. Drag and drop.
~b0 = Buffer.read(s, "/Users/edmundigardi/Documents/Audio/Audio-Library/6890__hanstimm__kr1.aiff");
~b1 = Buffer.read(s,"/Users/edmundigardi/Documents/Audio/Audio-Library/103958__robinhood76__02041-textile-tearing.wav");
~b2 = Buffer.read(s, "/Users/edmundigardi/Documents/Audio/Audio-Library/351422__diramus__wood-crack.wav");

~b0.play;
~b1.play;
~b2.play;

// Fundamental attributes of buffers
// FRAMES
~b0.numFrames;

// CHANNELS
~b0.numChannels;

// numSamples = numFrames * numChannels

~b4 = Buffer.readChannel(s, "/Users/edmundigardi/Documents/Audio/Audio-Library/6890__hanstimm__kr1.aiff", channels:[1]);
s.meter;
~b0.play;
~b4.numChannels;
~b4.play; // Only one channel!

// DURATION
~b0.duration; // Length in seconds

// BUFFER NUMBERS (bufnums)
~b0.bufnum; // Returns a unique integer for this particular buffer
~b1.bufnum;
~b2.bufnum;
~b4.bufnum;

//BUFFER SAMPLE RATE
~b0.sampleRate;
s.sampleRate;

//SUMMARY
~b0.query; //Returns summary of many features


~b2.play;
~b2_part0 = Buffer.read(s, "/Users/edmundigardi/Documents/Audio/Audio-Library/351422__diramus__wood-crack.wav", 0, s.sampleRate/2);
~b2_part0.play;

~b2.numFrames;
~b2_part1 = Buffer.read(s, "/Users/edmundigardi/Documents/Audio/Audio-Library/351422__diramus__wood-crack.wav", 12000, ~b2.numFrames - 12001);
~b2_part1.numFrames;
~b2_part1.play;



// Load multiple files at the time
~bells = Array.new;
~folder = PathName.new("/Users/edmundigardi/Documents/Audio/Audio-Library/Atmos/");

(
~folder.entries.do({
	arg path;
	~bells = ~bells.add(Buffer.read(s,path.fullPath));
});
)

~bells[0].play;
~bells[1].play;
~bells[3].play;
~bells[4].play;

s.options.numBuffers;
//s.options.numBuffers = 2000; // Change the number of max buffers from the default 1024

// UGens Buffers

// Fix issue when using MacBook with headphones and iPhone connected via USB-C for Hotspot
s.options.numInputBusChannels = 0;
s.reboot;

(
SynthDef.new(\playbuf_test, {
	arg amp=1, out=0, buf, rate=1, da=2;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale,kr(buf) * rate, doneAction:da);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Synth.new(\playbuf_test, [\buf, ~b0.bufnum, \rate, 2]);
Synth.new(\playbuf_test, [\buf, ~b1.bufnum, \rate, 1]);
Synth.new(\playbuf_test, [\buf, ~b2.bufnum, \rate, 0.5]);

~b0.query;

s.plotTree;
s.freeAll;

// Trig
(
SynthDef.new(\playbuf_test, {
	arg amp=1, out=0, buf, rate=1, t_trig=1, start=0, loop=0, da=2;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, t_trig, start, loop, doneAction:da);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\playbuf_test, [\buf, ~b0.bufnum, \start, s.sampleRate/2, \da, 0]);
x.set(\t_trig, 1);

// Loop
x = Synth.new(\playbuf_test, [\buf, ~b0.bufnum, \loop, 1]);

// Reverse

...

// midiration
Synth.new(\playbuf_test, [\buf, ~bells[0].bufnum, \rate, 1.midiratio]);
Synth.new(\playbuf_test, [\buf, ~bells[0].bufnum, \rate, 3.midiratio]);
Synth.new(\playbuf_test, [\buf, ~bells[0].bufnum, \rate, 7.midiratio]);
Synth.new(\playbuf_test, [\buf, ~bells[0].bufnum, \rate, 8.midiratio]);

g = Group.new;

(
x = Synth.new(\playbuf_test, [\buf, ~b0.bufnum, \rate, 1.5, \loop,  1, \amp, 0.5], g);
y = Synth.new(\playbuf_test, [\buf, ~b1.bufnum, \rate, 1.5, \loop,  1, \amp, 0.5], g);
z = Synth.new(\playbuf_test, [\buf, ~b2.bufnum, \rate, 1.5, \loop,  1, \amp, 0.5], g);
)

g.set(\rate, 1);

g.set(\buf, ~b0.bufnum);
x.set(\rate, exprand(0.2, 2.0));
y.set(\rate, exprand(0.2, 2.0));
z.set(\rate, exprand(0.2, 2.0));
g.set(\loop, 0);

x.free;
y.free;
z.free;

// Bufread

(
SynthDef.new(\bufrd_test, {
	arg amp=1, out=0, buf, start, end;
	var sig, ptr;
	ptr = Line.ar(start, end, BufDur.kr(buf), doneAction:2);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

// Forward
Synth.new(\bufrd_test, [\buf, ~b2.bufnum, \start, 0, \end, ~b2.numFrames-1]);
// Backward
~r = ~b2.numFrames-1;
Synth.new(\bufrd_test, [\buf, ~b2.bufnum, \start, ~r, \end, 0]);

// Line is not capable of looping
(
SynthDef.new(\bufrd_loop, {
	arg amp=1, out=0, buf, start, end, rate=1;
	var sig, ptr;
	ptr = Phasor.ar(0, BufRateScale.kr(buf)*rate, start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\bufrd_loop, [\buf, ~b2.bufnum, \start, 0, \end, ~b2.numFrames-1]);
x.set(\start, ~b2.numFrames/8, \end, ~b2.numFrames-1000);
x.set(\start, 2000, \end, 26000);
x.set(\rate, 12.midiratio);
x.free;

//SineOsc
(
SynthDef.new(\bufrd_sine, {
	arg amp=1, out=0, buf, start, end, freq=1;
	var sig, ptr;
	ptr = SinOsc.ar(freq, 3pi/2).range(start,end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\bufrd_sine, [\buf, ~b2.bufnum, \start, 0, \end, ~b2.numFrames-1, \freq, 1.2]);
x.free;

//Noise
(
SynthDef.new(\bufrd_noise, {
	arg amp=1, out=0, buf, start, end, freq=1;
	var sig, ptr;
	ptr = LFDNoise1.ar(freq).range(start,end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\bufrd_noise, [\buf, ~b2.bufnum, \start, 0, \end, ~b2.numFrames-1, \freq, 33.3]);
x.free;

//Group

g = Group.new;
x = Synth.new(\bufrd_noise, [\buf, ~b0.bufnum, \start, 0, \end, ~b0.numFrames-1, \freq, 2.5, \amp, 0.5], g);
y = Synth.new(\bufrd_noise, [\buf, ~b1.bufnum, \start, 0, \end, ~b1.numFrames-1, \freq, 3.5, \amp, 0.5], g);
z = Synth.new(\bufrd_noise, [\buf, ~b2.bufnum, \start, 0, \end, ~b2.numFrames-1, \freq, 2.7, \amp, 0.5], g);
w = Synth.new(\bufrd_noise, [\buf, ~b4.bufnum, \start, 0, \end, ~b4.numFrames-1, \freq, 3.3, \amp, 0.2], g);

g.set(\freq, 3);

s.freeAll;















