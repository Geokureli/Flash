/*
  Flod JS 2.1
  2012/04/30
  Christian Corti
  Neoart Costa Rica

  Last Update: Flod JS 2.1 - 2012/04/16

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
  Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
*/
(function(){function i(g){return Object.create(null,{index:{value:g,writable:!0},next:{value:null,writable:!0},channel:{value:null,writable:!0},sample:{value:null,writable:!0},enabled:{value:0,writable:!0},loopCtr:{value:0,writable:!0},loopPos:{value:0,writable:!0},step:{value:0,writable:!0},period:{value:0,writable:!0},effect:{value:0,writable:!0},param:{value:0,writable:!0},volume:{value:0,writable:!0},pointer:{value:0,writable:!0},length:{value:0,writable:!0},loopPtr:{value:0,writable:!0},repeat:{value:0,
writable:!0},finetune:{value:0,writable:!0},offset:{value:0,writable:!0},portaDir:{value:0,writable:!0},portaPeriod:{value:0,writable:!0},portaSpeed:{value:0,writable:!0},glissando:{value:0,writable:!0},tremoloParam:{value:0,writable:!0},tremoloPos:{value:0,writable:!0},tremoloWave:{value:0,writable:!0},vibratoParam:{value:0,writable:!0},vibratoPos:{value:0,writable:!0},vibratoWave:{value:0,writable:!0},funkPos:{value:0,writable:!0},funkSpeed:{value:0,writable:!0},funkWave:{value:0,writable:!0},initialize:{value:function(){this.sample=
this.channel=null;this.funkWave=this.funkSpeed=this.funkPos=this.vibratoWave=this.vibratoPos=this.vibratoParam=this.tremoloWave=this.tremoloPos=this.tremoloParam=this.glissando=this.portaSpeed=this.portaPeriod=this.portaDir=this.offset=this.finetune=this.repeat=this.loopPtr=this.length=this.pointer=this.volume=this.param=this.effect=this.period=this.step=this.loopPos=this.loopCtr=this.enabled=0}}})}function j(){var g=AmigaSample();Object.defineProperties(g,{finetune:{value:0,writable:!0},realLen:{value:0,
writable:!0}});return Object.seal(g)}var h=[856,808,762,720,678,640,604,570,538,508,480,453,428,404,381,360,339,320,302,285,269,254,240,226,214,202,190,180,170,160,151,143,135,127,120,113,0,850,802,757,715,674,637,601,567,535,505,477,450,425,401,379,357,337,318,300,284,268,253,239,225,213,201,189,179,169,159,150,142,134,126,119,113,0,844,796,752,709,670,632,597,563,532,502,474,447,422,398,376,355,335,316,298,282,266,251,237,224,211,199,188,177,167,158,149,141,133,125,118,112,0,838,791,746,704,665,
628,592,559,528,498,470,444,419,395,373,352,332,314,296,280,264,249,235,222,209,198,187,176,166,157,148,140,132,125,118,111,0,832,785,741,699,660,623,588,555,524,495,467,441,416,392,370,350,330,312,294,278,262,247,233,220,208,196,185,175,165,156,147,139,131,124,117,110,0,826,779,736,694,655,619,584,551,520,491,463,437,413,390,368,347,328,309,292,276,260,245,232,219,206,195,184,174,164,155,146,138,130,123,116,109,0,820,774,730,689,651,614,580,547,516,487,460,434,410,387,365,345,325,307,290,274,258,
244,230,217,205,193,183,172,163,154,145,137,129,122,115,109,0,814,768,725,684,646,610,575,543,513,484,457,431,407,384,363,342,323,305,288,272,256,242,228,216,204,192,181,171,161,152,144,136,128,121,114,108,0,907,856,808,762,720,678,640,604,570,538,508,480,453,428,404,381,360,339,320,302,285,269,254,240,226,214,202,190,180,170,160,151,143,135,127,120,0,900,850,802,757,715,675,636,601,567,535,505,477,450,425,401,379,357,337,318,300,284,268,253,238,225,212,200,189,179,169,159,150,142,134,126,119,0,894,
844,796,752,709,670,632,597,563,532,502,474,447,422,398,376,355,335,316,298,282,266,251,237,223,211,199,188,177,167,158,149,141,133,125,118,0,887,838,791,746,704,665,628,592,559,528,498,470,444,419,395,373,352,332,314,296,280,264,249,235,222,209,198,187,176,166,157,148,140,132,125,118,0,881,832,785,741,699,660,623,588,555,524,494,467,441,416,392,370,350,330,312,294,278,262,247,233,220,208,196,185,175,165,156,147,139,131,123,117,0,875,826,779,736,694,655,619,584,551,520,491,463,437,413,390,368,347,
328,309,292,276,260,245,232,219,206,195,184,174,164,155,146,138,130,123,116,0,868,820,774,730,689,651,614,580,547,516,487,460,434,410,387,365,345,325,307,290,274,258,244,230,217,205,193,183,172,163,154,145,137,129,122,115,0,862,814,768,725,684,646,610,575,543,513,484,457,431,407,384,363,342,323,305,288,272,256,242,228,216,203,192,181,171,161,152,144,136,128,121,114,0],k=[0,24,49,74,97,120,141,161,180,197,212,224,235,244,250,253,255,253,250,244,235,224,212,197,180,161,141,120,97,74,49,24],l=[0,5,6,
7,8,10,11,13,16,19,22,26,32,43,64,128];window.neoart.PTPlayer=function(g){g=AmigaPlayer(g);Object.defineProperties(g,{id:{value:"PTPlayer"},track:{value:null,writable:!0},patterns:{value:[],writable:!0},samples:{value:[],writable:!0},length:{value:0,writable:!0},voices:{value:[],writable:!0},trackPos:{value:0,writable:!0},patternPos:{value:0,writable:!0},patternBreak:{value:0,writable:!0},patternDelay:{value:0,writable:!0},breakPos:{value:0,writable:!0},jumpFlag:{value:0,writable:!0},vibratoDepth:{value:0,
writable:!0},force:{set:function(a){1>a?a=1:3<a&&(a=3);this.version=a;this.vibratoDepth=2>a?6:7}},initialize:{value:function(){var a=this.voices[0];this.tempo=125;this.speed=6;this.jumpFlag=this.breakPos=this.patternDelay=this.patternBreak=this.patternPos=this.trackPos=0;this.reset();for(this.force=this.version;a;)a.initialize(),a.channel=this.mixer.channels[a.index],a.sample=this.samples[0],a=a.next}},loader:{value:function(a){var c=0,e,d,f=0,b;if(!(2106>a.length)&&(a.position=1080,e=a.readString(4),
!("M.K."!=e&&"M!K!"!=e))){a.position=0;this.title=a.readString(20);this.version=1;a.position+=22;for(e=1;32>e;++e)(b=a.readUshort())?(d=j(),a.position-=24,d.name=a.readString(22),d.length=d.realLen=b<<1,a.position+=2,d.finetune=37*a.readUbyte(),d.volume=a.readUbyte(),d.loop=a.readUshort()<<1,d.repeat=a.readUshort()<<1,a.position+=22,d.pointer=f,f+=d.length,this.samples[e]=d):(this.samples[e]=null,a.position+=28);a.position=950;this.length=a.readUbyte();a.position++;for(e=0;128>e;++e)b=a.readUbyte()<<
8,this.track[e]=b,b>c&&(c=b);a.position=1084;c+=256;this.patterns.length=c;for(e=0;e<c;++e){b=AmigaRow();Object.defineProperties(b,{step:{value:0,writable:!0}});d=Object.seal(b);d.step=b=a.readUint();d.note=b>>16&4095;d.effect=b>>8&15;d.sample=b>>24&240|b>>12&15;d.param=b&255;this.patterns[e]=d;if(31<d.sample||!this.samples[d.sample])d.sample=0;15==d.effect&&31<d.param&&(this.version=2);8==d.effect&&(this.version=3)}this.mixer.store(a,f);for(e=1;32>e;++e)if(d=this.samples[e]){d.loop||4<d.repeat?(d.loopPtr=
d.pointer+d.loop,d.length=d.loop+d.repeat):(d.loopPtr=this.mixer.memory.length,d.repeat=2);f=d.pointer+2;for(a=d.pointer;a<f;++a)this.mixer.memory[a]=0}d=j();d.pointer=d.loopPtr=this.mixer.memory.length;d.length=d.repeat=2;this.samples[0]=d}}},process:{value:function(){var a,c,e,d,f,b=this.voices[0];if(this.tick)this.effects();else if(this.patternDelay)this.effects();else{for(e=this.track[this.trackPos]+this.patternPos;b;){a=b.channel;b.enabled=0;b.step||(a.period=b.period);d=this.patterns[e+b.index];
b.step=d.step;b.effect=d.effect;b.param=d.param;d.sample&&(c=b.sample=this.samples[d.sample],b.pointer=c.pointer,b.length=c.length,b.loopPtr=b.funkWave=c.loopPtr,b.repeat=c.repeat,b.finetune=c.finetune,a.volume=b.volume=c.volume);if(d.note){if(3664==(b.step&4080))b.finetune=37*(b.param&15);else if(3==b.effect||5==b.effect)if(d.note==b.period)b.portaPeriod=0;else{c=b.finetune;for(f=c+37;c<f&&!(d.note>=h[c]);++c);0<c&&(f=b.finetune/37>>0&8)&&c--;b.portaPeriod=h[c];b.portaDir=d.note>b.portaPeriod?0:
1}else 9==b.effect&&this.moreEffects(b);for(c=0;37>c&&!(d.note>=h[c]);++c);b.period=h[b.finetune+c];3792==(b.step&4080)?(b.funkSpeed&&this.updateFunk(b),this.extended(b)):(4>b.vibratoWave&&(b.vibratoPos=0),4>b.tremoloWave&&(b.tremoloPos=0),a.enabled=0,a.pointer=b.pointer,a.length=b.length,a.period=b.period,b.enabled=1,this.moreEffects(b))}else this.moreEffects(b);b=b.next}for(b=this.voices[0];b;)a=b.channel,b.enabled&&(a.enabled=1),a.pointer=b.loopPtr,a.length=b.repeat,b=b.next}if(++this.tick==this.speed&&
(this.tick=0,this.patternPos+=4,this.patternDelay&&--this.patternDelay&&(this.patternPos-=4),this.patternBreak&&(this.patternBreak=0,this.patternPos=this.breakPos,this.breakPos=0),256==this.patternPos||this.jumpFlag))this.patternPos=this.breakPos,this.jumpFlag=this.breakPos=0,++this.trackPos==this.length&&(this.trackPos=0,this.mixer.complete=1)}},effects:{value:function(){for(var a,c,e,d,f,b=this.voices[0];b;){a=b.channel;b.funkSpeed&&this.updateFunk(b);if(0==(b.step&4095))a.period=b.period;else{switch(b.effect){case 0:f=
this.tick%3;if(!f){a.period=b.period;b=b.next;continue}f=1==f?b.param>>4:b.param&15;c=b.finetune;for(e=c+37;c<e;++c)if(b.period>=h[c]){a.period=h[c+f];break}break;case 1:b.period-=b.param;113>b.period&&(b.period=113);a.period=b.period;break;case 2:b.period+=b.param;856<b.period&&(b.period=856);a.period=b.period;break;case 3:case 5:5==b.effect?d=1:(b.portaSpeed=b.param,b.param=0);if(b.portaPeriod)if(b.portaDir?(b.period-=b.portaSpeed,b.period<=b.portaPeriod&&(b.period=b.portaPeriod,b.portaPeriod=0)):
(b.period+=b.portaSpeed,b.period>=b.portaPeriod&&(b.period=b.portaPeriod,b.portaPeriod=0)),b.glissando){c=b.finetune;for(f=c+37;c<f&&!(b.period>=h[c]);++c);c==f&&c--;a.period=h[c]}else a.period=b.period;break;case 4:case 6:if(6==b.effect)d=1;else if(b.param){if(f=b.param&15)b.vibratoParam=b.vibratoParam&240|f;if(f=b.param&240)b.vibratoParam=b.vibratoParam&15|f}e=b.vibratoPos>>2&31;(c=b.vibratoWave&3)?(f=255,e<<=3,1==c&&(f=127<b.vibratoPos?f-e:e)):f=k[e];f=(b.vibratoParam&15)*f>>this.vibratoDepth;
a.period=127<b.vibratoPos?b.period-f:b.period+f;f=b.vibratoParam>>2&60;b.vibratoPos=b.vibratoPos+f&255;break;case 7:a.period=b.period;if(b.param){if(f=b.param&15)b.tremoloParam=b.tremoloParam&240|f;if(f=b.param&240)b.tremoloParam=b.tremoloParam&15|f}e=b.tremoloPos>>2&31;(c=b.tremoloWave&3)?(f=255,e<<=3,1==c&&(f=127<b.tremoloPos?f-e:e)):f=k[e];f=(b.tremoloParam&15)*f>>6;a.volume=127<b.tremoloPos?b.volume-f:b.volume+f;f=b.tremoloParam>>2&60;b.tremoloPos=b.tremoloPos+f&255;break;case 10:d=1;break;case 14:this.extended(b)}d&&
(d=0,f=b.param>>4,b.volume=f?b.volume+f:b.volume-(b.param&15),0>b.volume?b.volume=0:64<b.volume&&(b.volume=64),a.volume=b.volume)}b=b.next}}},moreEffects:{value:function(a){var c=a.channel;a.funkSpeed&&this.updateFunk(a);switch(a.effect){case 9:a.param&&(a.offset=a.param);c=a.offset<<8;c>=a.length?a.length=2:(a.pointer+=c,a.length-=c);break;case 11:this.trackPos=a.param-1;this.breakPos=0;this.jumpFlag=1;break;case 12:a.volume=a.param;64<a.volume&&(a.volume=64);c.volume=a.volume;break;case 13:this.breakPos=
10*(a.param>>4)+(a.param&15);this.breakPos=63<this.breakPos?0:this.breakPos<<2;this.jumpFlag=1;break;case 14:this.extended(a);break;case 15:if(!a.param)break;32>a.param?this.speed=a.param:this.mixer.samplesTick=2.5*this.sampleRate/a.param>>0;this.tick=0}}},extended:{value:function(a){var c=a.channel,e;e=a.param&15;switch(a.param>>4){case 0:this.mixer.filter.active=e;break;case 1:if(this.tick)break;a.period-=e;113>a.period&&(a.period=113);c.period=a.period;break;case 2:if(this.tick)break;a.period+=
e;856<a.period&&(a.period=856);c.period=a.period;break;case 3:a.glissando=e;break;case 4:a.vibratoWave=e;break;case 5:a.finetune=37*e;break;case 6:if(this.tick)break;e?(a.loopCtr?a.loopCtr--:a.loopCtr=e,a.loopCtr&&(this.breakPos=a.loopPos<<2,this.patternBreak=1)):a.loopPos=this.patternPos>>2;break;case 7:a.tremoloWave=e;break;case 8:c=a.length-2;e=this.mixer.memory;for(a=a.loopPtr;a<c;)e[a]=0.5*(e[a]+e[++a]);e[++a]=0.5*(e[a]+e[0]);break;case 9:if(this.tick||!e||!a.period)break;if(this.tick%e)break;
c.enabled=0;c.pointer=a.pointer;c.length=a.length;c.delay=30;c.enabled=1;c.pointer=a.loopPtr;c.length=a.repeat;c.period=a.period;break;case 10:if(this.tick)break;a.volume+=e;64<a.volume&&(a.volume=64);c.volume=a.volume;break;case 11:if(this.tick)break;a.volume-=e;0>a.volume&&(a.volume=0);c.volume=a.volume;break;case 12:this.tick==e&&(c.volume=a.volume=0);break;case 13:if(this.tick!=e||!a.period)break;c.enabled=0;c.pointer=a.pointer;c.length=a.length;c.delay=30;c.enabled=1;c.pointer=a.loopPtr;c.length=
a.repeat;c.period=a.period;break;case 14:if(this.tick||this.patternDelay)break;this.patternDelay=++e;break;case 15:if(this.tick)break;(a.funkSpeed=e)&&this.updateFunk(a)}}},updateFunk:{value:function(a){var c=a.channel,e,d;a.funkPos+=l[a.funkSpeed];128>a.funkPos||(a.funkPos=0,1==this.version?(e=a.pointer+a.sample.realLen-a.repeat,d=a.funkWave+a.repeat,d>e&&(d=a.loopPtr,c.length=a.repeat),c.pointer=a.funkWave=d):(e=a.loopPtr+a.repeat,d=a.funkWave+1,d>=e&&(d=a.loopPtr),this.mixer.memory[d]=-this.mixer.memory[d]))}}});
g.voices[0]=i(0);g.voices[0].next=g.voices[1]=i(1);g.voices[1].next=g.voices[2]=i(2);g.voices[2].next=g.voices[3]=i(3);g.track=new Uint16Array(128);return Object.seal(g)}})();