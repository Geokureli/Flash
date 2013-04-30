/*
  Flod JS 2.1
  2012/04/30
  Christian Corti
  Neoart Costa Rica

  Last Update: Flod JS 2.1 - 2012/04/13

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
  Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
*/
(function(){function h(e){return Object.create(null,{index:{value:e,writable:!0},next:{value:null,writable:!0},channel:{value:null,writable:!0},sample:{value:null,writable:!0},enabled:{value:0,writable:!0},period:{value:0,writable:!0},last:{value:0,writable:!0},effect:{value:0,writable:!0},param:{value:0,writable:!0},initialize:{value:function(){this.sample=this.channel=null;this.param=this.effect=this.last=this.period=this.enabled=0}}})}var i=[856,808,762,720,678,640,604,570,538,508,480,453,428,
404,381,360,339,320,302,285,269,254,240,226,214,202,190,180,170,160,151,143,135,127,120,113,0,0,0];window.neoart.STPlayer=function(e){e=AmigaPlayer(e);Object.defineProperties(e,{id:{value:"STPlayer"},standard:{value:0,writable:!0},track:{value:null,writable:!0},patterns:{value:[],writable:!0},samples:{value:[],writable:!0},length:{value:0,writable:!0},voices:{value:[],writable:!0},trackPos:{value:0,writable:!0},patternPos:{value:0,writable:!0},jumpFlag:{value:0,writable:!0},force:{set:function(b){1>
b?b=1:4<b&&(b=4);this.version=b}},ntsc:{set:function(b){this.standard=b;this.frequency(b);2>this.version&&(b=(b?20.44952532:20.637767904)*(this.sampleRate/1E3)/120,this.mixer.samplesTick=(240-this.tempo)*b>>0)}},initialize:{value:function(){var b=this.voices[0];this.reset();this.ntsc=this.standard;this.speed=6;for(this.jumpFlag=this.patternPos=this.trackPos=0;b;)b.initialize(),b.channel=this.mixer.channels[b.index],b.sample=this.samples[0],b=b.next}},loader:{value:function(b){var d=0,c,a,e=0,g=0,
f;if(!(1626>b.length)){this.title=b.readString(20);e+=this.isLegal(this.title);this.version=1;b.position=42;for(c=1;16>c;++c)(f=b.readUshort())?(a=AmigaSample(),b.position-=24,a.name=b.readString(22),a.length=f<<1,b.position+=3,a.volume=b.readUbyte(),a.loop=b.readUshort(),a.repeat=b.readUshort()<<1,b.position+=22,a.pointer=g,g+=a.length,this.samples[c]=a,e+=this.isLegal(a.name),9999<a.length&&(this.version=3)):(this.samples[c]=null,b.position+=28);b.position=470;this.length=b.readUbyte();this.tempo=
b.readUbyte();for(c=0;128>c;++c)f=b.readUbyte()<<8,16384<f&&e--,this.track[c]=f,f>d&&(d=f);b.position=600;d+=256;this.patterns.length=d;c=b.length-g-600>>2;d>c&&(d=c);for(c=0;c<d;++c){a=AmigaRow();a.note=b.readUshort();f=b.readUbyte();a.param=b.readUbyte();a.effect=f&15;a.sample=f>>4;this.patterns[c]=a;2<a.effect&&11>a.effect&&e--;a.note&&(113>a.note||856<a.note)&&e--;if(a.sample&&(15<a.sample||!this.samples[a.sample]))15<a.sample&&e--,a.sample=0;if(2<a.effect||!a.effect&&0!=a.param)this.version=
2;if(11==a.effect||13==a.effect)this.version=4}this.mixer.store(b,g);for(c=1;16>c;++c)if(a=this.samples[c]){a.loop?(a.loopPtr=a.pointer+a.loop,a.pointer=a.loopPtr,a.length=a.repeat):(a.loopPtr=this.mixer.memory.length,a.repeat=2);g=a.pointer+4;for(b=a.pointer;b<g;++b)this.mixer.memory[b]=0}a=AmigaSample();a.pointer=a.loopPtr=this.mixer.memory.length;a.length=a.repeat=2;this.samples[0]=a;1>e&&(this.version=0)}}},process:{value:function(){var b,d,c,a=this.voices[0];if(this.tick)for(;a;){if(a.param)if(b=
a.channel,1==this.version)1==a.effect?this.arpeggio(a):2==a.effect&&(c=a.param>>4,a.period=c?a.period+c:a.period-(a.param&15),b.period=a.period);else{switch(a.effect){case 0:this.arpeggio(a);break;case 1:a.last-=a.param&15;113>a.last&&(a.last=113);b.period=a.last;break;case 2:a.last+=a.param&15,856<a.last&&(a.last=856),b.period=a.last}if(2!=(this.version&2)){a=a.next;continue}switch(a.effect){case 12:b.volume=a.param;break;case 13:this.mixer.filter.active=0;break;case 14:this.speed=a.param&15}}a=
a.next}else for(c=this.track[this.trackPos]+this.patternPos;a;){b=a.channel;a.enabled=0;d=this.patterns[c+a.index];a.period=d.note;a.effect=d.effect;a.param=d.param;d.sample?(d=a.sample=this.samples[d.sample],b.volume=2==(this.version&2)&&12==a.effect?a.param:d.volume):d=a.sample;a.period&&(a.enabled=1,b.enabled=0,b.pointer=d.pointer,b.length=d.length,b.period=a.last=a.period);a.enabled&&(b.enabled=1);b.pointer=d.loopPtr;b.length=d.repeat;if(!(4>this.version))switch(a.effect){case 11:this.trackPos=
a.param-1;this.jumpFlag^=1;break;case 12:b.volume=a.param;break;case 13:this.jumpFlag^=1;break;case 14:this.mixer.filter.active=a.param^1;break;case 15:if(!a.param)break;this.speed=a.param&15;this.tick=0}a=a.next}if(++this.tick==this.speed&&(this.tick=0,this.patternPos+=4,256==this.patternPos||this.jumpFlag))this.patternPos=this.jumpFlag=0,++this.trackPos==this.length&&(this.trackPos=0,this.mixer.complete=1)}},arpeggio:{value:function(b){var d=b.channel,c=0,a=this.tick%3;if(a){for(a=1==a?b.param>>
4:b.param&15;b.last!=i[c];)c++;d.period=i[c+a]}else d.period=b.last}},isLegal:{value:function(b){var d,c=0,a=b.length;if(!a)return 0;for(;c<a;++c)if((d=b.charCodeAt(c))&&(32>d||127<d))return 0;return 1}}});e.voices[0]=h(0);e.voices[0].next=e.voices[1]=h(1);e.voices[1].next=e.voices[2]=h(2);e.voices[2].next=e.voices[3]=h(3);e.track=new Uint16Array(128);return Object.seal(e)}})();