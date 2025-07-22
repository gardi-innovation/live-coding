
// Search: cmd + shift + d

[6, 4, 0.5, 10, 7].do{"hello".postln};




//

x = Array.newClear(5);

(
[6, 4, 0.5, 10, 7].do{
	arg item, count;
	x[count] = itme.squared.postln;
}
)

(
z = [6, 4, 0.5, 10, 7].collect{
	arg item;
	item.squared;
}
)

z = [6, 4, 0.5, 10, 7].collect(_.squared);


5.do{arg item; item.postln};

[0, 1, 2, 3, 4, 5].do{arg item; item.postln};


// UGens
s.boot;
x = {VarSaw.ar(40!2, 0, 0.05)}.play;
x.free;

(
SynthDef.new(\iter, {
	arg freq=40;
	var temp, sum, env;
	sum = 0;
	env = EnvGen.kr(Env.perc(0.01, 5, 1, -2), doneAction:2);
	10.do{
		temp = VarSaw.ar(
			freq * {Rand(0.99,1.02)}!2,
			{Rand(0.0, 1.0)}!2,
			{ExpRand(0.005, 0.05)}!2
		);
		sum = sum + temp;
	};
	sum = sum * 0.05 * env;
	Out.ar(0, sum);
}).add;
)

x = Synth.new(\iter, [\freq, 66.midicps]);
x = Synth.new(\iter, [\freq, 73.midicps]);
x = Synth.new(\iter, [\freq, 80.midicps]);
x = Synth.new(\iter, [\freq, 75.midicps]);

x.free;

//

(
SynthDef.new(\iter2, {
	arg freq=200, dev=1.02;
	var temp, sum;
	sum=0;
	10.do{
		arg count;
		temp = SinOsc.ar(
			freq *
			(count + 1) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev)
	);
		temp = temp * LFNoise1.kr({Rand(0.5,8)}!2).exprange(0.01,1);
		sum = sum + temp;
	};
	sum = sum * 0.05;
	Out.ar(0, sum);
}).add;
)

x = Synth.new(\iter2);
x.set(\freq, 33);
x.set(\dev, 0.33);
x.free;










