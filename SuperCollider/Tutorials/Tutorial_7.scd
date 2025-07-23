s.boot;
s.plotTree;
s.meter;

// Nodes, Busses, Order of Exectution

// Node -> [Synth, Group]

(
SynthDef.new(\blip, {
	arg out;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(300,1200).round(300);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(2);
	sig = sig * EnvGen.kr(Env.perc(0.01, 0.2), trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;
)

(
SynthDef.new(\reverb, {
	arg in, out=0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
}).add;
)

s.options.numAudioBusChannels;
s.options.numOutputBusChannels = 4;
s.options.numInputBusChannels = 2;

s.reboot;
s.meter;

y = Synth.new(\reverb, [\in, ~reverbBus]);
x = Synth.new(\blip, [\out, ~reverbBus]);
x.free;
y.free;

x.set(\out, 25);
y.set(\in, 25);


// Let's talk about busses
~reverbBus = Bus.audio(s,1);
~revbebBus.index;

~reverbBus2 = Bus.audio(s,2);
~reverbBus3 = Bus.audio(s,1);
~reverbBus2.index;


// Groups

g = Group.new;
x.free;
g.free;

x = Synth.new(\blip, [\out, ~reverbBus2], s, \addToHead);
y = Synth.new(\reverb, [\in, ~reverbBus2], s, \addToTail);


x = Synth.new(\blip, [\out, ~reverbBus2]);
y = Synth.new(\reverb, [\in, ~reverbBus2], x, \addAfter);
x.free;
x = Synth.before(y, \blip, [\out, ~reverbBus2]);
y.free;


~sourceGrp = Group.new;
~fxGrp = Group.after(~sourceGrp);

x = Synth.new(\blip, [\out, ~reverbBus2], ~sourceGrp);
y = Synth.new(\reverb, [\in, ~reverbBus2], ~fxGrp);
x.free;
y.free;



//
(
SynthDef.new(\blip, {
	arg out, fund=300, dens=2, decay=0.2;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(fund,fund*4).round(fund);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(dens);
	sig = sig * EnvGen.kr(Env.perc(0.01, decay), trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;
)

(
SynthDef.new(\reverb, {
	arg in, out=0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
}).add;
)

~sourceGrp = Group.new;
~fxGrp = Group.after(~sourceGrp);

8.do{
	Synth.new(
		\blip,
		[
			\out, ~reverbBus2,
			\fund, exprand(60,300)
		],
		~sourceGrp
	);
}

y = Synth.new(\reverb, [\in, ~reverbBus2], ~fxGrp);

~sourceGrp.set(\decay, 1.2);
~soruceGrp.set(\dens, 0.25);

~sourceGrp.freeAll;
y.free;






