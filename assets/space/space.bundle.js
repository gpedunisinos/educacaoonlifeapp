(()=>{var Nu=0,Zl=1,Du=2;var Is=1,Uu=2,Nr=3,Dr=0,Gt=1,Vt=2,Ii=0,Ls=1,fi=2,Jl=3,Kl=4,Fu=5;var Ur=100,Ou=101,Bu=102,zu=103,Gu=104,Vu=200,Hu=201,ku=202,Wu=203,Xu=204,ju=205,qu=206,Yu=207,Zu=208,Ju=209,Ku=210,$u=211,Qu=212,ed=213,td=214,$l=0,Ql=1,ec=2,xo=3,tc=4,ic=5,nc=6,rc=7,id=0,nd=1,rd=2,gi=0,sc=1,ac=2,oc=3,Ns=4,lc=5,cc=6,hc=7;var uc=300,Fr=301,Un=302,yo=303,Mo=304,Ds=306,Aa=1e3,dn=1001,Ca=1002,ti=1003,sd=1004;var Us=1005;var Dt=1006,So=1007;var Fn=1008;var Zt=1009,dc=1010,pc=1011,Or=1012,bo=1013,$i=1014,_i=1015,Li=1016,To=1017,Eo=1018,Br=1020,mc=35902,fc=35899,ad=1021,od=1022,vi=1023,vn=1026,On=1027,gc=1028,wo=1029,Bn=1030,_c=1031;var vc=1033,Ao=33776,Co=33777,Ro=33778,Po=33779,xc=35840,yc=35841,Mc=35842,Sc=35843,bc=36196,Tc=37492,Ec=37496,wc=37488,Ac=37489,Io=37490,Cc=37491,Rc=37808,Pc=37809,Ic=37810,Lc=37811,Nc=37812,Dc=37813,Uc=37814,Fc=37815,Oc=37816,Bc=37817,zc=37818,Gc=37819,Vc=37820,Hc=37821,kc=36492,Wc=36494,Xc=36495,jc=36283,qc=36284,Lo=36285,Yc=36286;var ss=2300,Ra=2301,Ea=2302,Fl=2303,Ol=2400,Bl=2401,zl=2402;var Zc=0,ld=1,zn="",bt="srgb",as="srgb-linear",os="linear",Ze="srgb";var Rn=7680;var cd=512,hd=513,ud=514,No=515,dd=516,pd=517,Do=518,md=519,Pa=35044;var Jc="300 es",Wi=2e3,pr=2001;function Rp(r){return ArrayBuffer.isView(r)&&!(r instanceof DataView)}function mr(r){return document.createElementNS("http://www.w3.org/1999/xhtml",r)}function fd(){let r=mr("canvas");return r.style.display="block",r}var Yh={},fr=null;function ls(...r){let e="THREE."+r.shift();fr?fr("log",e,...r):console.log(e,...r)}function gd(r){let e=r[0];if(typeof e=="string"&&e.startsWith("TSL:")){let t=r[1];t&&t.isStackTrace?r[0]+=" "+t.getLocation():r[1]='Stack trace not available. Enable "THREE.Node.captureStackTrace" to capture stack traces.'}return r}function be(...r){let e="THREE."+(r=gd(r)).shift();if(fr)fr("warn",e,...r);else{let t=r[0];t&&t.isStackTrace?console.warn(t.getError(e)):console.warn(e,...r)}}function we(...r){let e="THREE."+(r=gd(r)).shift();if(fr)fr("error",e,...r);else{let t=r[0];t&&t.isStackTrace?console.error(t.getError(e)):console.error(e,...r)}}function Pn(...r){let e=r.join(" ");e in Yh||(Yh[e]=!0,be(...r))}function _d(r,e,t){return new Promise(function(i,n){setTimeout(function s(){switch(r.clientWaitSync(e,r.SYNC_FLUSH_COMMANDS_BIT,0)){case r.WAIT_FAILED:n();break;case r.TIMEOUT_EXPIRED:setTimeout(s,t);break;default:i()}},t)})}var vd={[$l]:1,[ec]:6,[tc]:7,[xo]:5,[Ql]:0,[nc]:2,[rc]:4,[ic]:3},Ri=class{addEventListener(e,t){this._listeners===void 0&&(this._listeners={});let i=this._listeners;i[e]===void 0&&(i[e]=[]),i[e].indexOf(t)===-1&&i[e].push(t)}hasEventListener(e,t){let i=this._listeners;return i!==void 0&&i[e]!==void 0&&i[e].indexOf(t)!==-1}removeEventListener(e,t){let i=this._listeners;if(i===void 0)return;let n=i[e];if(n!==void 0){let s=n.indexOf(t);s!==-1&&n.splice(s,1)}}dispatchEvent(e){let t=this._listeners;if(t===void 0)return;let i=t[e.type];if(i!==void 0){e.target=this;let n=i.slice(0);for(let s=0,a=n.length;s<a;s++)n[s].call(this,e);e.target=null}}},It=["00","01","02","03","04","05","06","07","08","09","0a","0b","0c","0d","0e","0f","10","11","12","13","14","15","16","17","18","19","1a","1b","1c","1d","1e","1f","20","21","22","23","24","25","26","27","28","29","2a","2b","2c","2d","2e","2f","30","31","32","33","34","35","36","37","38","39","3a","3b","3c","3d","3e","3f","40","41","42","43","44","45","46","47","48","49","4a","4b","4c","4d","4e","4f","50","51","52","53","54","55","56","57","58","59","5a","5b","5c","5d","5e","5f","60","61","62","63","64","65","66","67","68","69","6a","6b","6c","6d","6e","6f","70","71","72","73","74","75","76","77","78","79","7a","7b","7c","7d","7e","7f","80","81","82","83","84","85","86","87","88","89","8a","8b","8c","8d","8e","8f","90","91","92","93","94","95","96","97","98","99","9a","9b","9c","9d","9e","9f","a0","a1","a2","a3","a4","a5","a6","a7","a8","a9","aa","ab","ac","ad","ae","af","b0","b1","b2","b3","b4","b5","b6","b7","b8","b9","ba","bb","bc","bd","be","bf","c0","c1","c2","c3","c4","c5","c6","c7","c8","c9","ca","cb","cc","cd","ce","cf","d0","d1","d2","d3","d4","d5","d6","d7","d8","d9","da","db","dc","dd","de","df","e0","e1","e2","e3","e4","e5","e6","e7","e8","e9","ea","eb","ec","ed","ee","ef","f0","f1","f2","f3","f4","f5","f6","f7","f8","f9","fa","fb","fc","fd","fe","ff"],Zh=1234567,ur=Math.PI/180,gr=180/Math.PI;function Ci(){let r=4294967295*Math.random()|0,e=4294967295*Math.random()|0,t=4294967295*Math.random()|0,i=4294967295*Math.random()|0;return(It[255&r]+It[r>>8&255]+It[r>>16&255]+It[r>>24&255]+"-"+It[255&e]+It[e>>8&255]+"-"+It[e>>16&15|64]+It[e>>24&255]+"-"+It[63&t|128]+It[t>>8&255]+"-"+It[t>>16&255]+It[t>>24&255]+It[255&i]+It[i>>8&255]+It[i>>16&255]+It[i>>24&255]).toLowerCase()}function Ge(r,e,t){return Math.max(e,Math.min(t,r))}function Gl(r,e){return(r%e+e)%e}function is(r,e,t){return(1-t)*r+t*e}function ui(r,e){switch(e.constructor){case Float32Array:return r;case Uint32Array:return r/4294967295;case Uint16Array:return r/65535;case Uint8Array:return r/255;case Int32Array:return Math.max(r/2147483647,-1);case Int16Array:return Math.max(r/32767,-1);case Int8Array:return Math.max(r/127,-1);default:throw new Error("THREE.MathUtils: Invalid component type.")}}function Ke(r,e){switch(e.constructor){case Float32Array:return r;case Uint32Array:return Math.round(4294967295*r);case Uint16Array:return Math.round(65535*r);case Uint8Array:return Math.round(255*r);case Int32Array:return Math.round(2147483647*r);case Int16Array:return Math.round(32767*r);case Int8Array:return Math.round(127*r);default:throw new Error("THREE.MathUtils: Invalid component type.")}}var Kc={DEG2RAD:ur,RAD2DEG:gr,generateUUID:Ci,clamp:Ge,euclideanModulo:Gl,mapLinear:function(r,e,t,i,n){return i+(r-e)*(n-i)/(t-e)},inverseLerp:function(r,e,t){return r!==e?(t-r)/(e-r):0},lerp:is,damp:function(r,e,t,i){return is(r,e,1-Math.exp(-t*i))},pingpong:function(r,e=1){return e-Math.abs(Gl(r,2*e)-e)},smoothstep:function(r,e,t){return r<=e?0:r>=t?1:(r=(r-e)/(t-e))*r*(3-2*r)},smootherstep:function(r,e,t){return r<=e?0:r>=t?1:(r=(r-e)/(t-e))*r*r*(r*(6*r-15)+10)},randInt:function(r,e){return r+Math.floor(Math.random()*(e-r+1))},randFloat:function(r,e){return r+Math.random()*(e-r)},randFloatSpread:function(r){return r*(.5-Math.random())},seededRandom:function(r){r!==void 0&&(Zh=r);let e=Zh+=1831565813;return e=Math.imul(e^e>>>15,1|e),e^=e+Math.imul(e^e>>>7,61|e),((e^e>>>14)>>>0)/4294967296},degToRad:function(r){return r*ur},radToDeg:function(r){return r*gr},isPowerOfTwo:function(r){return!(r&r-1)&&r!==0},ceilPowerOfTwo:function(r){return Math.pow(2,Math.ceil(Math.log(r)/Math.LN2))},floorPowerOfTwo:function(r){return Math.pow(2,Math.floor(Math.log(r)/Math.LN2))},setQuaternionFromProperEuler:function(r,e,t,i,n){let s=Math.cos,a=Math.sin,o=s(t/2),c=a(t/2),l=s((e+i)/2),h=a((e+i)/2),d=s((e-i)/2),p=a((e-i)/2),u=s((i-e)/2),g=a((i-e)/2);switch(n){case"XYX":r.set(o*h,c*d,c*p,o*l);break;case"YZY":r.set(c*p,o*h,c*d,o*l);break;case"ZXZ":r.set(c*d,c*p,o*h,o*l);break;case"XZX":r.set(o*h,c*g,c*u,o*l);break;case"YXY":r.set(c*u,o*h,c*g,o*l);break;case"ZYZ":r.set(c*g,c*u,o*h,o*l);break;default:be("MathUtils: .setQuaternionFromProperEuler() encountered an unknown order: "+n)}},normalize:Ke,denormalize:ui},te=class r{static{r.prototype.isVector2=!0}constructor(e=0,t=0){this.x=e,this.y=t}get width(){return this.x}set width(e){this.x=e}get height(){return this.y}set height(e){this.y=e}set(e,t){return this.x=e,this.y=t,this}setScalar(e){return this.x=e,this.y=e,this}setX(e){return this.x=e,this}setY(e){return this.y=e,this}setComponent(e,t){switch(e){case 0:this.x=t;break;case 1:this.y=t;break;default:throw new Error("THREE.Vector2: index is out of range: "+e)}return this}getComponent(e){switch(e){case 0:return this.x;case 1:return this.y;default:throw new Error("THREE.Vector2: index is out of range: "+e)}}clone(){return new this.constructor(this.x,this.y)}copy(e){return this.x=e.x,this.y=e.y,this}add(e){return this.x+=e.x,this.y+=e.y,this}addScalar(e){return this.x+=e,this.y+=e,this}addVectors(e,t){return this.x=e.x+t.x,this.y=e.y+t.y,this}addScaledVector(e,t){return this.x+=e.x*t,this.y+=e.y*t,this}sub(e){return this.x-=e.x,this.y-=e.y,this}subScalar(e){return this.x-=e,this.y-=e,this}subVectors(e,t){return this.x=e.x-t.x,this.y=e.y-t.y,this}multiply(e){return this.x*=e.x,this.y*=e.y,this}multiplyScalar(e){return this.x*=e,this.y*=e,this}divide(e){return this.x/=e.x,this.y/=e.y,this}divideScalar(e){return this.multiplyScalar(1/e)}applyMatrix3(e){let t=this.x,i=this.y,n=e.elements;return this.x=n[0]*t+n[3]*i+n[6],this.y=n[1]*t+n[4]*i+n[7],this}min(e){return this.x=Math.min(this.x,e.x),this.y=Math.min(this.y,e.y),this}max(e){return this.x=Math.max(this.x,e.x),this.y=Math.max(this.y,e.y),this}clamp(e,t){return this.x=Ge(this.x,e.x,t.x),this.y=Ge(this.y,e.y,t.y),this}clampScalar(e,t){return this.x=Ge(this.x,e,t),this.y=Ge(this.y,e,t),this}clampLength(e,t){let i=this.length();return this.divideScalar(i||1).multiplyScalar(Ge(i,e,t))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this}negate(){return this.x=-this.x,this.y=-this.y,this}dot(e){return this.x*e.x+this.y*e.y}cross(e){return this.x*e.y-this.y*e.x}lengthSq(){return this.x*this.x+this.y*this.y}length(){return Math.sqrt(this.x*this.x+this.y*this.y)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)}normalize(){return this.divideScalar(this.length()||1)}angle(){return Math.atan2(-this.y,-this.x)+Math.PI}angleTo(e){let t=Math.sqrt(this.lengthSq()*e.lengthSq());if(t===0)return Math.PI/2;let i=this.dot(e)/t;return Math.acos(Ge(i,-1,1))}distanceTo(e){return Math.sqrt(this.distanceToSquared(e))}distanceToSquared(e){let t=this.x-e.x,i=this.y-e.y;return t*t+i*i}manhattanDistanceTo(e){return Math.abs(this.x-e.x)+Math.abs(this.y-e.y)}setLength(e){return this.normalize().multiplyScalar(e)}lerp(e,t){return this.x+=(e.x-this.x)*t,this.y+=(e.y-this.y)*t,this}lerpVectors(e,t,i){return this.x=e.x+(t.x-e.x)*i,this.y=e.y+(t.y-e.y)*i,this}equals(e){return e.x===this.x&&e.y===this.y}fromArray(e,t=0){return this.x=e[t],this.y=e[t+1],this}toArray(e=[],t=0){return e[t]=this.x,e[t+1]=this.y,e}fromBufferAttribute(e,t){return this.x=e.getX(t),this.y=e.getY(t),this}rotateAround(e,t){let i=Math.cos(t),n=Math.sin(t),s=this.x-e.x,a=this.y-e.y;return this.x=s*i-a*n+e.x,this.y=s*n+a*i+e.y,this}random(){return this.x=Math.random(),this.y=Math.random(),this}*[Symbol.iterator](){yield this.x,yield this.y}},ii=class{constructor(e=0,t=0,i=0,n=1){this.isQuaternion=!0,this._x=e,this._y=t,this._z=i,this._w=n}static slerpFlat(e,t,i,n,s,a,o){let c=i[n+0],l=i[n+1],h=i[n+2],d=i[n+3],p=s[a+0],u=s[a+1],g=s[a+2],m=s[a+3];if(d!==m||c!==p||l!==u||h!==g){let v=c*p+l*u+h*g+d*m;v<0&&(p=-p,u=-u,g=-g,m=-m,v=-v);let f=1-o;if(v<.9995){let _=Math.acos(v),x=Math.sin(_);f=Math.sin(f*_)/x,c=c*f+p*(o=Math.sin(o*_)/x),l=l*f+u*o,h=h*f+g*o,d=d*f+m*o}else{c=c*f+p*o,l=l*f+u*o,h=h*f+g*o,d=d*f+m*o;let _=1/Math.sqrt(c*c+l*l+h*h+d*d);c*=_,l*=_,h*=_,d*=_}}e[t]=c,e[t+1]=l,e[t+2]=h,e[t+3]=d}static multiplyQuaternionsFlat(e,t,i,n,s,a){let o=i[n],c=i[n+1],l=i[n+2],h=i[n+3],d=s[a],p=s[a+1],u=s[a+2],g=s[a+3];return e[t]=o*g+h*d+c*u-l*p,e[t+1]=c*g+h*p+l*d-o*u,e[t+2]=l*g+h*u+o*p-c*d,e[t+3]=h*g-o*d-c*p-l*u,e}get x(){return this._x}set x(e){this._x=e,this._onChangeCallback()}get y(){return this._y}set y(e){this._y=e,this._onChangeCallback()}get z(){return this._z}set z(e){this._z=e,this._onChangeCallback()}get w(){return this._w}set w(e){this._w=e,this._onChangeCallback()}set(e,t,i,n){return this._x=e,this._y=t,this._z=i,this._w=n,this._onChangeCallback(),this}clone(){return new this.constructor(this._x,this._y,this._z,this._w)}copy(e){return this._x=e.x,this._y=e.y,this._z=e.z,this._w=e.w,this._onChangeCallback(),this}setFromEuler(e,t=!0){let i=e._x,n=e._y,s=e._z,a=e._order,o=Math.cos,c=Math.sin,l=o(i/2),h=o(n/2),d=o(s/2),p=c(i/2),u=c(n/2),g=c(s/2);switch(a){case"XYZ":this._x=p*h*d+l*u*g,this._y=l*u*d-p*h*g,this._z=l*h*g+p*u*d,this._w=l*h*d-p*u*g;break;case"YXZ":this._x=p*h*d+l*u*g,this._y=l*u*d-p*h*g,this._z=l*h*g-p*u*d,this._w=l*h*d+p*u*g;break;case"ZXY":this._x=p*h*d-l*u*g,this._y=l*u*d+p*h*g,this._z=l*h*g+p*u*d,this._w=l*h*d-p*u*g;break;case"ZYX":this._x=p*h*d-l*u*g,this._y=l*u*d+p*h*g,this._z=l*h*g-p*u*d,this._w=l*h*d+p*u*g;break;case"YZX":this._x=p*h*d+l*u*g,this._y=l*u*d+p*h*g,this._z=l*h*g-p*u*d,this._w=l*h*d-p*u*g;break;case"XZY":this._x=p*h*d-l*u*g,this._y=l*u*d-p*h*g,this._z=l*h*g+p*u*d,this._w=l*h*d+p*u*g;break;default:be("Quaternion: .setFromEuler() encountered an unknown order: "+a)}return t===!0&&this._onChangeCallback(),this}setFromAxisAngle(e,t){let i=t/2,n=Math.sin(i);return this._x=e.x*n,this._y=e.y*n,this._z=e.z*n,this._w=Math.cos(i),this._onChangeCallback(),this}setFromRotationMatrix(e){let t=e.elements,i=t[0],n=t[4],s=t[8],a=t[1],o=t[5],c=t[9],l=t[2],h=t[6],d=t[10],p=i+o+d;if(p>0){let u=.5/Math.sqrt(p+1);this._w=.25/u,this._x=(h-c)*u,this._y=(s-l)*u,this._z=(a-n)*u}else if(i>o&&i>d){let u=2*Math.sqrt(1+i-o-d);this._w=(h-c)/u,this._x=.25*u,this._y=(n+a)/u,this._z=(s+l)/u}else if(o>d){let u=2*Math.sqrt(1+o-i-d);this._w=(s-l)/u,this._x=(n+a)/u,this._y=.25*u,this._z=(c+h)/u}else{let u=2*Math.sqrt(1+d-i-o);this._w=(a-n)/u,this._x=(s+l)/u,this._y=(c+h)/u,this._z=.25*u}return this._onChangeCallback(),this}setFromUnitVectors(e,t){let i=e.dot(t)+1;return i<1e-8?(i=0,Math.abs(e.x)>Math.abs(e.z)?(this._x=-e.y,this._y=e.x,this._z=0,this._w=i):(this._x=0,this._y=-e.z,this._z=e.y,this._w=i)):(this._x=e.y*t.z-e.z*t.y,this._y=e.z*t.x-e.x*t.z,this._z=e.x*t.y-e.y*t.x,this._w=i),this.normalize()}angleTo(e){return 2*Math.acos(Math.abs(Ge(this.dot(e),-1,1)))}rotateTowards(e,t){let i=this.angleTo(e);if(i===0)return this;let n=Math.min(1,t/i);return this.slerp(e,n),this}identity(){return this.set(0,0,0,1)}invert(){return this.conjugate()}conjugate(){return this._x*=-1,this._y*=-1,this._z*=-1,this._onChangeCallback(),this}dot(e){return this._x*e._x+this._y*e._y+this._z*e._z+this._w*e._w}lengthSq(){return this._x*this._x+this._y*this._y+this._z*this._z+this._w*this._w}length(){return Math.sqrt(this._x*this._x+this._y*this._y+this._z*this._z+this._w*this._w)}normalize(){let e=this.length();return e===0?(this._x=0,this._y=0,this._z=0,this._w=1):(e=1/e,this._x=this._x*e,this._y=this._y*e,this._z=this._z*e,this._w=this._w*e),this._onChangeCallback(),this}multiply(e){return this.multiplyQuaternions(this,e)}premultiply(e){return this.multiplyQuaternions(e,this)}multiplyQuaternions(e,t){let i=e._x,n=e._y,s=e._z,a=e._w,o=t._x,c=t._y,l=t._z,h=t._w;return this._x=i*h+a*o+n*l-s*c,this._y=n*h+a*c+s*o-i*l,this._z=s*h+a*l+i*c-n*o,this._w=a*h-i*o-n*c-s*l,this._onChangeCallback(),this}slerp(e,t){let i=e._x,n=e._y,s=e._z,a=e._w,o=this.dot(e);o<0&&(i=-i,n=-n,s=-s,a=-a,o=-o);let c=1-t;if(o<.9995){let l=Math.acos(o),h=Math.sin(l);c=Math.sin(c*l)/h,t=Math.sin(t*l)/h,this._x=this._x*c+i*t,this._y=this._y*c+n*t,this._z=this._z*c+s*t,this._w=this._w*c+a*t,this._onChangeCallback()}else this._x=this._x*c+i*t,this._y=this._y*c+n*t,this._z=this._z*c+s*t,this._w=this._w*c+a*t,this.normalize();return this}slerpQuaternions(e,t,i){return this.copy(e).slerp(t,i)}random(){let e=2*Math.PI*Math.random(),t=2*Math.PI*Math.random(),i=Math.random(),n=Math.sqrt(1-i),s=Math.sqrt(i);return this.set(n*Math.sin(e),n*Math.cos(e),s*Math.sin(t),s*Math.cos(t))}equals(e){return e._x===this._x&&e._y===this._y&&e._z===this._z&&e._w===this._w}fromArray(e,t=0){return this._x=e[t],this._y=e[t+1],this._z=e[t+2],this._w=e[t+3],this._onChangeCallback(),this}toArray(e=[],t=0){return e[t]=this._x,e[t+1]=this._y,e[t+2]=this._z,e[t+3]=this._w,e}fromBufferAttribute(e,t){return this._x=e.getX(t),this._y=e.getY(t),this._z=e.getZ(t),this._w=e.getW(t),this._onChangeCallback(),this}toJSON(){return this.toArray()}_onChange(e){return this._onChangeCallback=e,this}_onChangeCallback(){}*[Symbol.iterator](){yield this._x,yield this._y,yield this._z,yield this._w}},w=class r{static{r.prototype.isVector3=!0}constructor(e=0,t=0,i=0){this.x=e,this.y=t,this.z=i}set(e,t,i){return i===void 0&&(i=this.z),this.x=e,this.y=t,this.z=i,this}setScalar(e){return this.x=e,this.y=e,this.z=e,this}setX(e){return this.x=e,this}setY(e){return this.y=e,this}setZ(e){return this.z=e,this}setComponent(e,t){switch(e){case 0:this.x=t;break;case 1:this.y=t;break;case 2:this.z=t;break;default:throw new Error("THREE.Vector3: index is out of range: "+e)}return this}getComponent(e){switch(e){case 0:return this.x;case 1:return this.y;case 2:return this.z;default:throw new Error("THREE.Vector3: index is out of range: "+e)}}clone(){return new this.constructor(this.x,this.y,this.z)}copy(e){return this.x=e.x,this.y=e.y,this.z=e.z,this}add(e){return this.x+=e.x,this.y+=e.y,this.z+=e.z,this}addScalar(e){return this.x+=e,this.y+=e,this.z+=e,this}addVectors(e,t){return this.x=e.x+t.x,this.y=e.y+t.y,this.z=e.z+t.z,this}addScaledVector(e,t){return this.x+=e.x*t,this.y+=e.y*t,this.z+=e.z*t,this}sub(e){return this.x-=e.x,this.y-=e.y,this.z-=e.z,this}subScalar(e){return this.x-=e,this.y-=e,this.z-=e,this}subVectors(e,t){return this.x=e.x-t.x,this.y=e.y-t.y,this.z=e.z-t.z,this}multiply(e){return this.x*=e.x,this.y*=e.y,this.z*=e.z,this}multiplyScalar(e){return this.x*=e,this.y*=e,this.z*=e,this}multiplyVectors(e,t){return this.x=e.x*t.x,this.y=e.y*t.y,this.z=e.z*t.z,this}applyEuler(e){return this.applyQuaternion(Jh.setFromEuler(e))}applyAxisAngle(e,t){return this.applyQuaternion(Jh.setFromAxisAngle(e,t))}applyMatrix3(e){let t=this.x,i=this.y,n=this.z,s=e.elements;return this.x=s[0]*t+s[3]*i+s[6]*n,this.y=s[1]*t+s[4]*i+s[7]*n,this.z=s[2]*t+s[5]*i+s[8]*n,this}applyNormalMatrix(e){return this.applyMatrix3(e).normalize()}applyMatrix4(e){let t=this.x,i=this.y,n=this.z,s=e.elements,a=1/(s[3]*t+s[7]*i+s[11]*n+s[15]);return this.x=(s[0]*t+s[4]*i+s[8]*n+s[12])*a,this.y=(s[1]*t+s[5]*i+s[9]*n+s[13])*a,this.z=(s[2]*t+s[6]*i+s[10]*n+s[14])*a,this}applyQuaternion(e){let t=this.x,i=this.y,n=this.z,s=e.x,a=e.y,o=e.z,c=e.w,l=2*(a*n-o*i),h=2*(o*t-s*n),d=2*(s*i-a*t);return this.x=t+c*l+a*d-o*h,this.y=i+c*h+o*l-s*d,this.z=n+c*d+s*h-a*l,this}project(e){return this.applyMatrix4(e.matrixWorldInverse).applyMatrix4(e.projectionMatrix)}unproject(e){return this.applyMatrix4(e.projectionMatrixInverse).applyMatrix4(e.matrixWorld)}transformDirection(e){let t=this.x,i=this.y,n=this.z,s=e.elements;return this.x=s[0]*t+s[4]*i+s[8]*n,this.y=s[1]*t+s[5]*i+s[9]*n,this.z=s[2]*t+s[6]*i+s[10]*n,this.normalize()}divide(e){return this.x/=e.x,this.y/=e.y,this.z/=e.z,this}divideScalar(e){return this.multiplyScalar(1/e)}min(e){return this.x=Math.min(this.x,e.x),this.y=Math.min(this.y,e.y),this.z=Math.min(this.z,e.z),this}max(e){return this.x=Math.max(this.x,e.x),this.y=Math.max(this.y,e.y),this.z=Math.max(this.z,e.z),this}clamp(e,t){return this.x=Ge(this.x,e.x,t.x),this.y=Ge(this.y,e.y,t.y),this.z=Ge(this.z,e.z,t.z),this}clampScalar(e,t){return this.x=Ge(this.x,e,t),this.y=Ge(this.y,e,t),this.z=Ge(this.z,e,t),this}clampLength(e,t){let i=this.length();return this.divideScalar(i||1).multiplyScalar(Ge(i,e,t))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this.z=Math.floor(this.z),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this.z=Math.ceil(this.z),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this.z=Math.round(this.z),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this.z=Math.trunc(this.z),this}negate(){return this.x=-this.x,this.y=-this.y,this.z=-this.z,this}dot(e){return this.x*e.x+this.y*e.y+this.z*e.z}lengthSq(){return this.x*this.x+this.y*this.y+this.z*this.z}length(){return Math.sqrt(this.x*this.x+this.y*this.y+this.z*this.z)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)+Math.abs(this.z)}normalize(){return this.divideScalar(this.length()||1)}setLength(e){return this.normalize().multiplyScalar(e)}lerp(e,t){return this.x+=(e.x-this.x)*t,this.y+=(e.y-this.y)*t,this.z+=(e.z-this.z)*t,this}lerpVectors(e,t,i){return this.x=e.x+(t.x-e.x)*i,this.y=e.y+(t.y-e.y)*i,this.z=e.z+(t.z-e.z)*i,this}cross(e){return this.crossVectors(this,e)}crossVectors(e,t){let i=e.x,n=e.y,s=e.z,a=t.x,o=t.y,c=t.z;return this.x=n*c-s*o,this.y=s*a-i*c,this.z=i*o-n*a,this}projectOnVector(e){let t=e.lengthSq();if(t===0)return this.set(0,0,0);let i=e.dot(this)/t;return this.copy(e).multiplyScalar(i)}projectOnPlane(e){return ol.copy(this).projectOnVector(e),this.sub(ol)}reflect(e){return this.sub(ol.copy(e).multiplyScalar(2*this.dot(e)))}angleTo(e){let t=Math.sqrt(this.lengthSq()*e.lengthSq());if(t===0)return Math.PI/2;let i=this.dot(e)/t;return Math.acos(Ge(i,-1,1))}distanceTo(e){return Math.sqrt(this.distanceToSquared(e))}distanceToSquared(e){let t=this.x-e.x,i=this.y-e.y,n=this.z-e.z;return t*t+i*i+n*n}manhattanDistanceTo(e){return Math.abs(this.x-e.x)+Math.abs(this.y-e.y)+Math.abs(this.z-e.z)}setFromSpherical(e){return this.setFromSphericalCoords(e.radius,e.phi,e.theta)}setFromSphericalCoords(e,t,i){let n=Math.sin(t)*e;return this.x=n*Math.sin(i),this.y=Math.cos(t)*e,this.z=n*Math.cos(i),this}setFromCylindrical(e){return this.setFromCylindricalCoords(e.radius,e.theta,e.y)}setFromCylindricalCoords(e,t,i){return this.x=e*Math.sin(t),this.y=i,this.z=e*Math.cos(t),this}setFromMatrixPosition(e){let t=e.elements;return this.x=t[12],this.y=t[13],this.z=t[14],this}setFromMatrixScale(e){let t=this.setFromMatrixColumn(e,0).length(),i=this.setFromMatrixColumn(e,1).length(),n=this.setFromMatrixColumn(e,2).length();return this.x=t,this.y=i,this.z=n,this}setFromMatrixColumn(e,t){return this.fromArray(e.elements,4*t)}setFromMatrix3Column(e,t){return this.fromArray(e.elements,3*t)}setFromEuler(e){return this.x=e._x,this.y=e._y,this.z=e._z,this}setFromColor(e){return this.x=e.r,this.y=e.g,this.z=e.b,this}equals(e){return e.x===this.x&&e.y===this.y&&e.z===this.z}fromArray(e,t=0){return this.x=e[t],this.y=e[t+1],this.z=e[t+2],this}toArray(e=[],t=0){return e[t]=this.x,e[t+1]=this.y,e[t+2]=this.z,e}fromBufferAttribute(e,t){return this.x=e.getX(t),this.y=e.getY(t),this.z=e.getZ(t),this}random(){return this.x=Math.random(),this.y=Math.random(),this.z=Math.random(),this}randomDirection(){let e=Math.random()*Math.PI*2,t=2*Math.random()-1,i=Math.sqrt(1-t*t);return this.x=i*Math.cos(e),this.y=t,this.z=i*Math.sin(e),this}*[Symbol.iterator](){yield this.x,yield this.y,yield this.z}},ol=new w,Jh=new ii,Ne=class r{static{r.prototype.isMatrix3=!0}constructor(e,t,i,n,s,a,o,c,l){this.elements=[1,0,0,0,1,0,0,0,1],e!==void 0&&this.set(e,t,i,n,s,a,o,c,l)}set(e,t,i,n,s,a,o,c,l){let h=this.elements;return h[0]=e,h[1]=n,h[2]=o,h[3]=t,h[4]=s,h[5]=c,h[6]=i,h[7]=a,h[8]=l,this}identity(){return this.set(1,0,0,0,1,0,0,0,1),this}copy(e){let t=this.elements,i=e.elements;return t[0]=i[0],t[1]=i[1],t[2]=i[2],t[3]=i[3],t[4]=i[4],t[5]=i[5],t[6]=i[6],t[7]=i[7],t[8]=i[8],this}extractBasis(e,t,i){return e.setFromMatrix3Column(this,0),t.setFromMatrix3Column(this,1),i.setFromMatrix3Column(this,2),this}setFromMatrix4(e){let t=e.elements;return this.set(t[0],t[4],t[8],t[1],t[5],t[9],t[2],t[6],t[10]),this}multiply(e){return this.multiplyMatrices(this,e)}premultiply(e){return this.multiplyMatrices(e,this)}multiplyMatrices(e,t){let i=e.elements,n=t.elements,s=this.elements,a=i[0],o=i[3],c=i[6],l=i[1],h=i[4],d=i[7],p=i[2],u=i[5],g=i[8],m=n[0],v=n[3],f=n[6],_=n[1],x=n[4],S=n[7],T=n[2],M=n[5],P=n[8];return s[0]=a*m+o*_+c*T,s[3]=a*v+o*x+c*M,s[6]=a*f+o*S+c*P,s[1]=l*m+h*_+d*T,s[4]=l*v+h*x+d*M,s[7]=l*f+h*S+d*P,s[2]=p*m+u*_+g*T,s[5]=p*v+u*x+g*M,s[8]=p*f+u*S+g*P,this}multiplyScalar(e){let t=this.elements;return t[0]*=e,t[3]*=e,t[6]*=e,t[1]*=e,t[4]*=e,t[7]*=e,t[2]*=e,t[5]*=e,t[8]*=e,this}determinant(){let e=this.elements,t=e[0],i=e[1],n=e[2],s=e[3],a=e[4],o=e[5],c=e[6],l=e[7],h=e[8];return t*a*h-t*o*l-i*s*h+i*o*c+n*s*l-n*a*c}invert(){let e=this.elements,t=e[0],i=e[1],n=e[2],s=e[3],a=e[4],o=e[5],c=e[6],l=e[7],h=e[8],d=h*a-o*l,p=o*c-h*s,u=l*s-a*c,g=t*d+i*p+n*u;if(g===0)return this.set(0,0,0,0,0,0,0,0,0);let m=1/g;return e[0]=d*m,e[1]=(n*l-h*i)*m,e[2]=(o*i-n*a)*m,e[3]=p*m,e[4]=(h*t-n*c)*m,e[5]=(n*s-o*t)*m,e[6]=u*m,e[7]=(i*c-l*t)*m,e[8]=(a*t-i*s)*m,this}transpose(){let e,t=this.elements;return e=t[1],t[1]=t[3],t[3]=e,e=t[2],t[2]=t[6],t[6]=e,e=t[5],t[5]=t[7],t[7]=e,this}getNormalMatrix(e){return this.setFromMatrix4(e).invert().transpose()}transposeIntoArray(e){let t=this.elements;return e[0]=t[0],e[1]=t[3],e[2]=t[6],e[3]=t[1],e[4]=t[4],e[5]=t[7],e[6]=t[2],e[7]=t[5],e[8]=t[8],this}setUvTransform(e,t,i,n,s,a,o){let c=Math.cos(s),l=Math.sin(s);return this.set(i*c,i*l,-i*(c*a+l*o)+a+e,-n*l,n*c,-n*(-l*a+c*o)+o+t,0,0,1),this}scale(e,t){return Pn("Matrix3: .scale() is deprecated. Use .makeScale() instead."),this.premultiply(ll.makeScale(e,t)),this}rotate(e){return Pn("Matrix3: .rotate() is deprecated. Use .makeRotation() instead."),this.premultiply(ll.makeRotation(-e)),this}translate(e,t){return Pn("Matrix3: .translate() is deprecated. Use .makeTranslation() instead."),this.premultiply(ll.makeTranslation(e,t)),this}makeTranslation(e,t){return e.isVector2?this.set(1,0,e.x,0,1,e.y,0,0,1):this.set(1,0,e,0,1,t,0,0,1),this}makeRotation(e){let t=Math.cos(e),i=Math.sin(e);return this.set(t,-i,0,i,t,0,0,0,1),this}makeScale(e,t){return this.set(e,0,0,0,t,0,0,0,1),this}equals(e){let t=this.elements,i=e.elements;for(let n=0;n<9;n++)if(t[n]!==i[n])return!1;return!0}fromArray(e,t=0){for(let i=0;i<9;i++)this.elements[i]=e[i+t];return this}toArray(e=[],t=0){let i=this.elements;return e[t]=i[0],e[t+1]=i[1],e[t+2]=i[2],e[t+3]=i[3],e[t+4]=i[4],e[t+5]=i[5],e[t+6]=i[6],e[t+7]=i[7],e[t+8]=i[8],e}clone(){return new this.constructor().fromArray(this.elements)}},ll=new Ne,Kh=new Ne().set(.4123908,.3575843,.1804808,.212639,.7151687,.0721923,.0193308,.1191948,.9505322),$h=new Ne().set(3.2409699,-1.5373832,-.4986108,-.9692436,1.8759675,.0415551,.0556301,-.203977,1.0569715);function Pp(){let r={enabled:!0,workingColorSpace:as,spaces:{},convert:function(n,s,a){return this.enabled!==!1&&s!==a&&s&&a&&(this.spaces[s].transfer===Ze&&(n.r=ki(n.r),n.g=ki(n.g),n.b=ki(n.b)),this.spaces[s].primaries!==this.spaces[a].primaries&&(n.applyMatrix3(this.spaces[s].toXYZ),n.applyMatrix3(this.spaces[a].fromXYZ)),this.spaces[a].transfer===Ze&&(n.r=dr(n.r),n.g=dr(n.g),n.b=dr(n.b))),n},workingToColorSpace:function(n,s){return this.convert(n,this.workingColorSpace,s)},colorSpaceToWorking:function(n,s){return this.convert(n,s,this.workingColorSpace)},getPrimaries:function(n){return this.spaces[n].primaries},getTransfer:function(n){return n===""?os:this.spaces[n].transfer},getToneMappingMode:function(n){return this.spaces[n].outputColorSpaceConfig.toneMappingMode||"standard"},getLuminanceCoefficients:function(n,s=this.workingColorSpace){return n.fromArray(this.spaces[s].luminanceCoefficients)},define:function(n){Object.assign(this.spaces,n)},_getMatrix:function(n,s,a){return n.copy(this.spaces[s].toXYZ).multiply(this.spaces[a].fromXYZ)},_getDrawingBufferColorSpace:function(n){return this.spaces[n].outputColorSpaceConfig.drawingBufferColorSpace},_getUnpackColorSpace:function(n=this.workingColorSpace){return this.spaces[n].workingColorSpaceConfig.unpackColorSpace},fromWorkingColorSpace:function(n,s){return Pn("ColorManagement: .fromWorkingColorSpace() has been renamed to .workingToColorSpace()."),r.workingToColorSpace(n,s)},toWorkingColorSpace:function(n,s){return Pn("ColorManagement: .toWorkingColorSpace() has been renamed to .colorSpaceToWorking()."),r.colorSpaceToWorking(n,s)}},e=[.64,.33,.3,.6,.15,.06],t=[.2126,.7152,.0722],i=[.3127,.329];return r.define({[as]:{primaries:e,whitePoint:i,transfer:os,toXYZ:Kh,fromXYZ:$h,luminanceCoefficients:t,workingColorSpaceConfig:{unpackColorSpace:bt},outputColorSpaceConfig:{drawingBufferColorSpace:bt}},[bt]:{primaries:e,whitePoint:i,transfer:Ze,toXYZ:Kh,fromXYZ:$h,luminanceCoefficients:t,outputColorSpaceConfig:{drawingBufferColorSpace:bt}}}),r}var He=Pp();function ki(r){return r<.04045?.0773993808*r:Math.pow(.9478672986*r+.0521327014,2.4)}function dr(r){return r<.0031308?12.92*r:1.055*Math.pow(r,.41666)-.055}var Zn,Ia=class{static getDataURL(e,t="image/png"){if(/^data:/i.test(e.src)||typeof HTMLCanvasElement>"u")return e.src;let i;if(e instanceof HTMLCanvasElement)i=e;else{Zn===void 0&&(Zn=mr("canvas")),Zn.width=e.width,Zn.height=e.height;let n=Zn.getContext("2d");e instanceof ImageData?n.putImageData(e,0,0):n.drawImage(e,0,0,e.width,e.height),i=Zn}return i.toDataURL(t)}static sRGBToLinear(e){if(typeof HTMLImageElement<"u"&&e instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&e instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&e instanceof ImageBitmap){let t=mr("canvas");t.width=e.width,t.height=e.height;let i=t.getContext("2d");i.drawImage(e,0,0,e.width,e.height);let n=i.getImageData(0,0,e.width,e.height),s=n.data;for(let a=0;a<s.length;a++)s[a]=255*ki(s[a]/255);return i.putImageData(n,0,0),t}if(e.data){let t=e.data.slice(0);for(let i=0;i<t.length;i++)t instanceof Uint8Array||t instanceof Uint8ClampedArray?t[i]=Math.floor(255*ki(t[i]/255)):t[i]=ki(t[i]);return{data:t,width:e.width,height:e.height}}return be("ImageUtils.sRGBToLinear(): Unsupported image type. No color space conversion applied."),e}},Ip=0,_r=class{constructor(e=null){this.isSource=!0,Object.defineProperty(this,"id",{value:Ip++}),this.uuid=Ci(),this.data=e,this.dataReady=!0,this.version=0}getSize(e){let t=this.data;return typeof HTMLVideoElement<"u"&&t instanceof HTMLVideoElement?e.set(t.videoWidth,t.videoHeight,0):typeof VideoFrame<"u"&&t instanceof VideoFrame?e.set(t.displayWidth,t.displayHeight,0):t!==null?e.set(t.width,t.height,t.depth||0):e.set(0,0,0),e}set needsUpdate(e){e===!0&&this.version++}toJSON(e){let t=e===void 0||typeof e=="string";if(!t&&e.images[this.uuid]!==void 0)return e.images[this.uuid];let i={uuid:this.uuid,url:""},n=this.data;if(n!==null){let s;if(Array.isArray(n)){s=[];for(let a=0,o=n.length;a<o;a++)n[a].isDataTexture?s.push(cl(n[a].image)):s.push(cl(n[a]))}else s=cl(n);i.url=s}return t||(e.images[this.uuid]=i),i}};function cl(r){return typeof HTMLImageElement<"u"&&r instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&r instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&r instanceof ImageBitmap?Ia.getDataURL(r):r.data?{data:Array.from(r.data),width:r.width,height:r.height,type:r.data.constructor.name}:(be("Texture: Unable to serialize Texture."),{})}var Lp=0,hl=new w,Nt=class r extends Ri{constructor(e=r.DEFAULT_IMAGE,t=r.DEFAULT_MAPPING,i=1001,n=1001,s=1006,a=1008,o=1023,c=1009,l=r.DEFAULT_ANISOTROPY,h=""){super(),this.isTexture=!0,Object.defineProperty(this,"id",{value:Lp++}),this.uuid=Ci(),this.name="",this.source=new _r(e),this.mipmaps=[],this.mapping=t,this.channel=0,this.wrapS=i,this.wrapT=n,this.magFilter=s,this.minFilter=a,this.anisotropy=l,this.format=o,this.internalFormat=null,this.type=c,this.offset=new te(0,0),this.repeat=new te(1,1),this.center=new te(0,0),this.rotation=0,this.matrixAutoUpdate=!0,this.matrix=new Ne,this.generateMipmaps=!0,this.premultiplyAlpha=!1,this.flipY=!0,this.unpackAlignment=4,this.colorSpace=h,this.userData={},this.updateRanges=[],this.version=0,this.onUpdate=null,this.renderTarget=null,this.isRenderTargetTexture=!1,this.isArrayTexture=!!(e&&e.depth&&e.depth>1),this.pmremVersion=0,this.normalized=!1}get width(){return this.source.getSize(hl).x}get height(){return this.source.getSize(hl).y}get depth(){return this.source.getSize(hl).z}get image(){return this.source.data}set image(e){this.source.data=e}updateMatrix(){this.matrix.setUvTransform(this.offset.x,this.offset.y,this.repeat.x,this.repeat.y,this.rotation,this.center.x,this.center.y)}addUpdateRange(e,t){this.updateRanges.push({start:e,count:t})}clearUpdateRanges(){this.updateRanges.length=0}clone(){return new this.constructor().copy(this)}copy(e){return this.name=e.name,this.source=e.source,this.mipmaps=e.mipmaps.slice(0),this.mapping=e.mapping,this.channel=e.channel,this.wrapS=e.wrapS,this.wrapT=e.wrapT,this.magFilter=e.magFilter,this.minFilter=e.minFilter,this.anisotropy=e.anisotropy,this.format=e.format,this.internalFormat=e.internalFormat,this.type=e.type,this.normalized=e.normalized,this.offset.copy(e.offset),this.repeat.copy(e.repeat),this.center.copy(e.center),this.rotation=e.rotation,this.matrixAutoUpdate=e.matrixAutoUpdate,this.matrix.copy(e.matrix),this.generateMipmaps=e.generateMipmaps,this.premultiplyAlpha=e.premultiplyAlpha,this.flipY=e.flipY,this.unpackAlignment=e.unpackAlignment,this.colorSpace=e.colorSpace,this.renderTarget=e.renderTarget,this.isRenderTargetTexture=e.isRenderTargetTexture,this.isArrayTexture=e.isArrayTexture,this.userData=JSON.parse(JSON.stringify(e.userData)),this.needsUpdate=!0,this}setValues(e){for(let t in e){let i=e[t];if(i===void 0){be(`Texture.setValues(): parameter '${t}' has value of undefined.`);continue}let n=this[t];n!==void 0?n&&i&&n.isVector2&&i.isVector2||n&&i&&n.isVector3&&i.isVector3||n&&i&&n.isMatrix3&&i.isMatrix3?n.copy(i):this[t]=i:be(`Texture.setValues(): property '${t}' does not exist.`)}}toJSON(e){let t=e===void 0||typeof e=="string";if(!t&&e.textures[this.uuid]!==void 0)return e.textures[this.uuid];let i={metadata:{version:4.7,type:"Texture",generator:"Texture.toJSON"},uuid:this.uuid,name:this.name,image:this.source.toJSON(e).uuid,mapping:this.mapping,channel:this.channel,repeat:[this.repeat.x,this.repeat.y],offset:[this.offset.x,this.offset.y],center:[this.center.x,this.center.y],rotation:this.rotation,wrap:[this.wrapS,this.wrapT],format:this.format,internalFormat:this.internalFormat,type:this.type,normalized:this.normalized,colorSpace:this.colorSpace,minFilter:this.minFilter,magFilter:this.magFilter,anisotropy:this.anisotropy,flipY:this.flipY,generateMipmaps:this.generateMipmaps,premultiplyAlpha:this.premultiplyAlpha,unpackAlignment:this.unpackAlignment};return Object.keys(this.userData).length>0&&(i.userData=this.userData),t||(e.textures[this.uuid]=i),i}dispose(){this.dispatchEvent({type:"dispose"})}transformUv(e){if(this.mapping!==uc)return e;if(e.applyMatrix3(this.matrix),e.x<0||e.x>1)switch(this.wrapS){case Aa:e.x=e.x-Math.floor(e.x);break;case dn:e.x=e.x<0?0:1;break;case Ca:Math.abs(Math.floor(e.x)%2)===1?e.x=Math.ceil(e.x)-e.x:e.x=e.x-Math.floor(e.x)}if(e.y<0||e.y>1)switch(this.wrapT){case Aa:e.y=e.y-Math.floor(e.y);break;case dn:e.y=e.y<0?0:1;break;case Ca:Math.abs(Math.floor(e.y)%2)===1?e.y=Math.ceil(e.y)-e.y:e.y=e.y-Math.floor(e.y)}return this.flipY&&(e.y=1-e.y),e}set needsUpdate(e){e===!0&&(this.version++,this.source.needsUpdate=!0)}set needsPMREMUpdate(e){e===!0&&this.pmremVersion++}};Nt.DEFAULT_IMAGE=null,Nt.DEFAULT_MAPPING=uc,Nt.DEFAULT_ANISOTROPY=1;var $e=class r{static{r.prototype.isVector4=!0}constructor(e=0,t=0,i=0,n=1){this.x=e,this.y=t,this.z=i,this.w=n}get width(){return this.z}set width(e){this.z=e}get height(){return this.w}set height(e){this.w=e}set(e,t,i,n){return this.x=e,this.y=t,this.z=i,this.w=n,this}setScalar(e){return this.x=e,this.y=e,this.z=e,this.w=e,this}setX(e){return this.x=e,this}setY(e){return this.y=e,this}setZ(e){return this.z=e,this}setW(e){return this.w=e,this}setComponent(e,t){switch(e){case 0:this.x=t;break;case 1:this.y=t;break;case 2:this.z=t;break;case 3:this.w=t;break;default:throw new Error("THREE.Vector4: index is out of range: "+e)}return this}getComponent(e){switch(e){case 0:return this.x;case 1:return this.y;case 2:return this.z;case 3:return this.w;default:throw new Error("THREE.Vector4: index is out of range: "+e)}}clone(){return new this.constructor(this.x,this.y,this.z,this.w)}copy(e){return this.x=e.x,this.y=e.y,this.z=e.z,this.w=e.w!==void 0?e.w:1,this}add(e){return this.x+=e.x,this.y+=e.y,this.z+=e.z,this.w+=e.w,this}addScalar(e){return this.x+=e,this.y+=e,this.z+=e,this.w+=e,this}addVectors(e,t){return this.x=e.x+t.x,this.y=e.y+t.y,this.z=e.z+t.z,this.w=e.w+t.w,this}addScaledVector(e,t){return this.x+=e.x*t,this.y+=e.y*t,this.z+=e.z*t,this.w+=e.w*t,this}sub(e){return this.x-=e.x,this.y-=e.y,this.z-=e.z,this.w-=e.w,this}subScalar(e){return this.x-=e,this.y-=e,this.z-=e,this.w-=e,this}subVectors(e,t){return this.x=e.x-t.x,this.y=e.y-t.y,this.z=e.z-t.z,this.w=e.w-t.w,this}multiply(e){return this.x*=e.x,this.y*=e.y,this.z*=e.z,this.w*=e.w,this}multiplyScalar(e){return this.x*=e,this.y*=e,this.z*=e,this.w*=e,this}applyMatrix4(e){let t=this.x,i=this.y,n=this.z,s=this.w,a=e.elements;return this.x=a[0]*t+a[4]*i+a[8]*n+a[12]*s,this.y=a[1]*t+a[5]*i+a[9]*n+a[13]*s,this.z=a[2]*t+a[6]*i+a[10]*n+a[14]*s,this.w=a[3]*t+a[7]*i+a[11]*n+a[15]*s,this}divide(e){return this.x/=e.x,this.y/=e.y,this.z/=e.z,this.w/=e.w,this}divideScalar(e){return this.multiplyScalar(1/e)}setAxisAngleFromQuaternion(e){this.w=2*Math.acos(e.w);let t=Math.sqrt(1-e.w*e.w);return t<1e-4?(this.x=1,this.y=0,this.z=0):(this.x=e.x/t,this.y=e.y/t,this.z=e.z/t),this}setAxisAngleFromRotationMatrix(e){let t,i,n,s,c=e.elements,l=c[0],h=c[4],d=c[8],p=c[1],u=c[5],g=c[9],m=c[2],v=c[6],f=c[10];if(Math.abs(h-p)<.01&&Math.abs(d-m)<.01&&Math.abs(g-v)<.01){if(Math.abs(h+p)<.1&&Math.abs(d+m)<.1&&Math.abs(g+v)<.1&&Math.abs(l+u+f-3)<.1)return this.set(1,0,0,0),this;t=Math.PI;let x=(l+1)/2,S=(u+1)/2,T=(f+1)/2,M=(h+p)/4,P=(d+m)/4,O=(g+v)/4;return x>S&&x>T?x<.01?(i=0,n=.707106781,s=.707106781):(i=Math.sqrt(x),n=M/i,s=P/i):S>T?S<.01?(i=.707106781,n=0,s=.707106781):(n=Math.sqrt(S),i=M/n,s=O/n):T<.01?(i=.707106781,n=.707106781,s=0):(s=Math.sqrt(T),i=P/s,n=O/s),this.set(i,n,s,t),this}let _=Math.sqrt((v-g)*(v-g)+(d-m)*(d-m)+(p-h)*(p-h));return Math.abs(_)<.001&&(_=1),this.x=(v-g)/_,this.y=(d-m)/_,this.z=(p-h)/_,this.w=Math.acos((l+u+f-1)/2),this}setFromMatrixPosition(e){let t=e.elements;return this.x=t[12],this.y=t[13],this.z=t[14],this.w=t[15],this}min(e){return this.x=Math.min(this.x,e.x),this.y=Math.min(this.y,e.y),this.z=Math.min(this.z,e.z),this.w=Math.min(this.w,e.w),this}max(e){return this.x=Math.max(this.x,e.x),this.y=Math.max(this.y,e.y),this.z=Math.max(this.z,e.z),this.w=Math.max(this.w,e.w),this}clamp(e,t){return this.x=Ge(this.x,e.x,t.x),this.y=Ge(this.y,e.y,t.y),this.z=Ge(this.z,e.z,t.z),this.w=Ge(this.w,e.w,t.w),this}clampScalar(e,t){return this.x=Ge(this.x,e,t),this.y=Ge(this.y,e,t),this.z=Ge(this.z,e,t),this.w=Ge(this.w,e,t),this}clampLength(e,t){let i=this.length();return this.divideScalar(i||1).multiplyScalar(Ge(i,e,t))}floor(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this.z=Math.floor(this.z),this.w=Math.floor(this.w),this}ceil(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this.z=Math.ceil(this.z),this.w=Math.ceil(this.w),this}round(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this.z=Math.round(this.z),this.w=Math.round(this.w),this}roundToZero(){return this.x=Math.trunc(this.x),this.y=Math.trunc(this.y),this.z=Math.trunc(this.z),this.w=Math.trunc(this.w),this}negate(){return this.x=-this.x,this.y=-this.y,this.z=-this.z,this.w=-this.w,this}dot(e){return this.x*e.x+this.y*e.y+this.z*e.z+this.w*e.w}lengthSq(){return this.x*this.x+this.y*this.y+this.z*this.z+this.w*this.w}length(){return Math.sqrt(this.x*this.x+this.y*this.y+this.z*this.z+this.w*this.w)}manhattanLength(){return Math.abs(this.x)+Math.abs(this.y)+Math.abs(this.z)+Math.abs(this.w)}normalize(){return this.divideScalar(this.length()||1)}setLength(e){return this.normalize().multiplyScalar(e)}lerp(e,t){return this.x+=(e.x-this.x)*t,this.y+=(e.y-this.y)*t,this.z+=(e.z-this.z)*t,this.w+=(e.w-this.w)*t,this}lerpVectors(e,t,i){return this.x=e.x+(t.x-e.x)*i,this.y=e.y+(t.y-e.y)*i,this.z=e.z+(t.z-e.z)*i,this.w=e.w+(t.w-e.w)*i,this}equals(e){return e.x===this.x&&e.y===this.y&&e.z===this.z&&e.w===this.w}fromArray(e,t=0){return this.x=e[t],this.y=e[t+1],this.z=e[t+2],this.w=e[t+3],this}toArray(e=[],t=0){return e[t]=this.x,e[t+1]=this.y,e[t+2]=this.z,e[t+3]=this.w,e}fromBufferAttribute(e,t){return this.x=e.getX(t),this.y=e.getY(t),this.z=e.getZ(t),this.w=e.getW(t),this}random(){return this.x=Math.random(),this.y=Math.random(),this.z=Math.random(),this.w=Math.random(),this}*[Symbol.iterator](){yield this.x,yield this.y,yield this.z,yield this.w}},La=class extends Ri{constructor(e=1,t=1,i={}){super(),i=Object.assign({generateMipmaps:!1,internalFormat:null,minFilter:Dt,depthBuffer:!0,stencilBuffer:!1,resolveDepthBuffer:!0,resolveStencilBuffer:!0,depthTexture:null,samples:0,count:1,depth:1,multiview:!1,useArrayDepthTexture:!1},i),this.isRenderTarget=!0,this.width=e,this.height=t,this.depth=i.depth,this.scissor=new $e(0,0,e,t),this.scissorTest=!1,this.viewport=new $e(0,0,e,t),this.textures=[];let n={width:e,height:t,depth:i.depth},s=new Nt(n),a=i.count;for(let o=0;o<a;o++)this.textures[o]=s.clone(),this.textures[o].isRenderTargetTexture=!0,this.textures[o].renderTarget=this;this._setTextureOptions(i),this.depthBuffer=i.depthBuffer,this.stencilBuffer=i.stencilBuffer,this.resolveDepthBuffer=i.resolveDepthBuffer,this.resolveStencilBuffer=i.resolveStencilBuffer,this._depthTexture=null,this.depthTexture=i.depthTexture,this.samples=i.samples,this.multiview=i.multiview,this.useArrayDepthTexture=i.useArrayDepthTexture}_setTextureOptions(e={}){let t={minFilter:Dt,generateMipmaps:!1,flipY:!1,internalFormat:null};e.mapping!==void 0&&(t.mapping=e.mapping),e.wrapS!==void 0&&(t.wrapS=e.wrapS),e.wrapT!==void 0&&(t.wrapT=e.wrapT),e.wrapR!==void 0&&(t.wrapR=e.wrapR),e.magFilter!==void 0&&(t.magFilter=e.magFilter),e.minFilter!==void 0&&(t.minFilter=e.minFilter),e.format!==void 0&&(t.format=e.format),e.type!==void 0&&(t.type=e.type),e.anisotropy!==void 0&&(t.anisotropy=e.anisotropy),e.colorSpace!==void 0&&(t.colorSpace=e.colorSpace),e.flipY!==void 0&&(t.flipY=e.flipY),e.generateMipmaps!==void 0&&(t.generateMipmaps=e.generateMipmaps),e.internalFormat!==void 0&&(t.internalFormat=e.internalFormat);for(let i=0;i<this.textures.length;i++)this.textures[i].setValues(t)}get texture(){return this.textures[0]}set texture(e){this.textures[0]=e}set depthTexture(e){this._depthTexture!==null&&(this._depthTexture.renderTarget=null),e!==null&&(e.renderTarget=this),this._depthTexture=e}get depthTexture(){return this._depthTexture}setSize(e,t,i=1){if(this.width!==e||this.height!==t||this.depth!==i){this.width=e,this.height=t,this.depth=i;for(let n=0,s=this.textures.length;n<s;n++)this.textures[n].image.width=e,this.textures[n].image.height=t,this.textures[n].image.depth=i,this.textures[n].isData3DTexture!==!0&&(this.textures[n].isArrayTexture=this.textures[n].image.depth>1);this.dispose()}this.viewport.set(0,0,e,t),this.scissor.set(0,0,e,t)}clone(){return new this.constructor().copy(this)}copy(e){this.width=e.width,this.height=e.height,this.depth=e.depth,this.scissor.copy(e.scissor),this.scissorTest=e.scissorTest,this.viewport.copy(e.viewport),this.textures.length=0;for(let t=0,i=e.textures.length;t<i;t++){this.textures[t]=e.textures[t].clone(),this.textures[t].isRenderTargetTexture=!0,this.textures[t].renderTarget=this;let n=Object.assign({},e.textures[t].image);this.textures[t].source=new _r(n)}return this.depthBuffer=e.depthBuffer,this.stencilBuffer=e.stencilBuffer,this.resolveDepthBuffer=e.resolveDepthBuffer,this.resolveStencilBuffer=e.resolveStencilBuffer,e.depthTexture!==null&&(this.depthTexture=e.depthTexture.clone()),this.samples=e.samples,this.multiview=e.multiview,this.useArrayDepthTexture=e.useArrayDepthTexture,this}dispose(){this.dispatchEvent({type:"dispose"})}},jt=class extends La{constructor(e=1,t=1,i={}){super(e,t,i),this.isWebGLRenderTarget=!0}},cs=class extends Nt{constructor(e=null,t=1,i=1,n=1){super(null),this.isDataArrayTexture=!0,this.image={data:e,width:t,height:i,depth:n},this.magFilter=ti,this.minFilter=ti,this.wrapR=dn,this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1,this.layerUpdates=new Set}addLayerUpdate(e){this.layerUpdates.add(e)}clearLayerUpdates(){this.layerUpdates.clear()}};var Na=class extends Nt{constructor(e=null,t=1,i=1,n=1){super(null),this.isData3DTexture=!0,this.image={data:e,width:t,height:i,depth:n},this.magFilter=ti,this.minFilter=ti,this.wrapR=dn,this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1}};var Fe=class r{static{r.prototype.isMatrix4=!0}constructor(e,t,i,n,s,a,o,c,l,h,d,p,u,g,m,v){this.elements=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1],e!==void 0&&this.set(e,t,i,n,s,a,o,c,l,h,d,p,u,g,m,v)}set(e,t,i,n,s,a,o,c,l,h,d,p,u,g,m,v){let f=this.elements;return f[0]=e,f[4]=t,f[8]=i,f[12]=n,f[1]=s,f[5]=a,f[9]=o,f[13]=c,f[2]=l,f[6]=h,f[10]=d,f[14]=p,f[3]=u,f[7]=g,f[11]=m,f[15]=v,this}identity(){return this.set(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1),this}clone(){return new r().fromArray(this.elements)}copy(e){let t=this.elements,i=e.elements;return t[0]=i[0],t[1]=i[1],t[2]=i[2],t[3]=i[3],t[4]=i[4],t[5]=i[5],t[6]=i[6],t[7]=i[7],t[8]=i[8],t[9]=i[9],t[10]=i[10],t[11]=i[11],t[12]=i[12],t[13]=i[13],t[14]=i[14],t[15]=i[15],this}copyPosition(e){let t=this.elements,i=e.elements;return t[12]=i[12],t[13]=i[13],t[14]=i[14],this}setFromMatrix3(e){let t=e.elements;return this.set(t[0],t[3],t[6],0,t[1],t[4],t[7],0,t[2],t[5],t[8],0,0,0,0,1),this}extractBasis(e,t,i){return this.determinantAffine()===0?(e.set(1,0,0),t.set(0,1,0),i.set(0,0,1),this):(e.setFromMatrixColumn(this,0),t.setFromMatrixColumn(this,1),i.setFromMatrixColumn(this,2),this)}makeBasis(e,t,i){return this.set(e.x,t.x,i.x,0,e.y,t.y,i.y,0,e.z,t.z,i.z,0,0,0,0,1),this}extractRotation(e){if(e.determinantAffine()===0)return this.identity();let t=this.elements,i=e.elements,n=1/Jn.setFromMatrixColumn(e,0).length(),s=1/Jn.setFromMatrixColumn(e,1).length(),a=1/Jn.setFromMatrixColumn(e,2).length();return t[0]=i[0]*n,t[1]=i[1]*n,t[2]=i[2]*n,t[3]=0,t[4]=i[4]*s,t[5]=i[5]*s,t[6]=i[6]*s,t[7]=0,t[8]=i[8]*a,t[9]=i[9]*a,t[10]=i[10]*a,t[11]=0,t[12]=0,t[13]=0,t[14]=0,t[15]=1,this}makeRotationFromEuler(e){let t=this.elements,i=e.x,n=e.y,s=e.z,a=Math.cos(i),o=Math.sin(i),c=Math.cos(n),l=Math.sin(n),h=Math.cos(s),d=Math.sin(s);if(e.order==="XYZ"){let p=a*h,u=a*d,g=o*h,m=o*d;t[0]=c*h,t[4]=-c*d,t[8]=l,t[1]=u+g*l,t[5]=p-m*l,t[9]=-o*c,t[2]=m-p*l,t[6]=g+u*l,t[10]=a*c}else if(e.order==="YXZ"){let p=c*h,u=c*d,g=l*h,m=l*d;t[0]=p+m*o,t[4]=g*o-u,t[8]=a*l,t[1]=a*d,t[5]=a*h,t[9]=-o,t[2]=u*o-g,t[6]=m+p*o,t[10]=a*c}else if(e.order==="ZXY"){let p=c*h,u=c*d,g=l*h,m=l*d;t[0]=p-m*o,t[4]=-a*d,t[8]=g+u*o,t[1]=u+g*o,t[5]=a*h,t[9]=m-p*o,t[2]=-a*l,t[6]=o,t[10]=a*c}else if(e.order==="ZYX"){let p=a*h,u=a*d,g=o*h,m=o*d;t[0]=c*h,t[4]=g*l-u,t[8]=p*l+m,t[1]=c*d,t[5]=m*l+p,t[9]=u*l-g,t[2]=-l,t[6]=o*c,t[10]=a*c}else if(e.order==="YZX"){let p=a*c,u=a*l,g=o*c,m=o*l;t[0]=c*h,t[4]=m-p*d,t[8]=g*d+u,t[1]=d,t[5]=a*h,t[9]=-o*h,t[2]=-l*h,t[6]=u*d+g,t[10]=p-m*d}else if(e.order==="XZY"){let p=a*c,u=a*l,g=o*c,m=o*l;t[0]=c*h,t[4]=-d,t[8]=l*h,t[1]=p*d+m,t[5]=a*h,t[9]=u*d-g,t[2]=g*d-u,t[6]=o*h,t[10]=m*d+p}return t[3]=0,t[7]=0,t[11]=0,t[12]=0,t[13]=0,t[14]=0,t[15]=1,this}makeRotationFromQuaternion(e){return this.compose(Np,e,Dp)}lookAt(e,t,i){let n=this.elements;return kt.subVectors(e,t),kt.lengthSq()===0&&(kt.z=1),kt.normalize(),rn.crossVectors(i,kt),rn.lengthSq()===0&&(Math.abs(i.z)===1?kt.x+=1e-4:kt.z+=1e-4,kt.normalize(),rn.crossVectors(i,kt)),rn.normalize(),qs.crossVectors(kt,rn),n[0]=rn.x,n[4]=qs.x,n[8]=kt.x,n[1]=rn.y,n[5]=qs.y,n[9]=kt.y,n[2]=rn.z,n[6]=qs.z,n[10]=kt.z,this}multiply(e){return this.multiplyMatrices(this,e)}premultiply(e){return this.multiplyMatrices(e,this)}multiplyMatrices(e,t){let i=e.elements,n=t.elements,s=this.elements,a=i[0],o=i[4],c=i[8],l=i[12],h=i[1],d=i[5],p=i[9],u=i[13],g=i[2],m=i[6],v=i[10],f=i[14],_=i[3],x=i[7],S=i[11],T=i[15],M=n[0],P=n[4],O=n[8],L=n[12],I=n[1],B=n[5],U=n[9],X=n[13],k=n[2],V=n[6],Y=n[10],W=n[14],ne=n[3],pe=n[7],Ee=n[11],_e=n[15];return s[0]=a*M+o*I+c*k+l*ne,s[4]=a*P+o*B+c*V+l*pe,s[8]=a*O+o*U+c*Y+l*Ee,s[12]=a*L+o*X+c*W+l*_e,s[1]=h*M+d*I+p*k+u*ne,s[5]=h*P+d*B+p*V+u*pe,s[9]=h*O+d*U+p*Y+u*Ee,s[13]=h*L+d*X+p*W+u*_e,s[2]=g*M+m*I+v*k+f*ne,s[6]=g*P+m*B+v*V+f*pe,s[10]=g*O+m*U+v*Y+f*Ee,s[14]=g*L+m*X+v*W+f*_e,s[3]=_*M+x*I+S*k+T*ne,s[7]=_*P+x*B+S*V+T*pe,s[11]=_*O+x*U+S*Y+T*Ee,s[15]=_*L+x*X+S*W+T*_e,this}multiplyScalar(e){let t=this.elements;return t[0]*=e,t[4]*=e,t[8]*=e,t[12]*=e,t[1]*=e,t[5]*=e,t[9]*=e,t[13]*=e,t[2]*=e,t[6]*=e,t[10]*=e,t[14]*=e,t[3]*=e,t[7]*=e,t[11]*=e,t[15]*=e,this}determinant(){let e=this.elements,t=e[0],i=e[4],n=e[8],s=e[12],a=e[1],o=e[5],c=e[9],l=e[13],h=e[2],d=e[6],p=e[10],u=e[14],g=e[3],m=e[7],v=e[11],f=e[15],_=c*u-l*p,x=o*u-l*d,S=o*p-c*d,T=a*u-l*h,M=a*p-c*h,P=a*d-o*h;return t*(m*_-v*x+f*S)-i*(g*_-v*T+f*M)+n*(g*x-m*T+f*P)-s*(g*S-m*M+v*P)}determinantAffine(){let e=this.elements,t=e[0],i=e[4],n=e[8],s=e[1],a=e[5],o=e[9],c=e[2],l=e[6],h=e[10];return t*(a*h-o*l)-i*(s*h-o*c)+n*(s*l-a*c)}transpose(){let e=this.elements,t;return t=e[1],e[1]=e[4],e[4]=t,t=e[2],e[2]=e[8],e[8]=t,t=e[6],e[6]=e[9],e[9]=t,t=e[3],e[3]=e[12],e[12]=t,t=e[7],e[7]=e[13],e[13]=t,t=e[11],e[11]=e[14],e[14]=t,this}setPosition(e,t,i){let n=this.elements;return e.isVector3?(n[12]=e.x,n[13]=e.y,n[14]=e.z):(n[12]=e,n[13]=t,n[14]=i),this}invert(){let e=this.elements,t=e[0],i=e[1],n=e[2],s=e[3],a=e[4],o=e[5],c=e[6],l=e[7],h=e[8],d=e[9],p=e[10],u=e[11],g=e[12],m=e[13],v=e[14],f=e[15],_=t*o-i*a,x=t*c-n*a,S=t*l-s*a,T=i*c-n*o,M=i*l-s*o,P=n*l-s*c,O=h*m-d*g,L=h*v-p*g,I=h*f-u*g,B=d*v-p*m,U=d*f-u*m,X=p*f-u*v,k=_*X-x*U+S*B+T*I-M*L+P*O;if(k===0)return this.set(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);let V=1/k;return e[0]=(o*X-c*U+l*B)*V,e[1]=(n*U-i*X-s*B)*V,e[2]=(m*P-v*M+f*T)*V,e[3]=(p*M-d*P-u*T)*V,e[4]=(c*I-a*X-l*L)*V,e[5]=(t*X-n*I+s*L)*V,e[6]=(v*S-g*P-f*x)*V,e[7]=(h*P-p*S+u*x)*V,e[8]=(a*U-o*I+l*O)*V,e[9]=(i*I-t*U-s*O)*V,e[10]=(g*M-m*S+f*_)*V,e[11]=(d*S-h*M-u*_)*V,e[12]=(o*L-a*B-c*O)*V,e[13]=(t*B-i*L+n*O)*V,e[14]=(m*x-g*T-v*_)*V,e[15]=(h*T-d*x+p*_)*V,this}scale(e){let t=this.elements,i=e.x,n=e.y,s=e.z;return t[0]*=i,t[4]*=n,t[8]*=s,t[1]*=i,t[5]*=n,t[9]*=s,t[2]*=i,t[6]*=n,t[10]*=s,t[3]*=i,t[7]*=n,t[11]*=s,this}getMaxScaleOnAxis(){let e=this.elements,t=e[0]*e[0]+e[1]*e[1]+e[2]*e[2],i=e[4]*e[4]+e[5]*e[5]+e[6]*e[6],n=e[8]*e[8]+e[9]*e[9]+e[10]*e[10];return Math.sqrt(Math.max(t,i,n))}makeTranslation(e,t,i){return e.isVector3?this.set(1,0,0,e.x,0,1,0,e.y,0,0,1,e.z,0,0,0,1):this.set(1,0,0,e,0,1,0,t,0,0,1,i,0,0,0,1),this}makeRotationX(e){let t=Math.cos(e),i=Math.sin(e);return this.set(1,0,0,0,0,t,-i,0,0,i,t,0,0,0,0,1),this}makeRotationY(e){let t=Math.cos(e),i=Math.sin(e);return this.set(t,0,i,0,0,1,0,0,-i,0,t,0,0,0,0,1),this}makeRotationZ(e){let t=Math.cos(e),i=Math.sin(e);return this.set(t,-i,0,0,i,t,0,0,0,0,1,0,0,0,0,1),this}makeRotationAxis(e,t){let i=Math.cos(t),n=Math.sin(t),s=1-i,a=e.x,o=e.y,c=e.z,l=s*a,h=s*o;return this.set(l*a+i,l*o-n*c,l*c+n*o,0,l*o+n*c,h*o+i,h*c-n*a,0,l*c-n*o,h*c+n*a,s*c*c+i,0,0,0,0,1),this}makeScale(e,t,i){return this.set(e,0,0,0,0,t,0,0,0,0,i,0,0,0,0,1),this}makeShear(e,t,i,n,s,a){return this.set(1,i,s,0,e,1,a,0,t,n,1,0,0,0,0,1),this}compose(e,t,i){let n=this.elements,s=t._x,a=t._y,o=t._z,c=t._w,l=s+s,h=a+a,d=o+o,p=s*l,u=s*h,g=s*d,m=a*h,v=a*d,f=o*d,_=c*l,x=c*h,S=c*d,T=i.x,M=i.y,P=i.z;return n[0]=(1-(m+f))*T,n[1]=(u+S)*T,n[2]=(g-x)*T,n[3]=0,n[4]=(u-S)*M,n[5]=(1-(p+f))*M,n[6]=(v+_)*M,n[7]=0,n[8]=(g+x)*P,n[9]=(v-_)*P,n[10]=(1-(p+m))*P,n[11]=0,n[12]=e.x,n[13]=e.y,n[14]=e.z,n[15]=1,this}decompose(e,t,i){let n=this.elements;e.x=n[12],e.y=n[13],e.z=n[14];let s=this.determinantAffine();if(s===0)return i.set(1,1,1),t.identity(),this;let a=Jn.set(n[0],n[1],n[2]).length(),o=Jn.set(n[4],n[5],n[6]).length(),c=Jn.set(n[8],n[9],n[10]).length();s<0&&(a=-a),li.copy(this);let l=1/a,h=1/o,d=1/c;return li.elements[0]*=l,li.elements[1]*=l,li.elements[2]*=l,li.elements[4]*=h,li.elements[5]*=h,li.elements[6]*=h,li.elements[8]*=d,li.elements[9]*=d,li.elements[10]*=d,t.setFromRotationMatrix(li),i.x=a,i.y=o,i.z=c,this}makePerspective(e,t,i,n,s,a,o=2e3,c=!1){let l=this.elements,h=2*s/(t-e),d=2*s/(i-n),p=(t+e)/(t-e),u=(i+n)/(i-n),g,m;if(c)g=s/(a-s),m=a*s/(a-s);else if(o===Wi)g=-(a+s)/(a-s),m=-2*a*s/(a-s);else{if(o!==pr)throw new Error("THREE.Matrix4.makePerspective(): Invalid coordinate system: "+o);g=-a/(a-s),m=-a*s/(a-s)}return l[0]=h,l[4]=0,l[8]=p,l[12]=0,l[1]=0,l[5]=d,l[9]=u,l[13]=0,l[2]=0,l[6]=0,l[10]=g,l[14]=m,l[3]=0,l[7]=0,l[11]=-1,l[15]=0,this}makeOrthographic(e,t,i,n,s,a,o=2e3,c=!1){let l=this.elements,h=2/(t-e),d=2/(i-n),p=-(t+e)/(t-e),u=-(i+n)/(i-n),g,m;if(c)g=1/(a-s),m=a/(a-s);else if(o===Wi)g=-2/(a-s),m=-(a+s)/(a-s);else{if(o!==pr)throw new Error("THREE.Matrix4.makeOrthographic(): Invalid coordinate system: "+o);g=-1/(a-s),m=-s/(a-s)}return l[0]=h,l[4]=0,l[8]=0,l[12]=p,l[1]=0,l[5]=d,l[9]=0,l[13]=u,l[2]=0,l[6]=0,l[10]=g,l[14]=m,l[3]=0,l[7]=0,l[11]=0,l[15]=1,this}equals(e){let t=this.elements,i=e.elements;for(let n=0;n<16;n++)if(t[n]!==i[n])return!1;return!0}fromArray(e,t=0){for(let i=0;i<16;i++)this.elements[i]=e[i+t];return this}toArray(e=[],t=0){let i=this.elements;return e[t]=i[0],e[t+1]=i[1],e[t+2]=i[2],e[t+3]=i[3],e[t+4]=i[4],e[t+5]=i[5],e[t+6]=i[6],e[t+7]=i[7],e[t+8]=i[8],e[t+9]=i[9],e[t+10]=i[10],e[t+11]=i[11],e[t+12]=i[12],e[t+13]=i[13],e[t+14]=i[14],e[t+15]=i[15],e}},Jn=new w,li=new Fe,Np=new w(0,0,0),Dp=new w(1,1,1),rn=new w,qs=new w,kt=new w,Qh=new Fe,eu=new ii,Xi=class r{constructor(e=0,t=0,i=0,n=r.DEFAULT_ORDER){this.isEuler=!0,this._x=e,this._y=t,this._z=i,this._order=n}get x(){return this._x}set x(e){this._x=e,this._onChangeCallback()}get y(){return this._y}set y(e){this._y=e,this._onChangeCallback()}get z(){return this._z}set z(e){this._z=e,this._onChangeCallback()}get order(){return this._order}set order(e){this._order=e,this._onChangeCallback()}set(e,t,i,n=this._order){return this._x=e,this._y=t,this._z=i,this._order=n,this._onChangeCallback(),this}clone(){return new this.constructor(this._x,this._y,this._z,this._order)}copy(e){return this._x=e._x,this._y=e._y,this._z=e._z,this._order=e._order,this._onChangeCallback(),this}setFromRotationMatrix(e,t=this._order,i=!0){let n=e.elements,s=n[0],a=n[4],o=n[8],c=n[1],l=n[5],h=n[9],d=n[2],p=n[6],u=n[10];switch(t){case"XYZ":this._y=Math.asin(Ge(o,-1,1)),Math.abs(o)<.9999999?(this._x=Math.atan2(-h,u),this._z=Math.atan2(-a,s)):(this._x=Math.atan2(p,l),this._z=0);break;case"YXZ":this._x=Math.asin(-Ge(h,-1,1)),Math.abs(h)<.9999999?(this._y=Math.atan2(o,u),this._z=Math.atan2(c,l)):(this._y=Math.atan2(-d,s),this._z=0);break;case"ZXY":this._x=Math.asin(Ge(p,-1,1)),Math.abs(p)<.9999999?(this._y=Math.atan2(-d,u),this._z=Math.atan2(-a,l)):(this._y=0,this._z=Math.atan2(c,s));break;case"ZYX":this._y=Math.asin(-Ge(d,-1,1)),Math.abs(d)<.9999999?(this._x=Math.atan2(p,u),this._z=Math.atan2(c,s)):(this._x=0,this._z=Math.atan2(-a,l));break;case"YZX":this._z=Math.asin(Ge(c,-1,1)),Math.abs(c)<.9999999?(this._x=Math.atan2(-h,l),this._y=Math.atan2(-d,s)):(this._x=0,this._y=Math.atan2(o,u));break;case"XZY":this._z=Math.asin(-Ge(a,-1,1)),Math.abs(a)<.9999999?(this._x=Math.atan2(p,l),this._y=Math.atan2(o,s)):(this._x=Math.atan2(-h,u),this._y=0);break;default:be("Euler: .setFromRotationMatrix() encountered an unknown order: "+t)}return this._order=t,i===!0&&this._onChangeCallback(),this}setFromQuaternion(e,t,i){return Qh.makeRotationFromQuaternion(e),this.setFromRotationMatrix(Qh,t,i)}setFromVector3(e,t=this._order){return this.set(e.x,e.y,e.z,t)}reorder(e){return eu.setFromEuler(this),this.setFromQuaternion(eu,e)}equals(e){return e._x===this._x&&e._y===this._y&&e._z===this._z&&e._order===this._order}fromArray(e){return this._x=e[0],this._y=e[1],this._z=e[2],e[3]!==void 0&&(this._order=e[3]),this._onChangeCallback(),this}toArray(e=[],t=0){return e[t]=this._x,e[t+1]=this._y,e[t+2]=this._z,e[t+3]=this._order,e}_onChange(e){return this._onChangeCallback=e,this}_onChangeCallback(){}*[Symbol.iterator](){yield this._x,yield this._y,yield this._z,yield this._order}};Xi.DEFAULT_ORDER="XYZ";var hs=class{constructor(){this.mask=1}set(e){this.mask=1<<e>>>0}enable(e){this.mask|=1<<e}enableAll(){this.mask=-1}toggle(e){this.mask^=1<<e}disable(e){this.mask&=~(1<<e)}disableAll(){this.mask=0}test(e){return(this.mask&e.mask)!==0}isEnabled(e){return!!(this.mask&1<<e)}},Up=0,tu=new w,Kn=new ii,Bi=new Fe,Ys=new w,qr=new w,Fp=new w,Op=new ii,iu=new w(1,0,0),nu=new w(0,1,0),ru=new w(0,0,1),su={type:"added"},Bp={type:"removed"},$n={type:"childadded",child:null},ul={type:"childremoved",child:null},Tt=class r extends Ri{constructor(){super(),this.isObject3D=!0,Object.defineProperty(this,"id",{value:Up++}),this.uuid=Ci(),this.name="",this.type="Object3D",this.parent=null,this.children=[],this.up=r.DEFAULT_UP.clone();let e=new w,t=new Xi,i=new ii,n=new w(1,1,1);t._onChange(function(){i.setFromEuler(t,!1)}),i._onChange(function(){t.setFromQuaternion(i,void 0,!1)}),Object.defineProperties(this,{position:{configurable:!0,enumerable:!0,value:e},rotation:{configurable:!0,enumerable:!0,value:t},quaternion:{configurable:!0,enumerable:!0,value:i},scale:{configurable:!0,enumerable:!0,value:n},modelViewMatrix:{value:new Fe},normalMatrix:{value:new Ne}}),this.matrix=new Fe,this.matrixWorld=new Fe,this.matrixAutoUpdate=r.DEFAULT_MATRIX_AUTO_UPDATE,this.matrixWorldAutoUpdate=r.DEFAULT_MATRIX_WORLD_AUTO_UPDATE,this.matrixWorldNeedsUpdate=!1,this.layers=new hs,this.visible=!0,this.castShadow=!1,this.receiveShadow=!1,this.frustumCulled=!0,this.renderOrder=0,this.animations=[],this.customDepthMaterial=void 0,this.customDistanceMaterial=void 0,this.static=!1,this.userData={},this.pivot=null}onBeforeShadow(){}onAfterShadow(){}onBeforeRender(){}onAfterRender(){}applyMatrix4(e){this.matrixAutoUpdate&&this.updateMatrix(),this.matrix.premultiply(e),this.matrix.decompose(this.position,this.quaternion,this.scale)}applyQuaternion(e){return this.quaternion.premultiply(e),this}setRotationFromAxisAngle(e,t){this.quaternion.setFromAxisAngle(e,t)}setRotationFromEuler(e){this.quaternion.setFromEuler(e,!0)}setRotationFromMatrix(e){this.quaternion.setFromRotationMatrix(e)}setRotationFromQuaternion(e){this.quaternion.copy(e)}rotateOnAxis(e,t){return Kn.setFromAxisAngle(e,t),this.quaternion.multiply(Kn),this}rotateOnWorldAxis(e,t){return Kn.setFromAxisAngle(e,t),this.quaternion.premultiply(Kn),this}rotateX(e){return this.rotateOnAxis(iu,e)}rotateY(e){return this.rotateOnAxis(nu,e)}rotateZ(e){return this.rotateOnAxis(ru,e)}translateOnAxis(e,t){return tu.copy(e).applyQuaternion(this.quaternion),this.position.add(tu.multiplyScalar(t)),this}translateX(e){return this.translateOnAxis(iu,e)}translateY(e){return this.translateOnAxis(nu,e)}translateZ(e){return this.translateOnAxis(ru,e)}localToWorld(e){return this.updateWorldMatrix(!0,!1),e.applyMatrix4(this.matrixWorld)}worldToLocal(e){return this.updateWorldMatrix(!0,!1),e.applyMatrix4(Bi.copy(this.matrixWorld).invert())}lookAt(e,t,i){e.isVector3?Ys.copy(e):Ys.set(e,t,i);let n=this.parent;this.updateWorldMatrix(!0,!1),qr.setFromMatrixPosition(this.matrixWorld),this.isCamera||this.isLight?Bi.lookAt(qr,Ys,this.up):Bi.lookAt(Ys,qr,this.up),this.quaternion.setFromRotationMatrix(Bi),n&&(Bi.extractRotation(n.matrixWorld),Kn.setFromRotationMatrix(Bi),this.quaternion.premultiply(Kn.invert()))}add(e){if(arguments.length>1){for(let t=0;t<arguments.length;t++)this.add(arguments[t]);return this}return e===this?(we("Object3D.add: object can't be added as a child of itself.",e),this):(e&&e.isObject3D?(e.removeFromParent(),e.parent=this,this.children.push(e),e.dispatchEvent(su),$n.child=e,this.dispatchEvent($n),$n.child=null):we("Object3D.add: object not an instance of THREE.Object3D.",e),this)}remove(e){if(arguments.length>1){for(let i=0;i<arguments.length;i++)this.remove(arguments[i]);return this}let t=this.children.indexOf(e);return t!==-1&&(e.parent=null,this.children.splice(t,1),e.dispatchEvent(Bp),ul.child=e,this.dispatchEvent(ul),ul.child=null),this}removeFromParent(){let e=this.parent;return e!==null&&e.remove(this),this}clear(){return this.remove(...this.children)}attach(e){return this.updateWorldMatrix(!0,!1),Bi.copy(this.matrixWorld).invert(),e.parent!==null&&(e.parent.updateWorldMatrix(!0,!1),Bi.multiply(e.parent.matrixWorld)),e.applyMatrix4(Bi),e.removeFromParent(),e.parent=this,this.children.push(e),e.updateWorldMatrix(!1,!0),e.dispatchEvent(su),$n.child=e,this.dispatchEvent($n),$n.child=null,this}getObjectById(e){return this.getObjectByProperty("id",e)}getObjectByName(e){return this.getObjectByProperty("name",e)}getObjectByProperty(e,t){if(this[e]===t)return this;for(let i=0,n=this.children.length;i<n;i++){let s=this.children[i].getObjectByProperty(e,t);if(s!==void 0)return s}}getObjectsByProperty(e,t,i=[]){this[e]===t&&i.push(this);let n=this.children;for(let s=0,a=n.length;s<a;s++)n[s].getObjectsByProperty(e,t,i);return i}getWorldPosition(e){return this.updateWorldMatrix(!0,!1),e.setFromMatrixPosition(this.matrixWorld)}getWorldQuaternion(e){return this.updateWorldMatrix(!0,!1),this.matrixWorld.decompose(qr,e,Fp),e}getWorldScale(e){return this.updateWorldMatrix(!0,!1),this.matrixWorld.decompose(qr,Op,e),e}getWorldDirection(e){this.updateWorldMatrix(!0,!1);let t=this.matrixWorld.elements;return e.set(t[8],t[9],t[10]).normalize()}raycast(){}traverse(e){e(this);let t=this.children;for(let i=0,n=t.length;i<n;i++)t[i].traverse(e)}traverseVisible(e){if(this.visible===!1)return;e(this);let t=this.children;for(let i=0,n=t.length;i<n;i++)t[i].traverseVisible(e)}traverseAncestors(e){let t=this.parent;t!==null&&(e(t),t.traverseAncestors(e))}updateMatrix(){this.matrix.compose(this.position,this.quaternion,this.scale);let e=this.pivot;if(e!==null){let t=e.x,i=e.y,n=e.z,s=this.matrix.elements;s[12]+=t-s[0]*t-s[4]*i-s[8]*n,s[13]+=i-s[1]*t-s[5]*i-s[9]*n,s[14]+=n-s[2]*t-s[6]*i-s[10]*n}this.matrixWorldNeedsUpdate=!0}updateMatrixWorld(e){this.matrixAutoUpdate&&this.updateMatrix(),(this.matrixWorldNeedsUpdate||e)&&(this.matrixWorldAutoUpdate===!0&&(this.parent===null?this.matrixWorld.copy(this.matrix):this.matrixWorld.multiplyMatrices(this.parent.matrixWorld,this.matrix)),this.matrixWorldNeedsUpdate=!1,e=!0);let t=this.children;for(let i=0,n=t.length;i<n;i++)t[i].updateMatrixWorld(e)}updateWorldMatrix(e,t,i=!1){let n=this.parent;if(e===!0&&n!==null&&n.updateWorldMatrix(!0,!1),this.matrixAutoUpdate&&this.updateMatrix(),(this.matrixWorldNeedsUpdate||i)&&(this.matrixWorldAutoUpdate===!0&&(this.parent===null?this.matrixWorld.copy(this.matrix):this.matrixWorld.multiplyMatrices(this.parent.matrixWorld,this.matrix)),this.matrixWorldNeedsUpdate=!1,i=!0),t===!0){let s=this.children;for(let a=0,o=s.length;a<o;a++)s[a].updateWorldMatrix(!1,!0,i)}}toJSON(e){let t=e===void 0||typeof e=="string",i={};t&&(e={geometries:{},materials:{},textures:{},images:{},shapes:{},skeletons:{},animations:{},nodes:{}},i.metadata={version:4.7,type:"Object",generator:"Object3D.toJSON"});let n={};function s(o,c){return o[c.uuid]===void 0&&(o[c.uuid]=c.toJSON(e)),c.uuid}if(n.uuid=this.uuid,n.type=this.type,this.name!==""&&(n.name=this.name),this.castShadow===!0&&(n.castShadow=!0),this.receiveShadow===!0&&(n.receiveShadow=!0),this.visible===!1&&(n.visible=!1),this.frustumCulled===!1&&(n.frustumCulled=!1),this.renderOrder!==0&&(n.renderOrder=this.renderOrder),this.static!==!1&&(n.static=this.static),Object.keys(this.userData).length>0&&(n.userData=this.userData),n.layers=this.layers.mask,n.matrix=this.matrix.toArray(),n.up=this.up.toArray(),this.pivot!==null&&(n.pivot=this.pivot.toArray()),this.matrixAutoUpdate===!1&&(n.matrixAutoUpdate=!1),this.morphTargetDictionary!==void 0&&(n.morphTargetDictionary=Object.assign({},this.morphTargetDictionary)),this.morphTargetInfluences!==void 0&&(n.morphTargetInfluences=this.morphTargetInfluences.slice()),this.isInstancedMesh&&(n.type="InstancedMesh",n.count=this.count,n.instanceMatrix=this.instanceMatrix.toJSON(),this.instanceColor!==null&&(n.instanceColor=this.instanceColor.toJSON())),this.isBatchedMesh&&(n.type="BatchedMesh",n.perObjectFrustumCulled=this.perObjectFrustumCulled,n.sortObjects=this.sortObjects,n.drawRanges=this._drawRanges,n.reservedRanges=this._reservedRanges,n.geometryInfo=this._geometryInfo.map(o=>({...o,boundingBox:o.boundingBox?o.boundingBox.toJSON():void 0,boundingSphere:o.boundingSphere?o.boundingSphere.toJSON():void 0})),n.instanceInfo=this._instanceInfo.map(o=>({...o})),n.availableInstanceIds=this._availableInstanceIds.slice(),n.availableGeometryIds=this._availableGeometryIds.slice(),n.nextIndexStart=this._nextIndexStart,n.nextVertexStart=this._nextVertexStart,n.geometryCount=this._geometryCount,n.maxInstanceCount=this._maxInstanceCount,n.maxVertexCount=this._maxVertexCount,n.maxIndexCount=this._maxIndexCount,n.geometryInitialized=this._geometryInitialized,n.matricesTexture=this._matricesTexture.toJSON(e),n.indirectTexture=this._indirectTexture.toJSON(e),this._colorsTexture!==null&&(n.colorsTexture=this._colorsTexture.toJSON(e)),this.boundingSphere!==null&&(n.boundingSphere=this.boundingSphere.toJSON()),this.boundingBox!==null&&(n.boundingBox=this.boundingBox.toJSON())),this.isScene)this.background&&(this.background.isColor?n.background=this.background.toJSON():this.background.isTexture&&(n.background=this.background.toJSON(e).uuid)),this.environment&&this.environment.isTexture&&this.environment.isRenderTargetTexture!==!0&&(n.environment=this.environment.toJSON(e).uuid);else if(this.isMesh||this.isLine||this.isPoints){n.geometry=s(e.geometries,this.geometry);let o=this.geometry.parameters;if(o!==void 0&&o.shapes!==void 0){let c=o.shapes;if(Array.isArray(c))for(let l=0,h=c.length;l<h;l++){let d=c[l];s(e.shapes,d)}else s(e.shapes,c)}}if(this.isSkinnedMesh&&(n.bindMode=this.bindMode,n.bindMatrix=this.bindMatrix.toArray(),this.skeleton!==void 0&&(s(e.skeletons,this.skeleton),n.skeleton=this.skeleton.uuid)),this.material!==void 0)if(Array.isArray(this.material)){let o=[];for(let c=0,l=this.material.length;c<l;c++)o.push(s(e.materials,this.material[c]));n.material=o}else n.material=s(e.materials,this.material);if(this.children.length>0){n.children=[];for(let o=0;o<this.children.length;o++)n.children.push(this.children[o].toJSON(e).object)}if(this.animations.length>0){n.animations=[];for(let o=0;o<this.animations.length;o++){let c=this.animations[o];n.animations.push(s(e.animations,c))}}if(t){let o=a(e.geometries),c=a(e.materials),l=a(e.textures),h=a(e.images),d=a(e.shapes),p=a(e.skeletons),u=a(e.animations),g=a(e.nodes);o.length>0&&(i.geometries=o),c.length>0&&(i.materials=c),l.length>0&&(i.textures=l),h.length>0&&(i.images=h),d.length>0&&(i.shapes=d),p.length>0&&(i.skeletons=p),u.length>0&&(i.animations=u),g.length>0&&(i.nodes=g)}return i.object=n,i;function a(o){let c=[];for(let l in o){let h=o[l];delete h.metadata,c.push(h)}return c}}clone(e){return new this.constructor().copy(this,e)}copy(e,t=!0){if(this.name=e.name,this.up.copy(e.up),this.position.copy(e.position),this.rotation.order=e.rotation.order,this.quaternion.copy(e.quaternion),this.scale.copy(e.scale),this.pivot=e.pivot!==null?e.pivot.clone():null,this.matrix.copy(e.matrix),this.matrixWorld.copy(e.matrixWorld),this.matrixAutoUpdate=e.matrixAutoUpdate,this.matrixWorldAutoUpdate=e.matrixWorldAutoUpdate,this.matrixWorldNeedsUpdate=e.matrixWorldNeedsUpdate,this.layers.mask=e.layers.mask,this.visible=e.visible,this.castShadow=e.castShadow,this.receiveShadow=e.receiveShadow,this.frustumCulled=e.frustumCulled,this.renderOrder=e.renderOrder,this.static=e.static,this.animations=e.animations.slice(),this.userData=JSON.parse(JSON.stringify(e.userData)),t===!0)for(let i=0;i<e.children.length;i++){let n=e.children[i];this.add(n.clone())}return this}};Tt.DEFAULT_UP=new w(0,1,0),Tt.DEFAULT_MATRIX_AUTO_UPDATE=!0,Tt.DEFAULT_MATRIX_WORLD_AUTO_UPDATE=!0;var mt=class extends Tt{constructor(){super(),this.isGroup=!0,this.type="Group"}},zp={type:"move"},vr=class{constructor(){this._targetRay=null,this._grip=null,this._hand=null}getHandSpace(){return this._hand===null&&(this._hand=new mt,this._hand.matrixAutoUpdate=!1,this._hand.visible=!1,this._hand.joints={},this._hand.inputState={pinching:!1}),this._hand}getTargetRaySpace(){return this._targetRay===null&&(this._targetRay=new mt,this._targetRay.matrixAutoUpdate=!1,this._targetRay.visible=!1,this._targetRay.hasLinearVelocity=!1,this._targetRay.linearVelocity=new w,this._targetRay.hasAngularVelocity=!1,this._targetRay.angularVelocity=new w),this._targetRay}getGripSpace(){return this._grip===null&&(this._grip=new mt,this._grip.matrixAutoUpdate=!1,this._grip.visible=!1,this._grip.hasLinearVelocity=!1,this._grip.linearVelocity=new w,this._grip.hasAngularVelocity=!1,this._grip.angularVelocity=new w,this._grip.eventsEnabled=!1),this._grip}dispatchEvent(e){return this._targetRay!==null&&this._targetRay.dispatchEvent(e),this._grip!==null&&this._grip.dispatchEvent(e),this._hand!==null&&this._hand.dispatchEvent(e),this}connect(e){if(e&&e.hand){let t=this._hand;if(t)for(let i of e.hand.values())this._getHandJoint(t,i)}return this.dispatchEvent({type:"connected",data:e}),this}disconnect(e){return this.dispatchEvent({type:"disconnected",data:e}),this._targetRay!==null&&(this._targetRay.visible=!1),this._grip!==null&&(this._grip.visible=!1),this._hand!==null&&(this._hand.visible=!1),this}update(e,t,i){let n=null,s=null,a=null,o=this._targetRay,c=this._grip,l=this._hand;if(e&&t.session.visibilityState!=="visible-blurred"){if(l&&e.hand){a=!0;for(let m of e.hand.values()){let v=t.getJointPose(m,i),f=this._getHandJoint(l,m);v!==null&&(f.matrix.fromArray(v.transform.matrix),f.matrix.decompose(f.position,f.rotation,f.scale),f.matrixWorldNeedsUpdate=!0,f.jointRadius=v.radius),f.visible=v!==null}let h=l.joints["index-finger-tip"],d=l.joints["thumb-tip"],p=h.position.distanceTo(d.position),u=.02,g=.005;l.inputState.pinching&&p>u+g?(l.inputState.pinching=!1,this.dispatchEvent({type:"pinchend",handedness:e.handedness,target:this})):!l.inputState.pinching&&p<=u-g&&(l.inputState.pinching=!0,this.dispatchEvent({type:"pinchstart",handedness:e.handedness,target:this}))}else c!==null&&e.gripSpace&&(s=t.getPose(e.gripSpace,i),s!==null&&(c.matrix.fromArray(s.transform.matrix),c.matrix.decompose(c.position,c.rotation,c.scale),c.matrixWorldNeedsUpdate=!0,s.linearVelocity?(c.hasLinearVelocity=!0,c.linearVelocity.copy(s.linearVelocity)):c.hasLinearVelocity=!1,s.angularVelocity?(c.hasAngularVelocity=!0,c.angularVelocity.copy(s.angularVelocity)):c.hasAngularVelocity=!1,c.eventsEnabled&&c.dispatchEvent({type:"gripUpdated",data:e,target:this})));o!==null&&(n=t.getPose(e.targetRaySpace,i),n===null&&s!==null&&(n=s),n!==null&&(o.matrix.fromArray(n.transform.matrix),o.matrix.decompose(o.position,o.rotation,o.scale),o.matrixWorldNeedsUpdate=!0,n.linearVelocity?(o.hasLinearVelocity=!0,o.linearVelocity.copy(n.linearVelocity)):o.hasLinearVelocity=!1,n.angularVelocity?(o.hasAngularVelocity=!0,o.angularVelocity.copy(n.angularVelocity)):o.hasAngularVelocity=!1,this.dispatchEvent(zp)))}return o!==null&&(o.visible=n!==null),c!==null&&(c.visible=s!==null),l!==null&&(l.visible=a!==null),this}_getHandJoint(e,t){if(e.joints[t.jointName]===void 0){let i=new mt;i.matrixAutoUpdate=!1,i.visible=!1,e.joints[t.jointName]=i,e.add(i)}return e.joints[t.jointName]}},xd={aliceblue:15792383,antiquewhite:16444375,aqua:65535,aquamarine:8388564,azure:15794175,beige:16119260,bisque:16770244,black:0,blanchedalmond:16772045,blue:255,blueviolet:9055202,brown:10824234,burlywood:14596231,cadetblue:6266528,chartreuse:8388352,chocolate:13789470,coral:16744272,cornflowerblue:6591981,cornsilk:16775388,crimson:14423100,cyan:65535,darkblue:139,darkcyan:35723,darkgoldenrod:12092939,darkgray:11119017,darkgreen:25600,darkgrey:11119017,darkkhaki:12433259,darkmagenta:9109643,darkolivegreen:5597999,darkorange:16747520,darkorchid:10040012,darkred:9109504,darksalmon:15308410,darkseagreen:9419919,darkslateblue:4734347,darkslategray:3100495,darkslategrey:3100495,darkturquoise:52945,darkviolet:9699539,deeppink:16716947,deepskyblue:49151,dimgray:6908265,dimgrey:6908265,dodgerblue:2003199,firebrick:11674146,floralwhite:16775920,forestgreen:2263842,fuchsia:16711935,gainsboro:14474460,ghostwhite:16316671,gold:16766720,goldenrod:14329120,gray:8421504,green:32768,greenyellow:11403055,grey:8421504,honeydew:15794160,hotpink:16738740,indianred:13458524,indigo:4915330,ivory:16777200,khaki:15787660,lavender:15132410,lavenderblush:16773365,lawngreen:8190976,lemonchiffon:16775885,lightblue:11393254,lightcoral:15761536,lightcyan:14745599,lightgoldenrodyellow:16448210,lightgray:13882323,lightgreen:9498256,lightgrey:13882323,lightpink:16758465,lightsalmon:16752762,lightseagreen:2142890,lightskyblue:8900346,lightslategray:7833753,lightslategrey:7833753,lightsteelblue:11584734,lightyellow:16777184,lime:65280,limegreen:3329330,linen:16445670,magenta:16711935,maroon:8388608,mediumaquamarine:6737322,mediumblue:205,mediumorchid:12211667,mediumpurple:9662683,mediumseagreen:3978097,mediumslateblue:8087790,mediumspringgreen:64154,mediumturquoise:4772300,mediumvioletred:13047173,midnightblue:1644912,mintcream:16121850,mistyrose:16770273,moccasin:16770229,navajowhite:16768685,navy:128,oldlace:16643558,olive:8421376,olivedrab:7048739,orange:16753920,orangered:16729344,orchid:14315734,palegoldenrod:15657130,palegreen:10025880,paleturquoise:11529966,palevioletred:14381203,papayawhip:16773077,peachpuff:16767673,peru:13468991,pink:16761035,plum:14524637,powderblue:11591910,purple:8388736,rebeccapurple:6697881,red:16711680,rosybrown:12357519,royalblue:4286945,saddlebrown:9127187,salmon:16416882,sandybrown:16032864,seagreen:3050327,seashell:16774638,sienna:10506797,silver:12632256,skyblue:8900331,slateblue:6970061,slategray:7372944,slategrey:7372944,snow:16775930,springgreen:65407,steelblue:4620980,tan:13808780,teal:32896,thistle:14204888,tomato:16737095,turquoise:4251856,violet:15631086,wheat:16113331,white:16777215,whitesmoke:16119285,yellow:16776960,yellowgreen:10145074},sn={h:0,s:0,l:0},Zs={h:0,s:0,l:0};function dl(r,e,t){return t<0&&(t+=1),t>1&&(t-=1),t<1/6?r+6*(e-r)*t:t<.5?e:t<2/3?r+6*(e-r)*(2/3-t):r}var Ie=class{constructor(e,t,i){return this.isColor=!0,this.r=1,this.g=1,this.b=1,this.set(e,t,i)}set(e,t,i){if(t===void 0&&i===void 0){let n=e;n&&n.isColor?this.copy(n):typeof n=="number"?this.setHex(n):typeof n=="string"&&this.setStyle(n)}else this.setRGB(e,t,i);return this}setScalar(e){return this.r=e,this.g=e,this.b=e,this}setHex(e,t=bt){return e=Math.floor(e),this.r=(e>>16&255)/255,this.g=(e>>8&255)/255,this.b=(255&e)/255,He.colorSpaceToWorking(this,t),this}setRGB(e,t,i,n=He.workingColorSpace){return this.r=e,this.g=t,this.b=i,He.colorSpaceToWorking(this,n),this}setHSL(e,t,i,n=He.workingColorSpace){if(e=Gl(e,1),t=Ge(t,0,1),i=Ge(i,0,1),t===0)this.r=this.g=this.b=i;else{let s=i<=.5?i*(1+t):i+t-i*t,a=2*i-s;this.r=dl(a,s,e+1/3),this.g=dl(a,s,e),this.b=dl(a,s,e-1/3)}return He.colorSpaceToWorking(this,n),this}setStyle(e,t=bt){function i(s){s!==void 0&&parseFloat(s)<1&&be("Color: Alpha component of "+e+" will be ignored.")}let n;if(n=/^(\w+)\(([^\)]*)\)/.exec(e)){let s,a=n[1],o=n[2];switch(a){case"rgb":case"rgba":if(s=/^\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(o))return i(s[4]),this.setRGB(Math.min(255,parseInt(s[1],10))/255,Math.min(255,parseInt(s[2],10))/255,Math.min(255,parseInt(s[3],10))/255,t);if(s=/^\s*(\d+)\%\s*,\s*(\d+)\%\s*,\s*(\d+)\%\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(o))return i(s[4]),this.setRGB(Math.min(100,parseInt(s[1],10))/100,Math.min(100,parseInt(s[2],10))/100,Math.min(100,parseInt(s[3],10))/100,t);break;case"hsl":case"hsla":if(s=/^\s*(\d*\.?\d+)\s*,\s*(\d*\.?\d+)\%\s*,\s*(\d*\.?\d+)\%\s*(?:,\s*(\d*\.?\d+)\s*)?$/.exec(o))return i(s[4]),this.setHSL(parseFloat(s[1])/360,parseFloat(s[2])/100,parseFloat(s[3])/100,t);break;default:be("Color: Unknown color model "+e)}}else if(n=/^\#([A-Fa-f\d]+)$/.exec(e)){let s=n[1],a=s.length;if(a===3)return this.setRGB(parseInt(s.charAt(0),16)/15,parseInt(s.charAt(1),16)/15,parseInt(s.charAt(2),16)/15,t);if(a===6)return this.setHex(parseInt(s,16),t);be("Color: Invalid hex color "+e)}else if(e&&e.length>0)return this.setColorName(e,t);return this}setColorName(e,t=bt){let i=xd[e.toLowerCase()];return i!==void 0?this.setHex(i,t):be("Color: Unknown color "+e),this}clone(){return new this.constructor(this.r,this.g,this.b)}copy(e){return this.r=e.r,this.g=e.g,this.b=e.b,this}copySRGBToLinear(e){return this.r=ki(e.r),this.g=ki(e.g),this.b=ki(e.b),this}copyLinearToSRGB(e){return this.r=dr(e.r),this.g=dr(e.g),this.b=dr(e.b),this}convertSRGBToLinear(){return this.copySRGBToLinear(this),this}convertLinearToSRGB(){return this.copyLinearToSRGB(this),this}getHex(e=bt){return He.workingToColorSpace(Lt.copy(this),e),65536*Math.round(Ge(255*Lt.r,0,255))+256*Math.round(Ge(255*Lt.g,0,255))+Math.round(Ge(255*Lt.b,0,255))}getHexString(e=bt){return("000000"+this.getHex(e).toString(16)).slice(-6)}getHSL(e,t=He.workingColorSpace){He.workingToColorSpace(Lt.copy(this),t);let i=Lt.r,n=Lt.g,s=Lt.b,a=Math.max(i,n,s),o=Math.min(i,n,s),c,l,h=(o+a)/2;if(o===a)c=0,l=0;else{let d=a-o;switch(l=h<=.5?d/(a+o):d/(2-a-o),a){case i:c=(n-s)/d+(n<s?6:0);break;case n:c=(s-i)/d+2;break;case s:c=(i-n)/d+4}c/=6}return e.h=c,e.s=l,e.l=h,e}getRGB(e,t=He.workingColorSpace){return He.workingToColorSpace(Lt.copy(this),t),e.r=Lt.r,e.g=Lt.g,e.b=Lt.b,e}getStyle(e=bt){He.workingToColorSpace(Lt.copy(this),e);let t=Lt.r,i=Lt.g,n=Lt.b;return e!==bt?`color(${e} ${t.toFixed(3)} ${i.toFixed(3)} ${n.toFixed(3)})`:`rgb(${Math.round(255*t)},${Math.round(255*i)},${Math.round(255*n)})`}offsetHSL(e,t,i){return this.getHSL(sn),this.setHSL(sn.h+e,sn.s+t,sn.l+i)}add(e){return this.r+=e.r,this.g+=e.g,this.b+=e.b,this}addColors(e,t){return this.r=e.r+t.r,this.g=e.g+t.g,this.b=e.b+t.b,this}addScalar(e){return this.r+=e,this.g+=e,this.b+=e,this}sub(e){return this.r=Math.max(0,this.r-e.r),this.g=Math.max(0,this.g-e.g),this.b=Math.max(0,this.b-e.b),this}multiply(e){return this.r*=e.r,this.g*=e.g,this.b*=e.b,this}multiplyScalar(e){return this.r*=e,this.g*=e,this.b*=e,this}lerp(e,t){return this.r+=(e.r-this.r)*t,this.g+=(e.g-this.g)*t,this.b+=(e.b-this.b)*t,this}lerpColors(e,t,i){return this.r=e.r+(t.r-e.r)*i,this.g=e.g+(t.g-e.g)*i,this.b=e.b+(t.b-e.b)*i,this}lerpHSL(e,t){this.getHSL(sn),e.getHSL(Zs);let i=is(sn.h,Zs.h,t),n=is(sn.s,Zs.s,t),s=is(sn.l,Zs.l,t);return this.setHSL(i,n,s),this}setFromVector3(e){return this.r=e.x,this.g=e.y,this.b=e.z,this}applyMatrix3(e){let t=this.r,i=this.g,n=this.b,s=e.elements;return this.r=s[0]*t+s[3]*i+s[6]*n,this.g=s[1]*t+s[4]*i+s[7]*n,this.b=s[2]*t+s[5]*i+s[8]*n,this}equals(e){return e.r===this.r&&e.g===this.g&&e.b===this.b}fromArray(e,t=0){return this.r=e[t],this.g=e[t+1],this.b=e[t+2],this}toArray(e=[],t=0){return e[t]=this.r,e[t+1]=this.g,e[t+2]=this.b,e}fromBufferAttribute(e,t){return this.r=e.getX(t),this.g=e.getY(t),this.b=e.getZ(t),this}toJSON(){return this.getHex()}*[Symbol.iterator](){yield this.r,yield this.g,yield this.b}},Lt=new Ie;Ie.NAMES=xd;var us=class extends Tt{constructor(){super(),this.isScene=!0,this.type="Scene",this.background=null,this.environment=null,this.fog=null,this.backgroundBlurriness=0,this.backgroundIntensity=1,this.backgroundRotation=new Xi,this.environmentIntensity=1,this.environmentRotation=new Xi,this.overrideMaterial=null,typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}copy(e,t){return super.copy(e,t),e.background!==null&&(this.background=e.background.clone()),e.environment!==null&&(this.environment=e.environment.clone()),e.fog!==null&&(this.fog=e.fog.clone()),this.backgroundBlurriness=e.backgroundBlurriness,this.backgroundIntensity=e.backgroundIntensity,this.backgroundRotation.copy(e.backgroundRotation),this.environmentIntensity=e.environmentIntensity,this.environmentRotation.copy(e.environmentRotation),e.overrideMaterial!==null&&(this.overrideMaterial=e.overrideMaterial.clone()),this.matrixAutoUpdate=e.matrixAutoUpdate,this}toJSON(e){let t=super.toJSON(e);return this.fog!==null&&(t.object.fog=this.fog.toJSON()),this.backgroundBlurriness>0&&(t.object.backgroundBlurriness=this.backgroundBlurriness),this.backgroundIntensity!==1&&(t.object.backgroundIntensity=this.backgroundIntensity),t.object.backgroundRotation=this.backgroundRotation.toArray(),this.environmentIntensity!==1&&(t.object.environmentIntensity=this.environmentIntensity),t.object.environmentRotation=this.environmentRotation.toArray(),t}},ci=new w,zi=new w,pl=new w,Gi=new w,Qn=new w,er=new w,au=new w,ml=new w,fl=new w,gl=new w,_l=new $e,vl=new $e,xl=new $e,wi=class r{constructor(e=new w,t=new w,i=new w){this.a=e,this.b=t,this.c=i}static getNormal(e,t,i,n){n.subVectors(i,t),ci.subVectors(e,t),n.cross(ci);let s=n.lengthSq();return s>0?n.multiplyScalar(1/Math.sqrt(s)):n.set(0,0,0)}static getBarycoord(e,t,i,n,s){ci.subVectors(n,t),zi.subVectors(i,t),pl.subVectors(e,t);let a=ci.dot(ci),o=ci.dot(zi),c=ci.dot(pl),l=zi.dot(zi),h=zi.dot(pl),d=a*l-o*o;if(d===0)return s.set(0,0,0),null;let p=1/d,u=(l*c-o*h)*p,g=(a*h-o*c)*p;return s.set(1-u-g,g,u)}static containsPoint(e,t,i,n){return this.getBarycoord(e,t,i,n,Gi)!==null&&Gi.x>=0&&Gi.y>=0&&Gi.x+Gi.y<=1}static getInterpolation(e,t,i,n,s,a,o,c){return this.getBarycoord(e,t,i,n,Gi)===null?(c.x=0,c.y=0,"z"in c&&(c.z=0),"w"in c&&(c.w=0),null):(c.setScalar(0),c.addScaledVector(s,Gi.x),c.addScaledVector(a,Gi.y),c.addScaledVector(o,Gi.z),c)}static getInterpolatedAttribute(e,t,i,n,s,a){return _l.setScalar(0),vl.setScalar(0),xl.setScalar(0),_l.fromBufferAttribute(e,t),vl.fromBufferAttribute(e,i),xl.fromBufferAttribute(e,n),a.setScalar(0),a.addScaledVector(_l,s.x),a.addScaledVector(vl,s.y),a.addScaledVector(xl,s.z),a}static isFrontFacing(e,t,i,n){return ci.subVectors(i,t),zi.subVectors(e,t),ci.cross(zi).dot(n)<0}set(e,t,i){return this.a.copy(e),this.b.copy(t),this.c.copy(i),this}setFromPointsAndIndices(e,t,i,n){return this.a.copy(e[t]),this.b.copy(e[i]),this.c.copy(e[n]),this}setFromAttributeAndIndices(e,t,i,n){return this.a.fromBufferAttribute(e,t),this.b.fromBufferAttribute(e,i),this.c.fromBufferAttribute(e,n),this}clone(){return new this.constructor().copy(this)}copy(e){return this.a.copy(e.a),this.b.copy(e.b),this.c.copy(e.c),this}getArea(){return ci.subVectors(this.c,this.b),zi.subVectors(this.a,this.b),.5*ci.cross(zi).length()}getMidpoint(e){return e.addVectors(this.a,this.b).add(this.c).multiplyScalar(1/3)}getNormal(e){return r.getNormal(this.a,this.b,this.c,e)}getPlane(e){return e.setFromCoplanarPoints(this.a,this.b,this.c)}getBarycoord(e,t){return r.getBarycoord(e,this.a,this.b,this.c,t)}getInterpolation(e,t,i,n,s){return r.getInterpolation(e,this.a,this.b,this.c,t,i,n,s)}containsPoint(e){return r.containsPoint(e,this.a,this.b,this.c)}isFrontFacing(e){return r.isFrontFacing(this.a,this.b,this.c,e)}intersectsBox(e){return e.intersectsTriangle(this)}closestPointToPoint(e,t){let i=this.a,n=this.b,s=this.c,a,o;Qn.subVectors(n,i),er.subVectors(s,i),ml.subVectors(e,i);let c=Qn.dot(ml),l=er.dot(ml);if(c<=0&&l<=0)return t.copy(i);fl.subVectors(e,n);let h=Qn.dot(fl),d=er.dot(fl);if(h>=0&&d<=h)return t.copy(n);let p=c*d-h*l;if(p<=0&&c>=0&&h<=0)return a=c/(c-h),t.copy(i).addScaledVector(Qn,a);gl.subVectors(e,s);let u=Qn.dot(gl),g=er.dot(gl);if(g>=0&&u<=g)return t.copy(s);let m=u*l-c*g;if(m<=0&&l>=0&&g<=0)return o=l/(l-g),t.copy(i).addScaledVector(er,o);let v=h*g-u*d;if(v<=0&&d-h>=0&&u-g>=0)return au.subVectors(s,n),o=(d-h)/(d-h+(u-g)),t.copy(n).addScaledVector(au,o);let f=1/(v+m+p);return a=m*f,o=p*f,t.copy(i).addScaledVector(Qn,a).addScaledVector(er,o)}equals(e){return e.a.equals(this.a)&&e.b.equals(this.b)&&e.c.equals(this.c)}},di=class{constructor(e=new w(1/0,1/0,1/0),t=new w(-1/0,-1/0,-1/0)){this.isBox3=!0,this.min=e,this.max=t}set(e,t){return this.min.copy(e),this.max.copy(t),this}setFromArray(e){this.makeEmpty();for(let t=0,i=e.length;t<i;t+=3)this.expandByPoint(hi.fromArray(e,t));return this}setFromBufferAttribute(e){this.makeEmpty();for(let t=0,i=e.count;t<i;t++)this.expandByPoint(hi.fromBufferAttribute(e,t));return this}setFromPoints(e){this.makeEmpty();for(let t=0,i=e.length;t<i;t++)this.expandByPoint(e[t]);return this}setFromCenterAndSize(e,t){let i=hi.copy(t).multiplyScalar(.5);return this.min.copy(e).sub(i),this.max.copy(e).add(i),this}setFromObject(e,t=!1){return this.makeEmpty(),this.expandByObject(e,t)}clone(){return new this.constructor().copy(this)}copy(e){return this.min.copy(e.min),this.max.copy(e.max),this}makeEmpty(){return this.min.x=this.min.y=this.min.z=1/0,this.max.x=this.max.y=this.max.z=-1/0,this}isEmpty(){return this.max.x<this.min.x||this.max.y<this.min.y||this.max.z<this.min.z}getCenter(e){return this.isEmpty()?e.set(0,0,0):e.addVectors(this.min,this.max).multiplyScalar(.5)}getSize(e){return this.isEmpty()?e.set(0,0,0):e.subVectors(this.max,this.min)}expandByPoint(e){return this.min.min(e),this.max.max(e),this}expandByVector(e){return this.min.sub(e),this.max.add(e),this}expandByScalar(e){return this.min.addScalar(-e),this.max.addScalar(e),this}expandByObject(e,t=!1){e.updateWorldMatrix(!1,!1);let i=e.geometry;if(i!==void 0){let s=i.getAttribute("position");if(t===!0&&s!==void 0&&e.isInstancedMesh!==!0)for(let a=0,o=s.count;a<o;a++)e.isMesh===!0?e.getVertexPosition(a,hi):hi.fromBufferAttribute(s,a),hi.applyMatrix4(e.matrixWorld),this.expandByPoint(hi);else e.boundingBox!==void 0?(e.boundingBox===null&&e.computeBoundingBox(),Js.copy(e.boundingBox)):(i.boundingBox===null&&i.computeBoundingBox(),Js.copy(i.boundingBox)),Js.applyMatrix4(e.matrixWorld),this.union(Js)}let n=e.children;for(let s=0,a=n.length;s<a;s++)this.expandByObject(n[s],t);return this}containsPoint(e){return e.x>=this.min.x&&e.x<=this.max.x&&e.y>=this.min.y&&e.y<=this.max.y&&e.z>=this.min.z&&e.z<=this.max.z}containsBox(e){return this.min.x<=e.min.x&&e.max.x<=this.max.x&&this.min.y<=e.min.y&&e.max.y<=this.max.y&&this.min.z<=e.min.z&&e.max.z<=this.max.z}getParameter(e,t){return t.set((e.x-this.min.x)/(this.max.x-this.min.x),(e.y-this.min.y)/(this.max.y-this.min.y),(e.z-this.min.z)/(this.max.z-this.min.z))}intersectsBox(e){return e.max.x>=this.min.x&&e.min.x<=this.max.x&&e.max.y>=this.min.y&&e.min.y<=this.max.y&&e.max.z>=this.min.z&&e.min.z<=this.max.z}intersectsSphere(e){return this.clampPoint(e.center,hi),hi.distanceToSquared(e.center)<=e.radius*e.radius}intersectsPlane(e){let t,i;return e.normal.x>0?(t=e.normal.x*this.min.x,i=e.normal.x*this.max.x):(t=e.normal.x*this.max.x,i=e.normal.x*this.min.x),e.normal.y>0?(t+=e.normal.y*this.min.y,i+=e.normal.y*this.max.y):(t+=e.normal.y*this.max.y,i+=e.normal.y*this.min.y),e.normal.z>0?(t+=e.normal.z*this.min.z,i+=e.normal.z*this.max.z):(t+=e.normal.z*this.max.z,i+=e.normal.z*this.min.z),t<=-e.constant&&i>=-e.constant}intersectsTriangle(e){if(this.isEmpty())return!1;this.getCenter(Yr),Ks.subVectors(this.max,Yr),tr.subVectors(e.a,Yr),ir.subVectors(e.b,Yr),nr.subVectors(e.c,Yr),an.subVectors(ir,tr),on.subVectors(nr,ir),En.subVectors(tr,nr);let t=[0,-an.z,an.y,0,-on.z,on.y,0,-En.z,En.y,an.z,0,-an.x,on.z,0,-on.x,En.z,0,-En.x,-an.y,an.x,0,-on.y,on.x,0,-En.y,En.x,0];return!!yl(t,tr,ir,nr,Ks)&&(t=[1,0,0,0,1,0,0,0,1],!!yl(t,tr,ir,nr,Ks)&&($s.crossVectors(an,on),t=[$s.x,$s.y,$s.z],yl(t,tr,ir,nr,Ks)))}clampPoint(e,t){return t.copy(e).clamp(this.min,this.max)}distanceToPoint(e){return this.clampPoint(e,hi).distanceTo(e)}getBoundingSphere(e){return this.isEmpty()?e.makeEmpty():(this.getCenter(e.center),e.radius=.5*this.getSize(hi).length()),e}intersect(e){return this.min.max(e.min),this.max.min(e.max),this.isEmpty()&&this.makeEmpty(),this}union(e){return this.min.min(e.min),this.max.max(e.max),this}applyMatrix4(e){return this.isEmpty()||(Vi[0].set(this.min.x,this.min.y,this.min.z).applyMatrix4(e),Vi[1].set(this.min.x,this.min.y,this.max.z).applyMatrix4(e),Vi[2].set(this.min.x,this.max.y,this.min.z).applyMatrix4(e),Vi[3].set(this.min.x,this.max.y,this.max.z).applyMatrix4(e),Vi[4].set(this.max.x,this.min.y,this.min.z).applyMatrix4(e),Vi[5].set(this.max.x,this.min.y,this.max.z).applyMatrix4(e),Vi[6].set(this.max.x,this.max.y,this.min.z).applyMatrix4(e),Vi[7].set(this.max.x,this.max.y,this.max.z).applyMatrix4(e),this.setFromPoints(Vi)),this}translate(e){return this.min.add(e),this.max.add(e),this}equals(e){return e.min.equals(this.min)&&e.max.equals(this.max)}toJSON(){return{min:this.min.toArray(),max:this.max.toArray()}}fromJSON(e){return this.min.fromArray(e.min),this.max.fromArray(e.max),this}},Vi=[new w,new w,new w,new w,new w,new w,new w,new w],hi=new w,Js=new di,tr=new w,ir=new w,nr=new w,an=new w,on=new w,En=new w,Yr=new w,Ks=new w,$s=new w,wn=new w;function yl(r,e,t,i,n){for(let s=0,a=r.length-3;s<=a;s+=3){wn.fromArray(r,s);let o=n.x*Math.abs(wn.x)+n.y*Math.abs(wn.y)+n.z*Math.abs(wn.z),c=e.dot(wn),l=t.dot(wn),h=i.dot(wn);if(Math.max(-Math.max(c,l,h),Math.min(c,l,h))>o)return!1}return!0}var ag=Gp();function Gp(){let r=new ArrayBuffer(4),e=new Float32Array(r),t=new Uint32Array(r),i=new Uint32Array(512),n=new Uint32Array(512);for(let c=0;c<256;++c){let l=c-127;l<-27?(i[c]=0,i[256|c]=32768,n[c]=24,n[256|c]=24):l<-14?(i[c]=1024>>-l-14,i[256|c]=1024>>-l-14|32768,n[c]=-l-1,n[256|c]=-l-1):l<=15?(i[c]=l+15<<10,i[256|c]=l+15<<10|32768,n[c]=13,n[256|c]=13):l<128?(i[c]=31744,i[256|c]=64512,n[c]=24,n[256|c]=24):(i[c]=31744,i[256|c]=64512,n[c]=13,n[256|c]=13)}let s=new Uint32Array(2048),a=new Uint32Array(64),o=new Uint32Array(64);for(let c=1;c<1024;++c){let l=c<<13,h=0;for(;!(8388608&l);)l<<=1,h-=8388608;l&=-8388609,h+=947912704,s[c]=l|h}for(let c=1024;c<2048;++c)s[c]=939524096+(c-1024<<13);for(let c=1;c<31;++c)a[c]=c<<23;a[31]=1199570944,a[32]=2147483648;for(let c=33;c<63;++c)a[c]=2147483648+(c-32<<23);a[63]=3347054592;for(let c=1;c<64;++c)c!==32&&(o[c]=1024);return{floatView:e,uint32View:t,baseTable:i,shiftTable:n,mantissaTable:s,exponentTable:a,offsetTable:o}}var pt=new w,Qs=new te,Vp=0,ft=class extends Ri{constructor(e,t,i=!1){if(super(),Array.isArray(e))throw new TypeError("THREE.BufferAttribute: array should be a Typed Array.");this.isBufferAttribute=!0,Object.defineProperty(this,"id",{value:Vp++}),this.name="",this.array=e,this.itemSize=t,this.count=e!==void 0?e.length/t:0,this.normalized=i,this.usage=Pa,this.updateRanges=[],this.gpuType=_i,this.version=0}onUploadCallback(){}set needsUpdate(e){e===!0&&this.version++}setUsage(e){return this.usage=e,this}addUpdateRange(e,t){this.updateRanges.push({start:e,count:t})}clearUpdateRanges(){this.updateRanges.length=0}copy(e){return this.name=e.name,this.array=new e.array.constructor(e.array),this.itemSize=e.itemSize,this.count=e.count,this.normalized=e.normalized,this.usage=e.usage,this.gpuType=e.gpuType,this}copyAt(e,t,i){e*=this.itemSize,i*=t.itemSize;for(let n=0,s=this.itemSize;n<s;n++)this.array[e+n]=t.array[i+n];return this}copyArray(e){return this.array.set(e),this}applyMatrix3(e){if(this.itemSize===2)for(let t=0,i=this.count;t<i;t++)Qs.fromBufferAttribute(this,t),Qs.applyMatrix3(e),this.setXY(t,Qs.x,Qs.y);else if(this.itemSize===3)for(let t=0,i=this.count;t<i;t++)pt.fromBufferAttribute(this,t),pt.applyMatrix3(e),this.setXYZ(t,pt.x,pt.y,pt.z);return this}applyMatrix4(e){for(let t=0,i=this.count;t<i;t++)pt.fromBufferAttribute(this,t),pt.applyMatrix4(e),this.setXYZ(t,pt.x,pt.y,pt.z);return this}applyNormalMatrix(e){for(let t=0,i=this.count;t<i;t++)pt.fromBufferAttribute(this,t),pt.applyNormalMatrix(e),this.setXYZ(t,pt.x,pt.y,pt.z);return this}transformDirection(e){for(let t=0,i=this.count;t<i;t++)pt.fromBufferAttribute(this,t),pt.transformDirection(e),this.setXYZ(t,pt.x,pt.y,pt.z);return this}set(e,t=0){return this.array.set(e,t),this}getComponent(e,t){let i=this.array[e*this.itemSize+t];return this.normalized&&(i=ui(i,this.array)),i}setComponent(e,t,i){return this.normalized&&(i=Ke(i,this.array)),this.array[e*this.itemSize+t]=i,this}getX(e){let t=this.array[e*this.itemSize];return this.normalized&&(t=ui(t,this.array)),t}setX(e,t){return this.normalized&&(t=Ke(t,this.array)),this.array[e*this.itemSize]=t,this}getY(e){let t=this.array[e*this.itemSize+1];return this.normalized&&(t=ui(t,this.array)),t}setY(e,t){return this.normalized&&(t=Ke(t,this.array)),this.array[e*this.itemSize+1]=t,this}getZ(e){let t=this.array[e*this.itemSize+2];return this.normalized&&(t=ui(t,this.array)),t}setZ(e,t){return this.normalized&&(t=Ke(t,this.array)),this.array[e*this.itemSize+2]=t,this}getW(e){let t=this.array[e*this.itemSize+3];return this.normalized&&(t=ui(t,this.array)),t}setW(e,t){return this.normalized&&(t=Ke(t,this.array)),this.array[e*this.itemSize+3]=t,this}setXY(e,t,i){return e*=this.itemSize,this.normalized&&(t=Ke(t,this.array),i=Ke(i,this.array)),this.array[e+0]=t,this.array[e+1]=i,this}setXYZ(e,t,i,n){return e*=this.itemSize,this.normalized&&(t=Ke(t,this.array),i=Ke(i,this.array),n=Ke(n,this.array)),this.array[e+0]=t,this.array[e+1]=i,this.array[e+2]=n,this}setXYZW(e,t,i,n,s){return e*=this.itemSize,this.normalized&&(t=Ke(t,this.array),i=Ke(i,this.array),n=Ke(n,this.array),s=Ke(s,this.array)),this.array[e+0]=t,this.array[e+1]=i,this.array[e+2]=n,this.array[e+3]=s,this}onUpload(e){return this.onUploadCallback=e,this}clone(){return new this.constructor(this.array,this.itemSize).copy(this)}toJSON(){let e={itemSize:this.itemSize,type:this.array.constructor.name,array:Array.from(this.array),normalized:this.normalized};return this.name!==""&&(e.name=this.name),this.usage!==Pa&&(e.usage=this.usage),e}dispose(){this.dispatchEvent({type:"dispose"})}};var ds=class extends ft{constructor(e,t,i){super(new Uint16Array(e),t,i)}};var ps=class extends ft{constructor(e,t,i){super(new Uint32Array(e),t,i)}};var Te=class extends ft{constructor(e,t,i){super(new Float32Array(e),t,i)}},Hp=new di,Zr=new w,Ml=new w,pi=class{constructor(e=new w,t=-1){this.isSphere=!0,this.center=e,this.radius=t}set(e,t){return this.center.copy(e),this.radius=t,this}setFromPoints(e,t){let i=this.center;t!==void 0?i.copy(t):Hp.setFromPoints(e).getCenter(i);let n=0;for(let s=0,a=e.length;s<a;s++)n=Math.max(n,i.distanceToSquared(e[s]));return this.radius=Math.sqrt(n),this}copy(e){return this.center.copy(e.center),this.radius=e.radius,this}isEmpty(){return this.radius<0}makeEmpty(){return this.center.set(0,0,0),this.radius=-1,this}containsPoint(e){return e.distanceToSquared(this.center)<=this.radius*this.radius}distanceToPoint(e){return e.distanceTo(this.center)-this.radius}intersectsSphere(e){let t=this.radius+e.radius;return e.center.distanceToSquared(this.center)<=t*t}intersectsBox(e){return e.intersectsSphere(this)}intersectsPlane(e){return Math.abs(e.distanceToPoint(this.center))<=this.radius}clampPoint(e,t){let i=this.center.distanceToSquared(e);return t.copy(e),i>this.radius*this.radius&&(t.sub(this.center).normalize(),t.multiplyScalar(this.radius).add(this.center)),t}getBoundingBox(e){return this.isEmpty()?(e.makeEmpty(),e):(e.set(this.center,this.center),e.expandByScalar(this.radius),e)}applyMatrix4(e){return this.center.applyMatrix4(e),this.radius=this.radius*e.getMaxScaleOnAxis(),this}translate(e){return this.center.add(e),this}expandByPoint(e){if(this.isEmpty())return this.center.copy(e),this.radius=0,this;Zr.subVectors(e,this.center);let t=Zr.lengthSq();if(t>this.radius*this.radius){let i=Math.sqrt(t),n=.5*(i-this.radius);this.center.addScaledVector(Zr,n/i),this.radius+=n}return this}union(e){return e.isEmpty()?this:this.isEmpty()?(this.copy(e),this):(this.center.equals(e.center)===!0?this.radius=Math.max(this.radius,e.radius):(Ml.subVectors(e.center,this.center).setLength(e.radius),this.expandByPoint(Zr.copy(e.center).add(Ml)),this.expandByPoint(Zr.copy(e.center).sub(Ml))),this)}equals(e){return e.center.equals(this.center)&&e.radius===this.radius}clone(){return new this.constructor().copy(this)}toJSON(){return{radius:this.radius,center:this.center.toArray()}}fromJSON(e){return this.radius=e.radius,this.center.fromArray(e.center),this}},kp=0,ei=new Fe,Sl=new Tt,rr=new w,Wt=new di,Jr=new di,St=new w,Xe=class r extends Ri{constructor(){super(),this.isBufferGeometry=!0,Object.defineProperty(this,"id",{value:kp++}),this.uuid=Ci(),this.name="",this.type="BufferGeometry",this.index=null,this.indirect=null,this.indirectOffset=0,this.attributes={},this.morphAttributes={},this.morphTargetsRelative=!1,this.groups=[],this.boundingBox=null,this.boundingSphere=null,this.drawRange={start:0,count:1/0},this.userData={},this._transformed=!1}getIndex(){return this.index}setIndex(e){return Array.isArray(e)?this.index=new((function(t){for(let i=t.length-1;i>=0;--i)if(t[i]>=65535)return!0;return!1})(e)?ps:ds)(e,1):this.index=e,this}setIndirect(e,t=0){return this.indirect=e,this.indirectOffset=t,this}getIndirect(){return this.indirect}getAttribute(e){return this.attributes[e]}setAttribute(e,t){return this.attributes[e]=t,this}deleteAttribute(e){return delete this.attributes[e],this}hasAttribute(e){return this.attributes[e]!==void 0}addGroup(e,t,i=0){this.groups.push({start:e,count:t,materialIndex:i})}clearGroups(){this.groups=[]}setDrawRange(e,t){this.drawRange.start=e,this.drawRange.count=t}applyMatrix4(e){let t=this.attributes.position;t!==void 0&&(t.applyMatrix4(e),t.needsUpdate=!0);let i=this.attributes.normal;if(i!==void 0){let s=new Ne().getNormalMatrix(e);i.applyNormalMatrix(s),i.needsUpdate=!0}let n=this.attributes.tangent;return n!==void 0&&(n.transformDirection(e),n.needsUpdate=!0),this.boundingBox!==null&&this.computeBoundingBox(),this.boundingSphere!==null&&this.computeBoundingSphere(),this._transformed=!0,this}applyQuaternion(e){return ei.makeRotationFromQuaternion(e),this.applyMatrix4(ei),this}rotateX(e){return ei.makeRotationX(e),this.applyMatrix4(ei),this}rotateY(e){return ei.makeRotationY(e),this.applyMatrix4(ei),this}rotateZ(e){return ei.makeRotationZ(e),this.applyMatrix4(ei),this}translate(e,t,i){return ei.makeTranslation(e,t,i),this.applyMatrix4(ei),this}scale(e,t,i){return ei.makeScale(e,t,i),this.applyMatrix4(ei),this}lookAt(e){return Sl.lookAt(e),Sl.updateMatrix(),this.applyMatrix4(Sl.matrix),this}center(){return this.computeBoundingBox(),this.boundingBox.getCenter(rr).negate(),this.translate(rr.x,rr.y,rr.z),this}setFromPoints(e){let t=this.getAttribute("position");if(t===void 0){let i=[];for(let n=0,s=e.length;n<s;n++){let a=e[n];i.push(a.x,a.y,a.z||0)}this.setAttribute("position",new Te(i,3))}else{let i=Math.min(e.length,t.count);for(let n=0;n<i;n++){let s=e[n];t.setXYZ(n,s.x,s.y,s.z||0)}e.length>t.count&&be("BufferGeometry: Buffer size too small for points data. Use .dispose() and create a new geometry."),t.needsUpdate=!0}return this}computeBoundingBox(){this.boundingBox===null&&(this.boundingBox=new di);let e=this.attributes.position,t=this.morphAttributes.position;if(e&&e.isGLBufferAttribute)return we("BufferGeometry.computeBoundingBox(): GLBufferAttribute requires a manual bounding box.",this),void this.boundingBox.set(new w(-1/0,-1/0,-1/0),new w(1/0,1/0,1/0));if(e!==void 0){if(this.boundingBox.setFromBufferAttribute(e),t)for(let i=0,n=t.length;i<n;i++){let s=t[i];Wt.setFromBufferAttribute(s),this.morphTargetsRelative?(St.addVectors(this.boundingBox.min,Wt.min),this.boundingBox.expandByPoint(St),St.addVectors(this.boundingBox.max,Wt.max),this.boundingBox.expandByPoint(St)):(this.boundingBox.expandByPoint(Wt.min),this.boundingBox.expandByPoint(Wt.max))}}else this.boundingBox.makeEmpty();(isNaN(this.boundingBox.min.x)||isNaN(this.boundingBox.min.y)||isNaN(this.boundingBox.min.z))&&we('BufferGeometry.computeBoundingBox(): Computed min/max have NaN values. The "position" attribute is likely to have NaN values.',this)}computeBoundingSphere(){this.boundingSphere===null&&(this.boundingSphere=new pi);let e=this.attributes.position,t=this.morphAttributes.position;if(e&&e.isGLBufferAttribute)return we("BufferGeometry.computeBoundingSphere(): GLBufferAttribute requires a manual bounding sphere.",this),void this.boundingSphere.set(new w,1/0);if(e){let i=this.boundingSphere.center;if(Wt.setFromBufferAttribute(e),t)for(let s=0,a=t.length;s<a;s++){let o=t[s];Jr.setFromBufferAttribute(o),this.morphTargetsRelative?(St.addVectors(Wt.min,Jr.min),Wt.expandByPoint(St),St.addVectors(Wt.max,Jr.max),Wt.expandByPoint(St)):(Wt.expandByPoint(Jr.min),Wt.expandByPoint(Jr.max))}Wt.getCenter(i);let n=0;for(let s=0,a=e.count;s<a;s++)St.fromBufferAttribute(e,s),n=Math.max(n,i.distanceToSquared(St));if(t)for(let s=0,a=t.length;s<a;s++){let o=t[s],c=this.morphTargetsRelative;for(let l=0,h=o.count;l<h;l++)St.fromBufferAttribute(o,l),c&&(rr.fromBufferAttribute(e,l),St.add(rr)),n=Math.max(n,i.distanceToSquared(St))}this.boundingSphere.radius=Math.sqrt(n),isNaN(this.boundingSphere.radius)&&we('BufferGeometry.computeBoundingSphere(): Computed radius is NaN. The "position" attribute is likely to have NaN values.',this)}}computeTangents(){let e=this.index,t=this.attributes;if(e===null||t.position===void 0||t.normal===void 0||t.uv===void 0)return void we("BufferGeometry: .computeTangents() failed. Missing required attributes (index, position, normal or uv)");let i=t.position,n=t.normal,s=t.uv,a=this.getAttribute("tangent");a!==void 0&&a.count===i.count||(a=new ft(new Float32Array(4*i.count),4),this.setAttribute("tangent",a));let o=[],c=[];for(let O=0;O<i.count;O++)o[O]=new w,c[O]=new w;let l=new w,h=new w,d=new w,p=new te,u=new te,g=new te,m=new w,v=new w;function f(O,L,I){l.fromBufferAttribute(i,O),h.fromBufferAttribute(i,L),d.fromBufferAttribute(i,I),p.fromBufferAttribute(s,O),u.fromBufferAttribute(s,L),g.fromBufferAttribute(s,I),h.sub(l),d.sub(l),u.sub(p),g.sub(p);let B=1/(u.x*g.y-g.x*u.y);isFinite(B)&&(m.copy(h).multiplyScalar(g.y).addScaledVector(d,-u.y).multiplyScalar(B),v.copy(d).multiplyScalar(u.x).addScaledVector(h,-g.x).multiplyScalar(B),o[O].add(m),o[L].add(m),o[I].add(m),c[O].add(v),c[L].add(v),c[I].add(v))}let _=this.groups;_.length===0&&(_=[{start:0,count:e.count}]);for(let O=0,L=_.length;O<L;++O){let I=_[O],B=I.start;for(let U=B,X=B+I.count;U<X;U+=3)f(e.getX(U+0),e.getX(U+1),e.getX(U+2))}let x=new w,S=new w,T=new w,M=new w;function P(O){T.fromBufferAttribute(n,O),M.copy(T);let L=o[O];x.copy(L),x.sub(T.multiplyScalar(T.dot(L))).normalize(),S.crossVectors(M,L);let I=S.dot(c[O])<0?-1:1;a.setXYZW(O,x.x,x.y,x.z,I)}for(let O=0,L=_.length;O<L;++O){let I=_[O],B=I.start;for(let U=B,X=B+I.count;U<X;U+=3)P(e.getX(U+0)),P(e.getX(U+1)),P(e.getX(U+2))}this._transformed=!0}computeVertexNormals(){let e=this.index,t=this.getAttribute("position");if(t!==void 0){let i=this.getAttribute("normal");if(i===void 0||i.count!==t.count)i=new ft(new Float32Array(3*t.count),3),this.setAttribute("normal",i);else for(let p=0,u=i.count;p<u;p++)i.setXYZ(p,0,0,0);let n=new w,s=new w,a=new w,o=new w,c=new w,l=new w,h=new w,d=new w;if(e)for(let p=0,u=e.count;p<u;p+=3){let g=e.getX(p+0),m=e.getX(p+1),v=e.getX(p+2);n.fromBufferAttribute(t,g),s.fromBufferAttribute(t,m),a.fromBufferAttribute(t,v),h.subVectors(a,s),d.subVectors(n,s),h.cross(d),o.fromBufferAttribute(i,g),c.fromBufferAttribute(i,m),l.fromBufferAttribute(i,v),o.add(h),c.add(h),l.add(h),i.setXYZ(g,o.x,o.y,o.z),i.setXYZ(m,c.x,c.y,c.z),i.setXYZ(v,l.x,l.y,l.z)}else for(let p=0,u=t.count;p<u;p+=3)n.fromBufferAttribute(t,p+0),s.fromBufferAttribute(t,p+1),a.fromBufferAttribute(t,p+2),h.subVectors(a,s),d.subVectors(n,s),h.cross(d),i.setXYZ(p+0,h.x,h.y,h.z),i.setXYZ(p+1,h.x,h.y,h.z),i.setXYZ(p+2,h.x,h.y,h.z);this.normalizeNormals(),i.needsUpdate=!0}}normalizeNormals(){let e=this.attributes.normal;for(let t=0,i=e.count;t<i;t++)St.fromBufferAttribute(e,t),St.normalize(),e.setXYZ(t,St.x,St.y,St.z)}toNonIndexed(){function e(o,c){let l=o.array,h=o.itemSize,d=o.normalized,p=new l.constructor(c.length*h),u=0,g=0;for(let m=0,v=c.length;m<v;m++){u=o.isInterleavedBufferAttribute?c[m]*o.data.stride+o.offset:c[m]*h;for(let f=0;f<h;f++)p[g++]=l[u++]}return new ft(p,h,d)}if(this.index===null)return be("BufferGeometry.toNonIndexed(): BufferGeometry is already non-indexed."),this;let t=new r,i=this.index.array,n=this.attributes;for(let o in n){let c=e(n[o],i);t.setAttribute(o,c)}let s=this.morphAttributes;for(let o in s){let c=[],l=s[o];for(let h=0,d=l.length;h<d;h++){let p=e(l[h],i);c.push(p)}t.morphAttributes[o]=c}t.morphTargetsRelative=this.morphTargetsRelative;let a=this.groups;for(let o=0,c=a.length;o<c;o++){let l=a[o];t.addGroup(l.start,l.count,l.materialIndex)}return t}toJSON(){let e={metadata:{version:4.7,type:"BufferGeometry",generator:"BufferGeometry.toJSON"}};if(e.uuid=this.uuid,e.type=this.parameters!==void 0&&this._transformed===!0?"BufferGeometry":this.type,this.name!==""&&(e.name=this.name),Object.keys(this.userData).length>0&&(e.userData=this.userData),this.parameters!==void 0&&this._transformed!==!0){let c=this.parameters;for(let l in c)c[l]!==void 0&&(e[l]=c[l]);return e}e.data={attributes:{}};let t=this.index;t!==null&&(e.data.index={type:t.array.constructor.name,array:Array.prototype.slice.call(t.array)});let i=this.attributes;for(let c in i){let l=i[c];e.data.attributes[c]=l.toJSON(e.data)}let n={},s=!1;for(let c in this.morphAttributes){let l=this.morphAttributes[c],h=[];for(let d=0,p=l.length;d<p;d++){let u=l[d];h.push(u.toJSON(e.data))}h.length>0&&(n[c]=h,s=!0)}s&&(e.data.morphAttributes=n,e.data.morphTargetsRelative=this.morphTargetsRelative);let a=this.groups;a.length>0&&(e.data.groups=JSON.parse(JSON.stringify(a)));let o=this.boundingSphere;return o!==null&&(e.data.boundingSphere=o.toJSON()),e}clone(){return new this.constructor().copy(this)}copy(e){this.index=null,this.attributes={},this.morphAttributes={},this.groups=[],this.boundingBox=null,this.boundingSphere=null;let t={};this.name=e.name;let i=e.index;i!==null&&this.setIndex(i.clone());let n=e.attributes;for(let l in n){let h=n[l];this.setAttribute(l,h.clone(t))}let s=e.morphAttributes;for(let l in s){let h=[],d=s[l];for(let p=0,u=d.length;p<u;p++)h.push(d[p].clone(t));this.morphAttributes[l]=h}this.morphTargetsRelative=e.morphTargetsRelative;let a=e.groups;for(let l=0,h=a.length;l<h;l++){let d=a[l];this.addGroup(d.start,d.count,d.materialIndex)}let o=e.boundingBox;o!==null&&(this.boundingBox=o.clone());let c=e.boundingSphere;return c!==null&&(this.boundingSphere=c.clone()),this.drawRange.start=e.drawRange.start,this.drawRange.count=e.drawRange.count,this.userData=e.userData,this._transformed=e._transformed,this}dispose(){this.dispatchEvent({type:"dispose"})}},Da=class{constructor(e,t){this.isInterleavedBuffer=!0,this.array=e,this.stride=t,this.count=e!==void 0?e.length/t:0,this.usage=Pa,this.updateRanges=[],this.version=0,this.uuid=Ci()}onUploadCallback(){}set needsUpdate(e){e===!0&&this.version++}setUsage(e){return this.usage=e,this}addUpdateRange(e,t){this.updateRanges.push({start:e,count:t})}clearUpdateRanges(){this.updateRanges.length=0}copy(e){return this.array=new e.array.constructor(e.array),this.count=e.count,this.stride=e.stride,this.usage=e.usage,this}copyAt(e,t,i){e*=this.stride,i*=t.stride;for(let n=0,s=this.stride;n<s;n++)this.array[e+n]=t.array[i+n];return this}set(e,t=0){return this.array.set(e,t),this}clone(e){e.arrayBuffers===void 0&&(e.arrayBuffers={}),this.array.buffer._uuid===void 0&&(this.array.buffer._uuid=Ci()),e.arrayBuffers[this.array.buffer._uuid]===void 0&&(e.arrayBuffers[this.array.buffer._uuid]=this.array.slice(0).buffer);let t=new this.array.constructor(e.arrayBuffers[this.array.buffer._uuid]),i=new this.constructor(t,this.stride);return i.setUsage(this.usage),i}onUpload(e){return this.onUploadCallback=e,this}toJSON(e){return e.arrayBuffers===void 0&&(e.arrayBuffers={}),this.array.buffer._uuid===void 0&&(this.array.buffer._uuid=Ci()),e.arrayBuffers[this.array.buffer._uuid]===void 0&&(e.arrayBuffers[this.array.buffer._uuid]=Array.from(new Uint32Array(this.array.buffer))),{uuid:this.uuid,buffer:this.array.buffer._uuid,type:this.array.constructor.name,stride:this.stride}}},Bt=new w,ms=class r{constructor(e,t,i,n=!1){this.isInterleavedBufferAttribute=!0,this.name="",this.data=e,this.itemSize=t,this.offset=i,this.normalized=n}get count(){return this.data.count}get array(){return this.data.array}set needsUpdate(e){this.data.needsUpdate=e}applyMatrix4(e){for(let t=0,i=this.data.count;t<i;t++)Bt.fromBufferAttribute(this,t),Bt.applyMatrix4(e),this.setXYZ(t,Bt.x,Bt.y,Bt.z);return this}applyNormalMatrix(e){for(let t=0,i=this.count;t<i;t++)Bt.fromBufferAttribute(this,t),Bt.applyNormalMatrix(e),this.setXYZ(t,Bt.x,Bt.y,Bt.z);return this}transformDirection(e){for(let t=0,i=this.count;t<i;t++)Bt.fromBufferAttribute(this,t),Bt.transformDirection(e),this.setXYZ(t,Bt.x,Bt.y,Bt.z);return this}getComponent(e,t){let i=this.array[e*this.data.stride+this.offset+t];return this.normalized&&(i=ui(i,this.array)),i}setComponent(e,t,i){return this.normalized&&(i=Ke(i,this.array)),this.data.array[e*this.data.stride+this.offset+t]=i,this}setX(e,t){return this.normalized&&(t=Ke(t,this.array)),this.data.array[e*this.data.stride+this.offset]=t,this}setY(e,t){return this.normalized&&(t=Ke(t,this.array)),this.data.array[e*this.data.stride+this.offset+1]=t,this}setZ(e,t){return this.normalized&&(t=Ke(t,this.array)),this.data.array[e*this.data.stride+this.offset+2]=t,this}setW(e,t){return this.normalized&&(t=Ke(t,this.array)),this.data.array[e*this.data.stride+this.offset+3]=t,this}getX(e){let t=this.data.array[e*this.data.stride+this.offset];return this.normalized&&(t=ui(t,this.array)),t}getY(e){let t=this.data.array[e*this.data.stride+this.offset+1];return this.normalized&&(t=ui(t,this.array)),t}getZ(e){let t=this.data.array[e*this.data.stride+this.offset+2];return this.normalized&&(t=ui(t,this.array)),t}getW(e){let t=this.data.array[e*this.data.stride+this.offset+3];return this.normalized&&(t=ui(t,this.array)),t}setXY(e,t,i){return e=e*this.data.stride+this.offset,this.normalized&&(t=Ke(t,this.array),i=Ke(i,this.array)),this.data.array[e+0]=t,this.data.array[e+1]=i,this}setXYZ(e,t,i,n){return e=e*this.data.stride+this.offset,this.normalized&&(t=Ke(t,this.array),i=Ke(i,this.array),n=Ke(n,this.array)),this.data.array[e+0]=t,this.data.array[e+1]=i,this.data.array[e+2]=n,this}setXYZW(e,t,i,n,s){return e=e*this.data.stride+this.offset,this.normalized&&(t=Ke(t,this.array),i=Ke(i,this.array),n=Ke(n,this.array),s=Ke(s,this.array)),this.data.array[e+0]=t,this.data.array[e+1]=i,this.data.array[e+2]=n,this.data.array[e+3]=s,this}clone(e){if(e===void 0){ls("InterleavedBufferAttribute.clone(): Cloning an interleaved buffer attribute will de-interleave buffer data.");let t=[];for(let i=0;i<this.count;i++){let n=i*this.data.stride+this.offset;for(let s=0;s<this.itemSize;s++)t.push(this.data.array[n+s])}return new ft(new this.array.constructor(t),this.itemSize,this.normalized)}return e.interleavedBuffers===void 0&&(e.interleavedBuffers={}),e.interleavedBuffers[this.data.uuid]===void 0&&(e.interleavedBuffers[this.data.uuid]=this.data.clone(e)),new r(e.interleavedBuffers[this.data.uuid],this.itemSize,this.offset,this.normalized)}toJSON(e){if(e===void 0){ls("InterleavedBufferAttribute.toJSON(): Serializing an interleaved buffer attribute will de-interleave buffer data.");let t=[];for(let i=0;i<this.count;i++){let n=i*this.data.stride+this.offset;for(let s=0;s<this.itemSize;s++)t.push(this.data.array[n+s])}return{itemSize:this.itemSize,type:this.array.constructor.name,array:t,normalized:this.normalized}}return e.interleavedBuffers===void 0&&(e.interleavedBuffers={}),e.interleavedBuffers[this.data.uuid]===void 0&&(e.interleavedBuffers[this.data.uuid]=this.data.toJSON(e)),{isInterleavedBufferAttribute:!0,itemSize:this.itemSize,data:this.data.uuid,offset:this.offset,normalized:this.normalized}}},sr,Wp=0,mi=class extends Ri{constructor(){super(),this.isMaterial=!0,Object.defineProperty(this,"id",{value:Wp++}),this.uuid=Ci(),this.name="",this.type="Material",this.blending=1,this.side=0,this.vertexColors=!1,this.opacity=1,this.transparent=!1,this.alphaHash=!1,this.blendSrc=204,this.blendDst=205,this.blendEquation=100,this.blendSrcAlpha=null,this.blendDstAlpha=null,this.blendEquationAlpha=null,this.blendColor=new Ie(0,0,0),this.blendAlpha=0,this.depthFunc=3,this.depthTest=!0,this.depthWrite=!0,this.stencilWriteMask=255,this.stencilFunc=519,this.stencilRef=0,this.stencilFuncMask=255,this.stencilFail=Rn,this.stencilZFail=Rn,this.stencilZPass=Rn,this.stencilWrite=!1,this.clippingPlanes=null,this.clipIntersection=!1,this.clipShadows=!1,this.shadowSide=null,this.colorWrite=!0,this.precision=null,this.polygonOffset=!1,this.polygonOffsetFactor=0,this.polygonOffsetUnits=0,this.dithering=!1,this.alphaToCoverage=!1,this.premultipliedAlpha=!1,this.forceSinglePass=!1,this.allowOverride=!0,this.visible=!0,this.toneMapped=!0,this.userData={},this.version=0,this._alphaTest=0}get alphaTest(){return this._alphaTest}set alphaTest(e){this._alphaTest>0!=e>0&&this.version++,this._alphaTest=e}onBeforeRender(){}onBeforeCompile(){}customProgramCacheKey(){return this.onBeforeCompile.toString()}setValues(e){if(e!==void 0)for(let t in e){let i=e[t];if(i===void 0){be(`Material: parameter '${t}' has value of undefined.`);continue}let n=this[t];n!==void 0?n&&n.isColor?n.set(i):n&&n.isVector2&&i&&i.isVector2||n&&n.isEuler&&i&&i.isEuler||n&&n.isVector3&&i&&i.isVector3?n.copy(i):this[t]=i:be(`Material: '${t}' is not a property of THREE.${this.type}.`)}}toJSON(e){let t=e===void 0||typeof e=="string";t&&(e={textures:{},images:{}});let i={metadata:{version:4.7,type:"Material",generator:"Material.toJSON"}};function n(s){let a=[];for(let o in s){let c=s[o];delete c.metadata,a.push(c)}return a}if(i.uuid=this.uuid,i.type=this.type,this.name!==""&&(i.name=this.name),this.color&&this.color.isColor&&(i.color=this.color.getHex()),this.roughness!==void 0&&(i.roughness=this.roughness),this.metalness!==void 0&&(i.metalness=this.metalness),this.sheen!==void 0&&(i.sheen=this.sheen),this.sheenColor&&this.sheenColor.isColor&&(i.sheenColor=this.sheenColor.getHex()),this.sheenRoughness!==void 0&&(i.sheenRoughness=this.sheenRoughness),this.emissive&&this.emissive.isColor&&(i.emissive=this.emissive.getHex()),this.emissiveIntensity!==void 0&&this.emissiveIntensity!==1&&(i.emissiveIntensity=this.emissiveIntensity),this.specular&&this.specular.isColor&&(i.specular=this.specular.getHex()),this.specularIntensity!==void 0&&(i.specularIntensity=this.specularIntensity),this.specularColor&&this.specularColor.isColor&&(i.specularColor=this.specularColor.getHex()),this.shininess!==void 0&&(i.shininess=this.shininess),this.clearcoat!==void 0&&(i.clearcoat=this.clearcoat),this.clearcoatRoughness!==void 0&&(i.clearcoatRoughness=this.clearcoatRoughness),this.clearcoatMap&&this.clearcoatMap.isTexture&&(i.clearcoatMap=this.clearcoatMap.toJSON(e).uuid),this.clearcoatRoughnessMap&&this.clearcoatRoughnessMap.isTexture&&(i.clearcoatRoughnessMap=this.clearcoatRoughnessMap.toJSON(e).uuid),this.clearcoatNormalMap&&this.clearcoatNormalMap.isTexture&&(i.clearcoatNormalMap=this.clearcoatNormalMap.toJSON(e).uuid,i.clearcoatNormalScale=this.clearcoatNormalScale.toArray()),this.sheenColorMap&&this.sheenColorMap.isTexture&&(i.sheenColorMap=this.sheenColorMap.toJSON(e).uuid),this.sheenRoughnessMap&&this.sheenRoughnessMap.isTexture&&(i.sheenRoughnessMap=this.sheenRoughnessMap.toJSON(e).uuid),this.dispersion!==void 0&&(i.dispersion=this.dispersion),this.iridescence!==void 0&&(i.iridescence=this.iridescence),this.iridescenceIOR!==void 0&&(i.iridescenceIOR=this.iridescenceIOR),this.iridescenceThicknessRange!==void 0&&(i.iridescenceThicknessRange=this.iridescenceThicknessRange),this.iridescenceMap&&this.iridescenceMap.isTexture&&(i.iridescenceMap=this.iridescenceMap.toJSON(e).uuid),this.iridescenceThicknessMap&&this.iridescenceThicknessMap.isTexture&&(i.iridescenceThicknessMap=this.iridescenceThicknessMap.toJSON(e).uuid),this.anisotropy!==void 0&&(i.anisotropy=this.anisotropy),this.anisotropyRotation!==void 0&&(i.anisotropyRotation=this.anisotropyRotation),this.anisotropyMap&&this.anisotropyMap.isTexture&&(i.anisotropyMap=this.anisotropyMap.toJSON(e).uuid),this.map&&this.map.isTexture&&(i.map=this.map.toJSON(e).uuid),this.matcap&&this.matcap.isTexture&&(i.matcap=this.matcap.toJSON(e).uuid),this.alphaMap&&this.alphaMap.isTexture&&(i.alphaMap=this.alphaMap.toJSON(e).uuid),this.lightMap&&this.lightMap.isTexture&&(i.lightMap=this.lightMap.toJSON(e).uuid,i.lightMapIntensity=this.lightMapIntensity),this.aoMap&&this.aoMap.isTexture&&(i.aoMap=this.aoMap.toJSON(e).uuid,i.aoMapIntensity=this.aoMapIntensity),this.bumpMap&&this.bumpMap.isTexture&&(i.bumpMap=this.bumpMap.toJSON(e).uuid,i.bumpScale=this.bumpScale),this.normalMap&&this.normalMap.isTexture&&(i.normalMap=this.normalMap.toJSON(e).uuid,i.normalMapType=this.normalMapType,i.normalScale=this.normalScale.toArray()),this.displacementMap&&this.displacementMap.isTexture&&(i.displacementMap=this.displacementMap.toJSON(e).uuid,i.displacementScale=this.displacementScale,i.displacementBias=this.displacementBias),this.roughnessMap&&this.roughnessMap.isTexture&&(i.roughnessMap=this.roughnessMap.toJSON(e).uuid),this.metalnessMap&&this.metalnessMap.isTexture&&(i.metalnessMap=this.metalnessMap.toJSON(e).uuid),this.emissiveMap&&this.emissiveMap.isTexture&&(i.emissiveMap=this.emissiveMap.toJSON(e).uuid),this.specularMap&&this.specularMap.isTexture&&(i.specularMap=this.specularMap.toJSON(e).uuid),this.specularIntensityMap&&this.specularIntensityMap.isTexture&&(i.specularIntensityMap=this.specularIntensityMap.toJSON(e).uuid),this.specularColorMap&&this.specularColorMap.isTexture&&(i.specularColorMap=this.specularColorMap.toJSON(e).uuid),this.envMap&&this.envMap.isTexture&&(i.envMap=this.envMap.toJSON(e).uuid,this.combine!==void 0&&(i.combine=this.combine)),this.envMapRotation!==void 0&&(i.envMapRotation=this.envMapRotation.toArray()),this.envMapIntensity!==void 0&&(i.envMapIntensity=this.envMapIntensity),this.reflectivity!==void 0&&(i.reflectivity=this.reflectivity),this.refractionRatio!==void 0&&(i.refractionRatio=this.refractionRatio),this.gradientMap&&this.gradientMap.isTexture&&(i.gradientMap=this.gradientMap.toJSON(e).uuid),this.transmission!==void 0&&(i.transmission=this.transmission),this.transmissionMap&&this.transmissionMap.isTexture&&(i.transmissionMap=this.transmissionMap.toJSON(e).uuid),this.thickness!==void 0&&(i.thickness=this.thickness),this.thicknessMap&&this.thicknessMap.isTexture&&(i.thicknessMap=this.thicknessMap.toJSON(e).uuid),this.attenuationDistance!==void 0&&this.attenuationDistance!==1/0&&(i.attenuationDistance=this.attenuationDistance),this.attenuationColor!==void 0&&(i.attenuationColor=this.attenuationColor.getHex()),this.size!==void 0&&(i.size=this.size),this.shadowSide!==null&&(i.shadowSide=this.shadowSide),this.sizeAttenuation!==void 0&&(i.sizeAttenuation=this.sizeAttenuation),this.blending!==1&&(i.blending=this.blending),this.side!==0&&(i.side=this.side),this.vertexColors===!0&&(i.vertexColors=!0),this.opacity<1&&(i.opacity=this.opacity),this.transparent===!0&&(i.transparent=!0),this.blendSrc!==204&&(i.blendSrc=this.blendSrc),this.blendDst!==205&&(i.blendDst=this.blendDst),this.blendEquation!==100&&(i.blendEquation=this.blendEquation),this.blendSrcAlpha!==null&&(i.blendSrcAlpha=this.blendSrcAlpha),this.blendDstAlpha!==null&&(i.blendDstAlpha=this.blendDstAlpha),this.blendEquationAlpha!==null&&(i.blendEquationAlpha=this.blendEquationAlpha),this.blendColor&&this.blendColor.isColor&&(i.blendColor=this.blendColor.getHex()),this.blendAlpha!==0&&(i.blendAlpha=this.blendAlpha),this.depthFunc!==3&&(i.depthFunc=this.depthFunc),this.depthTest===!1&&(i.depthTest=this.depthTest),this.depthWrite===!1&&(i.depthWrite=this.depthWrite),this.colorWrite===!1&&(i.colorWrite=this.colorWrite),this.stencilWriteMask!==255&&(i.stencilWriteMask=this.stencilWriteMask),this.stencilFunc!==519&&(i.stencilFunc=this.stencilFunc),this.stencilRef!==0&&(i.stencilRef=this.stencilRef),this.stencilFuncMask!==255&&(i.stencilFuncMask=this.stencilFuncMask),this.stencilFail!==Rn&&(i.stencilFail=this.stencilFail),this.stencilZFail!==Rn&&(i.stencilZFail=this.stencilZFail),this.stencilZPass!==Rn&&(i.stencilZPass=this.stencilZPass),this.stencilWrite===!0&&(i.stencilWrite=this.stencilWrite),this.rotation!==void 0&&this.rotation!==0&&(i.rotation=this.rotation),this.polygonOffset===!0&&(i.polygonOffset=!0),this.polygonOffsetFactor!==0&&(i.polygonOffsetFactor=this.polygonOffsetFactor),this.polygonOffsetUnits!==0&&(i.polygonOffsetUnits=this.polygonOffsetUnits),this.linewidth!==void 0&&this.linewidth!==1&&(i.linewidth=this.linewidth),this.dashSize!==void 0&&(i.dashSize=this.dashSize),this.gapSize!==void 0&&(i.gapSize=this.gapSize),this.scale!==void 0&&(i.scale=this.scale),this.dithering===!0&&(i.dithering=!0),this.alphaTest>0&&(i.alphaTest=this.alphaTest),this.alphaHash===!0&&(i.alphaHash=!0),this.alphaToCoverage===!0&&(i.alphaToCoverage=!0),this.premultipliedAlpha===!0&&(i.premultipliedAlpha=!0),this.forceSinglePass===!0&&(i.forceSinglePass=!0),this.allowOverride===!1&&(i.allowOverride=!1),this.wireframe===!0&&(i.wireframe=!0),this.wireframeLinewidth>1&&(i.wireframeLinewidth=this.wireframeLinewidth),this.wireframeLinecap!=="round"&&(i.wireframeLinecap=this.wireframeLinecap),this.wireframeLinejoin!=="round"&&(i.wireframeLinejoin=this.wireframeLinejoin),this.flatShading===!0&&(i.flatShading=!0),this.visible===!1&&(i.visible=!1),this.toneMapped===!1&&(i.toneMapped=!1),this.fog===!1&&(i.fog=!1),Object.keys(this.userData).length>0&&(i.userData=this.userData),t){let s=n(e.textures),a=n(e.images);s.length>0&&(i.textures=s),a.length>0&&(i.images=a)}return i}fromJSON(e,t){if(e.uuid!==void 0&&(this.uuid=e.uuid),e.name!==void 0&&(this.name=e.name),e.color!==void 0&&this.color!==void 0&&this.color.setHex(e.color),e.roughness!==void 0&&(this.roughness=e.roughness),e.metalness!==void 0&&(this.metalness=e.metalness),e.sheen!==void 0&&(this.sheen=e.sheen),e.sheenColor!==void 0&&(this.sheenColor=new Ie().setHex(e.sheenColor)),e.sheenRoughness!==void 0&&(this.sheenRoughness=e.sheenRoughness),e.emissive!==void 0&&this.emissive!==void 0&&this.emissive.setHex(e.emissive),e.specular!==void 0&&this.specular!==void 0&&this.specular.setHex(e.specular),e.specularIntensity!==void 0&&(this.specularIntensity=e.specularIntensity),e.specularColor!==void 0&&this.specularColor!==void 0&&this.specularColor.setHex(e.specularColor),e.shininess!==void 0&&(this.shininess=e.shininess),e.clearcoat!==void 0&&(this.clearcoat=e.clearcoat),e.clearcoatRoughness!==void 0&&(this.clearcoatRoughness=e.clearcoatRoughness),e.dispersion!==void 0&&(this.dispersion=e.dispersion),e.iridescence!==void 0&&(this.iridescence=e.iridescence),e.iridescenceIOR!==void 0&&(this.iridescenceIOR=e.iridescenceIOR),e.iridescenceThicknessRange!==void 0&&(this.iridescenceThicknessRange=e.iridescenceThicknessRange),e.transmission!==void 0&&(this.transmission=e.transmission),e.thickness!==void 0&&(this.thickness=e.thickness),e.attenuationDistance!==void 0&&(this.attenuationDistance=e.attenuationDistance),e.attenuationColor!==void 0&&this.attenuationColor!==void 0&&this.attenuationColor.setHex(e.attenuationColor),e.anisotropy!==void 0&&(this.anisotropy=e.anisotropy),e.anisotropyRotation!==void 0&&(this.anisotropyRotation=e.anisotropyRotation),e.fog!==void 0&&(this.fog=e.fog),e.flatShading!==void 0&&(this.flatShading=e.flatShading),e.blending!==void 0&&(this.blending=e.blending),e.combine!==void 0&&(this.combine=e.combine),e.side!==void 0&&(this.side=e.side),e.shadowSide!==void 0&&(this.shadowSide=e.shadowSide),e.opacity!==void 0&&(this.opacity=e.opacity),e.transparent!==void 0&&(this.transparent=e.transparent),e.alphaTest!==void 0&&(this.alphaTest=e.alphaTest),e.alphaHash!==void 0&&(this.alphaHash=e.alphaHash),e.depthFunc!==void 0&&(this.depthFunc=e.depthFunc),e.depthTest!==void 0&&(this.depthTest=e.depthTest),e.depthWrite!==void 0&&(this.depthWrite=e.depthWrite),e.colorWrite!==void 0&&(this.colorWrite=e.colorWrite),e.blendSrc!==void 0&&(this.blendSrc=e.blendSrc),e.blendDst!==void 0&&(this.blendDst=e.blendDst),e.blendEquation!==void 0&&(this.blendEquation=e.blendEquation),e.blendSrcAlpha!==void 0&&(this.blendSrcAlpha=e.blendSrcAlpha),e.blendDstAlpha!==void 0&&(this.blendDstAlpha=e.blendDstAlpha),e.blendEquationAlpha!==void 0&&(this.blendEquationAlpha=e.blendEquationAlpha),e.blendColor!==void 0&&this.blendColor!==void 0&&this.blendColor.setHex(e.blendColor),e.blendAlpha!==void 0&&(this.blendAlpha=e.blendAlpha),e.stencilWriteMask!==void 0&&(this.stencilWriteMask=e.stencilWriteMask),e.stencilFunc!==void 0&&(this.stencilFunc=e.stencilFunc),e.stencilRef!==void 0&&(this.stencilRef=e.stencilRef),e.stencilFuncMask!==void 0&&(this.stencilFuncMask=e.stencilFuncMask),e.stencilFail!==void 0&&(this.stencilFail=e.stencilFail),e.stencilZFail!==void 0&&(this.stencilZFail=e.stencilZFail),e.stencilZPass!==void 0&&(this.stencilZPass=e.stencilZPass),e.stencilWrite!==void 0&&(this.stencilWrite=e.stencilWrite),e.wireframe!==void 0&&(this.wireframe=e.wireframe),e.wireframeLinewidth!==void 0&&(this.wireframeLinewidth=e.wireframeLinewidth),e.wireframeLinecap!==void 0&&(this.wireframeLinecap=e.wireframeLinecap),e.wireframeLinejoin!==void 0&&(this.wireframeLinejoin=e.wireframeLinejoin),e.rotation!==void 0&&(this.rotation=e.rotation),e.linewidth!==void 0&&(this.linewidth=e.linewidth),e.dashSize!==void 0&&(this.dashSize=e.dashSize),e.gapSize!==void 0&&(this.gapSize=e.gapSize),e.scale!==void 0&&(this.scale=e.scale),e.polygonOffset!==void 0&&(this.polygonOffset=e.polygonOffset),e.polygonOffsetFactor!==void 0&&(this.polygonOffsetFactor=e.polygonOffsetFactor),e.polygonOffsetUnits!==void 0&&(this.polygonOffsetUnits=e.polygonOffsetUnits),e.dithering!==void 0&&(this.dithering=e.dithering),e.alphaToCoverage!==void 0&&(this.alphaToCoverage=e.alphaToCoverage),e.premultipliedAlpha!==void 0&&(this.premultipliedAlpha=e.premultipliedAlpha),e.forceSinglePass!==void 0&&(this.forceSinglePass=e.forceSinglePass),e.allowOverride!==void 0&&(this.allowOverride=e.allowOverride),e.visible!==void 0&&(this.visible=e.visible),e.toneMapped!==void 0&&(this.toneMapped=e.toneMapped),e.userData!==void 0&&(this.userData=e.userData),e.vertexColors!==void 0&&(typeof e.vertexColors=="number"?this.vertexColors=e.vertexColors>0:this.vertexColors=e.vertexColors),e.size!==void 0&&(this.size=e.size),e.sizeAttenuation!==void 0&&(this.sizeAttenuation=e.sizeAttenuation),e.map!==void 0&&(this.map=t[e.map]||null),e.matcap!==void 0&&(this.matcap=t[e.matcap]||null),e.alphaMap!==void 0&&(this.alphaMap=t[e.alphaMap]||null),e.bumpMap!==void 0&&(this.bumpMap=t[e.bumpMap]||null),e.bumpScale!==void 0&&(this.bumpScale=e.bumpScale),e.normalMap!==void 0&&(this.normalMap=t[e.normalMap]||null),e.normalMapType!==void 0&&(this.normalMapType=e.normalMapType),e.normalScale!==void 0){let i=e.normalScale;Array.isArray(i)===!1&&(i=[i,i]),this.normalScale=new te().fromArray(i)}return e.displacementMap!==void 0&&(this.displacementMap=t[e.displacementMap]||null),e.displacementScale!==void 0&&(this.displacementScale=e.displacementScale),e.displacementBias!==void 0&&(this.displacementBias=e.displacementBias),e.roughnessMap!==void 0&&(this.roughnessMap=t[e.roughnessMap]||null),e.metalnessMap!==void 0&&(this.metalnessMap=t[e.metalnessMap]||null),e.emissiveMap!==void 0&&(this.emissiveMap=t[e.emissiveMap]||null),e.emissiveIntensity!==void 0&&(this.emissiveIntensity=e.emissiveIntensity),e.specularMap!==void 0&&(this.specularMap=t[e.specularMap]||null),e.specularIntensityMap!==void 0&&(this.specularIntensityMap=t[e.specularIntensityMap]||null),e.specularColorMap!==void 0&&(this.specularColorMap=t[e.specularColorMap]||null),e.envMap!==void 0&&(this.envMap=t[e.envMap]||null),e.envMapRotation!==void 0&&this.envMapRotation.fromArray(e.envMapRotation),e.envMapIntensity!==void 0&&(this.envMapIntensity=e.envMapIntensity),e.reflectivity!==void 0&&(this.reflectivity=e.reflectivity),e.refractionRatio!==void 0&&(this.refractionRatio=e.refractionRatio),e.lightMap!==void 0&&(this.lightMap=t[e.lightMap]||null),e.lightMapIntensity!==void 0&&(this.lightMapIntensity=e.lightMapIntensity),e.aoMap!==void 0&&(this.aoMap=t[e.aoMap]||null),e.aoMapIntensity!==void 0&&(this.aoMapIntensity=e.aoMapIntensity),e.gradientMap!==void 0&&(this.gradientMap=t[e.gradientMap]||null),e.clearcoatMap!==void 0&&(this.clearcoatMap=t[e.clearcoatMap]||null),e.clearcoatRoughnessMap!==void 0&&(this.clearcoatRoughnessMap=t[e.clearcoatRoughnessMap]||null),e.clearcoatNormalMap!==void 0&&(this.clearcoatNormalMap=t[e.clearcoatNormalMap]||null),e.clearcoatNormalScale!==void 0&&(this.clearcoatNormalScale=new te().fromArray(e.clearcoatNormalScale)),e.iridescenceMap!==void 0&&(this.iridescenceMap=t[e.iridescenceMap]||null),e.iridescenceThicknessMap!==void 0&&(this.iridescenceThicknessMap=t[e.iridescenceThicknessMap]||null),e.transmissionMap!==void 0&&(this.transmissionMap=t[e.transmissionMap]||null),e.thicknessMap!==void 0&&(this.thicknessMap=t[e.thicknessMap]||null),e.anisotropyMap!==void 0&&(this.anisotropyMap=t[e.anisotropyMap]||null),e.sheenColorMap!==void 0&&(this.sheenColorMap=t[e.sheenColorMap]||null),e.sheenRoughnessMap!==void 0&&(this.sheenRoughnessMap=t[e.sheenRoughnessMap]||null),this}clone(){return new this.constructor().copy(this)}copy(e){this.name=e.name,this.blending=e.blending,this.side=e.side,this.vertexColors=e.vertexColors,this.opacity=e.opacity,this.transparent=e.transparent,this.blendSrc=e.blendSrc,this.blendDst=e.blendDst,this.blendEquation=e.blendEquation,this.blendSrcAlpha=e.blendSrcAlpha,this.blendDstAlpha=e.blendDstAlpha,this.blendEquationAlpha=e.blendEquationAlpha,this.blendColor.copy(e.blendColor),this.blendAlpha=e.blendAlpha,this.depthFunc=e.depthFunc,this.depthTest=e.depthTest,this.depthWrite=e.depthWrite,this.stencilWriteMask=e.stencilWriteMask,this.stencilFunc=e.stencilFunc,this.stencilRef=e.stencilRef,this.stencilFuncMask=e.stencilFuncMask,this.stencilFail=e.stencilFail,this.stencilZFail=e.stencilZFail,this.stencilZPass=e.stencilZPass,this.stencilWrite=e.stencilWrite;let t=e.clippingPlanes,i=null;if(t!==null){let n=t.length;i=new Array(n);for(let s=0;s!==n;++s)i[s]=t[s].clone()}return this.clippingPlanes=i,this.clipIntersection=e.clipIntersection,this.clipShadows=e.clipShadows,this.shadowSide=e.shadowSide,this.colorWrite=e.colorWrite,this.precision=e.precision,this.polygonOffset=e.polygonOffset,this.polygonOffsetFactor=e.polygonOffsetFactor,this.polygonOffsetUnits=e.polygonOffsetUnits,this.dithering=e.dithering,this.alphaTest=e.alphaTest,this.alphaHash=e.alphaHash,this.alphaToCoverage=e.alphaToCoverage,this.premultipliedAlpha=e.premultipliedAlpha,this.forceSinglePass=e.forceSinglePass,this.allowOverride=e.allowOverride,this.visible=e.visible,this.toneMapped=e.toneMapped,this.userData=JSON.parse(JSON.stringify(e.userData)),this}dispose(){this.dispatchEvent({type:"dispose"})}set needsUpdate(e){e===!0&&this.version++}},pn=class extends mi{constructor(e){super(),this.isSpriteMaterial=!0,this.type="SpriteMaterial",this.color=new Ie(16777215),this.map=null,this.alphaMap=null,this.rotation=0,this.sizeAttenuation=!0,this.transparent=!0,this.fog=!0,this.setValues(e)}copy(e){return super.copy(e),this.color.copy(e.color),this.map=e.map,this.alphaMap=e.alphaMap,this.rotation=e.rotation,this.sizeAttenuation=e.sizeAttenuation,this.fog=e.fog,this}},Kr=new w,ar=new w,or=new w,lr=new te,$r=new te,yd=new Fe,ea=new w,Qr=new w,ta=new w,ou=new te,bl=new te,lu=new te,In=class extends Tt{constructor(e=new pn){if(super(),this.isSprite=!0,this.type="Sprite",sr===void 0){sr=new Xe;let t=new Float32Array([-.5,-.5,0,0,0,.5,-.5,0,1,0,.5,.5,0,1,1,-.5,.5,0,0,1]),i=new Da(t,5);sr.setIndex([0,1,2,0,2,3]),sr.setAttribute("position",new ms(i,3,0,!1)),sr.setAttribute("uv",new ms(i,2,3,!1))}this.geometry=sr,this.material=e,this.center=new te(.5,.5),this.count=1}raycast(e,t){e.camera===null&&we('Sprite: "Raycaster.camera" needs to be set in order to raycast against sprites.'),ar.setFromMatrixScale(this.matrixWorld),yd.copy(e.camera.matrixWorld),this.modelViewMatrix.multiplyMatrices(e.camera.matrixWorldInverse,this.matrixWorld),or.setFromMatrixPosition(this.modelViewMatrix),e.camera.isPerspectiveCamera&&this.material.sizeAttenuation===!1&&ar.multiplyScalar(-or.z);let i=this.material.rotation,n,s;i!==0&&(s=Math.cos(i),n=Math.sin(i));let a=this.center;ia(ea.set(-.5,-.5,0),or,a,ar,n,s),ia(Qr.set(.5,-.5,0),or,a,ar,n,s),ia(ta.set(.5,.5,0),or,a,ar,n,s),ou.set(0,0),bl.set(1,0),lu.set(1,1);let o=e.ray.intersectTriangle(ea,Qr,ta,!1,Kr);if(o===null&&(ia(Qr.set(-.5,.5,0),or,a,ar,n,s),bl.set(0,1),o=e.ray.intersectTriangle(ea,ta,Qr,!1,Kr),o===null))return;let c=e.ray.origin.distanceTo(Kr);c<e.near||c>e.far||t.push({distance:c,point:Kr.clone(),uv:wi.getInterpolation(Kr,ea,Qr,ta,ou,bl,lu,new te),face:null,object:this})}copy(e,t){return super.copy(e,t),e.center!==void 0&&this.center.copy(e.center),this.material=e.material,this}};function ia(r,e,t,i,n,s){lr.subVectors(r,t).addScalar(.5).multiply(i),n!==void 0?($r.x=s*lr.x-n*lr.y,$r.y=n*lr.x+s*lr.y):$r.copy(lr),r.copy(e),r.x+=$r.x,r.y+=$r.y,r.applyMatrix4(yd)}var og=new w,lg=new w;var Hi=new w,Tl=new w,na=new w,ln=new w,El=new w,ra=new w,wl=new w,Ln=class{constructor(e=new w,t=new w(0,0,-1)){this.origin=e,this.direction=t}set(e,t){return this.origin.copy(e),this.direction.copy(t),this}copy(e){return this.origin.copy(e.origin),this.direction.copy(e.direction),this}at(e,t){return t.copy(this.origin).addScaledVector(this.direction,e)}lookAt(e){return this.direction.copy(e).sub(this.origin).normalize(),this}recast(e){return this.origin.copy(this.at(e,Hi)),this}closestPointToPoint(e,t){t.subVectors(e,this.origin);let i=t.dot(this.direction);return i<0?t.copy(this.origin):t.copy(this.origin).addScaledVector(this.direction,i)}distanceToPoint(e){return Math.sqrt(this.distanceSqToPoint(e))}distanceSqToPoint(e){let t=Hi.subVectors(e,this.origin).dot(this.direction);return t<0?this.origin.distanceToSquared(e):(Hi.copy(this.origin).addScaledVector(this.direction,t),Hi.distanceToSquared(e))}distanceSqToSegment(e,t,i,n){Tl.copy(e).add(t).multiplyScalar(.5),na.copy(t).sub(e).normalize(),ln.copy(this.origin).sub(Tl);let s=.5*e.distanceTo(t),a=-this.direction.dot(na),o=ln.dot(this.direction),c=-ln.dot(na),l=ln.lengthSq(),h=Math.abs(1-a*a),d,p,u,g;if(h>0)if(d=a*c-o,p=a*o-c,g=s*h,d>=0)if(p>=-g)if(p<=g){let m=1/h;d*=m,p*=m,u=d*(d+a*p+2*o)+p*(a*d+p+2*c)+l}else p=s,d=Math.max(0,-(a*p+o)),u=-d*d+p*(p+2*c)+l;else p=-s,d=Math.max(0,-(a*p+o)),u=-d*d+p*(p+2*c)+l;else p<=-g?(d=Math.max(0,-(-a*s+o)),p=d>0?-s:Math.min(Math.max(-s,-c),s),u=-d*d+p*(p+2*c)+l):p<=g?(d=0,p=Math.min(Math.max(-s,-c),s),u=p*(p+2*c)+l):(d=Math.max(0,-(a*s+o)),p=d>0?s:Math.min(Math.max(-s,-c),s),u=-d*d+p*(p+2*c)+l);else p=a>0?-s:s,d=Math.max(0,-(a*p+o)),u=-d*d+p*(p+2*c)+l;return i&&i.copy(this.origin).addScaledVector(this.direction,d),n&&n.copy(Tl).addScaledVector(na,p),u}intersectSphere(e,t){Hi.subVectors(e.center,this.origin);let i=Hi.dot(this.direction),n=Hi.dot(Hi)-i*i,s=e.radius*e.radius;if(n>s)return null;let a=Math.sqrt(s-n),o=i-a,c=i+a;return c<0?null:o<0?this.at(c,t):this.at(o,t)}intersectsSphere(e){return!(e.radius<0)&&this.distanceSqToPoint(e.center)<=e.radius*e.radius}distanceToPlane(e){let t=e.normal.dot(this.direction);if(t===0)return e.distanceToPoint(this.origin)===0?0:null;let i=-(this.origin.dot(e.normal)+e.constant)/t;return i>=0?i:null}intersectPlane(e,t){let i=this.distanceToPlane(e);return i===null?null:this.at(i,t)}intersectsPlane(e){let t=e.distanceToPoint(this.origin);return t===0?!0:e.normal.dot(this.direction)*t<0}intersectBox(e,t){let i,n,s,a,o,c,l=1/this.direction.x,h=1/this.direction.y,d=1/this.direction.z,p=this.origin;return l>=0?(i=(e.min.x-p.x)*l,n=(e.max.x-p.x)*l):(i=(e.max.x-p.x)*l,n=(e.min.x-p.x)*l),h>=0?(s=(e.min.y-p.y)*h,a=(e.max.y-p.y)*h):(s=(e.max.y-p.y)*h,a=(e.min.y-p.y)*h),i>a||s>n?null:((s>i||isNaN(i))&&(i=s),(a<n||isNaN(n))&&(n=a),d>=0?(o=(e.min.z-p.z)*d,c=(e.max.z-p.z)*d):(o=(e.max.z-p.z)*d,c=(e.min.z-p.z)*d),i>c||o>n?null:((o>i||i!=i)&&(i=o),(c<n||n!=n)&&(n=c),n<0?null:this.at(i>=0?i:n,t)))}intersectsBox(e){return this.intersectBox(e,Hi)!==null}intersectTriangle(e,t,i,n,s){El.subVectors(t,e),ra.subVectors(i,e),wl.crossVectors(El,ra);let a,o=this.direction.dot(wl);if(o>0){if(n)return null;a=1}else{if(!(o<0))return null;a=-1,o=-o}ln.subVectors(this.origin,e);let c=a*this.direction.dot(ra.crossVectors(ln,ra));if(c<0)return null;let l=a*this.direction.dot(El.cross(ln));if(l<0||c+l>o)return null;let h=-a*ln.dot(wl);return h<0?null:this.at(h/o,s)}applyMatrix4(e){return this.origin.applyMatrix4(e),this.direction.transformDirection(e),this}equals(e){return e.origin.equals(this.origin)&&e.direction.equals(this.direction)}clone(){return new this.constructor().copy(this)}},Et=class extends mi{constructor(e){super(),this.isMeshBasicMaterial=!0,this.type="MeshBasicMaterial",this.color=new Ie(16777215),this.map=null,this.lightMap=null,this.lightMapIntensity=1,this.aoMap=null,this.aoMapIntensity=1,this.specularMap=null,this.alphaMap=null,this.envMap=null,this.envMapRotation=new Xi,this.combine=0,this.reflectivity=1,this.refractionRatio=.98,this.wireframe=!1,this.wireframeLinewidth=1,this.wireframeLinecap="round",this.wireframeLinejoin="round",this.fog=!0,this.setValues(e)}copy(e){return super.copy(e),this.color.copy(e.color),this.map=e.map,this.lightMap=e.lightMap,this.lightMapIntensity=e.lightMapIntensity,this.aoMap=e.aoMap,this.aoMapIntensity=e.aoMapIntensity,this.specularMap=e.specularMap,this.alphaMap=e.alphaMap,this.envMap=e.envMap,this.envMapRotation.copy(e.envMapRotation),this.combine=e.combine,this.reflectivity=e.reflectivity,this.refractionRatio=e.refractionRatio,this.wireframe=e.wireframe,this.wireframeLinewidth=e.wireframeLinewidth,this.wireframeLinecap=e.wireframeLinecap,this.wireframeLinejoin=e.wireframeLinejoin,this.fog=e.fog,this}},cu=new Fe,An=new Ln,sa=new pi,hu=new w,aa=new w,oa=new w,la=new w,Al=new w,ca=new w,uu=new w,ha=new w,Oe=class extends Tt{constructor(e=new Xe,t=new Et){super(),this.isMesh=!0,this.type="Mesh",this.geometry=e,this.material=t,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.count=1,this.updateMorphTargets()}copy(e,t){return super.copy(e,t),e.morphTargetInfluences!==void 0&&(this.morphTargetInfluences=e.morphTargetInfluences.slice()),e.morphTargetDictionary!==void 0&&(this.morphTargetDictionary=Object.assign({},e.morphTargetDictionary)),this.material=Array.isArray(e.material)?e.material.slice():e.material,this.geometry=e.geometry,this}updateMorphTargets(){let e=this.geometry.morphAttributes,t=Object.keys(e);if(t.length>0){let i=e[t[0]];if(i!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let n=0,s=i.length;n<s;n++){let a=i[n].name||String(n);this.morphTargetInfluences.push(0),this.morphTargetDictionary[a]=n}}}}getVertexPosition(e,t){let i=this.geometry,n=i.attributes.position,s=i.morphAttributes.position,a=i.morphTargetsRelative;t.fromBufferAttribute(n,e);let o=this.morphTargetInfluences;if(s&&o){ca.set(0,0,0);for(let c=0,l=s.length;c<l;c++){let h=o[c],d=s[c];h!==0&&(Al.fromBufferAttribute(d,e),a?ca.addScaledVector(Al,h):ca.addScaledVector(Al.sub(t),h))}t.add(ca)}return t}raycast(e,t){let i=this.geometry,n=this.material,s=this.matrixWorld;if(n!==void 0){if(i.boundingSphere===null&&i.computeBoundingSphere(),sa.copy(i.boundingSphere),sa.applyMatrix4(s),An.copy(e.ray).recast(e.near),sa.containsPoint(An.origin)===!1&&(An.intersectSphere(sa,hu)===null||An.origin.distanceToSquared(hu)>(e.far-e.near)**2))return;cu.copy(s).invert(),An.copy(e.ray).applyMatrix4(cu),i.boundingBox!==null&&An.intersectsBox(i.boundingBox)===!1||this._computeIntersections(e,t,An)}}_computeIntersections(e,t,i){let n,s=this.geometry,a=this.material,o=s.index,c=s.attributes.position,l=s.attributes.uv,h=s.attributes.uv1,d=s.attributes.normal,p=s.groups,u=s.drawRange;if(o!==null)if(Array.isArray(a))for(let g=0,m=p.length;g<m;g++){let v=p[g],f=a[v.materialIndex];for(let _=Math.max(v.start,u.start),x=Math.min(o.count,Math.min(v.start+v.count,u.start+u.count));_<x;_+=3)n=ua(this,f,e,i,l,h,d,o.getX(_),o.getX(_+1),o.getX(_+2)),n&&(n.faceIndex=Math.floor(_/3),n.face.materialIndex=v.materialIndex,t.push(n))}else for(let g=Math.max(0,u.start),m=Math.min(o.count,u.start+u.count);g<m;g+=3)n=ua(this,a,e,i,l,h,d,o.getX(g),o.getX(g+1),o.getX(g+2)),n&&(n.faceIndex=Math.floor(g/3),t.push(n));else if(c!==void 0)if(Array.isArray(a))for(let g=0,m=p.length;g<m;g++){let v=p[g],f=a[v.materialIndex];for(let _=Math.max(v.start,u.start),x=Math.min(c.count,Math.min(v.start+v.count,u.start+u.count));_<x;_+=3)n=ua(this,f,e,i,l,h,d,_,_+1,_+2),n&&(n.faceIndex=Math.floor(_/3),n.face.materialIndex=v.materialIndex,t.push(n))}else for(let g=Math.max(0,u.start),m=Math.min(c.count,u.start+u.count);g<m;g+=3)n=ua(this,a,e,i,l,h,d,g,g+1,g+2),n&&(n.faceIndex=Math.floor(g/3),t.push(n))}};function ua(r,e,t,i,n,s,a,o,c,l){r.getVertexPosition(o,aa),r.getVertexPosition(c,oa),r.getVertexPosition(l,la);let h=(function(d,p,u,g,m,v,f,_){let x;if(x=p.side===1?g.intersectTriangle(f,v,m,!0,_):g.intersectTriangle(m,v,f,p.side===0,_),x===null)return null;ha.copy(_),ha.applyMatrix4(d.matrixWorld);let S=u.ray.origin.distanceTo(ha);return S<u.near||S>u.far?null:{distance:S,point:ha.clone(),object:d}})(r,e,t,i,aa,oa,la,uu);if(h){let d=new w;wi.getBarycoord(uu,aa,oa,la,d),n&&(h.uv=wi.getInterpolatedAttribute(n,o,c,l,d,new te)),s&&(h.uv1=wi.getInterpolatedAttribute(s,o,c,l,d,new te)),a&&(h.normal=wi.getInterpolatedAttribute(a,o,c,l,d,new w),h.normal.dot(i.direction)>0&&h.normal.multiplyScalar(-1));let p={a:o,b:c,c:l,normal:new w,materialIndex:0};wi.getNormal(aa,oa,la,p.normal),h.face=p,h.barycoord=d}return h}var cg=new $e,hg=new $e,ug=new $e,dg=new $e,pg=new Fe,mg=new w,fg=new pi,gg=new Fe,_g=new Ln;var Ua=class extends Nt{constructor(e=null,t=1,i=1,n,s,a,o,c,l=1003,h=1003,d,p){super(null,a,o,c,l,h,n,s,d,p),this.isDataTexture=!0,this.image={data:e,width:t,height:i},this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1}},vg=new Fe,xg=new Fe;var yg=new Fe,Mg=new Fe;var Sg=new di,bg=new Fe,Tg=new Oe,Eg=new pi;var Cl=new w,Xp=new w,jp=new Ne,Ei=class{constructor(e=new w(1,0,0),t=0){this.isPlane=!0,this.normal=e,this.constant=t}set(e,t){return this.normal.copy(e),this.constant=t,this}setComponents(e,t,i,n){return this.normal.set(e,t,i),this.constant=n,this}setFromNormalAndCoplanarPoint(e,t){return this.normal.copy(e),this.constant=-t.dot(this.normal),this}setFromCoplanarPoints(e,t,i){let n=Cl.subVectors(i,t).cross(Xp.subVectors(e,t)).normalize();return this.setFromNormalAndCoplanarPoint(n,e),this}copy(e){return this.normal.copy(e.normal),this.constant=e.constant,this}normalize(){let e=1/this.normal.length();return this.normal.multiplyScalar(e),this.constant*=e,this}negate(){return this.constant*=-1,this.normal.negate(),this}distanceToPoint(e){return this.normal.dot(e)+this.constant}distanceToSphere(e){return this.distanceToPoint(e.center)-e.radius}projectPoint(e,t){return t.copy(e).addScaledVector(this.normal,-this.distanceToPoint(e))}intersectLine(e,t,i=!0){let n=e.delta(Cl),s=this.normal.dot(n);if(s===0)return this.distanceToPoint(e.start)===0?t.copy(e.start):null;let a=-(e.start.dot(this.normal)+this.constant)/s;return i===!0&&(a<0||a>1)?null:t.copy(e.start).addScaledVector(n,a)}intersectsLine(e){let t=this.distanceToPoint(e.start),i=this.distanceToPoint(e.end);return t<0&&i>0||i<0&&t>0}intersectsBox(e){return e.intersectsPlane(this)}intersectsSphere(e){return e.intersectsPlane(this)}coplanarPoint(e){return e.copy(this.normal).multiplyScalar(-this.constant)}applyMatrix4(e,t){let i=t||jp.getNormalMatrix(e),n=this.coplanarPoint(Cl).applyMatrix4(e),s=this.normal.applyMatrix3(i).normalize();return this.constant=-n.dot(s),this}translate(e){return this.constant-=e.dot(this.normal),this}equals(e){return e.normal.equals(this.normal)&&e.constant===this.constant}clone(){return new this.constructor().copy(this)}},Cn=new pi,qp=new te(.5,.5),da=new w,ji=class{constructor(e=new Ei,t=new Ei,i=new Ei,n=new Ei,s=new Ei,a=new Ei){this.planes=[e,t,i,n,s,a]}set(e,t,i,n,s,a){let o=this.planes;return o[0].copy(e),o[1].copy(t),o[2].copy(i),o[3].copy(n),o[4].copy(s),o[5].copy(a),this}copy(e){let t=this.planes;for(let i=0;i<6;i++)t[i].copy(e.planes[i]);return this}setFromProjectionMatrix(e,t=2e3,i=!1){let n=this.planes,s=e.elements,a=s[0],o=s[1],c=s[2],l=s[3],h=s[4],d=s[5],p=s[6],u=s[7],g=s[8],m=s[9],v=s[10],f=s[11],_=s[12],x=s[13],S=s[14],T=s[15];if(n[0].setComponents(l-a,u-h,f-g,T-_).normalize(),n[1].setComponents(l+a,u+h,f+g,T+_).normalize(),n[2].setComponents(l+o,u+d,f+m,T+x).normalize(),n[3].setComponents(l-o,u-d,f-m,T-x).normalize(),i)n[4].setComponents(c,p,v,S).normalize(),n[5].setComponents(l-c,u-p,f-v,T-S).normalize();else if(n[4].setComponents(l-c,u-p,f-v,T-S).normalize(),t===Wi)n[5].setComponents(l+c,u+p,f+v,T+S).normalize();else{if(t!==pr)throw new Error("THREE.Frustum.setFromProjectionMatrix(): Invalid coordinate system: "+t);n[5].setComponents(c,p,v,S).normalize()}return this}intersectsObject(e){if(e.boundingSphere!==void 0)e.boundingSphere===null&&e.computeBoundingSphere(),Cn.copy(e.boundingSphere).applyMatrix4(e.matrixWorld);else{let t=e.geometry;t.boundingSphere===null&&t.computeBoundingSphere(),Cn.copy(t.boundingSphere).applyMatrix4(e.matrixWorld)}return this.intersectsSphere(Cn)}intersectsSprite(e){Cn.center.set(0,0,0);let t=qp.distanceTo(e.center);return Cn.radius=.7071067811865476+t,Cn.applyMatrix4(e.matrixWorld),this.intersectsSphere(Cn)}intersectsSphere(e){let t=this.planes,i=e.center,n=-e.radius;for(let s=0;s<6;s++)if(t[s].distanceToPoint(i)<n)return!1;return!0}intersectsBox(e){let t=this.planes;for(let i=0;i<6;i++){let n=t[i];if(da.x=n.normal.x>0?e.max.x:e.min.x,da.y=n.normal.y>0?e.max.y:e.min.y,da.z=n.normal.z>0?e.max.z:e.min.z,n.distanceToPoint(da)<0)return!1}return!0}containsPoint(e){let t=this.planes;for(let i=0;i<6;i++)if(t[i].distanceToPoint(e)<0)return!1;return!0}clone(){return new this.constructor().copy(this)}},du=new Fe,Fa=class r{constructor(){this.coordinateSystem=Wi,this._frustums=[],this._count=0}setFromArrayCamera(e){let t=e.cameras,i=this._frustums;for(let n=0;n<t.length;n++){let s=t[n];du.multiplyMatrices(s.projectionMatrix,s.matrixWorldInverse),i[n]===void 0&&(i[n]=new ji),i[n].setFromProjectionMatrix(du,s.coordinateSystem,s.reversedDepth)}return this._count=t.length,this}intersectsObject(e){let t=this._frustums;for(let i=0;i<this._count;i++)if(t[i].intersectsObject(e))return!0;return!1}intersectsSprite(e){let t=this._frustums;for(let i=0;i<this._count;i++)if(t[i].intersectsSprite(e))return!0;return!1}intersectsSphere(e){let t=this._frustums;for(let i=0;i<this._count;i++)if(t[i].intersectsSphere(e))return!0;return!1}intersectsBox(e){let t=this._frustums;for(let i=0;i<this._count;i++)if(t[i].intersectsBox(e))return!0;return!1}containsPoint(e){let t=this._frustums;for(let i=0;i<this._count;i++)if(t[i].containsPoint(e))return!0;return!1}copy(e){this.coordinateSystem=e.coordinateSystem;let t=this._frustums,i=e._frustums;for(let n=0;n<e._count;n++)t[n]===void 0&&(t[n]=new ji),t[n].copy(i[n]);return this._count=e._count,this}clone(){return new r().copy(this)}};var Vl=class{constructor(){this.index=0,this.pool=[],this.list=[]}push(e,t,i,n){let s=this.pool,a=this.list;this.index>=s.length&&s.push({start:-1,count:-1,z:-1,index:-1});let o=s[this.index];a.push(o),this.index++,o.start=e,o.count=t,o.z=i,o.index=n}reset(){this.list.length=0,this.index=0}},wg=new Fe,Ag=new Ie(1,1,1),Cg=new ji,Rg=new Fa,Pg=new di,Ig=new pi,Lg=new w,Ng=new w,Dg=new w,Ug=new Vl,Fg=new Oe;var qi=class extends mi{constructor(e){super(),this.isLineBasicMaterial=!0,this.type="LineBasicMaterial",this.color=new Ie(16777215),this.map=null,this.linewidth=1,this.linecap="round",this.linejoin="round",this.fog=!0,this.setValues(e)}copy(e){return super.copy(e),this.color.copy(e.color),this.map=e.map,this.linewidth=e.linewidth,this.linecap=e.linecap,this.linejoin=e.linejoin,this.fog=e.fog,this}},Oa=new w,Ba=new w,pu=new Fe,es=new Ln,pa=new pi,Rl=new w,mu=new w,xr=class extends Tt{constructor(e=new Xe,t=new qi){super(),this.isLine=!0,this.type="Line",this.geometry=e,this.material=t,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.updateMorphTargets()}copy(e,t){return super.copy(e,t),this.material=Array.isArray(e.material)?e.material.slice():e.material,this.geometry=e.geometry,this}computeLineDistances(){let e=this.geometry;if(e.index===null){let t=e.attributes.position,i=[0];for(let n=1,s=t.count;n<s;n++)Oa.fromBufferAttribute(t,n-1),Ba.fromBufferAttribute(t,n),i[n]=i[n-1],i[n]+=Oa.distanceTo(Ba);e.setAttribute("lineDistance",new Te(i,1))}else be("Line.computeLineDistances(): Computation only possible with non-indexed BufferGeometry.");return this}raycast(e,t){let i=this.geometry,n=this.matrixWorld,s=e.params.Line.threshold,a=i.drawRange;if(i.boundingSphere===null&&i.computeBoundingSphere(),pa.copy(i.boundingSphere),pa.applyMatrix4(n),pa.radius+=s,e.ray.intersectsSphere(pa)===!1)return;pu.copy(n).invert(),es.copy(e.ray).applyMatrix4(pu);let o=s/((this.scale.x+this.scale.y+this.scale.z)/3),c=o*o,l=this.isLineSegments?2:1,h=i.index,d=i.attributes.position;if(h!==null){let p=Math.max(0,a.start),u=Math.min(h.count,a.start+a.count);for(let g=p,m=u-1;g<m;g+=l){let v=h.getX(g),f=h.getX(g+1),_=ma(this,e,es,c,v,f,g);_&&t.push(_)}if(this.isLineLoop){let g=h.getX(u-1),m=h.getX(p),v=ma(this,e,es,c,g,m,u-1);v&&t.push(v)}}else{let p=Math.max(0,a.start),u=Math.min(d.count,a.start+a.count);for(let g=p,m=u-1;g<m;g+=l){let v=ma(this,e,es,c,g,g+1,g);v&&t.push(v)}if(this.isLineLoop){let g=ma(this,e,es,c,u-1,p,u-1);g&&t.push(g)}}}updateMorphTargets(){let e=this.geometry.morphAttributes,t=Object.keys(e);if(t.length>0){let i=e[t[0]];if(i!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let n=0,s=i.length;n<s;n++){let a=i[n].name||String(n);this.morphTargetInfluences.push(0),this.morphTargetDictionary[a]=n}}}}};function ma(r,e,t,i,n,s,a){let o=r.geometry.attributes.position;if(Oa.fromBufferAttribute(o,n),Ba.fromBufferAttribute(o,s),t.distanceSqToSegment(Oa,Ba,Rl,mu)>i)return;Rl.applyMatrix4(r.matrixWorld);let c=e.ray.origin.distanceTo(Rl);return c<e.near||c>e.far?void 0:{distance:c,point:mu.clone().applyMatrix4(r.matrixWorld),index:a,face:null,faceIndex:null,barycoord:null,object:r}}var fu=new w,gu=new w,Nn=class extends xr{constructor(e,t){super(e,t),this.isLineSegments=!0,this.type="LineSegments"}computeLineDistances(){let e=this.geometry;if(e.index===null){let t=e.attributes.position,i=[];for(let n=0,s=t.count;n<s;n+=2)fu.fromBufferAttribute(t,n),gu.fromBufferAttribute(t,n+1),i[n]=n===0?0:i[n-1],i[n+1]=i[n]+fu.distanceTo(gu);e.setAttribute("lineDistance",new Te(i,1))}else be("LineSegments.computeLineDistances(): Computation only possible with non-indexed BufferGeometry.");return this}};var yr=class extends mi{constructor(e){super(),this.isPointsMaterial=!0,this.type="PointsMaterial",this.color=new Ie(16777215),this.map=null,this.alphaMap=null,this.size=1,this.sizeAttenuation=!0,this.fog=!0,this.setValues(e)}copy(e){return super.copy(e),this.color.copy(e.color),this.map=e.map,this.alphaMap=e.alphaMap,this.size=e.size,this.sizeAttenuation=e.sizeAttenuation,this.fog=e.fog,this}},_u=new Fe,Hl=new Ln,fa=new pi,ga=new w,fs=class extends Tt{constructor(e=new Xe,t=new yr){super(),this.isPoints=!0,this.type="Points",this.geometry=e,this.material=t,this.morphTargetDictionary=void 0,this.morphTargetInfluences=void 0,this.updateMorphTargets()}copy(e,t){return super.copy(e,t),this.material=Array.isArray(e.material)?e.material.slice():e.material,this.geometry=e.geometry,this}raycast(e,t){let i=this.geometry,n=this.matrixWorld,s=e.params.Points.threshold,a=i.drawRange;if(i.boundingSphere===null&&i.computeBoundingSphere(),fa.copy(i.boundingSphere),fa.applyMatrix4(n),fa.radius+=s,e.ray.intersectsSphere(fa)===!1)return;_u.copy(n).invert(),Hl.copy(e.ray).applyMatrix4(_u);let o=s/((this.scale.x+this.scale.y+this.scale.z)/3),c=o*o,l=i.index,h=i.attributes.position;if(l!==null)for(let d=Math.max(0,a.start),p=Math.min(l.count,a.start+a.count);d<p;d++){let u=l.getX(d);ga.fromBufferAttribute(h,u),vu(ga,u,c,n,e,t,this)}else for(let d=Math.max(0,a.start),p=Math.min(h.count,a.start+a.count);d<p;d++)ga.fromBufferAttribute(h,d),vu(ga,d,c,n,e,t,this)}updateMorphTargets(){let e=this.geometry.morphAttributes,t=Object.keys(e);if(t.length>0){let i=e[t[0]];if(i!==void 0){this.morphTargetInfluences=[],this.morphTargetDictionary={};for(let n=0,s=i.length;n<s;n++){let a=i[n].name||String(n);this.morphTargetInfluences.push(0),this.morphTargetDictionary[a]=n}}}}};function vu(r,e,t,i,n,s,a){let o=Hl.distanceSqToPoint(r);if(o<t){let c=new w;Hl.closestPointToPoint(r,c),c.applyMatrix4(i);let l=n.ray.origin.distanceTo(c);if(l<n.near||l>n.far)return;s.push({distance:l,distanceToRay:Math.sqrt(o),point:c,index:e,face:null,faceIndex:null,barycoord:null,object:a})}}var gs=class extends Nt{constructor(e=[],t=301,i,n,s,a,o,c,l,h){super(e,t,i,n,s,a,o,c,l,h),this.isCubeTexture=!0,this.flipY=!1}get images(){return this.image}set images(e){this.image=e}},Yi=class extends Nt{constructor(e,t,i,n,s,a,o,c,l){super(e,t,i,n,s,a,o,c,l),this.isCanvasTexture=!0,this.needsUpdate=!0}};var Zi=class extends Nt{constructor(e,t,i=1014,n,s,a,o=1003,c=1003,l,h=1026,d=1){if(h!==vn&&h!==1027)throw new Error("THREE.DepthTexture: format must be either THREE.DepthFormat or THREE.DepthStencilFormat");super({width:e,height:t,depth:d},n,s,a,o,c,h,i,l),this.isDepthTexture=!0,this.flipY=!1,this.generateMipmaps=!1,this.compareFunction=null}copy(e){return super.copy(e),this.source=new _r(Object.assign({},e.image)),this.compareFunction=e.compareFunction,this}toJSON(e){let t=super.toJSON(e);return this.compareFunction!==null&&(t.compareFunction=this.compareFunction),t}},za=class extends Zi{constructor(e,t=1014,i=301,n,s,a=1003,o=1003,c,l=1026){let h={width:e,height:e,depth:1},d=[h,h,h,h,h,h];super(e,e,t,i,n,s,a,o,c,l),this.image=d,this.isCubeDepthTexture=!0,this.isCubeTexture=!0}get images(){return this.image}set images(e){this.image=e}},_s=class extends Nt{constructor(e=null){super(),this.sourceTexture=e,this.isExternalTexture=!0}copy(e){return super.copy(e),this.sourceTexture=e.sourceTexture,this}},qt=class r extends Xe{constructor(e=1,t=1,i=1,n=1,s=1,a=1){super(),this.type="BoxGeometry",this.parameters={width:e,height:t,depth:i,widthSegments:n,heightSegments:s,depthSegments:a};let o=this;n=Math.floor(n),s=Math.floor(s),a=Math.floor(a);let c=[],l=[],h=[],d=[],p=0,u=0;function g(m,v,f,_,x,S,T,M,P,O,L){let I=S/P,B=T/O,U=S/2,X=T/2,k=M/2,V=P+1,Y=O+1,W=0,ne=0,pe=new w;for(let Ee=0;Ee<Y;Ee++){let _e=Ee*B-X;for(let ve=0;ve<V;ve++){let ie=ve*I-U;pe[m]=ie*_,pe[v]=_e*x,pe[f]=k,l.push(pe.x,pe.y,pe.z),pe[m]=0,pe[v]=0,pe[f]=M>0?1:-1,h.push(pe.x,pe.y,pe.z),d.push(ve/P),d.push(1-Ee/O),W+=1}}for(let Ee=0;Ee<O;Ee++)for(let _e=0;_e<P;_e++){let ve=p+_e+V*Ee,ie=p+_e+V*(Ee+1),he=p+(_e+1)+V*(Ee+1),le=p+(_e+1)+V*Ee;c.push(ve,ie,le),c.push(ie,he,le),ne+=6}o.addGroup(u,ne,L),u+=ne,p+=W}g("z","y","x",-1,-1,i,t,e,a,s,0),g("z","y","x",1,-1,i,t,-e,a,s,1),g("x","z","y",1,1,e,i,t,n,a,2),g("x","z","y",1,-1,e,i,-t,n,a,3),g("x","y","z",1,-1,e,t,i,n,s,4),g("x","y","z",-1,-1,e,t,-i,n,s,5),this.setIndex(c),this.setAttribute("position",new Te(l,3)),this.setAttribute("normal",new Te(h,3)),this.setAttribute("uv",new Te(d,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.width,e.height,e.depth,e.widthSegments,e.heightSegments,e.depthSegments)}},Ga=class r extends Xe{constructor(e=1,t=1,i=4,n=8,s=1){super(),this.type="CapsuleGeometry",this.parameters={radius:e,height:t,capSegments:i,radialSegments:n,heightSegments:s},t=Math.max(0,t),i=Math.max(1,Math.floor(i)),n=Math.max(3,Math.floor(n)),s=Math.max(1,Math.floor(s));let a=[],o=[],c=[],l=[],h=t/2,d=Math.PI/2*e,p=t,u=2*d+p,g=2*i+s,m=n+1,v=new w,f=new w;for(let _=0;_<=g;_++){let x=0,S=0,T=0,M=0;if(_<=i){let L=_/i,I=L*Math.PI/2;S=-h-e*Math.cos(I),T=e*Math.sin(I),M=-e*Math.cos(I),x=L*d}else if(_<=i+s){let L=(_-i)/s;S=L*t-h,T=e,M=0,x=d+L*p}else{let L=(_-i-s)/i,I=L*Math.PI/2;S=h+e*Math.sin(I),T=e*Math.cos(I),M=e*Math.sin(I),x=d+p+L*d}let P=Math.max(0,Math.min(1,x/u)),O=0;_===0?O=.5/n:_===g&&(O=-.5/n);for(let L=0;L<=n;L++){let I=L/n,B=I*Math.PI*2,U=Math.sin(B),X=Math.cos(B);f.x=-T*X,f.y=S,f.z=T*U,o.push(f.x,f.y,f.z),v.set(-T*X,M,T*U),v.normalize(),c.push(v.x,v.y,v.z),l.push(I+O,P)}if(_>0){let L=(_-1)*m;for(let I=0;I<n;I++){let B=L+I,U=L+I+1,X=_*m+I,k=_*m+I+1;a.push(B,U,X),a.push(U,k,X)}}}this.setIndex(a),this.setAttribute("position",new Te(o,3)),this.setAttribute("normal",new Te(c,3)),this.setAttribute("uv",new Te(l,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.radius,e.height,e.capSegments,e.radialSegments,e.heightSegments)}},Va=class r extends Xe{constructor(e=1,t=32,i=0,n=2*Math.PI){super(),this.type="CircleGeometry",this.parameters={radius:e,segments:t,thetaStart:i,thetaLength:n},t=Math.max(3,t);let s=[],a=[],o=[],c=[],l=new w,h=new te;a.push(0,0,0),o.push(0,0,1),c.push(.5,.5);for(let d=0,p=3;d<=t;d++,p+=3){let u=i+d/t*n;l.x=e*Math.cos(u),l.y=e*Math.sin(u),a.push(l.x,l.y,l.z),o.push(0,0,1),h.x=(a[p]/e+1)/2,h.y=(a[p+1]/e+1)/2,c.push(h.x,h.y)}for(let d=1;d<=t;d++)s.push(d,d+1,0);this.setIndex(s),this.setAttribute("position",new Te(a,3)),this.setAttribute("normal",new Te(o,3)),this.setAttribute("uv",new Te(c,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.radius,e.segments,e.thetaStart,e.thetaLength)}},Ji=class r extends Xe{constructor(e=1,t=1,i=1,n=32,s=1,a=!1,o=0,c=2*Math.PI){super(),this.type="CylinderGeometry",this.parameters={radiusTop:e,radiusBottom:t,height:i,radialSegments:n,heightSegments:s,openEnded:a,thetaStart:o,thetaLength:c};let l=this;n=Math.floor(n),s=Math.floor(s);let h=[],d=[],p=[],u=[],g=0,m=[],v=i/2,f=0;function _(x){let S=g,T=new te,M=new w,P=0,O=x===!0?e:t,L=x===!0?1:-1;for(let B=1;B<=n;B++)d.push(0,v*L,0),p.push(0,L,0),u.push(.5,.5),g++;let I=g;for(let B=0;B<=n;B++){let U=B/n*c+o,X=Math.cos(U),k=Math.sin(U);M.x=O*k,M.y=v*L,M.z=O*X,d.push(M.x,M.y,M.z),p.push(0,L,0),T.x=.5*X+.5,T.y=.5*k*L+.5,u.push(T.x,T.y),g++}for(let B=0;B<n;B++){let U=S+B,X=I+B;x===!0?h.push(X,X+1,U):h.push(X+1,X,U),P+=3}l.addGroup(f,P,x===!0?1:2),f+=P}(function(){let x=new w,S=new w,T=0,M=(t-e)/i;for(let P=0;P<=s;P++){let O=[],L=P/s,I=L*(t-e)+e;for(let B=0;B<=n;B++){let U=B/n,X=U*c+o,k=Math.sin(X),V=Math.cos(X);S.x=I*k,S.y=-L*i+v,S.z=I*V,d.push(S.x,S.y,S.z),x.set(k,M,V).normalize(),p.push(x.x,x.y,x.z),u.push(U,1-L),O.push(g++)}m.push(O)}for(let P=0;P<n;P++)for(let O=0;O<s;O++){let L=m[O][P],I=m[O+1][P],B=m[O+1][P+1],U=m[O][P+1];(e>0||O!==0)&&(h.push(L,I,U),T+=3),(t>0||O!==s-1)&&(h.push(I,B,U),T+=3)}l.addGroup(f,T,0),f+=T})(),a===!1&&(e>0&&_(!0),t>0&&_(!1)),this.setIndex(h),this.setAttribute("position",new Te(d,3)),this.setAttribute("normal",new Te(p,3)),this.setAttribute("uv",new Te(u,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.radiusTop,e.radiusBottom,e.height,e.radialSegments,e.heightSegments,e.openEnded,e.thetaStart,e.thetaLength)}},Ha=class r extends Ji{constructor(e=1,t=1,i=32,n=1,s=!1,a=0,o=2*Math.PI){super(0,e,t,i,n,s,a,o),this.type="ConeGeometry",this.parameters={radius:e,height:t,radialSegments:i,heightSegments:n,openEnded:s,thetaStart:a,thetaLength:o}}static fromJSON(e){return new r(e.radius,e.height,e.radialSegments,e.heightSegments,e.openEnded,e.thetaStart,e.thetaLength)}},mn=class r extends Xe{constructor(e=[],t=[],i=1,n=0){super(),this.type="PolyhedronGeometry",this.parameters={vertices:e,indices:t,radius:i,detail:n};let s=[],a=[];function o(u,g,m,v){let f=v+1,_=[];for(let x=0;x<=f;x++){_[x]=[];let S=u.clone().lerp(m,x/f),T=g.clone().lerp(m,x/f),M=f-x;for(let P=0;P<=M;P++)_[x][P]=P===0&&x===f?S:S.clone().lerp(T,P/M)}for(let x=0;x<f;x++)for(let S=0;S<2*(f-x)-1;S++){let T=Math.floor(S/2);S%2==0?(c(_[x][T+1]),c(_[x+1][T]),c(_[x][T])):(c(_[x][T+1]),c(_[x+1][T+1]),c(_[x+1][T]))}}function c(u){s.push(u.x,u.y,u.z)}function l(u,g){let m=3*u;g.x=e[m+0],g.y=e[m+1],g.z=e[m+2]}function h(u,g,m,v){v<0&&u.x===1&&(a[g]=u.x-1),m.x===0&&m.z===0&&(a[g]=v/2/Math.PI+.5)}function d(u){return Math.atan2(u.z,-u.x)}function p(u){return Math.atan2(-u.y,Math.sqrt(u.x*u.x+u.z*u.z))}(function(u){let g=new w,m=new w,v=new w;for(let f=0;f<t.length;f+=3)l(t[f+0],g),l(t[f+1],m),l(t[f+2],v),o(g,m,v,u)})(n),(function(u){let g=new w;for(let m=0;m<s.length;m+=3)g.x=s[m+0],g.y=s[m+1],g.z=s[m+2],g.normalize().multiplyScalar(u),s[m+0]=g.x,s[m+1]=g.y,s[m+2]=g.z})(i),(function(){let u=new w;for(let g=0;g<s.length;g+=3){u.x=s[g+0],u.y=s[g+1],u.z=s[g+2];let m=d(u)/2/Math.PI+.5,v=p(u)/Math.PI+.5;a.push(m,1-v)}(function(){let g=new w,m=new w,v=new w,f=new w,_=new te,x=new te,S=new te;for(let T=0,M=0;T<s.length;T+=9,M+=6){g.set(s[T+0],s[T+1],s[T+2]),m.set(s[T+3],s[T+4],s[T+5]),v.set(s[T+6],s[T+7],s[T+8]),_.set(a[M+0],a[M+1]),x.set(a[M+2],a[M+3]),S.set(a[M+4],a[M+5]),f.copy(g).add(m).add(v).divideScalar(3);let P=d(f);h(_,M+0,g,P),h(x,M+2,m,P),h(S,M+4,v,P)}})(),(function(){for(let g=0;g<a.length;g+=6){let m=a[g+0],v=a[g+2],f=a[g+4],_=Math.max(m,v,f),x=Math.min(m,v,f);_>.9&&x<.1&&(m<.2&&(a[g+0]+=1),v<.2&&(a[g+2]+=1),f<.2&&(a[g+4]+=1))}})()})(),this.setAttribute("position",new Te(s,3)),this.setAttribute("normal",new Te(s.slice(),3)),this.setAttribute("uv",new Te(a,2)),n===0?this.computeVertexNormals():this.normalizeNormals()}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.vertices,e.indices,e.radius,e.detail)}},ka=class r extends mn{constructor(e=1,t=0){let i=(1+Math.sqrt(5))/2,n=1/i;super([-1,-1,-1,-1,-1,1,-1,1,-1,-1,1,1,1,-1,-1,1,-1,1,1,1,-1,1,1,1,0,-n,-i,0,-n,i,0,n,-i,0,n,i,-n,-i,0,-n,i,0,n,-i,0,n,i,0,-i,0,-n,i,0,-n,-i,0,n,i,0,n],[3,11,7,3,7,15,3,15,13,7,19,17,7,17,6,7,6,15,17,4,8,17,8,10,17,10,6,8,0,16,8,16,2,8,2,10,0,12,1,0,1,18,0,18,16,6,10,2,6,2,13,6,13,15,2,16,18,2,18,3,2,3,13,18,1,9,18,9,11,18,11,3,4,14,12,4,12,0,4,0,8,11,9,5,11,5,19,11,19,7,19,5,14,19,14,4,19,4,17,1,12,14,1,14,5,1,5,9],e,t),this.type="DodecahedronGeometry",this.parameters={radius:e,detail:t}}static fromJSON(e){return new r(e.radius,e.detail)}},_a=new w,va=new w,Pl=new w,xa=new wi,Wa=class extends Xe{constructor(e=null,t=1){if(super(),this.type="EdgesGeometry",this.parameters={geometry:e,thresholdAngle:t},e!==null){let n=Math.pow(10,4),s=Math.cos(ur*t),a=e.getIndex(),o=e.getAttribute("position"),c=a?a.count:o.count,l=[0,0,0],h=["a","b","c"],d=new Array(3),p={},u=[];for(let g=0;g<c;g+=3){a?(l[0]=a.getX(g),l[1]=a.getX(g+1),l[2]=a.getX(g+2)):(l[0]=g,l[1]=g+1,l[2]=g+2);let{a:m,b:v,c:f}=xa;if(m.fromBufferAttribute(o,l[0]),v.fromBufferAttribute(o,l[1]),f.fromBufferAttribute(o,l[2]),xa.getNormal(Pl),d[0]=`${Math.round(m.x*n)},${Math.round(m.y*n)},${Math.round(m.z*n)}`,d[1]=`${Math.round(v.x*n)},${Math.round(v.y*n)},${Math.round(v.z*n)}`,d[2]=`${Math.round(f.x*n)},${Math.round(f.y*n)},${Math.round(f.z*n)}`,d[0]!==d[1]&&d[1]!==d[2]&&d[2]!==d[0])for(let _=0;_<3;_++){let x=(_+1)%3,S=d[_],T=d[x],M=xa[h[_]],P=xa[h[x]],O=`${S}_${T}`,L=`${T}_${S}`;L in p&&p[L]?(Pl.dot(p[L].normal)<=s&&(u.push(M.x,M.y,M.z),u.push(P.x,P.y,P.z)),p[L]=null):O in p||(p[O]={index0:l[_],index1:l[x],normal:Pl.clone()})}}for(let g in p)if(p[g]){let{index0:m,index1:v}=p[g];_a.fromBufferAttribute(o,m),va.fromBufferAttribute(o,v),u.push(_a.x,_a.y,_a.z),u.push(va.x,va.y,va.z)}this.setAttribute("position",new Te(u,3))}}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}},Yt=class{constructor(){this.type="Curve",this.arcLengthDivisions=200,this.needsUpdate=!1,this.cacheArcLengths=null}getPoint(){be("Curve: .getPoint() not implemented.")}getPointAt(e,t){let i=this.getUtoTmapping(e);return this.getPoint(i,t)}getPoints(e=5){let t=[];for(let i=0;i<=e;i++)t.push(this.getPoint(i/e));return t}getSpacedPoints(e=5){let t=[];for(let i=0;i<=e;i++)t.push(this.getPointAt(i/e));return t}getLength(){let e=this.getLengths();return e[e.length-1]}getLengths(e=this.arcLengthDivisions){if(this.cacheArcLengths&&this.cacheArcLengths.length===e+1&&!this.needsUpdate)return this.cacheArcLengths;this.needsUpdate=!1;let t=[],i,n=this.getPoint(0),s=0;t.push(0);for(let a=1;a<=e;a++)i=this.getPoint(a/e),s+=i.distanceTo(n),t.push(s),n=i;return this.cacheArcLengths=t,t}updateArcLengths(){this.needsUpdate=!0,this.getLengths()}getUtoTmapping(e,t=null){let i=this.getLengths(),n=0,s=i.length,a;a=t||e*i[s-1];let o,c=0,l=s-1;for(;c<=l;)if(n=Math.floor(c+(l-c)/2),o=i[n]-a,o<0)c=n+1;else{if(!(o>0)){l=n;break}l=n-1}if(n=l,i[n]===a)return n/(s-1);let h=i[n];return(n+(a-h)/(i[n+1]-h))/(s-1)}getTangent(e,t){let n=e-1e-4,s=e+1e-4;n<0&&(n=0),s>1&&(s=1);let a=this.getPoint(n),o=this.getPoint(s),c=t||(a.isVector2?new te:new w);return c.copy(o).sub(a).normalize(),c}getTangentAt(e,t){let i=this.getUtoTmapping(e);return this.getTangent(i,t)}computeFrenetFrames(e,t=!1){let i=new w,n=[],s=[],a=[],o=new w,c=new Fe;for(let u=0;u<=e;u++){let g=u/e;n[u]=this.getTangentAt(g,new w)}s[0]=new w,a[0]=new w;let l=Number.MAX_VALUE,h=Math.abs(n[0].x),d=Math.abs(n[0].y),p=Math.abs(n[0].z);h<=l&&(l=h,i.set(1,0,0)),d<=l&&(l=d,i.set(0,1,0)),p<=l&&i.set(0,0,1),o.crossVectors(n[0],i).normalize(),s[0].crossVectors(n[0],o),a[0].crossVectors(n[0],s[0]);for(let u=1;u<=e;u++){if(s[u]=s[u-1].clone(),a[u]=a[u-1].clone(),o.crossVectors(n[u-1],n[u]),o.length()>Number.EPSILON){o.normalize();let g=Math.acos(Ge(n[u-1].dot(n[u]),-1,1));s[u].applyMatrix4(c.makeRotationAxis(o,g))}a[u].crossVectors(n[u],s[u])}if(t===!0){let u=Math.acos(Ge(s[0].dot(s[e]),-1,1));u/=e,n[0].dot(o.crossVectors(s[0],s[e]))>0&&(u=-u);for(let g=1;g<=e;g++)s[g].applyMatrix4(c.makeRotationAxis(n[g],u*g)),a[g].crossVectors(n[g],s[g])}return{tangents:n,normals:s,binormals:a}}clone(){return new this.constructor().copy(this)}copy(e){return this.arcLengthDivisions=e.arcLengthDivisions,this}toJSON(){let e={metadata:{version:4.7,type:"Curve",generator:"Curve.toJSON"}};return e.arcLengthDivisions=this.arcLengthDivisions,e.type=this.type,e}fromJSON(e){return this.arcLengthDivisions=e.arcLengthDivisions,this}},Mr=class extends Yt{constructor(e=0,t=0,i=1,n=1,s=0,a=2*Math.PI,o=!1,c=0){super(),this.isEllipseCurve=!0,this.type="EllipseCurve",this.aX=e,this.aY=t,this.xRadius=i,this.yRadius=n,this.aStartAngle=s,this.aEndAngle=a,this.aClockwise=o,this.aRotation=c}getPoint(e,t=new te){let i=t,n=2*Math.PI,s=this.aEndAngle-this.aStartAngle,a=Math.abs(s)<Number.EPSILON;for(;s<0;)s+=n;for(;s>n;)s-=n;s<Number.EPSILON&&(s=a?0:n),this.aClockwise!==!0||a||(s===n?s=-n:s-=n);let o=this.aStartAngle+e*s,c=this.aX+this.xRadius*Math.cos(o),l=this.aY+this.yRadius*Math.sin(o);if(this.aRotation!==0){let h=Math.cos(this.aRotation),d=Math.sin(this.aRotation),p=c-this.aX,u=l-this.aY;c=p*h-u*d+this.aX,l=p*d+u*h+this.aY}return i.set(c,l)}copy(e){return super.copy(e),this.aX=e.aX,this.aY=e.aY,this.xRadius=e.xRadius,this.yRadius=e.yRadius,this.aStartAngle=e.aStartAngle,this.aEndAngle=e.aEndAngle,this.aClockwise=e.aClockwise,this.aRotation=e.aRotation,this}toJSON(){let e=super.toJSON();return e.aX=this.aX,e.aY=this.aY,e.xRadius=this.xRadius,e.yRadius=this.yRadius,e.aStartAngle=this.aStartAngle,e.aEndAngle=this.aEndAngle,e.aClockwise=this.aClockwise,e.aRotation=this.aRotation,e}fromJSON(e){return super.fromJSON(e),this.aX=e.aX,this.aY=e.aY,this.xRadius=e.xRadius,this.yRadius=e.yRadius,this.aStartAngle=e.aStartAngle,this.aEndAngle=e.aEndAngle,this.aClockwise=e.aClockwise,this.aRotation=e.aRotation,this}},Xa=class extends Mr{constructor(e,t,i,n,s,a){super(e,t,i,i,n,s,a),this.isArcCurve=!0,this.type="ArcCurve"}};function $c(){let r=0,e=0,t=0,i=0;function n(s,a,o,c){r=s,e=o,t=-3*s+3*a-2*o-c,i=2*s-2*a+o+c}return{initCatmullRom:function(s,a,o,c,l){n(a,o,l*(o-s),l*(c-a))},initNonuniformCatmullRom:function(s,a,o,c,l,h,d){let p=(a-s)/l-(o-s)/(l+h)+(o-a)/h,u=(o-a)/h-(c-a)/(h+d)+(c-o)/d;p*=h,u*=h,n(a,o,p,u)},calc:function(s){let a=s*s;return r+e*s+t*a+i*(a*s)}}}var xu=new w,yu=new w,Il=new $c,Ll=new $c,Nl=new $c,Sr=class extends Yt{constructor(e=[],t=!1,i="centripetal",n=.5){super(),this.isCatmullRomCurve3=!0,this.type="CatmullRomCurve3",this.points=e,this.closed=t,this.curveType=i,this.tension=n}getPoint(e,t=new w){let i=t,n=this.points,s=n.length,a=(s-(this.closed?0:1))*e,o,c,l=Math.floor(a),h=a-l;this.closed?l+=l>0?0:(Math.floor(Math.abs(l)/s)+1)*s:h===0&&l===s-1&&(l=s-2,h=1),this.closed||l>0?o=n[(l-1)%s]:(yu.subVectors(n[0],n[1]).add(n[0]),o=yu);let d=n[l%s],p=n[(l+1)%s];if(this.closed||l+2<s?c=n[(l+2)%s]:(xu.subVectors(n[s-1],n[s-2]).add(n[s-1]),c=xu),this.curveType==="centripetal"||this.curveType==="chordal"){let u=this.curveType==="chordal"?.5:.25,g=Math.pow(o.distanceToSquared(d),u),m=Math.pow(d.distanceToSquared(p),u),v=Math.pow(p.distanceToSquared(c),u);m<1e-4&&(m=1),g<1e-4&&(g=m),v<1e-4&&(v=m),Il.initNonuniformCatmullRom(o.x,d.x,p.x,c.x,g,m,v),Ll.initNonuniformCatmullRom(o.y,d.y,p.y,c.y,g,m,v),Nl.initNonuniformCatmullRom(o.z,d.z,p.z,c.z,g,m,v)}else this.curveType==="catmullrom"&&(Il.initCatmullRom(o.x,d.x,p.x,c.x,this.tension),Ll.initCatmullRom(o.y,d.y,p.y,c.y,this.tension),Nl.initCatmullRom(o.z,d.z,p.z,c.z,this.tension));return i.set(Il.calc(h),Ll.calc(h),Nl.calc(h)),i}copy(e){super.copy(e),this.points=[];for(let t=0,i=e.points.length;t<i;t++){let n=e.points[t];this.points.push(n.clone())}return this.closed=e.closed,this.curveType=e.curveType,this.tension=e.tension,this}toJSON(){let e=super.toJSON();e.points=[];for(let t=0,i=this.points.length;t<i;t++){let n=this.points[t];e.points.push(n.toArray())}return e.closed=this.closed,e.curveType=this.curveType,e.tension=this.tension,e}fromJSON(e){super.fromJSON(e),this.points=[];for(let t=0,i=e.points.length;t<i;t++){let n=e.points[t];this.points.push(new w().fromArray(n))}return this.closed=e.closed,this.curveType=e.curveType,this.tension=e.tension,this}};function Mu(r,e,t,i,n){let s=.5*(i-e),a=.5*(n-t),o=r*r;return(2*t-2*i+s+a)*(r*o)+(-3*t+3*i-2*s-a)*o+s*r+t}function ns(r,e,t,i){return(function(n,s){let a=1-n;return a*a*s})(r,e)+(function(n,s){return 2*(1-n)*n*s})(r,t)+(function(n,s){return n*n*s})(r,i)}function rs(r,e,t,i,n){return(function(s,a){let o=1-s;return o*o*o*a})(r,e)+(function(s,a){let o=1-s;return 3*o*o*s*a})(r,t)+(function(s,a){return 3*(1-s)*s*s*a})(r,i)+(function(s,a){return s*s*s*a})(r,n)}var vs=class extends Yt{constructor(e=new te,t=new te,i=new te,n=new te){super(),this.isCubicBezierCurve=!0,this.type="CubicBezierCurve",this.v0=e,this.v1=t,this.v2=i,this.v3=n}getPoint(e,t=new te){let i=t,n=this.v0,s=this.v1,a=this.v2,o=this.v3;return i.set(rs(e,n.x,s.x,a.x,o.x),rs(e,n.y,s.y,a.y,o.y)),i}copy(e){return super.copy(e),this.v0.copy(e.v0),this.v1.copy(e.v1),this.v2.copy(e.v2),this.v3.copy(e.v3),this}toJSON(){let e=super.toJSON();return e.v0=this.v0.toArray(),e.v1=this.v1.toArray(),e.v2=this.v2.toArray(),e.v3=this.v3.toArray(),e}fromJSON(e){return super.fromJSON(e),this.v0.fromArray(e.v0),this.v1.fromArray(e.v1),this.v2.fromArray(e.v2),this.v3.fromArray(e.v3),this}},ja=class extends Yt{constructor(e=new w,t=new w,i=new w,n=new w){super(),this.isCubicBezierCurve3=!0,this.type="CubicBezierCurve3",this.v0=e,this.v1=t,this.v2=i,this.v3=n}getPoint(e,t=new w){let i=t,n=this.v0,s=this.v1,a=this.v2,o=this.v3;return i.set(rs(e,n.x,s.x,a.x,o.x),rs(e,n.y,s.y,a.y,o.y),rs(e,n.z,s.z,a.z,o.z)),i}copy(e){return super.copy(e),this.v0.copy(e.v0),this.v1.copy(e.v1),this.v2.copy(e.v2),this.v3.copy(e.v3),this}toJSON(){let e=super.toJSON();return e.v0=this.v0.toArray(),e.v1=this.v1.toArray(),e.v2=this.v2.toArray(),e.v3=this.v3.toArray(),e}fromJSON(e){return super.fromJSON(e),this.v0.fromArray(e.v0),this.v1.fromArray(e.v1),this.v2.fromArray(e.v2),this.v3.fromArray(e.v3),this}},xs=class extends Yt{constructor(e=new te,t=new te){super(),this.isLineCurve=!0,this.type="LineCurve",this.v1=e,this.v2=t}getPoint(e,t=new te){let i=t;return e===1?i.copy(this.v2):(i.copy(this.v2).sub(this.v1),i.multiplyScalar(e).add(this.v1)),i}getPointAt(e,t){return this.getPoint(e,t)}getTangent(e,t=new te){return t.subVectors(this.v2,this.v1).normalize()}getTangentAt(e,t){return this.getTangent(e,t)}copy(e){return super.copy(e),this.v1.copy(e.v1),this.v2.copy(e.v2),this}toJSON(){let e=super.toJSON();return e.v1=this.v1.toArray(),e.v2=this.v2.toArray(),e}fromJSON(e){return super.fromJSON(e),this.v1.fromArray(e.v1),this.v2.fromArray(e.v2),this}},qa=class extends Yt{constructor(e=new w,t=new w){super(),this.isLineCurve3=!0,this.type="LineCurve3",this.v1=e,this.v2=t}getPoint(e,t=new w){let i=t;return e===1?i.copy(this.v2):(i.copy(this.v2).sub(this.v1),i.multiplyScalar(e).add(this.v1)),i}getPointAt(e,t){return this.getPoint(e,t)}getTangent(e,t=new w){return t.subVectors(this.v2,this.v1).normalize()}getTangentAt(e,t){return this.getTangent(e,t)}copy(e){return super.copy(e),this.v1.copy(e.v1),this.v2.copy(e.v2),this}toJSON(){let e=super.toJSON();return e.v1=this.v1.toArray(),e.v2=this.v2.toArray(),e}fromJSON(e){return super.fromJSON(e),this.v1.fromArray(e.v1),this.v2.fromArray(e.v2),this}},ys=class extends Yt{constructor(e=new te,t=new te,i=new te){super(),this.isQuadraticBezierCurve=!0,this.type="QuadraticBezierCurve",this.v0=e,this.v1=t,this.v2=i}getPoint(e,t=new te){let i=t,n=this.v0,s=this.v1,a=this.v2;return i.set(ns(e,n.x,s.x,a.x),ns(e,n.y,s.y,a.y)),i}copy(e){return super.copy(e),this.v0.copy(e.v0),this.v1.copy(e.v1),this.v2.copy(e.v2),this}toJSON(){let e=super.toJSON();return e.v0=this.v0.toArray(),e.v1=this.v1.toArray(),e.v2=this.v2.toArray(),e}fromJSON(e){return super.fromJSON(e),this.v0.fromArray(e.v0),this.v1.fromArray(e.v1),this.v2.fromArray(e.v2),this}},Ms=class extends Yt{constructor(e=new w,t=new w,i=new w){super(),this.isQuadraticBezierCurve3=!0,this.type="QuadraticBezierCurve3",this.v0=e,this.v1=t,this.v2=i}getPoint(e,t=new w){let i=t,n=this.v0,s=this.v1,a=this.v2;return i.set(ns(e,n.x,s.x,a.x),ns(e,n.y,s.y,a.y),ns(e,n.z,s.z,a.z)),i}copy(e){return super.copy(e),this.v0.copy(e.v0),this.v1.copy(e.v1),this.v2.copy(e.v2),this}toJSON(){let e=super.toJSON();return e.v0=this.v0.toArray(),e.v1=this.v1.toArray(),e.v2=this.v2.toArray(),e}fromJSON(e){return super.fromJSON(e),this.v0.fromArray(e.v0),this.v1.fromArray(e.v1),this.v2.fromArray(e.v2),this}},Ss=class extends Yt{constructor(e=[]){super(),this.isSplineCurve=!0,this.type="SplineCurve",this.points=e}getPoint(e,t=new te){let i=t,n=this.points,s=(n.length-1)*e,a=Math.floor(s),o=s-a,c=n[a===0?a:a-1],l=n[a],h=n[a>n.length-2?n.length-1:a+1],d=n[a>n.length-3?n.length-1:a+2];return i.set(Mu(o,c.x,l.x,h.x,d.x),Mu(o,c.y,l.y,h.y,d.y)),i}copy(e){super.copy(e),this.points=[];for(let t=0,i=e.points.length;t<i;t++){let n=e.points[t];this.points.push(n.clone())}return this}toJSON(){let e=super.toJSON();e.points=[];for(let t=0,i=this.points.length;t<i;t++){let n=this.points[t];e.points.push(n.toArray())}return e}fromJSON(e){super.fromJSON(e),this.points=[];for(let t=0,i=e.points.length;t<i;t++){let n=e.points[t];this.points.push(new te().fromArray(n))}return this}},Ya=Object.freeze({__proto__:null,ArcCurve:Xa,CatmullRomCurve3:Sr,CubicBezierCurve:vs,CubicBezierCurve3:ja,EllipseCurve:Mr,LineCurve:xs,LineCurve3:qa,QuadraticBezierCurve:ys,QuadraticBezierCurve3:Ms,SplineCurve:Ss}),Za=class extends Yt{constructor(){super(),this.type="CurvePath",this.curves=[],this.autoClose=!1}add(e){this.curves.push(e)}closePath(){let e=this.curves[0].getPoint(0),t=this.curves[this.curves.length-1].getPoint(1);if(!e.equals(t)){let i=e.isVector2===!0?"LineCurve":"LineCurve3";this.curves.push(new Ya[i](t,e))}return this}getPoint(e,t){let i=e*this.getLength(),n=this.getCurveLengths(),s=0;for(;s<n.length;){if(n[s]>=i){let a=n[s]-i,o=this.curves[s],c=o.getLength(),l=c===0?0:1-a/c;return o.getPointAt(l,t)}s++}return null}getLength(){let e=this.getCurveLengths();return e[e.length-1]}updateArcLengths(){this.needsUpdate=!0,this.cacheLengths=null,this.getCurveLengths()}getCurveLengths(){if(this.cacheLengths&&this.cacheLengths.length===this.curves.length)return this.cacheLengths;let e=[],t=0;for(let i=0,n=this.curves.length;i<n;i++)t+=this.curves[i].getLength(),e.push(t);return this.cacheLengths=e,e}getSpacedPoints(e=40){let t=[];for(let i=0;i<=e;i++)t.push(this.getPoint(i/e));return this.autoClose&&t.push(t[0]),t}getPoints(e=12){let t=[],i;for(let n=0,s=this.curves;n<s.length;n++){let a=s[n],o=a.isEllipseCurve?2*e:a.isLineCurve||a.isLineCurve3?1:a.isSplineCurve?e*a.points.length:e,c=a.getPoints(o);for(let l=0;l<c.length;l++){let h=c[l];i&&i.equals(h)||(t.push(h),i=h)}}return this.autoClose&&t.length>1&&!t[t.length-1].equals(t[0])&&t.push(t[0]),t}copy(e){super.copy(e),this.curves=[];for(let t=0,i=e.curves.length;t<i;t++){let n=e.curves[t];this.curves.push(n.clone())}return this.autoClose=e.autoClose,this}toJSON(){let e=super.toJSON();e.autoClose=this.autoClose,e.curves=[];for(let t=0,i=this.curves.length;t<i;t++){let n=this.curves[t];e.curves.push(n.toJSON())}return e}fromJSON(e){super.fromJSON(e),this.autoClose=e.autoClose,this.curves=[];for(let t=0,i=e.curves.length;t<i;t++){let n=e.curves[t];this.curves.push(new Ya[n.type]().fromJSON(n))}return this}},bs=class extends Za{constructor(e){super(),this.type="Path",this.currentPoint=new te,e&&this.setFromPoints(e)}setFromPoints(e){this.moveTo(e[0].x,e[0].y);for(let t=1,i=e.length;t<i;t++)this.lineTo(e[t].x,e[t].y);return this}moveTo(e,t){return this.currentPoint.set(e,t),this}lineTo(e,t){let i=new xs(this.currentPoint.clone(),new te(e,t));return this.curves.push(i),this.currentPoint.set(e,t),this}quadraticCurveTo(e,t,i,n){let s=new ys(this.currentPoint.clone(),new te(e,t),new te(i,n));return this.curves.push(s),this.currentPoint.set(i,n),this}bezierCurveTo(e,t,i,n,s,a){let o=new vs(this.currentPoint.clone(),new te(e,t),new te(i,n),new te(s,a));return this.curves.push(o),this.currentPoint.set(s,a),this}splineThru(e){let t=[this.currentPoint.clone()].concat(e),i=new Ss(t);return this.curves.push(i),this.currentPoint.copy(e[e.length-1]),this}arc(e,t,i,n,s,a){let o=this.currentPoint.x,c=this.currentPoint.y;return this.absarc(e+o,t+c,i,n,s,a),this}absarc(e,t,i,n,s,a){return this.absellipse(e,t,i,i,n,s,a),this}ellipse(e,t,i,n,s,a,o,c){let l=this.currentPoint.x,h=this.currentPoint.y;return this.absellipse(e+l,t+h,i,n,s,a,o,c),this}absellipse(e,t,i,n,s,a,o,c){let l=new Mr(e,t,i,n,s,a,o,c);if(this.curves.length>0){let d=l.getPoint(0);d.equals(this.currentPoint)||this.lineTo(d.x,d.y)}this.curves.push(l);let h=l.getPoint(1);return this.currentPoint.copy(h),this}copy(e){return super.copy(e),this.currentPoint.copy(e.currentPoint),this}toJSON(){let e=super.toJSON();return e.currentPoint=this.currentPoint.toArray(),e}fromJSON(e){return super.fromJSON(e),this.currentPoint.fromArray(e.currentPoint),this}},fn=class extends bs{constructor(e){super(e),this.uuid=Ci(),this.type="Shape",this.holes=[]}getPointsHoles(e){let t=[];for(let i=0,n=this.holes.length;i<n;i++)t[i]=this.holes[i].getPoints(e);return t}extractPoints(e){return{shape:this.getPoints(e),holes:this.getPointsHoles(e)}}copy(e){super.copy(e),this.holes=[];for(let t=0,i=e.holes.length;t<i;t++){let n=e.holes[t];this.holes.push(n.clone())}return this}toJSON(){let e=super.toJSON();e.uuid=this.uuid,e.holes=[];for(let t=0,i=this.holes.length;t<i;t++){let n=this.holes[t];e.holes.push(n.toJSON())}return e}fromJSON(e){super.fromJSON(e),this.uuid=e.uuid,this.holes=[];for(let t=0,i=e.holes.length;t<i;t++){let n=e.holes[t];this.holes.push(new bs().fromJSON(n))}return this}};function Yp(r,e,t=2){let i=e&&e.length,n=i?e[0]*t:r.length,s=Su(r,0,n,t,!0),a=[];if(!s||s.next===s.prev)return a;let o,c,l;if(i&&(s=(function(h,d,p,u){let g=[];for(let m=0,v=d.length;m<v;m++){let f=Su(h,d[m]*u,m<v-1?d[m+1]*u:h.length,u,!1);f===f.next&&(f.steiner=!0),g.push(im(f))}g.sort(Qp);for(let m=0;m<g.length;m++)p=em(g[m],p);return p})(r,e,s,t)),r.length>80*t){o=r[0],c=r[1];let h=o,d=c;for(let p=t;p<n;p+=t){let u=r[p],g=r[p+1];u<o&&(o=u),g<c&&(c=g),u>h&&(h=u),g>d&&(d=g)}l=Math.max(h-o,d-c),l=l!==0?32767/l:0}return Ts(s,a,t,o,c,l,0),a}function Su(r,e,t,i,n){let s;if(n===(function(a,o,c,l){let h=0;for(let d=o,p=c-l;d<c;d+=l)h+=(a[p]-a[d])*(a[d+1]+a[p+1]),p=d;return h})(r,e,t,i)>0)for(let a=e;a<t;a+=i)s=bu(a/i|0,r[a],r[a+1],s);else for(let a=t-i;a>=e;a-=i)s=bu(a/i|0,r[a],r[a+1],s);return s&&br(s,s.next)&&(ws(s),s=s.next),s}function Dn(r,e){if(!r)return r;e||(e=r);let t,i=r;do if(t=!1,i.steiner||!br(i,i.next)&&at(i.prev,i,i.next)!==0)i=i.next;else{if(ws(i),i=e=i.prev,i===i.next)break;t=!0}while(t||i!==e);return e}function Ts(r,e,t,i,n,s,a){if(!r)return;!a&&s&&(function(c,l,h,d){let p=c;do p.z===0&&(p.z=kl(p.x,p.y,l,h,d)),p.prevZ=p.prev,p.nextZ=p.next,p=p.next;while(p!==c);p.prevZ.nextZ=null,p.prevZ=null,(function(u){let g,m=1;do{let v,f=u;u=null;let _=null;for(g=0;f;){g++;let x=f,S=0;for(let M=0;M<m&&(S++,x=x.nextZ,x);M++);let T=m;for(;S>0||T>0&&x;)S!==0&&(T===0||!x||f.z<=x.z)?(v=f,f=f.nextZ,S--):(v=x,x=x.nextZ,T--),_?_.nextZ=v:u=v,v.prevZ=_,_=v;f=x}_.nextZ=null,m*=2}while(g>1)})(p)})(r,i,n,s);let o=r;for(;r.prev!==r.next;){let c=r.prev,l=r.next;if(s?Jp(r,i,n,s):Zp(r))e.push(c.i,r.i,l.i),ws(r),r=l.next,o=l.next;else if((r=l)===o){a?a===1?Ts(r=Kp(Dn(r),e),e,t,i,n,s,2):a===2&&$p(r,e,t,i,n,s):Ts(Dn(r),e,t,i,n,s,1);break}}}function Zp(r){let e=r.prev,t=r,i=r.next;if(at(e,t,i)>=0)return!1;let n=e.x,s=t.x,a=i.x,o=e.y,c=t.y,l=i.y,h=Math.min(n,s,a),d=Math.min(o,c,l),p=Math.max(n,s,a),u=Math.max(o,c,l),g=i.next;for(;g!==e;){if(g.x>=h&&g.x<=p&&g.y>=d&&g.y<=u&&ts(n,o,s,c,a,l,g.x,g.y)&&at(g.prev,g,g.next)>=0)return!1;g=g.next}return!0}function Jp(r,e,t,i){let n=r.prev,s=r,a=r.next;if(at(n,s,a)>=0)return!1;let o=n.x,c=s.x,l=a.x,h=n.y,d=s.y,p=a.y,u=Math.min(o,c,l),g=Math.min(h,d,p),m=Math.max(o,c,l),v=Math.max(h,d,p),f=kl(u,g,e,t,i),_=kl(m,v,e,t,i),x=r.prevZ,S=r.nextZ;for(;x&&x.z>=f&&S&&S.z<=_;){if(x.x>=u&&x.x<=m&&x.y>=g&&x.y<=v&&x!==n&&x!==a&&ts(o,h,c,d,l,p,x.x,x.y)&&at(x.prev,x,x.next)>=0||(x=x.prevZ,S.x>=u&&S.x<=m&&S.y>=g&&S.y<=v&&S!==n&&S!==a&&ts(o,h,c,d,l,p,S.x,S.y)&&at(S.prev,S,S.next)>=0))return!1;S=S.nextZ}for(;x&&x.z>=f;){if(x.x>=u&&x.x<=m&&x.y>=g&&x.y<=v&&x!==n&&x!==a&&ts(o,h,c,d,l,p,x.x,x.y)&&at(x.prev,x,x.next)>=0)return!1;x=x.prevZ}for(;S&&S.z<=_;){if(S.x>=u&&S.x<=m&&S.y>=g&&S.y<=v&&S!==n&&S!==a&&ts(o,h,c,d,l,p,S.x,S.y)&&at(S.prev,S,S.next)>=0)return!1;S=S.nextZ}return!0}function Kp(r,e){let t=r;do{let i=t.prev,n=t.next.next;!br(i,n)&&Sd(i,t,t.next,n)&&Es(i,n)&&Es(n,i)&&(e.push(i.i,t.i,n.i),ws(t),ws(t.next),t=r=n),t=t.next}while(t!==r);return Dn(t)}function $p(r,e,t,i,n,s){let a=r;do{let o=a.next.next;for(;o!==a.prev;){if(a.i!==o.i&&nm(a,o)){let c=bd(a,o);return a=Dn(a,a.next),c=Dn(c,c.next),Ts(a,e,t,i,n,s,0),void Ts(c,e,t,i,n,s,0)}o=o.next}a=a.next}while(a!==r)}function Qp(r,e){let t=r.x-e.x;return t===0&&(t=r.y-e.y,t===0)&&(t=(r.next.y-r.y)/(r.next.x-r.x)-(e.next.y-e.y)/(e.next.x-e.x)),t}function em(r,e){let t=(function(n,s){let a=s,o=n.x,c=n.y,l,h=-1/0;if(br(n,a))return a;do{if(br(n,a.next))return a.next;if(c<=a.y&&c>=a.next.y&&a.next.y!==a.y){let m=a.x+(c-a.y)*(a.next.x-a.x)/(a.next.y-a.y);if(m<=o&&m>h&&(h=m,l=a.x<a.next.x?a:a.next,m===o))return l}a=a.next}while(a!==s);if(!l)return null;let d=l,p=l.x,u=l.y,g=1/0;a=l;do{if(o>=a.x&&a.x>=p&&o!==a.x&&Md(c<u?o:h,c,p,u,c<u?h:o,c,a.x,a.y)){let m=Math.abs(c-a.y)/(o-a.x);Es(a,n)&&(m<g||m===g&&(a.x>l.x||a.x===l.x&&tm(l,a)))&&(l=a,g=m)}a=a.next}while(a!==d);return l})(r,e);if(!t)return e;let i=bd(t,r);return Dn(i,i.next),Dn(t,t.next)}function tm(r,e){return at(r.prev,r,e.prev)<0&&at(e.next,r,r.next)<0}function kl(r,e,t,i,n){return(r=1431655765&((r=858993459&((r=252645135&((r=16711935&((r=(r-t)*n|0)|r<<8))|r<<4))|r<<2))|r<<1))|(e=1431655765&((e=858993459&((e=252645135&((e=16711935&((e=(e-i)*n|0)|e<<8))|e<<4))|e<<2))|e<<1))<<1}function im(r){let e=r,t=r;do(e.x<t.x||e.x===t.x&&e.y<t.y)&&(t=e),e=e.next;while(e!==r);return t}function Md(r,e,t,i,n,s,a,o){return(n-a)*(e-o)>=(r-a)*(s-o)&&(r-a)*(i-o)>=(t-a)*(e-o)&&(t-a)*(s-o)>=(n-a)*(i-o)}function ts(r,e,t,i,n,s,a,o){return!(r===a&&e===o)&&Md(r,e,t,i,n,s,a,o)}function nm(r,e){return r.next.i!==e.i&&r.prev.i!==e.i&&!(function(t,i){let n=t;do{if(n.i!==t.i&&n.next.i!==t.i&&n.i!==i.i&&n.next.i!==i.i&&Sd(n,n.next,t,i))return!0;n=n.next}while(n!==t);return!1})(r,e)&&(Es(r,e)&&Es(e,r)&&(function(t,i){let n=t,s=!1,a=(t.x+i.x)/2,o=(t.y+i.y)/2;do n.y>o!=n.next.y>o&&n.next.y!==n.y&&a<(n.next.x-n.x)*(o-n.y)/(n.next.y-n.y)+n.x&&(s=!s),n=n.next;while(n!==t);return s})(r,e)&&(at(r.prev,r,e.prev)||at(r,e.prev,e))||br(r,e)&&at(r.prev,r,r.next)>0&&at(e.prev,e,e.next)>0)}function at(r,e,t){return(e.y-r.y)*(t.x-e.x)-(e.x-r.x)*(t.y-e.y)}function br(r,e){return r.x===e.x&&r.y===e.y}function Sd(r,e,t,i){let n=Ma(at(r,e,t)),s=Ma(at(r,e,i)),a=Ma(at(t,i,r)),o=Ma(at(t,i,e));return n!==s&&a!==o||!(n!==0||!ya(r,t,e))||!(s!==0||!ya(r,i,e))||!(a!==0||!ya(t,r,i))||!(o!==0||!ya(t,e,i))}function ya(r,e,t){return e.x<=Math.max(r.x,t.x)&&e.x>=Math.min(r.x,t.x)&&e.y<=Math.max(r.y,t.y)&&e.y>=Math.min(r.y,t.y)}function Ma(r){return r>0?1:r<0?-1:0}function Es(r,e){return at(r.prev,r,r.next)<0?at(r,e,r.next)>=0&&at(r,r.prev,e)>=0:at(r,e,r.prev)<0||at(r,r.next,e)<0}function bd(r,e){let t=Wl(r.i,r.x,r.y),i=Wl(e.i,e.x,e.y),n=r.next,s=e.prev;return r.next=e,e.prev=r,t.next=n,n.prev=t,i.next=t,t.prev=i,s.next=i,i.prev=s,i}function bu(r,e,t,i){let n=Wl(r,e,t);return i?(n.next=i.next,n.prev=i,i.next.prev=n,i.next=n):(n.prev=n,n.next=n),n}function ws(r){r.next.prev=r.prev,r.prev.next=r.next,r.prevZ&&(r.prevZ.nextZ=r.nextZ),r.nextZ&&(r.nextZ.prevZ=r.prevZ)}function Wl(r,e,t){return{i:r,x:e,y:t,prev:null,next:null,z:0,prevZ:null,nextZ:null,steiner:!1}}var Xl=class{static triangulate(e,t,i=2){return Yp(e,t,i)}},Ai=class r{static area(e){let t=e.length,i=0;for(let n=t-1,s=0;s<t;n=s++)i+=e[n].x*e[s].y-e[s].x*e[n].y;return .5*i}static isClockWise(e){return r.area(e)<0}static triangulateShape(e,t){let i=[],n=[],s=[];Tu(e),Eu(i,e);let a=e.length;t.forEach(Tu);for(let c=0;c<t.length;c++)n.push(a),a+=t[c].length,Eu(i,t[c]);let o=Xl.triangulate(i,n);for(let c=0;c<o.length;c+=3)s.push(o.slice(c,c+3));return s}};function Tu(r){let e=r.length;e>2&&r[e-1].equals(r[0])&&r.pop()}function Eu(r,e){for(let t=0;t<e.length;t++)r.push(e[t].x),r.push(e[t].y)}var Tr=class r extends Xe{constructor(e=new fn([new te(.5,.5),new te(-.5,.5),new te(-.5,-.5),new te(.5,-.5)]),t={}){super(),this.type="ExtrudeGeometry",this.parameters={shapes:e,options:t},e=Array.isArray(e)?e:[e];let i=this,n=[],s=[];for(let o=0,c=e.length;o<c;o++)a(e[o]);function a(o){let c=[],l=t.curveSegments!==void 0?t.curveSegments:12,h=t.steps!==void 0?t.steps:1,d=t.depth!==void 0?t.depth:1,p=t.bevelEnabled===void 0||t.bevelEnabled,u=t.bevelThickness!==void 0?t.bevelThickness:.2,g=t.bevelSize!==void 0?t.bevelSize:u-.1,m=t.bevelOffset!==void 0?t.bevelOffset:0,v=t.bevelSegments!==void 0?t.bevelSegments:3,f=t.extrudePath,_=t.UVGenerator!==void 0?t.UVGenerator:rm,x,S,T,M,P,O=!1;if(f){x=f.getSpacedPoints(h),O=!0,p=!1;let C=!!f.isCatmullRomCurve3&&f.closed;S=f.computeFrenetFrames(h,C),T=new w,M=new w,P=new w}p||(v=0,u=0,g=0,m=0);let L=o.extractPoints(l),I=L.shape,B=L.holes;if(!Ai.isClockWise(I)){I=I.reverse();for(let C=0,F=B.length;C<F;C++){let y=B[C];Ai.isClockWise(y)&&(B[C]=y.reverse())}}function U(C){let F=10000000000000001e-36,y=C[0];for(let D=1;D<=C.length;D++){let N=D%C.length,A=C[N],H=A.x-y.x,j=A.y-y.y,Z=H*H+j*j,se=Math.max(Math.abs(A.x),Math.abs(A.y),Math.abs(y.x),Math.abs(y.y));Z<=F*se*se?(C.splice(N,1),D--):y=A}}U(I),B.forEach(U);let X=B.length,k=I;for(let C=0;C<X;C++){let F=B[C];I=I.concat(F)}function V(C,F,y){return F||we("ExtrudeGeometry: vec does not exist"),C.clone().addScaledVector(F,y)}let Y=I.length;function W(C,F,y){let D,N,A,H=C.x-F.x,j=C.y-F.y,Z=y.x-C.x,se=y.y-C.y,xe=H*H+j*j,ye=H*se-j*Z;if(Math.abs(ye)>Number.EPSILON){let ue=Math.sqrt(xe),Ce=Math.sqrt(Z*Z+se*se),ee=F.x-j/ue,ae=F.y+H/ue,re=((y.x-se/Ce-ee)*se-(y.y+Z/Ce-ae)*Z)/(H*se-j*Z);D=ee+H*re-C.x,N=ae+j*re-C.y;let me=D*D+N*N;if(me<=2)return new te(D,N);A=Math.sqrt(me/2)}else{let ue=!1;H>Number.EPSILON?Z>Number.EPSILON&&(ue=!0):H<-Number.EPSILON?Z<-Number.EPSILON&&(ue=!0):Math.sign(j)===Math.sign(se)&&(ue=!0),ue?(D=-j,N=H,A=Math.sqrt(xe)):(D=H,N=j,A=Math.sqrt(xe/2))}return new te(D/A,N/A)}let ne=[];for(let C=0,F=k.length,y=F-1,D=C+1;C<F;C++,y++,D++)y===F&&(y=0),D===F&&(D=0),ne[C]=W(k[C],k[y],k[D]);let pe=[],Ee,_e,ve=ne.concat();for(let C=0,F=X;C<F;C++){let y=B[C];Ee=[];for(let D=0,N=y.length,A=N-1,H=D+1;D<N;D++,A++,H++)A===N&&(A=0),H===N&&(H=0),Ee[D]=W(y[D],y[A],y[H]);pe.push(Ee),ve=ve.concat(Ee)}if(v===0)_e=Ai.triangulateShape(k,B);else{let C=[],F=[];for(let y=0;y<v;y++){let D=y/v,N=u*Math.cos(D*Math.PI/2),A=g*Math.sin(D*Math.PI/2)+m;for(let H=0,j=k.length;H<j;H++){let Z=V(k[H],ne[H],A);fe(Z.x,Z.y,-N),D===0&&C.push(Z)}for(let H=0,j=X;H<j;H++){let Z=B[H];Ee=pe[H];let se=[];for(let xe=0,ye=Z.length;xe<ye;xe++){let ue=V(Z[xe],Ee[xe],A);fe(ue.x,ue.y,-N),D===0&&se.push(ue)}D===0&&F.push(se)}}_e=Ai.triangulateShape(C,F)}let ie=_e.length,he=g+m;for(let C=0;C<Y;C++){let F=p?V(I[C],ve[C],he):I[C];O?(M.copy(S.normals[0]).multiplyScalar(F.x),T.copy(S.binormals[0]).multiplyScalar(F.y),P.copy(x[0]).add(M).add(T),fe(P.x,P.y,P.z)):fe(F.x,F.y,0)}for(let C=1;C<=h;C++)for(let F=0;F<Y;F++){let y=p?V(I[F],ve[F],he):I[F];O?(M.copy(S.normals[C]).multiplyScalar(y.x),T.copy(S.binormals[C]).multiplyScalar(y.y),P.copy(x[C]).add(M).add(T),fe(P.x,P.y,P.z)):fe(y.x,y.y,d/h*C)}for(let C=v-1;C>=0;C--){let F=C/v,y=u*Math.cos(F*Math.PI/2),D=g*Math.sin(F*Math.PI/2)+m;for(let N=0,A=k.length;N<A;N++){let H=V(k[N],ne[N],D);fe(H.x,H.y,d+y)}for(let N=0,A=B.length;N<A;N++){let H=B[N];Ee=pe[N];for(let j=0,Z=H.length;j<Z;j++){let se=V(H[j],Ee[j],D);O?fe(se.x,se.y+x[h-1].y,x[h-1].x+y):fe(se.x,se.y,d+y)}}}function le(C,F){let y=C.length;for(;--y>=0;){let D=y,N=y-1;N<0&&(N=C.length-1);for(let A=0,H=h+2*v;A<H;A++){let j=Y*A,Z=Y*(A+1);$(F+D+j,F+N+j,F+N+Z,F+D+Z)}}}function fe(C,F,y){c.push(C),c.push(F),c.push(y)}function Ue(C,F,y){R(C),R(F),R(y);let D=n.length/3,N=_.generateTopUV(i,n,D-3,D-2,D-1);b(N[0]),b(N[1]),b(N[2])}function $(C,F,y,D){R(C),R(F),R(D),R(F),R(y),R(D);let N=n.length/3,A=_.generateSideWallUV(i,n,N-6,N-3,N-2,N-1);b(A[0]),b(A[1]),b(A[3]),b(A[1]),b(A[2]),b(A[3])}function R(C){n.push(c[3*C+0]),n.push(c[3*C+1]),n.push(c[3*C+2])}function b(C){s.push(C.x),s.push(C.y)}(function(){let C=n.length/3;if(p){let F=0,y=Y*F;for(let D=0;D<ie;D++){let N=_e[D];Ue(N[2]+y,N[1]+y,N[0]+y)}F=h+2*v,y=Y*F;for(let D=0;D<ie;D++){let N=_e[D];Ue(N[0]+y,N[1]+y,N[2]+y)}}else{for(let F=0;F<ie;F++){let y=_e[F];Ue(y[2],y[1],y[0])}for(let F=0;F<ie;F++){let y=_e[F];Ue(y[0]+Y*h,y[1]+Y*h,y[2]+Y*h)}}i.addGroup(C,n.length/3-C,0)})(),(function(){let C=n.length/3,F=0;le(k,F),F+=k.length;for(let y=0,D=B.length;y<D;y++){let N=B[y];le(N,F),F+=N.length}i.addGroup(C,n.length/3-C,1)})()}this.setAttribute("position",new Te(n,3)),this.setAttribute("uv",new Te(s,2)),this.computeVertexNormals()}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}toJSON(){let e=super.toJSON();return(function(t,i,n){if(n.shapes=[],Array.isArray(t))for(let s=0,a=t.length;s<a;s++){let o=t[s];n.shapes.push(o.uuid)}else n.shapes.push(t.uuid);return n.options=Object.assign({},i),i.extrudePath!==void 0&&(n.options.extrudePath=i.extrudePath.toJSON()),n})(this.parameters.shapes,this.parameters.options,e)}static fromJSON(e,t){let i=[];for(let s=0,a=e.shapes.length;s<a;s++){let o=t[e.shapes[s]];i.push(o)}let n=e.options.extrudePath;return n!==void 0&&(e.options.extrudePath=new Ya[n.type]().fromJSON(n)),new r(i,e.options)}},rm={generateTopUV:function(r,e,t,i,n){let s=e[3*t],a=e[3*t+1],o=e[3*i],c=e[3*i+1],l=e[3*n],h=e[3*n+1];return[new te(s,a),new te(o,c),new te(l,h)]},generateSideWallUV:function(r,e,t,i,n,s){let a=e[3*t],o=e[3*t+1],c=e[3*t+2],l=e[3*i],h=e[3*i+1],d=e[3*i+2],p=e[3*n],u=e[3*n+1],g=e[3*n+2],m=e[3*s],v=e[3*s+1],f=e[3*s+2];return Math.abs(o-h)<Math.abs(a-l)?[new te(a,1-c),new te(l,1-d),new te(p,1-g),new te(m,1-f)]:[new te(o,1-c),new te(h,1-d),new te(u,1-g),new te(v,1-f)]}},Ja=class r extends mn{constructor(e=1,t=0){let i=(1+Math.sqrt(5))/2;super([-1,i,0,1,i,0,-1,-i,0,1,-i,0,0,-1,i,0,1,i,0,-1,-i,0,1,-i,i,0,-1,i,0,1,-i,0,-1,-i,0,1],[0,11,5,0,5,1,0,1,7,0,7,10,0,10,11,1,5,9,5,11,4,11,10,2,10,7,6,7,1,8,3,9,4,3,4,2,3,2,6,3,6,8,3,8,9,4,9,5,2,4,11,6,2,10,8,6,7,9,8,1],e,t),this.type="IcosahedronGeometry",this.parameters={radius:e,detail:t}}static fromJSON(e){return new r(e.radius,e.detail)}},Ka=class r extends Xe{constructor(e=[new te(0,-.5),new te(.5,0),new te(0,.5)],t=12,i=0,n=2*Math.PI){super(),this.type="LatheGeometry",this.parameters={points:e,segments:t,phiStart:i,phiLength:n},t=Math.floor(t),n=Ge(n,0,2*Math.PI);let s=[],a=[],o=[],c=[],l=[],h=1/t,d=new w,p=new te,u=new w,g=new w,m=new w,v=0,f=0;for(let _=0;_<=e.length-1;_++)switch(_){case 0:v=e[_+1].x-e[_].x,f=e[_+1].y-e[_].y,u.x=1*f,u.y=-v,u.z=0*f,m.copy(u),u.normalize(),c.push(u.x,u.y,u.z);break;case e.length-1:c.push(m.x,m.y,m.z);break;default:v=e[_+1].x-e[_].x,f=e[_+1].y-e[_].y,u.x=1*f,u.y=-v,u.z=0*f,g.copy(u),u.x+=m.x,u.y+=m.y,u.z+=m.z,u.normalize(),c.push(u.x,u.y,u.z),m.copy(g)}for(let _=0;_<=t;_++){let x=i+_*h*n,S=Math.sin(x),T=Math.cos(x);for(let M=0;M<=e.length-1;M++){d.x=e[M].x*S,d.y=e[M].y,d.z=e[M].x*T,a.push(d.x,d.y,d.z),p.x=_/t,p.y=M/(e.length-1),o.push(p.x,p.y);let P=c[3*M+0]*S,O=c[3*M+1],L=c[3*M+0]*T;l.push(P,O,L)}}for(let _=0;_<t;_++)for(let x=0;x<e.length-1;x++){let S=x+_*e.length,T=S,M=S+e.length,P=S+e.length+1,O=S+1;s.push(T,M,O),s.push(P,O,M)}this.setIndex(s),this.setAttribute("position",new Te(a,3)),this.setAttribute("uv",new Te(o,2)),this.setAttribute("normal",new Te(l,3))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.points,e.segments,e.phiStart,e.phiLength)}},Er=class r extends mn{constructor(e=1,t=0){super([1,0,0,-1,0,0,0,1,0,0,-1,0,0,0,1,0,0,-1],[0,2,4,0,4,3,0,3,5,0,5,2,1,2,5,1,5,3,1,3,4,1,4,2],e,t),this.type="OctahedronGeometry",this.parameters={radius:e,detail:t}}static fromJSON(e){return new r(e.radius,e.detail)}},gn=class r extends Xe{constructor(e=1,t=1,i=1,n=1){super(),this.type="PlaneGeometry",this.parameters={width:e,height:t,widthSegments:i,heightSegments:n};let s=e/2,a=t/2,o=Math.floor(i),c=Math.floor(n),l=o+1,h=c+1,d=e/o,p=t/c,u=[],g=[],m=[],v=[];for(let f=0;f<h;f++){let _=f*p-a;for(let x=0;x<l;x++){let S=x*d-s;g.push(S,-_,0),m.push(0,0,1),v.push(x/o),v.push(1-f/c)}}for(let f=0;f<c;f++)for(let _=0;_<o;_++){let x=_+l*f,S=_+l*(f+1),T=_+1+l*(f+1),M=_+1+l*f;u.push(x,S,M),u.push(S,T,M)}this.setIndex(u),this.setAttribute("position",new Te(g,3)),this.setAttribute("normal",new Te(m,3)),this.setAttribute("uv",new Te(v,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.width,e.height,e.widthSegments,e.heightSegments)}},$a=class r extends Xe{constructor(e=.5,t=1,i=32,n=1,s=0,a=2*Math.PI){super(),this.type="RingGeometry",this.parameters={innerRadius:e,outerRadius:t,thetaSegments:i,phiSegments:n,thetaStart:s,thetaLength:a},i=Math.max(3,i);let o=[],c=[],l=[],h=[],d=e,p=(t-e)/(n=Math.max(1,n)),u=new w,g=new te;for(let m=0;m<=n;m++){for(let v=0;v<=i;v++){let f=s+v/i*a;u.x=d*Math.cos(f),u.y=d*Math.sin(f),c.push(u.x,u.y,u.z),l.push(0,0,1),g.x=(u.x/t+1)/2,g.y=(u.y/t+1)/2,h.push(g.x,g.y)}d+=p}for(let m=0;m<n;m++){let v=m*(i+1);for(let f=0;f<i;f++){let _=f+v,x=_,S=_+i+1,T=_+i+2,M=_+1;o.push(x,S,M),o.push(S,T,M)}}this.setIndex(o),this.setAttribute("position",new Te(c,3)),this.setAttribute("normal",new Te(l,3)),this.setAttribute("uv",new Te(h,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.innerRadius,e.outerRadius,e.thetaSegments,e.phiSegments,e.thetaStart,e.thetaLength)}},wr=class r extends Xe{constructor(e=new fn([new te(0,.5),new te(-.5,-.5),new te(.5,-.5)]),t=12){super(),this.type="ShapeGeometry",this.parameters={shapes:e,curveSegments:t};let i=[],n=[],s=[],a=[],o=0,c=0;if(Array.isArray(e)===!1)l(e);else for(let h=0;h<e.length;h++)l(e[h]),this.addGroup(o,c,h),o+=c,c=0;function l(h){let d=n.length/3,p=h.extractPoints(t),u=p.shape,g=p.holes;Ai.isClockWise(u)===!1&&(u=u.reverse());for(let v=0,f=g.length;v<f;v++){let _=g[v];Ai.isClockWise(_)===!0&&(g[v]=_.reverse())}let m=Ai.triangulateShape(u,g);for(let v=0,f=g.length;v<f;v++){let _=g[v];u=u.concat(_)}for(let v=0,f=u.length;v<f;v++){let _=u[v];n.push(_.x,_.y,0),s.push(0,0,1),a.push(_.x,_.y)}for(let v=0,f=m.length;v<f;v++){let _=m[v],x=_[0]+d,S=_[1]+d,T=_[2]+d;i.push(x,S,T),c+=3}}this.setIndex(i),this.setAttribute("position",new Te(n,3)),this.setAttribute("normal",new Te(s,3)),this.setAttribute("uv",new Te(a,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}toJSON(){let e=super.toJSON();return(function(t,i){if(i.shapes=[],Array.isArray(t))for(let n=0,s=t.length;n<s;n++){let a=t[n];i.shapes.push(a.uuid)}else i.shapes.push(t.uuid);return i})(this.parameters.shapes,e)}static fromJSON(e,t){let i=[];for(let n=0,s=e.shapes.length;n<s;n++){let a=t[e.shapes[n]];i.push(a)}return new r(i,e.curveSegments)}},ni=class r extends Xe{constructor(e=1,t=32,i=16,n=0,s=2*Math.PI,a=0,o=Math.PI){super(),this.type="SphereGeometry",this.parameters={radius:e,widthSegments:t,heightSegments:i,phiStart:n,phiLength:s,thetaStart:a,thetaLength:o},t=Math.max(3,Math.floor(t)),i=Math.max(2,Math.floor(i));let c=Math.min(a+o,Math.PI),l=0,h=[],d=new w,p=new w,u=[],g=[],m=[],v=[];for(let f=0;f<=i;f++){let _=[],x=f/i,S=a+x*o,T=e*Math.cos(S),M=Math.sqrt(e*e-T*T),P=0;f===0&&a===0?P=.5/t:f===i&&c===Math.PI&&(P=-.5/t);for(let O=0;O<=t;O++){let L=O/t,I=n+L*s;d.x=-M*Math.cos(I),d.y=T,d.z=M*Math.sin(I),g.push(d.x,d.y,d.z),p.copy(d).normalize(),m.push(p.x,p.y,p.z),v.push(L+P,1-x),_.push(l++)}h.push(_)}for(let f=0;f<i;f++)for(let _=0;_<t;_++){let x=h[f][_+1],S=h[f][_],T=h[f+1][_],M=h[f+1][_+1];(f!==0||a>0)&&u.push(x,S,M),(f!==i-1||c<Math.PI)&&u.push(S,T,M)}this.setIndex(u),this.setAttribute("position",new Te(g,3)),this.setAttribute("normal",new Te(m,3)),this.setAttribute("uv",new Te(v,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.radius,e.widthSegments,e.heightSegments,e.phiStart,e.phiLength,e.thetaStart,e.thetaLength)}},Qa=class r extends mn{constructor(e=1,t=0){super([1,1,1,-1,-1,1,-1,1,-1,1,-1,-1],[2,1,0,0,3,2,1,3,0,2,3,1],e,t),this.type="TetrahedronGeometry",this.parameters={radius:e,detail:t}}static fromJSON(e){return new r(e.radius,e.detail)}},Ki=class r extends Xe{constructor(e=1,t=.4,i=12,n=48,s=2*Math.PI,a=0,o=2*Math.PI){super(),this.type="TorusGeometry",this.parameters={radius:e,tube:t,radialSegments:i,tubularSegments:n,arc:s,thetaStart:a,thetaLength:o},i=Math.floor(i),n=Math.floor(n);let c=[],l=[],h=[],d=[],p=new w,u=new w,g=new w;for(let m=0;m<=i;m++){let v=a+m/i*o;for(let f=0;f<=n;f++){let _=f/n*s;u.x=(e+t*Math.cos(v))*Math.cos(_),u.y=(e+t*Math.cos(v))*Math.sin(_),u.z=t*Math.sin(v),l.push(u.x,u.y,u.z),p.x=e*Math.cos(_),p.y=e*Math.sin(_),g.subVectors(u,p).normalize(),h.push(g.x,g.y,g.z),d.push(f/n),d.push(m/i)}}for(let m=1;m<=i;m++)for(let v=1;v<=n;v++){let f=(n+1)*m+v-1,_=(n+1)*(m-1)+v-1,x=(n+1)*(m-1)+v,S=(n+1)*m+v;c.push(f,_,S),c.push(_,x,S)}this.setIndex(c),this.setAttribute("position",new Te(l,3)),this.setAttribute("normal",new Te(h,3)),this.setAttribute("uv",new Te(d,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.radius,e.tube,e.radialSegments,e.tubularSegments,e.arc)}},eo=class r extends Xe{constructor(e=1,t=.4,i=64,n=8,s=2,a=3){super(),this.type="TorusKnotGeometry",this.parameters={radius:e,tube:t,tubularSegments:i,radialSegments:n,p:s,q:a},i=Math.floor(i),n=Math.floor(n);let o=[],c=[],l=[],h=[],d=new w,p=new w,u=new w,g=new w,m=new w,v=new w,f=new w;for(let x=0;x<=i;++x){let S=x/i*s*Math.PI*2;_(S,s,a,e,u),_(S+.01,s,a,e,g),v.subVectors(g,u),f.addVectors(g,u),m.crossVectors(v,f),f.crossVectors(m,v),m.normalize(),f.normalize();for(let T=0;T<=n;++T){let M=T/n*Math.PI*2,P=-t*Math.cos(M),O=t*Math.sin(M);d.x=u.x+(P*f.x+O*m.x),d.y=u.y+(P*f.y+O*m.y),d.z=u.z+(P*f.z+O*m.z),c.push(d.x,d.y,d.z),p.subVectors(d,u).normalize(),l.push(p.x,p.y,p.z),h.push(x/i),h.push(T/n)}}for(let x=1;x<=i;x++)for(let S=1;S<=n;S++){let T=(n+1)*(x-1)+(S-1),M=(n+1)*x+(S-1),P=(n+1)*x+S,O=(n+1)*(x-1)+S;o.push(T,M,O),o.push(M,P,O)}function _(x,S,T,M,P){let O=Math.cos(x),L=Math.sin(x),I=T/S*x,B=Math.cos(I);P.x=M*(2+B)*.5*O,P.y=M*(2+B)*L*.5,P.z=M*Math.sin(I)*.5}this.setIndex(o),this.setAttribute("position",new Te(c,3)),this.setAttribute("normal",new Te(l,3)),this.setAttribute("uv",new Te(h,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}static fromJSON(e){return new r(e.radius,e.tube,e.tubularSegments,e.radialSegments,e.p,e.q)}},Ar=class r extends Xe{constructor(e=new Ms(new w(-1,-1,0),new w(-1,1,0),new w(1,1,0)),t=64,i=1,n=8,s=!1){super(),this.type="TubeGeometry",this.parameters={path:e,tubularSegments:t,radius:i,radialSegments:n,closed:s};let a=e.computeFrenetFrames(t,s);this.tangents=a.tangents,this.normals=a.normals,this.binormals=a.binormals;let o=new w,c=new w,l=new te,h=new w,d=[],p=[],u=[],g=[];function m(v){h=e.getPointAt(v/t,h);let f=a.normals[v],_=a.binormals[v];for(let x=0;x<=n;x++){let S=x/n*Math.PI*2,T=Math.sin(S),M=-Math.cos(S);c.x=M*f.x+T*_.x,c.y=M*f.y+T*_.y,c.z=M*f.z+T*_.z,c.normalize(),p.push(c.x,c.y,c.z),o.x=h.x+i*c.x,o.y=h.y+i*c.y,o.z=h.z+i*c.z,d.push(o.x,o.y,o.z)}}(function(){for(let v=0;v<t;v++)m(v);m(s===!1?t:0),(function(){for(let v=0;v<=t;v++)for(let f=0;f<=n;f++)l.x=v/t,l.y=f/n,u.push(l.x,l.y)})(),(function(){for(let v=1;v<=t;v++)for(let f=1;f<=n;f++){let _=(n+1)*(v-1)+(f-1),x=(n+1)*v+(f-1),S=(n+1)*v+f,T=(n+1)*(v-1)+f;g.push(_,x,T),g.push(x,S,T)}})()})(),this.setIndex(g),this.setAttribute("position",new Te(d,3)),this.setAttribute("normal",new Te(p,3)),this.setAttribute("uv",new Te(u,2))}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}toJSON(){let e=super.toJSON();return e.path=this.parameters.path.toJSON(),e}static fromJSON(e){return new r(new Ya[e.path.type]().fromJSON(e.path),e.tubularSegments,e.radius,e.radialSegments,e.closed)}},to=class extends Xe{constructor(e=null){if(super(),this.type="WireframeGeometry",this.parameters={geometry:e},e!==null){let t=[],i=new Set,n=new w,s=new w;if(e.index!==null){let a=e.attributes.position,o=e.index,c=e.groups;c.length===0&&(c=[{start:0,count:o.count,materialIndex:0}]);for(let l=0,h=c.length;l<h;++l){let d=c[l],p=d.start;for(let u=p,g=p+d.count;u<g;u+=3)for(let m=0;m<3;m++){let v=o.getX(u+m),f=o.getX(u+(m+1)%3);n.fromBufferAttribute(a,v),s.fromBufferAttribute(a,f),wu(n,s,i)===!0&&(t.push(n.x,n.y,n.z),t.push(s.x,s.y,s.z))}}}else{let a=e.attributes.position;for(let o=0,c=a.count/3;o<c;o++)for(let l=0;l<3;l++){let h=3*o+l,d=3*o+(l+1)%3;n.fromBufferAttribute(a,h),s.fromBufferAttribute(a,d),wu(n,s,i)===!0&&(t.push(n.x,n.y,n.z),t.push(s.x,s.y,s.z))}}this.setAttribute("position",new Te(t,3))}}copy(e){return super.copy(e),this.parameters=Object.assign({},e.parameters),this}};function wu(r,e,t){let i=`${r.x},${r.y},${r.z}-${e.x},${e.y},${e.z}`,n=`${e.x},${e.y},${e.z}-${r.x},${r.y},${r.z}`;return t.has(i)!==!0&&t.has(n)!==!0&&(t.add(i),t.add(n),!0)}var Og=Object.freeze({__proto__:null,BoxGeometry:qt,CapsuleGeometry:Ga,CircleGeometry:Va,ConeGeometry:Ha,CylinderGeometry:Ji,DodecahedronGeometry:ka,EdgesGeometry:Wa,ExtrudeGeometry:Tr,IcosahedronGeometry:Ja,LatheGeometry:Ka,OctahedronGeometry:Er,PlaneGeometry:gn,PolyhedronGeometry:mn,RingGeometry:$a,ShapeGeometry:wr,SphereGeometry:ni,TetrahedronGeometry:Qa,TorusGeometry:Ki,TorusKnotGeometry:eo,TubeGeometry:Ar,WireframeGeometry:to});function Gn(r){let e={};for(let t in r){e[t]={};for(let i in r[t]){let n=r[t][i];if(Au(n))n.isRenderTargetTexture?(be("UniformsUtils: Textures of render targets cannot be cloned via cloneUniforms() or mergeUniforms()."),e[t][i]=null):e[t][i]=n.clone();else if(Array.isArray(n))if(Au(n[0])){let s=[];for(let a=0,o=n.length;a<o;a++)s[a]=n[a].clone();e[t][i]=s}else e[t][i]=n.slice();else e[t][i]=n}}return e}function Ut(r){let e={};for(let t=0;t<r.length;t++){let i=Gn(r[t]);for(let n in i)e[n]=i[n]}return e}function Au(r){return r&&(r.isColor||r.isMatrix3||r.isMatrix4||r.isVector2||r.isVector3||r.isVector4||r.isTexture||r.isQuaternion)}function Qc(r){let e=r.getRenderTarget();return e===null?r.outputColorSpace:e.isXRRenderTarget===!0?e.texture.colorSpace:He.workingColorSpace}var Td={clone:Gn,merge:Ut},zt=class extends mi{constructor(e){super(),this.isShaderMaterial=!0,this.type="ShaderMaterial",this.defines={},this.uniforms={},this.uniformsGroups=[],this.vertexShader=`void main() {
	gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}`,this.fragmentShader=`void main() {
	gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
}`,this.linewidth=1,this.wireframe=!1,this.wireframeLinewidth=1,this.fog=!1,this.lights=!1,this.clipping=!1,this.forceSinglePass=!0,this.extensions={clipCullDistance:!1,multiDraw:!1},this.defaultAttributeValues={color:[1,1,1],uv:[0,0],uv1:[0,0]},this.index0AttributeName=void 0,this.uniformsNeedUpdate=!1,this.glslVersion=null,e!==void 0&&this.setValues(e)}copy(e){return super.copy(e),this.fragmentShader=e.fragmentShader,this.vertexShader=e.vertexShader,this.uniforms=Gn(e.uniforms),this.uniformsGroups=(function(t){let i=[];for(let n=0;n<t.length;n++)i.push(t[n].clone());return i})(e.uniformsGroups),this.defines=Object.assign({},e.defines),this.wireframe=e.wireframe,this.wireframeLinewidth=e.wireframeLinewidth,this.fog=e.fog,this.lights=e.lights,this.clipping=e.clipping,this.extensions=Object.assign({},e.extensions),this.glslVersion=e.glslVersion,this.defaultAttributeValues=Object.assign({},e.defaultAttributeValues),this.index0AttributeName=e.index0AttributeName,this.uniformsNeedUpdate=e.uniformsNeedUpdate,this}toJSON(e){let t=super.toJSON(e);t.glslVersion=this.glslVersion,t.uniforms={};for(let n in this.uniforms){let s=this.uniforms[n].value;s&&s.isTexture?t.uniforms[n]={type:"t",value:s.toJSON(e).uuid}:s&&s.isColor?t.uniforms[n]={type:"c",value:s.getHex()}:s&&s.isVector2?t.uniforms[n]={type:"v2",value:s.toArray()}:s&&s.isVector3?t.uniforms[n]={type:"v3",value:s.toArray()}:s&&s.isVector4?t.uniforms[n]={type:"v4",value:s.toArray()}:s&&s.isMatrix3?t.uniforms[n]={type:"m3",value:s.toArray()}:s&&s.isMatrix4?t.uniforms[n]={type:"m4",value:s.toArray()}:t.uniforms[n]={value:s}}Object.keys(this.defines).length>0&&(t.defines=this.defines),t.vertexShader=this.vertexShader,t.fragmentShader=this.fragmentShader,t.lights=this.lights,t.clipping=this.clipping;let i={};for(let n in this.extensions)this.extensions[n]===!0&&(i[n]=!0);return Object.keys(i).length>0&&(t.extensions=i),t}fromJSON(e,t){if(super.fromJSON(e,t),e.uniforms!==void 0)for(let i in e.uniforms){let n=e.uniforms[i];switch(this.uniforms[i]={},n.type){case"t":this.uniforms[i].value=t[n.value]||null;break;case"c":this.uniforms[i].value=new Ie().setHex(n.value);break;case"v2":this.uniforms[i].value=new te().fromArray(n.value);break;case"v3":this.uniforms[i].value=new w().fromArray(n.value);break;case"v4":this.uniforms[i].value=new $e().fromArray(n.value);break;case"m3":this.uniforms[i].value=new Ne().fromArray(n.value);break;case"m4":this.uniforms[i].value=new Fe().fromArray(n.value);break;default:this.uniforms[i].value=n.value}}if(e.defines!==void 0&&(this.defines=e.defines),e.vertexShader!==void 0&&(this.vertexShader=e.vertexShader),e.fragmentShader!==void 0&&(this.fragmentShader=e.fragmentShader),e.glslVersion!==void 0&&(this.glslVersion=e.glslVersion),e.extensions!==void 0)for(let i in e.extensions)this.extensions[i]=e.extensions[i];return e.lights!==void 0&&(this.lights=e.lights),e.clipping!==void 0&&(this.clipping=e.clipping),this}},io=class extends zt{constructor(e){super(e),this.isRawShaderMaterial=!0,this.type="RawShaderMaterial"}},Pi=class extends mi{constructor(e){super(),this.isMeshStandardMaterial=!0,this.type="MeshStandardMaterial",this.defines={STANDARD:""},this.color=new Ie(16777215),this.roughness=1,this.metalness=0,this.map=null,this.lightMap=null,this.lightMapIntensity=1,this.aoMap=null,this.aoMapIntensity=1,this.emissive=new Ie(0),this.emissiveIntensity=1,this.emissiveMap=null,this.bumpMap=null,this.bumpScale=1,this.normalMap=null,this.normalMapType=0,this.normalScale=new te(1,1),this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.roughnessMap=null,this.metalnessMap=null,this.alphaMap=null,this.envMap=null,this.envMapRotation=new Xi,this.envMapIntensity=1,this.wireframe=!1,this.wireframeLinewidth=1,this.wireframeLinecap="round",this.wireframeLinejoin="round",this.flatShading=!1,this.fog=!0,this.setValues(e)}copy(e){return super.copy(e),this.defines={STANDARD:""},this.color.copy(e.color),this.roughness=e.roughness,this.metalness=e.metalness,this.map=e.map,this.lightMap=e.lightMap,this.lightMapIntensity=e.lightMapIntensity,this.aoMap=e.aoMap,this.aoMapIntensity=e.aoMapIntensity,this.emissive.copy(e.emissive),this.emissiveMap=e.emissiveMap,this.emissiveIntensity=e.emissiveIntensity,this.bumpMap=e.bumpMap,this.bumpScale=e.bumpScale,this.normalMap=e.normalMap,this.normalMapType=e.normalMapType,this.normalScale.copy(e.normalScale),this.displacementMap=e.displacementMap,this.displacementScale=e.displacementScale,this.displacementBias=e.displacementBias,this.roughnessMap=e.roughnessMap,this.metalnessMap=e.metalnessMap,this.alphaMap=e.alphaMap,this.envMap=e.envMap,this.envMapRotation.copy(e.envMapRotation),this.envMapIntensity=e.envMapIntensity,this.wireframe=e.wireframe,this.wireframeLinewidth=e.wireframeLinewidth,this.wireframeLinecap=e.wireframeLinecap,this.wireframeLinejoin=e.wireframeLinejoin,this.flatShading=e.flatShading,this.fog=e.fog,this}};var no=class extends mi{constructor(e){super(),this.isMeshDepthMaterial=!0,this.type="MeshDepthMaterial",this.depthPacking=3200,this.map=null,this.alphaMap=null,this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.wireframe=!1,this.wireframeLinewidth=1,this.setValues(e)}copy(e){return super.copy(e),this.depthPacking=e.depthPacking,this.map=e.map,this.alphaMap=e.alphaMap,this.displacementMap=e.displacementMap,this.displacementScale=e.displacementScale,this.displacementBias=e.displacementBias,this.wireframe=e.wireframe,this.wireframeLinewidth=e.wireframeLinewidth,this}},ro=class extends mi{constructor(e){super(),this.isMeshDistanceMaterial=!0,this.type="MeshDistanceMaterial",this.map=null,this.alphaMap=null,this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.setValues(e)}copy(e){return super.copy(e),this.map=e.map,this.alphaMap=e.alphaMap,this.displacementMap=e.displacementMap,this.displacementScale=e.displacementScale,this.displacementBias=e.displacementBias,this}};function Sa(r,e){return r&&r.constructor!==e?typeof e.BYTES_PER_ELEMENT=="number"?new e(r):Array.prototype.slice.call(r):r}var _n=class{constructor(e,t,i,n){this.parameterPositions=e,this._cachedIndex=0,this.resultBuffer=n!==void 0?n:new t.constructor(i),this.sampleValues=t,this.valueSize=i,this.settings=null,this.DefaultSettings_={}}evaluate(e){let t=this.parameterPositions,i=this._cachedIndex,n=t[i],s=t[i-1];i:{e:{let a;t:{n:if(!(e<n)){for(let o=i+2;;){if(n===void 0){if(e<s)break n;return i=t.length,this._cachedIndex=i,this.copySampleValue_(i-1)}if(i===o)break;if(s=n,n=t[++i],e<n)break e}a=t.length;break t}if(!(e>=s)){let o=t[1];e<o&&(i=2,s=o);for(let c=i-2;;){if(s===void 0)return this._cachedIndex=0,this.copySampleValue_(0);if(i===c)break;if(n=s,s=t[--i-1],e>=s)break e}a=i,i=0;break t}break i}for(;i<a;){let o=i+a>>>1;e<t[o]?a=o:i=o+1}if(n=t[i],s=t[i-1],s===void 0)return this._cachedIndex=0,this.copySampleValue_(0);if(n===void 0)return i=t.length,this._cachedIndex=i,this.copySampleValue_(i-1)}this._cachedIndex=i,this.intervalChanged_(i,s,n)}return this.interpolate_(i,s,e,n)}getSettings_(){return this.settings||this.DefaultSettings_}copySampleValue_(e){let t=this.resultBuffer,i=this.sampleValues,n=this.valueSize,s=e*n;for(let a=0;a!==n;++a)t[a]=i[s+a];return t}interpolate_(){throw new Error("THREE.Interpolant: Call to abstract method.")}intervalChanged_(){}},so=class extends _n{constructor(e,t,i,n){super(e,t,i,n),this._weightPrev=-0,this._offsetPrev=-0,this._weightNext=-0,this._offsetNext=-0,this.DefaultSettings_={endingStart:Ol,endingEnd:Ol}}intervalChanged_(e,t,i){let n=this.parameterPositions,s=e-2,a=e+1,o=n[s],c=n[a];if(o===void 0)switch(this.getSettings_().endingStart){case Bl:s=e,o=2*t-i;break;case zl:s=n.length-2,o=t+n[s]-n[s+1];break;default:s=e,o=i}if(c===void 0)switch(this.getSettings_().endingEnd){case Bl:a=e,c=2*i-t;break;case zl:a=1,c=i+n[1]-n[0];break;default:a=e-1,c=t}let l=.5*(i-t),h=this.valueSize;this._weightPrev=l/(t-o),this._weightNext=l/(c-i),this._offsetPrev=s*h,this._offsetNext=a*h}interpolate_(e,t,i,n){let s=this.resultBuffer,a=this.sampleValues,o=this.valueSize,c=e*o,l=c-o,h=this._offsetPrev,d=this._offsetNext,p=this._weightPrev,u=this._weightNext,g=(i-t)/(n-t),m=g*g,v=m*g,f=-p*v+2*p*m-p*g,_=(1+p)*v+(-1.5-2*p)*m+(-.5+p)*g+1,x=(-1-u)*v+(1.5+u)*m+.5*g,S=u*v-u*m;for(let T=0;T!==o;++T)s[T]=f*a[h+T]+_*a[l+T]+x*a[c+T]+S*a[d+T];return s}},ao=class extends _n{constructor(e,t,i,n){super(e,t,i,n)}interpolate_(e,t,i,n){let s=this.resultBuffer,a=this.sampleValues,o=this.valueSize,c=e*o,l=c-o,h=(i-t)/(n-t),d=1-h;for(let p=0;p!==o;++p)s[p]=a[l+p]*d+a[c+p]*h;return s}},oo=class extends _n{constructor(e,t,i,n){super(e,t,i,n)}interpolate_(e){return this.copySampleValue_(e-1)}},lo=class extends _n{interpolate_(e,t,i,n){let s=this.resultBuffer,a=this.sampleValues,o=this.valueSize,c=e*o,l=c-o,h=this.inTangents,d=this.outTangents;if(!h||!d){let g=(i-t)/(n-t),m=1-g;for(let v=0;v!==o;++v)s[v]=a[l+v]*m+a[c+v]*g;return s}let p=2*o,u=e-1;for(let g=0;g!==o;++g){let m=a[l+g],v=a[c+g],f=u*p+2*g,_=d[f],x=d[f+1],S=e*p+2*g,T=h[S],M=h[S+1],P,O,L,I,B,U=(i-t)/(n-t);for(let X=0;X<8;X++){P=U*U,O=P*U,L=1-U,I=L*L,B=I*L;let k=B*t+3*I*U*_+3*L*P*T+O*n-i;if(Math.abs(k)<1e-10)break;let V=3*I*(_-t)+6*L*U*(T-_)+3*P*(n-T);if(Math.abs(V)<1e-10)break;U-=k/V,U=Math.max(0,Math.min(1,U))}s[g]=B*m+3*I*U*x+3*L*P*M+O*v}return s}},Xt=class{constructor(e,t,i,n){if(e===void 0)throw new Error("THREE.KeyframeTrack: track name is undefined");if(t===void 0||t.length===0)throw new Error("THREE.KeyframeTrack: no keyframes in track named "+e);this.name=e,this.times=Sa(t,this.TimeBufferType),this.values=Sa(i,this.ValueBufferType),this.setInterpolation(n||this.DefaultInterpolation)}static toJSON(e){let t=e.constructor,i;if(t.toJSON!==this.toJSON)i=t.toJSON(e);else{i={name:e.name,times:Sa(e.times,Array),values:Sa(e.values,Array)};let n=e.getInterpolation();n!==e.DefaultInterpolation&&(i.interpolation=n)}return i.type=e.ValueTypeName,i}InterpolantFactoryMethodDiscrete(e){return new oo(this.times,this.values,this.getValueSize(),e)}InterpolantFactoryMethodLinear(e){return new ao(this.times,this.values,this.getValueSize(),e)}InterpolantFactoryMethodSmooth(e){return new so(this.times,this.values,this.getValueSize(),e)}InterpolantFactoryMethodBezier(e){let t=new lo(this.times,this.values,this.getValueSize(),e);return this.settings&&(t.inTangents=this.settings.inTangents,t.outTangents=this.settings.outTangents),t}setInterpolation(e){let t;switch(e){case ss:t=this.InterpolantFactoryMethodDiscrete;break;case Ra:t=this.InterpolantFactoryMethodLinear;break;case Ea:t=this.InterpolantFactoryMethodSmooth;break;case Fl:t=this.InterpolantFactoryMethodBezier}if(t===void 0){let i="unsupported interpolation for "+this.ValueTypeName+" keyframe track named "+this.name;if(this.createInterpolant===void 0){if(e===this.DefaultInterpolation)throw new Error(i);this.setInterpolation(this.DefaultInterpolation)}return be("KeyframeTrack:",i),this}return this.createInterpolant=t,this}getInterpolation(){switch(this.createInterpolant){case this.InterpolantFactoryMethodDiscrete:return ss;case this.InterpolantFactoryMethodLinear:return Ra;case this.InterpolantFactoryMethodSmooth:return Ea;case this.InterpolantFactoryMethodBezier:return Fl}}getValueSize(){return this.values.length/this.times.length}shift(e){if(e!==0){let t=this.times;for(let i=0,n=t.length;i!==n;++i)t[i]+=e}return this}scale(e){if(e!==1){let t=this.times;for(let i=0,n=t.length;i!==n;++i)t[i]*=e}return this}trim(e,t){let i=this.times,n=i.length,s=0,a=n-1;for(;s!==n&&i[s]<e;)++s;for(;a!==-1&&i[a]>t;)--a;if(++a,s!==0||a!==n){s>=a&&(a=Math.max(a,1),s=a-1);let o=this.getValueSize();this.times=i.slice(s,a),this.values=this.values.slice(s*o,a*o)}return this}validate(){let e=!0,t=this.getValueSize();t-Math.floor(t)!==0&&(we("KeyframeTrack: Invalid value size in track.",this),e=!1);let i=this.times,n=this.values,s=i.length;s===0&&(we("KeyframeTrack: Track is empty.",this),e=!1);let a=null;for(let o=0;o!==s;o++){let c=i[o];if(typeof c=="number"&&isNaN(c)){we("KeyframeTrack: Time is not a valid number.",this,o,c),e=!1;break}if(a!==null&&a>c){we("KeyframeTrack: Out of order keys.",this,o,c,a),e=!1;break}a=c}if(n!==void 0&&Rp(n))for(let o=0,c=n.length;o!==c;++o){let l=n[o];if(isNaN(l)){we("KeyframeTrack: Value is not a valid number.",this,o,l),e=!1;break}}return e}optimize(){let e=this.times.slice(),t=this.values.slice(),i=this.getValueSize(),n=this.getInterpolation()===Ea,s=e.length-1,a=1;for(let o=1;o<s;++o){let c=!1,l=e[o];if(l!==e[o+1]&&(o!==1||l!==e[0]))if(n)c=!0;else{let h=o*i,d=h-i,p=h+i;for(let u=0;u!==i;++u){let g=t[h+u];if(g!==t[d+u]||g!==t[p+u]){c=!0;break}}}if(c){if(o!==a){e[a]=e[o];let h=o*i,d=a*i;for(let p=0;p!==i;++p)t[d+p]=t[h+p]}++a}}if(s>0){e[a]=e[s];for(let o=s*i,c=a*i,l=0;l!==i;++l)t[c+l]=t[o+l];++a}return a!==e.length?(this.times=e.slice(0,a),this.values=t.slice(0,a*i)):(this.times=e,this.values=t),this}clone(){let e=this.times.slice(),t=this.values.slice(),i=new this.constructor(this.name,e,t);return i.createInterpolant=this.createInterpolant,i}};Xt.prototype.ValueTypeName="",Xt.prototype.TimeBufferType=Float32Array,Xt.prototype.ValueBufferType=Float32Array,Xt.prototype.DefaultInterpolation=Ra;var hn=class extends Xt{constructor(e,t,i){super(e,t,i)}};hn.prototype.ValueTypeName="bool",hn.prototype.ValueBufferType=Array,hn.prototype.DefaultInterpolation=ss,hn.prototype.InterpolantFactoryMethodLinear=void 0,hn.prototype.InterpolantFactoryMethodSmooth=void 0;var co=class extends Xt{constructor(e,t,i,n){super(e,t,i,n)}};co.prototype.ValueTypeName="color";var ho=class extends Xt{constructor(e,t,i,n){super(e,t,i,n)}};ho.prototype.ValueTypeName="number";var uo=class extends _n{constructor(e,t,i,n){super(e,t,i,n)}interpolate_(e,t,i,n){let s=this.resultBuffer,a=this.sampleValues,o=this.valueSize,c=(i-t)/(n-t),l=e*o;for(let h=l+o;l!==h;l+=4)ii.slerpFlat(s,0,a,l-o,a,l,c);return s}},As=class extends Xt{constructor(e,t,i,n){super(e,t,i,n)}InterpolantFactoryMethodLinear(e){return new uo(this.times,this.values,this.getValueSize(),e)}};As.prototype.ValueTypeName="quaternion",As.prototype.InterpolantFactoryMethodSmooth=void 0;var un=class extends Xt{constructor(e,t,i){super(e,t,i)}};un.prototype.ValueTypeName="string",un.prototype.ValueBufferType=Array,un.prototype.DefaultInterpolation=ss,un.prototype.InterpolantFactoryMethodLinear=void 0,un.prototype.InterpolantFactoryMethodSmooth=void 0;var po=class extends Xt{constructor(e,t,i,n){super(e,t,i,n)}};po.prototype.ValueTypeName="vector";var wa={enabled:!1,files:{},add:function(r,e){this.enabled!==!1&&(Cu(r)||(this.files[r]=e))},get:function(r){if(this.enabled!==!1&&!Cu(r))return this.files[r]},remove:function(r){delete this.files[r]},clear:function(){this.files={}}};function Cu(r){try{let e=r.slice(r.indexOf(":")+1);return new URL(e).protocol==="blob:"}catch{return!1}}var mo=class{constructor(e,t,i){let n=this,s,a=!1,o=0,c=0,l=[];this.onStart=void 0,this.onLoad=e,this.onProgress=t,this.onError=i,this._abortController=null,this.itemStart=function(h){c++,a===!1&&n.onStart!==void 0&&n.onStart(h,o,c),a=!0},this.itemEnd=function(h){o++,n.onProgress!==void 0&&n.onProgress(h,o,c),o===c&&(a=!1,n.onLoad!==void 0&&n.onLoad())},this.itemError=function(h){n.onError!==void 0&&n.onError(h)},this.resolveURL=function(h){return h=h.normalize("NFC"),s?s(h):h},this.setURLModifier=function(h){return s=h,this},this.addHandler=function(h,d){return l.push(h,d),this},this.removeHandler=function(h){let d=l.indexOf(h);return d!==-1&&l.splice(d,2),this},this.getHandler=function(h){for(let d=0,p=l.length;d<p;d+=2){let u=l[d],g=l[d+1];if(u.global&&(u.lastIndex=0),u.test(h))return g}return null},this.abort=function(){return this.abortController.abort(),this._abortController=null,this}}get abortController(){return this._abortController||(this._abortController=new AbortController),this._abortController}},Ed=new mo,Cr=class{constructor(e){this.manager=e!==void 0?e:Ed,this.crossOrigin="anonymous",this.withCredentials=!1,this.path="",this.resourcePath="",this.requestHeader={},typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}load(){}loadAsync(e,t){let i=this;return new Promise(function(n,s){i.load(e,n,t,s)})}parse(){}setCrossOrigin(e){return this.crossOrigin=e,this}setWithCredentials(e){return this.withCredentials=e,this}setPath(e){return this.path=e,this}setResourcePath(e){return this.resourcePath=e,this}setRequestHeader(e){return this.requestHeader=e,this}abort(){return this}};Cr.DEFAULT_MATERIAL_NAME="__DEFAULT";var cr=new WeakMap,fo=class extends Cr{constructor(e){super(e)}load(e,t,i,n){this.path!==void 0&&(e=this.path+e),e=this.manager.resolveURL(e);let s=this,a=wa.get(`image:${e}`);if(a!==void 0){if(a.complete===!0)s.manager.itemStart(e),setTimeout(function(){t&&t(a),s.manager.itemEnd(e)},0);else{let d=cr.get(a);d===void 0&&(d=[],cr.set(a,d)),d.push({onLoad:t,onError:n})}return a}let o=mr("img");function c(){h(),t&&t(this);let d=cr.get(this)||[];for(let p=0;p<d.length;p++){let u=d[p];u.onLoad&&u.onLoad(this)}cr.delete(this),s.manager.itemEnd(e)}function l(d){h(),n&&n(d),wa.remove(`image:${e}`);let p=cr.get(this)||[];for(let u=0;u<p.length;u++){let g=p[u];g.onError&&g.onError(d)}cr.delete(this),s.manager.itemError(e),s.manager.itemEnd(e)}function h(){o.removeEventListener("load",c,!1),o.removeEventListener("error",l,!1)}return o.addEventListener("load",c,!1),o.addEventListener("error",l,!1),e.slice(0,5)!=="data:"&&this.crossOrigin!==void 0&&(o.crossOrigin=this.crossOrigin),wa.add(`image:${e}`,o),s.manager.itemStart(e),o.src=e,o}};var Cs=class extends Cr{constructor(e){super(e)}load(e,t,i,n){let s=new Nt,a=new fo(this.manager);return a.setCrossOrigin(this.crossOrigin),a.setPath(this.path),a.load(e,function(o){s.image=o,s.needsUpdate=!0,t!==void 0&&t(s)},i,n),s}},Rr=class extends Tt{constructor(e,t=1){super(),this.isLight=!0,this.type="Light",this.color=new Ie(e),this.intensity=t}dispose(){this.dispatchEvent({type:"dispose"})}copy(e,t){return super.copy(e,t),this.color.copy(e.color),this.intensity=e.intensity,this}toJSON(e){let t=super.toJSON(e);return t.object.color=this.color.getHex(),t.object.intensity=this.intensity,t}};var Dl=new Fe,Ru=new w,Pu=new w,go=class{constructor(e){this.camera=e,this.intensity=1,this.bias=0,this.biasNode=null,this.normalBias=0,this.radius=1,this.blurSamples=8,this.mapSize=new te(512,512),this.mapType=Zt,this.map=null,this.mapPass=null,this.matrix=new Fe,this.autoUpdate=!0,this.needsUpdate=!1,this._frustum=new ji,this._frameExtents=new te(1,1),this._viewportCount=1,this._viewports=[new $e(0,0,1,1)]}getViewportCount(){return this._viewportCount}getFrustum(){return this._frustum}updateMatrices(e){let t=this.camera,i=this.matrix;Ru.setFromMatrixPosition(e.matrixWorld),t.position.copy(Ru),Pu.setFromMatrixPosition(e.target.matrixWorld),t.lookAt(Pu),t.updateMatrixWorld(),Dl.multiplyMatrices(t.projectionMatrix,t.matrixWorldInverse),this._frustum.setFromProjectionMatrix(Dl,t.coordinateSystem,t.reversedDepth),t.coordinateSystem===pr||t.reversedDepth?i.set(.5,0,0,.5,0,.5,0,.5,0,0,1,0,0,0,0,1):i.set(.5,0,0,.5,0,.5,0,.5,0,0,.5,.5,0,0,0,1),i.multiply(Dl)}getViewport(e){return this._viewports[e]}getFrameExtents(){return this._frameExtents}dispose(){this.map&&this.map.dispose(),this.mapPass&&this.mapPass.dispose()}copy(e){return this.camera=e.camera.clone(),this.intensity=e.intensity,this.bias=e.bias,this.radius=e.radius,this.autoUpdate=e.autoUpdate,this.needsUpdate=e.needsUpdate,this.normalBias=e.normalBias,this.blurSamples=e.blurSamples,this.mapSize.copy(e.mapSize),this.biasNode=e.biasNode,this}clone(){return new this.constructor().copy(this)}toJSON(){let e={};return this.intensity!==1&&(e.intensity=this.intensity),this.bias!==0&&(e.bias=this.bias),this.normalBias!==0&&(e.normalBias=this.normalBias),this.radius!==1&&(e.radius=this.radius),this.mapSize.x===512&&this.mapSize.y===512||(e.mapSize=this.mapSize.toArray()),e.camera=this.camera.toJSON(!1).object,delete e.camera.matrix,e}},ba=new w,Ta=new ii,Ti=new w,Pr=class extends Tt{constructor(){super(),this.isCamera=!0,this.type="Camera",this.matrixWorldInverse=new Fe,this.projectionMatrix=new Fe,this.projectionMatrixInverse=new Fe,this.coordinateSystem=Wi,this._reversedDepth=!1}get reversedDepth(){return this._reversedDepth}copy(e,t){return super.copy(e,t),this.matrixWorldInverse.copy(e.matrixWorldInverse),this.projectionMatrix.copy(e.projectionMatrix),this.projectionMatrixInverse.copy(e.projectionMatrixInverse),this.coordinateSystem=e.coordinateSystem,this}getWorldDirection(e){return super.getWorldDirection(e).negate()}updateMatrixWorld(e){super.updateMatrixWorld(e),this.matrixWorld.decompose(ba,Ta,Ti),Ti.x===1&&Ti.y===1&&Ti.z===1?this.matrixWorldInverse.copy(this.matrixWorld).invert():this.matrixWorldInverse.compose(ba,Ta,Ti.set(1,1,1)).invert()}updateWorldMatrix(e,t,i=!1){super.updateWorldMatrix(e,t,i),this.matrixWorld.decompose(ba,Ta,Ti),Ti.x===1&&Ti.y===1&&Ti.z===1?this.matrixWorldInverse.copy(this.matrixWorld).invert():this.matrixWorldInverse.compose(ba,Ta,Ti.set(1,1,1)).invert()}clone(){return new this.constructor().copy(this)}},cn=new w,Iu=new te,Lu=new te,Rt=class extends Pr{constructor(e=50,t=1,i=.1,n=2e3){super(),this.isPerspectiveCamera=!0,this.type="PerspectiveCamera",this.fov=e,this.zoom=1,this.near=i,this.far=n,this.focus=10,this.aspect=t,this.view=null,this.filmGauge=35,this.filmOffset=0,this.updateProjectionMatrix()}copy(e,t){return super.copy(e,t),this.fov=e.fov,this.zoom=e.zoom,this.near=e.near,this.far=e.far,this.focus=e.focus,this.aspect=e.aspect,this.view=e.view===null?null:Object.assign({},e.view),this.filmGauge=e.filmGauge,this.filmOffset=e.filmOffset,this}setFocalLength(e){let t=.5*this.getFilmHeight()/e;this.fov=2*gr*Math.atan(t),this.updateProjectionMatrix()}getFocalLength(){let e=Math.tan(.5*ur*this.fov);return .5*this.getFilmHeight()/e}getEffectiveFOV(){return 2*gr*Math.atan(Math.tan(.5*ur*this.fov)/this.zoom)}getFilmWidth(){return this.filmGauge*Math.min(this.aspect,1)}getFilmHeight(){return this.filmGauge/Math.max(this.aspect,1)}getViewBounds(e,t,i){cn.set(-1,-1,.5).applyMatrix4(this.projectionMatrixInverse),t.set(cn.x,cn.y).multiplyScalar(-e/cn.z),cn.set(1,1,.5).applyMatrix4(this.projectionMatrixInverse),i.set(cn.x,cn.y).multiplyScalar(-e/cn.z)}getViewSize(e,t){return this.getViewBounds(e,Iu,Lu),t.subVectors(Lu,Iu)}setViewOffset(e,t,i,n,s,a){this.aspect=e/t,this.view===null&&(this.view={enabled:!0,fullWidth:1,fullHeight:1,offsetX:0,offsetY:0,width:1,height:1}),this.view.enabled=!0,this.view.fullWidth=e,this.view.fullHeight=t,this.view.offsetX=i,this.view.offsetY=n,this.view.width=s,this.view.height=a,this.updateProjectionMatrix()}clearViewOffset(){this.view!==null&&(this.view.enabled=!1),this.updateProjectionMatrix()}updateProjectionMatrix(){let e=this.near,t=e*Math.tan(.5*ur*this.fov)/this.zoom,i=2*t,n=this.aspect*i,s=-.5*n,a=this.view;if(this.view!==null&&this.view.enabled){let c=a.fullWidth,l=a.fullHeight;s+=a.offsetX*n/c,t-=a.offsetY*i/l,n*=a.width/c,i*=a.height/l}let o=this.filmOffset;o!==0&&(s+=e*o/this.getFilmWidth()),this.projectionMatrix.makePerspective(s,s+n,t,t-i,e,this.far,this.coordinateSystem,this.reversedDepth),this.projectionMatrixInverse.copy(this.projectionMatrix).invert()}toJSON(e){let t=super.toJSON(e);return t.object.fov=this.fov,t.object.zoom=this.zoom,t.object.near=this.near,t.object.far=this.far,t.object.focus=this.focus,t.object.aspect=this.aspect,this.view!==null&&(t.object.view=Object.assign({},this.view)),t.object.filmGauge=this.filmGauge,t.object.filmOffset=this.filmOffset,t}};var jl=class extends go{constructor(){super(new Rt(90,1,.5,500)),this.isPointLightShadow=!0}},Ir=class extends Rr{constructor(e,t,i=0,n=2){super(e,t),this.isPointLight=!0,this.type="PointLight",this.distance=i,this.decay=n,this.shadow=new jl}get power(){return 4*this.intensity*Math.PI}set power(e){this.intensity=e/(4*Math.PI)}dispose(){super.dispose(),this.shadow.dispose()}copy(e,t){return super.copy(e,t),this.distance=e.distance,this.decay=e.decay,this.shadow=e.shadow.clone(),this}toJSON(e){let t=super.toJSON(e);return t.object.distance=this.distance,t.object.decay=this.decay,t.object.shadow=this.shadow.toJSON(),t}},Lr=class extends Pr{constructor(e=-1,t=1,i=1,n=-1,s=.1,a=2e3){super(),this.isOrthographicCamera=!0,this.type="OrthographicCamera",this.zoom=1,this.view=null,this.left=e,this.right=t,this.top=i,this.bottom=n,this.near=s,this.far=a,this.updateProjectionMatrix()}copy(e,t){return super.copy(e,t),this.left=e.left,this.right=e.right,this.top=e.top,this.bottom=e.bottom,this.near=e.near,this.far=e.far,this.zoom=e.zoom,this.view=e.view===null?null:Object.assign({},e.view),this}setViewOffset(e,t,i,n,s,a){this.view===null&&(this.view={enabled:!0,fullWidth:1,fullHeight:1,offsetX:0,offsetY:0,width:1,height:1}),this.view.enabled=!0,this.view.fullWidth=e,this.view.fullHeight=t,this.view.offsetX=i,this.view.offsetY=n,this.view.width=s,this.view.height=a,this.updateProjectionMatrix()}clearViewOffset(){this.view!==null&&(this.view.enabled=!1),this.updateProjectionMatrix()}updateProjectionMatrix(){let e=(this.right-this.left)/(2*this.zoom),t=(this.top-this.bottom)/(2*this.zoom),i=(this.right+this.left)/2,n=(this.top+this.bottom)/2,s=i-e,a=i+e,o=n+t,c=n-t;if(this.view!==null&&this.view.enabled){let l=(this.right-this.left)/this.view.fullWidth/this.zoom,h=(this.top-this.bottom)/this.view.fullHeight/this.zoom;s+=l*this.view.offsetX,a=s+l*this.view.width,o-=h*this.view.offsetY,c=o-h*this.view.height}this.projectionMatrix.makeOrthographic(s,a,o,c,this.near,this.far,this.coordinateSystem,this.reversedDepth),this.projectionMatrixInverse.copy(this.projectionMatrix).invert()}toJSON(e){let t=super.toJSON(e);return t.object.zoom=this.zoom,t.object.left=this.left,t.object.right=this.right,t.object.top=this.top,t.object.bottom=this.bottom,t.object.near=this.near,t.object.far=this.far,this.view!==null&&(t.object.view=Object.assign({},this.view)),t}},ql=class extends go{constructor(){super(new Lr(-5,5,5,-5,.5,500)),this.isDirectionalLightShadow=!0}},Rs=class extends Rr{constructor(e,t){super(e,t),this.isDirectionalLight=!0,this.type="DirectionalLight",this.position.copy(Tt.DEFAULT_UP),this.updateMatrix(),this.target=new Tt,this.shadow=new ql}dispose(){super.dispose(),this.shadow.dispose()}copy(e){return super.copy(e),this.target=e.target.clone(),this.shadow=e.shadow.clone(),this}toJSON(e){let t=super.toJSON(e);return t.object.shadow=this.shadow.toJSON(),t.object.target=this.target.uuid,t}},Ps=class extends Rr{constructor(e,t){super(e,t),this.isAmbientLight=!0,this.type="AmbientLight"}};var Bg=new Fe,zg=new Fe,Gg=new Fe;var hr=-90,_o=class extends Tt{constructor(e,t,i){super(),this.type="CubeCamera",this.renderTarget=i,this.coordinateSystem=null,this.activeMipmapLevel=0;let n=new Rt(hr,1,e,t);n.layers=this.layers,this.add(n);let s=new Rt(hr,1,e,t);s.layers=this.layers,this.add(s);let a=new Rt(hr,1,e,t);a.layers=this.layers,this.add(a);let o=new Rt(hr,1,e,t);o.layers=this.layers,this.add(o);let c=new Rt(hr,1,e,t);c.layers=this.layers,this.add(c);let l=new Rt(hr,1,e,t);l.layers=this.layers,this.add(l)}updateCoordinateSystem(){let e=this.coordinateSystem,t=this.children.concat(),[i,n,s,a,o,c]=t;for(let l of t)this.remove(l);if(e===Wi)i.up.set(0,1,0),i.lookAt(1,0,0),n.up.set(0,1,0),n.lookAt(-1,0,0),s.up.set(0,0,-1),s.lookAt(0,1,0),a.up.set(0,0,1),a.lookAt(0,-1,0),o.up.set(0,1,0),o.lookAt(0,0,1),c.up.set(0,1,0),c.lookAt(0,0,-1);else{if(e!==pr)throw new Error("THREE.CubeCamera.updateCoordinateSystem(): Invalid coordinate system: "+e);i.up.set(0,-1,0),i.lookAt(-1,0,0),n.up.set(0,-1,0),n.lookAt(1,0,0),s.up.set(0,0,1),s.lookAt(0,1,0),a.up.set(0,0,-1),a.lookAt(0,-1,0),o.up.set(0,-1,0),o.lookAt(0,0,1),c.up.set(0,-1,0),c.lookAt(0,0,-1)}for(let l of t)this.add(l),l.updateMatrixWorld()}update(e,t){this.parent===null&&this.updateMatrixWorld();let{renderTarget:i,activeMipmapLevel:n}=this;this.coordinateSystem!==e.coordinateSystem&&(this.coordinateSystem=e.coordinateSystem,this.updateCoordinateSystem());let[s,a,o,c,l,h]=this.children,d=e.getRenderTarget(),p=e.getActiveCubeFace(),u=e.getActiveMipmapLevel(),g=e.xr.enabled;e.xr.enabled=!1;let m=i.texture.generateMipmaps;i.texture.generateMipmaps=!1;let v=!1;v=e.isWebGLRenderer===!0?e.state.buffers.depth.getReversed():e.reversedDepthBuffer,e.setRenderTarget(i,0,n),v&&e.autoClear===!1&&e.clearDepth(),e.render(t,s),e.setRenderTarget(i,1,n),v&&e.autoClear===!1&&e.clearDepth(),e.render(t,a),e.setRenderTarget(i,2,n),v&&e.autoClear===!1&&e.clearDepth(),e.render(t,o),e.setRenderTarget(i,3,n),v&&e.autoClear===!1&&e.clearDepth(),e.render(t,c),e.setRenderTarget(i,4,n),v&&e.autoClear===!1&&e.clearDepth(),e.render(t,l),i.texture.generateMipmaps=m,e.setRenderTarget(i,5,n),v&&e.autoClear===!1&&e.clearDepth(),e.render(t,h),e.setRenderTarget(d,p,u),e.xr.enabled=g,i.texture.needsPMREMUpdate=!0}},vo=class extends Rt{constructor(e=[]){super(),this.isArrayCamera=!0,this.isMultiViewCamera=!1,this.cameras=e}};var Vg=new w,Hg=new ii,kg=new w,Wg=new w,Xg=new w;var jg=new w,qg=new ii,Yg=new w,Zg=new w;var eh="\\[\\]\\.:\\/",sm=new RegExp("["+eh+"]","g"),Ul="[^"+eh+"]",am="[^"+eh.replace("\\.","")+"]",om=new RegExp("^"+/((?:WC+[\/:])*)/.source.replace("WC",Ul)+/(WCOD+)?/.source.replace("WCOD",am)+/(?:\.(WC+)(?:\[(.+)\])?)?/.source.replace("WC",Ul)+/\.(WC+)(?:\[(.+)\])?/.source.replace("WC",Ul)+"$"),lm=["material","materials","bones","map"],it=class r{constructor(e,t,i){this.path=t,this.parsedPath=i||r.parseTrackName(t),this.node=r.findNode(e,this.parsedPath.nodeName),this.rootNode=e,this.getValue=this._getValue_unbound,this.setValue=this._setValue_unbound}static create(e,t,i){return e&&e.isAnimationObjectGroup?new r.Composite(e,t,i):new r(e,t,i)}static sanitizeNodeName(e){return e.replace(/\s/g,"_").replace(sm,"")}static parseTrackName(e){let t=om.exec(e);if(t===null)throw new Error("THREE.PropertyBinding: Cannot parse trackName: "+e);let i={nodeName:t[2],objectName:t[3],objectIndex:t[4],propertyName:t[5],propertyIndex:t[6]},n=i.nodeName&&i.nodeName.lastIndexOf(".");if(n!==void 0&&n!==-1){let s=i.nodeName.substring(n+1);lm.indexOf(s)!==-1&&(i.nodeName=i.nodeName.substring(0,n),i.objectName=s)}if(i.propertyName===null||i.propertyName.length===0)throw new Error("THREE.PropertyBinding: can not parse propertyName from trackName: "+e);return i}static findNode(e,t){if(t===void 0||t===""||t==="."||t===-1||t===e.name||t===e.uuid)return e;if(e.skeleton){let i=e.skeleton.getBoneByName(t);if(i!==void 0)return i}if(e.children){let i=function(s){for(let a=0;a<s.length;a++){let o=s[a];if(o.name===t||o.uuid===t)return o;let c=i(o.children);if(c)return c}return null},n=i(e.children);if(n)return n}return null}_getValue_unavailable(){}_setValue_unavailable(){}_getValue_direct(e,t){e[t]=this.targetObject[this.propertyName]}_getValue_array(e,t){let i=this.resolvedProperty;for(let n=0,s=i.length;n!==s;++n)e[t++]=i[n]}_getValue_arrayElement(e,t){e[t]=this.resolvedProperty[this.propertyIndex]}_getValue_toArray(e,t){this.resolvedProperty.toArray(e,t)}_setValue_direct(e,t){this.targetObject[this.propertyName]=e[t]}_setValue_direct_setNeedsUpdate(e,t){this.targetObject[this.propertyName]=e[t],this.targetObject.needsUpdate=!0}_setValue_direct_setMatrixWorldNeedsUpdate(e,t){this.targetObject[this.propertyName]=e[t],this.targetObject.matrixWorldNeedsUpdate=!0}_setValue_array(e,t){let i=this.resolvedProperty;for(let n=0,s=i.length;n!==s;++n)i[n]=e[t++]}_setValue_array_setNeedsUpdate(e,t){let i=this.resolvedProperty;for(let n=0,s=i.length;n!==s;++n)i[n]=e[t++];this.targetObject.needsUpdate=!0}_setValue_array_setMatrixWorldNeedsUpdate(e,t){let i=this.resolvedProperty;for(let n=0,s=i.length;n!==s;++n)i[n]=e[t++];this.targetObject.matrixWorldNeedsUpdate=!0}_setValue_arrayElement(e,t){this.resolvedProperty[this.propertyIndex]=e[t]}_setValue_arrayElement_setNeedsUpdate(e,t){this.resolvedProperty[this.propertyIndex]=e[t],this.targetObject.needsUpdate=!0}_setValue_arrayElement_setMatrixWorldNeedsUpdate(e,t){this.resolvedProperty[this.propertyIndex]=e[t],this.targetObject.matrixWorldNeedsUpdate=!0}_setValue_fromArray(e,t){this.resolvedProperty.fromArray(e,t)}_setValue_fromArray_setNeedsUpdate(e,t){this.resolvedProperty.fromArray(e,t),this.targetObject.needsUpdate=!0}_setValue_fromArray_setMatrixWorldNeedsUpdate(e,t){this.resolvedProperty.fromArray(e,t),this.targetObject.matrixWorldNeedsUpdate=!0}_getValue_unbound(e,t){this.bind(),this.getValue(e,t)}_setValue_unbound(e,t){this.bind(),this.setValue(e,t)}bind(){let e=this.node,t=this.parsedPath,i=t.objectName,n=t.propertyName,s=t.propertyIndex;if(e||(e=r.findNode(this.rootNode,t.nodeName),this.node=e),this.getValue=this._getValue_unavailable,this.setValue=this._setValue_unavailable,!e)return void be("PropertyBinding: No target node found for track: "+this.path+".");if(i){let l=t.objectIndex;switch(i){case"materials":if(!e.material)return void we("PropertyBinding: Can not bind to material as node does not have a material.",this);if(!e.material.materials)return void we("PropertyBinding: Can not bind to material.materials as node.material does not have a materials array.",this);e=e.material.materials;break;case"bones":if(!e.skeleton)return void we("PropertyBinding: Can not bind to bones as node does not have a skeleton.",this);e=e.skeleton.bones;for(let h=0;h<e.length;h++)if(e[h].name===l){l=h;break}break;case"map":if("map"in e){e=e.map;break}if(!e.material)return void we("PropertyBinding: Can not bind to material as node does not have a material.",this);if(!e.material.map)return void we("PropertyBinding: Can not bind to material.map as node.material does not have a map.",this);e=e.material.map;break;default:if(e[i]===void 0)return void we("PropertyBinding: Can not bind to objectName of node undefined.",this);e=e[i]}if(l!==void 0){if(e[l]===void 0)return void we("PropertyBinding: Trying to bind to objectIndex of objectName, but is undefined.",this,e);e=e[l]}}let a=e[n];if(a===void 0)return void we("PropertyBinding: Trying to update property for track: "+t.nodeName+"."+n+" but it wasn't found.",e);let o=this.Versioning.None;this.targetObject=e,e.isMaterial===!0?o=this.Versioning.NeedsUpdate:e.isObject3D===!0&&(o=this.Versioning.MatrixWorldNeedsUpdate);let c=this.BindingType.Direct;if(s!==void 0){if(n==="morphTargetInfluences"){if(!e.geometry)return void we("PropertyBinding: Can not bind to morphTargetInfluences because node does not have a geometry.",this);if(!e.geometry.morphAttributes)return void we("PropertyBinding: Can not bind to morphTargetInfluences because node does not have a geometry.morphAttributes.",this);e.morphTargetDictionary[s]!==void 0&&(s=e.morphTargetDictionary[s])}c=this.BindingType.ArrayElement,this.resolvedProperty=a,this.propertyIndex=s}else a.fromArray!==void 0&&a.toArray!==void 0?(c=this.BindingType.HasFromToArray,this.resolvedProperty=a):Array.isArray(a)?(c=this.BindingType.EntireArray,this.resolvedProperty=a):this.propertyName=n;this.getValue=this.GetterByBindingType[c],this.setValue=this.SetterByBindingTypeAndVersioning[c][o]}unbind(){this.node=null,this.getValue=this._getValue_unbound,this.setValue=this._setValue_unbound}};it.Composite=class{constructor(r,e,t){let i=t||it.parseTrackName(e);this._targetGroup=r,this._bindings=r.subscribe_(e,i)}getValue(r,e){this.bind();let t=this._targetGroup.nCachedObjects_,i=this._bindings[t];i!==void 0&&i.getValue(r,e)}setValue(r,e){let t=this._bindings;for(let i=this._targetGroup.nCachedObjects_,n=t.length;i!==n;++i)t[i].setValue(r,e)}bind(){let r=this._bindings;for(let e=this._targetGroup.nCachedObjects_,t=r.length;e!==t;++e)r[e].bind()}unbind(){let r=this._bindings;for(let e=this._targetGroup.nCachedObjects_,t=r.length;e!==t;++e)r[e].unbind()}},it.prototype.BindingType={Direct:0,EntireArray:1,ArrayElement:2,HasFromToArray:3},it.prototype.Versioning={None:0,NeedsUpdate:1,MatrixWorldNeedsUpdate:2},it.prototype.GetterByBindingType=[it.prototype._getValue_direct,it.prototype._getValue_array,it.prototype._getValue_arrayElement,it.prototype._getValue_toArray],it.prototype.SetterByBindingTypeAndVersioning=[[it.prototype._setValue_direct,it.prototype._setValue_direct_setNeedsUpdate,it.prototype._setValue_direct_setMatrixWorldNeedsUpdate],[it.prototype._setValue_array,it.prototype._setValue_array_setNeedsUpdate,it.prototype._setValue_array_setMatrixWorldNeedsUpdate],[it.prototype._setValue_arrayElement,it.prototype._setValue_arrayElement_setNeedsUpdate,it.prototype._setValue_arrayElement_setMatrixWorldNeedsUpdate],[it.prototype._setValue_fromArray,it.prototype._setValue_fromArray_setNeedsUpdate,it.prototype._setValue_fromArray_setMatrixWorldNeedsUpdate]];var Jg=new Float32Array(1);var Kg=new Fe;var Yl=class r{static{r.prototype.isMatrix2=!0}constructor(e,t,i,n){this.elements=[1,0,0,1],e!==void 0&&this.set(e,t,i,n)}identity(){return this.set(1,0,0,1),this}fromArray(e,t=0){for(let i=0;i<4;i++)this.elements[i]=e[i+t];return this}set(e,t,i,n){let s=this.elements;return s[0]=e,s[2]=t,s[1]=i,s[3]=n,this}},$g=new te;var Qg=new w,e0=new w,t0=new w,i0=new w,n0=new w,r0=new w,s0=new w;var a0=new w;var o0=new w,l0=new Fe,c0=new Fe;var h0=new w,u0=new Ie,d0=new Ie;var p0=new w,m0=new w,f0=new w;var g0=new w,_0=new Pr;var v0=new di;var x0=new w;function th(r,e,t,i){let n=(function(s){switch(s){case Zt:case dc:return{byteLength:1,components:1};case Or:case pc:case Li:return{byteLength:2,components:1};case To:case Eo:return{byteLength:2,components:4};case $i:case bo:case _i:return{byteLength:4,components:1};case mc:case fc:return{byteLength:4,components:3}}throw new Error(`THREE.TextureUtils: Unknown texture type ${s}.`)})(i);switch(t){case 1021:return r*e;case gc:case wo:return r*e/n.components*n.byteLength;case 1030:case 1031:return r*e*2/n.components*n.byteLength;case 1022:return r*e*3/n.components*n.byteLength;case vi:case 1033:return r*e*4/n.components*n.byteLength;case 33776:case 33777:return Math.floor((r+3)/4)*Math.floor((e+3)/4)*8;case 33778:case 33779:return Math.floor((r+3)/4)*Math.floor((e+3)/4)*16;case 35841:case 35843:return Math.max(r,16)*Math.max(e,8)/4;case 35840:case 35842:return Math.max(r,8)*Math.max(e,8)/2;case 36196:case 37492:case 37488:case 37489:return Math.floor((r+3)/4)*Math.floor((e+3)/4)*8;case 37496:case 37490:case 37491:case 37808:return Math.floor((r+3)/4)*Math.floor((e+3)/4)*16;case 37809:return Math.floor((r+4)/5)*Math.floor((e+3)/4)*16;case 37810:return Math.floor((r+4)/5)*Math.floor((e+4)/5)*16;case 37811:return Math.floor((r+5)/6)*Math.floor((e+4)/5)*16;case 37812:return Math.floor((r+5)/6)*Math.floor((e+5)/6)*16;case 37813:return Math.floor((r+7)/8)*Math.floor((e+4)/5)*16;case 37814:return Math.floor((r+7)/8)*Math.floor((e+5)/6)*16;case 37815:return Math.floor((r+7)/8)*Math.floor((e+7)/8)*16;case 37816:return Math.floor((r+9)/10)*Math.floor((e+4)/5)*16;case 37817:return Math.floor((r+9)/10)*Math.floor((e+5)/6)*16;case 37818:return Math.floor((r+9)/10)*Math.floor((e+7)/8)*16;case 37819:return Math.floor((r+9)/10)*Math.floor((e+9)/10)*16;case 37820:return Math.floor((r+11)/12)*Math.floor((e+9)/10)*16;case 37821:return Math.floor((r+11)/12)*Math.floor((e+11)/12)*16;case 36492:case 36494:case 36495:return Math.ceil(r/4)*Math.ceil(e/4)*16;case 36283:case 36284:return Math.ceil(r/4)*Math.ceil(e/4)*8;case 36285:case 36286:return Math.ceil(r/4)*Math.ceil(e/4)*16}throw new Error(`Unable to determine texture byte length for ${t} format.`)}typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("register",{detail:{revision:"185"}})),typeof window<"u"&&(window.__THREE__?be("WARNING: Multiple instances of Three.js being imported."):window.__THREE__="185");function Yd(){let r=null,e=!1,t=null,i=null;function n(s,a){t(s,a),i=r.requestAnimationFrame(n)}return{start:function(){e!==!0&&t!==null&&r!==null&&(i=r.requestAnimationFrame(n),e=!0)},stop:function(){r!==null&&r.cancelAnimationFrame(i),e=!1},setAnimationLoop:function(s){t=s},setContext:function(s){r=s}}}function hm(r){let e=new WeakMap;return{get:function(t){return t.isInterleavedBufferAttribute&&(t=t.data),e.get(t)},remove:function(t){t.isInterleavedBufferAttribute&&(t=t.data);let i=e.get(t);i&&(r.deleteBuffer(i.buffer),e.delete(t))},update:function(t,i){if(t.isInterleavedBufferAttribute&&(t=t.data),t.isGLBufferAttribute){let s=e.get(t);return void((!s||s.version<t.version)&&e.set(t,{buffer:t.buffer,type:t.type,bytesPerElement:t.elementSize,version:t.version}))}let n=e.get(t);if(n===void 0)e.set(t,(function(s,a){let o=s.array,c=s.usage,l=o.byteLength,h=r.createBuffer(),d;if(r.bindBuffer(a,h),r.bufferData(a,o,c),s.onUploadCallback(),o instanceof Float32Array)d=r.FLOAT;else if(typeof Float16Array<"u"&&o instanceof Float16Array)d=r.HALF_FLOAT;else if(o instanceof Uint16Array)d=s.isFloat16BufferAttribute?r.HALF_FLOAT:r.UNSIGNED_SHORT;else if(o instanceof Int16Array)d=r.SHORT;else if(o instanceof Uint32Array)d=r.UNSIGNED_INT;else if(o instanceof Int32Array)d=r.INT;else if(o instanceof Int8Array)d=r.BYTE;else if(o instanceof Uint8Array)d=r.UNSIGNED_BYTE;else{if(!(o instanceof Uint8ClampedArray))throw new Error("THREE.WebGLAttributes: Unsupported buffer data format: "+o);d=r.UNSIGNED_BYTE}return{buffer:h,type:d,bytesPerElement:o.BYTES_PER_ELEMENT,version:s.version,size:l}})(t,i));else if(n.version<t.version){if(n.size!==t.array.byteLength)throw new Error("THREE.WebGLAttributes: The size of the buffer attribute's array buffer does not match the original size. Resizing buffer attributes is not supported.");(function(s,a,o){let c=a.array,l=a.updateRanges;if(r.bindBuffer(o,s),l.length===0)r.bufferSubData(o,0,c);else{l.sort((d,p)=>d.start-p.start);let h=0;for(let d=1;d<l.length;d++){let p=l[h],u=l[d];u.start<=p.start+p.count+1?p.count=Math.max(p.count,u.start+u.count-p.start):(++h,l[h]=u)}l.length=h+1;for(let d=0,p=l.length;d<p;d++){let u=l[d];r.bufferSubData(o,u.start*c.BYTES_PER_ELEMENT,c,u.start,u.count)}a.clearUpdateRanges()}a.onUploadCallback()})(n.buffer,t,i),n.version=t.version}}}}var Be={alphahash_fragment:`#ifdef USE_ALPHAHASH
	if ( diffuseColor.a < getAlphaHashThreshold( vPosition ) ) discard;
#endif`,alphahash_pars_fragment:`#ifdef USE_ALPHAHASH
	const float ALPHA_HASH_SCALE = 0.05;
	float hash2D( vec2 value ) {
		return fract( 1.0e4 * sin( 17.0 * value.x + 0.1 * value.y ) * ( 0.1 + abs( sin( 13.0 * value.y + value.x ) ) ) );
	}
	float hash3D( vec3 value ) {
		return hash2D( vec2( hash2D( value.xy ), value.z ) );
	}
	float getAlphaHashThreshold( vec3 position ) {
		float maxDeriv = max(
			length( dFdx( position.xyz ) ),
			length( dFdy( position.xyz ) )
		);
		float pixScale = 1.0 / ( ALPHA_HASH_SCALE * maxDeriv );
		vec2 pixScales = vec2(
			exp2( floor( log2( pixScale ) ) ),
			exp2( ceil( log2( pixScale ) ) )
		);
		vec2 alpha = vec2(
			hash3D( floor( pixScales.x * position.xyz ) ),
			hash3D( floor( pixScales.y * position.xyz ) )
		);
		float lerpFactor = fract( log2( pixScale ) );
		float x = ( 1.0 - lerpFactor ) * alpha.x + lerpFactor * alpha.y;
		float a = min( lerpFactor, 1.0 - lerpFactor );
		vec3 cases = vec3(
			x * x / ( 2.0 * a * ( 1.0 - a ) ),
			( x - 0.5 * a ) / ( 1.0 - a ),
			1.0 - ( ( 1.0 - x ) * ( 1.0 - x ) / ( 2.0 * a * ( 1.0 - a ) ) )
		);
		float threshold = ( x < ( 1.0 - a ) )
			? ( ( x < a ) ? cases.x : cases.y )
			: cases.z;
		return clamp( threshold , 1.0e-6, 1.0 );
	}
#endif`,alphamap_fragment:`#ifdef USE_ALPHAMAP
	diffuseColor.a *= texture2D( alphaMap, vAlphaMapUv ).g;
#endif`,alphamap_pars_fragment:`#ifdef USE_ALPHAMAP
	uniform sampler2D alphaMap;
#endif`,alphatest_fragment:`#ifdef USE_ALPHATEST
	#ifdef ALPHA_TO_COVERAGE
	diffuseColor.a = smoothstep( alphaTest, alphaTest + fwidth( diffuseColor.a ), diffuseColor.a );
	if ( diffuseColor.a == 0.0 ) discard;
	#else
	if ( diffuseColor.a < alphaTest ) discard;
	#endif
#endif`,alphatest_pars_fragment:`#ifdef USE_ALPHATEST
	uniform float alphaTest;
#endif`,aomap_fragment:`#ifdef USE_AOMAP
	float ambientOcclusion = ( texture2D( aoMap, vAoMapUv ).r - 1.0 ) * aoMapIntensity + 1.0;
	reflectedLight.indirectDiffuse *= ambientOcclusion;
	#if defined( USE_CLEARCOAT ) 
		clearcoatSpecularIndirect *= ambientOcclusion;
	#endif
	#if defined( USE_SHEEN ) 
		sheenSpecularIndirect *= ambientOcclusion;
	#endif
	#if defined( USE_ENVMAP ) && defined( STANDARD )
		float dotNV = saturate( dot( geometryNormal, geometryViewDir ) );
		reflectedLight.indirectSpecular *= computeSpecularOcclusion( dotNV, ambientOcclusion, material.roughness );
	#endif
#endif`,aomap_pars_fragment:`#ifdef USE_AOMAP
	uniform sampler2D aoMap;
	uniform float aoMapIntensity;
#endif`,batching_pars_vertex:`#ifdef USE_BATCHING
	#if ! defined( GL_ANGLE_multi_draw )
	#define gl_DrawID _gl_DrawID
	uniform int _gl_DrawID;
	#endif
	uniform highp sampler2D batchingTexture;
	uniform highp usampler2D batchingIdTexture;
	mat4 getBatchingMatrix( const in float i ) {
		int size = textureSize( batchingTexture, 0 ).x;
		int j = int( i ) * 4;
		int x = j % size;
		int y = j / size;
		vec4 v1 = texelFetch( batchingTexture, ivec2( x, y ), 0 );
		vec4 v2 = texelFetch( batchingTexture, ivec2( x + 1, y ), 0 );
		vec4 v3 = texelFetch( batchingTexture, ivec2( x + 2, y ), 0 );
		vec4 v4 = texelFetch( batchingTexture, ivec2( x + 3, y ), 0 );
		return mat4( v1, v2, v3, v4 );
	}
	float getIndirectIndex( const in int i ) {
		int size = textureSize( batchingIdTexture, 0 ).x;
		int x = i % size;
		int y = i / size;
		return float( texelFetch( batchingIdTexture, ivec2( x, y ), 0 ).r );
	}
#endif
#ifdef USE_BATCHING_COLOR
	uniform sampler2D batchingColorTexture;
	vec4 getBatchingColor( const in float i ) {
		int size = textureSize( batchingColorTexture, 0 ).x;
		int j = int( i );
		int x = j % size;
		int y = j / size;
		return texelFetch( batchingColorTexture, ivec2( x, y ), 0 );
	}
#endif`,batching_vertex:`#ifdef USE_BATCHING
	mat4 batchingMatrix = getBatchingMatrix( getIndirectIndex( gl_DrawID ) );
#endif`,begin_vertex:`vec3 transformed = vec3( position );
#ifdef USE_ALPHAHASH
	vPosition = vec3( position );
#endif`,beginnormal_vertex:`vec3 objectNormal = vec3( normal );
#ifdef USE_TANGENT
	vec3 objectTangent = vec3( tangent.xyz );
#endif`,bsdfs:`float G_BlinnPhong_Implicit( ) {
	return 0.25;
}
float D_BlinnPhong( const in float shininess, const in float dotNH ) {
	return RECIPROCAL_PI * ( shininess * 0.5 + 1.0 ) * pow( dotNH, shininess );
}
vec3 BRDF_BlinnPhong( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in vec3 specularColor, const in float shininess ) {
	vec3 halfDir = normalize( lightDir + viewDir );
	float dotNH = saturate( dot( normal, halfDir ) );
	float dotVH = saturate( dot( viewDir, halfDir ) );
	vec3 F = F_Schlick( specularColor, 1.0, dotVH );
	float G = G_BlinnPhong_Implicit( );
	float D = D_BlinnPhong( shininess, dotNH );
	return F * ( G * D );
} // validated`,iridescence_fragment:`#ifdef USE_IRIDESCENCE
	const mat3 XYZ_TO_REC709 = mat3(
		 3.2404542, -0.9692660,  0.0556434,
		-1.5371385,  1.8760108, -0.2040259,
		-0.4985314,  0.0415560,  1.0572252
	);
	vec3 Fresnel0ToIor( vec3 fresnel0 ) {
		vec3 sqrtF0 = sqrt( fresnel0 );
		return ( vec3( 1.0 ) + sqrtF0 ) / ( vec3( 1.0 ) - sqrtF0 );
	}
	vec3 IorToFresnel0( vec3 transmittedIor, float incidentIor ) {
		return pow2( ( transmittedIor - vec3( incidentIor ) ) / ( transmittedIor + vec3( incidentIor ) ) );
	}
	float IorToFresnel0( float transmittedIor, float incidentIor ) {
		return pow2( ( transmittedIor - incidentIor ) / ( transmittedIor + incidentIor ));
	}
	vec3 evalSensitivity( float OPD, vec3 shift ) {
		float phase = 2.0 * PI * OPD * 1.0e-9;
		vec3 val = vec3( 5.4856e-13, 4.4201e-13, 5.2481e-13 );
		vec3 pos = vec3( 1.6810e+06, 1.7953e+06, 2.2084e+06 );
		vec3 var = vec3( 4.3278e+09, 9.3046e+09, 6.6121e+09 );
		vec3 xyz = val * sqrt( 2.0 * PI * var ) * cos( pos * phase + shift ) * exp( - pow2( phase ) * var );
		xyz.x += 9.7470e-14 * sqrt( 2.0 * PI * 4.5282e+09 ) * cos( 2.2399e+06 * phase + shift[ 0 ] ) * exp( - 4.5282e+09 * pow2( phase ) );
		xyz /= 1.0685e-7;
		vec3 rgb = XYZ_TO_REC709 * xyz;
		return rgb;
	}
	vec3 evalIridescence( float outsideIOR, float eta2, float cosTheta1, float thinFilmThickness, vec3 baseF0 ) {
		vec3 I;
		float iridescenceIOR = mix( outsideIOR, eta2, smoothstep( 0.0, 0.03, thinFilmThickness ) );
		float sinTheta2Sq = pow2( outsideIOR / iridescenceIOR ) * ( 1.0 - pow2( cosTheta1 ) );
		float cosTheta2Sq = 1.0 - sinTheta2Sq;
		if ( cosTheta2Sq < 0.0 ) {
			return vec3( 1.0 );
		}
		float cosTheta2 = sqrt( cosTheta2Sq );
		float R0 = IorToFresnel0( iridescenceIOR, outsideIOR );
		float R12 = F_Schlick( R0, 1.0, cosTheta1 );
		float T121 = 1.0 - R12;
		float phi12 = 0.0;
		if ( iridescenceIOR < outsideIOR ) phi12 = PI;
		float phi21 = PI - phi12;
		vec3 baseIOR = Fresnel0ToIor( clamp( baseF0, 0.0, 0.9999 ) );		vec3 R1 = IorToFresnel0( baseIOR, iridescenceIOR );
		vec3 R23 = F_Schlick( R1, 1.0, cosTheta2 );
		vec3 phi23 = vec3( 0.0 );
		if ( baseIOR[ 0 ] < iridescenceIOR ) phi23[ 0 ] = PI;
		if ( baseIOR[ 1 ] < iridescenceIOR ) phi23[ 1 ] = PI;
		if ( baseIOR[ 2 ] < iridescenceIOR ) phi23[ 2 ] = PI;
		float OPD = 2.0 * iridescenceIOR * thinFilmThickness * cosTheta2;
		vec3 phi = vec3( phi21 ) + phi23;
		vec3 R123 = clamp( R12 * R23, 1e-5, 0.9999 );
		vec3 r123 = sqrt( R123 );
		vec3 Rs = pow2( T121 ) * R23 / ( vec3( 1.0 ) - R123 );
		vec3 C0 = R12 + Rs;
		I = C0;
		vec3 Cm = Rs - T121;
		for ( int m = 1; m <= 2; ++ m ) {
			Cm *= r123;
			vec3 Sm = 2.0 * evalSensitivity( float( m ) * OPD, float( m ) * phi );
			I += Cm * Sm;
		}
		return max( I, vec3( 0.0 ) );
	}
#endif`,bumpmap_pars_fragment:`#ifdef USE_BUMPMAP
	uniform sampler2D bumpMap;
	uniform float bumpScale;
	vec2 dHdxy_fwd() {
		vec2 dSTdx = dFdx( vBumpMapUv );
		vec2 dSTdy = dFdy( vBumpMapUv );
		float Hll = bumpScale * texture2D( bumpMap, vBumpMapUv ).x;
		float dBx = bumpScale * texture2D( bumpMap, vBumpMapUv + dSTdx ).x - Hll;
		float dBy = bumpScale * texture2D( bumpMap, vBumpMapUv + dSTdy ).x - Hll;
		return vec2( dBx, dBy );
	}
	vec3 perturbNormalArb( vec3 surf_pos, vec3 surf_norm, vec2 dHdxy, float faceDirection ) {
		vec3 vSigmaX = normalize( dFdx( surf_pos.xyz ) );
		vec3 vSigmaY = normalize( dFdy( surf_pos.xyz ) );
		vec3 vN = surf_norm;
		vec3 R1 = cross( vSigmaY, vN );
		vec3 R2 = cross( vN, vSigmaX );
		float fDet = dot( vSigmaX, R1 ) * faceDirection;
		vec3 vGrad = sign( fDet ) * ( dHdxy.x * R1 + dHdxy.y * R2 );
		return normalize( abs( fDet ) * surf_norm - vGrad );
	}
#endif`,clipping_planes_fragment:`#if NUM_CLIPPING_PLANES > 0
	vec4 plane;
	#ifdef ALPHA_TO_COVERAGE
		float distanceToPlane, distanceGradient;
		float clipOpacity = 1.0;
		#pragma unroll_loop_start
		for ( int i = 0; i < UNION_CLIPPING_PLANES; i ++ ) {
			plane = clippingPlanes[ i ];
			distanceToPlane = - dot( vClipPosition, plane.xyz ) + plane.w;
			distanceGradient = fwidth( distanceToPlane ) / 2.0;
			clipOpacity *= smoothstep( - distanceGradient, distanceGradient, distanceToPlane );
			if ( clipOpacity == 0.0 ) discard;
		}
		#pragma unroll_loop_end
		#if UNION_CLIPPING_PLANES < NUM_CLIPPING_PLANES
			float unionClipOpacity = 1.0;
			#pragma unroll_loop_start
			for ( int i = UNION_CLIPPING_PLANES; i < NUM_CLIPPING_PLANES; i ++ ) {
				plane = clippingPlanes[ i ];
				distanceToPlane = - dot( vClipPosition, plane.xyz ) + plane.w;
				distanceGradient = fwidth( distanceToPlane ) / 2.0;
				unionClipOpacity *= 1.0 - smoothstep( - distanceGradient, distanceGradient, distanceToPlane );
			}
			#pragma unroll_loop_end
			clipOpacity *= 1.0 - unionClipOpacity;
		#endif
		diffuseColor.a *= clipOpacity;
		if ( diffuseColor.a == 0.0 ) discard;
	#else
		#pragma unroll_loop_start
		for ( int i = 0; i < UNION_CLIPPING_PLANES; i ++ ) {
			plane = clippingPlanes[ i ];
			if ( dot( vClipPosition, plane.xyz ) > plane.w ) discard;
		}
		#pragma unroll_loop_end
		#if UNION_CLIPPING_PLANES < NUM_CLIPPING_PLANES
			bool clipped = true;
			#pragma unroll_loop_start
			for ( int i = UNION_CLIPPING_PLANES; i < NUM_CLIPPING_PLANES; i ++ ) {
				plane = clippingPlanes[ i ];
				clipped = ( dot( vClipPosition, plane.xyz ) > plane.w ) && clipped;
			}
			#pragma unroll_loop_end
			if ( clipped ) discard;
		#endif
	#endif
#endif`,clipping_planes_pars_fragment:`#if NUM_CLIPPING_PLANES > 0
	varying vec3 vClipPosition;
	uniform vec4 clippingPlanes[ NUM_CLIPPING_PLANES ];
#endif`,clipping_planes_pars_vertex:`#if NUM_CLIPPING_PLANES > 0
	varying vec3 vClipPosition;
#endif`,clipping_planes_vertex:`#if NUM_CLIPPING_PLANES > 0
	vClipPosition = - mvPosition.xyz;
#endif`,color_fragment:`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA )
	diffuseColor *= vColor;
#endif`,color_pars_fragment:`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA )
	varying vec4 vColor;
#endif`,color_pars_vertex:`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA ) || defined( USE_INSTANCING_COLOR ) || defined( USE_BATCHING_COLOR )
	varying vec4 vColor;
#endif`,color_vertex:`#if defined( USE_COLOR ) || defined( USE_COLOR_ALPHA ) || defined( USE_INSTANCING_COLOR ) || defined( USE_BATCHING_COLOR )
	vColor = vec4( 1.0 );
#endif
#ifdef USE_COLOR_ALPHA
	vColor *= color;
#elif defined( USE_COLOR )
	vColor.rgb *= color;
#endif
#ifdef USE_INSTANCING_COLOR
	vColor.rgb *= instanceColor.rgb;
#endif
#ifdef USE_BATCHING_COLOR
	vColor *= getBatchingColor( getIndirectIndex( gl_DrawID ) );
#endif`,common:`#define PI 3.141592653589793
#define PI2 6.283185307179586
#define PI_HALF 1.5707963267948966
#define RECIPROCAL_PI 0.3183098861837907
#define RECIPROCAL_PI2 0.15915494309189535
#define EPSILON 1e-6
#ifndef saturate
#define saturate( a ) clamp( a, 0.0, 1.0 )
#endif
#define whiteComplement( a ) ( 1.0 - saturate( a ) )
float pow2( const in float x ) { return x*x; }
vec3 pow2( const in vec3 x ) { return x*x; }
float pow3( const in float x ) { return x*x*x; }
float pow4( const in float x ) { float x2 = x*x; return x2*x2; }
float max3( const in vec3 v ) { return max( max( v.x, v.y ), v.z ); }
float average( const in vec3 v ) { return dot( v, vec3( 0.3333333 ) ); }
highp float rand( const in vec2 uv ) {
	const highp float a = 12.9898, b = 78.233, c = 43758.5453;
	highp float dt = dot( uv.xy, vec2( a,b ) ), sn = mod( dt, PI );
	return fract( sin( sn ) * c );
}
#ifdef HIGH_PRECISION
	float precisionSafeLength( vec3 v ) { return length( v ); }
#else
	float precisionSafeLength( vec3 v ) {
		float maxComponent = max3( abs( v ) );
		return length( v / maxComponent ) * maxComponent;
	}
#endif
struct IncidentLight {
	vec3 color;
	vec3 direction;
	bool visible;
};
struct ReflectedLight {
	vec3 directDiffuse;
	vec3 directSpecular;
	vec3 indirectDiffuse;
	vec3 indirectSpecular;
};
#ifdef USE_ALPHAHASH
	varying vec3 vPosition;
#endif
vec3 transformDirection( in vec3 dir, in mat4 matrix ) {
	return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );
}
#define inverseTransformDirection transformDirectionByInverseViewMatrix
vec3 transformNormalByInverseViewMatrix( in vec3 normal, in mat4 viewMatrix ) {
	return normalize( ( vec4( normal, 0.0 ) * viewMatrix ).xyz );
}
vec3 transformDirectionByInverseViewMatrix( in vec3 dir, in mat4 viewMatrix ) {
	return normalize( ( vec4( dir, 0.0 ) * viewMatrix ).xyz );
}
bool isPerspectiveMatrix( mat4 m ) {
	return m[ 2 ][ 3 ] == - 1.0;
}
vec2 equirectUv( in vec3 dir ) {
	float u = atan( dir.z, dir.x ) * RECIPROCAL_PI2 + 0.5;
	float v = asin( clamp( dir.y, - 1.0, 1.0 ) ) * RECIPROCAL_PI + 0.5;
	return vec2( u, v );
}
vec3 BRDF_Lambert( const in vec3 diffuseColor ) {
	return RECIPROCAL_PI * diffuseColor;
}
vec3 F_Schlick( const in vec3 f0, const in float f90, const in float dotVH ) {
	float fresnel = exp2( ( - 5.55473 * dotVH - 6.98316 ) * dotVH );
	return f0 * ( 1.0 - fresnel ) + ( f90 * fresnel );
}
float F_Schlick( const in float f0, const in float f90, const in float dotVH ) {
	float fresnel = exp2( ( - 5.55473 * dotVH - 6.98316 ) * dotVH );
	return f0 * ( 1.0 - fresnel ) + ( f90 * fresnel );
} // validated`,cube_uv_reflection_fragment:`#ifdef ENVMAP_TYPE_CUBE_UV
	#define cubeUV_minMipLevel 4.0
	#define cubeUV_minTileSize 16.0
	float getFace( vec3 direction ) {
		vec3 absDirection = abs( direction );
		float face = - 1.0;
		if ( absDirection.x > absDirection.z ) {
			if ( absDirection.x > absDirection.y )
				face = direction.x > 0.0 ? 0.0 : 3.0;
			else
				face = direction.y > 0.0 ? 1.0 : 4.0;
		} else {
			if ( absDirection.z > absDirection.y )
				face = direction.z > 0.0 ? 2.0 : 5.0;
			else
				face = direction.y > 0.0 ? 1.0 : 4.0;
		}
		return face;
	}
	vec2 getUV( vec3 direction, float face ) {
		vec2 uv;
		if ( face == 0.0 ) {
			uv = vec2( direction.z, direction.y ) / abs( direction.x );
		} else if ( face == 1.0 ) {
			uv = vec2( - direction.x, - direction.z ) / abs( direction.y );
		} else if ( face == 2.0 ) {
			uv = vec2( - direction.x, direction.y ) / abs( direction.z );
		} else if ( face == 3.0 ) {
			uv = vec2( - direction.z, direction.y ) / abs( direction.x );
		} else if ( face == 4.0 ) {
			uv = vec2( - direction.x, direction.z ) / abs( direction.y );
		} else {
			uv = vec2( direction.x, direction.y ) / abs( direction.z );
		}
		return 0.5 * ( uv + 1.0 );
	}
	vec3 bilinearCubeUV( sampler2D envMap, vec3 direction, float mipInt ) {
		float face = getFace( direction );
		float filterInt = max( cubeUV_minMipLevel - mipInt, 0.0 );
		mipInt = max( mipInt, cubeUV_minMipLevel );
		float faceSize = exp2( mipInt );
		highp vec2 uv = getUV( direction, face ) * ( faceSize - 2.0 ) + 1.0;
		if ( face > 2.0 ) {
			uv.y += faceSize;
			face -= 3.0;
		}
		uv.x += face * faceSize;
		uv.x += filterInt * 3.0 * cubeUV_minTileSize;
		uv.y += 4.0 * ( exp2( CUBEUV_MAX_MIP ) - faceSize );
		uv.x *= CUBEUV_TEXEL_WIDTH;
		uv.y *= CUBEUV_TEXEL_HEIGHT;
		#ifdef texture2DGradEXT
			return texture2DGradEXT( envMap, uv, vec2( 0.0 ), vec2( 0.0 ) ).rgb;
		#else
			return texture2D( envMap, uv ).rgb;
		#endif
	}
	#define cubeUV_r0 1.0
	#define cubeUV_m0 - 2.0
	#define cubeUV_r1 0.8
	#define cubeUV_m1 - 1.0
	#define cubeUV_r4 0.4
	#define cubeUV_m4 2.0
	#define cubeUV_r5 0.305
	#define cubeUV_m5 3.0
	#define cubeUV_r6 0.21
	#define cubeUV_m6 4.0
	float roughnessToMip( float roughness ) {
		float mip = 0.0;
		if ( roughness >= cubeUV_r1 ) {
			mip = ( cubeUV_r0 - roughness ) * ( cubeUV_m1 - cubeUV_m0 ) / ( cubeUV_r0 - cubeUV_r1 ) + cubeUV_m0;
		} else if ( roughness >= cubeUV_r4 ) {
			mip = ( cubeUV_r1 - roughness ) * ( cubeUV_m4 - cubeUV_m1 ) / ( cubeUV_r1 - cubeUV_r4 ) + cubeUV_m1;
		} else if ( roughness >= cubeUV_r5 ) {
			mip = ( cubeUV_r4 - roughness ) * ( cubeUV_m5 - cubeUV_m4 ) / ( cubeUV_r4 - cubeUV_r5 ) + cubeUV_m4;
		} else if ( roughness >= cubeUV_r6 ) {
			mip = ( cubeUV_r5 - roughness ) * ( cubeUV_m6 - cubeUV_m5 ) / ( cubeUV_r5 - cubeUV_r6 ) + cubeUV_m5;
		} else {
			mip = - 2.0 * log2( 1.16 * roughness );		}
		return mip;
	}
	vec4 textureCubeUV( sampler2D envMap, vec3 sampleDir, float roughness ) {
		float mip = clamp( roughnessToMip( roughness ), cubeUV_m0, CUBEUV_MAX_MIP );
		float mipF = fract( mip );
		float mipInt = floor( mip );
		vec3 color0 = bilinearCubeUV( envMap, sampleDir, mipInt );
		if ( mipF == 0.0 ) {
			return vec4( color0, 1.0 );
		} else {
			vec3 color1 = bilinearCubeUV( envMap, sampleDir, mipInt + 1.0 );
			return vec4( mix( color0, color1, mipF ), 1.0 );
		}
	}
#endif`,defaultnormal_vertex:`vec3 transformedNormal = objectNormal;
#ifdef USE_TANGENT
	vec3 transformedTangent = objectTangent;
#endif
#ifdef USE_BATCHING
	mat3 bm = mat3( batchingMatrix );
	transformedNormal /= vec3( dot( bm[ 0 ], bm[ 0 ] ), dot( bm[ 1 ], bm[ 1 ] ), dot( bm[ 2 ], bm[ 2 ] ) );
	transformedNormal = bm * transformedNormal;
	#ifdef USE_TANGENT
		transformedTangent = bm * transformedTangent;
	#endif
#endif
#ifdef USE_INSTANCING
	mat3 im = mat3( instanceMatrix );
	transformedNormal /= vec3( dot( im[ 0 ], im[ 0 ] ), dot( im[ 1 ], im[ 1 ] ), dot( im[ 2 ], im[ 2 ] ) );
	transformedNormal = im * transformedNormal;
	#ifdef USE_TANGENT
		transformedTangent = im * transformedTangent;
	#endif
#endif
transformedNormal = normalMatrix * transformedNormal;
#ifdef FLIP_SIDED
	transformedNormal = - transformedNormal;
#endif
#ifdef USE_TANGENT
	transformedTangent = ( modelViewMatrix * vec4( transformedTangent, 0.0 ) ).xyz;
#endif`,displacementmap_pars_vertex:`#ifdef USE_DISPLACEMENTMAP
	uniform sampler2D displacementMap;
	uniform float displacementScale;
	uniform float displacementBias;
#endif`,displacementmap_vertex:`#ifdef USE_DISPLACEMENTMAP
	transformed += normalize( objectNormal ) * ( texture2D( displacementMap, vDisplacementMapUv ).x * displacementScale + displacementBias );
#endif`,emissivemap_fragment:`#ifdef USE_EMISSIVEMAP
	vec4 emissiveColor = texture2D( emissiveMap, vEmissiveMapUv );
	#ifdef DECODE_VIDEO_TEXTURE_EMISSIVE
		emissiveColor = sRGBTransferEOTF( emissiveColor );
	#endif
	totalEmissiveRadiance *= emissiveColor.rgb;
#endif`,emissivemap_pars_fragment:`#ifdef USE_EMISSIVEMAP
	uniform sampler2D emissiveMap;
#endif`,colorspace_fragment:"gl_FragColor = linearToOutputTexel( gl_FragColor );",colorspace_pars_fragment:`vec4 LinearTransferOETF( in vec4 value ) {
	return value;
}
vec4 sRGBTransferEOTF( in vec4 value ) {
	return vec4( mix( pow( value.rgb * 0.9478672986 + vec3( 0.0521327014 ), vec3( 2.4 ) ), value.rgb * 0.0773993808, vec3( lessThanEqual( value.rgb, vec3( 0.04045 ) ) ) ), value.a );
}
vec4 sRGBTransferOETF( in vec4 value ) {
	return vec4( mix( pow( value.rgb, vec3( 0.41666 ) ) * 1.055 - vec3( 0.055 ), value.rgb * 12.92, vec3( lessThanEqual( value.rgb, vec3( 0.0031308 ) ) ) ), value.a );
}`,envmap_fragment:`#ifdef USE_ENVMAP
	#ifdef ENV_WORLDPOS
		vec3 cameraToFrag;
		if ( isOrthographic ) {
			cameraToFrag = normalize( vec3( - viewMatrix[ 0 ][ 2 ], - viewMatrix[ 1 ][ 2 ], - viewMatrix[ 2 ][ 2 ] ) );
		} else {
			cameraToFrag = normalize( vWorldPosition - cameraPosition );
		}
		vec3 worldNormal = transformNormalByInverseViewMatrix( normal, viewMatrix );
		#ifdef ENVMAP_MODE_REFLECTION
			vec3 reflectVec = reflect( cameraToFrag, worldNormal );
		#else
			vec3 reflectVec = refract( cameraToFrag, worldNormal, refractionRatio );
		#endif
	#else
		vec3 reflectVec = vReflect;
	#endif
	#ifdef ENVMAP_TYPE_CUBE
		vec4 envColor = textureCube( envMap, envMapRotation * reflectVec );
		#ifdef ENVMAP_BLENDING_MULTIPLY
			outgoingLight = mix( outgoingLight, outgoingLight * envColor.xyz, specularStrength * reflectivity );
		#elif defined( ENVMAP_BLENDING_MIX )
			outgoingLight = mix( outgoingLight, envColor.xyz, specularStrength * reflectivity );
		#elif defined( ENVMAP_BLENDING_ADD )
			outgoingLight += envColor.xyz * specularStrength * reflectivity;
		#endif
	#endif
#endif`,envmap_common_pars_fragment:`#ifdef USE_ENVMAP
	uniform float envMapIntensity;
	uniform mat3 envMapRotation;
	#ifdef ENVMAP_TYPE_CUBE
		uniform samplerCube envMap;
	#else
		uniform sampler2D envMap;
	#endif
#endif`,envmap_pars_fragment:`#ifdef USE_ENVMAP
	uniform float reflectivity;
	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) || defined( LAMBERT )
		#define ENV_WORLDPOS
	#endif
	#ifdef ENV_WORLDPOS
		varying vec3 vWorldPosition;
		uniform float refractionRatio;
	#else
		varying vec3 vReflect;
	#endif
#endif`,envmap_pars_vertex:`#ifdef USE_ENVMAP
	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) || defined( LAMBERT )
		#define ENV_WORLDPOS
	#endif
	#ifdef ENV_WORLDPOS
		
		varying vec3 vWorldPosition;
	#else
		varying vec3 vReflect;
		uniform float refractionRatio;
	#endif
#endif`,envmap_physical_pars_fragment:`#ifdef USE_ENVMAP
	vec3 getIBLIrradiance( const in vec3 normal ) {
		#ifdef ENVMAP_TYPE_CUBE_UV
			vec3 worldNormal = transformNormalByInverseViewMatrix( normal, viewMatrix );
			vec4 envMapColor = textureCubeUV( envMap, envMapRotation * worldNormal, 1.0 );
			return PI * envMapColor.rgb * envMapIntensity;
		#else
			return vec3( 0.0 );
		#endif
	}
	vec3 getIBLRadiance( const in vec3 viewDir, const in vec3 normal, const in float roughness ) {
		#ifdef ENVMAP_TYPE_CUBE_UV
			vec3 reflectVec = reflect( - viewDir, normal );
			reflectVec = normalize( mix( reflectVec, normal, pow4( roughness ) ) );
			reflectVec = transformDirectionByInverseViewMatrix( reflectVec, viewMatrix );
			vec4 envMapColor = textureCubeUV( envMap, envMapRotation * reflectVec, roughness );
			return envMapColor.rgb * envMapIntensity;
		#else
			return vec3( 0.0 );
		#endif
	}
	#ifdef USE_ANISOTROPY
		vec3 getIBLAnisotropyRadiance( const in vec3 viewDir, const in vec3 normal, const in float roughness, const in vec3 bitangent, const in float anisotropy ) {
			#ifdef ENVMAP_TYPE_CUBE_UV
				vec3 bentNormal = cross( bitangent, viewDir );
				bentNormal = normalize( cross( bentNormal, bitangent ) );
				bentNormal = normalize( mix( bentNormal, normal, pow2( pow2( 1.0 - anisotropy * ( 1.0 - roughness ) ) ) ) );
				return getIBLRadiance( viewDir, bentNormal, roughness );
			#else
				return vec3( 0.0 );
			#endif
		}
	#endif
#endif`,envmap_vertex:`#ifdef USE_ENVMAP
	#ifdef ENV_WORLDPOS
		vWorldPosition = worldPosition.xyz;
	#else
		vec3 cameraToVertex;
		if ( isOrthographic ) {
			cameraToVertex = normalize( vec3( - viewMatrix[ 0 ][ 2 ], - viewMatrix[ 1 ][ 2 ], - viewMatrix[ 2 ][ 2 ] ) );
		} else {
			cameraToVertex = normalize( worldPosition.xyz - cameraPosition );
		}
		vec3 worldNormal = transformNormalByInverseViewMatrix( transformedNormal, viewMatrix );
		#ifdef ENVMAP_MODE_REFLECTION
			vReflect = reflect( cameraToVertex, worldNormal );
		#else
			vReflect = refract( cameraToVertex, worldNormal, refractionRatio );
		#endif
	#endif
#endif`,fog_vertex:`#ifdef USE_FOG
	vFogDepth = - mvPosition.z;
#endif`,fog_pars_vertex:`#ifdef USE_FOG
	varying float vFogDepth;
#endif`,fog_fragment:`#ifdef USE_FOG
	#ifdef FOG_EXP2
		float fogFactor = 1.0 - exp( - fogDensity * fogDensity * vFogDepth * vFogDepth );
	#else
		float fogFactor = smoothstep( fogNear, fogFar, vFogDepth );
	#endif
	gl_FragColor.rgb = mix( gl_FragColor.rgb, fogColor, fogFactor );
#endif`,fog_pars_fragment:`#ifdef USE_FOG
	uniform vec3 fogColor;
	varying float vFogDepth;
	#ifdef FOG_EXP2
		uniform float fogDensity;
	#else
		uniform float fogNear;
		uniform float fogFar;
	#endif
#endif`,gradientmap_pars_fragment:`#ifdef USE_GRADIENTMAP
	uniform sampler2D gradientMap;
#endif
vec3 getGradientIrradiance( vec3 normal, vec3 lightDirection ) {
	float dotNL = dot( normal, lightDirection );
	vec2 coord = vec2( dotNL * 0.5 + 0.5, 0.0 );
	#ifdef USE_GRADIENTMAP
		return vec3( texture2D( gradientMap, coord ).r );
	#else
		vec2 fw = fwidth( coord ) * 0.5;
		return mix( vec3( 0.7 ), vec3( 1.0 ), smoothstep( 0.7 - fw.x, 0.7 + fw.x, coord.x ) );
	#endif
}`,lightmap_pars_fragment:`#ifdef USE_LIGHTMAP
	uniform sampler2D lightMap;
	uniform float lightMapIntensity;
#endif`,lights_lambert_fragment:`LambertMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.specularStrength = specularStrength;`,lights_lambert_pars_fragment:`varying vec3 vViewPosition;
struct LambertMaterial {
	vec3 diffuseColor;
	float specularStrength;
};
void RE_Direct_Lambert( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in LambertMaterial material, inout ReflectedLight reflectedLight ) {
	float dotNL = saturate( dot( geometryNormal, directLight.direction ) );
	vec3 irradiance = dotNL * directLight.color;
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
void RE_IndirectDiffuse_Lambert( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in LambertMaterial material, inout ReflectedLight reflectedLight ) {
	reflectedLight.indirectDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
#define RE_Direct				RE_Direct_Lambert
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Lambert`,lights_pars_begin:`uniform bool receiveShadow;
uniform vec3 ambientLightColor;
#if defined( USE_LIGHT_PROBES )
	uniform vec3 lightProbe[ 9 ];
#endif
vec3 shGetIrradianceAt( in vec3 normal, in vec3 shCoefficients[ 9 ] ) {
	float x = normal.x, y = normal.y, z = normal.z;
	vec3 result = shCoefficients[ 0 ] * 0.886227;
	result += shCoefficients[ 1 ] * 2.0 * 0.511664 * y;
	result += shCoefficients[ 2 ] * 2.0 * 0.511664 * z;
	result += shCoefficients[ 3 ] * 2.0 * 0.511664 * x;
	result += shCoefficients[ 4 ] * 2.0 * 0.429043 * x * y;
	result += shCoefficients[ 5 ] * 2.0 * 0.429043 * y * z;
	result += shCoefficients[ 6 ] * ( 0.743125 * z * z - 0.247708 );
	result += shCoefficients[ 7 ] * 2.0 * 0.429043 * x * z;
	result += shCoefficients[ 8 ] * 0.429043 * ( x * x - y * y );
	return result;
}
vec3 getLightProbeIrradiance( const in vec3 lightProbe[ 9 ], const in vec3 normal ) {
	vec3 worldNormal = transformNormalByInverseViewMatrix( normal, viewMatrix );
	vec3 irradiance = shGetIrradianceAt( worldNormal, lightProbe );
	return irradiance;
}
vec3 getAmbientLightIrradiance( const in vec3 ambientLightColor ) {
	vec3 irradiance = ambientLightColor;
	return irradiance;
}
float getDistanceAttenuation( const in float lightDistance, const in float cutoffDistance, const in float decayExponent ) {
	float distanceFalloff = 1.0 / max( pow( lightDistance, decayExponent ), 0.01 );
	if ( cutoffDistance > 0.0 ) {
		distanceFalloff *= pow2( saturate( 1.0 - pow4( lightDistance / cutoffDistance ) ) );
	}
	return distanceFalloff;
}
float getSpotAttenuation( const in float coneCosine, const in float penumbraCosine, const in float angleCosine ) {
	return smoothstep( coneCosine, penumbraCosine, angleCosine );
}
#if NUM_DIR_LIGHTS > 0
	struct DirectionalLight {
		vec3 direction;
		vec3 color;
	};
	uniform DirectionalLight directionalLights[ NUM_DIR_LIGHTS ];
	void getDirectionalLightInfo( const in DirectionalLight directionalLight, out IncidentLight light ) {
		light.color = directionalLight.color;
		light.direction = directionalLight.direction;
		light.visible = true;
	}
#endif
#if NUM_POINT_LIGHTS > 0
	struct PointLight {
		vec3 position;
		vec3 color;
		float distance;
		float decay;
	};
	uniform PointLight pointLights[ NUM_POINT_LIGHTS ];
	void getPointLightInfo( const in PointLight pointLight, const in vec3 geometryPosition, out IncidentLight light ) {
		vec3 lVector = pointLight.position - geometryPosition;
		light.direction = normalize( lVector );
		float lightDistance = length( lVector );
		light.color = pointLight.color;
		light.color *= getDistanceAttenuation( lightDistance, pointLight.distance, pointLight.decay );
		light.visible = ( light.color != vec3( 0.0 ) );
	}
#endif
#if NUM_SPOT_LIGHTS > 0
	struct SpotLight {
		vec3 position;
		vec3 direction;
		vec3 color;
		float distance;
		float decay;
		float coneCos;
		float penumbraCos;
	};
	uniform SpotLight spotLights[ NUM_SPOT_LIGHTS ];
	void getSpotLightInfo( const in SpotLight spotLight, const in vec3 geometryPosition, out IncidentLight light ) {
		vec3 lVector = spotLight.position - geometryPosition;
		light.direction = normalize( lVector );
		float angleCos = dot( light.direction, spotLight.direction );
		float spotAttenuation = getSpotAttenuation( spotLight.coneCos, spotLight.penumbraCos, angleCos );
		if ( spotAttenuation > 0.0 ) {
			float lightDistance = length( lVector );
			light.color = spotLight.color * spotAttenuation;
			light.color *= getDistanceAttenuation( lightDistance, spotLight.distance, spotLight.decay );
			light.visible = ( light.color != vec3( 0.0 ) );
		} else {
			light.color = vec3( 0.0 );
			light.visible = false;
		}
	}
#endif
#if NUM_RECT_AREA_LIGHTS > 0
	struct RectAreaLight {
		vec3 color;
		vec3 position;
		vec3 halfWidth;
		vec3 halfHeight;
	};
	uniform sampler2D ltc_1;	uniform sampler2D ltc_2;
	uniform RectAreaLight rectAreaLights[ NUM_RECT_AREA_LIGHTS ];
#endif
#if NUM_HEMI_LIGHTS > 0
	struct HemisphereLight {
		vec3 direction;
		vec3 skyColor;
		vec3 groundColor;
	};
	uniform HemisphereLight hemisphereLights[ NUM_HEMI_LIGHTS ];
	vec3 getHemisphereLightIrradiance( const in HemisphereLight hemiLight, const in vec3 normal ) {
		float dotNL = dot( normal, hemiLight.direction );
		float hemiDiffuseWeight = 0.5 * dotNL + 0.5;
		vec3 irradiance = mix( hemiLight.groundColor, hemiLight.skyColor, hemiDiffuseWeight );
		return irradiance;
	}
#endif
#include <lightprobes_pars_fragment>`,lights_toon_fragment:`ToonMaterial material;
material.diffuseColor = diffuseColor.rgb;`,lights_toon_pars_fragment:`varying vec3 vViewPosition;
struct ToonMaterial {
	vec3 diffuseColor;
};
void RE_Direct_Toon( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in ToonMaterial material, inout ReflectedLight reflectedLight ) {
	vec3 irradiance = getGradientIrradiance( geometryNormal, directLight.direction ) * directLight.color;
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
void RE_IndirectDiffuse_Toon( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in ToonMaterial material, inout ReflectedLight reflectedLight ) {
	reflectedLight.indirectDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
#define RE_Direct				RE_Direct_Toon
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Toon`,lights_phong_fragment:`BlinnPhongMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.specularColor = specular;
material.specularShininess = shininess;
material.specularStrength = specularStrength;`,lights_phong_pars_fragment:`varying vec3 vViewPosition;
struct BlinnPhongMaterial {
	vec3 diffuseColor;
	vec3 specularColor;
	float specularShininess;
	float specularStrength;
};
void RE_Direct_BlinnPhong( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {
	float dotNL = saturate( dot( geometryNormal, directLight.direction ) );
	vec3 irradiance = dotNL * directLight.color;
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
	reflectedLight.directSpecular += irradiance * BRDF_BlinnPhong( directLight.direction, geometryViewDir, geometryNormal, material.specularColor, material.specularShininess ) * material.specularStrength;
}
void RE_IndirectDiffuse_BlinnPhong( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {
	reflectedLight.indirectDiffuse += irradiance * BRDF_Lambert( material.diffuseColor );
}
#define RE_Direct				RE_Direct_BlinnPhong
#define RE_IndirectDiffuse		RE_IndirectDiffuse_BlinnPhong`,lights_physical_fragment:`PhysicalMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.diffuseContribution = diffuseColor.rgb * ( 1.0 - metalnessFactor );
material.metalness = metalnessFactor;
vec3 dxy = max( abs( dFdx( nonPerturbedNormal ) ), abs( dFdy( nonPerturbedNormal ) ) );
float geometryRoughness = max( max( dxy.x, dxy.y ), dxy.z );
material.roughness = max( roughnessFactor, 0.0525 );material.roughness += geometryRoughness;
material.roughness = min( material.roughness, 1.0 );
#ifdef IOR
	material.ior = ior;
	#ifdef USE_SPECULAR
		float specularIntensityFactor = specularIntensity;
		vec3 specularColorFactor = specularColor;
		#ifdef USE_SPECULAR_COLORMAP
			specularColorFactor *= texture2D( specularColorMap, vSpecularColorMapUv ).rgb;
		#endif
		#ifdef USE_SPECULAR_INTENSITYMAP
			specularIntensityFactor *= texture2D( specularIntensityMap, vSpecularIntensityMapUv ).a;
		#endif
		material.specularF90 = mix( specularIntensityFactor, 1.0, metalnessFactor );
	#else
		float specularIntensityFactor = 1.0;
		vec3 specularColorFactor = vec3( 1.0 );
		material.specularF90 = 1.0;
	#endif
	material.specularColor = min( pow2( ( material.ior - 1.0 ) / ( material.ior + 1.0 ) ) * specularColorFactor, vec3( 1.0 ) ) * specularIntensityFactor;
	material.specularColorBlended = mix( material.specularColor, diffuseColor.rgb, metalnessFactor );
#else
	material.specularColor = vec3( 0.04 );
	material.specularColorBlended = mix( material.specularColor, diffuseColor.rgb, metalnessFactor );
	material.specularF90 = 1.0;
#endif
#ifdef USE_CLEARCOAT
	material.clearcoat = clearcoat;
	material.clearcoatRoughness = clearcoatRoughness;
	material.clearcoatF0 = vec3( 0.04 );
	material.clearcoatF90 = 1.0;
	#ifdef USE_CLEARCOATMAP
		material.clearcoat *= texture2D( clearcoatMap, vClearcoatMapUv ).x;
	#endif
	#ifdef USE_CLEARCOAT_ROUGHNESSMAP
		material.clearcoatRoughness *= texture2D( clearcoatRoughnessMap, vClearcoatRoughnessMapUv ).y;
	#endif
	material.clearcoat = saturate( material.clearcoat );	material.clearcoatRoughness = max( material.clearcoatRoughness, 0.0525 );
	material.clearcoatRoughness += geometryRoughness;
	material.clearcoatRoughness = min( material.clearcoatRoughness, 1.0 );
#endif
#ifdef USE_DISPERSION
	material.dispersion = dispersion;
#endif
#ifdef USE_IRIDESCENCE
	material.iridescence = iridescence;
	material.iridescenceIOR = iridescenceIOR;
	#ifdef USE_IRIDESCENCEMAP
		material.iridescence *= texture2D( iridescenceMap, vIridescenceMapUv ).r;
	#endif
	#ifdef USE_IRIDESCENCE_THICKNESSMAP
		material.iridescenceThickness = (iridescenceThicknessMaximum - iridescenceThicknessMinimum) * texture2D( iridescenceThicknessMap, vIridescenceThicknessMapUv ).g + iridescenceThicknessMinimum;
	#else
		material.iridescenceThickness = iridescenceThicknessMaximum;
	#endif
#endif
#ifdef USE_SHEEN
	material.sheenColor = sheenColor;
	#ifdef USE_SHEEN_COLORMAP
		material.sheenColor *= texture2D( sheenColorMap, vSheenColorMapUv ).rgb;
	#endif
	material.sheenRoughness = clamp( sheenRoughness, 0.0001, 1.0 );
	#ifdef USE_SHEEN_ROUGHNESSMAP
		material.sheenRoughness *= texture2D( sheenRoughnessMap, vSheenRoughnessMapUv ).a;
	#endif
#endif
#ifdef USE_ANISOTROPY
	#ifdef USE_ANISOTROPYMAP
		mat2 anisotropyMat = mat2( anisotropyVector.x, anisotropyVector.y, - anisotropyVector.y, anisotropyVector.x );
		vec3 anisotropyPolar = texture2D( anisotropyMap, vAnisotropyMapUv ).rgb;
		vec2 anisotropyV = anisotropyMat * normalize( 2.0 * anisotropyPolar.rg - vec2( 1.0 ) ) * anisotropyPolar.b;
	#else
		vec2 anisotropyV = anisotropyVector;
	#endif
	material.anisotropy = length( anisotropyV );
	if( material.anisotropy == 0.0 ) {
		anisotropyV = vec2( 1.0, 0.0 );
	} else {
		anisotropyV /= material.anisotropy;
		material.anisotropy = saturate( material.anisotropy );
	}
	material.alphaT = mix( pow2( material.roughness ), 1.0, pow2( material.anisotropy ) );
	material.anisotropyT = tbn[ 0 ] * anisotropyV.x + tbn[ 1 ] * anisotropyV.y;
	material.anisotropyB = tbn[ 1 ] * anisotropyV.x - tbn[ 0 ] * anisotropyV.y;
#endif`,lights_physical_pars_fragment:`uniform sampler2D dfgLUT;
struct PhysicalMaterial {
	vec3 diffuseColor;
	vec3 diffuseContribution;
	vec3 specularColor;
	vec3 specularColorBlended;
	float roughness;
	float metalness;
	float specularF90;
	float dispersion;
	#ifdef USE_CLEARCOAT
		float clearcoat;
		float clearcoatRoughness;
		vec3 clearcoatF0;
		float clearcoatF90;
	#endif
	#ifdef USE_IRIDESCENCE
		float iridescence;
		float iridescenceIOR;
		float iridescenceThickness;
		vec3 iridescenceFresnel;
		vec3 iridescenceF0;
		vec3 iridescenceFresnelDielectric;
		vec3 iridescenceFresnelMetallic;
	#endif
	#ifdef USE_SHEEN
		vec3 sheenColor;
		float sheenRoughness;
	#endif
	#ifdef IOR
		float ior;
	#endif
	#ifdef USE_TRANSMISSION
		float transmission;
		float transmissionAlpha;
		float thickness;
		float attenuationDistance;
		vec3 attenuationColor;
	#endif
	#ifdef USE_ANISOTROPY
		float anisotropy;
		float alphaT;
		vec3 anisotropyT;
		vec3 anisotropyB;
	#endif
};
vec3 clearcoatSpecularDirect = vec3( 0.0 );
vec3 clearcoatSpecularIndirect = vec3( 0.0 );
vec3 sheenSpecularDirect = vec3( 0.0 );
vec3 sheenSpecularIndirect = vec3(0.0 );
vec3 Schlick_to_F0( const in vec3 f, const in float f90, const in float dotVH ) {
    float x = clamp( 1.0 - dotVH, 0.0, 1.0 );
    float x2 = x * x;
    float x5 = clamp( x * x2 * x2, 0.0, 0.9999 );
    return ( f - vec3( f90 ) * x5 ) / ( 1.0 - x5 );
}
float V_GGX_SmithCorrelated( const in float alpha, const in float dotNL, const in float dotNV ) {
	float a2 = pow2( alpha );
	float gv = dotNL * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNV ) );
	float gl = dotNV * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNL ) );
	return 0.5 / max( gv + gl, EPSILON );
}
float D_GGX( const in float alpha, const in float dotNH ) {
	float a2 = pow2( alpha );
	float denom = pow2( dotNH ) * ( a2 - 1.0 ) + 1.0;
	return RECIPROCAL_PI * a2 / pow2( denom );
}
#ifdef USE_ANISOTROPY
	float V_GGX_SmithCorrelated_Anisotropic( const in float alphaT, const in float alphaB, const in float dotTV, const in float dotBV, const in float dotTL, const in float dotBL, const in float dotNV, const in float dotNL ) {
		float gv = dotNL * length( vec3( alphaT * dotTV, alphaB * dotBV, dotNV ) );
		float gl = dotNV * length( vec3( alphaT * dotTL, alphaB * dotBL, dotNL ) );
		return 0.5 / max( gv + gl, EPSILON );
	}
	float D_GGX_Anisotropic( const in float alphaT, const in float alphaB, const in float dotNH, const in float dotTH, const in float dotBH ) {
		float a2 = alphaT * alphaB;
		highp vec3 v = vec3( alphaB * dotTH, alphaT * dotBH, a2 * dotNH );
		highp float v2 = dot( v, v );
		float w2 = a2 / v2;
		return RECIPROCAL_PI * a2 * pow2 ( w2 );
	}
#endif
#ifdef USE_CLEARCOAT
	vec3 BRDF_GGX_Clearcoat( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in PhysicalMaterial material) {
		vec3 f0 = material.clearcoatF0;
		float f90 = material.clearcoatF90;
		float roughness = material.clearcoatRoughness;
		float alpha = pow2( roughness );
		vec3 halfDir = normalize( lightDir + viewDir );
		float dotNL = saturate( dot( normal, lightDir ) );
		float dotNV = saturate( dot( normal, viewDir ) );
		float dotNH = saturate( dot( normal, halfDir ) );
		float dotVH = saturate( dot( viewDir, halfDir ) );
		vec3 F = F_Schlick( f0, f90, dotVH );
		float V = V_GGX_SmithCorrelated( alpha, dotNL, dotNV );
		float D = D_GGX( alpha, dotNH );
		return F * ( V * D );
	}
#endif
vec3 BRDF_GGX( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in PhysicalMaterial material ) {
	vec3 f0 = material.specularColorBlended;
	float f90 = material.specularF90;
	float roughness = material.roughness;
	float alpha = pow2( roughness );
	vec3 halfDir = normalize( lightDir + viewDir );
	float dotNL = saturate( dot( normal, lightDir ) );
	float dotNV = saturate( dot( normal, viewDir ) );
	float dotNH = saturate( dot( normal, halfDir ) );
	float dotVH = saturate( dot( viewDir, halfDir ) );
	vec3 F = F_Schlick( f0, f90, dotVH );
	#ifdef USE_IRIDESCENCE
		F = mix( F, material.iridescenceFresnel, material.iridescence );
	#endif
	#ifdef USE_ANISOTROPY
		float dotTL = dot( material.anisotropyT, lightDir );
		float dotTV = dot( material.anisotropyT, viewDir );
		float dotTH = dot( material.anisotropyT, halfDir );
		float dotBL = dot( material.anisotropyB, lightDir );
		float dotBV = dot( material.anisotropyB, viewDir );
		float dotBH = dot( material.anisotropyB, halfDir );
		float V = V_GGX_SmithCorrelated_Anisotropic( material.alphaT, alpha, dotTV, dotBV, dotTL, dotBL, dotNV, dotNL );
		float D = D_GGX_Anisotropic( material.alphaT, alpha, dotNH, dotTH, dotBH );
	#else
		float V = V_GGX_SmithCorrelated( alpha, dotNL, dotNV );
		float D = D_GGX( alpha, dotNH );
	#endif
	return F * ( V * D );
}
vec2 LTC_Uv( const in vec3 N, const in vec3 V, const in float roughness ) {
	const float LUT_SIZE = 64.0;
	const float LUT_SCALE = ( LUT_SIZE - 1.0 ) / LUT_SIZE;
	const float LUT_BIAS = 0.5 / LUT_SIZE;
	float dotNV = saturate( dot( N, V ) );
	vec2 uv = vec2( roughness, sqrt( 1.0 - dotNV ) );
	uv = uv * LUT_SCALE + LUT_BIAS;
	return uv;
}
float LTC_ClippedSphereFormFactor( const in vec3 f ) {
	float l = length( f );
	return max( ( l * l + f.z ) / ( l + 1.0 ), 0.0 );
}
vec3 LTC_EdgeVectorFormFactor( const in vec3 v1, const in vec3 v2 ) {
	float x = dot( v1, v2 );
	float y = abs( x );
	float a = 0.8543985 + ( 0.4965155 + 0.0145206 * y ) * y;
	float b = 3.4175940 + ( 4.1616724 + y ) * y;
	float v = a / b;
	float theta_sintheta = ( x > 0.0 ) ? v : 0.5 * inversesqrt( max( 1.0 - x * x, 1e-7 ) ) - v;
	return cross( v1, v2 ) * theta_sintheta;
}
vec3 LTC_Evaluate( const in vec3 N, const in vec3 V, const in vec3 P, const in mat3 mInv, const in vec3 rectCoords[ 4 ] ) {
	vec3 v1 = rectCoords[ 1 ] - rectCoords[ 0 ];
	vec3 v2 = rectCoords[ 3 ] - rectCoords[ 0 ];
	vec3 lightNormal = cross( v1, v2 );
	if( dot( lightNormal, P - rectCoords[ 0 ] ) < 0.0 ) return vec3( 0.0 );
	vec3 T1, T2;
	T1 = normalize( V - N * dot( V, N ) );
	T2 = - cross( N, T1 );
	mat3 mat = mInv * transpose( mat3( T1, T2, N ) );
	vec3 coords[ 4 ];
	coords[ 0 ] = mat * ( rectCoords[ 0 ] - P );
	coords[ 1 ] = mat * ( rectCoords[ 1 ] - P );
	coords[ 2 ] = mat * ( rectCoords[ 2 ] - P );
	coords[ 3 ] = mat * ( rectCoords[ 3 ] - P );
	coords[ 0 ] = normalize( coords[ 0 ] );
	coords[ 1 ] = normalize( coords[ 1 ] );
	coords[ 2 ] = normalize( coords[ 2 ] );
	coords[ 3 ] = normalize( coords[ 3 ] );
	vec3 vectorFormFactor = vec3( 0.0 );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 0 ], coords[ 1 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 1 ], coords[ 2 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 2 ], coords[ 3 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 3 ], coords[ 0 ] );
	float result = LTC_ClippedSphereFormFactor( vectorFormFactor );
	return vec3( result );
}
#if defined( USE_SHEEN )
float D_Charlie( float roughness, float dotNH ) {
	float alpha = pow2( roughness );
	float invAlpha = 1.0 / alpha;
	float cos2h = dotNH * dotNH;
	float sin2h = max( 1.0 - cos2h, 0.0078125 );
	return ( 2.0 + invAlpha ) * pow( sin2h, invAlpha * 0.5 ) / ( 2.0 * PI );
}
float V_Neubelt( float dotNV, float dotNL ) {
	return saturate( 1.0 / ( 4.0 * ( dotNL + dotNV - dotNL * dotNV ) ) );
}
vec3 BRDF_Sheen( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, vec3 sheenColor, const in float sheenRoughness ) {
	vec3 halfDir = normalize( lightDir + viewDir );
	float dotNL = saturate( dot( normal, lightDir ) );
	float dotNV = saturate( dot( normal, viewDir ) );
	float dotNH = saturate( dot( normal, halfDir ) );
	float D = D_Charlie( sheenRoughness, dotNH );
	float V = V_Neubelt( dotNV, dotNL );
	return sheenColor * ( D * V );
}
#endif
float IBLSheenBRDF( const in vec3 normal, const in vec3 viewDir, const in float roughness ) {
	float dotNV = saturate( dot( normal, viewDir ) );
	float r2 = roughness * roughness;
	float rInv = 1.0 / ( roughness + 0.1 );
	float a = -1.9362 + 1.0678 * roughness + 0.4573 * r2 - 0.8469 * rInv;
	float b = -0.6014 + 0.5538 * roughness - 0.4670 * r2 - 0.1255 * rInv;
	float DG = exp( a * dotNV + b );
	return saturate( DG );
}
vec3 EnvironmentBRDF( const in vec3 normal, const in vec3 viewDir, const in vec3 specularColor, const in float specularF90, const in float roughness ) {
	float dotNV = saturate( dot( normal, viewDir ) );
	vec2 fab = texture2D( dfgLUT, vec2( roughness, dotNV ) ).rg;
	return specularColor * fab.x + specularF90 * fab.y;
}
#ifdef USE_IRIDESCENCE
void computeMultiscatteringIridescence( const in vec3 normal, const in vec3 viewDir, const in vec3 specularColor, const in float specularF90, const in float iridescence, const in vec3 iridescenceF0, const in float roughness, inout vec3 singleScatter, inout vec3 multiScatter ) {
#else
void computeMultiscattering( const in vec3 normal, const in vec3 viewDir, const in vec3 specularColor, const in float specularF90, const in float roughness, inout vec3 singleScatter, inout vec3 multiScatter ) {
#endif
	float dotNV = saturate( dot( normal, viewDir ) );
	vec2 fab = texture2D( dfgLUT, vec2( roughness, dotNV ) ).rg;
	#ifdef USE_IRIDESCENCE
		vec3 Fr = mix( specularColor, iridescenceF0, iridescence );
	#else
		vec3 Fr = specularColor;
	#endif
	vec3 FssEss = Fr * fab.x + specularF90 * fab.y;
	float Ess = fab.x + fab.y;
	float Ems = 1.0 - Ess;
	vec3 Favg = Fr + ( 1.0 - Fr ) * 0.047619;	vec3 Fms = FssEss * Favg / ( 1.0 - Ems * Favg );
	singleScatter += FssEss;
	multiScatter += Fms * Ems;
}
vec3 BRDF_GGX_Multiscatter( const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in PhysicalMaterial material ) {
	vec3 singleScatter = BRDF_GGX( lightDir, viewDir, normal, material );
	float dotNL = saturate( dot( normal, lightDir ) );
	float dotNV = saturate( dot( normal, viewDir ) );
	vec2 dfgV = texture2D( dfgLUT, vec2( material.roughness, dotNV ) ).rg;
	vec2 dfgL = texture2D( dfgLUT, vec2( material.roughness, dotNL ) ).rg;
	vec3 FssEss_V = material.specularColorBlended * dfgV.x + material.specularF90 * dfgV.y;
	vec3 FssEss_L = material.specularColorBlended * dfgL.x + material.specularF90 * dfgL.y;
	float Ess_V = dfgV.x + dfgV.y;
	float Ess_L = dfgL.x + dfgL.y;
	float Ems_V = 1.0 - Ess_V;
	float Ems_L = 1.0 - Ess_L;
	vec3 Favg = material.specularColorBlended + ( 1.0 - material.specularColorBlended ) * 0.047619;
	vec3 Fms = FssEss_V * FssEss_L * Favg / ( 1.0 - Ems_V * Ems_L * Favg + EPSILON );
	float compensationFactor = Ems_V * Ems_L;
	vec3 multiScatter = Fms * compensationFactor;
	return singleScatter + multiScatter;
}
#if NUM_RECT_AREA_LIGHTS > 0
	void RE_Direct_RectArea_Physical( const in RectAreaLight rectAreaLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {
		vec3 normal = geometryNormal;
		vec3 viewDir = geometryViewDir;
		vec3 position = geometryPosition;
		vec3 lightPos = rectAreaLight.position;
		vec3 halfWidth = rectAreaLight.halfWidth;
		vec3 halfHeight = rectAreaLight.halfHeight;
		vec3 lightColor = rectAreaLight.color;
		float roughness = material.roughness;
		vec3 rectCoords[ 4 ];
		rectCoords[ 0 ] = lightPos + halfWidth - halfHeight;		rectCoords[ 1 ] = lightPos - halfWidth - halfHeight;
		rectCoords[ 2 ] = lightPos - halfWidth + halfHeight;
		rectCoords[ 3 ] = lightPos + halfWidth + halfHeight;
		vec2 uv = LTC_Uv( normal, viewDir, roughness );
		vec4 t1 = texture2D( ltc_1, uv );
		vec4 t2 = texture2D( ltc_2, uv );
		mat3 mInv = mat3(
			vec3( t1.x, 0, t1.y ),
			vec3(    0, 1,    0 ),
			vec3( t1.z, 0, t1.w )
		);
		vec3 fresnel = ( material.specularColorBlended * t2.x + ( material.specularF90 - material.specularColorBlended ) * t2.y );
		reflectedLight.directSpecular += lightColor * fresnel * LTC_Evaluate( normal, viewDir, position, mInv, rectCoords );
		reflectedLight.directDiffuse += lightColor * material.diffuseContribution * LTC_Evaluate( normal, viewDir, position, mat3( 1.0 ), rectCoords );
		#ifdef USE_CLEARCOAT
			vec3 Ncc = geometryClearcoatNormal;
			vec2 uvClearcoat = LTC_Uv( Ncc, viewDir, material.clearcoatRoughness );
			vec4 t1Clearcoat = texture2D( ltc_1, uvClearcoat );
			vec4 t2Clearcoat = texture2D( ltc_2, uvClearcoat );
			mat3 mInvClearcoat = mat3(
				vec3( t1Clearcoat.x, 0, t1Clearcoat.y ),
				vec3(             0, 1,             0 ),
				vec3( t1Clearcoat.z, 0, t1Clearcoat.w )
			);
			vec3 fresnelClearcoat = material.clearcoatF0 * t2Clearcoat.x + ( material.clearcoatF90 - material.clearcoatF0 ) * t2Clearcoat.y;
			clearcoatSpecularDirect += lightColor * fresnelClearcoat * LTC_Evaluate( Ncc, viewDir, position, mInvClearcoat, rectCoords );
		#endif
	}
#endif
void RE_Direct_Physical( const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {
	float dotNL = saturate( dot( geometryNormal, directLight.direction ) );
	vec3 irradiance = dotNL * directLight.color;
	#ifdef USE_CLEARCOAT
		float dotNLcc = saturate( dot( geometryClearcoatNormal, directLight.direction ) );
		vec3 ccIrradiance = dotNLcc * directLight.color;
		clearcoatSpecularDirect += ccIrradiance * BRDF_GGX_Clearcoat( directLight.direction, geometryViewDir, geometryClearcoatNormal, material );
	#endif
	#ifdef USE_SHEEN
 
 		sheenSpecularDirect += irradiance * BRDF_Sheen( directLight.direction, geometryViewDir, geometryNormal, material.sheenColor, material.sheenRoughness );
 
 		float sheenAlbedoV = IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness );
 		float sheenAlbedoL = IBLSheenBRDF( geometryNormal, directLight.direction, material.sheenRoughness );
 
 		float sheenEnergyComp = 1.0 - max3( material.sheenColor ) * max( sheenAlbedoV, sheenAlbedoL );
 
 		irradiance *= sheenEnergyComp;
 
 	#endif
	reflectedLight.directSpecular += irradiance * BRDF_GGX_Multiscatter( directLight.direction, geometryViewDir, geometryNormal, material );
	reflectedLight.directDiffuse += irradiance * BRDF_Lambert( material.diffuseContribution );
}
void RE_IndirectDiffuse_Physical( const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {
	vec3 diffuse = irradiance * BRDF_Lambert( material.diffuseContribution );
	#ifdef USE_SHEEN
		float sheenAlbedo = IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness );
		float sheenEnergyComp = 1.0 - max3( material.sheenColor ) * sheenAlbedo;
		diffuse *= sheenEnergyComp;
	#endif
	reflectedLight.indirectDiffuse += diffuse;
}
void RE_IndirectSpecular_Physical( const in vec3 radiance, const in vec3 irradiance, const in vec3 clearcoatRadiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in PhysicalMaterial material, inout ReflectedLight reflectedLight) {
	#ifdef USE_CLEARCOAT
		clearcoatSpecularIndirect += clearcoatRadiance * EnvironmentBRDF( geometryClearcoatNormal, geometryViewDir, material.clearcoatF0, material.clearcoatF90, material.clearcoatRoughness );
	#endif
	#ifdef USE_SHEEN
		sheenSpecularIndirect += irradiance * material.sheenColor * IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness ) * RECIPROCAL_PI;
 	#endif
	vec3 singleScatteringDielectric = vec3( 0.0 );
	vec3 multiScatteringDielectric = vec3( 0.0 );
	vec3 singleScatteringMetallic = vec3( 0.0 );
	vec3 multiScatteringMetallic = vec3( 0.0 );
	#ifdef USE_IRIDESCENCE
		computeMultiscatteringIridescence( geometryNormal, geometryViewDir, material.specularColor, material.specularF90, material.iridescence, material.iridescenceFresnelDielectric, material.roughness, singleScatteringDielectric, multiScatteringDielectric );
		computeMultiscatteringIridescence( geometryNormal, geometryViewDir, material.diffuseColor, material.specularF90, material.iridescence, material.iridescenceFresnelMetallic, material.roughness, singleScatteringMetallic, multiScatteringMetallic );
	#else
		computeMultiscattering( geometryNormal, geometryViewDir, material.specularColor, material.specularF90, material.roughness, singleScatteringDielectric, multiScatteringDielectric );
		computeMultiscattering( geometryNormal, geometryViewDir, material.diffuseColor, material.specularF90, material.roughness, singleScatteringMetallic, multiScatteringMetallic );
	#endif
	vec3 singleScattering = mix( singleScatteringDielectric, singleScatteringMetallic, material.metalness );
	vec3 multiScattering = mix( multiScatteringDielectric, multiScatteringMetallic, material.metalness );
	vec3 totalScatteringDielectric = singleScatteringDielectric + multiScatteringDielectric;
	vec3 diffuse = material.diffuseContribution * ( 1.0 - totalScatteringDielectric );
	vec3 cosineWeightedIrradiance = irradiance * RECIPROCAL_PI;
	vec3 indirectSpecular = radiance * singleScattering;
	indirectSpecular += multiScattering * cosineWeightedIrradiance;
	vec3 indirectDiffuse = diffuse * cosineWeightedIrradiance;
	#ifdef USE_SHEEN
		float sheenAlbedo = IBLSheenBRDF( geometryNormal, geometryViewDir, material.sheenRoughness );
		float sheenEnergyComp = 1.0 - max3( material.sheenColor ) * sheenAlbedo;
		indirectSpecular *= sheenEnergyComp;
		indirectDiffuse *= sheenEnergyComp;
	#endif
	reflectedLight.indirectSpecular += indirectSpecular;
	reflectedLight.indirectDiffuse += indirectDiffuse;
}
#define RE_Direct				RE_Direct_Physical
#define RE_Direct_RectArea		RE_Direct_RectArea_Physical
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Physical
#define RE_IndirectSpecular		RE_IndirectSpecular_Physical
float computeSpecularOcclusion( const in float dotNV, const in float ambientOcclusion, const in float roughness ) {
	return saturate( pow( dotNV + ambientOcclusion, exp2( - 16.0 * roughness - 1.0 ) ) - 1.0 + ambientOcclusion );
}`,lights_fragment_begin:`
vec3 geometryPosition = - vViewPosition;
vec3 geometryNormal = normal;
vec3 geometryViewDir = ( isOrthographic ) ? vec3( 0, 0, 1 ) : normalize( vViewPosition );
vec3 geometryClearcoatNormal = vec3( 0.0 );
#ifdef USE_CLEARCOAT
	geometryClearcoatNormal = clearcoatNormal;
#endif
#ifdef USE_IRIDESCENCE
	float dotNVi = saturate( dot( normal, geometryViewDir ) );
	if ( material.iridescenceThickness == 0.0 ) {
		material.iridescence = 0.0;
	} else {
		material.iridescence = saturate( material.iridescence );
	}
	if ( material.iridescence > 0.0 ) {
		material.iridescenceFresnelDielectric = evalIridescence( 1.0, material.iridescenceIOR, dotNVi, material.iridescenceThickness, material.specularColor );
		material.iridescenceFresnelMetallic = evalIridescence( 1.0, material.iridescenceIOR, dotNVi, material.iridescenceThickness, material.diffuseColor );
		material.iridescenceFresnel = mix( material.iridescenceFresnelDielectric, material.iridescenceFresnelMetallic, material.metalness );
		material.iridescenceF0 = Schlick_to_F0( material.iridescenceFresnel, 1.0, dotNVi );
	}
#endif
IncidentLight directLight;
#if ( NUM_POINT_LIGHTS > 0 ) && defined( RE_Direct )
	PointLight pointLight;
	#if defined( USE_SHADOWMAP ) && NUM_POINT_LIGHT_SHADOWS > 0
	PointLightShadow pointLightShadow;
	#endif
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_POINT_LIGHTS; i ++ ) {
		pointLight = pointLights[ i ];
		getPointLightInfo( pointLight, geometryPosition, directLight );
		#if defined( USE_SHADOWMAP ) && ( UNROLLED_LOOP_INDEX < NUM_POINT_LIGHT_SHADOWS ) && ( defined( SHADOWMAP_TYPE_PCF ) || defined( SHADOWMAP_TYPE_BASIC ) )
		pointLightShadow = pointLightShadows[ i ];
		directLight.color *= ( directLight.visible && receiveShadow ) ? getPointShadow( pointShadowMap[ i ], pointLightShadow.shadowMapSize, pointLightShadow.shadowIntensity, pointLightShadow.shadowBias, pointLightShadow.shadowRadius, vPointShadowCoord[ i ], pointLightShadow.shadowCameraNear, pointLightShadow.shadowCameraFar ) : 1.0;
		#endif
		RE_Direct( directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if ( NUM_SPOT_LIGHTS > 0 ) && defined( RE_Direct )
	SpotLight spotLight;
	vec4 spotColor;
	vec3 spotLightCoord;
	bool inSpotLightMap;
	#if defined( USE_SHADOWMAP ) && NUM_SPOT_LIGHT_SHADOWS > 0
	SpotLightShadow spotLightShadow;
	#endif
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SPOT_LIGHTS; i ++ ) {
		spotLight = spotLights[ i ];
		getSpotLightInfo( spotLight, geometryPosition, directLight );
		#if ( UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS_WITH_MAPS )
		#define SPOT_LIGHT_MAP_INDEX UNROLLED_LOOP_INDEX
		#elif ( UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS )
		#define SPOT_LIGHT_MAP_INDEX NUM_SPOT_LIGHT_MAPS
		#else
		#define SPOT_LIGHT_MAP_INDEX ( UNROLLED_LOOP_INDEX - NUM_SPOT_LIGHT_SHADOWS + NUM_SPOT_LIGHT_SHADOWS_WITH_MAPS )
		#endif
		#if ( SPOT_LIGHT_MAP_INDEX < NUM_SPOT_LIGHT_MAPS )
			spotLightCoord = vSpotLightCoord[ i ].xyz / vSpotLightCoord[ i ].w;
			inSpotLightMap = all( lessThan( abs( spotLightCoord * 2. - 1. ), vec3( 1.0 ) ) );
			spotColor = texture2D( spotLightMap[ SPOT_LIGHT_MAP_INDEX ], spotLightCoord.xy );
			directLight.color = inSpotLightMap ? directLight.color * spotColor.rgb : directLight.color;
		#endif
		#undef SPOT_LIGHT_MAP_INDEX
		#if defined( USE_SHADOWMAP ) && ( UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS )
		spotLightShadow = spotLightShadows[ i ];
		directLight.color *= ( directLight.visible && receiveShadow ) ? getShadow( spotShadowMap[ i ], spotLightShadow.shadowMapSize, spotLightShadow.shadowIntensity, spotLightShadow.shadowBias, spotLightShadow.shadowRadius, vSpotLightCoord[ i ] ) : 1.0;
		#endif
		RE_Direct( directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if ( NUM_DIR_LIGHTS > 0 ) && defined( RE_Direct )
	DirectionalLight directionalLight;
	#if defined( USE_SHADOWMAP ) && NUM_DIR_LIGHT_SHADOWS > 0
	DirectionalLightShadow directionalLightShadow;
	#endif
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_DIR_LIGHTS; i ++ ) {
		directionalLight = directionalLights[ i ];
		getDirectionalLightInfo( directionalLight, directLight );
		#if defined( USE_SHADOWMAP ) && ( UNROLLED_LOOP_INDEX < NUM_DIR_LIGHT_SHADOWS )
		directionalLightShadow = directionalLightShadows[ i ];
		directLight.color *= ( directLight.visible && receiveShadow ) ? getShadow( directionalShadowMap[ i ], directionalLightShadow.shadowMapSize, directionalLightShadow.shadowIntensity, directionalLightShadow.shadowBias, directionalLightShadow.shadowRadius, vDirectionalShadowCoord[ i ] ) : 1.0;
		#endif
		RE_Direct( directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if ( NUM_RECT_AREA_LIGHTS > 0 ) && defined( RE_Direct_RectArea )
	RectAreaLight rectAreaLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_RECT_AREA_LIGHTS; i ++ ) {
		rectAreaLight = rectAreaLights[ i ];
		RE_Direct_RectArea( rectAreaLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
	}
	#pragma unroll_loop_end
#endif
#if defined( RE_IndirectDiffuse )
	vec3 iblIrradiance = vec3( 0.0 );
	vec3 irradiance = getAmbientLightIrradiance( ambientLightColor );
	#if defined( USE_LIGHT_PROBES )
		irradiance += getLightProbeIrradiance( lightProbe, geometryNormal );
	#endif
	#if ( NUM_HEMI_LIGHTS > 0 )
		#pragma unroll_loop_start
		for ( int i = 0; i < NUM_HEMI_LIGHTS; i ++ ) {
			irradiance += getHemisphereLightIrradiance( hemisphereLights[ i ], geometryNormal );
		}
		#pragma unroll_loop_end
	#endif
	#ifdef USE_LIGHT_PROBES_GRID
		vec3 probeWorldPos = ( ( vec4( geometryPosition, 1.0 ) - viewMatrix[ 3 ] ) * viewMatrix ).xyz;
		vec3 probeWorldNormal = transformNormalByInverseViewMatrix( geometryNormal, viewMatrix );
		irradiance += getLightProbeGridIrradiance( probeWorldPos, probeWorldNormal );
	#endif
#endif
#if defined( RE_IndirectSpecular )
	vec3 radiance = vec3( 0.0 );
	vec3 clearcoatRadiance = vec3( 0.0 );
#endif`,lights_fragment_maps:`#if defined( RE_IndirectDiffuse )
	#ifdef USE_LIGHTMAP
		vec4 lightMapTexel = texture2D( lightMap, vLightMapUv );
		vec3 lightMapIrradiance = lightMapTexel.rgb * lightMapIntensity;
		irradiance += lightMapIrradiance;
	#endif
	#if defined( USE_ENVMAP ) && defined( ENVMAP_TYPE_CUBE_UV )
		#if defined( STANDARD ) || defined( LAMBERT ) || defined( PHONG )
			iblIrradiance += getIBLIrradiance( geometryNormal );
		#endif
	#endif
#endif
#if defined( USE_ENVMAP ) && defined( RE_IndirectSpecular )
	#ifdef USE_ANISOTROPY
		radiance += getIBLAnisotropyRadiance( geometryViewDir, geometryNormal, material.roughness, material.anisotropyB, material.anisotropy );
	#else
		radiance += getIBLRadiance( geometryViewDir, geometryNormal, material.roughness );
	#endif
	#ifdef USE_CLEARCOAT
		clearcoatRadiance += getIBLRadiance( geometryViewDir, geometryClearcoatNormal, material.clearcoatRoughness );
	#endif
#endif`,lights_fragment_end:`#if defined( RE_IndirectDiffuse )
	#if defined( LAMBERT ) || defined( PHONG )
		irradiance += iblIrradiance;
	#endif
	RE_IndirectDiffuse( irradiance, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
#endif
#if defined( RE_IndirectSpecular )
	RE_IndirectSpecular( radiance, iblIrradiance, clearcoatRadiance, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight );
#endif`,lightprobes_pars_fragment:`#ifdef USE_LIGHT_PROBES_GRID
uniform highp sampler3D probesSH;
uniform vec3 probesMin;
uniform vec3 probesMax;
uniform vec3 probesResolution;
vec3 getLightProbeGridIrradiance( vec3 worldPos, vec3 worldNormal ) {
	vec3 res = probesResolution;
	vec3 gridRange = probesMax - probesMin;
	vec3 resMinusOne = res - 1.0;
	vec3 probeSpacing = gridRange / resMinusOne;
	vec3 samplePos = worldPos + worldNormal * probeSpacing * 0.5;
	vec3 uvw = clamp( ( samplePos - probesMin ) / gridRange, 0.0, 1.0 );
	uvw = uvw * resMinusOne / res + 0.5 / res;
	float nz          = res.z;
	float paddedSlices = nz + 2.0;
	float atlasDepth  = 7.0 * paddedSlices;
	float uvZBase     = uvw.z * nz + 1.0;
	vec4 s0 = texture( probesSH, vec3( uvw.xy, ( uvZBase                       ) / atlasDepth ) );
	vec4 s1 = texture( probesSH, vec3( uvw.xy, ( uvZBase +       paddedSlices   ) / atlasDepth ) );
	vec4 s2 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 2.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s3 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 3.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s4 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 4.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s5 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 5.0 * paddedSlices   ) / atlasDepth ) );
	vec4 s6 = texture( probesSH, vec3( uvw.xy, ( uvZBase + 6.0 * paddedSlices   ) / atlasDepth ) );
	vec3 c0 = s0.xyz;
	vec3 c1 = vec3( s0.w, s1.xy );
	vec3 c2 = vec3( s1.zw, s2.x );
	vec3 c3 = s2.yzw;
	vec3 c4 = s3.xyz;
	vec3 c5 = vec3( s3.w, s4.xy );
	vec3 c6 = vec3( s4.zw, s5.x );
	vec3 c7 = s5.yzw;
	vec3 c8 = s6.xyz;
	float x = worldNormal.x, y = worldNormal.y, z = worldNormal.z;
	vec3 result = c0 * 0.886227;
	result += c1 * 2.0 * 0.511664 * y;
	result += c2 * 2.0 * 0.511664 * z;
	result += c3 * 2.0 * 0.511664 * x;
	result += c4 * 2.0 * 0.429043 * x * y;
	result += c5 * 2.0 * 0.429043 * y * z;
	result += c6 * ( 0.743125 * z * z - 0.247708 );
	result += c7 * 2.0 * 0.429043 * x * z;
	result += c8 * 0.429043 * ( x * x - y * y );
	return max( result, vec3( 0.0 ) );
}
#endif`,logdepthbuf_fragment:`#if defined( USE_LOGARITHMIC_DEPTH_BUFFER )
	gl_FragDepth = vIsPerspective == 0.0 ? gl_FragCoord.z : log2( vFragDepth ) * logDepthBufFC * 0.5;
#endif`,logdepthbuf_pars_fragment:`#if defined( USE_LOGARITHMIC_DEPTH_BUFFER )
	uniform float logDepthBufFC;
	varying float vFragDepth;
	varying float vIsPerspective;
#endif`,logdepthbuf_pars_vertex:`#ifdef USE_LOGARITHMIC_DEPTH_BUFFER
	varying float vFragDepth;
	varying float vIsPerspective;
#endif`,logdepthbuf_vertex:`#ifdef USE_LOGARITHMIC_DEPTH_BUFFER
	vFragDepth = 1.0 + gl_Position.w;
	vIsPerspective = float( isPerspectiveMatrix( projectionMatrix ) );
#endif`,map_fragment:`#ifdef USE_MAP
	vec4 sampledDiffuseColor = texture2D( map, vMapUv );
	#ifdef DECODE_VIDEO_TEXTURE
		sampledDiffuseColor = sRGBTransferEOTF( sampledDiffuseColor );
	#endif
	diffuseColor *= sampledDiffuseColor;
#endif`,map_pars_fragment:`#ifdef USE_MAP
	uniform sampler2D map;
#endif`,map_particle_fragment:`#if defined( USE_MAP ) || defined( USE_ALPHAMAP )
	#if defined( USE_POINTS_UV )
		vec2 uv = vUv;
	#else
		vec2 uv = ( uvTransform * vec3( gl_PointCoord.x, 1.0 - gl_PointCoord.y, 1 ) ).xy;
	#endif
#endif
#ifdef USE_MAP
	diffuseColor *= texture2D( map, uv );
#endif
#ifdef USE_ALPHAMAP
	diffuseColor.a *= texture2D( alphaMap, uv ).g;
#endif`,map_particle_pars_fragment:`#if defined( USE_POINTS_UV )
	varying vec2 vUv;
#else
	#if defined( USE_MAP ) || defined( USE_ALPHAMAP )
		uniform mat3 uvTransform;
	#endif
#endif
#ifdef USE_MAP
	uniform sampler2D map;
#endif
#ifdef USE_ALPHAMAP
	uniform sampler2D alphaMap;
#endif`,metalnessmap_fragment:`float metalnessFactor = metalness;
#ifdef USE_METALNESSMAP
	vec4 texelMetalness = texture2D( metalnessMap, vMetalnessMapUv );
	metalnessFactor *= texelMetalness.b;
#endif`,metalnessmap_pars_fragment:`#ifdef USE_METALNESSMAP
	uniform sampler2D metalnessMap;
#endif`,morphinstance_vertex:`#ifdef USE_INSTANCING_MORPH
	float morphTargetInfluences[ MORPHTARGETS_COUNT ];
	float morphTargetBaseInfluence = texelFetch( morphTexture, ivec2( 0, gl_InstanceID ), 0 ).r;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		morphTargetInfluences[i] =  texelFetch( morphTexture, ivec2( i + 1, gl_InstanceID ), 0 ).r;
	}
#endif`,morphcolor_vertex:`#if defined( USE_MORPHCOLORS )
	vColor *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		#if defined( USE_COLOR_ALPHA )
			if ( morphTargetInfluences[ i ] != 0.0 ) vColor += getMorph( gl_VertexID, i, 2 ) * morphTargetInfluences[ i ];
		#elif defined( USE_COLOR )
			if ( morphTargetInfluences[ i ] != 0.0 ) vColor += getMorph( gl_VertexID, i, 2 ).rgb * morphTargetInfluences[ i ];
		#endif
	}
#endif`,morphnormal_vertex:`#ifdef USE_MORPHNORMALS
	objectNormal *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		if ( morphTargetInfluences[ i ] != 0.0 ) objectNormal += getMorph( gl_VertexID, i, 1 ).xyz * morphTargetInfluences[ i ];
	}
#endif`,morphtarget_pars_vertex:`#ifdef USE_MORPHTARGETS
	#ifndef USE_INSTANCING_MORPH
		uniform float morphTargetBaseInfluence;
		uniform float morphTargetInfluences[ MORPHTARGETS_COUNT ];
	#endif
	uniform sampler2DArray morphTargetsTexture;
	uniform ivec2 morphTargetsTextureSize;
	vec4 getMorph( const in int vertexIndex, const in int morphTargetIndex, const in int offset ) {
		int texelIndex = vertexIndex * MORPHTARGETS_TEXTURE_STRIDE + offset;
		int y = texelIndex / morphTargetsTextureSize.x;
		int x = texelIndex - y * morphTargetsTextureSize.x;
		ivec3 morphUV = ivec3( x, y, morphTargetIndex );
		return texelFetch( morphTargetsTexture, morphUV, 0 );
	}
#endif`,morphtarget_vertex:`#ifdef USE_MORPHTARGETS
	transformed *= morphTargetBaseInfluence;
	for ( int i = 0; i < MORPHTARGETS_COUNT; i ++ ) {
		if ( morphTargetInfluences[ i ] != 0.0 ) transformed += getMorph( gl_VertexID, i, 0 ).xyz * morphTargetInfluences[ i ];
	}
#endif`,normal_fragment_begin:`float faceDirection = gl_FrontFacing ? 1.0 : - 1.0;
#ifdef FLAT_SHADED
	vec3 fdx = dFdx( vViewPosition );
	vec3 fdy = dFdy( vViewPosition );
	vec3 normal = normalize( cross( fdx, fdy ) );
#else
	vec3 normal = normalize( vNormal );
	#ifdef DOUBLE_SIDED
		normal *= faceDirection;
	#endif
#endif
#if defined( USE_NORMALMAP_TANGENTSPACE ) || defined( USE_CLEARCOAT_NORMALMAP ) || defined( USE_ANISOTROPY )
	#ifdef USE_TANGENT
		mat3 tbn = mat3( normalize( vTangent ), normalize( vBitangent ), normal );
	#else
		mat3 tbn = getTangentFrame( - vViewPosition, normal,
		#if defined( USE_NORMALMAP )
			vNormalMapUv
		#elif defined( USE_CLEARCOAT_NORMALMAP )
			vClearcoatNormalMapUv
		#else
			vUv
		#endif
		);
	#endif
	#ifdef DOUBLE_SIDED
		tbn[0] *= faceDirection;
		tbn[1] *= faceDirection;
	#endif
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	#ifdef USE_TANGENT
		mat3 tbn2 = mat3( normalize( vTangent ), normalize( vBitangent ), normal );
	#else
		mat3 tbn2 = getTangentFrame( - vViewPosition, normal, vClearcoatNormalMapUv );
	#endif
	#ifdef DOUBLE_SIDED
		tbn2[0] *= faceDirection;
		tbn2[1] *= faceDirection;
	#endif
#endif
vec3 nonPerturbedNormal = normal;`,normal_fragment_maps:`#ifdef USE_NORMALMAP_OBJECTSPACE
	normal = texture2D( normalMap, vNormalMapUv ).xyz * 2.0 - 1.0;
	#ifdef FLIP_SIDED
		normal = - normal;
	#endif
	#ifdef DOUBLE_SIDED
		normal = normal * faceDirection;
	#endif
	normal = normalize( normalMatrix * normal );
#elif defined( USE_NORMALMAP_TANGENTSPACE )
	vec3 mapN = texture2D( normalMap, vNormalMapUv ).xyz * 2.0 - 1.0;
	#if defined( USE_PACKED_NORMALMAP )
		mapN = vec3( mapN.xy, sqrt( saturate( 1.0 - dot( mapN.xy, mapN.xy ) ) ) );
	#endif
	mapN.xy *= normalScale;
	normal = normalize( tbn * mapN );
#elif defined( USE_BUMPMAP )
	normal = perturbNormalArb( - vViewPosition, normal, dHdxy_fwd(), faceDirection );
#endif`,normal_pars_fragment:`#ifndef FLAT_SHADED
	varying vec3 vNormal;
	#ifdef USE_TANGENT
		varying vec3 vTangent;
		varying vec3 vBitangent;
	#endif
#endif`,normal_pars_vertex:`#ifndef FLAT_SHADED
	varying vec3 vNormal;
	#ifdef USE_TANGENT
		varying vec3 vTangent;
		varying vec3 vBitangent;
	#endif
#endif`,normal_vertex:`#ifndef FLAT_SHADED
	vNormal = normalize( transformedNormal );
	#ifdef USE_TANGENT
		vTangent = normalize( transformedTangent );
		vBitangent = normalize( cross( vNormal, vTangent ) * tangent.w );
		#ifdef FLIP_SIDED
			vBitangent = - vBitangent;
		#endif
	#endif
#endif`,normalmap_pars_fragment:`#ifdef USE_NORMALMAP
	uniform sampler2D normalMap;
	uniform vec2 normalScale;
#endif
#ifdef USE_NORMALMAP_OBJECTSPACE
	uniform mat3 normalMatrix;
#endif
#if ! defined ( USE_TANGENT ) && ( defined ( USE_NORMALMAP_TANGENTSPACE ) || defined ( USE_CLEARCOAT_NORMALMAP ) || defined( USE_ANISOTROPY ) )
	mat3 getTangentFrame( vec3 eye_pos, vec3 surf_norm, vec2 uv ) {
		vec3 q0 = dFdx( eye_pos.xyz );
		vec3 q1 = dFdy( eye_pos.xyz );
		vec2 st0 = dFdx( uv.st );
		vec2 st1 = dFdy( uv.st );
		vec3 N = surf_norm;
		vec3 q1perp = cross( q1, N );
		vec3 q0perp = cross( N, q0 );
		vec3 T = q1perp * st0.x + q0perp * st1.x;
		vec3 B = q1perp * st0.y + q0perp * st1.y;
		float det = max( dot( T, T ), dot( B, B ) );
		float scale = ( det == 0.0 ) ? 0.0 : inversesqrt( det );
		return mat3( T * scale, B * scale, N );
	}
#endif`,clearcoat_normal_fragment_begin:`#ifdef USE_CLEARCOAT
	vec3 clearcoatNormal = nonPerturbedNormal;
#endif`,clearcoat_normal_fragment_maps:`#ifdef USE_CLEARCOAT_NORMALMAP
	vec3 clearcoatMapN = texture2D( clearcoatNormalMap, vClearcoatNormalMapUv ).xyz * 2.0 - 1.0;
	clearcoatMapN.xy *= clearcoatNormalScale;
	clearcoatNormal = normalize( tbn2 * clearcoatMapN );
#endif`,clearcoat_pars_fragment:`#ifdef USE_CLEARCOATMAP
	uniform sampler2D clearcoatMap;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	uniform sampler2D clearcoatNormalMap;
	uniform vec2 clearcoatNormalScale;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	uniform sampler2D clearcoatRoughnessMap;
#endif`,iridescence_pars_fragment:`#ifdef USE_IRIDESCENCEMAP
	uniform sampler2D iridescenceMap;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	uniform sampler2D iridescenceThicknessMap;
#endif`,opaque_fragment:`#ifdef OPAQUE
diffuseColor.a = 1.0;
#endif
#ifdef USE_TRANSMISSION
diffuseColor.a *= material.transmissionAlpha;
#endif
gl_FragColor = vec4( outgoingLight, diffuseColor.a );`,packing:`vec3 packNormalToRGB( const in vec3 normal ) {
	return normalize( normal ) * 0.5 + 0.5;
}
vec3 unpackRGBToNormal( const in vec3 rgb ) {
	return 2.0 * rgb.xyz - 1.0;
}
const float PackUpscale = 256. / 255.;const float UnpackDownscale = 255. / 256.;const float ShiftRight8 = 1. / 256.;
const float Inv255 = 1. / 255.;
const vec4 PackFactors = vec4( 1.0, 256.0, 256.0 * 256.0, 256.0 * 256.0 * 256.0 );
const vec2 UnpackFactors2 = vec2( UnpackDownscale, 1.0 / PackFactors.g );
const vec3 UnpackFactors3 = vec3( UnpackDownscale / PackFactors.rg, 1.0 / PackFactors.b );
const vec4 UnpackFactors4 = vec4( UnpackDownscale / PackFactors.rgb, 1.0 / PackFactors.a );
vec4 packDepthToRGBA( const in float v ) {
	if( v <= 0.0 )
		return vec4( 0., 0., 0., 0. );
	if( v >= 1.0 )
		return vec4( 1., 1., 1., 1. );
	float vuf;
	float af = modf( v * PackFactors.a, vuf );
	float bf = modf( vuf * ShiftRight8, vuf );
	float gf = modf( vuf * ShiftRight8, vuf );
	return vec4( vuf * Inv255, gf * PackUpscale, bf * PackUpscale, af );
}
vec3 packDepthToRGB( const in float v ) {
	if( v <= 0.0 )
		return vec3( 0., 0., 0. );
	if( v >= 1.0 )
		return vec3( 1., 1., 1. );
	float vuf;
	float bf = modf( v * PackFactors.b, vuf );
	float gf = modf( vuf * ShiftRight8, vuf );
	return vec3( vuf * Inv255, gf * PackUpscale, bf );
}
vec2 packDepthToRG( const in float v ) {
	if( v <= 0.0 )
		return vec2( 0., 0. );
	if( v >= 1.0 )
		return vec2( 1., 1. );
	float vuf;
	float gf = modf( v * 256., vuf );
	return vec2( vuf * Inv255, gf );
}
float unpackRGBAToDepth( const in vec4 v ) {
	return dot( v, UnpackFactors4 );
}
float unpackRGBToDepth( const in vec3 v ) {
	return dot( v, UnpackFactors3 );
}
float unpackRGToDepth( const in vec2 v ) {
	return v.r * UnpackFactors2.r + v.g * UnpackFactors2.g;
}
vec4 pack2HalfToRGBA( const in vec2 v ) {
	vec4 r = vec4( v.x, fract( v.x * 255.0 ), v.y, fract( v.y * 255.0 ) );
	return vec4( r.x - r.y / 255.0, r.y, r.z - r.w / 255.0, r.w );
}
vec2 unpackRGBATo2Half( const in vec4 v ) {
	return vec2( v.x + ( v.y / 255.0 ), v.z + ( v.w / 255.0 ) );
}
float viewZToOrthographicDepth( const in float viewZ, const in float near, const in float far ) {
	return ( viewZ + near ) / ( near - far );
}
float orthographicDepthToViewZ( const in float depth, const in float near, const in float far ) {
	#ifdef USE_REVERSED_DEPTH_BUFFER
	
		return depth * ( far - near ) - far;
	#else
		return depth * ( near - far ) - near;
	#endif
}
float viewZToPerspectiveDepth( const in float viewZ, const in float near, const in float far ) {
	return ( ( near + viewZ ) * far ) / ( ( far - near ) * viewZ );
}
float perspectiveDepthToViewZ( const in float depth, const in float near, const in float far ) {
	
	#ifdef USE_REVERSED_DEPTH_BUFFER
		return ( near * far ) / ( ( near - far ) * depth - near );
	#else
		return ( near * far ) / ( ( far - near ) * depth - far );
	#endif
}`,premultiplied_alpha_fragment:`#ifdef PREMULTIPLIED_ALPHA
	gl_FragColor.rgb *= gl_FragColor.a;
#endif`,project_vertex:`vec4 mvPosition = vec4( transformed, 1.0 );
#ifdef USE_BATCHING
	mvPosition = batchingMatrix * mvPosition;
#endif
#ifdef USE_INSTANCING
	mvPosition = instanceMatrix * mvPosition;
#endif
mvPosition = modelViewMatrix * mvPosition;
gl_Position = projectionMatrix * mvPosition;`,dithering_fragment:`#ifdef DITHERING
	gl_FragColor.rgb = dithering( gl_FragColor.rgb );
#endif`,dithering_pars_fragment:`#ifdef DITHERING
	vec3 dithering( vec3 color ) {
		float grid_position = rand( gl_FragCoord.xy );
		vec3 dither_shift_RGB = vec3( 0.25 / 255.0, -0.25 / 255.0, 0.25 / 255.0 );
		dither_shift_RGB = mix( 2.0 * dither_shift_RGB, -2.0 * dither_shift_RGB, grid_position );
		return color + dither_shift_RGB;
	}
#endif`,roughnessmap_fragment:`float roughnessFactor = roughness;
#ifdef USE_ROUGHNESSMAP
	vec4 texelRoughness = texture2D( roughnessMap, vRoughnessMapUv );
	roughnessFactor *= texelRoughness.g;
#endif`,roughnessmap_pars_fragment:`#ifdef USE_ROUGHNESSMAP
	uniform sampler2D roughnessMap;
#endif`,shadowmap_pars_fragment:`#if NUM_SPOT_LIGHT_COORDS > 0
	varying vec4 vSpotLightCoord[ NUM_SPOT_LIGHT_COORDS ];
#endif
#if NUM_SPOT_LIGHT_MAPS > 0
	uniform sampler2D spotLightMap[ NUM_SPOT_LIGHT_MAPS ];
#endif
#ifdef USE_SHADOWMAP
	#if NUM_DIR_LIGHT_SHADOWS > 0
		#if defined( SHADOWMAP_TYPE_PCF )
			uniform sampler2DShadow directionalShadowMap[ NUM_DIR_LIGHT_SHADOWS ];
		#else
			uniform sampler2D directionalShadowMap[ NUM_DIR_LIGHT_SHADOWS ];
		#endif
		varying vec4 vDirectionalShadowCoord[ NUM_DIR_LIGHT_SHADOWS ];
		struct DirectionalLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform DirectionalLightShadow directionalLightShadows[ NUM_DIR_LIGHT_SHADOWS ];
	#endif
	#if NUM_SPOT_LIGHT_SHADOWS > 0
		#if defined( SHADOWMAP_TYPE_PCF )
			uniform sampler2DShadow spotShadowMap[ NUM_SPOT_LIGHT_SHADOWS ];
		#else
			uniform sampler2D spotShadowMap[ NUM_SPOT_LIGHT_SHADOWS ];
		#endif
		struct SpotLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform SpotLightShadow spotLightShadows[ NUM_SPOT_LIGHT_SHADOWS ];
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
		#if defined( SHADOWMAP_TYPE_PCF )
			uniform samplerCubeShadow pointShadowMap[ NUM_POINT_LIGHT_SHADOWS ];
		#elif defined( SHADOWMAP_TYPE_BASIC )
			uniform samplerCube pointShadowMap[ NUM_POINT_LIGHT_SHADOWS ];
		#endif
		varying vec4 vPointShadowCoord[ NUM_POINT_LIGHT_SHADOWS ];
		struct PointLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
			float shadowCameraNear;
			float shadowCameraFar;
		};
		uniform PointLightShadow pointLightShadows[ NUM_POINT_LIGHT_SHADOWS ];
	#endif
	#if defined( SHADOWMAP_TYPE_PCF )
		float interleavedGradientNoise( vec2 position ) {
			return fract( 52.9829189 * fract( dot( position, vec2( 0.06711056, 0.00583715 ) ) ) );
		}
		vec2 vogelDiskSample( int sampleIndex, int samplesCount, float phi ) {
			const float goldenAngle = 2.399963229728653;
			float r = sqrt( ( float( sampleIndex ) + 0.5 ) / float( samplesCount ) );
			float theta = float( sampleIndex ) * goldenAngle + phi;
			return vec2( cos( theta ), sin( theta ) ) * r;
		}
	#endif
	#if defined( SHADOWMAP_TYPE_PCF )
		float getShadow( sampler2DShadow shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord ) {
			float shadow = 1.0;
			shadowCoord.xyz /= shadowCoord.w;
			shadowCoord.z += shadowBias;
			bool inFrustum = shadowCoord.x >= 0.0 && shadowCoord.x <= 1.0 && shadowCoord.y >= 0.0 && shadowCoord.y <= 1.0;
			bool frustumTest = inFrustum && shadowCoord.z <= 1.0;
			if ( frustumTest ) {
				vec2 texelSize = vec2( 1.0 ) / shadowMapSize;
				float radius = shadowRadius * texelSize.x;
				float phi = interleavedGradientNoise( gl_FragCoord.xy ) * PI2;
				shadow = (
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 0, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 1, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 2, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 3, 5, phi ) * radius, shadowCoord.z ) ) +
					texture( shadowMap, vec3( shadowCoord.xy + vogelDiskSample( 4, 5, phi ) * radius, shadowCoord.z ) )
				) * 0.2;
			}
			return mix( 1.0, shadow, shadowIntensity );
		}
	#elif defined( SHADOWMAP_TYPE_VSM )
		float getShadow( sampler2D shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord ) {
			float shadow = 1.0;
			shadowCoord.xyz /= shadowCoord.w;
			#ifdef USE_REVERSED_DEPTH_BUFFER
				shadowCoord.z -= shadowBias;
			#else
				shadowCoord.z += shadowBias;
			#endif
			bool inFrustum = shadowCoord.x >= 0.0 && shadowCoord.x <= 1.0 && shadowCoord.y >= 0.0 && shadowCoord.y <= 1.0;
			bool frustumTest = inFrustum && shadowCoord.z <= 1.0;
			if ( frustumTest ) {
				vec2 distribution = texture2D( shadowMap, shadowCoord.xy ).rg;
				float mean = distribution.x;
				float variance = distribution.y * distribution.y;
				#ifdef USE_REVERSED_DEPTH_BUFFER
					float hard_shadow = step( mean, shadowCoord.z );
				#else
					float hard_shadow = step( shadowCoord.z, mean );
				#endif
				
				if ( hard_shadow == 1.0 ) {
					shadow = 1.0;
				} else {
					variance = max( variance, 0.0000001 );
					float d = shadowCoord.z - mean;
					float p_max = variance / ( variance + d * d );
					p_max = clamp( ( p_max - 0.3 ) / 0.65, 0.0, 1.0 );
					shadow = max( hard_shadow, p_max );
				}
			}
			return mix( 1.0, shadow, shadowIntensity );
		}
	#else
		float getShadow( sampler2D shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord ) {
			float shadow = 1.0;
			shadowCoord.xyz /= shadowCoord.w;
			#ifdef USE_REVERSED_DEPTH_BUFFER
				shadowCoord.z -= shadowBias;
			#else
				shadowCoord.z += shadowBias;
			#endif
			bool inFrustum = shadowCoord.x >= 0.0 && shadowCoord.x <= 1.0 && shadowCoord.y >= 0.0 && shadowCoord.y <= 1.0;
			bool frustumTest = inFrustum && shadowCoord.z <= 1.0;
			if ( frustumTest ) {
				float depth = texture2D( shadowMap, shadowCoord.xy ).r;
				#ifdef USE_REVERSED_DEPTH_BUFFER
					shadow = step( depth, shadowCoord.z );
				#else
					shadow = step( shadowCoord.z, depth );
				#endif
			}
			return mix( 1.0, shadow, shadowIntensity );
		}
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
	#if defined( SHADOWMAP_TYPE_PCF )
	float getPointShadow( samplerCubeShadow shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord, float shadowCameraNear, float shadowCameraFar ) {
		float shadow = 1.0;
		vec3 lightToPosition = shadowCoord.xyz;
		vec3 bd3D = normalize( lightToPosition );
		vec3 absVec = abs( lightToPosition );
		float viewSpaceZ = max( max( absVec.x, absVec.y ), absVec.z );
		if ( viewSpaceZ - shadowCameraFar <= 0.0 && viewSpaceZ - shadowCameraNear >= 0.0 ) {
			#ifdef USE_REVERSED_DEPTH_BUFFER
				float dp = ( shadowCameraNear * ( shadowCameraFar - viewSpaceZ ) ) / ( viewSpaceZ * ( shadowCameraFar - shadowCameraNear ) );
				dp -= shadowBias;
			#else
				float dp = ( shadowCameraFar * ( viewSpaceZ - shadowCameraNear ) ) / ( viewSpaceZ * ( shadowCameraFar - shadowCameraNear ) );
				dp += shadowBias;
			#endif
			float texelSize = shadowRadius / shadowMapSize.x;
			vec3 absDir = abs( bd3D );
			vec3 tangent = absDir.x > absDir.z ? vec3( 0.0, 1.0, 0.0 ) : vec3( 1.0, 0.0, 0.0 );
			tangent = normalize( cross( bd3D, tangent ) );
			vec3 bitangent = cross( bd3D, tangent );
			float phi = interleavedGradientNoise( gl_FragCoord.xy ) * PI2;
			vec2 sample0 = vogelDiskSample( 0, 5, phi );
			vec2 sample1 = vogelDiskSample( 1, 5, phi );
			vec2 sample2 = vogelDiskSample( 2, 5, phi );
			vec2 sample3 = vogelDiskSample( 3, 5, phi );
			vec2 sample4 = vogelDiskSample( 4, 5, phi );
			shadow = (
				texture( shadowMap, vec4( bd3D + ( tangent * sample0.x + bitangent * sample0.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample1.x + bitangent * sample1.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample2.x + bitangent * sample2.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample3.x + bitangent * sample3.y ) * texelSize, dp ) ) +
				texture( shadowMap, vec4( bd3D + ( tangent * sample4.x + bitangent * sample4.y ) * texelSize, dp ) )
			) * 0.2;
		}
		return mix( 1.0, shadow, shadowIntensity );
	}
	#elif defined( SHADOWMAP_TYPE_BASIC )
	float getPointShadow( samplerCube shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord, float shadowCameraNear, float shadowCameraFar ) {
		float shadow = 1.0;
		vec3 lightToPosition = shadowCoord.xyz;
		vec3 absVec = abs( lightToPosition );
		float viewSpaceZ = max( max( absVec.x, absVec.y ), absVec.z );
		if ( viewSpaceZ - shadowCameraFar <= 0.0 && viewSpaceZ - shadowCameraNear >= 0.0 ) {
			float dp = ( shadowCameraFar * ( viewSpaceZ - shadowCameraNear ) ) / ( viewSpaceZ * ( shadowCameraFar - shadowCameraNear ) );
			dp += shadowBias;
			vec3 bd3D = normalize( lightToPosition );
			float depth = textureCube( shadowMap, bd3D ).r;
			#ifdef USE_REVERSED_DEPTH_BUFFER
				depth = 1.0 - depth;
			#endif
			shadow = step( dp, depth );
		}
		return mix( 1.0, shadow, shadowIntensity );
	}
	#endif
	#endif
#endif`,shadowmap_pars_vertex:`#if NUM_SPOT_LIGHT_COORDS > 0
	uniform mat4 spotLightMatrix[ NUM_SPOT_LIGHT_COORDS ];
	varying vec4 vSpotLightCoord[ NUM_SPOT_LIGHT_COORDS ];
#endif
#ifdef USE_SHADOWMAP
	#if NUM_DIR_LIGHT_SHADOWS > 0
		uniform mat4 directionalShadowMatrix[ NUM_DIR_LIGHT_SHADOWS ];
		varying vec4 vDirectionalShadowCoord[ NUM_DIR_LIGHT_SHADOWS ];
		struct DirectionalLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform DirectionalLightShadow directionalLightShadows[ NUM_DIR_LIGHT_SHADOWS ];
	#endif
	#if NUM_SPOT_LIGHT_SHADOWS > 0
		struct SpotLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
		};
		uniform SpotLightShadow spotLightShadows[ NUM_SPOT_LIGHT_SHADOWS ];
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
		uniform mat4 pointShadowMatrix[ NUM_POINT_LIGHT_SHADOWS ];
		varying vec4 vPointShadowCoord[ NUM_POINT_LIGHT_SHADOWS ];
		struct PointLightShadow {
			float shadowIntensity;
			float shadowBias;
			float shadowNormalBias;
			float shadowRadius;
			vec2 shadowMapSize;
			float shadowCameraNear;
			float shadowCameraFar;
		};
		uniform PointLightShadow pointLightShadows[ NUM_POINT_LIGHT_SHADOWS ];
	#endif
#endif`,shadowmap_vertex:`#if ( defined( USE_SHADOWMAP ) && ( NUM_DIR_LIGHT_SHADOWS > 0 || NUM_POINT_LIGHT_SHADOWS > 0 ) ) || ( NUM_SPOT_LIGHT_COORDS > 0 )
	#ifdef HAS_NORMAL
		vec3 shadowWorldNormal = transformNormalByInverseViewMatrix( transformedNormal, viewMatrix );
	#else
		vec3 shadowWorldNormal = vec3( 0.0 );
	#endif
	vec4 shadowWorldPosition;
#endif
#if defined( USE_SHADOWMAP )
	#if NUM_DIR_LIGHT_SHADOWS > 0
		#pragma unroll_loop_start
		for ( int i = 0; i < NUM_DIR_LIGHT_SHADOWS; i ++ ) {
			shadowWorldPosition = worldPosition + vec4( shadowWorldNormal * directionalLightShadows[ i ].shadowNormalBias, 0 );
			vDirectionalShadowCoord[ i ] = directionalShadowMatrix[ i ] * shadowWorldPosition;
		}
		#pragma unroll_loop_end
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0
		#pragma unroll_loop_start
		for ( int i = 0; i < NUM_POINT_LIGHT_SHADOWS; i ++ ) {
			shadowWorldPosition = worldPosition + vec4( shadowWorldNormal * pointLightShadows[ i ].shadowNormalBias, 0 );
			vPointShadowCoord[ i ] = pointShadowMatrix[ i ] * shadowWorldPosition;
		}
		#pragma unroll_loop_end
	#endif
#endif
#if NUM_SPOT_LIGHT_COORDS > 0
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SPOT_LIGHT_COORDS; i ++ ) {
		shadowWorldPosition = worldPosition;
		#if ( defined( USE_SHADOWMAP ) && UNROLLED_LOOP_INDEX < NUM_SPOT_LIGHT_SHADOWS )
			shadowWorldPosition.xyz += shadowWorldNormal * spotLightShadows[ i ].shadowNormalBias;
		#endif
		vSpotLightCoord[ i ] = spotLightMatrix[ i ] * shadowWorldPosition;
	}
	#pragma unroll_loop_end
#endif`,shadowmask_pars_fragment:`float getShadowMask() {
	float shadow = 1.0;
	#ifdef USE_SHADOWMAP
	#if NUM_DIR_LIGHT_SHADOWS > 0
	DirectionalLightShadow directionalLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_DIR_LIGHT_SHADOWS; i ++ ) {
		directionalLight = directionalLightShadows[ i ];
		shadow *= receiveShadow ? getShadow( directionalShadowMap[ i ], directionalLight.shadowMapSize, directionalLight.shadowIntensity, directionalLight.shadowBias, directionalLight.shadowRadius, vDirectionalShadowCoord[ i ] ) : 1.0;
	}
	#pragma unroll_loop_end
	#endif
	#if NUM_SPOT_LIGHT_SHADOWS > 0
	SpotLightShadow spotLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_SPOT_LIGHT_SHADOWS; i ++ ) {
		spotLight = spotLightShadows[ i ];
		shadow *= receiveShadow ? getShadow( spotShadowMap[ i ], spotLight.shadowMapSize, spotLight.shadowIntensity, spotLight.shadowBias, spotLight.shadowRadius, vSpotLightCoord[ i ] ) : 1.0;
	}
	#pragma unroll_loop_end
	#endif
	#if NUM_POINT_LIGHT_SHADOWS > 0 && ( defined( SHADOWMAP_TYPE_PCF ) || defined( SHADOWMAP_TYPE_BASIC ) )
	PointLightShadow pointLight;
	#pragma unroll_loop_start
	for ( int i = 0; i < NUM_POINT_LIGHT_SHADOWS; i ++ ) {
		pointLight = pointLightShadows[ i ];
		shadow *= receiveShadow ? getPointShadow( pointShadowMap[ i ], pointLight.shadowMapSize, pointLight.shadowIntensity, pointLight.shadowBias, pointLight.shadowRadius, vPointShadowCoord[ i ], pointLight.shadowCameraNear, pointLight.shadowCameraFar ) : 1.0;
	}
	#pragma unroll_loop_end
	#endif
	#endif
	return shadow;
}`,skinbase_vertex:`#ifdef USE_SKINNING
	mat4 boneMatX = getBoneMatrix( skinIndex.x );
	mat4 boneMatY = getBoneMatrix( skinIndex.y );
	mat4 boneMatZ = getBoneMatrix( skinIndex.z );
	mat4 boneMatW = getBoneMatrix( skinIndex.w );
#endif`,skinning_pars_vertex:`#ifdef USE_SKINNING
	uniform mat4 bindMatrix;
	uniform mat4 bindMatrixInverse;
	uniform highp sampler2D boneTexture;
	mat4 getBoneMatrix( const in float i ) {
		int size = textureSize( boneTexture, 0 ).x;
		int j = int( i ) * 4;
		int x = j % size;
		int y = j / size;
		vec4 v1 = texelFetch( boneTexture, ivec2( x, y ), 0 );
		vec4 v2 = texelFetch( boneTexture, ivec2( x + 1, y ), 0 );
		vec4 v3 = texelFetch( boneTexture, ivec2( x + 2, y ), 0 );
		vec4 v4 = texelFetch( boneTexture, ivec2( x + 3, y ), 0 );
		return mat4( v1, v2, v3, v4 );
	}
#endif`,skinning_vertex:`#ifdef USE_SKINNING
	vec4 skinVertex = bindMatrix * vec4( transformed, 1.0 );
	vec4 skinned = vec4( 0.0 );
	skinned += boneMatX * skinVertex * skinWeight.x;
	skinned += boneMatY * skinVertex * skinWeight.y;
	skinned += boneMatZ * skinVertex * skinWeight.z;
	skinned += boneMatW * skinVertex * skinWeight.w;
	transformed = ( bindMatrixInverse * skinned ).xyz;
#endif`,skinnormal_vertex:`#ifdef USE_SKINNING
	mat4 skinMatrix = mat4( 0.0 );
	skinMatrix += skinWeight.x * boneMatX;
	skinMatrix += skinWeight.y * boneMatY;
	skinMatrix += skinWeight.z * boneMatZ;
	skinMatrix += skinWeight.w * boneMatW;
	skinMatrix = bindMatrixInverse * skinMatrix * bindMatrix;
	objectNormal = vec4( skinMatrix * vec4( objectNormal, 0.0 ) ).xyz;
	#ifdef USE_TANGENT
		objectTangent = vec4( skinMatrix * vec4( objectTangent, 0.0 ) ).xyz;
	#endif
#endif`,specularmap_fragment:`float specularStrength;
#ifdef USE_SPECULARMAP
	vec4 texelSpecular = texture2D( specularMap, vSpecularMapUv );
	specularStrength = texelSpecular.r;
#else
	specularStrength = 1.0;
#endif`,specularmap_pars_fragment:`#ifdef USE_SPECULARMAP
	uniform sampler2D specularMap;
#endif`,tonemapping_fragment:`#if defined( TONE_MAPPING )
	gl_FragColor.rgb = toneMapping( gl_FragColor.rgb );
#endif`,tonemapping_pars_fragment:`#ifndef saturate
#define saturate( a ) clamp( a, 0.0, 1.0 )
#endif
uniform float toneMappingExposure;
vec3 LinearToneMapping( vec3 color ) {
	return saturate( toneMappingExposure * color );
}
vec3 ReinhardToneMapping( vec3 color ) {
	color *= toneMappingExposure;
	return saturate( color / ( vec3( 1.0 ) + color ) );
}
vec3 CineonToneMapping( vec3 color ) {
	color *= toneMappingExposure;
	color = max( vec3( 0.0 ), color - 0.004 );
	return pow( ( color * ( 6.2 * color + 0.5 ) ) / ( color * ( 6.2 * color + 1.7 ) + 0.06 ), vec3( 2.2 ) );
}
vec3 RRTAndODTFit( vec3 v ) {
	vec3 a = v * ( v + 0.0245786 ) - 0.000090537;
	vec3 b = v * ( 0.983729 * v + 0.4329510 ) + 0.238081;
	return a / b;
}
vec3 ACESFilmicToneMapping( vec3 color ) {
	const mat3 ACESInputMat = mat3(
		vec3( 0.59719, 0.07600, 0.02840 ),		vec3( 0.35458, 0.90834, 0.13383 ),
		vec3( 0.04823, 0.01566, 0.83777 )
	);
	const mat3 ACESOutputMat = mat3(
		vec3(  1.60475, -0.10208, -0.00327 ),		vec3( -0.53108,  1.10813, -0.07276 ),
		vec3( -0.07367, -0.00605,  1.07602 )
	);
	color *= toneMappingExposure / 0.6;
	color = ACESInputMat * color;
	color = RRTAndODTFit( color );
	color = ACESOutputMat * color;
	return saturate( color );
}
const mat3 LINEAR_REC2020_TO_LINEAR_SRGB = mat3(
	vec3( 1.6605, - 0.1246, - 0.0182 ),
	vec3( - 0.5876, 1.1329, - 0.1006 ),
	vec3( - 0.0728, - 0.0083, 1.1187 )
);
const mat3 LINEAR_SRGB_TO_LINEAR_REC2020 = mat3(
	vec3( 0.6274, 0.0691, 0.0164 ),
	vec3( 0.3293, 0.9195, 0.0880 ),
	vec3( 0.0433, 0.0113, 0.8956 )
);
vec3 agxDefaultContrastApprox( vec3 x ) {
	vec3 x2 = x * x;
	vec3 x4 = x2 * x2;
	return + 15.5 * x4 * x2
		- 40.14 * x4 * x
		+ 31.96 * x4
		- 6.868 * x2 * x
		+ 0.4298 * x2
		+ 0.1191 * x
		- 0.00232;
}
vec3 AgXToneMapping( vec3 color ) {
	const mat3 AgXInsetMatrix = mat3(
		vec3( 0.856627153315983, 0.137318972929847, 0.11189821299995 ),
		vec3( 0.0951212405381588, 0.761241990602591, 0.0767994186031903 ),
		vec3( 0.0482516061458583, 0.101439036467562, 0.811302368396859 )
	);
	const mat3 AgXOutsetMatrix = mat3(
		vec3( 1.1271005818144368, - 0.1413297634984383, - 0.14132976349843826 ),
		vec3( - 0.11060664309660323, 1.157823702216272, - 0.11060664309660294 ),
		vec3( - 0.016493938717834573, - 0.016493938717834257, 1.2519364065950405 )
	);
	const float AgxMinEv = - 12.47393;	const float AgxMaxEv = 4.026069;
	color *= toneMappingExposure;
	color = LINEAR_SRGB_TO_LINEAR_REC2020 * color;
	color = AgXInsetMatrix * color;
	color = max( color, 1e-10 );	color = log2( color );
	color = ( color - AgxMinEv ) / ( AgxMaxEv - AgxMinEv );
	color = clamp( color, 0.0, 1.0 );
	color = agxDefaultContrastApprox( color );
	color = AgXOutsetMatrix * color;
	color = pow( max( vec3( 0.0 ), color ), vec3( 2.2 ) );
	color = LINEAR_REC2020_TO_LINEAR_SRGB * color;
	color = clamp( color, 0.0, 1.0 );
	return color;
}
vec3 NeutralToneMapping( vec3 color ) {
	const float StartCompression = 0.8 - 0.04;
	const float Desaturation = 0.15;
	color *= toneMappingExposure;
	float x = min( color.r, min( color.g, color.b ) );
	float offset = x < 0.08 ? x - 6.25 * x * x : 0.04;
	color -= offset;
	float peak = max( color.r, max( color.g, color.b ) );
	if ( peak < StartCompression ) return color;
	float d = 1. - StartCompression;
	float newPeak = 1. - d * d / ( peak + d - StartCompression );
	color *= newPeak / peak;
	float g = 1. - 1. / ( Desaturation * ( peak - newPeak ) + 1. );
	return mix( color, vec3( newPeak ), g );
}
vec3 CustomToneMapping( vec3 color ) { return color; }`,transmission_fragment:`#ifdef USE_TRANSMISSION
	material.transmission = transmission;
	material.transmissionAlpha = 1.0;
	material.thickness = thickness;
	material.attenuationDistance = attenuationDistance;
	material.attenuationColor = attenuationColor;
	#ifdef USE_TRANSMISSIONMAP
		material.transmission *= texture2D( transmissionMap, vTransmissionMapUv ).r;
	#endif
	#ifdef USE_THICKNESSMAP
		material.thickness *= texture2D( thicknessMap, vThicknessMapUv ).g;
	#endif
	vec3 pos = vWorldPosition;
	vec3 v = normalize( cameraPosition - pos );
	vec3 n = transformNormalByInverseViewMatrix( normal, viewMatrix );
	vec4 transmitted = getIBLVolumeRefraction(
		n, v, material.roughness, material.diffuseContribution, material.specularColorBlended, material.specularF90,
		pos, modelMatrix, viewMatrix, projectionMatrix, material.dispersion, material.ior, material.thickness,
		material.attenuationColor, material.attenuationDistance );
	material.transmissionAlpha = mix( material.transmissionAlpha, transmitted.a, material.transmission );
	totalDiffuse = mix( totalDiffuse, transmitted.rgb, material.transmission );
#endif`,transmission_pars_fragment:`#ifdef USE_TRANSMISSION
	uniform float transmission;
	uniform float thickness;
	uniform float attenuationDistance;
	uniform vec3 attenuationColor;
	#ifdef USE_TRANSMISSIONMAP
		uniform sampler2D transmissionMap;
	#endif
	#ifdef USE_THICKNESSMAP
		uniform sampler2D thicknessMap;
	#endif
	uniform vec2 transmissionSamplerSize;
	uniform sampler2D transmissionSamplerMap;
	uniform mat4 modelMatrix;
	uniform mat4 projectionMatrix;
	varying vec3 vWorldPosition;
	float w0( float a ) {
		return ( 1.0 / 6.0 ) * ( a * ( a * ( - a + 3.0 ) - 3.0 ) + 1.0 );
	}
	float w1( float a ) {
		return ( 1.0 / 6.0 ) * ( a *  a * ( 3.0 * a - 6.0 ) + 4.0 );
	}
	float w2( float a ){
		return ( 1.0 / 6.0 ) * ( a * ( a * ( - 3.0 * a + 3.0 ) + 3.0 ) + 1.0 );
	}
	float w3( float a ) {
		return ( 1.0 / 6.0 ) * ( a * a * a );
	}
	float g0( float a ) {
		return w0( a ) + w1( a );
	}
	float g1( float a ) {
		return w2( a ) + w3( a );
	}
	float h0( float a ) {
		return - 1.0 + w1( a ) / ( w0( a ) + w1( a ) );
	}
	float h1( float a ) {
		return 1.0 + w3( a ) / ( w2( a ) + w3( a ) );
	}
	vec4 bicubic( sampler2D tex, vec2 uv, vec4 texelSize, float lod ) {
		uv = uv * texelSize.zw + 0.5;
		vec2 iuv = floor( uv );
		vec2 fuv = fract( uv );
		float g0x = g0( fuv.x );
		float g1x = g1( fuv.x );
		float h0x = h0( fuv.x );
		float h1x = h1( fuv.x );
		float h0y = h0( fuv.y );
		float h1y = h1( fuv.y );
		vec2 p0 = ( vec2( iuv.x + h0x, iuv.y + h0y ) - 0.5 ) * texelSize.xy;
		vec2 p1 = ( vec2( iuv.x + h1x, iuv.y + h0y ) - 0.5 ) * texelSize.xy;
		vec2 p2 = ( vec2( iuv.x + h0x, iuv.y + h1y ) - 0.5 ) * texelSize.xy;
		vec2 p3 = ( vec2( iuv.x + h1x, iuv.y + h1y ) - 0.5 ) * texelSize.xy;
		return g0( fuv.y ) * ( g0x * textureLod( tex, p0, lod ) + g1x * textureLod( tex, p1, lod ) ) +
			g1( fuv.y ) * ( g0x * textureLod( tex, p2, lod ) + g1x * textureLod( tex, p3, lod ) );
	}
	vec4 textureBicubic( sampler2D sampler, vec2 uv, float lod ) {
		vec2 fLodSize = vec2( textureSize( sampler, int( lod ) ) );
		vec2 cLodSize = vec2( textureSize( sampler, int( lod + 1.0 ) ) );
		vec2 fLodSizeInv = 1.0 / fLodSize;
		vec2 cLodSizeInv = 1.0 / cLodSize;
		vec4 fSample = bicubic( sampler, uv, vec4( fLodSizeInv, fLodSize ), floor( lod ) );
		vec4 cSample = bicubic( sampler, uv, vec4( cLodSizeInv, cLodSize ), ceil( lod ) );
		return mix( fSample, cSample, fract( lod ) );
	}
	vec3 getVolumeTransmissionRay( const in vec3 n, const in vec3 v, const in float thickness, const in float ior, const in mat4 modelMatrix ) {
		vec3 refractionVector = refract( - v, normalize( n ), 1.0 / ior );
		vec3 modelScale;
		modelScale.x = length( vec3( modelMatrix[ 0 ].xyz ) );
		modelScale.y = length( vec3( modelMatrix[ 1 ].xyz ) );
		modelScale.z = length( vec3( modelMatrix[ 2 ].xyz ) );
		return normalize( refractionVector ) * thickness * modelScale;
	}
	float applyIorToRoughness( const in float roughness, const in float ior ) {
		return roughness * clamp( ior * 2.0 - 2.0, 0.0, 1.0 );
	}
	vec4 getTransmissionSample( const in vec2 fragCoord, const in float roughness, const in float ior ) {
		float lod = log2( transmissionSamplerSize.x ) * applyIorToRoughness( roughness, ior );
		return textureBicubic( transmissionSamplerMap, fragCoord.xy, lod );
	}
	vec3 volumeAttenuation( const in float transmissionDistance, const in vec3 attenuationColor, const in float attenuationDistance ) {
		if ( isinf( attenuationDistance ) ) {
			return vec3( 1.0 );
		} else {
			vec3 attenuationCoefficient = -log( attenuationColor ) / attenuationDistance;
			vec3 transmittance = exp( - attenuationCoefficient * transmissionDistance );			return transmittance;
		}
	}
	vec4 getIBLVolumeRefraction( const in vec3 n, const in vec3 v, const in float roughness, const in vec3 diffuseColor,
		const in vec3 specularColor, const in float specularF90, const in vec3 position, const in mat4 modelMatrix,
		const in mat4 viewMatrix, const in mat4 projMatrix, const in float dispersion, const in float ior, const in float thickness,
		const in vec3 attenuationColor, const in float attenuationDistance ) {
		vec4 transmittedLight;
		vec3 transmittance;
		#ifdef USE_DISPERSION
			float halfSpread = ( ior - 1.0 ) * 0.025 * dispersion;
			vec3 iors = vec3( ior - halfSpread, ior, ior + halfSpread );
			for ( int i = 0; i < 3; i ++ ) {
				vec3 transmissionRay = getVolumeTransmissionRay( n, v, thickness, iors[ i ], modelMatrix );
				vec3 refractedRayExit = position + transmissionRay;
				vec4 ndcPos = projMatrix * viewMatrix * vec4( refractedRayExit, 1.0 );
				vec2 refractionCoords = ndcPos.xy / ndcPos.w;
				refractionCoords += 1.0;
				refractionCoords /= 2.0;
				vec4 transmissionSample = getTransmissionSample( refractionCoords, roughness, iors[ i ] );
				transmittedLight[ i ] = transmissionSample[ i ];
				transmittedLight.a += transmissionSample.a;
				transmittance[ i ] = diffuseColor[ i ] * volumeAttenuation( length( transmissionRay ), attenuationColor, attenuationDistance )[ i ];
			}
			transmittedLight.a /= 3.0;
		#else
			vec3 transmissionRay = getVolumeTransmissionRay( n, v, thickness, ior, modelMatrix );
			vec3 refractedRayExit = position + transmissionRay;
			vec4 ndcPos = projMatrix * viewMatrix * vec4( refractedRayExit, 1.0 );
			vec2 refractionCoords = ndcPos.xy / ndcPos.w;
			refractionCoords += 1.0;
			refractionCoords /= 2.0;
			transmittedLight = getTransmissionSample( refractionCoords, roughness, ior );
			transmittance = diffuseColor * volumeAttenuation( length( transmissionRay ), attenuationColor, attenuationDistance );
		#endif
		vec3 attenuatedColor = transmittance * transmittedLight.rgb;
		vec3 F = EnvironmentBRDF( n, v, specularColor, specularF90, roughness );
		float transmittanceFactor = ( transmittance.r + transmittance.g + transmittance.b ) / 3.0;
		return vec4( ( 1.0 - F ) * attenuatedColor, 1.0 - ( 1.0 - transmittedLight.a ) * transmittanceFactor );
	}
#endif`,uv_pars_fragment:`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
	varying vec2 vUv;
#endif
#ifdef USE_MAP
	varying vec2 vMapUv;
#endif
#ifdef USE_ALPHAMAP
	varying vec2 vAlphaMapUv;
#endif
#ifdef USE_LIGHTMAP
	varying vec2 vLightMapUv;
#endif
#ifdef USE_AOMAP
	varying vec2 vAoMapUv;
#endif
#ifdef USE_BUMPMAP
	varying vec2 vBumpMapUv;
#endif
#ifdef USE_NORMALMAP
	varying vec2 vNormalMapUv;
#endif
#ifdef USE_EMISSIVEMAP
	varying vec2 vEmissiveMapUv;
#endif
#ifdef USE_METALNESSMAP
	varying vec2 vMetalnessMapUv;
#endif
#ifdef USE_ROUGHNESSMAP
	varying vec2 vRoughnessMapUv;
#endif
#ifdef USE_ANISOTROPYMAP
	varying vec2 vAnisotropyMapUv;
#endif
#ifdef USE_CLEARCOATMAP
	varying vec2 vClearcoatMapUv;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	varying vec2 vClearcoatNormalMapUv;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	varying vec2 vClearcoatRoughnessMapUv;
#endif
#ifdef USE_IRIDESCENCEMAP
	varying vec2 vIridescenceMapUv;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	varying vec2 vIridescenceThicknessMapUv;
#endif
#ifdef USE_SHEEN_COLORMAP
	varying vec2 vSheenColorMapUv;
#endif
#ifdef USE_SHEEN_ROUGHNESSMAP
	varying vec2 vSheenRoughnessMapUv;
#endif
#ifdef USE_SPECULARMAP
	varying vec2 vSpecularMapUv;
#endif
#ifdef USE_SPECULAR_COLORMAP
	varying vec2 vSpecularColorMapUv;
#endif
#ifdef USE_SPECULAR_INTENSITYMAP
	varying vec2 vSpecularIntensityMapUv;
#endif
#ifdef USE_TRANSMISSIONMAP
	uniform mat3 transmissionMapTransform;
	varying vec2 vTransmissionMapUv;
#endif
#ifdef USE_THICKNESSMAP
	uniform mat3 thicknessMapTransform;
	varying vec2 vThicknessMapUv;
#endif`,uv_pars_vertex:`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
	varying vec2 vUv;
#endif
#ifdef USE_MAP
	uniform mat3 mapTransform;
	varying vec2 vMapUv;
#endif
#ifdef USE_ALPHAMAP
	uniform mat3 alphaMapTransform;
	varying vec2 vAlphaMapUv;
#endif
#ifdef USE_LIGHTMAP
	uniform mat3 lightMapTransform;
	varying vec2 vLightMapUv;
#endif
#ifdef USE_AOMAP
	uniform mat3 aoMapTransform;
	varying vec2 vAoMapUv;
#endif
#ifdef USE_BUMPMAP
	uniform mat3 bumpMapTransform;
	varying vec2 vBumpMapUv;
#endif
#ifdef USE_NORMALMAP
	uniform mat3 normalMapTransform;
	varying vec2 vNormalMapUv;
#endif
#ifdef USE_DISPLACEMENTMAP
	uniform mat3 displacementMapTransform;
	varying vec2 vDisplacementMapUv;
#endif
#ifdef USE_EMISSIVEMAP
	uniform mat3 emissiveMapTransform;
	varying vec2 vEmissiveMapUv;
#endif
#ifdef USE_METALNESSMAP
	uniform mat3 metalnessMapTransform;
	varying vec2 vMetalnessMapUv;
#endif
#ifdef USE_ROUGHNESSMAP
	uniform mat3 roughnessMapTransform;
	varying vec2 vRoughnessMapUv;
#endif
#ifdef USE_ANISOTROPYMAP
	uniform mat3 anisotropyMapTransform;
	varying vec2 vAnisotropyMapUv;
#endif
#ifdef USE_CLEARCOATMAP
	uniform mat3 clearcoatMapTransform;
	varying vec2 vClearcoatMapUv;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	uniform mat3 clearcoatNormalMapTransform;
	varying vec2 vClearcoatNormalMapUv;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	uniform mat3 clearcoatRoughnessMapTransform;
	varying vec2 vClearcoatRoughnessMapUv;
#endif
#ifdef USE_SHEEN_COLORMAP
	uniform mat3 sheenColorMapTransform;
	varying vec2 vSheenColorMapUv;
#endif
#ifdef USE_SHEEN_ROUGHNESSMAP
	uniform mat3 sheenRoughnessMapTransform;
	varying vec2 vSheenRoughnessMapUv;
#endif
#ifdef USE_IRIDESCENCEMAP
	uniform mat3 iridescenceMapTransform;
	varying vec2 vIridescenceMapUv;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	uniform mat3 iridescenceThicknessMapTransform;
	varying vec2 vIridescenceThicknessMapUv;
#endif
#ifdef USE_SPECULARMAP
	uniform mat3 specularMapTransform;
	varying vec2 vSpecularMapUv;
#endif
#ifdef USE_SPECULAR_COLORMAP
	uniform mat3 specularColorMapTransform;
	varying vec2 vSpecularColorMapUv;
#endif
#ifdef USE_SPECULAR_INTENSITYMAP
	uniform mat3 specularIntensityMapTransform;
	varying vec2 vSpecularIntensityMapUv;
#endif
#ifdef USE_TRANSMISSIONMAP
	uniform mat3 transmissionMapTransform;
	varying vec2 vTransmissionMapUv;
#endif
#ifdef USE_THICKNESSMAP
	uniform mat3 thicknessMapTransform;
	varying vec2 vThicknessMapUv;
#endif`,uv_vertex:`#if defined( USE_UV ) || defined( USE_ANISOTROPY )
	vUv = vec3( uv, 1 ).xy;
#endif
#ifdef USE_MAP
	vMapUv = ( mapTransform * vec3( MAP_UV, 1 ) ).xy;
#endif
#ifdef USE_ALPHAMAP
	vAlphaMapUv = ( alphaMapTransform * vec3( ALPHAMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_LIGHTMAP
	vLightMapUv = ( lightMapTransform * vec3( LIGHTMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_AOMAP
	vAoMapUv = ( aoMapTransform * vec3( AOMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_BUMPMAP
	vBumpMapUv = ( bumpMapTransform * vec3( BUMPMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_NORMALMAP
	vNormalMapUv = ( normalMapTransform * vec3( NORMALMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_DISPLACEMENTMAP
	vDisplacementMapUv = ( displacementMapTransform * vec3( DISPLACEMENTMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_EMISSIVEMAP
	vEmissiveMapUv = ( emissiveMapTransform * vec3( EMISSIVEMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_METALNESSMAP
	vMetalnessMapUv = ( metalnessMapTransform * vec3( METALNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_ROUGHNESSMAP
	vRoughnessMapUv = ( roughnessMapTransform * vec3( ROUGHNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_ANISOTROPYMAP
	vAnisotropyMapUv = ( anisotropyMapTransform * vec3( ANISOTROPYMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_CLEARCOATMAP
	vClearcoatMapUv = ( clearcoatMapTransform * vec3( CLEARCOATMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	vClearcoatNormalMapUv = ( clearcoatNormalMapTransform * vec3( CLEARCOAT_NORMALMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
	vClearcoatRoughnessMapUv = ( clearcoatRoughnessMapTransform * vec3( CLEARCOAT_ROUGHNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_IRIDESCENCEMAP
	vIridescenceMapUv = ( iridescenceMapTransform * vec3( IRIDESCENCEMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
	vIridescenceThicknessMapUv = ( iridescenceThicknessMapTransform * vec3( IRIDESCENCE_THICKNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SHEEN_COLORMAP
	vSheenColorMapUv = ( sheenColorMapTransform * vec3( SHEEN_COLORMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SHEEN_ROUGHNESSMAP
	vSheenRoughnessMapUv = ( sheenRoughnessMapTransform * vec3( SHEEN_ROUGHNESSMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SPECULARMAP
	vSpecularMapUv = ( specularMapTransform * vec3( SPECULARMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SPECULAR_COLORMAP
	vSpecularColorMapUv = ( specularColorMapTransform * vec3( SPECULAR_COLORMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_SPECULAR_INTENSITYMAP
	vSpecularIntensityMapUv = ( specularIntensityMapTransform * vec3( SPECULAR_INTENSITYMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_TRANSMISSIONMAP
	vTransmissionMapUv = ( transmissionMapTransform * vec3( TRANSMISSIONMAP_UV, 1 ) ).xy;
#endif
#ifdef USE_THICKNESSMAP
	vThicknessMapUv = ( thicknessMapTransform * vec3( THICKNESSMAP_UV, 1 ) ).xy;
#endif`,worldpos_vertex:`#if defined( USE_ENVMAP ) || defined( DISTANCE ) || defined ( USE_SHADOWMAP ) || defined ( USE_TRANSMISSION ) || NUM_SPOT_LIGHT_COORDS > 0
	vec4 worldPosition = vec4( transformed, 1.0 );
	#ifdef USE_BATCHING
		worldPosition = batchingMatrix * worldPosition;
	#endif
	#ifdef USE_INSTANCING
		worldPosition = instanceMatrix * worldPosition;
	#endif
	worldPosition = modelMatrix * worldPosition;
#endif`,background_vert:`varying vec2 vUv;
uniform mat3 uvTransform;
void main() {
	vUv = ( uvTransform * vec3( uv, 1 ) ).xy;
	gl_Position = vec4( position.xy, 1.0, 1.0 );
}`,background_frag:`uniform sampler2D t2D;
uniform float backgroundIntensity;
varying vec2 vUv;
void main() {
	vec4 texColor = texture2D( t2D, vUv );
	#ifdef DECODE_VIDEO_TEXTURE
		texColor = vec4( mix( pow( texColor.rgb * 0.9478672986 + vec3( 0.0521327014 ), vec3( 2.4 ) ), texColor.rgb * 0.0773993808, vec3( lessThanEqual( texColor.rgb, vec3( 0.04045 ) ) ) ), texColor.w );
	#endif
	texColor.rgb *= backgroundIntensity;
	gl_FragColor = texColor;
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,backgroundCube_vert:`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
	gl_Position.z = gl_Position.w;
}`,backgroundCube_frag:`#ifdef ENVMAP_TYPE_CUBE
	uniform samplerCube envMap;
#elif defined( ENVMAP_TYPE_CUBE_UV )
	uniform sampler2D envMap;
#endif
uniform float backgroundBlurriness;
uniform float backgroundIntensity;
uniform mat3 backgroundRotation;
varying vec3 vWorldDirection;
#include <cube_uv_reflection_fragment>
void main() {
	#ifdef ENVMAP_TYPE_CUBE
		vec4 texColor = textureCube( envMap, backgroundRotation * vWorldDirection );
	#elif defined( ENVMAP_TYPE_CUBE_UV )
		vec4 texColor = textureCubeUV( envMap, backgroundRotation * vWorldDirection, backgroundBlurriness );
	#else
		vec4 texColor = vec4( 0.0, 0.0, 0.0, 1.0 );
	#endif
	texColor.rgb *= backgroundIntensity;
	gl_FragColor = texColor;
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,cube_vert:`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
	gl_Position.z = gl_Position.w;
}`,cube_frag:`uniform samplerCube tCube;
uniform float tFlip;
uniform float opacity;
varying vec3 vWorldDirection;
void main() {
	vec4 texColor = textureCube( tCube, vec3( tFlip * vWorldDirection.x, vWorldDirection.yz ) );
	gl_FragColor = texColor;
	gl_FragColor.a *= opacity;
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,depth_vert:`#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
varying vec2 vHighPrecisionZW;
void main() {
	#include <uv_vertex>
	#include <batching_vertex>
	#include <skinbase_vertex>
	#include <morphinstance_vertex>
	#ifdef USE_DISPLACEMENTMAP
		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinnormal_vertex>
	#endif
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vHighPrecisionZW = gl_Position.zw;
}`,depth_frag:`#if DEPTH_PACKING == 3200
	uniform float opacity;
#endif
#include <common>
#include <packing>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
varying vec2 vHighPrecisionZW;
void main() {
	vec4 diffuseColor = vec4( 1.0 );
	#include <clipping_planes_fragment>
	#if DEPTH_PACKING == 3200
		diffuseColor.a = opacity;
	#endif
	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <logdepthbuf_fragment>
	#ifdef USE_REVERSED_DEPTH_BUFFER
		float fragCoordZ = vHighPrecisionZW[ 0 ] / vHighPrecisionZW[ 1 ];
	#else
		float fragCoordZ = 0.5 * vHighPrecisionZW[ 0 ] / vHighPrecisionZW[ 1 ] + 0.5;
	#endif
	#if DEPTH_PACKING == 3200
		gl_FragColor = vec4( vec3( 1.0 - fragCoordZ ), opacity );
	#elif DEPTH_PACKING == 3201
		gl_FragColor = packDepthToRGBA( fragCoordZ );
	#elif DEPTH_PACKING == 3202
		gl_FragColor = vec4( packDepthToRGB( fragCoordZ ), 1.0 );
	#elif DEPTH_PACKING == 3203
		gl_FragColor = vec4( packDepthToRG( fragCoordZ ), 0.0, 1.0 );
	#endif
}`,distance_vert:`#define DISTANCE
varying vec3 vWorldPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <batching_vertex>
	#include <skinbase_vertex>
	#include <morphinstance_vertex>
	#ifdef USE_DISPLACEMENTMAP
		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinnormal_vertex>
	#endif
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <worldpos_vertex>
	#include <clipping_planes_vertex>
	vWorldPosition = worldPosition.xyz;
}`,distance_frag:`#define DISTANCE
uniform vec3 referencePosition;
uniform float nearDistance;
uniform float farDistance;
varying vec3 vWorldPosition;
#include <common>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( 1.0 );
	#include <clipping_planes_fragment>
	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	float dist = length( vWorldPosition - referencePosition );
	dist = ( dist - nearDistance ) / ( farDistance - nearDistance );
	dist = saturate( dist );
	gl_FragColor = vec4( dist, 0.0, 0.0, 1.0 );
}`,equirect_vert:`varying vec3 vWorldDirection;
#include <common>
void main() {
	vWorldDirection = transformDirection( position, modelMatrix );
	#include <begin_vertex>
	#include <project_vertex>
}`,equirect_frag:`uniform sampler2D tEquirect;
varying vec3 vWorldDirection;
#include <common>
void main() {
	vec3 direction = normalize( vWorldDirection );
	vec2 sampleUV = equirectUv( direction );
	gl_FragColor = texture2D( tEquirect, sampleUV );
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
}`,linedashed_vert:`uniform float scale;
attribute float lineDistance;
varying float vLineDistance;
#include <common>
#include <uv_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	vLineDistance = scale * lineDistance;
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>
}`,linedashed_frag:`uniform vec3 diffuse;
uniform float opacity;
uniform float dashSize;
uniform float totalSize;
varying float vLineDistance;
#include <common>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	if ( mod( vLineDistance, totalSize ) > dashSize ) {
		discard;
	}
	vec3 outgoingLight = vec3( 0.0 );
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	outgoingLight = diffuseColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
}`,meshbasic_vert:`#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#if defined ( USE_ENVMAP ) || defined ( USE_SKINNING )
		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinbase_vertex>
		#include <skinnormal_vertex>
		#include <defaultnormal_vertex>
	#endif
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <fog_vertex>
}`,meshbasic_frag:`uniform vec3 diffuse;
uniform float opacity;
#ifndef FLAT_SHADED
	varying vec3 vNormal;
#endif
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_pars_fragment>
#include <fog_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <specularmap_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	#ifdef USE_LIGHTMAP
		vec4 lightMapTexel = texture2D( lightMap, vLightMapUv );
		reflectedLight.indirectDiffuse += lightMapTexel.rgb * lightMapIntensity * RECIPROCAL_PI;
	#else
		reflectedLight.indirectDiffuse += vec3( 1.0 );
	#endif
	#include <aomap_fragment>
	reflectedLight.indirectDiffuse *= diffuseColor.rgb;
	vec3 outgoingLight = reflectedLight.indirectDiffuse;
	#include <envmap_fragment>
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,meshlambert_vert:`#define LAMBERT
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,meshlambert_frag:`#define LAMBERT
uniform vec3 diffuse;
uniform vec3 emissive;
uniform float opacity;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <cube_uv_reflection_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_pars_fragment>
#include <envmap_physical_pars_fragment>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_lambert_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <specularmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_lambert_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + totalEmissiveRadiance;
	#include <envmap_fragment>
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,meshmatcap_vert:`#define MATCAP
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <color_pars_vertex>
#include <displacementmap_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>
	vViewPosition = - mvPosition.xyz;
}`,meshmatcap_frag:`#define MATCAP
uniform vec3 diffuse;
uniform float opacity;
uniform sampler2D matcap;
varying vec3 vViewPosition;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <fog_pars_fragment>
#include <normal_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	vec3 viewDir = normalize( vViewPosition );
	vec3 x = normalize( vec3( viewDir.z, 0.0, - viewDir.x ) );
	vec3 y = cross( viewDir, x );
	vec2 uv = vec2( dot( x, normal ), dot( y, normal ) ) * 0.495 + 0.5;
	#ifdef USE_MATCAP
		vec4 matcapColor = texture2D( matcap, uv );
	#else
		vec4 matcapColor = vec4( vec3( mix( 0.2, 0.8, uv.y ) ), 1.0 );
	#endif
	vec3 outgoingLight = diffuseColor.rgb * matcapColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,meshnormal_vert:`#define NORMAL
#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP_TANGENTSPACE )
	varying vec3 vViewPosition;
#endif
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphinstance_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP_TANGENTSPACE )
	vViewPosition = - mvPosition.xyz;
#endif
}`,meshnormal_frag:`#define NORMAL
uniform float opacity;
#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP_TANGENTSPACE )
	varying vec3 vViewPosition;
#endif
#include <uv_pars_fragment>
#include <normal_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( 0.0, 0.0, 0.0, opacity );
	#include <clipping_planes_fragment>
	#include <logdepthbuf_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	gl_FragColor = vec4( normalize( normal ) * 0.5 + 0.5, diffuseColor.a );
	#ifdef OPAQUE
		gl_FragColor.a = 1.0;
	#endif
}`,meshphong_vert:`#define PHONG
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphinstance_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,meshphong_frag:`#define PHONG
uniform vec3 diffuse;
uniform vec3 emissive;
uniform vec3 specular;
uniform float shininess;
uniform float opacity;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <cube_uv_reflection_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_pars_fragment>
#include <envmap_physical_pars_fragment>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_phong_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <specularmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_phong_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + reflectedLight.directSpecular + reflectedLight.indirectSpecular + totalEmissiveRadiance;
	#include <envmap_fragment>
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,meshphysical_vert:`#define STANDARD
varying vec3 vViewPosition;
#ifdef USE_TRANSMISSION
	varying vec3 vWorldPosition;
#endif
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
#ifdef USE_TRANSMISSION
	vWorldPosition = worldPosition.xyz;
#endif
}`,meshphysical_frag:`#define STANDARD
#ifdef PHYSICAL
	#define IOR
	#define USE_SPECULAR
#endif
uniform vec3 diffuse;
uniform vec3 emissive;
uniform float roughness;
uniform float metalness;
uniform float opacity;
#ifdef IOR
	uniform float ior;
#endif
#ifdef USE_SPECULAR
	uniform float specularIntensity;
	uniform vec3 specularColor;
	#ifdef USE_SPECULAR_COLORMAP
		uniform sampler2D specularColorMap;
	#endif
	#ifdef USE_SPECULAR_INTENSITYMAP
		uniform sampler2D specularIntensityMap;
	#endif
#endif
#ifdef USE_CLEARCOAT
	uniform float clearcoat;
	uniform float clearcoatRoughness;
#endif
#ifdef USE_DISPERSION
	uniform float dispersion;
#endif
#ifdef USE_IRIDESCENCE
	uniform float iridescence;
	uniform float iridescenceIOR;
	uniform float iridescenceThicknessMinimum;
	uniform float iridescenceThicknessMaximum;
#endif
#ifdef USE_SHEEN
	uniform vec3 sheenColor;
	uniform float sheenRoughness;
	#ifdef USE_SHEEN_COLORMAP
		uniform sampler2D sheenColorMap;
	#endif
	#ifdef USE_SHEEN_ROUGHNESSMAP
		uniform sampler2D sheenRoughnessMap;
	#endif
#endif
#ifdef USE_ANISOTROPY
	uniform vec2 anisotropyVector;
	#ifdef USE_ANISOTROPYMAP
		uniform sampler2D anisotropyMap;
	#endif
#endif
varying vec3 vViewPosition;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <iridescence_fragment>
#include <cube_uv_reflection_fragment>
#include <envmap_common_pars_fragment>
#include <envmap_physical_pars_fragment>
#include <fog_pars_fragment>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_physical_pars_fragment>
#include <transmission_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <clearcoat_pars_fragment>
#include <iridescence_pars_fragment>
#include <roughnessmap_pars_fragment>
#include <metalnessmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <roughnessmap_fragment>
	#include <metalnessmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <clearcoat_normal_fragment_begin>
	#include <clearcoat_normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_physical_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 totalDiffuse = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse;
	vec3 totalSpecular = reflectedLight.directSpecular + reflectedLight.indirectSpecular;
	#include <transmission_fragment>
	vec3 outgoingLight = totalDiffuse + totalSpecular + totalEmissiveRadiance;
	#ifdef USE_SHEEN
 
		outgoingLight = outgoingLight + sheenSpecularDirect + sheenSpecularIndirect;
 
 	#endif
	#ifdef USE_CLEARCOAT
		float dotNVcc = saturate( dot( geometryClearcoatNormal, geometryViewDir ) );
		vec3 Fcc = F_Schlick( material.clearcoatF0, material.clearcoatF90, dotNVcc );
		outgoingLight = outgoingLight * ( 1.0 - material.clearcoat * Fcc ) + ( clearcoatSpecularDirect + clearcoatSpecularIndirect ) * material.clearcoat;
	#endif
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,meshtoon_vert:`#define TOON
varying vec3 vViewPosition;
#include <common>
#include <batching_pars_vertex>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <normal_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <normal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	vViewPosition = - mvPosition.xyz;
	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,meshtoon_frag:`#define TOON
uniform vec3 diffuse;
uniform vec3 emissive;
uniform float opacity;
#include <common>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <gradientmap_pars_fragment>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <normal_pars_fragment>
#include <lights_toon_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>
	#include <lights_toon_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>
	#include <aomap_fragment>
	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + totalEmissiveRadiance;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}`,points_vert:`uniform float size;
uniform float scale;
#include <common>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
#ifdef USE_POINTS_UV
	varying vec2 vUv;
	uniform mat3 uvTransform;
#endif
void main() {
	#ifdef USE_POINTS_UV
		vUv = ( uvTransform * vec3( uv, 1 ) ).xy;
	#endif
	#include <color_vertex>
	#include <morphinstance_vertex>
	#include <morphcolor_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <project_vertex>
	gl_PointSize = size;
	#ifdef USE_SIZEATTENUATION
		bool isPerspective = isPerspectiveMatrix( projectionMatrix );
		if ( isPerspective ) gl_PointSize *= ( scale / - mvPosition.z );
	#endif
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <worldpos_vertex>
	#include <fog_vertex>
}`,points_frag:`uniform vec3 diffuse;
uniform float opacity;
#include <common>
#include <color_pars_fragment>
#include <map_particle_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	vec3 outgoingLight = vec3( 0.0 );
	#include <logdepthbuf_fragment>
	#include <map_particle_fragment>
	#include <color_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	outgoingLight = diffuseColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
}`,shadow_vert:`#include <common>
#include <batching_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <shadowmap_pars_vertex>
void main() {
	#include <batching_vertex>
	#include <beginnormal_vertex>
	#include <morphinstance_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>
}`,shadow_frag:`uniform vec3 color;
uniform float opacity;
#include <common>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <logdepthbuf_pars_fragment>
#include <shadowmap_pars_fragment>
#include <shadowmask_pars_fragment>
void main() {
	#include <logdepthbuf_fragment>
	gl_FragColor = vec4( color, opacity * ( 1.0 - getShadowMask() ) );
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
}`,sprite_vert:`uniform float rotation;
uniform vec2 center;
#include <common>
#include <uv_pars_vertex>
#include <fog_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>
void main() {
	#include <uv_vertex>
	vec4 mvPosition = modelViewMatrix[ 3 ];
	vec2 scale = vec2( length( modelMatrix[ 0 ].xyz ), length( modelMatrix[ 1 ].xyz ) );
	#ifndef USE_SIZEATTENUATION
		bool isPerspective = isPerspectiveMatrix( projectionMatrix );
		if ( isPerspective ) scale *= - mvPosition.z;
	#endif
	vec2 alignedPosition = ( position.xy - ( center - vec2( 0.5 ) ) ) * scale;
	vec2 rotatedPosition;
	rotatedPosition.x = cos( rotation ) * alignedPosition.x - sin( rotation ) * alignedPosition.y;
	rotatedPosition.y = sin( rotation ) * alignedPosition.x + cos( rotation ) * alignedPosition.y;
	mvPosition.xy += rotatedPosition;
	gl_Position = projectionMatrix * mvPosition;
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>
}`,sprite_frag:`uniform vec3 diffuse;
uniform float opacity;
#include <common>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <alphatest_pars_fragment>
#include <alphahash_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	vec4 diffuseColor = vec4( diffuse, opacity );
	#include <clipping_planes_fragment>
	vec3 outgoingLight = vec3( 0.0 );
	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <alphahash_fragment>
	outgoingLight = diffuseColor.rgb;
	#include <opaque_fragment>
	#include <tonemapping_fragment>
	#include <colorspace_fragment>
	#include <fog_fragment>
}`},ce={common:{diffuse:{value:new Ie(16777215)},opacity:{value:1},map:{value:null},mapTransform:{value:new Ne},alphaMap:{value:null},alphaMapTransform:{value:new Ne},alphaTest:{value:0}},specularmap:{specularMap:{value:null},specularMapTransform:{value:new Ne}},envmap:{envMap:{value:null},envMapRotation:{value:new Ne},reflectivity:{value:1},ior:{value:1.5},refractionRatio:{value:.98},dfgLUT:{value:null}},aomap:{aoMap:{value:null},aoMapIntensity:{value:1},aoMapTransform:{value:new Ne}},lightmap:{lightMap:{value:null},lightMapIntensity:{value:1},lightMapTransform:{value:new Ne}},bumpmap:{bumpMap:{value:null},bumpMapTransform:{value:new Ne},bumpScale:{value:1}},normalmap:{normalMap:{value:null},normalMapTransform:{value:new Ne},normalScale:{value:new te(1,1)}},displacementmap:{displacementMap:{value:null},displacementMapTransform:{value:new Ne},displacementScale:{value:1},displacementBias:{value:0}},emissivemap:{emissiveMap:{value:null},emissiveMapTransform:{value:new Ne}},metalnessmap:{metalnessMap:{value:null},metalnessMapTransform:{value:new Ne}},roughnessmap:{roughnessMap:{value:null},roughnessMapTransform:{value:new Ne}},gradientmap:{gradientMap:{value:null}},fog:{fogDensity:{value:25e-5},fogNear:{value:1},fogFar:{value:2e3},fogColor:{value:new Ie(16777215)}},lights:{ambientLightColor:{value:[]},lightProbe:{value:[]},directionalLights:{value:[],properties:{direction:{},color:{}}},directionalLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{}}},directionalShadowMatrix:{value:[]},spotLights:{value:[],properties:{color:{},position:{},direction:{},distance:{},coneCos:{},penumbraCos:{},decay:{}}},spotLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{}}},spotLightMap:{value:[]},spotLightMatrix:{value:[]},pointLights:{value:[],properties:{color:{},position:{},decay:{},distance:{}}},pointLightShadows:{value:[],properties:{shadowIntensity:1,shadowBias:{},shadowNormalBias:{},shadowRadius:{},shadowMapSize:{},shadowCameraNear:{},shadowCameraFar:{}}},pointShadowMatrix:{value:[]},hemisphereLights:{value:[],properties:{direction:{},skyColor:{},groundColor:{}}},rectAreaLights:{value:[],properties:{color:{},position:{},width:{},height:{}}},ltc_1:{value:null},ltc_2:{value:null},probesSH:{value:null},probesMin:{value:new w},probesMax:{value:new w},probesResolution:{value:new w}},points:{diffuse:{value:new Ie(16777215)},opacity:{value:1},size:{value:1},scale:{value:1},map:{value:null},alphaMap:{value:null},alphaMapTransform:{value:new Ne},alphaTest:{value:0},uvTransform:{value:new Ne}},sprite:{diffuse:{value:new Ie(16777215)},opacity:{value:1},center:{value:new te(.5,.5)},rotation:{value:0},map:{value:null},mapTransform:{value:new Ne},alphaMap:{value:null},alphaMapTransform:{value:new Ne},alphaTest:{value:0}}},Di={basic:{uniforms:Ut([ce.common,ce.specularmap,ce.envmap,ce.aomap,ce.lightmap,ce.fog]),vertexShader:Be.meshbasic_vert,fragmentShader:Be.meshbasic_frag},lambert:{uniforms:Ut([ce.common,ce.specularmap,ce.envmap,ce.aomap,ce.lightmap,ce.emissivemap,ce.bumpmap,ce.normalmap,ce.displacementmap,ce.fog,ce.lights,{emissive:{value:new Ie(0)},envMapIntensity:{value:1}}]),vertexShader:Be.meshlambert_vert,fragmentShader:Be.meshlambert_frag},phong:{uniforms:Ut([ce.common,ce.specularmap,ce.envmap,ce.aomap,ce.lightmap,ce.emissivemap,ce.bumpmap,ce.normalmap,ce.displacementmap,ce.fog,ce.lights,{emissive:{value:new Ie(0)},specular:{value:new Ie(1118481)},shininess:{value:30},envMapIntensity:{value:1}}]),vertexShader:Be.meshphong_vert,fragmentShader:Be.meshphong_frag},standard:{uniforms:Ut([ce.common,ce.envmap,ce.aomap,ce.lightmap,ce.emissivemap,ce.bumpmap,ce.normalmap,ce.displacementmap,ce.roughnessmap,ce.metalnessmap,ce.fog,ce.lights,{emissive:{value:new Ie(0)},roughness:{value:1},metalness:{value:0},envMapIntensity:{value:1}}]),vertexShader:Be.meshphysical_vert,fragmentShader:Be.meshphysical_frag},toon:{uniforms:Ut([ce.common,ce.aomap,ce.lightmap,ce.emissivemap,ce.bumpmap,ce.normalmap,ce.displacementmap,ce.gradientmap,ce.fog,ce.lights,{emissive:{value:new Ie(0)}}]),vertexShader:Be.meshtoon_vert,fragmentShader:Be.meshtoon_frag},matcap:{uniforms:Ut([ce.common,ce.bumpmap,ce.normalmap,ce.displacementmap,ce.fog,{matcap:{value:null}}]),vertexShader:Be.meshmatcap_vert,fragmentShader:Be.meshmatcap_frag},points:{uniforms:Ut([ce.points,ce.fog]),vertexShader:Be.points_vert,fragmentShader:Be.points_frag},dashed:{uniforms:Ut([ce.common,ce.fog,{scale:{value:1},dashSize:{value:1},totalSize:{value:2}}]),vertexShader:Be.linedashed_vert,fragmentShader:Be.linedashed_frag},depth:{uniforms:Ut([ce.common,ce.displacementmap]),vertexShader:Be.depth_vert,fragmentShader:Be.depth_frag},normal:{uniforms:Ut([ce.common,ce.bumpmap,ce.normalmap,ce.displacementmap,{opacity:{value:1}}]),vertexShader:Be.meshnormal_vert,fragmentShader:Be.meshnormal_frag},sprite:{uniforms:Ut([ce.sprite,ce.fog]),vertexShader:Be.sprite_vert,fragmentShader:Be.sprite_frag},background:{uniforms:{uvTransform:{value:new Ne},t2D:{value:null},backgroundIntensity:{value:1}},vertexShader:Be.background_vert,fragmentShader:Be.background_frag},backgroundCube:{uniforms:{envMap:{value:null},backgroundBlurriness:{value:0},backgroundIntensity:{value:1},backgroundRotation:{value:new Ne}},vertexShader:Be.backgroundCube_vert,fragmentShader:Be.backgroundCube_frag},cube:{uniforms:{tCube:{value:null},tFlip:{value:-1},opacity:{value:1}},vertexShader:Be.cube_vert,fragmentShader:Be.cube_frag},equirect:{uniforms:{tEquirect:{value:null}},vertexShader:Be.equirect_vert,fragmentShader:Be.equirect_frag},distance:{uniforms:Ut([ce.common,ce.displacementmap,{referencePosition:{value:new w},nearDistance:{value:1},farDistance:{value:1e3}}]),vertexShader:Be.distance_vert,fragmentShader:Be.distance_frag},shadow:{uniforms:Ut([ce.lights,ce.fog,{color:{value:new Ie(0)},opacity:{value:1}}]),vertexShader:Be.shadow_vert,fragmentShader:Be.shadow_frag}};Di.physical={uniforms:Ut([Di.standard.uniforms,{clearcoat:{value:0},clearcoatMap:{value:null},clearcoatMapTransform:{value:new Ne},clearcoatNormalMap:{value:null},clearcoatNormalMapTransform:{value:new Ne},clearcoatNormalScale:{value:new te(1,1)},clearcoatRoughness:{value:0},clearcoatRoughnessMap:{value:null},clearcoatRoughnessMapTransform:{value:new Ne},dispersion:{value:0},iridescence:{value:0},iridescenceMap:{value:null},iridescenceMapTransform:{value:new Ne},iridescenceIOR:{value:1.3},iridescenceThicknessMinimum:{value:100},iridescenceThicknessMaximum:{value:400},iridescenceThicknessMap:{value:null},iridescenceThicknessMapTransform:{value:new Ne},sheen:{value:0},sheenColor:{value:new Ie(0)},sheenColorMap:{value:null},sheenColorMapTransform:{value:new Ne},sheenRoughness:{value:1},sheenRoughnessMap:{value:null},sheenRoughnessMapTransform:{value:new Ne},transmission:{value:0},transmissionMap:{value:null},transmissionMapTransform:{value:new Ne},transmissionSamplerSize:{value:new te},transmissionSamplerMap:{value:null},thickness:{value:0},thicknessMap:{value:null},thicknessMapTransform:{value:new Ne},attenuationDistance:{value:0},attenuationColor:{value:new Ie(0)},specularColor:{value:new Ie(1,1,1)},specularColorMap:{value:null},specularColorMapTransform:{value:new Ne},specularIntensity:{value:1},specularIntensityMap:{value:null},specularIntensityMapTransform:{value:new Ne},anisotropyVector:{value:new te},anisotropyMap:{value:null},anisotropyMapTransform:{value:new Ne}}]),vertexShader:Be.meshphysical_vert,fragmentShader:Be.meshphysical_frag};var Uo={r:0,b:0,g:0},um=new Fe,Zd=new Ne;function dm(r,e,t,i,n,s){let a=new Ie(0),o,c,l=n===!0?0:1,h=null,d=0,p=null;function u(m){let v=m.isScene===!0?m.background:null;if(v&&v.isTexture){let f=m.backgroundBlurriness>0;v=e.get(v,f)}return v}function g(m,v){m.getRGB(Uo,Qc(r)),t.buffers.color.setClear(Uo.r,Uo.g,Uo.b,v,s)}return{getClearColor:function(){return a},setClearColor:function(m,v=1){a.set(m),l=v,g(a,l)},getClearAlpha:function(){return l},setClearAlpha:function(m){l=m,g(a,l)},render:function(m){let v=!1,f=u(m);f===null?g(a,l):f&&f.isColor&&(g(f,1),v=!0);let _=r.xr.getEnvironmentBlendMode();_==="additive"?t.buffers.color.setClear(0,0,0,1,s):_==="alpha-blend"&&t.buffers.color.setClear(0,0,0,0,s),(r.autoClear||v)&&(t.buffers.depth.setTest(!0),t.buffers.depth.setMask(!0),t.buffers.color.setMask(!0),r.clear(r.autoClearColor,r.autoClearDepth,r.autoClearStencil))},addToRenderList:function(m,v){let f=u(v);f&&(f.isCubeTexture||f.mapping===Ds)?(c===void 0&&(c=new Oe(new qt(1,1,1),new zt({name:"BackgroundCubeMaterial",uniforms:Gn(Di.backgroundCube.uniforms),vertexShader:Di.backgroundCube.vertexShader,fragmentShader:Di.backgroundCube.fragmentShader,side:Gt,depthTest:!1,depthWrite:!1,fog:!1,allowOverride:!1})),c.geometry.deleteAttribute("normal"),c.geometry.deleteAttribute("uv"),c.onBeforeRender=function(_,x,S){this.matrixWorld.copyPosition(S.matrixWorld)},Object.defineProperty(c.material,"envMap",{get:function(){return this.uniforms.envMap.value}}),i.update(c)),c.material.uniforms.envMap.value=f,c.material.uniforms.backgroundBlurriness.value=v.backgroundBlurriness,c.material.uniforms.backgroundIntensity.value=v.backgroundIntensity,c.material.uniforms.backgroundRotation.value.setFromMatrix4(um.makeRotationFromEuler(v.backgroundRotation)).transpose(),f.isCubeTexture&&f.isRenderTargetTexture===!1&&c.material.uniforms.backgroundRotation.value.premultiply(Zd),c.material.toneMapped=He.getTransfer(f.colorSpace)!==Ze,h===f&&d===f.version&&p===r.toneMapping||(c.material.needsUpdate=!0,h=f,d=f.version,p=r.toneMapping),c.layers.enableAll(),m.unshift(c,c.geometry,c.material,0,0,null)):f&&f.isTexture&&(o===void 0&&(o=new Oe(new gn(2,2),new zt({name:"BackgroundMaterial",uniforms:Gn(Di.background.uniforms),vertexShader:Di.background.vertexShader,fragmentShader:Di.background.fragmentShader,side:Dr,depthTest:!1,depthWrite:!1,fog:!1,allowOverride:!1})),o.geometry.deleteAttribute("normal"),Object.defineProperty(o.material,"map",{get:function(){return this.uniforms.t2D.value}}),i.update(o)),o.material.uniforms.t2D.value=f,o.material.uniforms.backgroundIntensity.value=v.backgroundIntensity,o.material.toneMapped=He.getTransfer(f.colorSpace)!==Ze,f.matrixAutoUpdate===!0&&f.updateMatrix(),o.material.uniforms.uvTransform.value.copy(f.matrix),h===f&&d===f.version&&p===r.toneMapping||(o.material.needsUpdate=!0,h=f,d=f.version,p=r.toneMapping),o.layers.enableAll(),m.unshift(o,o.geometry,o.material,0,0,null))},dispose:function(){c!==void 0&&(c.geometry.dispose(),c.material.dispose(),c=void 0),o!==void 0&&(o.geometry.dispose(),o.material.dispose(),o=void 0)}}}function pm(r,e){let t=r.getParameter(r.MAX_VERTEX_ATTRIBS),i={},n=l(null),s=n,a=!1;function o(f){return r.bindVertexArray(f)}function c(f){return r.deleteVertexArray(f)}function l(f){let _=[],x=[],S=[];for(let T=0;T<t;T++)_[T]=0,x[T]=0,S[T]=0;return{geometry:null,program:null,wireframe:!1,newAttributes:_,enabledAttributes:x,attributeDivisors:S,object:f,attributes:{},index:null}}function h(){let f=s.newAttributes;for(let _=0,x=f.length;_<x;_++)f[_]=0}function d(f){p(f,0)}function p(f,_){let x=s.newAttributes,S=s.enabledAttributes,T=s.attributeDivisors;x[f]=1,S[f]===0&&(r.enableVertexAttribArray(f),S[f]=1),T[f]!==_&&(r.vertexAttribDivisor(f,_),T[f]=_)}function u(){let f=s.newAttributes,_=s.enabledAttributes;for(let x=0,S=_.length;x<S;x++)_[x]!==f[x]&&(r.disableVertexAttribArray(x),_[x]=0)}function g(f,_,x,S,T,M,P){P===!0?r.vertexAttribIPointer(f,_,x,T,M):r.vertexAttribPointer(f,_,x,S,T,M)}function m(){v(),a=!0,s!==n&&(s=n,o(s.object))}function v(){n.geometry=null,n.program=null,n.wireframe=!1}return{setup:function(f,_,x,S,T){let M=!1,P=(function(O,L,I,B){let U=B.wireframe===!0,X=i[L.id];X===void 0&&(X={},i[L.id]=X);let k=O.isInstancedMesh===!0?O.id:0,V=X[k];V===void 0&&(V={},X[k]=V);let Y=V[I.id];Y===void 0&&(Y={},V[I.id]=Y);let W=Y[U];return W===void 0&&(W=l(r.createVertexArray()),Y[U]=W),W})(f,S,x,_);s!==P&&(s=P,o(s.object)),M=(function(O,L,I,B){let U=s.attributes,X=L.attributes,k=0,V=I.getAttributes();for(let Y in V)if(V[Y].location>=0){let W=U[Y],ne=X[Y];if(ne===void 0&&(Y==="instanceMatrix"&&O.instanceMatrix&&(ne=O.instanceMatrix),Y==="instanceColor"&&O.instanceColor&&(ne=O.instanceColor)),W===void 0||W.attribute!==ne||ne&&W.data!==ne.data)return!0;k++}return s.attributesNum!==k||s.index!==B})(f,S,x,T),M&&(function(O,L,I,B){let U={},X=L.attributes,k=0,V=I.getAttributes();for(let Y in V)if(V[Y].location>=0){let W=X[Y];W===void 0&&(Y==="instanceMatrix"&&O.instanceMatrix&&(W=O.instanceMatrix),Y==="instanceColor"&&O.instanceColor&&(W=O.instanceColor));let ne={};ne.attribute=W,W&&W.data&&(ne.data=W.data),U[Y]=ne,k++}s.attributes=U,s.attributesNum=k,s.index=B})(f,S,x,T),T!==null&&e.update(T,r.ELEMENT_ARRAY_BUFFER),(M||a)&&(a=!1,(function(O,L,I,B){h();let U=B.attributes,X=I.getAttributes(),k=L.defaultAttributeValues;for(let V in X){let Y=X[V];if(Y.location>=0){let W=U[V];if(W===void 0&&(V==="instanceMatrix"&&O.instanceMatrix&&(W=O.instanceMatrix),V==="instanceColor"&&O.instanceColor&&(W=O.instanceColor)),W!==void 0){let ne=W.normalized,pe=W.itemSize,Ee=e.get(W);if(Ee===void 0)continue;let _e=Ee.buffer,ve=Ee.type,ie=Ee.bytesPerElement,he=ve===r.INT||ve===r.UNSIGNED_INT||W.gpuType===bo;if(W.isInterleavedBufferAttribute){let le=W.data,fe=le.stride,Ue=W.offset;if(le.isInstancedInterleavedBuffer){for(let $=0;$<Y.locationSize;$++)p(Y.location+$,le.meshPerAttribute);O.isInstancedMesh!==!0&&B._maxInstanceCount===void 0&&(B._maxInstanceCount=le.meshPerAttribute*le.count)}else for(let $=0;$<Y.locationSize;$++)d(Y.location+$);r.bindBuffer(r.ARRAY_BUFFER,_e);for(let $=0;$<Y.locationSize;$++)g(Y.location+$,pe/Y.locationSize,ve,ne,fe*ie,(Ue+pe/Y.locationSize*$)*ie,he)}else{if(W.isInstancedBufferAttribute){for(let le=0;le<Y.locationSize;le++)p(Y.location+le,W.meshPerAttribute);O.isInstancedMesh!==!0&&B._maxInstanceCount===void 0&&(B._maxInstanceCount=W.meshPerAttribute*W.count)}else for(let le=0;le<Y.locationSize;le++)d(Y.location+le);r.bindBuffer(r.ARRAY_BUFFER,_e);for(let le=0;le<Y.locationSize;le++)g(Y.location+le,pe/Y.locationSize,ve,ne,pe*ie,pe/Y.locationSize*le*ie,he)}}else if(k!==void 0){let ne=k[V];if(ne!==void 0)switch(ne.length){case 2:r.vertexAttrib2fv(Y.location,ne);break;case 3:r.vertexAttrib3fv(Y.location,ne);break;case 4:r.vertexAttrib4fv(Y.location,ne);break;default:r.vertexAttrib1fv(Y.location,ne)}}}}u()})(f,_,x,S),T!==null&&r.bindBuffer(r.ELEMENT_ARRAY_BUFFER,e.get(T).buffer))},reset:m,resetDefaultState:v,dispose:function(){m();for(let f in i){let _=i[f];for(let x in _){let S=_[x];for(let T in S){let M=S[T];for(let P in M)c(M[P].object),delete M[P];delete S[T]}}delete i[f]}},releaseStatesOfGeometry:function(f){if(i[f.id]===void 0)return;let _=i[f.id];for(let x in _){let S=_[x];for(let T in S){let M=S[T];for(let P in M)c(M[P].object),delete M[P];delete S[T]}}delete i[f.id]},releaseStatesOfObject:function(f){for(let _ in i){let x=i[_],S=f.isInstancedMesh===!0?f.id:0,T=x[S];if(T!==void 0){for(let M in T){let P=T[M];for(let O in P)c(P[O].object),delete P[O];delete T[M]}delete x[S],Object.keys(x).length===0&&delete i[_]}}},releaseStatesOfProgram:function(f){for(let _ in i){let x=i[_];for(let S in x){let T=x[S];if(T[f.id]===void 0)continue;let M=T[f.id];for(let P in M)c(M[P].object),delete M[P];delete T[f.id]}}},initAttributes:h,enableAttribute:d,disableUnusedAttributes:u}}function mm(r,e,t){let i;this.setMode=function(n){i=n},this.render=function(n,s){r.drawArrays(i,n,s),t.update(s,i,1)},this.renderInstances=function(n,s,a){a!==0&&(r.drawArraysInstanced(i,n,s,a),t.update(s,i,a))},this.renderMultiDraw=function(n,s,a){if(a===0)return;e.get("WEBGL_multi_draw").multiDrawArraysWEBGL(i,n,0,s,0,a);let o=0;for(let c=0;c<a;c++)o+=s[c];t.update(o,i,1)}}function fm(r,e,t,i){let n;function s(h){if(h==="highp"){if(r.getShaderPrecisionFormat(r.VERTEX_SHADER,r.HIGH_FLOAT).precision>0&&r.getShaderPrecisionFormat(r.FRAGMENT_SHADER,r.HIGH_FLOAT).precision>0)return"highp";h="mediump"}return h==="mediump"&&r.getShaderPrecisionFormat(r.VERTEX_SHADER,r.MEDIUM_FLOAT).precision>0&&r.getShaderPrecisionFormat(r.FRAGMENT_SHADER,r.MEDIUM_FLOAT).precision>0?"mediump":"lowp"}let a=t.precision!==void 0?t.precision:"highp",o=s(a);o!==a&&(be("WebGLRenderer:",a,"not supported, using",o,"instead."),a=o);let c=t.logarithmicDepthBuffer===!0,l=t.reversedDepthBuffer===!0&&e.has("EXT_clip_control");return t.reversedDepthBuffer===!0&&l===!1&&be("WebGLRenderer: Unable to use reversed depth buffer due to missing EXT_clip_control extension. Fallback to default depth buffer."),{isWebGL2:!0,getMaxAnisotropy:function(){if(n!==void 0)return n;if(e.has("EXT_texture_filter_anisotropic")===!0){let h=e.get("EXT_texture_filter_anisotropic");n=r.getParameter(h.MAX_TEXTURE_MAX_ANISOTROPY_EXT)}else n=0;return n},getMaxPrecision:s,textureFormatReadable:function(h){return h===vi||i.convert(h)===r.getParameter(r.IMPLEMENTATION_COLOR_READ_FORMAT)},textureTypeReadable:function(h){let d=h===Li&&(e.has("EXT_color_buffer_half_float")||e.has("EXT_color_buffer_float"));return!(h!==Zt&&i.convert(h)!==r.getParameter(r.IMPLEMENTATION_COLOR_READ_TYPE)&&h!==_i&&!d)},precision:a,logarithmicDepthBuffer:c,reversedDepthBuffer:l,maxTextures:r.getParameter(r.MAX_TEXTURE_IMAGE_UNITS),maxVertexTextures:r.getParameter(r.MAX_VERTEX_TEXTURE_IMAGE_UNITS),maxTextureSize:r.getParameter(r.MAX_TEXTURE_SIZE),maxCubemapSize:r.getParameter(r.MAX_CUBE_MAP_TEXTURE_SIZE),maxAttributes:r.getParameter(r.MAX_VERTEX_ATTRIBS),maxVertexUniforms:r.getParameter(r.MAX_VERTEX_UNIFORM_VECTORS),maxVaryings:r.getParameter(r.MAX_VARYING_VECTORS),maxFragmentUniforms:r.getParameter(r.MAX_FRAGMENT_UNIFORM_VECTORS),maxSamples:r.getParameter(r.MAX_SAMPLES),samples:r.getParameter(r.SAMPLES)}}function gm(r){let e=this,t=null,i=0,n=!1,s=!1,a=new Ei,o=new Ne,c={value:null,needsUpdate:!1};function l(h,d,p,u){let g=h!==null?h.length:0,m=null;if(g!==0){if(m=c.value,u!==!0||m===null){let v=p+4*g,f=d.matrixWorldInverse;o.getNormalMatrix(f),(m===null||m.length<v)&&(m=new Float32Array(v));for(let _=0,x=p;_!==g;++_,x+=4)a.copy(h[_]).applyMatrix4(f,o),a.normal.toArray(m,x),m[x+3]=a.constant}c.value=m,c.needsUpdate=!0}return e.numPlanes=g,e.numIntersection=0,m}this.uniform=c,this.numPlanes=0,this.numIntersection=0,this.init=function(h,d){let p=h.length!==0||d||i!==0||n;return n=d,i=h.length,p},this.beginShadows=function(){s=!0,l(null)},this.endShadows=function(){s=!1},this.setGlobalState=function(h,d){t=l(h,d,0)},this.setState=function(h,d,p){let u=h.clippingPlanes,g=h.clipIntersection,m=h.clipShadows,v=r.get(h);if(!n||u===null||u.length===0||s&&!m)s?l(null):(function(){c.value!==t&&(c.value=t,c.needsUpdate=i>0),e.numPlanes=i,e.numIntersection=0})();else{let f=s?0:i,_=4*f,x=v.clippingState||null;c.value=x,x=l(u,d,_,p);for(let S=0;S!==_;++S)x[S]=t[S];v.clippingState=x,this.numIntersection=g?this.numPlanes:0,this.numPlanes+=f}}}Zd.set(-1,0,0,0,1,0,0,0,1);var wd=[.125,.215,.35,.446,.526,.582],Fs=20,Os=new Lr,Ad=new Ie,ih=null,nh=0,rh=0,sh=!1,_m=new w,Oo=class{constructor(e){this._renderer=e,this._pingPongRenderTarget=null,this._lodMax=0,this._cubeSize=0,this._sizeLods=[],this._sigmas=[],this._lodMeshes=[],this._backgroundBox=null,this._cubemapMaterial=null,this._equirectMaterial=null,this._blurMaterial=null,this._ggxMaterial=null}fromScene(e,t=0,i=.1,n=100,s={}){let{size:a=256,position:o=_m}=s;ih=this._renderer.getRenderTarget(),nh=this._renderer.getActiveCubeFace(),rh=this._renderer.getActiveMipmapLevel(),sh=this._renderer.xr.enabled,this._renderer.xr.enabled=!1,this._setSize(a);let c=this._allocateTargets();return c.depthBuffer=!0,this._sceneToCubeUV(e,i,n,c,o),t>0&&this._blur(c,0,0,t),this._applyPMREM(c),this._cleanup(c),c}fromEquirectangular(e,t=null){return this._fromTexture(e,t)}fromCubemap(e,t=null){return this._fromTexture(e,t)}compileCubemapShader(){this._cubemapMaterial===null&&(this._cubemapMaterial=Pd(),this._compileMaterial(this._cubemapMaterial))}compileEquirectangularShader(){this._equirectMaterial===null&&(this._equirectMaterial=Rd(),this._compileMaterial(this._equirectMaterial))}dispose(){this._dispose(),this._cubemapMaterial!==null&&this._cubemapMaterial.dispose(),this._equirectMaterial!==null&&this._equirectMaterial.dispose(),this._backgroundBox!==null&&(this._backgroundBox.geometry.dispose(),this._backgroundBox.material.dispose())}_setSize(e){this._lodMax=Math.floor(Math.log2(e)),this._cubeSize=Math.pow(2,this._lodMax)}_dispose(){this._blurMaterial!==null&&this._blurMaterial.dispose(),this._ggxMaterial!==null&&this._ggxMaterial.dispose(),this._pingPongRenderTarget!==null&&this._pingPongRenderTarget.dispose();for(let e=0;e<this._lodMeshes.length;e++)this._lodMeshes[e].geometry.dispose()}_cleanup(e){this._renderer.setRenderTarget(ih,nh,rh),this._renderer.xr.enabled=sh,e.scissorTest=!1,zr(e,0,0,e.width,e.height)}_fromTexture(e,t){e.mapping===Fr||e.mapping===Un?this._setSize(e.image.length===0?16:e.image[0].width||e.image[0].image.width):this._setSize(e.image.width/4),ih=this._renderer.getRenderTarget(),nh=this._renderer.getActiveCubeFace(),rh=this._renderer.getActiveMipmapLevel(),sh=this._renderer.xr.enabled,this._renderer.xr.enabled=!1;let i=t||this._allocateTargets();return this._textureToCubeUV(e,i),this._applyPMREM(i),this._cleanup(i),i}_allocateTargets(){let e=3*Math.max(this._cubeSize,112),t=4*this._cubeSize,i={magFilter:Dt,minFilter:Dt,generateMipmaps:!1,type:Li,format:vi,colorSpace:as,depthBuffer:!1},n=Cd(e,t,i);if(this._pingPongRenderTarget===null||this._pingPongRenderTarget.width!==e||this._pingPongRenderTarget.height!==t){this._pingPongRenderTarget!==null&&this._dispose(),this._pingPongRenderTarget=Cd(e,t,i);let{_lodMax:s}=this;({lodMeshes:this._lodMeshes,sizeLods:this._sizeLods,sigmas:this._sigmas}=(function(a){let o=[],c=[],l=[],h=a,d=a-4+1+wd.length;for(let p=0;p<d;p++){let u=Math.pow(2,h);o.push(u);let g=1/u;p>a-4?g=wd[p-a+4-1]:p===0&&(g=0),c.push(g);let m=1/(u-2),v=-m,f=1+m,_=[v,v,f,v,f,f,v,v,f,f,v,f],x=6,S=6,T=3,M=2,P=1,O=new Float32Array(T*S*x),L=new Float32Array(M*S*x),I=new Float32Array(P*S*x);for(let U=0;U<x;U++){let X=U%3*2/3-1,k=U>2?0:-1,V=[X,k,0,X+2/3,k,0,X+2/3,k+1,0,X,k,0,X+2/3,k+1,0,X,k+1,0];O.set(V,T*S*U),L.set(_,M*S*U);let Y=[U,U,U,U,U,U];I.set(Y,P*S*U)}let B=new Xe;B.setAttribute("position",new ft(O,T)),B.setAttribute("uv",new ft(L,M)),B.setAttribute("faceIndex",new ft(I,P)),l.push(new Oe(B,null)),h>4&&h--}return{lodMeshes:l,sizeLods:o,sigmas:c}})(s)),this._blurMaterial=(function(a,o,c){let l=new Float32Array(Fs),h=new w(0,1,0);return new zt({name:"SphericalGaussianBlur",defines:{n:Fs,CUBEUV_TEXEL_WIDTH:1/o,CUBEUV_TEXEL_HEIGHT:1/c,CUBEUV_MAX_MIP:`${a}.0`},uniforms:{envMap:{value:null},samples:{value:1},weights:{value:l},latitudinal:{value:!1},dTheta:{value:0},mipInt:{value:0},poleAxis:{value:h}},vertexShader:Bo(),fragmentShader:`

			precision mediump float;
			precision mediump int;

			varying vec3 vOutputDirection;

			uniform sampler2D envMap;
			uniform int samples;
			uniform float weights[ n ];
			uniform bool latitudinal;
			uniform float dTheta;
			uniform float mipInt;
			uniform vec3 poleAxis;

			#define ENVMAP_TYPE_CUBE_UV
			#include <cube_uv_reflection_fragment>

			vec3 getSample( float theta, vec3 axis ) {

				float cosTheta = cos( theta );
				// Rodrigues' axis-angle rotation
				vec3 sampleDirection = vOutputDirection * cosTheta
					+ cross( axis, vOutputDirection ) * sin( theta )
					+ axis * dot( axis, vOutputDirection ) * ( 1.0 - cosTheta );

				return bilinearCubeUV( envMap, sampleDirection, mipInt );

			}

			void main() {

				vec3 axis = latitudinal ? poleAxis : cross( poleAxis, vOutputDirection );

				if ( all( equal( axis, vec3( 0.0 ) ) ) ) {

					axis = vec3( vOutputDirection.z, 0.0, - vOutputDirection.x );

				}

				axis = normalize( axis );

				gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );
				gl_FragColor.rgb += weights[ 0 ] * getSample( 0.0, axis );

				for ( int i = 1; i < n; i++ ) {

					if ( i >= samples ) {

						break;

					}

					float theta = dTheta * float( i );
					gl_FragColor.rgb += weights[ i ] * getSample( -1.0 * theta, axis );
					gl_FragColor.rgb += weights[ i ] * getSample( theta, axis );

				}

			}
		`,blending:Ii,depthTest:!1,depthWrite:!1})})(s,e,t),this._ggxMaterial=(function(a,o,c){return new zt({name:"PMREMGGXConvolution",defines:{GGX_SAMPLES:256,CUBEUV_TEXEL_WIDTH:1/o,CUBEUV_TEXEL_HEIGHT:1/c,CUBEUV_MAX_MIP:`${a}.0`},uniforms:{envMap:{value:null},roughness:{value:0},mipInt:{value:0}},vertexShader:Bo(),fragmentShader:`

			precision highp float;
			precision highp int;

			varying vec3 vOutputDirection;

			uniform sampler2D envMap;
			uniform float roughness;
			uniform float mipInt;

			#define ENVMAP_TYPE_CUBE_UV
			#include <cube_uv_reflection_fragment>

			#define PI 3.14159265359

			// Van der Corput radical inverse
			float radicalInverse_VdC(uint bits) {
				bits = (bits << 16u) | (bits >> 16u);
				bits = ((bits & 0x55555555u) << 1u) | ((bits & 0xAAAAAAAAu) >> 1u);
				bits = ((bits & 0x33333333u) << 2u) | ((bits & 0xCCCCCCCCu) >> 2u);
				bits = ((bits & 0x0F0F0F0Fu) << 4u) | ((bits & 0xF0F0F0F0u) >> 4u);
				bits = ((bits & 0x00FF00FFu) << 8u) | ((bits & 0xFF00FF00u) >> 8u);
				return float(bits) * 2.3283064365386963e-10; // / 0x100000000
			}

			// Hammersley sequence
			vec2 hammersley(uint i, uint N) {
				return vec2(float(i) / float(N), radicalInverse_VdC(i));
			}

			// GGX VNDF importance sampling (Eric Heitz 2018)
			// "Sampling the GGX Distribution of Visible Normals"
			// https://jcgt.org/published/0007/04/01/
			vec3 importanceSampleGGX_VNDF(vec2 Xi, vec3 V, float roughness) {
				float alpha = roughness * roughness;

				// Section 4.1: Orthonormal basis
				vec3 T1 = vec3(1.0, 0.0, 0.0);
				vec3 T2 = cross(V, T1);

				// Section 4.2: Parameterization of projected area
				float r = sqrt(Xi.x);
				float phi = 2.0 * PI * Xi.y;
				float t1 = r * cos(phi);
				float t2 = r * sin(phi);
				float s = 0.5 * (1.0 + V.z);
				t2 = (1.0 - s) * sqrt(1.0 - t1 * t1) + s * t2;

				// Section 4.3: Reprojection onto hemisphere
				vec3 Nh = t1 * T1 + t2 * T2 + sqrt(max(0.0, 1.0 - t1 * t1 - t2 * t2)) * V;

				// Section 3.4: Transform back to ellipsoid configuration
				return normalize(vec3(alpha * Nh.x, alpha * Nh.y, max(0.0, Nh.z)));
			}

			void main() {
				vec3 N = normalize(vOutputDirection);
				vec3 V = N; // Assume view direction equals normal for pre-filtering

				vec3 prefilteredColor = vec3(0.0);
				float totalWeight = 0.0;

				// For very low roughness, just sample the environment directly
				if (roughness < 0.001) {
					gl_FragColor = vec4(bilinearCubeUV(envMap, N, mipInt), 1.0);
					return;
				}

				// Tangent space basis for VNDF sampling
				vec3 up = abs(N.z) < 0.999 ? vec3(0.0, 0.0, 1.0) : vec3(1.0, 0.0, 0.0);
				vec3 tangent = normalize(cross(up, N));
				vec3 bitangent = cross(N, tangent);

				for(uint i = 0u; i < uint(GGX_SAMPLES); i++) {
					vec2 Xi = hammersley(i, uint(GGX_SAMPLES));

					// For PMREM, V = N, so in tangent space V is always (0, 0, 1)
					vec3 H_tangent = importanceSampleGGX_VNDF(Xi, vec3(0.0, 0.0, 1.0), roughness);

					// Transform H back to world space
					vec3 H = normalize(tangent * H_tangent.x + bitangent * H_tangent.y + N * H_tangent.z);
					vec3 L = normalize(2.0 * dot(V, H) * H - V);

					float NdotL = max(dot(N, L), 0.0);

					if(NdotL > 0.0) {
						// Sample environment at fixed mip level
						// VNDF importance sampling handles the distribution filtering
						vec3 sampleColor = bilinearCubeUV(envMap, L, mipInt);

						// Weight by NdotL for the split-sum approximation
						// VNDF PDF naturally accounts for the visible microfacet distribution
						prefilteredColor += sampleColor * NdotL;
						totalWeight += NdotL;
					}
				}

				if (totalWeight > 0.0) {
					prefilteredColor = prefilteredColor / totalWeight;
				}

				gl_FragColor = vec4(prefilteredColor, 1.0);
			}
		`,blending:Ii,depthTest:!1,depthWrite:!1})})(s,e,t)}return n}_compileMaterial(e){let t=new Oe(new Xe,e);this._renderer.compile(t,Os)}_sceneToCubeUV(e,t,i,n,s){let a=new Rt(90,1,t,i),o=[1,-1,1,1,1,1],c=[1,1,1,-1,-1,-1],l=this._renderer,h=l.autoClear,d=l.toneMapping;l.getClearColor(Ad),l.toneMapping=gi,l.autoClear=!1,l.state.buffers.depth.getReversed()&&(l.setRenderTarget(n),l.clearDepth(),l.setRenderTarget(null)),this._backgroundBox===null&&(this._backgroundBox=new Oe(new qt,new Et({name:"PMREM.Background",side:Gt,depthWrite:!1,depthTest:!1})));let p=this._backgroundBox,u=p.material,g=!1,m=e.background;m?m.isColor&&(u.color.copy(m),e.background=null,g=!0):(u.color.copy(Ad),g=!0);for(let v=0;v<6;v++){let f=v%3;f===0?(a.up.set(0,o[v],0),a.position.set(s.x,s.y,s.z),a.lookAt(s.x+c[v],s.y,s.z)):f===1?(a.up.set(0,0,o[v]),a.position.set(s.x,s.y,s.z),a.lookAt(s.x,s.y+c[v],s.z)):(a.up.set(0,o[v],0),a.position.set(s.x,s.y,s.z),a.lookAt(s.x,s.y,s.z+c[v]));let _=this._cubeSize;zr(n,f*_,v>2?_:0,_,_),l.setRenderTarget(n),g&&l.render(p,a),l.render(e,a)}l.toneMapping=d,l.autoClear=h,e.background=m}_textureToCubeUV(e,t){let i=this._renderer,n=e.mapping===Fr||e.mapping===Un;n?(this._cubemapMaterial===null&&(this._cubemapMaterial=Pd()),this._cubemapMaterial.uniforms.flipEnvMap.value=e.isRenderTargetTexture===!1?-1:1):this._equirectMaterial===null&&(this._equirectMaterial=Rd());let s=n?this._cubemapMaterial:this._equirectMaterial,a=this._lodMeshes[0];a.material=s,s.uniforms.envMap.value=e;let o=this._cubeSize;zr(t,0,0,3*o,2*o),i.setRenderTarget(t),i.render(a,Os)}_applyPMREM(e){let t=this._renderer,i=t.autoClear;t.autoClear=!1;let n=this._lodMeshes.length;for(let s=1;s<n;s++)this._applyGGXFilter(e,s-1,s);t.autoClear=i}_applyGGXFilter(e,t,i){let n=this._renderer,s=this._pingPongRenderTarget,a=this._ggxMaterial,o=this._lodMeshes[i];o.material=a;let c=a.uniforms,l=i/(this._lodMeshes.length-1),h=t/(this._lodMeshes.length-1),d=Math.sqrt(l*l-h*h)*(0+1.25*l),{_lodMax:p}=this,u=this._sizeLods[i],g=3*u*(i>p-4?i-p+4:0),m=4*(this._cubeSize-u);c.envMap.value=e.texture,c.roughness.value=d,c.mipInt.value=p-t,zr(s,g,m,3*u,2*u),n.setRenderTarget(s),n.render(o,Os),c.envMap.value=s.texture,c.roughness.value=0,c.mipInt.value=p-i,zr(e,g,m,3*u,2*u),n.setRenderTarget(e),n.render(o,Os)}_blur(e,t,i,n,s){let a=this._pingPongRenderTarget;this._halfBlur(e,a,t,i,n,"latitudinal",s),this._halfBlur(a,e,i,i,n,"longitudinal",s)}_halfBlur(e,t,i,n,s,a,o){let c=this._renderer,l=this._blurMaterial;a!=="latitudinal"&&a!=="longitudinal"&&we("blur direction must be either latitudinal or longitudinal!");let h=this._lodMeshes[n];h.material=l;let d=l.uniforms,p=this._sizeLods[i]-1,u=isFinite(s)?Math.PI/(2*p):2*Math.PI/39,g=s/u,m=isFinite(s)?1+Math.floor(3*g):Fs;m>Fs&&be(`sigmaRadians, ${s}, is too large and will clip, as it requested ${m} samples when the maximum is set to 20`);let v=[],f=0;for(let S=0;S<Fs;++S){let T=S/g,M=Math.exp(-T*T/2);v.push(M),S===0?f+=M:S<m&&(f+=2*M)}for(let S=0;S<v.length;S++)v[S]=v[S]/f;d.envMap.value=e.texture,d.samples.value=m,d.weights.value=v,d.latitudinal.value=a==="latitudinal",o&&(d.poleAxis.value=o);let{_lodMax:_}=this;d.dTheta.value=u,d.mipInt.value=_-i;let x=this._sizeLods[n];zr(t,3*x*(n>_-4?n-_+4:0),4*(this._cubeSize-x),3*x,2*x),c.setRenderTarget(t),c.render(h,Os)}};function Cd(r,e,t){let i=new jt(r,e,t);return i.texture.mapping=Ds,i.texture.name="PMREM.cubeUv",i.scissorTest=!0,i}function zr(r,e,t,i,n){r.viewport.set(e,t,i,n),r.scissor.set(e,t,i,n)}function Rd(){return new zt({name:"EquirectangularToCubeUV",uniforms:{envMap:{value:null}},vertexShader:Bo(),fragmentShader:`

			precision mediump float;
			precision mediump int;

			varying vec3 vOutputDirection;

			uniform sampler2D envMap;

			#include <common>

			void main() {

				vec3 outputDirection = normalize( vOutputDirection );
				vec2 uv = equirectUv( outputDirection );

				gl_FragColor = vec4( texture2D ( envMap, uv ).rgb, 1.0 );

			}
		`,blending:Ii,depthTest:!1,depthWrite:!1})}function Pd(){return new zt({name:"CubemapToCubeUV",uniforms:{envMap:{value:null},flipEnvMap:{value:-1}},vertexShader:Bo(),fragmentShader:`

			precision mediump float;
			precision mediump int;

			uniform float flipEnvMap;

			varying vec3 vOutputDirection;

			uniform samplerCube envMap;

			void main() {

				gl_FragColor = textureCube( envMap, vec3( flipEnvMap * vOutputDirection.x, vOutputDirection.yz ) );

			}
		`,blending:Ii,depthTest:!1,depthWrite:!1})}function Bo(){return`

		precision mediump float;
		precision mediump int;

		attribute float faceIndex;

		varying vec3 vOutputDirection;

		// RH coordinate system; PMREM face-indexing convention
		vec3 getDirection( vec2 uv, float face ) {

			uv = 2.0 * uv - 1.0;

			vec3 direction = vec3( uv, 1.0 );

			if ( face == 0.0 ) {

				direction = direction.zyx; // ( 1, v, u ) pos x

			} else if ( face == 1.0 ) {

				direction = direction.xzy;
				direction.xz *= -1.0; // ( -u, 1, -v ) pos y

			} else if ( face == 2.0 ) {

				direction.x *= -1.0; // ( -u, v, 1 ) pos z

			} else if ( face == 3.0 ) {

				direction = direction.zyx;
				direction.xz *= -1.0; // ( -1, v, -u ) neg x

			} else if ( face == 4.0 ) {

				direction = direction.xzy;
				direction.xy *= -1.0; // ( -u, -1, v ) neg y

			} else if ( face == 5.0 ) {

				direction.z *= -1.0; // ( u, v, -1 ) neg z

			}

			return direction;

		}

		void main() {

			vOutputDirection = getDirection( uv, faceIndex );
			gl_Position = vec4( position, 1.0 );

		}
	`}var zo=class extends jt{constructor(e=1,t={}){super(e,e,t),this.isWebGLCubeRenderTarget=!0;let i={width:e,height:e,depth:1},n=[i,i,i,i,i,i];this.texture=new gs(n),this._setTextureOptions(t),this.texture.isRenderTargetTexture=!0}fromEquirectangularTexture(e,t){this.texture.type=t.type,this.texture.colorSpace=t.colorSpace,this.texture.generateMipmaps=t.generateMipmaps,this.texture.minFilter=t.minFilter,this.texture.magFilter=t.magFilter;let i={uniforms:{tEquirect:{value:null}},vertexShader:`

				varying vec3 vWorldDirection;

				vec3 transformDirection( in vec3 dir, in mat4 matrix ) {

					return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );

				}

				void main() {

					vWorldDirection = transformDirection( position, modelMatrix );

					#include <begin_vertex>
					#include <project_vertex>

				}
			`,fragmentShader:`

				uniform sampler2D tEquirect;

				varying vec3 vWorldDirection;

				#include <common>

				void main() {

					vec3 direction = normalize( vWorldDirection );

					vec2 sampleUV = equirectUv( direction );

					gl_FragColor = texture2D( tEquirect, sampleUV );

				}
			`},n=new qt(5,5,5),s=new zt({name:"CubemapFromEquirect",uniforms:Gn(i.uniforms),vertexShader:i.vertexShader,fragmentShader:i.fragmentShader,side:Gt,blending:Ii});s.uniforms.tEquirect.value=t;let a=new Oe(n,s),o=t.minFilter;return t.minFilter===Fn&&(t.minFilter=Dt),new _o(1,10,this).update(e,a),t.minFilter=o,a.geometry.dispose(),a.material.dispose(),this}clear(e,t=!0,i=!0,n=!0){let s=e.getRenderTarget();for(let a=0;a<6;a++)e.setRenderTarget(this,a),e.clear(t,i,n);e.setRenderTarget(s)}};function vm(r){let e=new WeakMap,t=new WeakMap,i=null;function n(o,c){return c===yo?o.mapping=Fr:c===Mo&&(o.mapping=Un),o}function s(o){let c=o.target;c.removeEventListener("dispose",s);let l=e.get(c);l!==void 0&&(e.delete(c),l.dispose())}function a(o){let c=o.target;c.removeEventListener("dispose",a);let l=t.get(c);l!==void 0&&(t.delete(c),l.dispose())}return{get:function(o,c=!1){return o==null?null:c?(function(l){if(l&&l.isTexture){let h=l.mapping,d=h===yo||h===Mo,p=h===Fr||h===Un;if(d||p){let u=t.get(l),g=u!==void 0?u.texture.pmremVersion:0;if(l.isRenderTargetTexture&&l.pmremVersion!==g)return i===null&&(i=new Oo(r)),u=d?i.fromEquirectangular(l,u):i.fromCubemap(l,u),u.texture.pmremVersion=l.pmremVersion,t.set(l,u),u.texture;if(u!==void 0)return u.texture;{let m=l.image;return d&&m&&m.height>0||p&&m&&(function(v){let f=0,_=6;for(let x=0;x<_;x++)v[x]!==void 0&&f++;return f===_})(m)?(i===null&&(i=new Oo(r)),u=d?i.fromEquirectangular(l):i.fromCubemap(l),u.texture.pmremVersion=l.pmremVersion,t.set(l,u),l.addEventListener("dispose",a),u.texture):null}}}return l})(o):(function(l){if(l&&l.isTexture){let h=l.mapping;if(h===yo||h===Mo){if(e.has(l))return n(e.get(l).texture,l.mapping);{let d=l.image;if(d&&d.height>0){let p=new zo(d.height);return p.fromEquirectangularTexture(r,l),e.set(l,p),l.addEventListener("dispose",s),n(p.texture,l.mapping)}return null}}}return l})(o)},dispose:function(){e=new WeakMap,t=new WeakMap,i!==null&&(i.dispose(),i=null)}}}function xm(r){let e={};function t(i){if(e[i]!==void 0)return e[i];let n=r.getExtension(i);return e[i]=n,n}return{has:function(i){return t(i)!==null},init:function(){t("EXT_color_buffer_float"),t("WEBGL_clip_cull_distance"),t("OES_texture_float_linear"),t("EXT_color_buffer_half_float"),t("WEBGL_multisampled_render_to_texture"),t("WEBGL_render_shared_exponent")},get:function(i){let n=t(i);return n===null&&Pn("WebGLRenderer: "+i+" extension not supported."),n}}}function ym(r,e,t,i){let n={},s=new WeakMap;function a(c){let l=c.target;l.index!==null&&e.remove(l.index);for(let d in l.attributes)e.remove(l.attributes[d]);l.removeEventListener("dispose",a),delete n[l.id];let h=s.get(l);h&&(e.remove(h),s.delete(l)),i.releaseStatesOfGeometry(l),l.isInstancedBufferGeometry===!0&&delete l._maxInstanceCount,t.memory.geometries--}function o(c){let l=[],h=c.index,d=c.attributes.position,p=0;if(d===void 0)return;if(h!==null){let m=h.array;p=h.version;for(let v=0,f=m.length;v<f;v+=3){let _=m[v+0],x=m[v+1],S=m[v+2];l.push(_,x,x,S,S,_)}}else{let m=d.array;p=d.version;for(let v=0,f=m.length/3-1;v<f;v+=3){let _=v+0,x=v+1,S=v+2;l.push(_,x,x,S,S,_)}}let u=new(d.count>=65535?ps:ds)(l,1);u.version=p;let g=s.get(c);g&&e.remove(g),s.set(c,u)}return{get:function(c,l){return n[l.id]===!0||(l.addEventListener("dispose",a),n[l.id]=!0,t.memory.geometries++),l},update:function(c){let l=c.attributes;for(let h in l)e.update(l[h],r.ARRAY_BUFFER)},getWireframeAttribute:function(c){let l=s.get(c);if(l){let h=c.index;h!==null&&l.version<h.version&&o(c)}else o(c);return s.get(c)}}}function Mm(r,e,t){let i,n,s;this.setMode=function(a){i=a},this.setIndex=function(a){n=a.type,s=a.bytesPerElement},this.render=function(a,o){r.drawElements(i,o,n,a*s),t.update(o,i,1)},this.renderInstances=function(a,o,c){c!==0&&(r.drawElementsInstanced(i,o,n,a*s,c),t.update(o,i,c))},this.renderMultiDraw=function(a,o,c){if(c===0)return;e.get("WEBGL_multi_draw").multiDrawElementsWEBGL(i,o,0,n,a,0,c);let l=0;for(let h=0;h<c;h++)l+=o[h];t.update(l,i,1)}}function Sm(r){let e={frame:0,calls:0,triangles:0,points:0,lines:0};return{memory:{geometries:0,textures:0},render:e,programs:null,autoReset:!0,reset:function(){e.calls=0,e.triangles=0,e.points=0,e.lines=0},update:function(t,i,n){switch(e.calls++,i){case r.TRIANGLES:e.triangles+=n*(t/3);break;case r.LINES:e.lines+=n*(t/2);break;case r.LINE_STRIP:e.lines+=n*(t-1);break;case r.LINE_LOOP:e.lines+=n*t;break;case r.POINTS:e.points+=n*t;break;default:we("WebGLInfo: Unknown draw mode:",i)}}}}function bm(r,e,t){let i=new WeakMap,n=new $e;return{update:function(s,a,o){let c=s.morphTargetInfluences,l=a.morphAttributes.position||a.morphAttributes.normal||a.morphAttributes.color,h=l!==void 0?l.length:0,d=i.get(a);if(d===void 0||d.count!==h){let O=function(){M.dispose(),i.delete(a),a.removeEventListener("dispose",O)};d!==void 0&&d.texture.dispose();let p=a.morphAttributes.position!==void 0,u=a.morphAttributes.normal!==void 0,g=a.morphAttributes.color!==void 0,m=a.morphAttributes.position||[],v=a.morphAttributes.normal||[],f=a.morphAttributes.color||[],_=0;p===!0&&(_=1),u===!0&&(_=2),g===!0&&(_=3);let x=a.attributes.position.count*_,S=1;x>e.maxTextureSize&&(S=Math.ceil(x/e.maxTextureSize),x=e.maxTextureSize);let T=new Float32Array(x*S*4*h),M=new cs(T,x,S,h);M.type=_i,M.needsUpdate=!0;let P=4*_;for(let L=0;L<h;L++){let I=m[L],B=v[L],U=f[L],X=x*S*4*L;for(let k=0;k<I.count;k++){let V=k*P;p===!0&&(n.fromBufferAttribute(I,k),T[X+V+0]=n.x,T[X+V+1]=n.y,T[X+V+2]=n.z,T[X+V+3]=0),u===!0&&(n.fromBufferAttribute(B,k),T[X+V+4]=n.x,T[X+V+5]=n.y,T[X+V+6]=n.z,T[X+V+7]=0),g===!0&&(n.fromBufferAttribute(U,k),T[X+V+8]=n.x,T[X+V+9]=n.y,T[X+V+10]=n.z,T[X+V+11]=U.itemSize===4?n.w:1)}}d={count:h,texture:M,size:new te(x,S)},i.set(a,d),a.addEventListener("dispose",O)}if(s.isInstancedMesh===!0&&s.morphTexture!==null)o.getUniforms().setValue(r,"morphTexture",s.morphTexture,t);else{let p=0;for(let g=0;g<c.length;g++)p+=c[g];let u=a.morphTargetsRelative?1:1-p;o.getUniforms().setValue(r,"morphTargetBaseInfluence",u),o.getUniforms().setValue(r,"morphTargetInfluences",c)}o.getUniforms().setValue(r,"morphTargetsTexture",d.texture,t),o.getUniforms().setValue(r,"morphTargetsTextureSize",d.size)}}}function Tm(r,e,t,i,n){let s=new WeakMap;function a(o){let c=o.target;c.removeEventListener("dispose",a),i.releaseStatesOfObject(c),t.remove(c.instanceMatrix),c.instanceColor!==null&&t.remove(c.instanceColor)}return{update:function(o){let c=n.render.frame,l=o.geometry,h=e.get(o,l);if(s.get(h)!==c&&(e.update(h),s.set(h,c)),o.isInstancedMesh&&(o.hasEventListener("dispose",a)===!1&&o.addEventListener("dispose",a),s.get(o)!==c&&(t.update(o.instanceMatrix,r.ARRAY_BUFFER),o.instanceColor!==null&&t.update(o.instanceColor,r.ARRAY_BUFFER),s.set(o,c))),o.isSkinnedMesh){let d=o.skeleton;s.get(d)!==c&&(d.update(),s.set(d,c))}return h},dispose:function(){s=new WeakMap}}}var Em={[sc]:"LINEAR_TONE_MAPPING",[ac]:"REINHARD_TONE_MAPPING",[oc]:"CINEON_TONE_MAPPING",[Ns]:"ACES_FILMIC_TONE_MAPPING",[cc]:"AGX_TONE_MAPPING",[hc]:"NEUTRAL_TONE_MAPPING",[lc]:"CUSTOM_TONE_MAPPING"};function wm(r,e,t,i,n,s){let a=new jt(e,t,{type:r,depthBuffer:n,stencilBuffer:s,samples:i?4:0,depthTexture:n?new Zi(e,t):void 0}),o=new jt(e,t,{type:Li,depthBuffer:!1,stencilBuffer:!1}),c=new Xe;c.setAttribute("position",new Te([-1,3,0,-1,-1,0,3,-1,0],3)),c.setAttribute("uv",new Te([0,2,0,0,2,0],2));let l=new io({uniforms:{tDiffuse:{value:null}},vertexShader:`
			precision highp float;

			uniform mat4 modelViewMatrix;
			uniform mat4 projectionMatrix;

			attribute vec3 position;
			attribute vec2 uv;

			varying vec2 vUv;

			void main() {
				vUv = uv;
				gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
			}`,fragmentShader:`
			precision highp float;

			uniform sampler2D tDiffuse;

			varying vec2 vUv;

			#include <tonemapping_pars_fragment>
			#include <colorspace_pars_fragment>

			void main() {
				gl_FragColor = texture2D( tDiffuse, vUv );

				#ifdef LINEAR_TONE_MAPPING
					gl_FragColor.rgb = LinearToneMapping( gl_FragColor.rgb );
				#elif defined( REINHARD_TONE_MAPPING )
					gl_FragColor.rgb = ReinhardToneMapping( gl_FragColor.rgb );
				#elif defined( CINEON_TONE_MAPPING )
					gl_FragColor.rgb = CineonToneMapping( gl_FragColor.rgb );
				#elif defined( ACES_FILMIC_TONE_MAPPING )
					gl_FragColor.rgb = ACESFilmicToneMapping( gl_FragColor.rgb );
				#elif defined( AGX_TONE_MAPPING )
					gl_FragColor.rgb = AgXToneMapping( gl_FragColor.rgb );
				#elif defined( NEUTRAL_TONE_MAPPING )
					gl_FragColor.rgb = NeutralToneMapping( gl_FragColor.rgb );
				#elif defined( CUSTOM_TONE_MAPPING )
					gl_FragColor.rgb = CustomToneMapping( gl_FragColor.rgb );
				#endif

				#ifdef SRGB_TRANSFER
					gl_FragColor = sRGBTransferOETF( gl_FragColor );
				#endif
			}`,depthTest:!1,depthWrite:!1}),h=new Oe(c,l),d=new Lr(-1,1,1,-1,0,1),p,u=null,g=null,m=!1,v=null,f=[],_=!1;this.setSize=function(x,S){a.setSize(x,S),o.setSize(x,S);for(let T=0;T<f.length;T++){let M=f[T];M.setSize&&M.setSize(x,S)}},this.setEffects=function(x){f=x,_=f.length>0&&f[0].isRenderPass===!0;let S=a.width,T=a.height;for(let M=0;M<f.length;M++){let P=f[M];P.setSize&&P.setSize(S,T)}},this.begin=function(x,S){if(m||x.toneMapping===gi&&f.length===0)return!1;if(v=S,S!==null){let T=S.width,M=S.height;a.width===T&&a.height===M||this.setSize(T,M)}return _===!1&&x.setRenderTarget(a),p=x.toneMapping,x.toneMapping=gi,!0},this.hasRenderPass=function(){return _},this.end=function(x,S){x.toneMapping=p,m=!0;let T=a,M=o;for(let P=0;P<f.length;P++){let O=f[P];if(O.enabled!==!1&&(O.render(x,M,T,S),O.needsSwap!==!1)){let L=T;T=M,M=L}}if(u!==x.outputColorSpace||g!==x.toneMapping){u=x.outputColorSpace,g=x.toneMapping,l.defines={},He.getTransfer(u)===Ze&&(l.defines.SRGB_TRANSFER="");let P=Em[g];P&&(l.defines[P]=""),l.needsUpdate=!0}l.uniforms.tDiffuse.value=T.texture,x.setRenderTarget(v),x.render(h,d),v=null,m=!1},this.isCompositing=function(){return m},this.dispose=function(){a.depthTexture&&a.depthTexture.dispose(),a.dispose(),o.dispose(),c.dispose(),l.dispose()}}var Jd=new Nt,lh=new Zi(1,1),Kd=new cs,$d=new Na,Qd=new gs,Id=[],Ld=[],Nd=new Float32Array(16),Dd=new Float32Array(9),Ud=new Float32Array(4);function Vr(r,e,t){let i=r[0];if(i<=0||i>0)return r;let n=e*t,s=Id[n];if(s===void 0&&(s=new Float32Array(n),Id[n]=s),e!==0){i.toArray(s,0);for(let a=1,o=0;a!==e;++a)o+=t,r[a].toArray(s,o)}return s}function yt(r,e){if(r.length!==e.length)return!1;for(let t=0,i=r.length;t<i;t++)if(r[t]!==e[t])return!1;return!0}function Mt(r,e){for(let t=0,i=e.length;t<i;t++)r[t]=e[t]}function Vo(r,e){let t=Ld[e];t===void 0&&(t=new Int32Array(e),Ld[e]=t);for(let i=0;i!==e;++i)t[i]=r.allocateTextureUnit();return t}function Am(r,e){let t=this.cache;t[0]!==e&&(r.uniform1f(this.addr,e),t[0]=e)}function Cm(r,e){let t=this.cache;if(e.x!==void 0)t[0]===e.x&&t[1]===e.y||(r.uniform2f(this.addr,e.x,e.y),t[0]=e.x,t[1]=e.y);else{if(yt(t,e))return;r.uniform2fv(this.addr,e),Mt(t,e)}}function Rm(r,e){let t=this.cache;if(e.x!==void 0)t[0]===e.x&&t[1]===e.y&&t[2]===e.z||(r.uniform3f(this.addr,e.x,e.y,e.z),t[0]=e.x,t[1]=e.y,t[2]=e.z);else if(e.r!==void 0)t[0]===e.r&&t[1]===e.g&&t[2]===e.b||(r.uniform3f(this.addr,e.r,e.g,e.b),t[0]=e.r,t[1]=e.g,t[2]=e.b);else{if(yt(t,e))return;r.uniform3fv(this.addr,e),Mt(t,e)}}function Pm(r,e){let t=this.cache;if(e.x!==void 0)t[0]===e.x&&t[1]===e.y&&t[2]===e.z&&t[3]===e.w||(r.uniform4f(this.addr,e.x,e.y,e.z,e.w),t[0]=e.x,t[1]=e.y,t[2]=e.z,t[3]=e.w);else{if(yt(t,e))return;r.uniform4fv(this.addr,e),Mt(t,e)}}function Im(r,e){let t=this.cache,i=e.elements;if(i===void 0){if(yt(t,e))return;r.uniformMatrix2fv(this.addr,!1,e),Mt(t,e)}else{if(yt(t,i))return;Ud.set(i),r.uniformMatrix2fv(this.addr,!1,Ud),Mt(t,i)}}function Lm(r,e){let t=this.cache,i=e.elements;if(i===void 0){if(yt(t,e))return;r.uniformMatrix3fv(this.addr,!1,e),Mt(t,e)}else{if(yt(t,i))return;Dd.set(i),r.uniformMatrix3fv(this.addr,!1,Dd),Mt(t,i)}}function Nm(r,e){let t=this.cache,i=e.elements;if(i===void 0){if(yt(t,e))return;r.uniformMatrix4fv(this.addr,!1,e),Mt(t,e)}else{if(yt(t,i))return;Nd.set(i),r.uniformMatrix4fv(this.addr,!1,Nd),Mt(t,i)}}function Dm(r,e){let t=this.cache;t[0]!==e&&(r.uniform1i(this.addr,e),t[0]=e)}function Um(r,e){let t=this.cache;if(e.x!==void 0)t[0]===e.x&&t[1]===e.y||(r.uniform2i(this.addr,e.x,e.y),t[0]=e.x,t[1]=e.y);else{if(yt(t,e))return;r.uniform2iv(this.addr,e),Mt(t,e)}}function Fm(r,e){let t=this.cache;if(e.x!==void 0)t[0]===e.x&&t[1]===e.y&&t[2]===e.z||(r.uniform3i(this.addr,e.x,e.y,e.z),t[0]=e.x,t[1]=e.y,t[2]=e.z);else{if(yt(t,e))return;r.uniform3iv(this.addr,e),Mt(t,e)}}function Om(r,e){let t=this.cache;if(e.x!==void 0)t[0]===e.x&&t[1]===e.y&&t[2]===e.z&&t[3]===e.w||(r.uniform4i(this.addr,e.x,e.y,e.z,e.w),t[0]=e.x,t[1]=e.y,t[2]=e.z,t[3]=e.w);else{if(yt(t,e))return;r.uniform4iv(this.addr,e),Mt(t,e)}}function Bm(r,e){let t=this.cache;t[0]!==e&&(r.uniform1ui(this.addr,e),t[0]=e)}function zm(r,e){let t=this.cache;if(e.x!==void 0)t[0]===e.x&&t[1]===e.y||(r.uniform2ui(this.addr,e.x,e.y),t[0]=e.x,t[1]=e.y);else{if(yt(t,e))return;r.uniform2uiv(this.addr,e),Mt(t,e)}}function Gm(r,e){let t=this.cache;if(e.x!==void 0)t[0]===e.x&&t[1]===e.y&&t[2]===e.z||(r.uniform3ui(this.addr,e.x,e.y,e.z),t[0]=e.x,t[1]=e.y,t[2]=e.z);else{if(yt(t,e))return;r.uniform3uiv(this.addr,e),Mt(t,e)}}function Vm(r,e){let t=this.cache;if(e.x!==void 0)t[0]===e.x&&t[1]===e.y&&t[2]===e.z&&t[3]===e.w||(r.uniform4ui(this.addr,e.x,e.y,e.z,e.w),t[0]=e.x,t[1]=e.y,t[2]=e.z,t[3]=e.w);else{if(yt(t,e))return;r.uniform4uiv(this.addr,e),Mt(t,e)}}function Hm(r,e,t){let i=this.cache,n=t.allocateTextureUnit(),s;i[0]!==n&&(r.uniform1i(this.addr,n),i[0]=n),this.type===r.SAMPLER_2D_SHADOW?(lh.compareFunction=t.isReversedDepthBuffer()?Do:No,s=lh):s=Jd,t.setTexture2D(e||s,n)}function km(r,e,t){let i=this.cache,n=t.allocateTextureUnit();i[0]!==n&&(r.uniform1i(this.addr,n),i[0]=n),t.setTexture3D(e||$d,n)}function Wm(r,e,t){let i=this.cache,n=t.allocateTextureUnit();i[0]!==n&&(r.uniform1i(this.addr,n),i[0]=n),t.setTextureCube(e||Qd,n)}function Xm(r,e,t){let i=this.cache,n=t.allocateTextureUnit();i[0]!==n&&(r.uniform1i(this.addr,n),i[0]=n),t.setTexture2DArray(e||Kd,n)}function jm(r,e){r.uniform1fv(this.addr,e)}function qm(r,e){let t=Vr(e,this.size,2);r.uniform2fv(this.addr,t)}function Ym(r,e){let t=Vr(e,this.size,3);r.uniform3fv(this.addr,t)}function Zm(r,e){let t=Vr(e,this.size,4);r.uniform4fv(this.addr,t)}function Jm(r,e){let t=Vr(e,this.size,4);r.uniformMatrix2fv(this.addr,!1,t)}function Km(r,e){let t=Vr(e,this.size,9);r.uniformMatrix3fv(this.addr,!1,t)}function $m(r,e){let t=Vr(e,this.size,16);r.uniformMatrix4fv(this.addr,!1,t)}function Qm(r,e){r.uniform1iv(this.addr,e)}function ef(r,e){r.uniform2iv(this.addr,e)}function tf(r,e){r.uniform3iv(this.addr,e)}function nf(r,e){r.uniform4iv(this.addr,e)}function rf(r,e){r.uniform1uiv(this.addr,e)}function sf(r,e){r.uniform2uiv(this.addr,e)}function af(r,e){r.uniform3uiv(this.addr,e)}function of(r,e){r.uniform4uiv(this.addr,e)}function lf(r,e,t){let i=this.cache,n=e.length,s=Vo(t,n),a;yt(i,s)||(r.uniform1iv(this.addr,s),Mt(i,s)),a=this.type===r.SAMPLER_2D_SHADOW?lh:Jd;for(let o=0;o!==n;++o)t.setTexture2D(e[o]||a,s[o])}function cf(r,e,t){let i=this.cache,n=e.length,s=Vo(t,n);yt(i,s)||(r.uniform1iv(this.addr,s),Mt(i,s));for(let a=0;a!==n;++a)t.setTexture3D(e[a]||$d,s[a])}function hf(r,e,t){let i=this.cache,n=e.length,s=Vo(t,n);yt(i,s)||(r.uniform1iv(this.addr,s),Mt(i,s));for(let a=0;a!==n;++a)t.setTextureCube(e[a]||Qd,s[a])}function uf(r,e,t){let i=this.cache,n=e.length,s=Vo(t,n);yt(i,s)||(r.uniform1iv(this.addr,s),Mt(i,s));for(let a=0;a!==n;++a)t.setTexture2DArray(e[a]||Kd,s[a])}var ch=class{constructor(e,t,i){this.id=e,this.addr=i,this.cache=[],this.type=t.type,this.setValue=(function(n){switch(n){case 5126:return Am;case 35664:return Cm;case 35665:return Rm;case 35666:return Pm;case 35674:return Im;case 35675:return Lm;case 35676:return Nm;case 5124:case 35670:return Dm;case 35667:case 35671:return Um;case 35668:case 35672:return Fm;case 35669:case 35673:return Om;case 5125:return Bm;case 36294:return zm;case 36295:return Gm;case 36296:return Vm;case 35678:case 36198:case 36298:case 36306:case 35682:return Hm;case 35679:case 36299:case 36307:return km;case 35680:case 36300:case 36308:case 36293:return Wm;case 36289:case 36303:case 36311:case 36292:return Xm}})(t.type)}},hh=class{constructor(e,t,i){this.id=e,this.addr=i,this.cache=[],this.type=t.type,this.size=t.size,this.setValue=(function(n){switch(n){case 5126:return jm;case 35664:return qm;case 35665:return Ym;case 35666:return Zm;case 35674:return Jm;case 35675:return Km;case 35676:return $m;case 5124:case 35670:return Qm;case 35667:case 35671:return ef;case 35668:case 35672:return tf;case 35669:case 35673:return nf;case 5125:return rf;case 36294:return sf;case 36295:return af;case 36296:return of;case 35678:case 36198:case 36298:case 36306:case 35682:return lf;case 35679:case 36299:case 36307:return cf;case 35680:case 36300:case 36308:case 36293:return hf;case 36289:case 36303:case 36311:case 36292:return uf}})(t.type)}},uh=class{constructor(e){this.id=e,this.seq=[],this.map={}}setValue(e,t,i){let n=this.seq;for(let s=0,a=n.length;s!==a;++s){let o=n[s];o.setValue(e,t[o.id],i)}}},ah=/(\w+)(\])?(\[|\.)?/g;function Fd(r,e){r.seq.push(e),r.map[e.id]=e}function df(r,e,t){let i=r.name,n=i.length;for(ah.lastIndex=0;;){let s=ah.exec(i),a=ah.lastIndex,o=s[1],c=s[2]==="]",l=s[3];if(c&&(o|=0),l===void 0||l==="["&&a+2===n){Fd(t,l===void 0?new ch(o,r,e):new hh(o,r,e));break}{let h=t.map[o];h===void 0&&(h=new uh(o),Fd(t,h)),t=h}}}var Gr=class{constructor(e,t){this.seq=[],this.map={};let i=e.getProgramParameter(t,e.ACTIVE_UNIFORMS);for(let a=0;a<i;++a){let o=e.getActiveUniform(t,a);df(o,e.getUniformLocation(t,o.name),this)}let n=[],s=[];for(let a of this.seq)a.type===e.SAMPLER_2D_SHADOW||a.type===e.SAMPLER_CUBE_SHADOW||a.type===e.SAMPLER_2D_ARRAY_SHADOW?n.push(a):s.push(a);n.length>0&&(this.seq=n.concat(s))}setValue(e,t,i,n){let s=this.map[t];s!==void 0&&s.setValue(e,i,n)}setOptional(e,t,i){let n=t[i];n!==void 0&&this.setValue(e,i,n)}static upload(e,t,i,n){for(let s=0,a=t.length;s!==a;++s){let o=t[s],c=i[o.id];c.needsUpdate!==!1&&o.setValue(e,c.value,n)}}static seqWithValue(e,t){let i=[];for(let n=0,s=e.length;n!==s;++n){let a=e[n];a.id in t&&i.push(a)}return i}};function Od(r,e,t){let i=r.createShader(e);return r.shaderSource(i,t),r.compileShader(i),i}var pf=0,Bd=new Ne;function zd(r,e,t){let i=r.getShaderParameter(e,r.COMPILE_STATUS),n=(r.getShaderInfoLog(e)||"").trim();if(i&&n==="")return"";let s=/ERROR: 0:(\d+)/.exec(n);if(s){let a=parseInt(s[1]);return t.toUpperCase()+`

`+n+`

`+(function(o,c){let l=o.split(`
`),h=[],d=Math.max(c-6,0),p=Math.min(c+6,l.length);for(let u=d;u<p;u++){let g=u+1;h.push(`${g===c?">":" "} ${g}: ${l[u]}`)}return h.join(`
`)})(r.getShaderSource(e),a)}return n}function mf(r,e){let t=(function(i){He._getMatrix(Bd,He.workingColorSpace,i);let n=`mat3( ${Bd.elements.map(s=>s.toFixed(4))} )`;switch(He.getTransfer(i)){case os:return[n,"LinearTransferOETF"];case Ze:return[n,"sRGBTransferOETF"];default:return be("WebGLProgram: Unsupported color space: ",i),[n,"LinearTransferOETF"]}})(e);return[`vec4 ${r}( vec4 value ) {`,`	return ${t[1]}( vec4( value.rgb * ${t[0]}, value.a ) );`,"}"].join(`
`)}var ff={[sc]:"Linear",[ac]:"Reinhard",[oc]:"Cineon",[Ns]:"ACESFilmic",[cc]:"AgX",[hc]:"Neutral",[lc]:"Custom"};function gf(r,e){let t=ff[e];return t===void 0?(be("WebGLProgram: Unsupported toneMapping:",e),"vec3 "+r+"( vec3 color ) { return LinearToneMapping( color ); }"):"vec3 "+r+"( vec3 color ) { return "+t+"ToneMapping( color ); }"}var Fo=new w;function _f(){return He.getLuminanceCoefficients(Fo),["float luminance( const in vec3 rgb ) {",`	const vec3 weights = vec3( ${Fo.x.toFixed(4)}, ${Fo.y.toFixed(4)}, ${Fo.z.toFixed(4)} );`,"	return dot( weights, rgb );","}"].join(`
`)}function Bs(r){return r!==""}function Gd(r,e){let t=e.numSpotLightShadows+e.numSpotLightMaps-e.numSpotLightShadowsWithMaps;return r.replace(/NUM_DIR_LIGHTS/g,e.numDirLights).replace(/NUM_SPOT_LIGHTS/g,e.numSpotLights).replace(/NUM_SPOT_LIGHT_MAPS/g,e.numSpotLightMaps).replace(/NUM_SPOT_LIGHT_COORDS/g,t).replace(/NUM_RECT_AREA_LIGHTS/g,e.numRectAreaLights).replace(/NUM_POINT_LIGHTS/g,e.numPointLights).replace(/NUM_HEMI_LIGHTS/g,e.numHemiLights).replace(/NUM_DIR_LIGHT_SHADOWS/g,e.numDirLightShadows).replace(/NUM_SPOT_LIGHT_SHADOWS_WITH_MAPS/g,e.numSpotLightShadowsWithMaps).replace(/NUM_SPOT_LIGHT_SHADOWS/g,e.numSpotLightShadows).replace(/NUM_POINT_LIGHT_SHADOWS/g,e.numPointLightShadows)}function Vd(r,e){return r.replace(/NUM_CLIPPING_PLANES/g,e.numClippingPlanes).replace(/UNION_CLIPPING_PLANES/g,e.numClippingPlanes-e.numClipIntersection)}var vf=/^[ \t]*#include +<([\w\d./]+)>/gm;function dh(r){return r.replace(vf,yf)}var xf=new Map;function yf(r,e){let t=Be[e];if(t===void 0){let i=xf.get(e);if(i===void 0)throw new Error("THREE.WebGLProgram: Can not resolve #include <"+e+">");t=Be[i],be('WebGLRenderer: Shader chunk "%s" has been deprecated. Use "%s" instead.',e,i)}return dh(t)}var Mf=/#pragma unroll_loop_start\s+for\s*\(\s*int\s+i\s*=\s*(\d+)\s*;\s*i\s*<\s*(\d+)\s*;\s*i\s*\+\+\s*\)\s*{([\s\S]+?)}\s+#pragma unroll_loop_end/g;function Hd(r){return r.replace(Mf,Sf)}function Sf(r,e,t,i){let n="";for(let s=parseInt(e);s<parseInt(t);s++)n+=i.replace(/\[\s*i\s*\]/g,"[ "+s+" ]").replace(/UNROLLED_LOOP_INDEX/g,s);return n}function kd(r){let e=`precision ${r.precision} float;
	precision ${r.precision} int;
	precision ${r.precision} sampler2D;
	precision ${r.precision} samplerCube;
	precision ${r.precision} sampler3D;
	precision ${r.precision} sampler2DArray;
	precision ${r.precision} sampler2DShadow;
	precision ${r.precision} samplerCubeShadow;
	precision ${r.precision} sampler2DArrayShadow;
	precision ${r.precision} isampler2D;
	precision ${r.precision} isampler3D;
	precision ${r.precision} isamplerCube;
	precision ${r.precision} isampler2DArray;
	precision ${r.precision} usampler2D;
	precision ${r.precision} usampler3D;
	precision ${r.precision} usamplerCube;
	precision ${r.precision} usampler2DArray;
	`;return r.precision==="highp"?e+=`
#define HIGH_PRECISION`:r.precision==="mediump"?e+=`
#define MEDIUM_PRECISION`:r.precision==="lowp"&&(e+=`
#define LOW_PRECISION`),e}var bf={[Is]:"SHADOWMAP_TYPE_PCF",[Nr]:"SHADOWMAP_TYPE_VSM"},Tf={[Fr]:"ENVMAP_TYPE_CUBE",[Un]:"ENVMAP_TYPE_CUBE",[Ds]:"ENVMAP_TYPE_CUBE_UV"},Ef={[Un]:"ENVMAP_MODE_REFRACTION"},wf={[id]:"ENVMAP_BLENDING_MULTIPLY",[nd]:"ENVMAP_BLENDING_MIX",[rd]:"ENVMAP_BLENDING_ADD"};function Af(r,e,t,i){let n=r.getContext(),s=t.defines,a=t.vertexShader,o=t.fragmentShader,c=(function(B){return bf[B.shadowMapType]||"SHADOWMAP_TYPE_BASIC"})(t),l=(function(B){return B.envMap===!1?"ENVMAP_TYPE_CUBE":Tf[B.envMapMode]||"ENVMAP_TYPE_CUBE"})(t),h=(function(B){return B.envMap===!1?"ENVMAP_MODE_REFLECTION":Ef[B.envMapMode]||"ENVMAP_MODE_REFLECTION"})(t),d=(function(B){return B.envMap===!1?"ENVMAP_BLENDING_NONE":wf[B.combine]||"ENVMAP_BLENDING_NONE"})(t),p=(function(B){let U=B.envMapCubeUVHeight;if(U===null)return null;let X=Math.log2(U)-2,k=1/U;return{texelWidth:1/(3*Math.max(Math.pow(2,X),112)),texelHeight:k,maxMip:X}})(t),u=(function(B){return[B.extensionClipCullDistance?"#extension GL_ANGLE_clip_cull_distance : require":"",B.extensionMultiDraw?"#extension GL_ANGLE_multi_draw : require":""].filter(Bs).join(`
`)})(t),g=(function(B){let U=[];for(let X in B){let k=B[X];k!==!1&&U.push("#define "+X+" "+k)}return U.join(`
`)})(s),m=n.createProgram(),v,f,_=t.glslVersion?"#version "+t.glslVersion+`
`:"";t.isRawShaderMaterial?(v=["#define SHADER_TYPE "+t.shaderType,"#define SHADER_NAME "+t.shaderName,g].filter(Bs).join(`
`),v.length>0&&(v+=`
`),f=["#define SHADER_TYPE "+t.shaderType,"#define SHADER_NAME "+t.shaderName,g].filter(Bs).join(`
`),f.length>0&&(f+=`
`)):(v=[kd(t),"#define SHADER_TYPE "+t.shaderType,"#define SHADER_NAME "+t.shaderName,g,t.extensionClipCullDistance?"#define USE_CLIP_DISTANCE":"",t.batching?"#define USE_BATCHING":"",t.batchingColor?"#define USE_BATCHING_COLOR":"",t.instancing?"#define USE_INSTANCING":"",t.instancingColor?"#define USE_INSTANCING_COLOR":"",t.instancingMorph?"#define USE_INSTANCING_MORPH":"",t.useFog&&t.fog?"#define USE_FOG":"",t.useFog&&t.fogExp2?"#define FOG_EXP2":"",t.map?"#define USE_MAP":"",t.envMap?"#define USE_ENVMAP":"",t.envMap?"#define "+h:"",t.lightMap?"#define USE_LIGHTMAP":"",t.aoMap?"#define USE_AOMAP":"",t.bumpMap?"#define USE_BUMPMAP":"",t.normalMap?"#define USE_NORMALMAP":"",t.normalMapObjectSpace?"#define USE_NORMALMAP_OBJECTSPACE":"",t.normalMapTangentSpace?"#define USE_NORMALMAP_TANGENTSPACE":"",t.displacementMap?"#define USE_DISPLACEMENTMAP":"",t.emissiveMap?"#define USE_EMISSIVEMAP":"",t.anisotropy?"#define USE_ANISOTROPY":"",t.anisotropyMap?"#define USE_ANISOTROPYMAP":"",t.clearcoatMap?"#define USE_CLEARCOATMAP":"",t.clearcoatRoughnessMap?"#define USE_CLEARCOAT_ROUGHNESSMAP":"",t.clearcoatNormalMap?"#define USE_CLEARCOAT_NORMALMAP":"",t.iridescenceMap?"#define USE_IRIDESCENCEMAP":"",t.iridescenceThicknessMap?"#define USE_IRIDESCENCE_THICKNESSMAP":"",t.specularMap?"#define USE_SPECULARMAP":"",t.specularColorMap?"#define USE_SPECULAR_COLORMAP":"",t.specularIntensityMap?"#define USE_SPECULAR_INTENSITYMAP":"",t.roughnessMap?"#define USE_ROUGHNESSMAP":"",t.metalnessMap?"#define USE_METALNESSMAP":"",t.alphaMap?"#define USE_ALPHAMAP":"",t.alphaHash?"#define USE_ALPHAHASH":"",t.transmission?"#define USE_TRANSMISSION":"",t.transmissionMap?"#define USE_TRANSMISSIONMAP":"",t.thicknessMap?"#define USE_THICKNESSMAP":"",t.sheenColorMap?"#define USE_SHEEN_COLORMAP":"",t.sheenRoughnessMap?"#define USE_SHEEN_ROUGHNESSMAP":"",t.mapUv?"#define MAP_UV "+t.mapUv:"",t.alphaMapUv?"#define ALPHAMAP_UV "+t.alphaMapUv:"",t.lightMapUv?"#define LIGHTMAP_UV "+t.lightMapUv:"",t.aoMapUv?"#define AOMAP_UV "+t.aoMapUv:"",t.emissiveMapUv?"#define EMISSIVEMAP_UV "+t.emissiveMapUv:"",t.bumpMapUv?"#define BUMPMAP_UV "+t.bumpMapUv:"",t.normalMapUv?"#define NORMALMAP_UV "+t.normalMapUv:"",t.displacementMapUv?"#define DISPLACEMENTMAP_UV "+t.displacementMapUv:"",t.metalnessMapUv?"#define METALNESSMAP_UV "+t.metalnessMapUv:"",t.roughnessMapUv?"#define ROUGHNESSMAP_UV "+t.roughnessMapUv:"",t.anisotropyMapUv?"#define ANISOTROPYMAP_UV "+t.anisotropyMapUv:"",t.clearcoatMapUv?"#define CLEARCOATMAP_UV "+t.clearcoatMapUv:"",t.clearcoatNormalMapUv?"#define CLEARCOAT_NORMALMAP_UV "+t.clearcoatNormalMapUv:"",t.clearcoatRoughnessMapUv?"#define CLEARCOAT_ROUGHNESSMAP_UV "+t.clearcoatRoughnessMapUv:"",t.iridescenceMapUv?"#define IRIDESCENCEMAP_UV "+t.iridescenceMapUv:"",t.iridescenceThicknessMapUv?"#define IRIDESCENCE_THICKNESSMAP_UV "+t.iridescenceThicknessMapUv:"",t.sheenColorMapUv?"#define SHEEN_COLORMAP_UV "+t.sheenColorMapUv:"",t.sheenRoughnessMapUv?"#define SHEEN_ROUGHNESSMAP_UV "+t.sheenRoughnessMapUv:"",t.specularMapUv?"#define SPECULARMAP_UV "+t.specularMapUv:"",t.specularColorMapUv?"#define SPECULAR_COLORMAP_UV "+t.specularColorMapUv:"",t.specularIntensityMapUv?"#define SPECULAR_INTENSITYMAP_UV "+t.specularIntensityMapUv:"",t.transmissionMapUv?"#define TRANSMISSIONMAP_UV "+t.transmissionMapUv:"",t.thicknessMapUv?"#define THICKNESSMAP_UV "+t.thicknessMapUv:"",t.vertexTangents&&t.flatShading===!1?"#define USE_TANGENT":"",t.vertexNormals?"#define HAS_NORMAL":"",t.vertexColors?"#define USE_COLOR":"",t.vertexAlphas?"#define USE_COLOR_ALPHA":"",t.vertexUv1s?"#define USE_UV1":"",t.vertexUv2s?"#define USE_UV2":"",t.vertexUv3s?"#define USE_UV3":"",t.pointsUvs?"#define USE_POINTS_UV":"",t.flatShading?"#define FLAT_SHADED":"",t.skinning?"#define USE_SKINNING":"",t.morphTargets?"#define USE_MORPHTARGETS":"",t.morphNormals&&t.flatShading===!1?"#define USE_MORPHNORMALS":"",t.morphColors?"#define USE_MORPHCOLORS":"",t.morphTargetsCount>0?"#define MORPHTARGETS_TEXTURE_STRIDE "+t.morphTextureStride:"",t.morphTargetsCount>0?"#define MORPHTARGETS_COUNT "+t.morphTargetsCount:"",t.doubleSided?"#define DOUBLE_SIDED":"",t.flipSided?"#define FLIP_SIDED":"",t.shadowMapEnabled?"#define USE_SHADOWMAP":"",t.shadowMapEnabled?"#define "+c:"",t.sizeAttenuation?"#define USE_SIZEATTENUATION":"",t.numLightProbes>0?"#define USE_LIGHT_PROBES":"",t.logarithmicDepthBuffer?"#define USE_LOGARITHMIC_DEPTH_BUFFER":"",t.reversedDepthBuffer?"#define USE_REVERSED_DEPTH_BUFFER":"","uniform mat4 modelMatrix;","uniform mat4 modelViewMatrix;","uniform mat4 projectionMatrix;","uniform mat4 viewMatrix;","uniform mat3 normalMatrix;","uniform vec3 cameraPosition;","uniform bool isOrthographic;","#ifdef USE_INSTANCING","	attribute mat4 instanceMatrix;","#endif","#ifdef USE_INSTANCING_COLOR","	attribute vec3 instanceColor;","#endif","#ifdef USE_INSTANCING_MORPH","	uniform sampler2D morphTexture;","#endif","attribute vec3 position;","attribute vec3 normal;","attribute vec2 uv;","#ifdef USE_UV1","	attribute vec2 uv1;","#endif","#ifdef USE_UV2","	attribute vec2 uv2;","#endif","#ifdef USE_UV3","	attribute vec2 uv3;","#endif","#ifdef USE_TANGENT","	attribute vec4 tangent;","#endif","#if defined( USE_COLOR_ALPHA )","	attribute vec4 color;","#elif defined( USE_COLOR )","	attribute vec3 color;","#endif","#ifdef USE_SKINNING","	attribute vec4 skinIndex;","	attribute vec4 skinWeight;","#endif",`
`].filter(Bs).join(`
`),f=[kd(t),"#define SHADER_TYPE "+t.shaderType,"#define SHADER_NAME "+t.shaderName,g,t.useFog&&t.fog?"#define USE_FOG":"",t.useFog&&t.fogExp2?"#define FOG_EXP2":"",t.alphaToCoverage?"#define ALPHA_TO_COVERAGE":"",t.map?"#define USE_MAP":"",t.matcap?"#define USE_MATCAP":"",t.envMap?"#define USE_ENVMAP":"",t.envMap?"#define "+l:"",t.envMap?"#define "+h:"",t.envMap?"#define "+d:"",p?"#define CUBEUV_TEXEL_WIDTH "+p.texelWidth:"",p?"#define CUBEUV_TEXEL_HEIGHT "+p.texelHeight:"",p?"#define CUBEUV_MAX_MIP "+p.maxMip+".0":"",t.lightMap?"#define USE_LIGHTMAP":"",t.aoMap?"#define USE_AOMAP":"",t.bumpMap?"#define USE_BUMPMAP":"",t.normalMap?"#define USE_NORMALMAP":"",t.normalMapObjectSpace?"#define USE_NORMALMAP_OBJECTSPACE":"",t.normalMapTangentSpace?"#define USE_NORMALMAP_TANGENTSPACE":"",t.packedNormalMap?"#define USE_PACKED_NORMALMAP":"",t.emissiveMap?"#define USE_EMISSIVEMAP":"",t.anisotropy?"#define USE_ANISOTROPY":"",t.anisotropyMap?"#define USE_ANISOTROPYMAP":"",t.clearcoat?"#define USE_CLEARCOAT":"",t.clearcoatMap?"#define USE_CLEARCOATMAP":"",t.clearcoatRoughnessMap?"#define USE_CLEARCOAT_ROUGHNESSMAP":"",t.clearcoatNormalMap?"#define USE_CLEARCOAT_NORMALMAP":"",t.dispersion?"#define USE_DISPERSION":"",t.iridescence?"#define USE_IRIDESCENCE":"",t.iridescenceMap?"#define USE_IRIDESCENCEMAP":"",t.iridescenceThicknessMap?"#define USE_IRIDESCENCE_THICKNESSMAP":"",t.specularMap?"#define USE_SPECULARMAP":"",t.specularColorMap?"#define USE_SPECULAR_COLORMAP":"",t.specularIntensityMap?"#define USE_SPECULAR_INTENSITYMAP":"",t.roughnessMap?"#define USE_ROUGHNESSMAP":"",t.metalnessMap?"#define USE_METALNESSMAP":"",t.alphaMap?"#define USE_ALPHAMAP":"",t.alphaTest?"#define USE_ALPHATEST":"",t.alphaHash?"#define USE_ALPHAHASH":"",t.sheen?"#define USE_SHEEN":"",t.sheenColorMap?"#define USE_SHEEN_COLORMAP":"",t.sheenRoughnessMap?"#define USE_SHEEN_ROUGHNESSMAP":"",t.transmission?"#define USE_TRANSMISSION":"",t.transmissionMap?"#define USE_TRANSMISSIONMAP":"",t.thicknessMap?"#define USE_THICKNESSMAP":"",t.vertexTangents&&t.flatShading===!1?"#define USE_TANGENT":"",t.vertexColors||t.instancingColor?"#define USE_COLOR":"",t.vertexAlphas||t.batchingColor?"#define USE_COLOR_ALPHA":"",t.vertexUv1s?"#define USE_UV1":"",t.vertexUv2s?"#define USE_UV2":"",t.vertexUv3s?"#define USE_UV3":"",t.pointsUvs?"#define USE_POINTS_UV":"",t.gradientMap?"#define USE_GRADIENTMAP":"",t.flatShading?"#define FLAT_SHADED":"",t.doubleSided?"#define DOUBLE_SIDED":"",t.flipSided?"#define FLIP_SIDED":"",t.shadowMapEnabled?"#define USE_SHADOWMAP":"",t.shadowMapEnabled?"#define "+c:"",t.premultipliedAlpha?"#define PREMULTIPLIED_ALPHA":"",t.numLightProbes>0?"#define USE_LIGHT_PROBES":"",t.numLightProbeGrids>0?"#define USE_LIGHT_PROBES_GRID":"",t.decodeVideoTexture?"#define DECODE_VIDEO_TEXTURE":"",t.decodeVideoTextureEmissive?"#define DECODE_VIDEO_TEXTURE_EMISSIVE":"",t.logarithmicDepthBuffer?"#define USE_LOGARITHMIC_DEPTH_BUFFER":"",t.reversedDepthBuffer?"#define USE_REVERSED_DEPTH_BUFFER":"","uniform mat4 viewMatrix;","uniform vec3 cameraPosition;","uniform bool isOrthographic;",t.toneMapping!==gi?"#define TONE_MAPPING":"",t.toneMapping!==gi?Be.tonemapping_pars_fragment:"",t.toneMapping!==gi?gf("toneMapping",t.toneMapping):"",t.dithering?"#define DITHERING":"",t.opaque?"#define OPAQUE":"",Be.colorspace_pars_fragment,mf("linearToOutputTexel",t.outputColorSpace),_f(),t.useDepthPacking?"#define DEPTH_PACKING "+t.depthPacking:"",`
`].filter(Bs).join(`
`)),a=dh(a),a=Gd(a,t),a=Vd(a,t),o=dh(o),o=Gd(o,t),o=Vd(o,t),a=Hd(a),o=Hd(o),t.isRawShaderMaterial!==!0&&(_=`#version 300 es
`,v=[u,"#define attribute in","#define varying out","#define texture2D texture"].join(`
`)+`
`+v,f=["#define varying in",t.glslVersion===Jc?"":"layout(location = 0) out highp vec4 pc_fragColor;",t.glslVersion===Jc?"":"#define gl_FragColor pc_fragColor","#define gl_FragDepthEXT gl_FragDepth","#define texture2D texture","#define textureCube texture","#define texture2DProj textureProj","#define texture2DLodEXT textureLod","#define texture2DProjLodEXT textureProjLod","#define textureCubeLodEXT textureLod","#define texture2DGradEXT textureGrad","#define texture2DProjGradEXT textureProjGrad","#define textureCubeGradEXT textureGrad"].join(`
`)+`
`+f);let x=_+v+a,S=_+f+o,T=Od(n,n.VERTEX_SHADER,x),M=Od(n,n.FRAGMENT_SHADER,S);function P(B){if(r.debug.checkShaderErrors){let U=n.getProgramInfoLog(m)||"",X=n.getShaderInfoLog(T)||"",k=n.getShaderInfoLog(M)||"",V=U.trim(),Y=X.trim(),W=k.trim(),ne=!0,pe=!0;if(n.getProgramParameter(m,n.LINK_STATUS)===!1)if(ne=!1,typeof r.debug.onShaderError=="function")r.debug.onShaderError(n,m,T,M);else{let Ee=zd(n,T,"vertex"),_e=zd(n,M,"fragment");we("WebGLProgram: Shader Error "+n.getError()+" - VALIDATE_STATUS "+n.getProgramParameter(m,n.VALIDATE_STATUS)+`

Material Name: `+B.name+`
Material Type: `+B.type+`

Program Info Log: `+V+`
`+Ee+`
`+_e)}else V!==""?be("WebGLProgram: Program Info Log:",V):Y!==""&&W!==""||(pe=!1);pe&&(B.diagnostics={runnable:ne,programLog:V,vertexShader:{log:Y,prefix:v},fragmentShader:{log:W,prefix:f}})}n.deleteShader(T),n.deleteShader(M),O=new Gr(n,m),L=(function(U,X){let k={},V=U.getProgramParameter(X,U.ACTIVE_ATTRIBUTES);for(let Y=0;Y<V;Y++){let W=U.getActiveAttrib(X,Y),ne=W.name,pe=1;W.type===U.FLOAT_MAT2&&(pe=2),W.type===U.FLOAT_MAT3&&(pe=3),W.type===U.FLOAT_MAT4&&(pe=4),k[ne]={type:W.type,location:U.getAttribLocation(X,ne),locationSize:pe}}return k})(n,m)}let O,L;n.attachShader(m,T),n.attachShader(m,M),t.index0AttributeName!==void 0?n.bindAttribLocation(m,0,t.index0AttributeName):t.hasPositionAttribute===!0&&n.bindAttribLocation(m,0,"position"),n.linkProgram(m),this.getUniforms=function(){return O===void 0&&P(this),O},this.getAttributes=function(){return L===void 0&&P(this),L};let I=t.rendererExtensionParallelShaderCompile===!1;return this.isReady=function(){return I===!1&&(I=n.getProgramParameter(m,37297)),I},this.destroy=function(){i.releaseStatesOfProgram(this),n.deleteProgram(m),this.program=void 0},this.type=t.shaderType,this.name=t.shaderName,this.id=pf++,this.cacheKey=e,this.usedTimes=1,this.program=m,this.vertexShader=T,this.fragmentShader=M,this}var Cf=0,ph=class{constructor(){this.shaderCache=new Map,this.materialCache=new Map}update(e,t,i){let n=this._getShaderCacheForMaterial(e);return n.has(t)===!1&&(n.add(t),t.usedTimes++),n.has(i)===!1&&(n.add(i),i.usedTimes++),this}remove(e){let t=this.materialCache.get(e);for(let i of t)i.usedTimes--,i.usedTimes===0&&this.shaderCache.delete(i.code);return this.materialCache.delete(e),this}getVertexShaderStage(e){return this._getShaderStage(e.vertexShader)}getFragmentShaderStage(e){return this._getShaderStage(e.fragmentShader)}dispose(){this.shaderCache.clear(),this.materialCache.clear()}_getShaderCacheForMaterial(e){let t=this.materialCache,i=t.get(e);return i===void 0&&(i=new Set,t.set(e,i)),i}_getShaderStage(e){let t=this.shaderCache,i=t.get(e);return i===void 0&&(i=new mh(e),t.set(e,i)),i}},mh=class{constructor(e){this.id=Cf++,this.code=e,this.usedTimes=0}};function Rf(r,e,t,i,n,s){let a=new hs,o=new ph,c=new Set,l=[],h=new Map,d=i.logarithmicDepthBuffer,p=i.precision,u={MeshDepthMaterial:"depth",MeshDistanceMaterial:"distance",MeshNormalMaterial:"normal",MeshBasicMaterial:"basic",MeshLambertMaterial:"lambert",MeshPhongMaterial:"phong",MeshToonMaterial:"toon",MeshStandardMaterial:"physical",MeshPhysicalMaterial:"physical",MeshMatcapMaterial:"matcap",LineBasicMaterial:"basic",LineDashedMaterial:"dashed",PointsMaterial:"points",ShadowMaterial:"shadow",SpriteMaterial:"sprite"};function g(m){return c.add(m),m===0?"uv":`uv${m}`}return{getParameters:function(m,v,f,_,x,S){let T=_.fog,M=x.geometry,P=m.isMeshStandardMaterial||m.isMeshLambertMaterial||m.isMeshPhongMaterial?_.environment:null,O=m.isMeshStandardMaterial||m.isMeshLambertMaterial&&!m.envMap||m.isMeshPhongMaterial&&!m.envMap,L=e.get(m.envMap||P,O),I=L&&L.mapping===Ds?L.image.height:null,B=u[m.type];m.precision!==null&&(p=i.getMaxPrecision(m.precision),p!==m.precision&&be("WebGLProgram.getParameters:",m.precision,"not supported, using",p,"instead."));let U=M.morphAttributes.position||M.morphAttributes.normal||M.morphAttributes.color,X=U!==void 0?U.length:0,k,V,Y,W,ne=0;if(M.morphAttributes.position!==void 0&&(ne=1),M.morphAttributes.normal!==void 0&&(ne=2),M.morphAttributes.color!==void 0&&(ne=3),B){let ri=Di[B];k=ri.vertexShader,V=ri.fragmentShader}else{k=m.vertexShader,V=m.fragmentShader;let ri=o.getVertexShaderStage(m),Sn=o.getFragmentShaderStage(m);o.update(m,ri,Sn),Y=ri.id,W=Sn.id}let pe=r.getRenderTarget(),Ee=r.state.buffers.depth.getReversed(),_e=x.isInstancedMesh===!0,ve=x.isBatchedMesh===!0,ie=!!m.map,he=!!m.matcap,le=!!L,fe=!!m.aoMap,Ue=!!m.lightMap,$=!!m.bumpMap&&m.wireframe===!1,R=!!m.normalMap,b=!!m.displacementMap,C=!!m.emissiveMap,F=!!m.metalnessMap,y=!!m.roughnessMap,D=m.anisotropy>0,N=m.clearcoat>0,A=m.dispersion>0,H=m.iridescence>0,j=m.sheen>0,Z=m.transmission>0,se=D&&!!m.anisotropyMap,xe=N&&!!m.clearcoatMap,ye=N&&!!m.clearcoatNormalMap,ue=N&&!!m.clearcoatRoughnessMap,Ce=H&&!!m.iridescenceMap,ee=H&&!!m.iridescenceThicknessMap,ae=j&&!!m.sheenColorMap,re=j&&!!m.sheenRoughnessMap,me=!!m.specularMap,et=!!m.specularColorMap,Ye=!!m.specularIntensityMap,ct=Z&&!!m.transmissionMap,Ot=Z&&!!m.thicknessMap,Se=!!m.gradientMap,Je=!!m.alphaMap,ze=m.alphaTest>0,At=!!m.alphaHash,tt=!!m.extensions,vt=gi;m.toneMapped&&(pe!==null&&pe.isXRRenderTarget!==!0||(vt=r.toneMapping));let ot={shaderID:B,shaderType:m.type,shaderName:m.name,vertexShader:k,fragmentShader:V,defines:m.defines,customVertexShaderID:Y,customFragmentShaderID:W,isRawShaderMaterial:m.isRawShaderMaterial===!0,glslVersion:m.glslVersion,precision:p,batching:ve,batchingColor:ve&&x._colorsTexture!==null,instancing:_e,instancingColor:_e&&x.instanceColor!==null,instancingMorph:_e&&x.morphTexture!==null,outputColorSpace:pe===null?r.outputColorSpace:pe.isXRRenderTarget===!0?pe.texture.colorSpace:He.workingColorSpace,alphaToCoverage:!!m.alphaToCoverage,map:ie,matcap:he,envMap:le,envMapMode:le&&L.mapping,envMapCubeUVHeight:I,aoMap:fe,lightMap:Ue,bumpMap:$,normalMap:R,displacementMap:b,emissiveMap:C,normalMapObjectSpace:R&&m.normalMapType===ld,normalMapTangentSpace:R&&m.normalMapType===Zc,packedNormalMap:R&&m.normalMapType===Zc&&($t=m.normalMap.format,$t===Bn||$t===Io||$t===Lo),metalnessMap:F,roughnessMap:y,anisotropy:D,anisotropyMap:se,clearcoat:N,clearcoatMap:xe,clearcoatNormalMap:ye,clearcoatRoughnessMap:ue,dispersion:A,iridescence:H,iridescenceMap:Ce,iridescenceThicknessMap:ee,sheen:j,sheenColorMap:ae,sheenRoughnessMap:re,specularMap:me,specularColorMap:et,specularIntensityMap:Ye,transmission:Z,transmissionMap:ct,thicknessMap:Ot,gradientMap:Se,opaque:m.transparent===!1&&m.blending===Ls&&m.alphaToCoverage===!1,alphaMap:Je,alphaTest:ze,alphaHash:At,combine:m.combine,mapUv:ie&&g(m.map.channel),aoMapUv:fe&&g(m.aoMap.channel),lightMapUv:Ue&&g(m.lightMap.channel),bumpMapUv:$&&g(m.bumpMap.channel),normalMapUv:R&&g(m.normalMap.channel),displacementMapUv:b&&g(m.displacementMap.channel),emissiveMapUv:C&&g(m.emissiveMap.channel),metalnessMapUv:F&&g(m.metalnessMap.channel),roughnessMapUv:y&&g(m.roughnessMap.channel),anisotropyMapUv:se&&g(m.anisotropyMap.channel),clearcoatMapUv:xe&&g(m.clearcoatMap.channel),clearcoatNormalMapUv:ye&&g(m.clearcoatNormalMap.channel),clearcoatRoughnessMapUv:ue&&g(m.clearcoatRoughnessMap.channel),iridescenceMapUv:Ce&&g(m.iridescenceMap.channel),iridescenceThicknessMapUv:ee&&g(m.iridescenceThicknessMap.channel),sheenColorMapUv:ae&&g(m.sheenColorMap.channel),sheenRoughnessMapUv:re&&g(m.sheenRoughnessMap.channel),specularMapUv:me&&g(m.specularMap.channel),specularColorMapUv:et&&g(m.specularColorMap.channel),specularIntensityMapUv:Ye&&g(m.specularIntensityMap.channel),transmissionMapUv:ct&&g(m.transmissionMap.channel),thicknessMapUv:Ot&&g(m.thicknessMap.channel),alphaMapUv:Je&&g(m.alphaMap.channel),vertexTangents:!!M.attributes.tangent&&(R||D),vertexNormals:!!M.attributes.normal,vertexColors:m.vertexColors,vertexAlphas:m.vertexColors===!0&&!!M.attributes.color&&M.attributes.color.itemSize===4,pointsUvs:x.isPoints===!0&&!!M.attributes.uv&&(ie||Je),fog:!!T,useFog:m.fog===!0,fogExp2:!!T&&T.isFogExp2,flatShading:m.wireframe===!1&&(m.flatShading===!0||M.attributes.normal===void 0&&R===!1&&(m.isMeshLambertMaterial||m.isMeshPhongMaterial||m.isMeshStandardMaterial||m.isMeshPhysicalMaterial)),sizeAttenuation:m.sizeAttenuation===!0,logarithmicDepthBuffer:d,reversedDepthBuffer:Ee,skinning:x.isSkinnedMesh===!0,hasPositionAttribute:M.attributes.position!==void 0,morphTargets:M.morphAttributes.position!==void 0,morphNormals:M.morphAttributes.normal!==void 0,morphColors:M.morphAttributes.color!==void 0,morphTargetsCount:X,morphTextureStride:ne,numDirLights:v.directional.length,numPointLights:v.point.length,numSpotLights:v.spot.length,numSpotLightMaps:v.spotLightMap.length,numRectAreaLights:v.rectArea.length,numHemiLights:v.hemi.length,numDirLightShadows:v.directionalShadowMap.length,numPointLightShadows:v.pointShadowMap.length,numSpotLightShadows:v.spotShadowMap.length,numSpotLightShadowsWithMaps:v.numSpotLightShadowsWithMaps,numLightProbes:v.numLightProbes,numLightProbeGrids:S.length,numClippingPlanes:s.numPlanes,numClipIntersection:s.numIntersection,dithering:m.dithering,shadowMapEnabled:r.shadowMap.enabled&&f.length>0,shadowMapType:r.shadowMap.type,toneMapping:vt,decodeVideoTexture:ie&&m.map.isVideoTexture===!0&&He.getTransfer(m.map.colorSpace)===Ze,decodeVideoTextureEmissive:C&&m.emissiveMap.isVideoTexture===!0&&He.getTransfer(m.emissiveMap.colorSpace)===Ze,premultipliedAlpha:m.premultipliedAlpha,doubleSided:m.side===Vt,flipSided:m.side===Gt,useDepthPacking:m.depthPacking>=0,depthPacking:m.depthPacking||0,index0AttributeName:m.index0AttributeName,extensionClipCullDistance:tt&&m.extensions.clipCullDistance===!0&&t.has("WEBGL_clip_cull_distance"),extensionMultiDraw:(tt&&m.extensions.multiDraw===!0||ve)&&t.has("WEBGL_multi_draw"),rendererExtensionParallelShaderCompile:t.has("KHR_parallel_shader_compile"),customProgramCacheKey:m.customProgramCacheKey()};var $t;return ot.vertexUv1s=c.has(1),ot.vertexUv2s=c.has(2),ot.vertexUv3s=c.has(3),c.clear(),ot},getProgramCacheKey:function(m){let v=[];if(m.shaderID?v.push(m.shaderID):(v.push(m.customVertexShaderID),v.push(m.customFragmentShaderID)),m.defines!==void 0)for(let f in m.defines)v.push(f),v.push(m.defines[f]);return m.isRawShaderMaterial===!1&&((function(f,_){f.push(_.precision),f.push(_.outputColorSpace),f.push(_.envMapMode),f.push(_.envMapCubeUVHeight),f.push(_.mapUv),f.push(_.alphaMapUv),f.push(_.lightMapUv),f.push(_.aoMapUv),f.push(_.bumpMapUv),f.push(_.normalMapUv),f.push(_.displacementMapUv),f.push(_.emissiveMapUv),f.push(_.metalnessMapUv),f.push(_.roughnessMapUv),f.push(_.anisotropyMapUv),f.push(_.clearcoatMapUv),f.push(_.clearcoatNormalMapUv),f.push(_.clearcoatRoughnessMapUv),f.push(_.iridescenceMapUv),f.push(_.iridescenceThicknessMapUv),f.push(_.sheenColorMapUv),f.push(_.sheenRoughnessMapUv),f.push(_.specularMapUv),f.push(_.specularColorMapUv),f.push(_.specularIntensityMapUv),f.push(_.transmissionMapUv),f.push(_.thicknessMapUv),f.push(_.combine),f.push(_.fogExp2),f.push(_.sizeAttenuation),f.push(_.morphTargetsCount),f.push(_.morphAttributeCount),f.push(_.numDirLights),f.push(_.numPointLights),f.push(_.numSpotLights),f.push(_.numSpotLightMaps),f.push(_.numHemiLights),f.push(_.numRectAreaLights),f.push(_.numDirLightShadows),f.push(_.numPointLightShadows),f.push(_.numSpotLightShadows),f.push(_.numSpotLightShadowsWithMaps),f.push(_.numLightProbes),f.push(_.shadowMapType),f.push(_.toneMapping),f.push(_.numClippingPlanes),f.push(_.numClipIntersection),f.push(_.depthPacking)})(v,m),(function(f,_){a.disableAll(),_.instancing&&a.enable(0),_.instancingColor&&a.enable(1),_.instancingMorph&&a.enable(2),_.matcap&&a.enable(3),_.envMap&&a.enable(4),_.normalMapObjectSpace&&a.enable(5),_.normalMapTangentSpace&&a.enable(6),_.clearcoat&&a.enable(7),_.iridescence&&a.enable(8),_.alphaTest&&a.enable(9),_.vertexColors&&a.enable(10),_.vertexAlphas&&a.enable(11),_.vertexUv1s&&a.enable(12),_.vertexUv2s&&a.enable(13),_.vertexUv3s&&a.enable(14),_.vertexTangents&&a.enable(15),_.anisotropy&&a.enable(16),_.alphaHash&&a.enable(17),_.batching&&a.enable(18),_.dispersion&&a.enable(19),_.batchingColor&&a.enable(20),_.gradientMap&&a.enable(21),_.packedNormalMap&&a.enable(22),_.vertexNormals&&a.enable(23),f.push(a.mask),a.disableAll(),_.fog&&a.enable(0),_.useFog&&a.enable(1),_.flatShading&&a.enable(2),_.logarithmicDepthBuffer&&a.enable(3),_.reversedDepthBuffer&&a.enable(4),_.skinning&&a.enable(5),_.morphTargets&&a.enable(6),_.morphNormals&&a.enable(7),_.morphColors&&a.enable(8),_.premultipliedAlpha&&a.enable(9),_.shadowMapEnabled&&a.enable(10),_.doubleSided&&a.enable(11),_.flipSided&&a.enable(12),_.useDepthPacking&&a.enable(13),_.dithering&&a.enable(14),_.transmission&&a.enable(15),_.sheen&&a.enable(16),_.opaque&&a.enable(17),_.pointsUvs&&a.enable(18),_.decodeVideoTexture&&a.enable(19),_.decodeVideoTextureEmissive&&a.enable(20),_.alphaToCoverage&&a.enable(21),_.numLightProbeGrids>0&&a.enable(22),_.hasPositionAttribute&&a.enable(23),f.push(a.mask)})(v,m),v.push(r.outputColorSpace)),v.push(m.customProgramCacheKey),v.join()},getUniforms:function(m){let v=u[m.type],f;if(v){let _=Di[v];f=Td.clone(_.uniforms)}else f=m.uniforms;return f},acquireProgram:function(m,v){let f=h.get(v);return f!==void 0?++f.usedTimes:(f=new Af(r,v,m,n),l.push(f),h.set(v,f)),f},releaseProgram:function(m){if(--m.usedTimes===0){let v=l.indexOf(m);l[v]=l[l.length-1],l.pop(),h.delete(m.cacheKey),m.destroy()}},releaseShaderCache:function(m){o.remove(m)},programs:l,dispose:function(){o.dispose()}}}function Pf(){let r=new WeakMap;return{has:function(e){return r.has(e)},get:function(e){let t=r.get(e);return t===void 0&&(t={},r.set(e,t)),t},remove:function(e){r.delete(e)},update:function(e,t,i){r.get(e)[t]=i},dispose:function(){r=new WeakMap}}}function If(r,e){return r.groupOrder!==e.groupOrder?r.groupOrder-e.groupOrder:r.renderOrder!==e.renderOrder?r.renderOrder-e.renderOrder:r.material.id!==e.material.id?r.material.id-e.material.id:r.materialVariant!==e.materialVariant?r.materialVariant-e.materialVariant:r.z!==e.z?r.z-e.z:r.id-e.id}function Wd(r,e){return r.groupOrder!==e.groupOrder?r.groupOrder-e.groupOrder:r.renderOrder!==e.renderOrder?r.renderOrder-e.renderOrder:r.z!==e.z?e.z-r.z:r.id-e.id}function Xd(){let r=[],e=0,t=[],i=[],n=[];function s(o){let c=0;return o.isInstancedMesh&&(c+=2),o.isSkinnedMesh&&(c+=1),c}function a(o,c,l,h,d,p){let u=r[e];return u===void 0?(u={id:o.id,object:o,geometry:c,material:l,materialVariant:s(o),groupOrder:h,renderOrder:o.renderOrder,z:d,group:p},r[e]=u):(u.id=o.id,u.object=o,u.geometry=c,u.material=l,u.materialVariant=s(o),u.groupOrder=h,u.renderOrder=o.renderOrder,u.z=d,u.group=p),e++,u}return{opaque:t,transmissive:i,transparent:n,init:function(){e=0,t.length=0,i.length=0,n.length=0},push:function(o,c,l,h,d,p){let u=a(o,c,l,h,d,p);l.transmission>0?i.push(u):l.transparent===!0?n.push(u):t.push(u)},unshift:function(o,c,l,h,d,p){let u=a(o,c,l,h,d,p);l.transmission>0?i.unshift(u):l.transparent===!0?n.unshift(u):t.unshift(u)},finish:function(){for(let o=e,c=r.length;o<c;o++){let l=r[o];if(l.id===null)break;l.id=null,l.object=null,l.geometry=null,l.material=null,l.group=null}},sort:function(o,c,l){t.length>1&&t.sort(o||If),i.length>1&&i.sort(c||Wd),n.length>1&&n.sort(c||Wd),l&&(t.reverse(),i.reverse(),n.reverse())}}}function Lf(){let r=new WeakMap;return{get:function(e,t){let i=r.get(e),n;return i===void 0?(n=new Xd,r.set(e,[n])):t>=i.length?(n=new Xd,i.push(n)):n=i[t],n},dispose:function(){r=new WeakMap}}}function Nf(){let r={};return{get:function(e){if(r[e.id]!==void 0)return r[e.id];let t;switch(e.type){case"DirectionalLight":t={direction:new w,color:new Ie};break;case"SpotLight":t={position:new w,direction:new w,color:new Ie,distance:0,coneCos:0,penumbraCos:0,decay:0};break;case"PointLight":t={position:new w,color:new Ie,distance:0,decay:0};break;case"HemisphereLight":t={direction:new w,skyColor:new Ie,groundColor:new Ie};break;case"RectAreaLight":t={color:new Ie,position:new w,halfWidth:new w,halfHeight:new w}}return r[e.id]=t,t}}}var Df=0;function Uf(r,e){return(e.castShadow?2:0)-(r.castShadow?2:0)+(e.map?1:0)-(r.map?1:0)}function Ff(r){let e=new Nf,t=(function(){let o={};return{get:function(c){if(o[c.id]!==void 0)return o[c.id];let l;switch(c.type){case"DirectionalLight":case"SpotLight":l={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new te};break;case"PointLight":l={shadowIntensity:1,shadowBias:0,shadowNormalBias:0,shadowRadius:1,shadowMapSize:new te,shadowCameraNear:1,shadowCameraFar:1e3}}return o[c.id]=l,l}}})(),i={version:0,hash:{directionalLength:-1,pointLength:-1,spotLength:-1,rectAreaLength:-1,hemiLength:-1,numDirectionalShadows:-1,numPointShadows:-1,numSpotShadows:-1,numSpotMaps:-1,numLightProbes:-1},ambient:[0,0,0],probe:[],directional:[],directionalShadow:[],directionalShadowMap:[],directionalShadowMatrix:[],spot:[],spotLightMap:[],spotShadow:[],spotShadowMap:[],spotLightMatrix:[],rectArea:[],rectAreaLTC1:null,rectAreaLTC2:null,point:[],pointShadow:[],pointShadowMap:[],pointShadowMatrix:[],hemi:[],numSpotLightShadowsWithMaps:0,numLightProbes:0};for(let o=0;o<9;o++)i.probe.push(new w);let n=new w,s=new Fe,a=new Fe;return{setup:function(o){let c=0,l=0,h=0;for(let P=0;P<9;P++)i.probe[P].set(0,0,0);let d=0,p=0,u=0,g=0,m=0,v=0,f=0,_=0,x=0,S=0,T=0;o.sort(Uf);for(let P=0,O=o.length;P<O;P++){let L=o[P],I=L.color,B=L.intensity,U=L.distance,X=null;if(L.shadow&&L.shadow.map&&(X=L.shadow.map.texture.format===Bn?L.shadow.map.texture:L.shadow.map.depthTexture||L.shadow.map.texture),L.isAmbientLight)c+=I.r*B,l+=I.g*B,h+=I.b*B;else if(L.isLightProbe){for(let k=0;k<9;k++)i.probe[k].addScaledVector(L.sh.coefficients[k],B);T++}else if(L.isDirectionalLight){let k=e.get(L);if(k.color.copy(L.color).multiplyScalar(L.intensity),L.castShadow){let V=L.shadow,Y=t.get(L);Y.shadowIntensity=V.intensity,Y.shadowBias=V.bias,Y.shadowNormalBias=V.normalBias,Y.shadowRadius=V.radius,Y.shadowMapSize=V.mapSize,i.directionalShadow[d]=Y,i.directionalShadowMap[d]=X,i.directionalShadowMatrix[d]=L.shadow.matrix,v++}i.directional[d]=k,d++}else if(L.isSpotLight){let k=e.get(L);k.position.setFromMatrixPosition(L.matrixWorld),k.color.copy(I).multiplyScalar(B),k.distance=U,k.coneCos=Math.cos(L.angle),k.penumbraCos=Math.cos(L.angle*(1-L.penumbra)),k.decay=L.decay,i.spot[u]=k;let V=L.shadow;if(L.map&&(i.spotLightMap[x]=L.map,x++,V.updateMatrices(L),L.castShadow&&S++),i.spotLightMatrix[u]=V.matrix,L.castShadow){let Y=t.get(L);Y.shadowIntensity=V.intensity,Y.shadowBias=V.bias,Y.shadowNormalBias=V.normalBias,Y.shadowRadius=V.radius,Y.shadowMapSize=V.mapSize,i.spotShadow[u]=Y,i.spotShadowMap[u]=X,_++}u++}else if(L.isRectAreaLight){let k=e.get(L);k.color.copy(I).multiplyScalar(B),k.halfWidth.set(.5*L.width,0,0),k.halfHeight.set(0,.5*L.height,0),i.rectArea[g]=k,g++}else if(L.isPointLight){let k=e.get(L);if(k.color.copy(L.color).multiplyScalar(L.intensity),k.distance=L.distance,k.decay=L.decay,L.castShadow){let V=L.shadow,Y=t.get(L);Y.shadowIntensity=V.intensity,Y.shadowBias=V.bias,Y.shadowNormalBias=V.normalBias,Y.shadowRadius=V.radius,Y.shadowMapSize=V.mapSize,Y.shadowCameraNear=V.camera.near,Y.shadowCameraFar=V.camera.far,i.pointShadow[p]=Y,i.pointShadowMap[p]=X,i.pointShadowMatrix[p]=L.shadow.matrix,f++}i.point[p]=k,p++}else if(L.isHemisphereLight){let k=e.get(L);k.skyColor.copy(L.color).multiplyScalar(B),k.groundColor.copy(L.groundColor).multiplyScalar(B),i.hemi[m]=k,m++}}g>0&&(r.has("OES_texture_float_linear")===!0?(i.rectAreaLTC1=ce.LTC_FLOAT_1,i.rectAreaLTC2=ce.LTC_FLOAT_2):(i.rectAreaLTC1=ce.LTC_HALF_1,i.rectAreaLTC2=ce.LTC_HALF_2)),i.ambient[0]=c,i.ambient[1]=l,i.ambient[2]=h;let M=i.hash;M.directionalLength===d&&M.pointLength===p&&M.spotLength===u&&M.rectAreaLength===g&&M.hemiLength===m&&M.numDirectionalShadows===v&&M.numPointShadows===f&&M.numSpotShadows===_&&M.numSpotMaps===x&&M.numLightProbes===T||(i.directional.length=d,i.spot.length=u,i.rectArea.length=g,i.point.length=p,i.hemi.length=m,i.directionalShadow.length=v,i.directionalShadowMap.length=v,i.pointShadow.length=f,i.pointShadowMap.length=f,i.spotShadow.length=_,i.spotShadowMap.length=_,i.directionalShadowMatrix.length=v,i.pointShadowMatrix.length=f,i.spotLightMatrix.length=_+x-S,i.spotLightMap.length=x,i.numSpotLightShadowsWithMaps=S,i.numLightProbes=T,M.directionalLength=d,M.pointLength=p,M.spotLength=u,M.rectAreaLength=g,M.hemiLength=m,M.numDirectionalShadows=v,M.numPointShadows=f,M.numSpotShadows=_,M.numSpotMaps=x,M.numLightProbes=T,i.version=Df++)},setupView:function(o,c){let l=0,h=0,d=0,p=0,u=0,g=c.matrixWorldInverse;for(let m=0,v=o.length;m<v;m++){let f=o[m];if(f.isDirectionalLight){let _=i.directional[l];_.direction.setFromMatrixPosition(f.matrixWorld),n.setFromMatrixPosition(f.target.matrixWorld),_.direction.sub(n),_.direction.transformDirection(g),l++}else if(f.isSpotLight){let _=i.spot[d];_.position.setFromMatrixPosition(f.matrixWorld),_.position.applyMatrix4(g),_.direction.setFromMatrixPosition(f.matrixWorld),n.setFromMatrixPosition(f.target.matrixWorld),_.direction.sub(n),_.direction.transformDirection(g),d++}else if(f.isRectAreaLight){let _=i.rectArea[p];_.position.setFromMatrixPosition(f.matrixWorld),_.position.applyMatrix4(g),a.identity(),s.copy(f.matrixWorld),s.premultiply(g),a.extractRotation(s),_.halfWidth.set(.5*f.width,0,0),_.halfHeight.set(0,.5*f.height,0),_.halfWidth.applyMatrix4(a),_.halfHeight.applyMatrix4(a),p++}else if(f.isPointLight){let _=i.point[h];_.position.setFromMatrixPosition(f.matrixWorld),_.position.applyMatrix4(g),h++}else if(f.isHemisphereLight){let _=i.hemi[u];_.direction.setFromMatrixPosition(f.matrixWorld),_.direction.transformDirection(g),u++}}},state:i}}function jd(r){let e=new Ff(r),t=[],i=[],n=[],s={lightsArray:t,shadowsArray:i,lightProbeGridArray:n,camera:null,lights:e,transmissionRenderTarget:{},textureUnits:0};return{init:function(a){s.camera=a,t.length=0,i.length=0,n.length=0},state:s,setupLights:function(){e.setup(t)},setupLightsView:function(a){e.setupView(t,a)},pushLight:function(a){t.push(a)},pushShadow:function(a){i.push(a)},pushLightProbeGrid:function(a){n.push(a)}}}function Of(r){let e=new WeakMap;return{get:function(t,i=0){let n=e.get(t),s;return n===void 0?(s=new jd(r),e.set(t,[s])):i>=n.length?(s=new jd(r),n.push(s)):s=n[i],s},dispose:function(){e=new WeakMap}}}var Bf=[new w(1,0,0),new w(-1,0,0),new w(0,1,0),new w(0,-1,0),new w(0,0,1),new w(0,0,-1)],zf=[new w(0,-1,0),new w(0,-1,0),new w(0,0,1),new w(0,0,-1),new w(0,-1,0),new w(0,-1,0)],qd=new Fe,zs=new w,oh=new w;function Gf(r,e,t){let i=new ji,n=new te,s=new te,a=new $e,o=new no,c=new ro,l={},h=t.maxTextureSize,d={[Dr]:Gt,[Gt]:Dr,[Vt]:Vt},p=new zt({defines:{VSM_SAMPLES:8},uniforms:{shadow_pass:{value:null},resolution:{value:new te},radius:{value:4}},vertexShader:`void main() {
	gl_Position = vec4( position, 1.0 );
}`,fragmentShader:`uniform sampler2D shadow_pass;
uniform vec2 resolution;
uniform float radius;
void main() {
	const float samples = float( VSM_SAMPLES );
	float mean = 0.0;
	float squared_mean = 0.0;
	float uvStride = samples <= 1.0 ? 0.0 : 2.0 / ( samples - 1.0 );
	float uvStart = samples <= 1.0 ? 0.0 : - 1.0;
	for ( float i = 0.0; i < samples; i ++ ) {
		float uvOffset = uvStart + i * uvStride;
		#ifdef HORIZONTAL_PASS
			vec2 distribution = texture2D( shadow_pass, ( gl_FragCoord.xy + vec2( uvOffset, 0.0 ) * radius ) / resolution ).rg;
			mean += distribution.x;
			squared_mean += distribution.y * distribution.y + distribution.x * distribution.x;
		#else
			float depth = texture2D( shadow_pass, ( gl_FragCoord.xy + vec2( 0.0, uvOffset ) * radius ) / resolution ).r;
			mean += depth;
			squared_mean += depth * depth;
		#endif
	}
	mean = mean / samples;
	squared_mean = squared_mean / samples;
	float std_dev = sqrt( max( 0.0, squared_mean - mean * mean ) );
	gl_FragColor = vec4( mean, std_dev, 0.0, 1.0 );
}`}),u=p.clone();u.defines.HORIZONTAL_PASS=1;let g=new Xe;g.setAttribute("position",new ft(new Float32Array([-1,-1,.5,3,-1,.5,-1,3,.5]),3));let m=new Oe(g,p),v=this;this.enabled=!1,this.autoUpdate=!0,this.needsUpdate=!1,this.type=Is;let f=this.type;function _(M,P){let O=e.update(m);p.defines.VSM_SAMPLES!==M.blurSamples&&(p.defines.VSM_SAMPLES=M.blurSamples,u.defines.VSM_SAMPLES=M.blurSamples,p.needsUpdate=!0,u.needsUpdate=!0),M.mapPass===null&&(M.mapPass=new jt(n.x,n.y,{format:Bn,type:Li})),p.uniforms.shadow_pass.value=M.map.depthTexture,p.uniforms.resolution.value=M.mapSize,p.uniforms.radius.value=M.radius,r.setRenderTarget(M.mapPass),r.clear(),r.renderBufferDirect(P,null,O,p,m,null),u.uniforms.shadow_pass.value=M.mapPass.texture,u.uniforms.resolution.value=M.mapSize,u.uniforms.radius.value=M.radius,r.setRenderTarget(M.map),r.clear(),r.renderBufferDirect(P,null,O,u,m,null)}function x(M,P,O,L){let I=null,B=O.isPointLight===!0?M.customDistanceMaterial:M.customDepthMaterial;if(B!==void 0)I=B;else if(I=O.isPointLight===!0?c:o,r.localClippingEnabled&&P.clipShadows===!0&&Array.isArray(P.clippingPlanes)&&P.clippingPlanes.length!==0||P.displacementMap&&P.displacementScale!==0||P.alphaMap&&P.alphaTest>0||P.map&&P.alphaTest>0||P.alphaToCoverage===!0){let U=I.uuid,X=P.uuid,k=l[U];k===void 0&&(k={},l[U]=k);let V=k[X];V===void 0&&(V=I.clone(),k[X]=V,P.addEventListener("dispose",T)),I=V}return I.visible=P.visible,I.wireframe=P.wireframe,I.side=L===Nr?P.shadowSide!==null?P.shadowSide:P.side:P.shadowSide!==null?P.shadowSide:d[P.side],I.alphaMap=P.alphaMap,I.alphaTest=P.alphaToCoverage===!0?.5:P.alphaTest,I.map=P.map,I.clipShadows=P.clipShadows,I.clippingPlanes=P.clippingPlanes,I.clipIntersection=P.clipIntersection,I.displacementMap=P.displacementMap,I.displacementScale=P.displacementScale,I.displacementBias=P.displacementBias,I.wireframeLinewidth=P.wireframeLinewidth,I.linewidth=P.linewidth,O.isPointLight===!0&&I.isMeshDistanceMaterial===!0&&(r.properties.get(I).light=O),I}function S(M,P,O,L,I){if(M.visible===!1)return;if(M.layers.test(P.layers)&&(M.isMesh||M.isLine||M.isPoints)&&(M.castShadow||M.receiveShadow&&I===Nr)&&(!M.frustumCulled||i.intersectsObject(M))){M.modelViewMatrix.multiplyMatrices(O.matrixWorldInverse,M.matrixWorld);let U=e.update(M),X=M.material;if(Array.isArray(X)){let k=U.groups;for(let V=0,Y=k.length;V<Y;V++){let W=k[V],ne=X[W.materialIndex];if(ne&&ne.visible){let pe=x(M,ne,L,I);M.onBeforeShadow(r,M,P,O,U,pe,W),r.renderBufferDirect(O,null,U,pe,M,W),M.onAfterShadow(r,M,P,O,U,pe,W)}}}else if(X.visible){let k=x(M,X,L,I);M.onBeforeShadow(r,M,P,O,U,k,null),r.renderBufferDirect(O,null,U,k,M,null),M.onAfterShadow(r,M,P,O,U,k,null)}}let B=M.children;for(let U=0,X=B.length;U<X;U++)S(B[U],P,O,L,I)}function T(M){M.target.removeEventListener("dispose",T);for(let P in l){let O=l[P],L=M.target.uuid;L in O&&(O[L].dispose(),delete O[L])}}this.render=function(M,P,O){if(v.enabled===!1||v.autoUpdate===!1&&v.needsUpdate===!1||M.length===0)return;this.type===Uu&&(be("WebGLShadowMap: PCFSoftShadowMap has been deprecated. Using PCFShadowMap instead."),this.type=Is);let L=r.getRenderTarget(),I=r.getActiveCubeFace(),B=r.getActiveMipmapLevel(),U=r.state;U.setBlending(Ii),U.buffers.depth.getReversed()===!0?U.buffers.color.setClear(0,0,0,0):U.buffers.color.setClear(1,1,1,1),U.buffers.depth.setTest(!0),U.setScissorTest(!1);let X=f!==this.type;X&&P.traverse(function(k){k.material&&(Array.isArray(k.material)?k.material.forEach(V=>V.needsUpdate=!0):k.material.needsUpdate=!0)});for(let k=0,V=M.length;k<V;k++){let Y=M[k],W=Y.shadow;if(W===void 0){be("WebGLShadowMap:",Y,"has no shadow.");continue}if(W.autoUpdate===!1&&W.needsUpdate===!1)continue;n.copy(W.mapSize);let ne=W.getFrameExtents();n.multiply(ne),s.copy(W.mapSize),(n.x>h||n.y>h)&&(n.x>h&&(s.x=Math.floor(h/ne.x),n.x=s.x*ne.x,W.mapSize.x=s.x),n.y>h&&(s.y=Math.floor(h/ne.y),n.y=s.y*ne.y,W.mapSize.y=s.y));let pe=r.state.buffers.depth.getReversed();if(W.camera._reversedDepth=pe,W.map===null||X===!0){if(W.map!==null&&(W.map.depthTexture!==null&&(W.map.depthTexture.dispose(),W.map.depthTexture=null),W.map.dispose()),this.type===Nr){if(Y.isPointLight){be("WebGLShadowMap: VSM shadow maps are not supported for PointLights. Use PCF or BasicShadowMap instead.");continue}W.map=new jt(n.x,n.y,{format:Bn,type:Li,minFilter:Dt,magFilter:Dt,generateMipmaps:!1}),W.map.texture.name=Y.name+".shadowMap",W.map.depthTexture=new Zi(n.x,n.y,_i),W.map.depthTexture.name=Y.name+".shadowMapDepth",W.map.depthTexture.format=vn,W.map.depthTexture.compareFunction=null,W.map.depthTexture.minFilter=ti,W.map.depthTexture.magFilter=ti}else Y.isPointLight?(W.map=new zo(n.x),W.map.depthTexture=new za(n.x,$i)):(W.map=new jt(n.x,n.y),W.map.depthTexture=new Zi(n.x,n.y,$i)),W.map.depthTexture.name=Y.name+".shadowMap",W.map.depthTexture.format=vn,this.type===Is?(W.map.depthTexture.compareFunction=pe?Do:No,W.map.depthTexture.minFilter=Dt,W.map.depthTexture.magFilter=Dt):(W.map.depthTexture.compareFunction=null,W.map.depthTexture.minFilter=ti,W.map.depthTexture.magFilter=ti);W.camera.updateProjectionMatrix()}let Ee=W.map.isWebGLCubeRenderTarget?6:1;for(let _e=0;_e<Ee;_e++){if(W.map.isWebGLCubeRenderTarget)r.setRenderTarget(W.map,_e),r.clear();else{_e===0&&(r.setRenderTarget(W.map),r.clear());let ve=W.getViewport(_e);a.set(s.x*ve.x,s.y*ve.y,s.x*ve.z,s.y*ve.w),U.viewport(a)}if(Y.isPointLight){let ve=W.camera,ie=W.matrix,he=Y.distance||ve.far;he!==ve.far&&(ve.far=he,ve.updateProjectionMatrix()),zs.setFromMatrixPosition(Y.matrixWorld),ve.position.copy(zs),oh.copy(ve.position),oh.add(Bf[_e]),ve.up.copy(zf[_e]),ve.lookAt(oh),ve.updateMatrixWorld(),ie.makeTranslation(-zs.x,-zs.y,-zs.z),qd.multiplyMatrices(ve.projectionMatrix,ve.matrixWorldInverse),W._frustum.setFromProjectionMatrix(qd,ve.coordinateSystem,ve.reversedDepth)}else W.updateMatrices(Y);i=W.getFrustum(),S(P,O,W.camera,Y,this.type)}W.isPointLightShadow!==!0&&this.type===Nr&&_(W,O),W.needsUpdate=!1}f=this.type,v.needsUpdate=!1,r.setRenderTarget(L,I,B)}}function Vf(r,e){let t=new function(){let y=!1,D=new $e,N=null,A=new $e(0,0,0,0);return{setMask:function(H){N===H||y||(r.colorMask(H,H,H,H),N=H)},setLocked:function(H){y=H},setClear:function(H,j,Z,se,xe){xe===!0&&(H*=se,j*=se,Z*=se),D.set(H,j,Z,se),A.equals(D)===!1&&(r.clearColor(H,j,Z,se),A.copy(D))},reset:function(){y=!1,N=null,A.set(-1,0,0,0)}}},i=new function(){let y=!1,D=!1,N=null,A=null,H=null;return{setReversed:function(j){if(D!==j){let Z=e.get("EXT_clip_control");j?Z.clipControlEXT(Z.LOWER_LEFT_EXT,Z.ZERO_TO_ONE_EXT):Z.clipControlEXT(Z.LOWER_LEFT_EXT,Z.NEGATIVE_ONE_TO_ONE_EXT),D=j;let se=H;H=null,this.setClear(se)}},getReversed:function(){return D},setTest:function(j){j?le(r.DEPTH_TEST):fe(r.DEPTH_TEST)},setMask:function(j){N===j||y||(r.depthMask(j),N=j)},setFunc:function(j){if(D&&(j=vd[j]),A!==j){switch(j){case $l:r.depthFunc(r.NEVER);break;case Ql:r.depthFunc(r.ALWAYS);break;case ec:r.depthFunc(r.LESS);break;case xo:r.depthFunc(r.LEQUAL);break;case tc:r.depthFunc(r.EQUAL);break;case ic:r.depthFunc(r.GEQUAL);break;case nc:r.depthFunc(r.GREATER);break;case rc:r.depthFunc(r.NOTEQUAL);break;default:r.depthFunc(r.LEQUAL)}A=j}},setLocked:function(j){y=j},setClear:function(j){H!==j&&(H=j,D&&(j=1-j),r.clearDepth(j))},reset:function(){y=!1,N=null,A=null,H=null,D=!1}}},n=new function(){let y=!1,D=null,N=null,A=null,H=null,j=null,Z=null,se=null,xe=null;return{setTest:function(ye){y||(ye?le(r.STENCIL_TEST):fe(r.STENCIL_TEST))},setMask:function(ye){D===ye||y||(r.stencilMask(ye),D=ye)},setFunc:function(ye,ue,Ce){N===ye&&A===ue&&H===Ce||(r.stencilFunc(ye,ue,Ce),N=ye,A=ue,H=Ce)},setOp:function(ye,ue,Ce){j===ye&&Z===ue&&se===Ce||(r.stencilOp(ye,ue,Ce),j=ye,Z=ue,se=Ce)},setLocked:function(ye){y=ye},setClear:function(ye){xe!==ye&&(r.clearStencil(ye),xe=ye)},reset:function(){y=!1,D=null,N=null,A=null,H=null,j=null,Z=null,se=null,xe=null}}},s=new WeakMap,a=new WeakMap,o={},c={},l={},h=new WeakMap,d=[],p=null,u=!1,g=null,m=null,v=null,f=null,_=null,x=null,S=null,T=new Ie(0,0,0),M=0,P=!1,O=null,L=null,I=null,B=null,U=null,X=r.getParameter(r.MAX_COMBINED_TEXTURE_IMAGE_UNITS),k=!1,V=0,Y=r.getParameter(r.VERSION);Y.indexOf("WebGL")!==-1?(V=parseFloat(/^WebGL (\d)/.exec(Y)[1]),k=V>=1):Y.indexOf("OpenGL ES")!==-1&&(V=parseFloat(/^OpenGL ES (\d)/.exec(Y)[1]),k=V>=2);let W=null,ne={},pe=r.getParameter(r.SCISSOR_BOX),Ee=r.getParameter(r.VIEWPORT),_e=new $e().fromArray(pe),ve=new $e().fromArray(Ee);function ie(y,D,N,A){let H=new Uint8Array(4),j=r.createTexture();r.bindTexture(y,j),r.texParameteri(y,r.TEXTURE_MIN_FILTER,r.NEAREST),r.texParameteri(y,r.TEXTURE_MAG_FILTER,r.NEAREST);for(let Z=0;Z<N;Z++)y===r.TEXTURE_3D||y===r.TEXTURE_2D_ARRAY?r.texImage3D(D,0,r.RGBA,1,1,A,0,r.RGBA,r.UNSIGNED_BYTE,H):r.texImage2D(D+Z,0,r.RGBA,1,1,0,r.RGBA,r.UNSIGNED_BYTE,H);return j}let he={};function le(y){o[y]!==!0&&(r.enable(y),o[y]=!0)}function fe(y){o[y]!==!1&&(r.disable(y),o[y]=!1)}he[r.TEXTURE_2D]=ie(r.TEXTURE_2D,r.TEXTURE_2D,1),he[r.TEXTURE_CUBE_MAP]=ie(r.TEXTURE_CUBE_MAP,r.TEXTURE_CUBE_MAP_POSITIVE_X,6),he[r.TEXTURE_2D_ARRAY]=ie(r.TEXTURE_2D_ARRAY,r.TEXTURE_2D_ARRAY,1,1),he[r.TEXTURE_3D]=ie(r.TEXTURE_3D,r.TEXTURE_3D,1,1),t.setClear(0,0,0,1),i.setClear(1),n.setClear(0),le(r.DEPTH_TEST),i.setFunc(xo),b(!1),C(Zl),le(r.CULL_FACE),R(Ii);let Ue={[Ur]:r.FUNC_ADD,[Ou]:r.FUNC_SUBTRACT,[Bu]:r.FUNC_REVERSE_SUBTRACT};Ue[zu]=r.MIN,Ue[Gu]=r.MAX;let $={[Vu]:r.ZERO,[Hu]:r.ONE,[ku]:r.SRC_COLOR,[Xu]:r.SRC_ALPHA,[Ku]:r.SRC_ALPHA_SATURATE,[Zu]:r.DST_COLOR,[qu]:r.DST_ALPHA,[Wu]:r.ONE_MINUS_SRC_COLOR,[ju]:r.ONE_MINUS_SRC_ALPHA,[Ju]:r.ONE_MINUS_DST_COLOR,[Yu]:r.ONE_MINUS_DST_ALPHA,[$u]:r.CONSTANT_COLOR,[Qu]:r.ONE_MINUS_CONSTANT_COLOR,[ed]:r.CONSTANT_ALPHA,[td]:r.ONE_MINUS_CONSTANT_ALPHA};function R(y,D,N,A,H,j,Z,se,xe,ye){if(y!==Ii){if(u===!1&&(le(r.BLEND),u=!0),y===Fu)H=H||D,j=j||N,Z=Z||A,D===m&&H===_||(r.blendEquationSeparate(Ue[D],Ue[H]),m=D,_=H),N===v&&A===f&&j===x&&Z===S||(r.blendFuncSeparate($[N],$[A],$[j],$[Z]),v=N,f=A,x=j,S=Z),se.equals(T)!==!1&&xe===M||(r.blendColor(se.r,se.g,se.b,xe),T.copy(se),M=xe),g=y,P=!1;else if(y!==g||ye!==P){if(m===Ur&&_===Ur||(r.blendEquation(r.FUNC_ADD),m=Ur,_=Ur),ye)switch(y){case Ls:r.blendFuncSeparate(r.ONE,r.ONE_MINUS_SRC_ALPHA,r.ONE,r.ONE_MINUS_SRC_ALPHA);break;case fi:r.blendFunc(r.ONE,r.ONE);break;case Jl:r.blendFuncSeparate(r.ZERO,r.ONE_MINUS_SRC_COLOR,r.ZERO,r.ONE);break;case Kl:r.blendFuncSeparate(r.DST_COLOR,r.ONE_MINUS_SRC_ALPHA,r.ZERO,r.ONE);break;default:we("WebGLState: Invalid blending: ",y)}else switch(y){case Ls:r.blendFuncSeparate(r.SRC_ALPHA,r.ONE_MINUS_SRC_ALPHA,r.ONE,r.ONE_MINUS_SRC_ALPHA);break;case fi:r.blendFuncSeparate(r.SRC_ALPHA,r.ONE,r.ONE,r.ONE);break;case Jl:we("WebGLState: SubtractiveBlending requires material.premultipliedAlpha = true");break;case Kl:we("WebGLState: MultiplyBlending requires material.premultipliedAlpha = true");break;default:we("WebGLState: Invalid blending: ",y)}v=null,f=null,x=null,S=null,T.set(0,0,0),M=0,g=y,P=ye}}else u===!0&&(fe(r.BLEND),u=!1)}function b(y){O!==y&&(y?r.frontFace(r.CW):r.frontFace(r.CCW),O=y)}function C(y){y!==Nu?(le(r.CULL_FACE),y!==L&&(y===Zl?r.cullFace(r.BACK):y===Du?r.cullFace(r.FRONT):r.cullFace(r.FRONT_AND_BACK))):fe(r.CULL_FACE),L=y}function F(y,D,N){y?(le(r.POLYGON_OFFSET_FILL),B===D&&U===N||(B=D,U=N,i.getReversed()&&(D=-D),r.polygonOffset(D,N))):fe(r.POLYGON_OFFSET_FILL)}return{buffers:{color:t,depth:i,stencil:n},enable:le,disable:fe,bindFramebuffer:function(y,D){return l[y]!==D&&(r.bindFramebuffer(y,D),l[y]=D,y===r.DRAW_FRAMEBUFFER&&(l[r.FRAMEBUFFER]=D),y===r.FRAMEBUFFER&&(l[r.DRAW_FRAMEBUFFER]=D),!0)},drawBuffers:function(y,D){let N=d,A=!1;if(y){N=h.get(D),N===void 0&&(N=[],h.set(D,N));let H=y.textures;if(N.length!==H.length||N[0]!==r.COLOR_ATTACHMENT0){for(let j=0,Z=H.length;j<Z;j++)N[j]=r.COLOR_ATTACHMENT0+j;N.length=H.length,A=!0}}else N[0]!==r.BACK&&(N[0]=r.BACK,A=!0);A&&r.drawBuffers(N)},useProgram:function(y){return p!==y&&(r.useProgram(y),p=y,!0)},setBlending:R,setMaterial:function(y,D){y.side===Vt?fe(r.CULL_FACE):le(r.CULL_FACE);let N=y.side===Gt;D&&(N=!N),b(N),y.blending===Ls&&y.transparent===!1?R(Ii):R(y.blending,y.blendEquation,y.blendSrc,y.blendDst,y.blendEquationAlpha,y.blendSrcAlpha,y.blendDstAlpha,y.blendColor,y.blendAlpha,y.premultipliedAlpha),i.setFunc(y.depthFunc),i.setTest(y.depthTest),i.setMask(y.depthWrite),t.setMask(y.colorWrite);let A=y.stencilWrite;n.setTest(A),A&&(n.setMask(y.stencilWriteMask),n.setFunc(y.stencilFunc,y.stencilRef,y.stencilFuncMask),n.setOp(y.stencilFail,y.stencilZFail,y.stencilZPass)),F(y.polygonOffset,y.polygonOffsetFactor,y.polygonOffsetUnits),y.alphaToCoverage===!0?le(r.SAMPLE_ALPHA_TO_COVERAGE):fe(r.SAMPLE_ALPHA_TO_COVERAGE)},setFlipSided:b,setCullFace:C,setLineWidth:function(y){y!==I&&(k&&r.lineWidth(y),I=y)},setPolygonOffset:F,setScissorTest:function(y){y?le(r.SCISSOR_TEST):fe(r.SCISSOR_TEST)},activeTexture:function(y){y===void 0&&(y=r.TEXTURE0+X-1),W!==y&&(r.activeTexture(y),W=y)},bindTexture:function(y,D,N){N===void 0&&(N=W===null?r.TEXTURE0+X-1:W);let A=ne[N];A===void 0&&(A={type:void 0,texture:void 0},ne[N]=A),A.type===y&&A.texture===D||(W!==N&&(r.activeTexture(N),W=N),r.bindTexture(y,D||he[y]),A.type=y,A.texture=D)},unbindTexture:function(){let y=ne[W];y!==void 0&&y.type!==void 0&&(r.bindTexture(y.type,null),y.type=void 0,y.texture=void 0)},compressedTexImage2D:function(){try{r.compressedTexImage2D(...arguments)}catch(y){we("WebGLState:",y)}},compressedTexImage3D:function(){try{r.compressedTexImage3D(...arguments)}catch(y){we("WebGLState:",y)}},texImage2D:function(){try{r.texImage2D(...arguments)}catch(y){we("WebGLState:",y)}},texImage3D:function(){try{r.texImage3D(...arguments)}catch(y){we("WebGLState:",y)}},pixelStorei:function(y,D){c[y]!==D&&(r.pixelStorei(y,D),c[y]=D)},getParameter:function(y){return c[y]!==void 0?c[y]:r.getParameter(y)},updateUBOMapping:function(y,D){let N=a.get(D);N===void 0&&(N=new WeakMap,a.set(D,N));let A=N.get(y);A===void 0&&(A=r.getUniformBlockIndex(D,y.name),N.set(y,A))},uniformBlockBinding:function(y,D){let N=a.get(D).get(y);s.get(D)!==N&&(r.uniformBlockBinding(D,N,y.__bindingPointIndex),s.set(D,N))},texStorage2D:function(){try{r.texStorage2D(...arguments)}catch(y){we("WebGLState:",y)}},texStorage3D:function(){try{r.texStorage3D(...arguments)}catch(y){we("WebGLState:",y)}},texSubImage2D:function(){try{r.texSubImage2D(...arguments)}catch(y){we("WebGLState:",y)}},texSubImage3D:function(){try{r.texSubImage3D(...arguments)}catch(y){we("WebGLState:",y)}},compressedTexSubImage2D:function(){try{r.compressedTexSubImage2D(...arguments)}catch(y){we("WebGLState:",y)}},compressedTexSubImage3D:function(){try{r.compressedTexSubImage3D(...arguments)}catch(y){we("WebGLState:",y)}},scissor:function(y){_e.equals(y)===!1&&(r.scissor(y.x,y.y,y.z,y.w),_e.copy(y))},viewport:function(y){ve.equals(y)===!1&&(r.viewport(y.x,y.y,y.z,y.w),ve.copy(y))},reset:function(){r.disable(r.BLEND),r.disable(r.CULL_FACE),r.disable(r.DEPTH_TEST),r.disable(r.POLYGON_OFFSET_FILL),r.disable(r.SCISSOR_TEST),r.disable(r.STENCIL_TEST),r.disable(r.SAMPLE_ALPHA_TO_COVERAGE),r.blendEquation(r.FUNC_ADD),r.blendFunc(r.ONE,r.ZERO),r.blendFuncSeparate(r.ONE,r.ZERO,r.ONE,r.ZERO),r.blendColor(0,0,0,0),r.colorMask(!0,!0,!0,!0),r.clearColor(0,0,0,0),r.depthMask(!0),r.depthFunc(r.LESS),i.setReversed(!1),r.clearDepth(1),r.stencilMask(4294967295),r.stencilFunc(r.ALWAYS,0,4294967295),r.stencilOp(r.KEEP,r.KEEP,r.KEEP),r.clearStencil(0),r.cullFace(r.BACK),r.frontFace(r.CCW),r.polygonOffset(0,0),r.activeTexture(r.TEXTURE0),r.bindFramebuffer(r.FRAMEBUFFER,null),r.bindFramebuffer(r.DRAW_FRAMEBUFFER,null),r.bindFramebuffer(r.READ_FRAMEBUFFER,null),r.useProgram(null),r.lineWidth(1),r.scissor(0,0,r.canvas.width,r.canvas.height),r.viewport(0,0,r.canvas.width,r.canvas.height),r.pixelStorei(r.PACK_ALIGNMENT,4),r.pixelStorei(r.UNPACK_ALIGNMENT,4),r.pixelStorei(r.UNPACK_FLIP_Y_WEBGL,!1),r.pixelStorei(r.UNPACK_PREMULTIPLY_ALPHA_WEBGL,!1),r.pixelStorei(r.UNPACK_COLORSPACE_CONVERSION_WEBGL,r.BROWSER_DEFAULT_WEBGL),r.pixelStorei(r.PACK_ROW_LENGTH,0),r.pixelStorei(r.PACK_SKIP_PIXELS,0),r.pixelStorei(r.PACK_SKIP_ROWS,0),r.pixelStorei(r.UNPACK_ROW_LENGTH,0),r.pixelStorei(r.UNPACK_IMAGE_HEIGHT,0),r.pixelStorei(r.UNPACK_SKIP_PIXELS,0),r.pixelStorei(r.UNPACK_SKIP_ROWS,0),r.pixelStorei(r.UNPACK_SKIP_IMAGES,0),o={},c={},W=null,ne={},l={},h=new WeakMap,d=[],p=null,u=!1,g=null,m=null,v=null,f=null,_=null,x=null,S=null,T=new Ie(0,0,0),M=0,P=!1,O=null,L=null,I=null,B=null,U=null,_e.set(0,0,r.canvas.width,r.canvas.height),ve.set(0,0,r.canvas.width,r.canvas.height),t.reset(),i.reset(),n.reset()}}}function Hf(r,e,t,i,n,s,a){let o=e.has("WEBGL_multisampled_render_to_texture")?e.get("WEBGL_multisampled_render_to_texture"):null,c=typeof navigator<"u"&&/OculusBrowser/g.test(navigator.userAgent),l=new te,h=new WeakMap,d=new Set,p,u=new WeakMap,g=!1;try{g=typeof OffscreenCanvas<"u"&&new OffscreenCanvas(1,1).getContext("2d")!==null}catch{}function m(R,b){return g?new OffscreenCanvas(R,b):mr("canvas")}function v(R,b,C){let F=1,y=$(R);if((y.width>C||y.height>C)&&(F=C/Math.max(y.width,y.height)),F<1){if(typeof HTMLImageElement<"u"&&R instanceof HTMLImageElement||typeof HTMLCanvasElement<"u"&&R instanceof HTMLCanvasElement||typeof ImageBitmap<"u"&&R instanceof ImageBitmap||typeof VideoFrame<"u"&&R instanceof VideoFrame){let D=Math.floor(F*y.width),N=Math.floor(F*y.height);p===void 0&&(p=m(D,N));let A=b?m(D,N):p;return A.width=D,A.height=N,A.getContext("2d").drawImage(R,0,0,D,N),be("WebGLRenderer: Texture has been resized from ("+y.width+"x"+y.height+") to ("+D+"x"+N+")."),A}return"data"in R&&be("WebGLRenderer: Image in DataTexture is too big ("+y.width+"x"+y.height+")."),R}return R}function f(R){return R.generateMipmaps}function _(R){r.generateMipmap(R)}function x(R){return R.isWebGLCubeRenderTarget?r.TEXTURE_CUBE_MAP:R.isWebGL3DRenderTarget?r.TEXTURE_3D:R.isWebGLArrayRenderTarget||R.isCompressedArrayTexture?r.TEXTURE_2D_ARRAY:r.TEXTURE_2D}function S(R,b,C,F,y,D=!1){if(R!==null){if(r[R]!==void 0)return r[R];be("WebGLRenderer: Attempt to use non-existing WebGL internal format '"+R+"'")}let N;F&&(N=e.get("EXT_texture_norm16"),N||be("WebGLRenderer: Unable to use normalized textures without EXT_texture_norm16 extension"));let A=b;if(b===r.RED&&(C===r.FLOAT&&(A=r.R32F),C===r.HALF_FLOAT&&(A=r.R16F),C===r.UNSIGNED_BYTE&&(A=r.R8),C===r.UNSIGNED_SHORT&&N&&(A=N.R16_EXT),C===r.SHORT&&N&&(A=N.R16_SNORM_EXT)),b===r.RED_INTEGER&&(C===r.UNSIGNED_BYTE&&(A=r.R8UI),C===r.UNSIGNED_SHORT&&(A=r.R16UI),C===r.UNSIGNED_INT&&(A=r.R32UI),C===r.BYTE&&(A=r.R8I),C===r.SHORT&&(A=r.R16I),C===r.INT&&(A=r.R32I)),b===r.RG&&(C===r.FLOAT&&(A=r.RG32F),C===r.HALF_FLOAT&&(A=r.RG16F),C===r.UNSIGNED_BYTE&&(A=r.RG8),C===r.UNSIGNED_SHORT&&N&&(A=N.RG16_EXT),C===r.SHORT&&N&&(A=N.RG16_SNORM_EXT)),b===r.RG_INTEGER&&(C===r.UNSIGNED_BYTE&&(A=r.RG8UI),C===r.UNSIGNED_SHORT&&(A=r.RG16UI),C===r.UNSIGNED_INT&&(A=r.RG32UI),C===r.BYTE&&(A=r.RG8I),C===r.SHORT&&(A=r.RG16I),C===r.INT&&(A=r.RG32I)),b===r.RGB_INTEGER&&(C===r.UNSIGNED_BYTE&&(A=r.RGB8UI),C===r.UNSIGNED_SHORT&&(A=r.RGB16UI),C===r.UNSIGNED_INT&&(A=r.RGB32UI),C===r.BYTE&&(A=r.RGB8I),C===r.SHORT&&(A=r.RGB16I),C===r.INT&&(A=r.RGB32I)),b===r.RGBA_INTEGER&&(C===r.UNSIGNED_BYTE&&(A=r.RGBA8UI),C===r.UNSIGNED_SHORT&&(A=r.RGBA16UI),C===r.UNSIGNED_INT&&(A=r.RGBA32UI),C===r.BYTE&&(A=r.RGBA8I),C===r.SHORT&&(A=r.RGBA16I),C===r.INT&&(A=r.RGBA32I)),b===r.RGB&&(C===r.UNSIGNED_SHORT&&N&&(A=N.RGB16_EXT),C===r.SHORT&&N&&(A=N.RGB16_SNORM_EXT),C===r.UNSIGNED_INT_5_9_9_9_REV&&(A=r.RGB9_E5),C===r.UNSIGNED_INT_10F_11F_11F_REV&&(A=r.R11F_G11F_B10F)),b===r.RGBA){let H=D?os:He.getTransfer(y);C===r.FLOAT&&(A=r.RGBA32F),C===r.HALF_FLOAT&&(A=r.RGBA16F),C===r.UNSIGNED_BYTE&&(A=H===Ze?r.SRGB8_ALPHA8:r.RGBA8),C===r.UNSIGNED_SHORT&&N&&(A=N.RGBA16_EXT),C===r.SHORT&&N&&(A=N.RGBA16_SNORM_EXT),C===r.UNSIGNED_SHORT_4_4_4_4&&(A=r.RGBA4),C===r.UNSIGNED_SHORT_5_5_5_1&&(A=r.RGB5_A1)}return A!==r.R16F&&A!==r.R32F&&A!==r.RG16F&&A!==r.RG32F&&A!==r.RGBA16F&&A!==r.RGBA32F||e.get("EXT_color_buffer_float"),A}function T(R,b){let C;return R?b===null||b===$i||b===Br?C=r.DEPTH24_STENCIL8:b===_i?C=r.DEPTH32F_STENCIL8:b===Or&&(C=r.DEPTH24_STENCIL8,be("DepthTexture: 16 bit depth attachment is not supported with stencil. Using 24-bit attachment.")):b===null||b===$i||b===Br?C=r.DEPTH_COMPONENT24:b===_i?C=r.DEPTH_COMPONENT32F:b===Or&&(C=r.DEPTH_COMPONENT16),C}function M(R,b){return f(R)===!0||R.isFramebufferTexture&&R.minFilter!==ti&&R.minFilter!==Dt?Math.log2(Math.max(b.width,b.height))+1:R.mipmaps!==void 0&&R.mipmaps.length>0?R.mipmaps.length:R.isCompressedTexture&&Array.isArray(R.image)?b.mipmaps.length:1}function P(R){let b=R.target;b.removeEventListener("dispose",P),(function(C){let F=i.get(C);if(F.__webglInit===void 0)return;let y=C.source,D=u.get(y);if(D){let N=D[F.__cacheKey];N.usedTimes--,N.usedTimes===0&&L(C),Object.keys(D).length===0&&u.delete(y)}i.remove(C)})(b),b.isVideoTexture&&h.delete(b),b.isHTMLTexture&&d.delete(b)}function O(R){let b=R.target;b.removeEventListener("dispose",O),(function(C){let F=i.get(C);if(C.depthTexture&&(C.depthTexture.dispose(),i.remove(C.depthTexture)),C.isWebGLCubeRenderTarget)for(let D=0;D<6;D++){if(Array.isArray(F.__webglFramebuffer[D]))for(let N=0;N<F.__webglFramebuffer[D].length;N++)r.deleteFramebuffer(F.__webglFramebuffer[D][N]);else r.deleteFramebuffer(F.__webglFramebuffer[D]);F.__webglDepthbuffer&&r.deleteRenderbuffer(F.__webglDepthbuffer[D])}else{if(Array.isArray(F.__webglFramebuffer))for(let D=0;D<F.__webglFramebuffer.length;D++)r.deleteFramebuffer(F.__webglFramebuffer[D]);else r.deleteFramebuffer(F.__webglFramebuffer);if(F.__webglDepthbuffer&&r.deleteRenderbuffer(F.__webglDepthbuffer),F.__webglMultisampledFramebuffer&&r.deleteFramebuffer(F.__webglMultisampledFramebuffer),F.__webglColorRenderbuffer)for(let D=0;D<F.__webglColorRenderbuffer.length;D++)F.__webglColorRenderbuffer[D]&&r.deleteRenderbuffer(F.__webglColorRenderbuffer[D]);F.__webglDepthRenderbuffer&&r.deleteRenderbuffer(F.__webglDepthRenderbuffer)}let y=C.textures;for(let D=0,N=y.length;D<N;D++){let A=i.get(y[D]);A.__webglTexture&&(r.deleteTexture(A.__webglTexture),a.memory.textures--),i.remove(y[D])}i.remove(C)})(b)}function L(R){let b=i.get(R);r.deleteTexture(b.__webglTexture);let C=R.source;delete u.get(C)[b.__cacheKey],a.memory.textures--}let I=0;function B(R,b){let C=i.get(R);if(R.isVideoTexture&&(function(F){let y=a.render.frame;h.get(F)!==y&&(h.set(F,y),F.update())})(R),R.isRenderTargetTexture===!1&&R.isExternalTexture!==!0&&R.version>0&&C.__version!==R.version){let F=R.image;if(F===null)be("WebGLRenderer: Texture marked for update but no image data found.");else{if(F.complete!==!1)return void ne(C,R,b);be("WebGLRenderer: Texture marked for update but image is incomplete")}}else R.isExternalTexture&&(C.__webglTexture=R.sourceTexture?R.sourceTexture:null);t.bindTexture(r.TEXTURE_2D,C.__webglTexture,r.TEXTURE0+b)}let U={[Aa]:r.REPEAT,[dn]:r.CLAMP_TO_EDGE,[Ca]:r.MIRRORED_REPEAT},X={[ti]:r.NEAREST,[sd]:r.NEAREST_MIPMAP_NEAREST,[Us]:r.NEAREST_MIPMAP_LINEAR,[Dt]:r.LINEAR,[So]:r.LINEAR_MIPMAP_NEAREST,[Fn]:r.LINEAR_MIPMAP_LINEAR},k={[cd]:r.NEVER,[md]:r.ALWAYS,[hd]:r.LESS,[No]:r.LEQUAL,[ud]:r.EQUAL,[Do]:r.GEQUAL,[dd]:r.GREATER,[pd]:r.NOTEQUAL};function V(R,b){if(b.type!==_i||e.has("OES_texture_float_linear")!==!1||b.magFilter!==Dt&&b.magFilter!==So&&b.magFilter!==Us&&b.magFilter!==Fn&&b.minFilter!==Dt&&b.minFilter!==So&&b.minFilter!==Us&&b.minFilter!==Fn||be("WebGLRenderer: Unable to use linear filtering with floating point textures. OES_texture_float_linear not supported on this device."),r.texParameteri(R,r.TEXTURE_WRAP_S,U[b.wrapS]),r.texParameteri(R,r.TEXTURE_WRAP_T,U[b.wrapT]),R!==r.TEXTURE_3D&&R!==r.TEXTURE_2D_ARRAY||r.texParameteri(R,r.TEXTURE_WRAP_R,U[b.wrapR]),r.texParameteri(R,r.TEXTURE_MAG_FILTER,X[b.magFilter]),r.texParameteri(R,r.TEXTURE_MIN_FILTER,X[b.minFilter]),b.compareFunction&&(r.texParameteri(R,r.TEXTURE_COMPARE_MODE,r.COMPARE_REF_TO_TEXTURE),r.texParameteri(R,r.TEXTURE_COMPARE_FUNC,k[b.compareFunction])),e.has("EXT_texture_filter_anisotropic")===!0){if(b.magFilter===ti||b.minFilter!==Us&&b.minFilter!==Fn||b.type===_i&&e.has("OES_texture_float_linear")===!1)return;if(b.anisotropy>1||i.get(b).__currentAnisotropy){let C=e.get("EXT_texture_filter_anisotropic");r.texParameterf(R,C.TEXTURE_MAX_ANISOTROPY_EXT,Math.min(b.anisotropy,n.getMaxAnisotropy())),i.get(b).__currentAnisotropy=b.anisotropy}}}function Y(R,b){let C=!1;R.__webglInit===void 0&&(R.__webglInit=!0,b.addEventListener("dispose",P));let F=b.source,y=u.get(F);y===void 0&&(y={},u.set(F,y));let D=(function(N){let A=[];return A.push(N.wrapS),A.push(N.wrapT),A.push(N.wrapR||0),A.push(N.magFilter),A.push(N.minFilter),A.push(N.anisotropy),A.push(N.internalFormat),A.push(N.format),A.push(N.type),A.push(N.generateMipmaps),A.push(N.premultiplyAlpha),A.push(N.flipY),A.push(N.unpackAlignment),A.push(N.colorSpace),A.join()})(b);if(D!==R.__cacheKey){y[D]===void 0&&(y[D]={texture:r.createTexture(),usedTimes:0},a.memory.textures++,C=!0),y[D].usedTimes++;let N=y[R.__cacheKey];N!==void 0&&(y[R.__cacheKey].usedTimes--,N.usedTimes===0&&L(b)),R.__cacheKey=D,R.__webglTexture=y[D].texture}return C}function W(R,b,C){return Math.floor(Math.floor(R/C)/b)}function ne(R,b,C){let F=r.TEXTURE_2D;(b.isDataArrayTexture||b.isCompressedArrayTexture)&&(F=r.TEXTURE_2D_ARRAY),b.isData3DTexture&&(F=r.TEXTURE_3D);let y=Y(R,b),D=b.source;t.bindTexture(F,R.__webglTexture,r.TEXTURE0+C);let N=i.get(D);if(D.version!==N.__version||y===!0){if(t.activeTexture(r.TEXTURE0+C),!(typeof ImageBitmap<"u"&&b.image instanceof ImageBitmap)){let ae=He.getPrimaries(He.workingColorSpace),re=b.colorSpace===zn?null:He.getPrimaries(b.colorSpace),me=b.colorSpace===zn||ae===re?r.NONE:r.BROWSER_DEFAULT_WEBGL;t.pixelStorei(r.UNPACK_FLIP_Y_WEBGL,b.flipY),t.pixelStorei(r.UNPACK_PREMULTIPLY_ALPHA_WEBGL,b.premultiplyAlpha),t.pixelStorei(r.UNPACK_COLORSPACE_CONVERSION_WEBGL,me)}t.pixelStorei(r.UNPACK_ALIGNMENT,b.unpackAlignment);let A=v(b.image,!1,n.maxTextureSize);A=Ue(b,A);let H=s.convert(b.format,b.colorSpace),j=s.convert(b.type),Z,se=S(b.internalFormat,H,j,b.normalized,b.colorSpace,b.isVideoTexture);V(F,b);let xe=b.mipmaps,ye=b.isVideoTexture!==!0,ue=N.__version===void 0||y===!0,Ce=D.dataReady,ee=M(b,A);if(b.isDepthTexture)se=T(b.format===On,b.type),ue&&(ye?t.texStorage2D(r.TEXTURE_2D,1,se,A.width,A.height):t.texImage2D(r.TEXTURE_2D,0,se,A.width,A.height,0,H,j,null));else if(b.isDataTexture)if(xe.length>0){ye&&ue&&t.texStorage2D(r.TEXTURE_2D,ee,se,xe[0].width,xe[0].height);for(let ae=0,re=xe.length;ae<re;ae++)Z=xe[ae],ye?Ce&&t.texSubImage2D(r.TEXTURE_2D,ae,0,0,Z.width,Z.height,H,j,Z.data):t.texImage2D(r.TEXTURE_2D,ae,se,Z.width,Z.height,0,H,j,Z.data);b.generateMipmaps=!1}else ye?(ue&&t.texStorage2D(r.TEXTURE_2D,ee,se,A.width,A.height),Ce&&(function(ae,re,me,et){let Ye=ae.updateRanges;if(Ye.length===0)t.texSubImage2D(r.TEXTURE_2D,0,0,0,re.width,re.height,me,et,re.data);else{Ye.sort((ze,At)=>ze.start-At.start);let ct=0;for(let ze=1;ze<Ye.length;ze++){let At=Ye[ct],tt=Ye[ze],vt=At.start+At.count,ot=W(tt.start,re.width,4),$t=W(At.start,re.width,4);tt.start<=vt+1&&ot===$t&&W(tt.start+tt.count-1,re.width,4)===ot?At.count=Math.max(At.count,tt.start+tt.count-At.start):(++ct,Ye[ct]=tt)}Ye.length=ct+1;let Ot=t.getParameter(r.UNPACK_ROW_LENGTH),Se=t.getParameter(r.UNPACK_SKIP_PIXELS),Je=t.getParameter(r.UNPACK_SKIP_ROWS);t.pixelStorei(r.UNPACK_ROW_LENGTH,re.width);for(let ze=0,At=Ye.length;ze<At;ze++){let tt=Ye[ze],vt=Math.floor(tt.start/4),ot=Math.ceil(tt.count/4),$t=vt%re.width,ri=Math.floor(vt/re.width),Sn=ot;t.pixelStorei(r.UNPACK_SKIP_PIXELS,$t),t.pixelStorei(r.UNPACK_SKIP_ROWS,ri),t.texSubImage2D(r.TEXTURE_2D,0,$t,ri,Sn,1,me,et,re.data)}ae.clearUpdateRanges(),t.pixelStorei(r.UNPACK_ROW_LENGTH,Ot),t.pixelStorei(r.UNPACK_SKIP_PIXELS,Se),t.pixelStorei(r.UNPACK_SKIP_ROWS,Je)}})(b,A,H,j)):t.texImage2D(r.TEXTURE_2D,0,se,A.width,A.height,0,H,j,A.data);else if(b.isCompressedTexture)if(b.isCompressedArrayTexture){ye&&ue&&t.texStorage3D(r.TEXTURE_2D_ARRAY,ee,se,xe[0].width,xe[0].height,A.depth);for(let ae=0,re=xe.length;ae<re;ae++)if(Z=xe[ae],b.format!==vi)if(H!==null)if(ye){if(Ce)if(b.layerUpdates.size>0){let me=th(Z.width,Z.height,b.format,b.type);for(let et of b.layerUpdates){let Ye=Z.data.subarray(et*me/Z.data.BYTES_PER_ELEMENT,(et+1)*me/Z.data.BYTES_PER_ELEMENT);t.compressedTexSubImage3D(r.TEXTURE_2D_ARRAY,ae,0,0,et,Z.width,Z.height,1,H,Ye)}b.clearLayerUpdates()}else t.compressedTexSubImage3D(r.TEXTURE_2D_ARRAY,ae,0,0,0,Z.width,Z.height,A.depth,H,Z.data)}else t.compressedTexImage3D(r.TEXTURE_2D_ARRAY,ae,se,Z.width,Z.height,A.depth,0,Z.data,0,0);else be("WebGLRenderer: Attempt to load unsupported compressed texture format in .uploadTexture()");else ye?Ce&&t.texSubImage3D(r.TEXTURE_2D_ARRAY,ae,0,0,0,Z.width,Z.height,A.depth,H,j,Z.data):t.texImage3D(r.TEXTURE_2D_ARRAY,ae,se,Z.width,Z.height,A.depth,0,H,j,Z.data)}else{ye&&ue&&t.texStorage2D(r.TEXTURE_2D,ee,se,xe[0].width,xe[0].height);for(let ae=0,re=xe.length;ae<re;ae++)Z=xe[ae],b.format!==vi?H!==null?ye?Ce&&t.compressedTexSubImage2D(r.TEXTURE_2D,ae,0,0,Z.width,Z.height,H,Z.data):t.compressedTexImage2D(r.TEXTURE_2D,ae,se,Z.width,Z.height,0,Z.data):be("WebGLRenderer: Attempt to load unsupported compressed texture format in .uploadTexture()"):ye?Ce&&t.texSubImage2D(r.TEXTURE_2D,ae,0,0,Z.width,Z.height,H,j,Z.data):t.texImage2D(r.TEXTURE_2D,ae,se,Z.width,Z.height,0,H,j,Z.data)}else if(b.isDataArrayTexture)if(ye){if(ue&&t.texStorage3D(r.TEXTURE_2D_ARRAY,ee,se,A.width,A.height,A.depth),Ce)if(b.layerUpdates.size>0){let ae=th(A.width,A.height,b.format,b.type);for(let re of b.layerUpdates){let me=A.data.subarray(re*ae/A.data.BYTES_PER_ELEMENT,(re+1)*ae/A.data.BYTES_PER_ELEMENT);t.texSubImage3D(r.TEXTURE_2D_ARRAY,0,0,0,re,A.width,A.height,1,H,j,me)}b.clearLayerUpdates()}else t.texSubImage3D(r.TEXTURE_2D_ARRAY,0,0,0,0,A.width,A.height,A.depth,H,j,A.data)}else t.texImage3D(r.TEXTURE_2D_ARRAY,0,se,A.width,A.height,A.depth,0,H,j,A.data);else if(b.isData3DTexture)ye?(ue&&t.texStorage3D(r.TEXTURE_3D,ee,se,A.width,A.height,A.depth),Ce&&t.texSubImage3D(r.TEXTURE_3D,0,0,0,0,A.width,A.height,A.depth,H,j,A.data)):t.texImage3D(r.TEXTURE_3D,0,se,A.width,A.height,A.depth,0,H,j,A.data);else if(b.isFramebufferTexture){if(ue)if(ye)t.texStorage2D(r.TEXTURE_2D,ee,se,A.width,A.height);else{let ae=A.width,re=A.height;for(let me=0;me<ee;me++)t.texImage2D(r.TEXTURE_2D,me,se,ae,re,0,H,j,null),ae>>=1,re>>=1}}else if(b.isHTMLTexture){if("texElementImage2D"in r){let ae=r.canvas;if(ae.hasAttribute("layoutsubtree")||ae.setAttribute("layoutsubtree","true"),A.parentNode!==ae)return ae.appendChild(A),d.add(b),ae.onpaint=re=>{let me=re.changedElements;for(let et of d)me.includes(et.image)&&(et.needsUpdate=!0)},void ae.requestPaint();if(r.texElementImage2D.length===3)r.texElementImage2D(r.TEXTURE_2D,r.RGBA8,A);else{let me=r.RGBA,et=r.RGBA,Ye=r.UNSIGNED_BYTE;r.texElementImage2D(r.TEXTURE_2D,0,me,et,Ye,A)}r.texParameteri(r.TEXTURE_2D,r.TEXTURE_MIN_FILTER,r.LINEAR),r.texParameteri(r.TEXTURE_2D,r.TEXTURE_WRAP_S,r.CLAMP_TO_EDGE),r.texParameteri(r.TEXTURE_2D,r.TEXTURE_WRAP_T,r.CLAMP_TO_EDGE)}}else if(xe.length>0){if(ye&&ue){let ae=$(xe[0]);t.texStorage2D(r.TEXTURE_2D,ee,se,ae.width,ae.height)}for(let ae=0,re=xe.length;ae<re;ae++)Z=xe[ae],ye?Ce&&t.texSubImage2D(r.TEXTURE_2D,ae,0,0,H,j,Z):t.texImage2D(r.TEXTURE_2D,ae,se,H,j,Z);b.generateMipmaps=!1}else if(ye){if(ue){let ae=$(A);t.texStorage2D(r.TEXTURE_2D,ee,se,ae.width,ae.height)}Ce&&t.texSubImage2D(r.TEXTURE_2D,0,0,0,H,j,A)}else t.texImage2D(r.TEXTURE_2D,0,se,H,j,A);f(b)&&_(F),N.__version=D.version,b.onUpdate&&b.onUpdate(b)}R.__version=b.version}function pe(R,b,C,F,y,D){let N=s.convert(C.format,C.colorSpace),A=s.convert(C.type),H=S(C.internalFormat,N,A,C.normalized,C.colorSpace),j=i.get(b),Z=i.get(C);if(Z.__renderTarget=b,!j.__hasExternalTextures){let se=Math.max(1,b.width>>D),xe=Math.max(1,b.height>>D);y===r.TEXTURE_3D||y===r.TEXTURE_2D_ARRAY?t.texImage3D(y,D,H,se,xe,b.depth,0,N,A,null):t.texImage2D(y,D,H,se,xe,0,N,A,null)}t.bindFramebuffer(r.FRAMEBUFFER,R),fe(b)?o.framebufferTexture2DMultisampleEXT(r.FRAMEBUFFER,F,y,Z.__webglTexture,0,le(b)):(y===r.TEXTURE_2D||y>=r.TEXTURE_CUBE_MAP_POSITIVE_X&&y<=r.TEXTURE_CUBE_MAP_NEGATIVE_Z)&&r.framebufferTexture2D(r.FRAMEBUFFER,F,y,Z.__webglTexture,D),t.bindFramebuffer(r.FRAMEBUFFER,null)}function Ee(R,b,C){if(r.bindRenderbuffer(r.RENDERBUFFER,R),b.depthBuffer){let F=b.depthTexture,y=F&&F.isDepthTexture?F.type:null,D=T(b.stencilBuffer,y),N=b.stencilBuffer?r.DEPTH_STENCIL_ATTACHMENT:r.DEPTH_ATTACHMENT;fe(b)?o.renderbufferStorageMultisampleEXT(r.RENDERBUFFER,le(b),D,b.width,b.height):C?r.renderbufferStorageMultisample(r.RENDERBUFFER,le(b),D,b.width,b.height):r.renderbufferStorage(r.RENDERBUFFER,D,b.width,b.height),r.framebufferRenderbuffer(r.FRAMEBUFFER,N,r.RENDERBUFFER,R)}else{let F=b.textures;for(let y=0;y<F.length;y++){let D=F[y],N=s.convert(D.format,D.colorSpace),A=s.convert(D.type),H=S(D.internalFormat,N,A,D.normalized,D.colorSpace);fe(b)?o.renderbufferStorageMultisampleEXT(r.RENDERBUFFER,le(b),H,b.width,b.height):C?r.renderbufferStorageMultisample(r.RENDERBUFFER,le(b),H,b.width,b.height):r.renderbufferStorage(r.RENDERBUFFER,H,b.width,b.height)}}r.bindRenderbuffer(r.RENDERBUFFER,null)}function _e(R,b,C){let F=b.isWebGLCubeRenderTarget===!0;if(t.bindFramebuffer(r.FRAMEBUFFER,R),!b.depthTexture||!b.depthTexture.isDepthTexture)throw new Error("THREE.WebGLTextures: renderTarget.depthTexture must be an instance of THREE.DepthTexture.");let y=i.get(b.depthTexture);if(y.__renderTarget=b,y.__webglTexture&&b.depthTexture.image.width===b.width&&b.depthTexture.image.height===b.height||(b.depthTexture.image.width=b.width,b.depthTexture.image.height=b.height,b.depthTexture.needsUpdate=!0),F){if(y.__webglInit===void 0&&(y.__webglInit=!0,b.depthTexture.addEventListener("dispose",P)),y.__webglTexture===void 0){y.__webglTexture=r.createTexture(),t.bindTexture(r.TEXTURE_CUBE_MAP,y.__webglTexture),V(r.TEXTURE_CUBE_MAP,b.depthTexture);let j=s.convert(b.depthTexture.format),Z=s.convert(b.depthTexture.type),se;b.depthTexture.format===vn?se=r.DEPTH_COMPONENT24:b.depthTexture.format===On&&(se=r.DEPTH24_STENCIL8);for(let xe=0;xe<6;xe++)r.texImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+xe,0,se,b.width,b.height,0,j,Z,null)}}else B(b.depthTexture,0);let D=y.__webglTexture,N=le(b),A=F?r.TEXTURE_CUBE_MAP_POSITIVE_X+C:r.TEXTURE_2D,H=b.depthTexture.format===On?r.DEPTH_STENCIL_ATTACHMENT:r.DEPTH_ATTACHMENT;if(b.depthTexture.format===vn)fe(b)?o.framebufferTexture2DMultisampleEXT(r.FRAMEBUFFER,H,A,D,0,N):r.framebufferTexture2D(r.FRAMEBUFFER,H,A,D,0);else{if(b.depthTexture.format!==On)throw new Error("THREE.WebGLTextures: Unknown depthTexture format.");fe(b)?o.framebufferTexture2DMultisampleEXT(r.FRAMEBUFFER,H,A,D,0,N):r.framebufferTexture2D(r.FRAMEBUFFER,H,A,D,0)}}function ve(R){let b=i.get(R),C=R.isWebGLCubeRenderTarget===!0;if(b.__boundDepthTexture!==R.depthTexture){let F=R.depthTexture;if(b.__depthDisposeCallback&&b.__depthDisposeCallback(),F){let y=()=>{delete b.__boundDepthTexture,delete b.__depthDisposeCallback,F.removeEventListener("dispose",y)};F.addEventListener("dispose",y),b.__depthDisposeCallback=y}b.__boundDepthTexture=F}if(R.depthTexture&&!b.__autoAllocateDepthBuffer)if(C)for(let F=0;F<6;F++)_e(b.__webglFramebuffer[F],R,F);else{let F=R.texture.mipmaps;F&&F.length>0?_e(b.__webglFramebuffer[0],R,0):_e(b.__webglFramebuffer,R,0)}else if(C){b.__webglDepthbuffer=[];for(let F=0;F<6;F++)if(t.bindFramebuffer(r.FRAMEBUFFER,b.__webglFramebuffer[F]),b.__webglDepthbuffer[F]===void 0)b.__webglDepthbuffer[F]=r.createRenderbuffer(),Ee(b.__webglDepthbuffer[F],R,!1);else{let y=R.stencilBuffer?r.DEPTH_STENCIL_ATTACHMENT:r.DEPTH_ATTACHMENT,D=b.__webglDepthbuffer[F];r.bindRenderbuffer(r.RENDERBUFFER,D),r.framebufferRenderbuffer(r.FRAMEBUFFER,y,r.RENDERBUFFER,D)}}else{let F=R.texture.mipmaps;if(F&&F.length>0?t.bindFramebuffer(r.FRAMEBUFFER,b.__webglFramebuffer[0]):t.bindFramebuffer(r.FRAMEBUFFER,b.__webglFramebuffer),b.__webglDepthbuffer===void 0)b.__webglDepthbuffer=r.createRenderbuffer(),Ee(b.__webglDepthbuffer,R,!1);else{let y=R.stencilBuffer?r.DEPTH_STENCIL_ATTACHMENT:r.DEPTH_ATTACHMENT,D=b.__webglDepthbuffer;r.bindRenderbuffer(r.RENDERBUFFER,D),r.framebufferRenderbuffer(r.FRAMEBUFFER,y,r.RENDERBUFFER,D)}}t.bindFramebuffer(r.FRAMEBUFFER,null)}let ie=[],he=[];function le(R){return Math.min(n.maxSamples,R.samples)}function fe(R){let b=i.get(R);return R.samples>0&&e.has("WEBGL_multisampled_render_to_texture")===!0&&b.__useRenderToTexture!==!1}function Ue(R,b){let C=R.colorSpace,F=R.format,y=R.type;return R.isCompressedTexture===!0||R.isVideoTexture===!0||C!==as&&C!==zn&&(He.getTransfer(C)===Ze?F===vi&&y===Zt||be("WebGLTextures: sRGB encoded textures have to use RGBAFormat and UnsignedByteType."):we("WebGLTextures: Unsupported texture color space:",C)),b}function $(R){return typeof HTMLImageElement<"u"&&R instanceof HTMLImageElement?(l.width=R.naturalWidth||R.width,l.height=R.naturalHeight||R.height):typeof VideoFrame<"u"&&R instanceof VideoFrame?(l.width=R.displayWidth,l.height=R.displayHeight):(l.width=R.width,l.height=R.height),l}this.allocateTextureUnit=function(){let R=I;return R>=n.maxTextures&&be("WebGLTextures: Trying to use "+R+" texture units while this GPU supports only "+n.maxTextures),I+=1,R},this.resetTextureUnits=function(){I=0},this.getTextureUnits=function(){return I},this.setTextureUnits=function(R){I=R},this.setTexture2D=B,this.setTexture2DArray=function(R,b){let C=i.get(R);R.isRenderTargetTexture===!1&&R.version>0&&C.__version!==R.version?ne(C,R,b):(R.isExternalTexture&&(C.__webglTexture=R.sourceTexture?R.sourceTexture:null),t.bindTexture(r.TEXTURE_2D_ARRAY,C.__webglTexture,r.TEXTURE0+b))},this.setTexture3D=function(R,b){let C=i.get(R);R.isRenderTargetTexture===!1&&R.version>0&&C.__version!==R.version?ne(C,R,b):t.bindTexture(r.TEXTURE_3D,C.__webglTexture,r.TEXTURE0+b)},this.setTextureCube=function(R,b){let C=i.get(R);R.isCubeDepthTexture!==!0&&R.version>0&&C.__version!==R.version?(function(F,y,D){if(y.image.length!==6)return;let N=Y(F,y),A=y.source;t.bindTexture(r.TEXTURE_CUBE_MAP,F.__webglTexture,r.TEXTURE0+D);let H=i.get(A);if(A.version!==H.__version||N===!0){t.activeTexture(r.TEXTURE0+D);let j=He.getPrimaries(He.workingColorSpace),Z=y.colorSpace===zn?null:He.getPrimaries(y.colorSpace),se=y.colorSpace===zn||j===Z?r.NONE:r.BROWSER_DEFAULT_WEBGL;t.pixelStorei(r.UNPACK_FLIP_Y_WEBGL,y.flipY),t.pixelStorei(r.UNPACK_PREMULTIPLY_ALPHA_WEBGL,y.premultiplyAlpha),t.pixelStorei(r.UNPACK_ALIGNMENT,y.unpackAlignment),t.pixelStorei(r.UNPACK_COLORSPACE_CONVERSION_WEBGL,se);let xe=y.isCompressedTexture||y.image[0].isCompressedTexture,ye=y.image[0]&&y.image[0].isDataTexture,ue=[];for(let Se=0;Se<6;Se++)ue[Se]=xe||ye?ye?y.image[Se].image:y.image[Se]:v(y.image[Se],!0,n.maxCubemapSize),ue[Se]=Ue(y,ue[Se]);let Ce=ue[0],ee=s.convert(y.format,y.colorSpace),ae=s.convert(y.type),re=S(y.internalFormat,ee,ae,y.normalized,y.colorSpace),me=y.isVideoTexture!==!0,et=H.__version===void 0||N===!0,Ye=A.dataReady,ct,Ot=M(y,Ce);if(V(r.TEXTURE_CUBE_MAP,y),xe){me&&et&&t.texStorage2D(r.TEXTURE_CUBE_MAP,Ot,re,Ce.width,Ce.height);for(let Se=0;Se<6;Se++){ct=ue[Se].mipmaps;for(let Je=0;Je<ct.length;Je++){let ze=ct[Je];y.format!==vi?ee!==null?me?Ye&&t.compressedTexSubImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,Je,0,0,ze.width,ze.height,ee,ze.data):t.compressedTexImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,Je,re,ze.width,ze.height,0,ze.data):be("WebGLRenderer: Attempt to load unsupported compressed texture format in .setTextureCube()"):me?Ye&&t.texSubImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,Je,0,0,ze.width,ze.height,ee,ae,ze.data):t.texImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,Je,re,ze.width,ze.height,0,ee,ae,ze.data)}}}else{if(ct=y.mipmaps,me&&et){ct.length>0&&Ot++;let Se=$(ue[0]);t.texStorage2D(r.TEXTURE_CUBE_MAP,Ot,re,Se.width,Se.height)}for(let Se=0;Se<6;Se++)if(ye){me?Ye&&t.texSubImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,0,0,0,ue[Se].width,ue[Se].height,ee,ae,ue[Se].data):t.texImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,0,re,ue[Se].width,ue[Se].height,0,ee,ae,ue[Se].data);for(let Je=0;Je<ct.length;Je++){let ze=ct[Je].image[Se].image;me?Ye&&t.texSubImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,Je+1,0,0,ze.width,ze.height,ee,ae,ze.data):t.texImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,Je+1,re,ze.width,ze.height,0,ee,ae,ze.data)}}else{me?Ye&&t.texSubImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,0,0,0,ee,ae,ue[Se]):t.texImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,0,re,ee,ae,ue[Se]);for(let Je=0;Je<ct.length;Je++){let ze=ct[Je];me?Ye&&t.texSubImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,Je+1,0,0,ee,ae,ze.image[Se]):t.texImage2D(r.TEXTURE_CUBE_MAP_POSITIVE_X+Se,Je+1,re,ee,ae,ze.image[Se])}}}f(y)&&_(r.TEXTURE_CUBE_MAP),H.__version=A.version,y.onUpdate&&y.onUpdate(y)}F.__version=y.version})(C,R,b):t.bindTexture(r.TEXTURE_CUBE_MAP,C.__webglTexture,r.TEXTURE0+b)},this.rebindTextures=function(R,b,C){let F=i.get(R);b!==void 0&&pe(F.__webglFramebuffer,R,R.texture,r.COLOR_ATTACHMENT0,r.TEXTURE_2D,0),C!==void 0&&ve(R)},this.setupRenderTarget=function(R){let b=R.texture,C=i.get(R),F=i.get(b);R.addEventListener("dispose",O);let y=R.textures,D=R.isWebGLCubeRenderTarget===!0,N=y.length>1;if(N||(F.__webglTexture===void 0&&(F.__webglTexture=r.createTexture()),F.__version=b.version,a.memory.textures++),D){C.__webglFramebuffer=[];for(let A=0;A<6;A++)if(b.mipmaps&&b.mipmaps.length>0){C.__webglFramebuffer[A]=[];for(let H=0;H<b.mipmaps.length;H++)C.__webglFramebuffer[A][H]=r.createFramebuffer()}else C.__webglFramebuffer[A]=r.createFramebuffer()}else{if(b.mipmaps&&b.mipmaps.length>0){C.__webglFramebuffer=[];for(let A=0;A<b.mipmaps.length;A++)C.__webglFramebuffer[A]=r.createFramebuffer()}else C.__webglFramebuffer=r.createFramebuffer();if(N)for(let A=0,H=y.length;A<H;A++){let j=i.get(y[A]);j.__webglTexture===void 0&&(j.__webglTexture=r.createTexture(),a.memory.textures++)}if(R.samples>0&&fe(R)===!1){C.__webglMultisampledFramebuffer=r.createFramebuffer(),C.__webglColorRenderbuffer=[],t.bindFramebuffer(r.FRAMEBUFFER,C.__webglMultisampledFramebuffer);for(let A=0;A<y.length;A++){let H=y[A];C.__webglColorRenderbuffer[A]=r.createRenderbuffer(),r.bindRenderbuffer(r.RENDERBUFFER,C.__webglColorRenderbuffer[A]);let j=s.convert(H.format,H.colorSpace),Z=s.convert(H.type),se=S(H.internalFormat,j,Z,H.normalized,H.colorSpace,R.isXRRenderTarget===!0),xe=le(R);r.renderbufferStorageMultisample(r.RENDERBUFFER,xe,se,R.width,R.height),r.framebufferRenderbuffer(r.FRAMEBUFFER,r.COLOR_ATTACHMENT0+A,r.RENDERBUFFER,C.__webglColorRenderbuffer[A])}r.bindRenderbuffer(r.RENDERBUFFER,null),R.depthBuffer&&(C.__webglDepthRenderbuffer=r.createRenderbuffer(),Ee(C.__webglDepthRenderbuffer,R,!0)),t.bindFramebuffer(r.FRAMEBUFFER,null)}}if(D){t.bindTexture(r.TEXTURE_CUBE_MAP,F.__webglTexture),V(r.TEXTURE_CUBE_MAP,b);for(let A=0;A<6;A++)if(b.mipmaps&&b.mipmaps.length>0)for(let H=0;H<b.mipmaps.length;H++)pe(C.__webglFramebuffer[A][H],R,b,r.COLOR_ATTACHMENT0,r.TEXTURE_CUBE_MAP_POSITIVE_X+A,H);else pe(C.__webglFramebuffer[A],R,b,r.COLOR_ATTACHMENT0,r.TEXTURE_CUBE_MAP_POSITIVE_X+A,0);f(b)&&_(r.TEXTURE_CUBE_MAP),t.unbindTexture()}else if(N){for(let A=0,H=y.length;A<H;A++){let j=y[A],Z=i.get(j),se=r.TEXTURE_2D;(R.isWebGL3DRenderTarget||R.isWebGLArrayRenderTarget)&&(se=R.isWebGL3DRenderTarget?r.TEXTURE_3D:r.TEXTURE_2D_ARRAY),t.bindTexture(se,Z.__webglTexture),V(se,j),pe(C.__webglFramebuffer,R,j,r.COLOR_ATTACHMENT0+A,se,0),f(j)&&_(se)}t.unbindTexture()}else{let A=r.TEXTURE_2D;if((R.isWebGL3DRenderTarget||R.isWebGLArrayRenderTarget)&&(A=R.isWebGL3DRenderTarget?r.TEXTURE_3D:r.TEXTURE_2D_ARRAY),t.bindTexture(A,F.__webglTexture),V(A,b),b.mipmaps&&b.mipmaps.length>0)for(let H=0;H<b.mipmaps.length;H++)pe(C.__webglFramebuffer[H],R,b,r.COLOR_ATTACHMENT0,A,H);else pe(C.__webglFramebuffer,R,b,r.COLOR_ATTACHMENT0,A,0);f(b)&&_(A),t.unbindTexture()}R.depthBuffer&&ve(R)},this.updateRenderTargetMipmap=function(R){let b=R.textures;for(let C=0,F=b.length;C<F;C++){let y=b[C];if(f(y)){let D=x(R),N=i.get(y).__webglTexture;t.bindTexture(D,N),_(D),t.unbindTexture()}}},this.updateMultisampleRenderTarget=function(R){if(R.samples>0){if(fe(R)===!1){let b=R.textures,C=R.width,F=R.height,y=r.COLOR_BUFFER_BIT,D=R.stencilBuffer?r.DEPTH_STENCIL_ATTACHMENT:r.DEPTH_ATTACHMENT,N=i.get(R),A=b.length>1;if(A)for(let j=0;j<b.length;j++)t.bindFramebuffer(r.FRAMEBUFFER,N.__webglMultisampledFramebuffer),r.framebufferRenderbuffer(r.FRAMEBUFFER,r.COLOR_ATTACHMENT0+j,r.RENDERBUFFER,null),t.bindFramebuffer(r.FRAMEBUFFER,N.__webglFramebuffer),r.framebufferTexture2D(r.DRAW_FRAMEBUFFER,r.COLOR_ATTACHMENT0+j,r.TEXTURE_2D,null,0);t.bindFramebuffer(r.READ_FRAMEBUFFER,N.__webglMultisampledFramebuffer);let H=R.texture.mipmaps;H&&H.length>0?t.bindFramebuffer(r.DRAW_FRAMEBUFFER,N.__webglFramebuffer[0]):t.bindFramebuffer(r.DRAW_FRAMEBUFFER,N.__webglFramebuffer);for(let j=0;j<b.length;j++){if(R.resolveDepthBuffer&&(R.depthBuffer&&(y|=r.DEPTH_BUFFER_BIT),R.stencilBuffer&&R.resolveStencilBuffer&&(y|=r.STENCIL_BUFFER_BIT)),A){r.framebufferRenderbuffer(r.READ_FRAMEBUFFER,r.COLOR_ATTACHMENT0,r.RENDERBUFFER,N.__webglColorRenderbuffer[j]);let Z=i.get(b[j]).__webglTexture;r.framebufferTexture2D(r.DRAW_FRAMEBUFFER,r.COLOR_ATTACHMENT0,r.TEXTURE_2D,Z,0)}r.blitFramebuffer(0,0,C,F,0,0,C,F,y,r.NEAREST),c===!0&&(ie.length=0,he.length=0,ie.push(r.COLOR_ATTACHMENT0+j),R.depthBuffer&&R.resolveDepthBuffer===!1&&(ie.push(D),he.push(D),r.invalidateFramebuffer(r.DRAW_FRAMEBUFFER,he)),r.invalidateFramebuffer(r.READ_FRAMEBUFFER,ie))}if(t.bindFramebuffer(r.READ_FRAMEBUFFER,null),t.bindFramebuffer(r.DRAW_FRAMEBUFFER,null),A)for(let j=0;j<b.length;j++){t.bindFramebuffer(r.FRAMEBUFFER,N.__webglMultisampledFramebuffer),r.framebufferRenderbuffer(r.FRAMEBUFFER,r.COLOR_ATTACHMENT0+j,r.RENDERBUFFER,N.__webglColorRenderbuffer[j]);let Z=i.get(b[j]).__webglTexture;t.bindFramebuffer(r.FRAMEBUFFER,N.__webglFramebuffer),r.framebufferTexture2D(r.DRAW_FRAMEBUFFER,r.COLOR_ATTACHMENT0+j,r.TEXTURE_2D,Z,0)}t.bindFramebuffer(r.DRAW_FRAMEBUFFER,N.__webglMultisampledFramebuffer)}else if(R.depthBuffer&&R.resolveDepthBuffer===!1&&c){let b=R.stencilBuffer?r.DEPTH_STENCIL_ATTACHMENT:r.DEPTH_ATTACHMENT;r.invalidateFramebuffer(r.DRAW_FRAMEBUFFER,[b])}}},this.setupDepthRenderbuffer=ve,this.setupFrameBufferTexture=pe,this.useMultisampledRTT=fe,this.isReversedDepthBuffer=function(){return t.buffers.depth.getReversed()}}function kf(r,e){return{convert:function(t,i=zn){let n,s=He.getTransfer(i);if(t===Zt)return r.UNSIGNED_BYTE;if(t===To)return r.UNSIGNED_SHORT_4_4_4_4;if(t===Eo)return r.UNSIGNED_SHORT_5_5_5_1;if(t===mc)return r.UNSIGNED_INT_5_9_9_9_REV;if(t===fc)return r.UNSIGNED_INT_10F_11F_11F_REV;if(t===dc)return r.BYTE;if(t===pc)return r.SHORT;if(t===Or)return r.UNSIGNED_SHORT;if(t===bo)return r.INT;if(t===$i)return r.UNSIGNED_INT;if(t===_i)return r.FLOAT;if(t===Li)return r.HALF_FLOAT;if(t===ad)return r.ALPHA;if(t===od)return r.RGB;if(t===vi)return r.RGBA;if(t===vn)return r.DEPTH_COMPONENT;if(t===On)return r.DEPTH_STENCIL;if(t===gc)return r.RED;if(t===wo)return r.RED_INTEGER;if(t===Bn)return r.RG;if(t===_c)return r.RG_INTEGER;if(t===vc)return r.RGBA_INTEGER;if(t===Ao||t===Co||t===Ro||t===Po)if(s===Ze){if(n=e.get("WEBGL_compressed_texture_s3tc_srgb"),n===null)return null;if(t===Ao)return n.COMPRESSED_SRGB_S3TC_DXT1_EXT;if(t===Co)return n.COMPRESSED_SRGB_ALPHA_S3TC_DXT1_EXT;if(t===Ro)return n.COMPRESSED_SRGB_ALPHA_S3TC_DXT3_EXT;if(t===Po)return n.COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT}else{if(n=e.get("WEBGL_compressed_texture_s3tc"),n===null)return null;if(t===Ao)return n.COMPRESSED_RGB_S3TC_DXT1_EXT;if(t===Co)return n.COMPRESSED_RGBA_S3TC_DXT1_EXT;if(t===Ro)return n.COMPRESSED_RGBA_S3TC_DXT3_EXT;if(t===Po)return n.COMPRESSED_RGBA_S3TC_DXT5_EXT}if(t===xc||t===yc||t===Mc||t===Sc){if(n=e.get("WEBGL_compressed_texture_pvrtc"),n===null)return null;if(t===xc)return n.COMPRESSED_RGB_PVRTC_4BPPV1_IMG;if(t===yc)return n.COMPRESSED_RGB_PVRTC_2BPPV1_IMG;if(t===Mc)return n.COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;if(t===Sc)return n.COMPRESSED_RGBA_PVRTC_2BPPV1_IMG}if(t===bc||t===Tc||t===Ec||t===wc||t===Ac||t===Io||t===Cc){if(n=e.get("WEBGL_compressed_texture_etc"),n===null)return null;if(t===bc||t===Tc)return s===Ze?n.COMPRESSED_SRGB8_ETC2:n.COMPRESSED_RGB8_ETC2;if(t===Ec)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ETC2_EAC:n.COMPRESSED_RGBA8_ETC2_EAC;if(t===wc)return n.COMPRESSED_R11_EAC;if(t===Ac)return n.COMPRESSED_SIGNED_R11_EAC;if(t===Io)return n.COMPRESSED_RG11_EAC;if(t===Cc)return n.COMPRESSED_SIGNED_RG11_EAC}if(t===Rc||t===Pc||t===Ic||t===Lc||t===Nc||t===Dc||t===Uc||t===Fc||t===Oc||t===Bc||t===zc||t===Gc||t===Vc||t===Hc){if(n=e.get("WEBGL_compressed_texture_astc"),n===null)return null;if(t===Rc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_4x4_KHR:n.COMPRESSED_RGBA_ASTC_4x4_KHR;if(t===Pc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_5x4_KHR:n.COMPRESSED_RGBA_ASTC_5x4_KHR;if(t===Ic)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_5x5_KHR:n.COMPRESSED_RGBA_ASTC_5x5_KHR;if(t===Lc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_6x5_KHR:n.COMPRESSED_RGBA_ASTC_6x5_KHR;if(t===Nc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_6x6_KHR:n.COMPRESSED_RGBA_ASTC_6x6_KHR;if(t===Dc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_8x5_KHR:n.COMPRESSED_RGBA_ASTC_8x5_KHR;if(t===Uc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_8x6_KHR:n.COMPRESSED_RGBA_ASTC_8x6_KHR;if(t===Fc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_8x8_KHR:n.COMPRESSED_RGBA_ASTC_8x8_KHR;if(t===Oc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_10x5_KHR:n.COMPRESSED_RGBA_ASTC_10x5_KHR;if(t===Bc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_10x6_KHR:n.COMPRESSED_RGBA_ASTC_10x6_KHR;if(t===zc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_10x8_KHR:n.COMPRESSED_RGBA_ASTC_10x8_KHR;if(t===Gc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_10x10_KHR:n.COMPRESSED_RGBA_ASTC_10x10_KHR;if(t===Vc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_12x10_KHR:n.COMPRESSED_RGBA_ASTC_12x10_KHR;if(t===Hc)return s===Ze?n.COMPRESSED_SRGB8_ALPHA8_ASTC_12x12_KHR:n.COMPRESSED_RGBA_ASTC_12x12_KHR}if(t===kc||t===Wc||t===Xc){if(n=e.get("EXT_texture_compression_bptc"),n===null)return null;if(t===kc)return s===Ze?n.COMPRESSED_SRGB_ALPHA_BPTC_UNORM_EXT:n.COMPRESSED_RGBA_BPTC_UNORM_EXT;if(t===Wc)return n.COMPRESSED_RGB_BPTC_SIGNED_FLOAT_EXT;if(t===Xc)return n.COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_EXT}if(t===jc||t===qc||t===Lo||t===Yc){if(n=e.get("EXT_texture_compression_rgtc"),n===null)return null;if(t===jc)return n.COMPRESSED_RED_RGTC1_EXT;if(t===qc)return n.COMPRESSED_SIGNED_RED_RGTC1_EXT;if(t===Lo)return n.COMPRESSED_RED_GREEN_RGTC2_EXT;if(t===Yc)return n.COMPRESSED_SIGNED_RED_GREEN_RGTC2_EXT}return t===Br?r.UNSIGNED_INT_24_8:r[t]!==void 0?r[t]:null}}}var fh=class{constructor(){this.texture=null,this.mesh=null,this.depthNear=0,this.depthFar=0}init(e,t){if(this.texture===null){let i=new _s(e.texture);e.depthNear===t.depthNear&&e.depthFar===t.depthFar||(this.depthNear=e.depthNear,this.depthFar=e.depthFar),this.texture=i}}getMesh(e){if(this.texture!==null&&this.mesh===null){let t=e.cameras[0].viewport,i=new zt({vertexShader:`
void main() {

	gl_Position = vec4( position, 1.0 );

}`,fragmentShader:`
uniform sampler2DArray depthColor;
uniform float depthWidth;
uniform float depthHeight;

void main() {

	vec2 coord = vec2( gl_FragCoord.x / depthWidth, gl_FragCoord.y / depthHeight );

	if ( coord.x >= 1.0 ) {

		gl_FragDepth = texture( depthColor, vec3( coord.x - 1.0, coord.y, 1 ) ).r;

	} else {

		gl_FragDepth = texture( depthColor, vec3( coord.x, coord.y, 0 ) ).r;

	}

}`,uniforms:{depthColor:{value:this.texture},depthWidth:{value:t.z},depthHeight:{value:t.w}}});this.mesh=new Oe(new gn(20,20),i)}return this.mesh}reset(){this.texture=null,this.mesh=null}getDepthTexture(){return this.texture}},gh=class extends Ri{constructor(e,t){super();let i=this,n=null,s=1,a=null,o="local-floor",c=1,l=null,h=null,d=null,p=null,u=null,g=null,m=typeof XRWebGLBinding<"u",v=new fh,f={},_=t.getContextAttributes(),x=null,S=null,T=[],M=[],P=new te,O=null,L=new Rt;L.viewport=new $e;let I=new Rt;I.viewport=new $e;let B=[L,I],U=new vo,X=null,k=null;function V(ie){let he=M.indexOf(ie.inputSource);if(he===-1)return;let le=T[he];le!==void 0&&(le.update(ie.inputSource,ie.frame,l||a),le.dispatchEvent({type:ie.type,data:ie.inputSource}))}function Y(){n.removeEventListener("select",V),n.removeEventListener("selectstart",V),n.removeEventListener("selectend",V),n.removeEventListener("squeeze",V),n.removeEventListener("squeezestart",V),n.removeEventListener("squeezeend",V),n.removeEventListener("end",Y),n.removeEventListener("inputsourceschange",W);for(let ie=0;ie<T.length;ie++){let he=M[ie];he!==null&&(M[ie]=null,T[ie].disconnect(he))}X=null,k=null,v.reset();for(let ie in f)delete f[ie];e.setRenderTarget(x),u=null,p=null,d=null,n=null,S=null,ve.stop(),i.isPresenting=!1,e.setPixelRatio(O),e.setSize(P.width,P.height,!1),i.dispatchEvent({type:"sessionend"})}function W(ie){for(let he=0;he<ie.removed.length;he++){let le=ie.removed[he],fe=M.indexOf(le);fe>=0&&(M[fe]=null,T[fe].disconnect(le))}for(let he=0;he<ie.added.length;he++){let le=ie.added[he],fe=M.indexOf(le);if(fe===-1){for(let $=0;$<T.length;$++){if($>=M.length){M.push(le),fe=$;break}if(M[$]===null){M[$]=le,fe=$;break}}if(fe===-1)break}let Ue=T[fe];Ue&&Ue.connect(le)}}this.cameraAutoUpdate=!0,this.enabled=!1,this.isPresenting=!1,this.getController=function(ie){let he=T[ie];return he===void 0&&(he=new vr,T[ie]=he),he.getTargetRaySpace()},this.getControllerGrip=function(ie){let he=T[ie];return he===void 0&&(he=new vr,T[ie]=he),he.getGripSpace()},this.getHand=function(ie){let he=T[ie];return he===void 0&&(he=new vr,T[ie]=he),he.getHandSpace()},this.setFramebufferScaleFactor=function(ie){s=ie,i.isPresenting===!0&&be("WebXRManager: Cannot change framebuffer scale while presenting.")},this.setReferenceSpaceType=function(ie){o=ie,i.isPresenting===!0&&be("WebXRManager: Cannot change reference space type while presenting.")},this.getReferenceSpace=function(){return l||a},this.setReferenceSpace=function(ie){l=ie},this.getBaseLayer=function(){return p!==null?p:u},this.getBinding=function(){return d===null&&m&&(d=new XRWebGLBinding(n,t)),d},this.getFrame=function(){return g},this.getSession=function(){return n},this.setSession=async function(ie){if(n=ie,n!==null){if(x=e.getRenderTarget(),n.addEventListener("select",V),n.addEventListener("selectstart",V),n.addEventListener("selectend",V),n.addEventListener("squeeze",V),n.addEventListener("squeezestart",V),n.addEventListener("squeezeend",V),n.addEventListener("end",Y),n.addEventListener("inputsourceschange",W),_.xrCompatible!==!0&&await t.makeXRCompatible(),O=e.getPixelRatio(),e.getSize(P),m&&"createProjectionLayer"in XRWebGLBinding.prototype){let he=null,le=null,fe=null;_.depth&&(fe=_.stencil?t.DEPTH24_STENCIL8:t.DEPTH_COMPONENT24,he=_.stencil?On:vn,le=_.stencil?Br:$i);let Ue={colorFormat:t.RGBA8,depthFormat:fe,scaleFactor:s};d=this.getBinding(),p=d.createProjectionLayer(Ue),n.updateRenderState({layers:[p]}),e.setPixelRatio(1),e.setSize(p.textureWidth,p.textureHeight,!1),S=new jt(p.textureWidth,p.textureHeight,{format:vi,type:Zt,depthTexture:new Zi(p.textureWidth,p.textureHeight,le,void 0,void 0,void 0,void 0,void 0,void 0,he),stencilBuffer:_.stencil,colorSpace:e.outputColorSpace,samples:_.antialias?4:0,resolveDepthBuffer:p.ignoreDepthValues===!1,resolveStencilBuffer:p.ignoreDepthValues===!1})}else{let he={antialias:_.antialias,alpha:!0,depth:_.depth,stencil:_.stencil,framebufferScaleFactor:s};u=new XRWebGLLayer(n,t,he),n.updateRenderState({baseLayer:u}),e.setPixelRatio(1),e.setSize(u.framebufferWidth,u.framebufferHeight,!1),S=new jt(u.framebufferWidth,u.framebufferHeight,{format:vi,type:Zt,colorSpace:e.outputColorSpace,stencilBuffer:_.stencil,resolveDepthBuffer:u.ignoreDepthValues===!1,resolveStencilBuffer:u.ignoreDepthValues===!1})}S.isXRRenderTarget=!0,this.setFoveation(c),l=null,a=await n.requestReferenceSpace(o),ve.setContext(n),ve.start(),i.isPresenting=!0,i.dispatchEvent({type:"sessionstart"})}},this.getEnvironmentBlendMode=function(){if(n!==null)return n.environmentBlendMode},this.getDepthTexture=function(){return v.getDepthTexture()};let ne=new w,pe=new w;function Ee(ie,he){he===null?ie.matrixWorld.copy(ie.matrix):ie.matrixWorld.multiplyMatrices(he.matrixWorld,ie.matrix),ie.matrixWorldInverse.copy(ie.matrixWorld).invert()}this.updateCamera=function(ie){if(n===null)return;let he=ie.near,le=ie.far;v.texture!==null&&(v.depthNear>0&&(he=v.depthNear),v.depthFar>0&&(le=v.depthFar)),U.near=I.near=L.near=he,U.far=I.far=L.far=le,X===U.near&&k===U.far||(n.updateRenderState({depthNear:U.near,depthFar:U.far}),X=U.near,k=U.far),U.layers.mask=6|ie.layers.mask,L.layers.mask=-5&U.layers.mask,I.layers.mask=-3&U.layers.mask;let fe=ie.parent,Ue=U.cameras;Ee(U,fe);for(let $=0;$<Ue.length;$++)Ee(Ue[$],fe);Ue.length===2?(function($,R,b){ne.setFromMatrixPosition(R.matrixWorld),pe.setFromMatrixPosition(b.matrixWorld);let C=ne.distanceTo(pe),F=R.projectionMatrix.elements,y=b.projectionMatrix.elements,D=F[14]/(F[10]-1),N=F[14]/(F[10]+1),A=(F[9]+1)/F[5],H=(F[9]-1)/F[5],j=(F[8]-1)/F[0],Z=(y[8]+1)/y[0],se=D*j,xe=D*Z,ye=C/(-j+Z),ue=ye*-j;if(R.matrixWorld.decompose($.position,$.quaternion,$.scale),$.translateX(ue),$.translateZ(ye),$.matrixWorld.compose($.position,$.quaternion,$.scale),$.matrixWorldInverse.copy($.matrixWorld).invert(),F[10]===-1)$.projectionMatrix.copy(R.projectionMatrix),$.projectionMatrixInverse.copy(R.projectionMatrixInverse);else{let Ce=D+ye,ee=N+ye,ae=se-ue,re=xe+(C-ue),me=A*N/ee*Ce,et=H*N/ee*Ce;$.projectionMatrix.makePerspective(ae,re,me,et,Ce,ee),$.projectionMatrixInverse.copy($.projectionMatrix).invert()}})(U,L,I):U.projectionMatrix.copy(L.projectionMatrix),(function($,R,b){b===null?$.matrix.copy(R.matrixWorld):($.matrix.copy(b.matrixWorld),$.matrix.invert(),$.matrix.multiply(R.matrixWorld)),$.matrix.decompose($.position,$.quaternion,$.scale),$.updateMatrixWorld(!0),$.projectionMatrix.copy(R.projectionMatrix),$.projectionMatrixInverse.copy(R.projectionMatrixInverse),$.isPerspectiveCamera&&($.fov=2*gr*Math.atan(1/$.projectionMatrix.elements[5]),$.zoom=1)})(ie,U,fe)},this.getCamera=function(){return U},this.getFoveation=function(){if(p!==null||u!==null)return c},this.setFoveation=function(ie){c=ie,p!==null&&(p.fixedFoveation=ie),u!==null&&u.fixedFoveation!==void 0&&(u.fixedFoveation=ie)},this.hasDepthSensing=function(){return v.texture!==null},this.getDepthSensingMesh=function(){return v.getMesh(U)},this.getCameraTexture=function(ie){return f[ie]};let _e=null,ve=new Yd;ve.setAnimationLoop(function(ie,he){if(h=he.getViewerPose(l||a),g=he,h!==null){let le=h.views;u!==null&&(e.setRenderTargetFramebuffer(S,u.framebuffer),e.setRenderTarget(S));let fe=!1;le.length!==U.cameras.length&&(U.cameras.length=0,fe=!0);for(let $=0;$<le.length;$++){let R=le[$],b=null;if(u!==null)b=u.getViewport(R);else{let F=d.getViewSubImage(p,R);b=F.viewport,$===0&&(e.setRenderTargetTextures(S,F.colorTexture,F.depthStencilTexture),e.setRenderTarget(S))}let C=B[$];C===void 0&&(C=new Rt,C.layers.enable($),C.viewport=new $e,B[$]=C),C.matrix.fromArray(R.transform.matrix),C.matrix.decompose(C.position,C.quaternion,C.scale),C.projectionMatrix.fromArray(R.projectionMatrix),C.projectionMatrixInverse.copy(C.projectionMatrix).invert(),C.viewport.set(b.x,b.y,b.width,b.height),$===0&&(U.matrix.copy(C.matrix),U.matrix.decompose(U.position,U.quaternion,U.scale)),fe===!0&&U.cameras.push(C)}let Ue=n.enabledFeatures;if(Ue&&Ue.includes("depth-sensing")&&n.depthUsage=="gpu-optimized"&&m){d=i.getBinding();let $=d.getDepthInformation(le[0]);$&&$.isValid&&$.texture&&v.init($,n.renderState)}if(Ue&&Ue.includes("camera-access")&&m){e.state.unbindTexture(),d=i.getBinding();for(let $=0;$<le.length;$++){let R=le[$].camera;if(R){let b=f[R];b||(b=new _s,f[R]=b);let C=d.getCameraImage(R);b.sourceTexture=C}}}}for(let le=0;le<T.length;le++){let fe=M[le],Ue=T[le];fe!==null&&Ue!==void 0&&Ue.update(fe,he,l||a)}_e&&_e(ie,he),he.detectedPlanes&&i.dispatchEvent({type:"planesdetected",data:he}),g=null}),this.setAnimationLoop=function(ie){_e=ie},this.dispose=function(){}}},Wf=new Fe,ep=new Ne;function Xf(r,e){function t(n,s){n.matrixAutoUpdate===!0&&n.updateMatrix(),s.value.copy(n.matrix)}function i(n,s){n.opacity.value=s.opacity,s.color&&n.diffuse.value.copy(s.color),s.emissive&&n.emissive.value.copy(s.emissive).multiplyScalar(s.emissiveIntensity),s.map&&(n.map.value=s.map,t(s.map,n.mapTransform)),s.alphaMap&&(n.alphaMap.value=s.alphaMap,t(s.alphaMap,n.alphaMapTransform)),s.bumpMap&&(n.bumpMap.value=s.bumpMap,t(s.bumpMap,n.bumpMapTransform),n.bumpScale.value=s.bumpScale,s.side===Gt&&(n.bumpScale.value*=-1)),s.normalMap&&(n.normalMap.value=s.normalMap,t(s.normalMap,n.normalMapTransform),n.normalScale.value.copy(s.normalScale),s.side===Gt&&n.normalScale.value.negate()),s.displacementMap&&(n.displacementMap.value=s.displacementMap,t(s.displacementMap,n.displacementMapTransform),n.displacementScale.value=s.displacementScale,n.displacementBias.value=s.displacementBias),s.emissiveMap&&(n.emissiveMap.value=s.emissiveMap,t(s.emissiveMap,n.emissiveMapTransform)),s.specularMap&&(n.specularMap.value=s.specularMap,t(s.specularMap,n.specularMapTransform)),s.alphaTest>0&&(n.alphaTest.value=s.alphaTest);let a=e.get(s),o=a.envMap,c=a.envMapRotation;o&&(n.envMap.value=o,n.envMapRotation.value.setFromMatrix4(Wf.makeRotationFromEuler(c)).transpose(),o.isCubeTexture&&o.isRenderTargetTexture===!1&&n.envMapRotation.value.premultiply(ep),n.reflectivity.value=s.reflectivity,n.ior.value=s.ior,n.refractionRatio.value=s.refractionRatio),s.lightMap&&(n.lightMap.value=s.lightMap,n.lightMapIntensity.value=s.lightMapIntensity,t(s.lightMap,n.lightMapTransform)),s.aoMap&&(n.aoMap.value=s.aoMap,n.aoMapIntensity.value=s.aoMapIntensity,t(s.aoMap,n.aoMapTransform))}return{refreshFogUniforms:function(n,s){s.color.getRGB(n.fogColor.value,Qc(r)),s.isFog?(n.fogNear.value=s.near,n.fogFar.value=s.far):s.isFogExp2&&(n.fogDensity.value=s.density)},refreshMaterialUniforms:function(n,s,a,o,c){s.isNodeMaterial?s.uniformsNeedUpdate=!1:s.isMeshBasicMaterial?i(n,s):s.isMeshLambertMaterial?(i(n,s),s.envMap&&(n.envMapIntensity.value=s.envMapIntensity)):s.isMeshToonMaterial?(i(n,s),(function(l,h){h.gradientMap&&(l.gradientMap.value=h.gradientMap)})(n,s)):s.isMeshPhongMaterial?(i(n,s),(function(l,h){l.specular.value.copy(h.specular),l.shininess.value=Math.max(h.shininess,1e-4)})(n,s),s.envMap&&(n.envMapIntensity.value=s.envMapIntensity)):s.isMeshStandardMaterial?(i(n,s),(function(l,h){l.metalness.value=h.metalness,h.metalnessMap&&(l.metalnessMap.value=h.metalnessMap,t(h.metalnessMap,l.metalnessMapTransform)),l.roughness.value=h.roughness,h.roughnessMap&&(l.roughnessMap.value=h.roughnessMap,t(h.roughnessMap,l.roughnessMapTransform)),h.envMap&&(l.envMapIntensity.value=h.envMapIntensity)})(n,s),s.isMeshPhysicalMaterial&&(function(l,h,d){l.ior.value=h.ior,h.sheen>0&&(l.sheenColor.value.copy(h.sheenColor).multiplyScalar(h.sheen),l.sheenRoughness.value=h.sheenRoughness,h.sheenColorMap&&(l.sheenColorMap.value=h.sheenColorMap,t(h.sheenColorMap,l.sheenColorMapTransform)),h.sheenRoughnessMap&&(l.sheenRoughnessMap.value=h.sheenRoughnessMap,t(h.sheenRoughnessMap,l.sheenRoughnessMapTransform))),h.clearcoat>0&&(l.clearcoat.value=h.clearcoat,l.clearcoatRoughness.value=h.clearcoatRoughness,h.clearcoatMap&&(l.clearcoatMap.value=h.clearcoatMap,t(h.clearcoatMap,l.clearcoatMapTransform)),h.clearcoatRoughnessMap&&(l.clearcoatRoughnessMap.value=h.clearcoatRoughnessMap,t(h.clearcoatRoughnessMap,l.clearcoatRoughnessMapTransform)),h.clearcoatNormalMap&&(l.clearcoatNormalMap.value=h.clearcoatNormalMap,t(h.clearcoatNormalMap,l.clearcoatNormalMapTransform),l.clearcoatNormalScale.value.copy(h.clearcoatNormalScale),h.side===Gt&&l.clearcoatNormalScale.value.negate())),h.dispersion>0&&(l.dispersion.value=h.dispersion),h.iridescence>0&&(l.iridescence.value=h.iridescence,l.iridescenceIOR.value=h.iridescenceIOR,l.iridescenceThicknessMinimum.value=h.iridescenceThicknessRange[0],l.iridescenceThicknessMaximum.value=h.iridescenceThicknessRange[1],h.iridescenceMap&&(l.iridescenceMap.value=h.iridescenceMap,t(h.iridescenceMap,l.iridescenceMapTransform)),h.iridescenceThicknessMap&&(l.iridescenceThicknessMap.value=h.iridescenceThicknessMap,t(h.iridescenceThicknessMap,l.iridescenceThicknessMapTransform))),h.transmission>0&&(l.transmission.value=h.transmission,l.transmissionSamplerMap.value=d.texture,l.transmissionSamplerSize.value.set(d.width,d.height),h.transmissionMap&&(l.transmissionMap.value=h.transmissionMap,t(h.transmissionMap,l.transmissionMapTransform)),l.thickness.value=h.thickness,h.thicknessMap&&(l.thicknessMap.value=h.thicknessMap,t(h.thicknessMap,l.thicknessMapTransform)),l.attenuationDistance.value=h.attenuationDistance,l.attenuationColor.value.copy(h.attenuationColor)),h.anisotropy>0&&(l.anisotropyVector.value.set(h.anisotropy*Math.cos(h.anisotropyRotation),h.anisotropy*Math.sin(h.anisotropyRotation)),h.anisotropyMap&&(l.anisotropyMap.value=h.anisotropyMap,t(h.anisotropyMap,l.anisotropyMapTransform))),l.specularIntensity.value=h.specularIntensity,l.specularColor.value.copy(h.specularColor),h.specularColorMap&&(l.specularColorMap.value=h.specularColorMap,t(h.specularColorMap,l.specularColorMapTransform)),h.specularIntensityMap&&(l.specularIntensityMap.value=h.specularIntensityMap,t(h.specularIntensityMap,l.specularIntensityMapTransform))})(n,s,c)):s.isMeshMatcapMaterial?(i(n,s),(function(l,h){h.matcap&&(l.matcap.value=h.matcap)})(n,s)):s.isMeshDepthMaterial?i(n,s):s.isMeshDistanceMaterial?(i(n,s),(function(l,h){let d=e.get(h).light;l.referencePosition.value.setFromMatrixPosition(d.matrixWorld),l.nearDistance.value=d.shadow.camera.near,l.farDistance.value=d.shadow.camera.far})(n,s)):s.isMeshNormalMaterial?i(n,s):s.isLineBasicMaterial?((function(l,h){l.diffuse.value.copy(h.color),l.opacity.value=h.opacity,h.map&&(l.map.value=h.map,t(h.map,l.mapTransform))})(n,s),s.isLineDashedMaterial&&(function(l,h){l.dashSize.value=h.dashSize,l.totalSize.value=h.dashSize+h.gapSize,l.scale.value=h.scale})(n,s)):s.isPointsMaterial?(function(l,h,d,p){l.diffuse.value.copy(h.color),l.opacity.value=h.opacity,l.size.value=h.size*d,l.scale.value=.5*p,h.map&&(l.map.value=h.map,t(h.map,l.uvTransform)),h.alphaMap&&(l.alphaMap.value=h.alphaMap,t(h.alphaMap,l.alphaMapTransform)),h.alphaTest>0&&(l.alphaTest.value=h.alphaTest)})(n,s,a,o):s.isSpriteMaterial?(function(l,h){l.diffuse.value.copy(h.color),l.opacity.value=h.opacity,l.rotation.value=h.rotation,h.map&&(l.map.value=h.map,t(h.map,l.mapTransform)),h.alphaMap&&(l.alphaMap.value=h.alphaMap,t(h.alphaMap,l.alphaMapTransform)),h.alphaTest>0&&(l.alphaTest.value=h.alphaTest)})(n,s):s.isShadowMaterial?(n.color.value.copy(s.color),n.opacity.value=s.opacity):s.isShaderMaterial&&(s.uniformsNeedUpdate=!1)}}}function jf(r,e,t,i){let n={},s={},a=[],o=r.getParameter(r.MAX_UNIFORM_BUFFER_BINDINGS);function c(p,u,g,m){if((function(v,f,_,x){let S=v.value,T=f+"_"+_;if(x[T]===void 0)return typeof S=="number"||typeof S=="boolean"?x[T]=S:ArrayBuffer.isView(S)?x[T]=S.slice():x[T]=S.clone(),!0;{let M=x[T];if(typeof S=="number"||typeof S=="boolean"){if(M!==S)return x[T]=S,!0}else{if(ArrayBuffer.isView(S))return!0;if(M.equals(S)===!1)return M.copy(S),!0}}return!1})(p,u,g,m)===!0){let v=p.__offset,f=p.value;if(Array.isArray(f)){let _=0;for(let x=0;x<f.length;x++){let S=f[x],T=h(S);l(S,p.__data,_),typeof S=="number"||typeof S=="boolean"||S.isMatrix3||ArrayBuffer.isView(S)||(_+=T.storage/Float32Array.BYTES_PER_ELEMENT)}}else l(f,p.__data,0);r.bufferSubData(r.UNIFORM_BUFFER,v,p.__data)}}function l(p,u,g){typeof p=="number"||typeof p=="boolean"?u[0]=p:p.isMatrix3?(u[0]=p.elements[0],u[1]=p.elements[1],u[2]=p.elements[2],u[3]=0,u[4]=p.elements[3],u[5]=p.elements[4],u[6]=p.elements[5],u[7]=0,u[8]=p.elements[6],u[9]=p.elements[7],u[10]=p.elements[8],u[11]=0):ArrayBuffer.isView(p)?u.set(new p.constructor(p.buffer,p.byteOffset,u.length)):p.toArray(u,g)}function h(p){let u={boundary:0,storage:0};return typeof p=="number"||typeof p=="boolean"?(u.boundary=4,u.storage=4):p.isVector2?(u.boundary=8,u.storage=8):p.isVector3||p.isColor?(u.boundary=16,u.storage=12):p.isVector4?(u.boundary=16,u.storage=16):p.isMatrix3?(u.boundary=48,u.storage=48):p.isMatrix4?(u.boundary=64,u.storage=64):p.isTexture?be("WebGLRenderer: Texture samplers can not be part of an uniforms group."):ArrayBuffer.isView(p)?(u.boundary=16,u.storage=p.byteLength):be("WebGLRenderer: Unsupported uniform value type.",p),u}function d(p){let u=p.target;u.removeEventListener("dispose",d);let g=a.indexOf(u.__bindingPointIndex);a.splice(g,1),r.deleteBuffer(n[u.id]),delete n[u.id],delete s[u.id]}return{bind:function(p,u){let g=u.program;i.uniformBlockBinding(p,g)},update:function(p,u){let g=n[p.id];g===void 0&&((function(f){let _=f.uniforms,x=0,S=16;for(let M=0,P=_.length;M<P;M++){let O=Array.isArray(_[M])?_[M]:[_[M]];for(let L=0,I=O.length;L<I;L++){let B=O[L],U=Array.isArray(B.value)?B.value:[B.value];for(let X=0,k=U.length;X<k;X++){let V=h(U[X]),Y=x%S,W=Y%V.boundary,ne=Y+W;x+=W,ne!==0&&S-ne<V.storage&&(x+=S-ne),B.__data=new Float32Array(V.storage/Float32Array.BYTES_PER_ELEMENT),B.__offset=x,x+=V.storage}}}let T=x%S;T>0&&(x+=S-T),f.__size=x,f.__cache={}})(p),g=(function(f){let _=(function(){for(let M=0;M<o;M++)if(a.indexOf(M)===-1)return a.push(M),M;return we("WebGLRenderer: Maximum number of simultaneously usable uniforms groups reached."),0})();f.__bindingPointIndex=_;let x=r.createBuffer(),S=f.__size,T=f.usage;return r.bindBuffer(r.UNIFORM_BUFFER,x),r.bufferData(r.UNIFORM_BUFFER,S,T),r.bindBuffer(r.UNIFORM_BUFFER,null),r.bindBufferBase(r.UNIFORM_BUFFER,_,x),x})(p),n[p.id]=g,p.addEventListener("dispose",d));let m=u.program;i.updateUBOMapping(p,m);let v=e.render.frame;s[p.id]!==v&&((function(f){let _=n[f.id],x=f.uniforms,S=f.__cache;r.bindBuffer(r.UNIFORM_BUFFER,_);for(let T=0,M=x.length;T<M;T++){let P=x[T];if(Array.isArray(P))for(let O=0,L=P.length;O<L;O++)c(P[O],T,O,S);else c(P,T,0,S)}r.bindBuffer(r.UNIFORM_BUFFER,null)})(p),s[p.id]=v)},dispose:function(){for(let p in n)r.deleteBuffer(n[p]);a=[],n={},s={}}}}ep.set(-1,0,0,0,1,0,0,0,1);var qf=new Uint16Array([12469,15057,12620,14925,13266,14620,13807,14376,14323,13990,14545,13625,14713,13328,14840,12882,14931,12528,14996,12233,15039,11829,15066,11525,15080,11295,15085,10976,15082,10705,15073,10495,13880,14564,13898,14542,13977,14430,14158,14124,14393,13732,14556,13410,14702,12996,14814,12596,14891,12291,14937,11834,14957,11489,14958,11194,14943,10803,14921,10506,14893,10278,14858,9960,14484,14039,14487,14025,14499,13941,14524,13740,14574,13468,14654,13106,14743,12678,14818,12344,14867,11893,14889,11509,14893,11180,14881,10751,14852,10428,14812,10128,14765,9754,14712,9466,14764,13480,14764,13475,14766,13440,14766,13347,14769,13070,14786,12713,14816,12387,14844,11957,14860,11549,14868,11215,14855,10751,14825,10403,14782,10044,14729,9651,14666,9352,14599,9029,14967,12835,14966,12831,14963,12804,14954,12723,14936,12564,14917,12347,14900,11958,14886,11569,14878,11247,14859,10765,14828,10401,14784,10011,14727,9600,14660,9289,14586,8893,14508,8533,15111,12234,15110,12234,15104,12216,15092,12156,15067,12010,15028,11776,14981,11500,14942,11205,14902,10752,14861,10393,14812,9991,14752,9570,14682,9252,14603,8808,14519,8445,14431,8145,15209,11449,15208,11451,15202,11451,15190,11438,15163,11384,15117,11274,15055,10979,14994,10648,14932,10343,14871,9936,14803,9532,14729,9218,14645,8742,14556,8381,14461,8020,14365,7603,15273,10603,15272,10607,15267,10619,15256,10631,15231,10614,15182,10535,15118,10389,15042,10167,14963,9787,14883,9447,14800,9115,14710,8665,14615,8318,14514,7911,14411,7507,14279,7198,15314,9675,15313,9683,15309,9712,15298,9759,15277,9797,15229,9773,15166,9668,15084,9487,14995,9274,14898,8910,14800,8539,14697,8234,14590,7790,14479,7409,14367,7067,14178,6621,15337,8619,15337,8631,15333,8677,15325,8769,15305,8871,15264,8940,15202,8909,15119,8775,15022,8565,14916,8328,14804,8009,14688,7614,14569,7287,14448,6888,14321,6483,14088,6171,15350,7402,15350,7419,15347,7480,15340,7613,15322,7804,15287,7973,15229,8057,15148,8012,15046,7846,14933,7611,14810,7357,14682,7069,14552,6656,14421,6316,14251,5948,14007,5528,15356,5942,15356,5977,15353,6119,15348,6294,15332,6551,15302,6824,15249,7044,15171,7122,15070,7050,14949,6861,14818,6611,14679,6349,14538,6067,14398,5651,14189,5311,13935,4958,15359,4123,15359,4153,15356,4296,15353,4646,15338,5160,15311,5508,15263,5829,15188,6042,15088,6094,14966,6001,14826,5796,14678,5543,14527,5287,14377,4985,14133,4586,13869,4257,15360,1563,15360,1642,15358,2076,15354,2636,15341,3350,15317,4019,15273,4429,15203,4732,15105,4911,14981,4932,14836,4818,14679,4621,14517,4386,14359,4156,14083,3795,13808,3437,15360,122,15360,137,15358,285,15355,636,15344,1274,15322,2177,15281,2765,15215,3223,15120,3451,14995,3569,14846,3567,14681,3466,14511,3305,14344,3121,14037,2800,13753,2467,15360,0,15360,1,15359,21,15355,89,15346,253,15325,479,15287,796,15225,1148,15133,1492,15008,1749,14856,1882,14685,1886,14506,1783,14324,1608,13996,1398,13702,1183]),Ni=null,Go=class{constructor(e={}){let{canvas:t=fd(),context:i=null,depth:n=!0,stencil:s=!1,alpha:a=!1,antialias:o=!1,premultipliedAlpha:c=!0,preserveDrawingBuffer:l=!1,powerPreference:h="default",failIfMajorPerformanceCaveat:d=!1,reversedDepthBuffer:p=!1,outputBufferType:u=Zt}=e,g;if(this.isWebGLRenderer=!0,i!==null){if(typeof WebGLRenderingContext<"u"&&i instanceof WebGLRenderingContext)throw new Error("THREE.WebGLRenderer: WebGL 1 is not supported since r163.");g=i.getContextAttributes().alpha}else g=a;let m=u,v=new Set([vc,_c,wo]),f=new Set([Zt,$i,Or,Br,To,Eo]),_=new Uint32Array(4),x=new Int32Array(4),S=new w,T=null,M=null,P=[],O=[],L=null;this.domElement=t,this.debug={checkShaderErrors:!0,onShaderError:null},this.autoClear=!0,this.autoClearColor=!0,this.autoClearDepth=!0,this.autoClearStencil=!0,this.sortObjects=!0,this.clippingPlanes=[],this.localClippingEnabled=!1,this.toneMapping=gi,this.toneMappingExposure=1,this.transmissionResolutionScale=1;let I=this,B=!1,U=null,X=null,k=null,V=null;this._outputColorSpace=bt;let Y=0,W=0,ne=null,pe=-1,Ee=null,_e=new $e,ve=new $e,ie=null,he=new Ie(0),le=0,fe=t.width,Ue=t.height,$=1,R=null,b=null,C=new $e(0,0,fe,Ue),F=new $e(0,0,fe,Ue),y=!1,D=new ji,N=!1,A=!1,H=new Fe,j=new w,Z=new $e,se={background:null,fog:null,environment:null,overrideMaterial:null,isScene:!0},xe=!1;function ye(){return ne===null?$:1}let ue,Ce,ee,ae,re,me,et,Ye,ct,Ot,Se,Je,ze,At,tt,vt,ot,$t,ri,Sn,yi,tn,ks,z=i;function Ih(E,G){return t.getContext(E,G)}try{let E={alpha:!0,depth:n,stencil:s,antialias:o,premultipliedAlpha:c,preserveDrawingBuffer:l,powerPreference:h,failIfMajorPerformanceCaveat:d};if("setAttribute"in t&&t.setAttribute("data-engine",`three.js r${"185"}`),t.addEventListener("webglcontextlost",Nh,!1),t.addEventListener("webglcontextrestored",Dh,!1),t.addEventListener("webglcontextcreationerror",Uh,!1),z===null){let G="webgl2";if(z=Ih(G,E),z===null)throw Ih(G)?new Error("THREE.WebGLRenderer: Error creating WebGL context with your selected attributes."):new Error("THREE.WebGLRenderer: Error creating WebGL context.")}}catch(E){throw we("WebGLRenderer: "+E.message),E}function Lh(){ue=new xm(z),ue.init(),yi=new kf(z,ue),Ce=new fm(z,ue,e,yi),ee=new Vf(z,ue),Ce.reversedDepthBuffer&&p&&ee.buffers.depth.setReversed(!0),X=z.createFramebuffer(),k=z.createFramebuffer(),V=z.createFramebuffer(),ae=new Sm(z),re=new Pf,me=new Hf(z,ue,ee,re,Ce,yi,ae),et=new vm(I),Ye=new hm(z),tn=new pm(z,Ye),ct=new ym(z,Ye,ae,tn),Ot=new Tm(z,ct,Ye,tn,ae),$t=new bm(z,Ce,me),tt=new gm(re),Se=new Rf(I,et,ue,Ce,tn,tt),Je=new Xf(I,re),ze=new Lf,At=new Of(ue),ot=new dm(I,et,ee,Ot,g,c),vt=new Gf(I,Ot,Ce),ks=new jf(z,ae,Ce,ee),ri=new mm(z,ue,ae),Sn=new Mm(z,ue,ae),ae.programs=Se.programs,I.capabilities=Ce,I.extensions=ue,I.properties=re,I.renderLists=ze,I.shadowMap=vt,I.state=ee,I.info=ae}Lh(),m!==Zt&&(L=new wm(m,t.width,t.height,o,n,s));let ht=new gh(I,z);function Nh(E){E.preventDefault(),ls("WebGLRenderer: Context Lost."),B=!0}function Dh(){ls("WebGLRenderer: Context Restored."),B=!1;let E=ae.autoReset,G=vt.enabled,q=vt.autoUpdate,K=vt.needsUpdate,J=vt.type;Lh(),ae.autoReset=E,vt.enabled=G,vt.autoUpdate=q,vt.needsUpdate=K,vt.type=J}function Uh(E){we("WebGLRenderer: A WebGL context could not be created. Reason: ",E.statusMessage)}function Fh(E){let G=E.target;G.removeEventListener("dispose",Fh),(function(q){(function(K){let J=re.get(K).programs;J!==void 0&&(J.forEach(function(oe){Se.releaseProgram(oe)}),K.isShaderMaterial&&Se.releaseShaderCache(K))})(q),re.remove(q)})(G)}function Oh(E,G,q){E.transparent===!0&&E.side===Vt&&E.forceSinglePass===!1?(E.side=Gt,E.needsUpdate=!0,Xs(E,G,q),E.side=Dr,E.needsUpdate=!0,Xs(E,G,q),E.side=Vt):Xs(E,G,q)}this.xr=ht,this.getContext=function(){return z},this.getContextAttributes=function(){return z.getContextAttributes()},this.forceContextLoss=function(){let E=ue.get("WEBGL_lose_context");E&&E.loseContext()},this.forceContextRestore=function(){let E=ue.get("WEBGL_lose_context");E&&E.restoreContext()},this.getPixelRatio=function(){return $},this.setPixelRatio=function(E){E!==void 0&&($=E,this.setSize(fe,Ue,!1))},this.getSize=function(E){return E.set(fe,Ue)},this.setSize=function(E,G,q=!0){ht.isPresenting?be("WebGLRenderer: Can't change size while VR device is presenting."):(fe=E,Ue=G,t.width=Math.floor(E*$),t.height=Math.floor(G*$),q===!0&&(t.style.width=E+"px",t.style.height=G+"px"),L!==null&&L.setSize(t.width,t.height),this.setViewport(0,0,E,G))},this.getDrawingBufferSize=function(E){return E.set(fe*$,Ue*$).floor()},this.setDrawingBufferSize=function(E,G,q){fe=E,Ue=G,$=q,t.width=Math.floor(E*q),t.height=Math.floor(G*q),this.setViewport(0,0,E,G)},this.setEffects=function(E){if(m!==Zt){if(E){for(let G=0;G<E.length;G++)if(E[G].isOutputPass===!0){be("WebGLRenderer: OutputPass is not needed in setEffects(). Tone mapping and color space conversion are applied automatically.");break}}L.setEffects(E||[])}else we("WebGLRenderer: setEffects() requires outputBufferType set to HalfFloatType or FloatType.")},this.getCurrentViewport=function(E){return E.copy(_e)},this.getViewport=function(E){return E.copy(C)},this.setViewport=function(E,G,q,K){E.isVector4?C.set(E.x,E.y,E.z,E.w):C.set(E,G,q,K),ee.viewport(_e.copy(C).multiplyScalar($).round())},this.getScissor=function(E){return E.copy(F)},this.setScissor=function(E,G,q,K){E.isVector4?F.set(E.x,E.y,E.z,E.w):F.set(E,G,q,K),ee.scissor(ve.copy(F).multiplyScalar($).round())},this.getScissorTest=function(){return y},this.setScissorTest=function(E){ee.setScissorTest(y=E)},this.setOpaqueSort=function(E){R=E},this.setTransparentSort=function(E){b=E},this.getClearColor=function(E){return E.copy(ot.getClearColor())},this.setClearColor=function(){ot.setClearColor(...arguments)},this.getClearAlpha=function(){return ot.getClearAlpha()},this.setClearAlpha=function(){ot.setClearAlpha(...arguments)},this.clear=function(E=!0,G=!0,q=!0){let K=0;if(E){let J=!1;if(ne!==null){let oe=ne.texture.format;J=v.has(oe)}if(J){let oe=ne.texture.type,de=f.has(oe),ge=ot.getClearColor(),Me=ot.getClearAlpha(),Re=ge.r,ke=ge.g,We=ge.b;de?(_[0]=Re,_[1]=ke,_[2]=We,_[3]=Me,z.clearBufferuiv(z.COLOR,0,_)):(x[0]=Re,x[1]=ke,x[2]=We,x[3]=Me,z.clearBufferiv(z.COLOR,0,x))}else K|=z.COLOR_BUFFER_BIT}G&&(K|=z.DEPTH_BUFFER_BIT,this.state.buffers.depth.setMask(!0)),q&&(K|=z.STENCIL_BUFFER_BIT,this.state.buffers.stencil.setMask(4294967295)),K!==0&&z.clear(K)},this.clearColor=function(){this.clear(!0,!1,!1)},this.clearDepth=function(){this.clear(!1,!0,!1)},this.clearStencil=function(){this.clear(!1,!1,!0)},this.setNodesHandler=function(E){E.setRenderer(this),U=E},this.dispose=function(){t.removeEventListener("webglcontextlost",Nh,!1),t.removeEventListener("webglcontextrestored",Dh,!1),t.removeEventListener("webglcontextcreationerror",Uh,!1),ot.dispose(),ze.dispose(),At.dispose(),re.dispose(),et.dispose(),Ot.dispose(),tn.dispose(),ks.dispose(),Se.dispose(),ht.dispose(),ht.removeEventListener("sessionstart",Bh),ht.removeEventListener("sessionend",zh),bn.stop()},this.renderBufferDirect=function(E,G,q,K,J,oe){G===null&&(G=se);let de=J.isMesh&&J.matrixWorld.determinantAffine()<0,ge=(function(Ve,rt,Ct,Pe,De){rt.isScene!==!0&&(rt=se),me.resetTextureUnits();let si=rt.fog,tl=Pe.isMeshStandardMaterial||Pe.isMeshLambertMaterial||Pe.isMeshPhongMaterial?rt.environment:null,js=ne===null?I.outputColorSpace:ne.isXRRenderTarget===!0?ne.texture.colorSpace:He.workingColorSpace,jr=Pe.isMeshStandardMaterial||Pe.isMeshLambertMaterial&&!Pe.envMap||Pe.isMeshPhongMaterial&&!Pe.envMap,Mi=et.get(Pe.envMap||tl,jr),Xn=Pe.vertexColors===!0&&!!Ct.attributes.color&&Ct.attributes.color.itemSize===4,Oi=!!Ct.attributes.tangent&&(!!Pe.normalMap||Pe.anisotropy>0),il=!!Ct.morphAttributes.position,jn=!!Ct.morphAttributes.normal,wp=!!Ct.morphAttributes.color,Xh=gi;Pe.toneMapped&&(ne!==null&&ne.isXRRenderTarget!==!0||(Xh=I.toneMapping));let jh=Ct.morphAttributes.position||Ct.morphAttributes.normal||Ct.morphAttributes.color,Ap=jh!==void 0?jh.length:0,Le=re.get(Pe),Tn=M.state.lights;if(N===!0&&(A===!0||Ve!==Ee)){let dt=Ve===Ee&&Pe.id===pe;tt.setState(Pe,Ve,dt)}let ai=!1;Pe.version===Le.__version?Le.needsLights&&Le.lightsStateVersion!==Tn.state.version||Le.outputColorSpace!==js||De.isBatchedMesh&&Le.batching===!1?ai=!0:De.isBatchedMesh||Le.batching!==!0?De.isBatchedMesh&&Le.batchingColor===!0&&De.colorTexture===null||De.isBatchedMesh&&Le.batchingColor===!1&&De.colorTexture!==null||De.isInstancedMesh&&Le.instancing===!1?ai=!0:De.isInstancedMesh||Le.instancing!==!0?De.isSkinnedMesh&&Le.skinning===!1?ai=!0:De.isSkinnedMesh||Le.skinning!==!0?De.isInstancedMesh&&Le.instancingColor===!0&&De.instanceColor===null||De.isInstancedMesh&&Le.instancingColor===!1&&De.instanceColor!==null||De.isInstancedMesh&&Le.instancingMorph===!0&&De.morphTexture===null||De.isInstancedMesh&&Le.instancingMorph===!1&&De.morphTexture!==null||Le.envMap!==Mi||Pe.fog===!0&&Le.fog!==si?ai=!0:Le.numClippingPlanes===void 0||Le.numClippingPlanes===tt.numPlanes&&Le.numIntersection===tt.numIntersection?(Le.vertexAlphas!==Xn||Le.vertexTangents!==Oi||Le.morphTargets!==il||Le.morphNormals!==jn||Le.morphColors!==wp||Le.toneMapping!==Xh||Le.morphTargetsCount!==Ap||!!Le.lightProbeGrid!=M.state.lightProbeGridArray.length>0)&&(ai=!0):ai=!0:ai=!0:ai=!0:ai=!0:(ai=!0,Le.__version=Pe.version);let nn=Le.currentProgram;ai===!0&&(nn=Xs(Pe,rt,De),U&&Pe.isNodeMaterial&&U.onUpdateProgram(Pe,nn,Le));let qh=!1,qn=!1,nl=!1,st=nn.getUniforms(),Qt=Le.uniforms;if(ee.useProgram(nn.program)&&(qh=!0,qn=!0,nl=!0),Pe.id!==pe&&(pe=Pe.id,qn=!0),Le.needsLights){let dt=(function(bi,sl){if(bi.length===0)return null;if(bi.length===1)return bi[0].texture!==null?bi[0]:null;S.setFromMatrixPosition(sl.matrixWorld);for(let Yn=0,Cp=bi.length;Yn<Cp;Yn++){let al=bi[Yn];if(al.texture!==null&&al.boundingBox.containsPoint(S))return al}return null})(M.state.lightProbeGridArray,De);Le.lightProbeGrid!==dt&&(Le.lightProbeGrid=dt,qn=!0)}if(qh||Ee!==Ve){ee.buffers.depth.getReversed()&&Ve.reversedDepth!==!0&&(Ve._reversedDepth=!0,Ve.updateProjectionMatrix()),st.setValue(z,"projectionMatrix",Ve.projectionMatrix),st.setValue(z,"viewMatrix",Ve.matrixWorldInverse);let dt=st.map.cameraPosition;dt!==void 0&&dt.setValue(z,j.setFromMatrixPosition(Ve.matrixWorld)),Ce.logarithmicDepthBuffer&&st.setValue(z,"logDepthBufFC",2/(Math.log(Ve.far+1)/Math.LN2)),(Pe.isMeshPhongMaterial||Pe.isMeshToonMaterial||Pe.isMeshLambertMaterial||Pe.isMeshBasicMaterial||Pe.isMeshStandardMaterial||Pe.isShaderMaterial)&&st.setValue(z,"isOrthographic",Ve.isOrthographicCamera===!0),Ee!==Ve&&(Ee=Ve,qn=!0,nl=!0)}if(Le.needsLights&&(Tn.state.directionalShadowMap.length>0&&st.setValue(z,"directionalShadowMap",Tn.state.directionalShadowMap,me),Tn.state.spotShadowMap.length>0&&st.setValue(z,"spotShadowMap",Tn.state.spotShadowMap,me),Tn.state.pointShadowMap.length>0&&st.setValue(z,"pointShadowMap",Tn.state.pointShadowMap,me)),De.isSkinnedMesh){st.setOptional(z,De,"bindMatrix"),st.setOptional(z,De,"bindMatrixInverse");let dt=De.skeleton;dt&&(dt.boneTexture===null&&dt.computeBoneTexture(),st.setValue(z,"boneTexture",dt.boneTexture,me))}De.isBatchedMesh&&(st.setOptional(z,De,"batchingTexture"),st.setValue(z,"batchingTexture",De._matricesTexture,me),st.setOptional(z,De,"batchingIdTexture"),st.setValue(z,"batchingIdTexture",De._indirectTexture,me),st.setOptional(z,De,"batchingColorTexture"),De._colorsTexture!==null&&st.setValue(z,"batchingColorTexture",De._colorsTexture,me));let rl=Ct.morphAttributes;if(rl.position===void 0&&rl.normal===void 0&&rl.color===void 0||$t.update(De,Ct,nn),(qn||Le.receiveShadow!==De.receiveShadow)&&(Le.receiveShadow=De.receiveShadow,st.setValue(z,"receiveShadow",De.receiveShadow)),(Pe.isMeshStandardMaterial||Pe.isMeshLambertMaterial||Pe.isMeshPhongMaterial)&&Pe.envMap===null&&rt.environment!==null&&(Qt.envMapIntensity.value=rt.environmentIntensity),Qt.dfgLUT!==void 0&&(Qt.dfgLUT.value=(Ni===null&&(Ni=new Ua(qf,16,16,Bn,Li),Ni.name="DFG_LUT",Ni.minFilter=Dt,Ni.magFilter=Dt,Ni.wrapS=dn,Ni.wrapT=dn,Ni.generateMipmaps=!1,Ni.needsUpdate=!0),Ni)),qn){if(st.setValue(z,"toneMappingExposure",I.toneMappingExposure),Le.needsLights&&(oi=nl,(Si=Qt).ambientLightColor.needsUpdate=oi,Si.lightProbe.needsUpdate=oi,Si.directionalLights.needsUpdate=oi,Si.directionalLightShadows.needsUpdate=oi,Si.pointLights.needsUpdate=oi,Si.pointLightShadows.needsUpdate=oi,Si.spotLights.needsUpdate=oi,Si.spotLightShadows.needsUpdate=oi,Si.rectAreaLights.needsUpdate=oi,Si.hemisphereLights.needsUpdate=oi),si&&Pe.fog===!0&&Je.refreshFogUniforms(Qt,si),Je.refreshMaterialUniforms(Qt,Pe,$,Ue,M.state.transmissionRenderTarget[Ve.id]),Le.needsLights&&Le.lightProbeGrid){let dt=Le.lightProbeGrid;Qt.probesSH.value=dt.texture,Qt.probesMin.value.copy(dt.boundingBox.min),Qt.probesMax.value.copy(dt.boundingBox.max),Qt.probesResolution.value.copy(dt.resolution)}Gr.upload(z,kh(Le),Qt,me)}var Si,oi;if(Pe.isShaderMaterial&&Pe.uniformsNeedUpdate===!0&&(Gr.upload(z,kh(Le),Qt,me),Pe.uniformsNeedUpdate=!1),Pe.isSpriteMaterial&&st.setValue(z,"center",De.center),st.setValue(z,"modelViewMatrix",De.modelViewMatrix),st.setValue(z,"normalMatrix",De.normalMatrix),st.setValue(z,"modelMatrix",De.matrixWorld),Pe.uniformsGroups!==void 0){let dt=Pe.uniformsGroups;for(let bi=0,sl=dt.length;bi<sl;bi++){let Yn=dt[bi];ks.update(Yn,nn),ks.bind(Yn,nn)}}return nn})(E,G,q,K,J);ee.setMaterial(K,de);let Me=q.index,Re=1;if(K.wireframe===!0){if(Me=ct.getWireframeAttribute(q),Me===void 0)return;Re=2}let ke=q.drawRange,We=q.attributes.position,Ae=ke.start*Re,je=(ke.start+ke.count)*Re;oe!==null&&(Ae=Math.max(Ae,oe.start*Re),je=Math.min(je,(oe.start+oe.count)*Re)),Me!==null?(Ae=Math.max(Ae,0),je=Math.min(je,Me.count)):We!=null&&(Ae=Math.max(Ae,0),je=Math.min(je,We.count));let xt=je-Ae;if(xt<0||xt===1/0)return;let ut;tn.setup(J,K,ge,q,Me);let nt=ri;if(Me!==null&&(ut=Ye.get(Me),nt=Sn,nt.setIndex(ut)),J.isMesh)K.wireframe===!0?(ee.setLineWidth(K.wireframeLinewidth*ye()),nt.setMode(z.LINES)):nt.setMode(z.TRIANGLES);else if(J.isLine){let Ve=K.linewidth;Ve===void 0&&(Ve=1),ee.setLineWidth(Ve*ye()),J.isLineSegments?nt.setMode(z.LINES):J.isLineLoop?nt.setMode(z.LINE_LOOP):nt.setMode(z.LINE_STRIP)}else J.isPoints?nt.setMode(z.POINTS):J.isSprite&&nt.setMode(z.TRIANGLES);if(J.isBatchedMesh)if(ue.get("WEBGL_multi_draw"))nt.renderMultiDraw(J._multiDrawStarts,J._multiDrawCounts,J._multiDrawCount);else{let Ve=J._multiDrawStarts,rt=J._multiDrawCounts,Ct=J._multiDrawCount,Pe=Me?Ye.get(Me).bytesPerElement:1,De=re.get(K).currentProgram.getUniforms();for(let si=0;si<Ct;si++)De.setValue(z,"_gl_DrawID",si),nt.render(Ve[si]/Pe,rt[si])}else if(J.isInstancedMesh)nt.renderInstances(Ae,xt,J.count);else if(q.isInstancedBufferGeometry){let Ve=q._maxInstanceCount!==void 0?q._maxInstanceCount:1/0,rt=Math.min(q.instanceCount,Ve);nt.renderInstances(Ae,xt,rt)}else nt.render(Ae,xt)},this.compile=function(E,G,q=null){q===null&&(q=E),M=At.get(q),M.init(G),O.push(M),q.traverseVisible(function(J){J.isLight&&J.layers.test(G.layers)&&(M.pushLight(J),J.castShadow&&M.pushShadow(J))}),E!==q&&E.traverseVisible(function(J){J.isLight&&J.layers.test(G.layers)&&(M.pushLight(J),J.castShadow&&M.pushShadow(J))}),M.setupLights();let K=new Set;return E.traverse(function(J){if(!(J.isMesh||J.isPoints||J.isLine||J.isSprite))return;let oe=J.material;if(oe)if(Array.isArray(oe))for(let de=0;de<oe.length;de++){let ge=oe[de];Oh(ge,q,J),K.add(ge)}else Oh(oe,q,J),K.add(oe)}),M=O.pop(),K},this.compileAsync=function(E,G,q=null){let K=this.compile(E,G,q);return new Promise(J=>{function oe(){K.forEach(function(de){re.get(de).currentProgram.isReady()&&K.delete(de)}),K.size!==0?setTimeout(oe,10):J(E)}ue.get("KHR_parallel_shader_compile")!==null?oe():setTimeout(oe,10)})};let Qo=null;function Bh(){bn.stop()}function zh(){bn.start()}let bn=new Yd;function el(E,G,q,K){if(E.visible===!1)return;if(E.layers.test(G.layers)){if(E.isGroup)q=E.renderOrder;else if(E.isLOD)E.autoUpdate===!0&&E.update(G);else if(E.isLightProbeGrid)M.pushLightProbeGrid(E);else if(E.isLight)M.pushLight(E),E.castShadow&&M.pushShadow(E);else if(E.isSprite){if(!E.frustumCulled||D.intersectsSprite(E)){K&&Z.setFromMatrixPosition(E.matrixWorld).applyMatrix4(H);let oe=Ot.update(E),de=E.material;de.visible&&T.push(E,oe,de,q,Z.z,null)}}else if((E.isMesh||E.isLine||E.isPoints)&&(!E.frustumCulled||D.intersectsObject(E))){let oe=Ot.update(E),de=E.material;if(K&&(E.boundingSphere!==void 0?(E.boundingSphere===null&&E.computeBoundingSphere(),Z.copy(E.boundingSphere.center)):(oe.boundingSphere===null&&oe.computeBoundingSphere(),Z.copy(oe.boundingSphere.center)),Z.applyMatrix4(E.matrixWorld).applyMatrix4(H)),Array.isArray(de)){let ge=oe.groups;for(let Me=0,Re=ge.length;Me<Re;Me++){let ke=ge[Me],We=de[ke.materialIndex];We&&We.visible&&T.push(E,oe,We,q,Z.z,ke)}}else de.visible&&T.push(E,oe,de,q,Z.z,null)}}let J=E.children;for(let oe=0,de=J.length;oe<de;oe++)el(J[oe],G,q,K)}function Gh(E,G,q,K){let{opaque:J,transmissive:oe,transparent:de}=E;M.setupLightsView(q),N===!0&&tt.setGlobalState(I.clippingPlanes,q),K&&ee.viewport(_e.copy(K)),J.length>0&&Ws(J,G,q),oe.length>0&&Ws(oe,G,q),de.length>0&&Ws(de,G,q),ee.buffers.depth.setTest(!0),ee.buffers.depth.setMask(!0),ee.buffers.color.setMask(!0),ee.setPolygonOffset(!1)}function Vh(E,G,q,K){if((q.isScene===!0?q.overrideMaterial:null)!==null)return;if(M.state.transmissionRenderTarget[K.id]===void 0){let We=ue.has("EXT_color_buffer_half_float")||ue.has("EXT_color_buffer_float");M.state.transmissionRenderTarget[K.id]=new jt(1,1,{generateMipmaps:!0,type:We?Li:Zt,minFilter:Fn,samples:Math.max(4,Ce.samples),stencilBuffer:s,resolveDepthBuffer:!1,resolveStencilBuffer:!1,colorSpace:He.workingColorSpace})}let J=M.state.transmissionRenderTarget[K.id],oe=K.viewport||_e;J.setSize(oe.z*I.transmissionResolutionScale,oe.w*I.transmissionResolutionScale);let de=I.getRenderTarget(),ge=I.getActiveCubeFace(),Me=I.getActiveMipmapLevel();I.setRenderTarget(J),I.getClearColor(he),le=I.getClearAlpha(),le<1&&I.setClearColor(16777215,.5),I.clear(),xe&&ot.render(q);let Re=I.toneMapping;I.toneMapping=gi;let ke=K.viewport;if(K.viewport!==void 0&&(K.viewport=void 0),M.setupLightsView(K),N===!0&&tt.setGlobalState(I.clippingPlanes,K),Ws(E,q,K),me.updateMultisampleRenderTarget(J),me.updateRenderTargetMipmap(J),ue.has("WEBGL_multisampled_render_to_texture")===!1){let We=!1;for(let Ae=0,je=G.length;Ae<je;Ae++){let xt=G[Ae],{object:ut,geometry:nt,material:Ve,group:rt}=xt;if(Ve.side===Vt&&ut.layers.test(K.layers)){let Ct=Ve.side;Ve.side=Gt,Ve.needsUpdate=!0,Hh(ut,q,K,nt,Ve,rt),Ve.side=Ct,Ve.needsUpdate=!0,We=!0}}We===!0&&(me.updateMultisampleRenderTarget(J),me.updateRenderTargetMipmap(J))}I.setRenderTarget(de,ge,Me),I.setClearColor(he,le),ke!==void 0&&(K.viewport=ke),I.toneMapping=Re}function Ws(E,G,q){let K=G.isScene===!0?G.overrideMaterial:null;for(let J=0,oe=E.length;J<oe;J++){let de=E[J],{object:ge,geometry:Me,group:Re}=de,ke=de.material;ke.allowOverride===!0&&K!==null&&(ke=K),ge.layers.test(q.layers)&&Hh(ge,G,q,Me,ke,Re)}}function Hh(E,G,q,K,J,oe){E.onBeforeRender(I,G,q,K,J,oe),E.modelViewMatrix.multiplyMatrices(q.matrixWorldInverse,E.matrixWorld),E.normalMatrix.getNormalMatrix(E.modelViewMatrix),J.onBeforeRender(I,G,q,K,E,oe),J.transparent===!0&&J.side===Vt&&J.forceSinglePass===!1?(J.side=Gt,J.needsUpdate=!0,I.renderBufferDirect(q,G,K,J,E,oe),J.side=Dr,J.needsUpdate=!0,I.renderBufferDirect(q,G,K,J,E,oe),J.side=Vt):I.renderBufferDirect(q,G,K,J,E,oe),E.onAfterRender(I,G,q,K,J,oe)}function Xs(E,G,q){G.isScene!==!0&&(G=se);let K=re.get(E),J=M.state.lights,oe=M.state.shadowsArray,de=J.state.version,ge=Se.getParameters(E,J.state,oe,G,q,M.state.lightProbeGridArray),Me=Se.getProgramCacheKey(ge),Re=K.programs;K.environment=E.isMeshStandardMaterial||E.isMeshLambertMaterial||E.isMeshPhongMaterial?G.environment:null,K.fog=G.fog;let ke=E.isMeshStandardMaterial||E.isMeshLambertMaterial&&!E.envMap||E.isMeshPhongMaterial&&!E.envMap;K.envMap=et.get(E.envMap||K.environment,ke),K.envMapRotation=K.environment!==null&&E.envMap===null?G.environmentRotation:E.envMapRotation,Re===void 0&&(E.addEventListener("dispose",Fh),Re=new Map,K.programs=Re);let We=Re.get(Me);if(We!==void 0){if(K.currentProgram===We&&K.lightsStateVersion===de)return Wh(E,ge),We}else ge.uniforms=Se.getUniforms(E),U!==null&&E.isNodeMaterial&&U.build(E,q,ge),E.onBeforeCompile(ge,I),We=Se.acquireProgram(ge,Me),Re.set(Me,We),K.uniforms=ge.uniforms;let Ae=K.uniforms;return(E.isShaderMaterial||E.isRawShaderMaterial)&&E.clipping!==!0||(Ae.clippingPlanes=tt.uniform),Wh(E,ge),K.needsLights=(function(je){return je.isMeshLambertMaterial||je.isMeshToonMaterial||je.isMeshPhongMaterial||je.isMeshStandardMaterial||je.isShadowMaterial||je.isShaderMaterial&&je.lights===!0})(E),K.lightsStateVersion=de,K.needsLights&&(Ae.ambientLightColor.value=J.state.ambient,Ae.lightProbe.value=J.state.probe,Ae.directionalLights.value=J.state.directional,Ae.directionalLightShadows.value=J.state.directionalShadow,Ae.spotLights.value=J.state.spot,Ae.spotLightShadows.value=J.state.spotShadow,Ae.rectAreaLights.value=J.state.rectArea,Ae.ltc_1.value=J.state.rectAreaLTC1,Ae.ltc_2.value=J.state.rectAreaLTC2,Ae.pointLights.value=J.state.point,Ae.pointLightShadows.value=J.state.pointShadow,Ae.hemisphereLights.value=J.state.hemi,Ae.directionalShadowMatrix.value=J.state.directionalShadowMatrix,Ae.spotLightMatrix.value=J.state.spotLightMatrix,Ae.spotLightMap.value=J.state.spotLightMap,Ae.pointShadowMatrix.value=J.state.pointShadowMatrix),K.lightProbeGrid=M.state.lightProbeGridArray.length>0,K.currentProgram=We,K.uniformsList=null,We}function kh(E){if(E.uniformsList===null){let G=E.currentProgram.getUniforms();E.uniformsList=Gr.seqWithValue(G.seq,E.uniforms)}return E.uniformsList}function Wh(E,G){let q=re.get(E);q.outputColorSpace=G.outputColorSpace,q.batching=G.batching,q.batchingColor=G.batchingColor,q.instancing=G.instancing,q.instancingColor=G.instancingColor,q.instancingMorph=G.instancingMorph,q.skinning=G.skinning,q.morphTargets=G.morphTargets,q.morphNormals=G.morphNormals,q.morphColors=G.morphColors,q.morphTargetsCount=G.morphTargetsCount,q.numClippingPlanes=G.numClippingPlanes,q.numIntersection=G.numClipIntersection,q.vertexAlphas=G.vertexAlphas,q.vertexTangents=G.vertexTangents,q.toneMapping=G.toneMapping}bn.setAnimationLoop(function(E){Qo&&Qo(E)}),typeof self<"u"&&bn.setContext(self),this.setAnimationLoop=function(E){Qo=E,ht.setAnimationLoop(E),E===null?bn.stop():bn.start()},ht.addEventListener("sessionstart",Bh),ht.addEventListener("sessionend",zh),this.render=function(E,G){if(G!==void 0&&G.isCamera!==!0)return void we("WebGLRenderer.render: camera is not an instance of THREE.Camera.");if(B===!0)return;U!==null&&U.renderStart(E,G);let q=ht.enabled===!0&&ht.isPresenting===!0,K=L!==null&&(ne===null||q)&&L.begin(I,ne);if(E.matrixWorldAutoUpdate===!0&&E.updateMatrixWorld(),G.parent===null&&G.matrixWorldAutoUpdate===!0&&G.updateMatrixWorld(),ht.enabled!==!0||ht.isPresenting!==!0||L!==null&&L.isCompositing()!==!1||(ht.cameraAutoUpdate===!0&&ht.updateCamera(G),G=ht.getCamera()),E.isScene===!0&&E.onBeforeRender(I,E,G,ne),M=At.get(E,O.length),M.init(G),M.state.textureUnits=me.getTextureUnits(),O.push(M),H.multiplyMatrices(G.projectionMatrix,G.matrixWorldInverse),D.setFromProjectionMatrix(H,Wi,G.reversedDepth),A=this.localClippingEnabled,N=tt.init(this.clippingPlanes,A),T=ze.get(E,P.length),T.init(),P.push(T),ht.enabled===!0&&ht.isPresenting===!0){let oe=I.xr.getDepthSensingMesh();oe!==null&&el(oe,G,-1/0,I.sortObjects)}el(E,G,0,I.sortObjects),T.finish(),I.sortObjects===!0&&T.sort(R,b,G.reversedDepth),xe=ht.enabled===!1||ht.isPresenting===!1||ht.hasDepthSensing()===!1,xe&&ot.addToRenderList(T,E),this.info.render.frame++,this.info.autoReset===!0&&this.info.reset(),N===!0&&tt.beginShadows();let J=M.state.shadowsArray;if(vt.render(J,E,G),N===!0&&tt.endShadows(),(K&&L.hasRenderPass())===!1){let oe=T.opaque,de=T.transmissive;if(M.setupLights(),G.isArrayCamera){let ge=G.cameras;if(de.length>0)for(let Me=0,Re=ge.length;Me<Re;Me++)Vh(oe,de,E,ge[Me]);xe&&ot.render(E);for(let Me=0,Re=ge.length;Me<Re;Me++){let ke=ge[Me];Gh(T,E,ke,ke.viewport)}}else de.length>0&&Vh(oe,de,E,G),xe&&ot.render(E),Gh(T,E,G)}ne!==null&&W===0&&(me.updateMultisampleRenderTarget(ne),me.updateRenderTargetMipmap(ne)),K&&L.end(I),E.isScene===!0&&E.onAfterRender(I,E,G),tn.resetDefaultState(),pe=-1,Ee=null,O.pop(),O.length>0?(M=O[O.length-1],me.setTextureUnits(M.state.textureUnits),N===!0&&tt.setGlobalState(I.clippingPlanes,M.state.camera)):M=null,P.pop(),T=P.length>0?P[P.length-1]:null,U!==null&&U.renderEnd()},this.getActiveCubeFace=function(){return Y},this.getActiveMipmapLevel=function(){return W},this.getRenderTarget=function(){return ne},this.setRenderTargetTextures=function(E,G,q){let K=re.get(E);K.__autoAllocateDepthBuffer=E.resolveDepthBuffer===!1,K.__autoAllocateDepthBuffer===!1&&(K.__useRenderToTexture=!1),re.get(E.texture).__webglTexture=G,re.get(E.depthTexture).__webglTexture=K.__autoAllocateDepthBuffer?void 0:q,K.__hasExternalTextures=!0},this.setRenderTargetFramebuffer=function(E,G){let q=re.get(E);q.__webglFramebuffer=G,q.__useDefaultFramebuffer=G===void 0},this.setRenderTarget=function(E,G=0,q=0){ne=E,Y=G,W=q;let K=null,J=!1,oe=!1;if(E){let de=re.get(E);if(de.__useDefaultFramebuffer!==void 0)return ee.bindFramebuffer(z.FRAMEBUFFER,de.__webglFramebuffer),_e.copy(E.viewport),ve.copy(E.scissor),ie=E.scissorTest,ee.viewport(_e),ee.scissor(ve),ee.setScissorTest(ie),void(pe=-1);if(de.__webglFramebuffer===void 0)me.setupRenderTarget(E);else if(de.__hasExternalTextures)me.rebindTextures(E,re.get(E.texture).__webglTexture,re.get(E.depthTexture).__webglTexture);else if(E.depthBuffer){let Re=E.depthTexture;if(de.__boundDepthTexture!==Re){if(Re!==null&&re.has(Re)&&(E.width!==Re.image.width||E.height!==Re.image.height))throw new Error("THREE.WebGLRenderer: Attached DepthTexture is initialized to the incorrect size.");me.setupDepthRenderbuffer(E)}}let ge=E.texture;(ge.isData3DTexture||ge.isDataArrayTexture||ge.isCompressedArrayTexture)&&(oe=!0);let Me=re.get(E).__webglFramebuffer;E.isWebGLCubeRenderTarget?(K=Array.isArray(Me[G])?Me[G][q]:Me[G],J=!0):K=E.samples>0&&me.useMultisampledRTT(E)===!1?re.get(E).__webglMultisampledFramebuffer:Array.isArray(Me)?Me[q]:Me,_e.copy(E.viewport),ve.copy(E.scissor),ie=E.scissorTest}else _e.copy(C).multiplyScalar($).floor(),ve.copy(F).multiplyScalar($).floor(),ie=y;if(q!==0&&(K=X),ee.bindFramebuffer(z.FRAMEBUFFER,K)&&ee.drawBuffers(E,K),ee.viewport(_e),ee.scissor(ve),ee.setScissorTest(ie),J){let de=re.get(E.texture);z.framebufferTexture2D(z.FRAMEBUFFER,z.COLOR_ATTACHMENT0,z.TEXTURE_CUBE_MAP_POSITIVE_X+G,de.__webglTexture,q)}else if(oe){let de=G;for(let ge=0;ge<E.textures.length;ge++){let Me=re.get(E.textures[ge]);z.framebufferTextureLayer(z.FRAMEBUFFER,z.COLOR_ATTACHMENT0+ge,Me.__webglTexture,q,de)}}else if(E!==null&&q!==0){let de=re.get(E.texture);z.framebufferTexture2D(z.FRAMEBUFFER,z.COLOR_ATTACHMENT0,z.TEXTURE_2D,de.__webglTexture,q)}pe=-1},this.readRenderTargetPixels=function(E,G,q,K,J,oe,de,ge=0){if(!E||!E.isWebGLRenderTarget)return void we("WebGLRenderer.readRenderTargetPixels: renderTarget is not THREE.WebGLRenderTarget.");let Me=re.get(E).__webglFramebuffer;if(E.isWebGLCubeRenderTarget&&de!==void 0&&(Me=Me[de]),Me){ee.bindFramebuffer(z.FRAMEBUFFER,Me);try{let Re=E.textures[ge],ke=Re.format,We=Re.type;if(E.textures.length>1&&z.readBuffer(z.COLOR_ATTACHMENT0+ge),!Ce.textureFormatReadable(ke))return void we("WebGLRenderer.readRenderTargetPixels: renderTarget is not in RGBA or implementation defined format.");if(!Ce.textureTypeReadable(We))return void we("WebGLRenderer.readRenderTargetPixels: renderTarget is not in UnsignedByteType or implementation defined type.");G>=0&&G<=E.width-K&&q>=0&&q<=E.height-J&&z.readPixels(G,q,K,J,yi.convert(ke),yi.convert(We),oe)}finally{let Re=ne!==null?re.get(ne).__webglFramebuffer:null;ee.bindFramebuffer(z.FRAMEBUFFER,Re)}}},this.readRenderTargetPixelsAsync=async function(E,G,q,K,J,oe,de,ge=0){if(!E||!E.isWebGLRenderTarget)throw new Error("THREE.WebGLRenderer.readRenderTargetPixels: renderTarget is not THREE.WebGLRenderTarget.");let Me=re.get(E).__webglFramebuffer;if(E.isWebGLCubeRenderTarget&&de!==void 0&&(Me=Me[de]),Me){if(G>=0&&G<=E.width-K&&q>=0&&q<=E.height-J){ee.bindFramebuffer(z.FRAMEBUFFER,Me);let Re=E.textures[ge],ke=Re.format,We=Re.type;if(E.textures.length>1&&z.readBuffer(z.COLOR_ATTACHMENT0+ge),!Ce.textureFormatReadable(ke))throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: renderTarget is not in RGBA or implementation defined format.");if(!Ce.textureTypeReadable(We))throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: renderTarget is not in UnsignedByteType or implementation defined type.");let Ae=z.createBuffer();z.bindBuffer(z.PIXEL_PACK_BUFFER,Ae),z.bufferData(z.PIXEL_PACK_BUFFER,oe.byteLength,z.STREAM_READ),z.readPixels(G,q,K,J,yi.convert(ke),yi.convert(We),0);let je=ne!==null?re.get(ne).__webglFramebuffer:null;ee.bindFramebuffer(z.FRAMEBUFFER,je);let xt=z.fenceSync(z.SYNC_GPU_COMMANDS_COMPLETE,0);return z.flush(),await _d(z,xt,4),z.bindBuffer(z.PIXEL_PACK_BUFFER,Ae),z.getBufferSubData(z.PIXEL_PACK_BUFFER,0,oe),z.deleteBuffer(Ae),z.deleteSync(xt),oe}throw new Error("THREE.WebGLRenderer.readRenderTargetPixelsAsync: requested read bounds are out of range.")}},this.copyFramebufferToTexture=function(E,G=null,q=0){let K=Math.pow(2,-q),J=Math.floor(E.image.width*K),oe=Math.floor(E.image.height*K),de=G!==null?G.x:0,ge=G!==null?G.y:0;me.setTexture2D(E,0),z.copyTexSubImage2D(z.TEXTURE_2D,q,0,0,de,ge,J,oe),ee.unbindTexture()},this.copyTextureToTexture=function(E,G,q=null,K=null,J=0,oe=0){let de,ge,Me,Re,ke,We,Ae,je,xt,ut=E.isCompressedTexture?E.mipmaps[oe]:E.image;if(q!==null)de=q.max.x-q.min.x,ge=q.max.y-q.min.y,Me=q.isBox3?q.max.z-q.min.z:1,Re=q.min.x,ke=q.min.y,We=q.isBox3?q.min.z:0;else{let Mi=Math.pow(2,-J);de=Math.floor(ut.width*Mi),ge=Math.floor(ut.height*Mi),Me=E.isDataArrayTexture?ut.depth:E.isData3DTexture?Math.floor(ut.depth*Mi):1,Re=0,ke=0,We=0}K!==null?(Ae=K.x,je=K.y,xt=K.z):(Ae=0,je=0,xt=0);let nt=yi.convert(G.format),Ve=yi.convert(G.type),rt;G.isData3DTexture?(me.setTexture3D(G,0),rt=z.TEXTURE_3D):G.isDataArrayTexture||G.isCompressedArrayTexture?(me.setTexture2DArray(G,0),rt=z.TEXTURE_2D_ARRAY):(me.setTexture2D(G,0),rt=z.TEXTURE_2D),ee.activeTexture(z.TEXTURE0),ee.pixelStorei(z.UNPACK_FLIP_Y_WEBGL,G.flipY),ee.pixelStorei(z.UNPACK_PREMULTIPLY_ALPHA_WEBGL,G.premultiplyAlpha),ee.pixelStorei(z.UNPACK_ALIGNMENT,G.unpackAlignment);let Ct=ee.getParameter(z.UNPACK_ROW_LENGTH),Pe=ee.getParameter(z.UNPACK_IMAGE_HEIGHT),De=ee.getParameter(z.UNPACK_SKIP_PIXELS),si=ee.getParameter(z.UNPACK_SKIP_ROWS),tl=ee.getParameter(z.UNPACK_SKIP_IMAGES);ee.pixelStorei(z.UNPACK_ROW_LENGTH,ut.width),ee.pixelStorei(z.UNPACK_IMAGE_HEIGHT,ut.height),ee.pixelStorei(z.UNPACK_SKIP_PIXELS,Re),ee.pixelStorei(z.UNPACK_SKIP_ROWS,ke),ee.pixelStorei(z.UNPACK_SKIP_IMAGES,We);let js=E.isDataArrayTexture||E.isData3DTexture,jr=G.isDataArrayTexture||G.isData3DTexture;if(E.isDepthTexture){let Mi=re.get(E),Xn=re.get(G),Oi=re.get(Mi.__renderTarget),il=re.get(Xn.__renderTarget);ee.bindFramebuffer(z.READ_FRAMEBUFFER,Oi.__webglFramebuffer),ee.bindFramebuffer(z.DRAW_FRAMEBUFFER,il.__webglFramebuffer);for(let jn=0;jn<Me;jn++)js&&(z.framebufferTextureLayer(z.READ_FRAMEBUFFER,z.COLOR_ATTACHMENT0,re.get(E).__webglTexture,J,We+jn),z.framebufferTextureLayer(z.DRAW_FRAMEBUFFER,z.COLOR_ATTACHMENT0,re.get(G).__webglTexture,oe,xt+jn)),z.blitFramebuffer(Re,ke,de,ge,Ae,je,de,ge,z.DEPTH_BUFFER_BIT,z.NEAREST);ee.bindFramebuffer(z.READ_FRAMEBUFFER,null),ee.bindFramebuffer(z.DRAW_FRAMEBUFFER,null)}else if(J!==0||E.isRenderTargetTexture||re.has(E)){let Mi=re.get(E),Xn=re.get(G);ee.bindFramebuffer(z.READ_FRAMEBUFFER,k),ee.bindFramebuffer(z.DRAW_FRAMEBUFFER,V);for(let Oi=0;Oi<Me;Oi++)js?z.framebufferTextureLayer(z.READ_FRAMEBUFFER,z.COLOR_ATTACHMENT0,Mi.__webglTexture,J,We+Oi):z.framebufferTexture2D(z.READ_FRAMEBUFFER,z.COLOR_ATTACHMENT0,z.TEXTURE_2D,Mi.__webglTexture,J),jr?z.framebufferTextureLayer(z.DRAW_FRAMEBUFFER,z.COLOR_ATTACHMENT0,Xn.__webglTexture,oe,xt+Oi):z.framebufferTexture2D(z.DRAW_FRAMEBUFFER,z.COLOR_ATTACHMENT0,z.TEXTURE_2D,Xn.__webglTexture,oe),J!==0?z.blitFramebuffer(Re,ke,de,ge,Ae,je,de,ge,z.COLOR_BUFFER_BIT,z.NEAREST):jr?z.copyTexSubImage3D(rt,oe,Ae,je,xt+Oi,Re,ke,de,ge):z.copyTexSubImage2D(rt,oe,Ae,je,Re,ke,de,ge);ee.bindFramebuffer(z.READ_FRAMEBUFFER,null),ee.bindFramebuffer(z.DRAW_FRAMEBUFFER,null)}else jr?E.isDataTexture||E.isData3DTexture?z.texSubImage3D(rt,oe,Ae,je,xt,de,ge,Me,nt,Ve,ut.data):G.isCompressedArrayTexture?z.compressedTexSubImage3D(rt,oe,Ae,je,xt,de,ge,Me,nt,ut.data):z.texSubImage3D(rt,oe,Ae,je,xt,de,ge,Me,nt,Ve,ut):E.isDataTexture?z.texSubImage2D(z.TEXTURE_2D,oe,Ae,je,de,ge,nt,Ve,ut.data):E.isCompressedTexture?z.compressedTexSubImage2D(z.TEXTURE_2D,oe,Ae,je,ut.width,ut.height,nt,ut.data):z.texSubImage2D(z.TEXTURE_2D,oe,Ae,je,de,ge,nt,Ve,ut);ee.pixelStorei(z.UNPACK_ROW_LENGTH,Ct),ee.pixelStorei(z.UNPACK_IMAGE_HEIGHT,Pe),ee.pixelStorei(z.UNPACK_SKIP_PIXELS,De),ee.pixelStorei(z.UNPACK_SKIP_ROWS,si),ee.pixelStorei(z.UNPACK_SKIP_IMAGES,tl),oe===0&&G.generateMipmaps&&z.generateMipmap(rt),ee.unbindTexture()},this.initRenderTarget=function(E){re.get(E).__webglFramebuffer===void 0&&me.setupRenderTarget(E)},this.initTexture=function(E){E.isCubeTexture?me.setTextureCube(E,0):E.isData3DTexture?me.setTexture3D(E,0):E.isDataArrayTexture||E.isCompressedArrayTexture?me.setTexture2DArray(E,0):me.setTexture2D(E,0),ee.unbindTexture()},this.resetState=function(){Y=0,W=0,ne=null,ee.reset(),tn.reset()},typeof __THREE_DEVTOOLS__<"u"&&__THREE_DEVTOOLS__.dispatchEvent(new CustomEvent("observe",{detail:this}))}get coordinateSystem(){return Wi}get outputColorSpace(){return this._outputColorSpace}set outputColorSpace(e){this._outputColorSpace=e;let t=this.getContext();t.drawingBufferColorSpace=He._getDrawingBufferColorSpace(e),t.unpackColorSpace=He._getUnpackColorSpace()}};var Ho=class{constructor(){this.enabled=!1,this.paused=!1,this.tickIndex=0}async enable(e){if(this.enabled=e,!e){this.ctx?.suspend();return}try{this.ctx||this.create(),this.paused||await this.ctx.resume()}catch{this.enabled=!1}}create(){let e=window.AudioContext||window.webkitAudioContext;this.ctx=new e;let t=this.ctx;this.master=t.createGain(),this.master.gain.value=.24;let i=t.createDynamicsCompressor();this.master.connect(i),i.connect(t.destination),[55,82.4069,110,164.8138].forEach((s,a)=>{let o=t.createOscillator(),c=t.createGain();o.type="sine",o.frequency.value=s,c.gain.value=.025/(a+1),o.connect(c),c.connect(this.master),o.start();let l=t.createOscillator(),h=t.createGain();l.frequency.value=.08+a*.023,h.gain.value=.008/(a+1),l.connect(h),h.connect(c.gain),l.start()}),this.engine=t.createOscillator(),this.engine.type="triangle",this.engine.frequency.value=42,this.engineGain=t.createGain(),this.engineGain.gain.value=.008;let n=t.createBiquadFilter();n.type="lowpass",n.frequency.value=180,this.engine.connect(n),n.connect(this.engineGain),this.engineGain.connect(this.master),this.engine.start()}tone(e,t=.09,i=.06,n=0,s="sine"){if(!this.enabled||this.paused||this.ctx?.state!=="running")return;let a=this.ctx,o=a.currentTime+n,c=a.createOscillator(),l=a.createGain();c.type=s,c.frequency.value=e,l.gain.setValueAtTime(0,o),l.gain.linearRampToValueAtTime(i,o+.008),l.gain.exponentialRampToValueAtTime(1e-4,o+t),c.connect(l),l.connect(this.master),c.start(o),c.stop(o+t+.03),c.onended=()=>{c.disconnect(),l.disconnect()}}type(){let e=[523.25,659.25,783.99,987.77,783.99,659.25];this.tone(e[this.tickIndex++%e.length],.055,.028,0,"triangle")}select(){this.tone(523.25,.12,.08),this.tone(783.99,.16,.05,.07)}arrival(){[261.63,329.63,392,523.25].forEach((e,t)=>this.tone(e,.8,.08,t*.12))}depart(){[130.81,196,261.63,392].forEach((e,t)=>this.tone(e,.45,.07,t*.1))}warpCharge(e=1.6){this.depart(),[110,164.81,220,329.63,440,659.25].forEach((t,i)=>this.tone(t,.5,.07,i*((e-.5)/5),"triangle"))}warpJump(){[65.41,130.81,261.63,523.25,1046.5].forEach((e,t)=>this.tone(e,1.5,.09,t*.045))}throttle(e){this.ctx&&(this.engine.frequency.setTargetAtTime(42+e*65,this.ctx.currentTime,.3),this.engineGain.gain.setTargetAtTime(.008+e*.14,this.ctx.currentTime,.4))}pause(e){this.paused=e,e?this.ctx?.suspend():this.enabled&&this.ctx?.resume().catch(()=>{})}dispose(){this.ctx?.close()}};var ko=class{constructor(e){this.canvas=e,this.ctx=e.getContext("2d"),this.time=0,this.activity=0,this.accumulator=1,this.lastReduced=null,this.colors=["#80e9e0","#a7deff","#b8adf4","#e8afbc","#dceac9"]}point(e,t,i){let n=Math.pow(Math.sin(Math.PI*e),.8),s=t*2.39996,a=1+this.activity*.12;return[12+e*216,67+Math.sin(e*6.5-i*.45)*10+n*a*(Math.sin(e*9+s+i*(.32+t%3*.05))*(13+t%5*3)+Math.cos(e*16-s-i*.22)*5)]}draw(e,t,i){if(!this.ctx)return;this.accumulator+=e;let n=this.canvas.getBoundingClientRect(),s=Math.min(window.devicePixelRatio||1,2),a=Math.round(n.width*s),o=Math.round(n.height*s);if(!a||!o)return;let c=this.canvas.width!==a||this.canvas.height!==o;if(!c&&t&&this.lastReduced===!0||!c&&!t&&this.accumulator<1/30)return;let l=Math.min(this.accumulator,.1);this.accumulator=0,this.lastReduced=t,t||(this.time+=l),this.activity+=((i&&!t?1:0)-this.activity)*Math.min(l*4,1),c&&(this.canvas.width=a,this.canvas.height=o);let h=this.ctx;h.setTransform(a/240,0,0,o/134,0,0),h.clearRect(0,0,240,134);let d=t?0:this.time;h.globalCompositeOperation="lighter";for(let p=0;p<30;p++){let u=this.colors[p%this.colors.length],g=h.createLinearGradient(12,0,228,0);g.addColorStop(0,u+"00"),g.addColorStop(.18,u+"70"),g.addColorStop(.48,u+(p%4===0?"d0":"80")),g.addColorStop(.82,u+"60"),g.addColorStop(1,u+"00"),h.strokeStyle=g,h.shadowColor=u,h.shadowBlur=4+this.activity*3,h.lineWidth=p%4===0?1.05:.5,h.beginPath();for(let m=0;m<=80;m++){let[v,f]=this.point(m/80,p,d);m===0?h.moveTo(v,f):h.lineTo(v,f)}if(h.stroke(),p%2===0){let m=.22+p*.137%.57,v=this.point(m,p,d),f=this.point(m+.055,p+1,d);h.globalAlpha=.3,h.beginPath(),h.moveTo(...v),h.bezierCurveTo(v[0]+7,v[1],f[0]-7,f[1],...f),h.stroke(),h.globalAlpha=1}if(p%3===0){let m=(p*.173+d*(.035+this.activity*.018))%1,[v,f]=this.point(m,p,d);h.globalAlpha=Math.sin(Math.PI*m)*.85,h.fillStyle=u,h.shadowBlur=7,h.beginPath(),h.arc(v,f,p%2===0?1.05:.7,0,Math.PI*2),h.fill(),h.globalAlpha=1}}h.shadowBlur=0,h.globalCompositeOperation="source-over"}};function tp(r){let e=new mt;e.name="observatory-problematic-network",e.position.set(...r.position);let t=new mt;e.add(t);let i=9512,n=()=>(i=i*1664525+1013904223>>>0,i/4294967296),s=26,a=Array.from({length:s},(L,I)=>{let B=1-I/(s-1)*2,U=I*2.3999632297+n()*.2,X=Math.sqrt(1-B*B),k=1.8+n()*.65;return new w(Math.cos(U)*X*k,B*k*.84,Math.sin(U)*X*k)}),o=a.map(L=>L.clone()),c=[],l=new Set,h=(L,I)=>{let B=`${Math.min(L,I)}:${Math.max(L,I)}`;l.has(B)||(l.add(B),c.push([L,I]))},d=new Set([0]);for(;d.size<s;){let L=1/0,I=0,B=0;for(let U of d)for(let X=0;X<s;X++){if(d.has(X))continue;let k=a[U].distanceToSquared(a[X]);k<L&&(L=k,I=U,B=X)}h(I,B),d.add(B)}a.forEach((L,I)=>{a.map((B,U)=>({b:U,distance:L.distanceToSquared(B)})).filter(({b:B})=>B!==I).sort((B,U)=>B.distance-U.distance).slice(0,2).forEach(({b:B})=>h(I,B))});let p=new Float32Array(c.length*6),u=new Xe;u.setAttribute("position",new ft(p,3));let g=new Nn(u,new qi({color:9288933,transparent:!0,opacity:.38,blending:fi,depthWrite:!1}));g.frustumCulled=!1,t.add(g);let m=document.createElement("canvas");m.width=m.height=64;let v=m.getContext("2d"),f=v.createRadialGradient(32,32,0,32,32,32);f.addColorStop(0,"#ffffff"),f.addColorStop(.15,"#ffffffa0"),f.addColorStop(.45,"#ffffff22"),f.addColorStop(1,"#ffffff00"),v.fillStyle=f,v.fillRect(0,0,64,64);let _=new Yi(m),x=new ni(1,12,10),S=[5822955,11308259,7054835,7134651,14261437,9019109,14203512,10147774],T=a.map((L,I)=>{let B=S[I%S.length],X=.052+c.filter(([Y,W])=>Y===I||W===I).length*.009,k=new Oe(x,new Et({color:B}));k.scale.setScalar(X),t.add(k);let V=new In(new pn({map:_,color:B,transparent:!0,opacity:.72,blending:fi,depthWrite:!1}));return V.scale.setScalar(X*6),t.add(V),{core:k,halo:V,phase:n()*Math.PI*2}}),M=Array.from({length:5},(L,I)=>{let B=new Oe(x,new Et({color:14416383}));return B.scale.setScalar(.023),t.add(B),{light:B,edge:c[Math.floor(I*c.length/5)],phase:n()}}),P=0;function O(L){P+=L,t.rotation.set(.22+Math.sin(P*.071)*.3,P*.075+Math.sin(P*.043)*.18,-.13+Math.sin(P*.059)*.17),T.forEach((I,B)=>{let U=I.phase;o[B].set(a[B].x+Math.sin(P*.24+U)*.07,a[B].y+Math.cos(P*.19+U)*.07,a[B].z+Math.sin(P*.21+U*2)*.07),I.core.position.copy(o[B]),I.halo.position.copy(o[B]),I.halo.material.opacity=.65+Math.sin(P*.7+U)*.1}),c.forEach(([I,B],U)=>{o[I].toArray(p,U*6),o[B].toArray(p,U*6+3)}),u.attributes.position.needsUpdate=!0,M.forEach(({light:I,edge:[B,U],phase:X})=>{I.position.lerpVectors(o[B],o[U],(P*.12+X)%1)})}return O(0),{group:e,update:O}}var Yf=[["\xC1guas do territ\xF3rio","O rio revela caminhos","e mem\xF3rias da paisagem."],["Mem\xF3rias do lugar","Hist\xF3rias que atravessam","gera\xE7\xF5es e encontros."],["Paisagens vivas","Pequenos sinais da vida","nos espa\xE7os que habitamos."],["Redes de cuidado","Gestos que aproximam","pessoas e comunidades."],["Caminhos e encontros","Percursos do cotidiano","abrem novas descobertas."],["Vozes do cotidiano","Escutar o territ\xF3rio","\xE9 descobrir outras pistas."],["Sinais da comunidade","Um olhar atento encontra","rela\xE7\xF5es por toda parte."],["Transforma\xE7\xF5es","O que muda ao redor","tamb\xE9m nos transforma."]];function Zf(r,e){let t=document.createElement("canvas");t.width=256,t.height=336;let i=t.getContext("2d"),n=["#97edcf","#9ddbe9","#b9b8f2","#d6dfb1"][e%4];i.fillStyle="#081c28",i.strokeStyle=n,i.lineWidth=2,i.beginPath(),i.roundRect(5,5,246,326,14),i.fill(),i.globalAlpha=.65,i.stroke(),i.globalAlpha=1,i.fillStyle=n,i.fillRect(20,22,4,14),i.font="500 12px Space, sans-serif",i.fillText("PISTA / TERRIT\xD3RIO",34,33);let s=i.createLinearGradient(0,52,0,150);s.addColorStop(0,"#183d4d"),s.addColorStop(1,"#0b2735"),i.fillStyle=s,i.fillRect(20,52,216,103),i.strokeStyle=n;for(let h=0;h<5;h++){i.globalAlpha=.18+h*.1,i.lineWidth=h===2?2:1,i.beginPath();for(let d=20;d<=236;d+=3){let p=100+Math.sin(d*.021+e+h*.4)*19+h*7;d===20?i.moveTo(d,p):i.lineTo(d,p)}i.stroke()}i.globalAlpha=1,i.fillStyle=n,i.beginPath(),i.arc(185-e*9,78+e%3*8,4,0,Math.PI*2),i.fill(),i.fillStyle="#edf9f7",i.font="500 21px Space, sans-serif";let a=r[0].split(" "),o="",c=190;for(let h of a){let d=o?`${o} ${h}`:h;i.measureText(d).width>210?(i.fillText(o,22,c),c+=26,o=h):o=d}i.fillText(o,22,c),i.fillStyle="#a5c5cb",i.font="14px Space, sans-serif",i.fillText(r[1],22,254),i.fillText(r[2],22,274),i.globalAlpha=.4,i.fillStyle=n,i.fillRect(22,300,140,1),i.fillRect(222,298,4,4);let l=new Yi(t);return l.colorSpace=bt,l}function ip(r){let e=new mt;e.name="research-hollow-clue-moon",e.position.set(...r.position);let t=new mt;e.add(t);let i=Yf.map((d,p)=>new Et({map:Zf(d,p),side:Vt,transparent:!0,alphaTest:.1,depthWrite:!0})),n=new gn(.57,.75),s=2.36,a=[4,12,18,22,24,22,18,12,4],o=new w,c=0;a.forEach((d,p)=>{let u=Kc.degToRad(-80+p*20),g=Math.cos(u);for(let m=0;m<d;m++){let v=m*Math.PI*2/d,f=new w(Math.sin(v)*g,Math.sin(u),Math.cos(v)*g),_=new Oe(n,i[c++%i.length]);_.position.copy(f).multiplyScalar(s),_.lookAt(o.copy(_.position).add(f)),t.add(_)}});let l=0;function h(d){l+=d,t.rotation.set(0,l*.055,0)}return h(0),{group:e,update:h}}var Q=r=>document.getElementById(r),lt=new Ho,Jf=new ko(Q("iarete-flow")),cp=document.querySelector(".console"),hp=new ResizeObserver(()=>{document.body.style.setProperty("--console-height",`${cp.offsetHeight}px`)});hp.observe(cp);var Hn={charge:3.6,jump:2.4,settle:1.2},wt=[{id:"earth",description:"Explore as pistas dos territ\xF3rios em um mapa georreferenciado.",contents:["Pistas no mapa","Territ\xF3rios e localiza\xE7\xF5es"],name:"Terra",module:"Mapa de Pistas",short:"Terra",symbol:"\u25CE",sector:"SOL \xB7 03",subtitle:"Um planeta vivo. Infinitas conex\xF5es.",position:[3,0,-14],radius:5,color:9434589,message:"A Terra guarda as pistas dos nossos territ\xF3rios. Vamos nos aproximar e explorar essas conex\xF5es?",arrival:"Chegamos \xE0 Terra. O observat\xF3rio territorial est\xE1 pronto. Abra o Mapa de Pistas para explorar em tela cheia."},{id:"research",description:"Re\xFAna pistas, viv\xEAncias e descobertas para conhecer melhor os territ\xF3rios.",contents:["Pistas","Viv\xEAncias e descobertas"],name:"Lua de Pistas",module:"Pistas",short:"Pesquisa",symbol:"\u25C7",sector:"SETOR \xB7 07",subtitle:"Cada pista abre uma nova possibilidade.",position:[-24,5,-24],radius:3.3,focusOffset:[0,-1.75,0],color:8779219,message:"Rota para a Lua de Pistas. Cada fragmento dessa pequena lua \xE9 um card: viv\xEAncias e descobertas que se aproximam e formam novas paisagens.",arrival:"Chegamos \xE0 Lua de Pistas. Os cards flutuam ao nosso redor. Abra as Pistas para explorar as viv\xEAncias e descobertas dos territ\xF3rios."},{id:"observatory",description:"Explore problem\xE1ticas e observe as rela\xE7\xF5es entre os desafios dos territ\xF3rios.",contents:["Problem\xE1ticas","Conex\xF5es entre problem\xE1ticas"],name:"Observat\xF3rio",module:"Problem\xE1ticas",short:"Observat\xF3rio",symbol:"\u25C8",sector:"SETOR \xB7 12",subtitle:"Novos olhares sobre quest\xF5es que nos conectam.",position:[-40,-2,14],radius:2.7,color:11903231,message:"O Observat\xF3rio \xE9 uma rede viva de problem\xE1ticas. Cada nodo mant\xE9m suas conex\xF5es enquanto exploramos novas perspectivas.",arrival:"Chegamos \xE0 rede do Observat\xF3rio. Os nodos e suas conex\xF5es revelam rela\xE7\xF5es entre problem\xE1ticas. Abra o grafo para explorar."},{id:"agents",description:"Conhe\xE7a os agentes de intelig\xEAncia artificial que acompanham suas explora\xE7\xF5es.",contents:["Agentes de IA","Conversas e apoio \xE0 explora\xE7\xE3o"],name:"Campo de Intelig\xEAncias",module:"Agentes",short:"Intelig\xEAncias",symbol:"\u2727",sector:"SETOR \xB7 24",subtitle:"M\xFAltiplas intelig\xEAncias. Outros horizontes.",position:[36,3,-28],radius:2.7,color:8575231,message:"\xD3rbitas luminosas entrela\xE7am as intelig\xEAncias que acompanham nossas explora\xE7\xF5es. Vamos nos aproximar?",arrival:"Chegamos ao Campo de Intelig\xEAncias. N\xE3o h\xE1 uma estrutura central: as luzes se conectam em movimento. Os agentes est\xE3o dispon\xEDveis para conversar."}],Kt=wt.map(r=>r.id),qe=wt[0],Pt=null,wh=!1,Hs=!1,yh=!1,gt=!1,yn=!1,_t=matchMedia("(prefers-reduced-motion: reduce)").matches,Mh,up="",Ui=0,jo,qo=0,Sh=0,Wo=!0,Ft,Vn,Qe,xn,vh,np,dp=[],pp,Yo,mp,Ah,Mn=new w(0,0,-14);function Wr(r,e={}){let t=JSON.stringify({channel:"econectiva-space",type:r,...e});window.SpaceBridge?window.SpaceBridge.postMessage(t):parent!==window?parent.postMessage(t,location.origin):(r==="open"||r==="assistant")&&(Wn(r==="assistant"?"Na plataforma, este console abre nossa conversa. Estou aqui para acompanhar sua explora\xE7\xE3o.":"Destino pronto. Dentro da plataforma, este acesso abre o m\xF3dulo real em tela cheia."),Fi("Pr\xE9via \xB7 acesso a "+(r==="assistant"?"Iaret\xE9":qe.module)))}function Fi(r){let e=new Date().toLocaleTimeString("pt-BR",{hour:"2-digit",minute:"2-digit"});Q("log").textContent=r;let t=document.createElement("li"),i=document.createElement("time");i.textContent=e,t.append(i,document.createTextNode(r)),Q("events").prepend(t),Q("events").children.length>30&&Q("events").lastChild.remove()}function Wn(r){clearTimeout(Mh),up=r,Q("message-accessible").textContent=r,Q("message").textContent="",document.body.classList.add("speaking");let e=0,t=()=>{Hs||(e=_t?r.length:Math.min(r.length,e+1),Q("message").textContent=r.slice(0,e),!_t&&e%3===0&&/\S/.test(r[e-1])&&lt.type(),e<r.length?Mh=setTimeout(t,/[.,?!]/.test(r[e-1])?140:23):document.body.classList.remove("speaking"))};t()}function fp(){Q("sound").textContent=lt.enabled?"Som ligado":"Som desligado",Q("sound").setAttribute("aria-pressed",String(lt.enabled))}function gp(){_t&&_p(qe),document.body.classList.toggle("reduced",_t),Q("motion").textContent=_t?"Movimento reduzido":"Movimento suave",Q("motion").setAttribute("aria-pressed",String(_t))}var Qi={x:110,y:122},kn={...Qi};function Zo(r){return{x:110+r.position[0]*2,y:108+r.position[2]*1.8}}function Kf(){let r="http://www.w3.org/2000/svg";Q("map-nodes").replaceChildren(...wt.filter(n=>Kt.includes(n.id)).map(n=>{let s=Zo(n),a=document.createElementNS(r,"g");a.classList.toggle("map-current",Pt===n.id),a.classList.toggle("map-selected",qe.id===n.id);let o=document.createElementNS(r,"circle");o.setAttribute("cx",s.x),o.setAttribute("cy",s.y),o.setAttribute("r",n.id==="earth"?5:3.5);let c=document.createElementNS(r,"text");return c.setAttribute("x",s.x),c.setAttribute("y",s.y+(s.y>108?17:-13)),c.setAttribute("text-anchor","middle"),c.textContent=n.short,a.append(o,c),a}));let e=wt.find(n=>n.id===Pt),t=gt?`Em salto \u2192 ${qe.short}`:e?`Voc\xEA est\xE1 em ${e.name}`:"Espa\xE7o aberto \xB7 em cruzeiro";Q("map-location").textContent=t,Q("expedition-map").setAttribute("aria-label",`Mapa da expedi\xE7\xE3o. ${t}`);let i=Zo(qe);Q("map-route").setAttribute("d",gt?`M${kn.x},${kn.y} L${i.x},${i.y}`:"")}function $f(){if(gt){let r=Math.min(Math.max((Ui-Hn.charge)/Hn.jump,0),1),e=r*r*(3-2*r),t=Zo(qe);Qi.x=kn.x+(t.x-kn.x)*e,Qi.y=kn.y+(t.y-kn.y)*e}else Pt?Object.assign(Qi,Zo(wt.find(r=>r.id===Pt))):_t||(Qi.x=110+Math.sin(Sh*.12)*8,Qi.y=122+Math.cos(Sh*.12)*4);Q("map-ship").setAttribute("transform",`translate(${Qi.x} ${Qi.y})`)}function Xr(){document.body.classList.toggle("at-destination",!!Pt),document.body.classList.toggle("at-current-destination",yn&&Pt===qe.id&&!gt),Kf(),Q("destinations").replaceChildren(),wt.filter(r=>Kt.includes(r.id)).forEach((r,e)=>{let t=document.createElement("button");t.className="destination",t.setAttribute("aria-pressed",String(r===qe)),t.setAttribute("aria-label",`${r.name}: ${r.module}`);let i=document.createElement("span");i.className="symbol",i.textContent=r.symbol;let n=document.createElement("span"),s=document.createElement("strong"),a=document.createElement("small");s.textContent=r.short,a.textContent=`0${e+1} / ${r.module.toUpperCase()}`,n.append(s,a),t.append(i,n),t.onclick=()=>Ch(r),t.disabled=gt,Q("destinations").append(t)})}var rp="earth",Hr=null,sp=0;function _p(r){let e=Q("destination-summary"),t=++sp,i=getComputedStyle(e).opacity,n=Hr?.playState==="running";Hr?.cancel();let s=()=>{Q("destination-title").textContent=r.name,Q("destination-subtitle").textContent=r.subtitle,Q("coordinates").textContent=r.sector,rp=r.id};if(_t||!n&&rp===r.id){s();return}Hr=e.animate([{opacity:i,transform:"translateY(0)"},{opacity:0,transform:"translateY(-4px)"}],{duration:180,easing:"ease-in",fill:"forwards"}),Hr.finished.then(()=>{t===sp&&(s(),Hr.cancel(),_t||(Hr=e.animate([{opacity:0,transform:"translateY(6px)"},{opacity:1,transform:"translateY(0)"}],{duration:500,easing:"cubic-bezier(.2,.7,.2,1)"})))}).catch(()=>{})}function Ch(r){gt||xi>=0||!Kt.includes(r.id)||(qe=r,lt.select(),Q("navigate").hidden=yn&&Pt===r.id,Q("direct").hidden=yn&&Pt===r.id,Q("skip").hidden=!0,_p(r),Q("module-title").textContent=r.module,Q("distance").textContent=`0${wt.indexOf(r)+1} / ${String(wt.length).padStart(2,"0")}`,Q("navigate").textContent=yn&&Pt===r.id?`Abrir ${r.module} \u2197`:r.id==="earth"?"Navegar at\xE9 a Terra \u2192":r.id==="agents"?"Navegar at\xE9 Intelig\xEAncias \u2192":r.id==="observatory"?"Navegar at\xE9 o Observat\xF3rio \u2192":r.id==="research"?"Navegar at\xE9 a Lua de Pistas \u2192":"Navegar at\xE9 a esta\xE7\xE3o \u2192",Q("reticle-label").textContent=Pt===r.id?`${r.short.toUpperCase()} / SINAL EST\xC1VEL`:"ROTA DISPON\xCDVEL",Q("flight-status").textContent=Pt&&Pt!==r.id?"Destino selecionado \xB7 aguardando iniciar navega\xE7\xE3o":yn?"\xD3rbita estabelecida":"Rota cont\xEDnua \xB7 destino selecionado",Q("progress").style.width="0%",Xr(),Wn(r.message),Wr("select",{name:r.name}))}var xh=0,Xo=0,en="",xi=-1,vp,kr,bh,Ht,Jt,xp=Array.from({length:260},()=>({x:(Math.random()-.5)*70,y:(Math.random()-.5)*42,z:-3-Math.random()*110,speed:.25+Math.random()**2*2.75}));function Jo(r){return new w(Math.sin(r)*90,18+Math.sin(r*2)*5,Math.cos(r)*80)}function yp(){if(!(!wh||Hs||gt||xi>=0||!Kt.includes(qe.id))){if(yn&&Pt===qe.id){Mp();return}if(kn={...Qi},gt=!0,Rh(),Jt&&(Jt.visible=!0),Ui=0,en="charge",lt.warpCharge(Hn.charge),document.body.classList.add("travelling"),Q("navigate").hidden=!0,Q("direct").hidden=!0,Q("skip").hidden=!1,Q("flight-status").textContent="Alinhando vetor \xB7 carregando salto",Q("speed").textContent="CARGA",Wn(`Rota confirmada. Seguimos para ${qe.id==="earth"?"a Terra":qe.name}. Carregando o salto conectivo.`),Fi("Partida autorizada \xB7 "+qe.name),Xr(),Qe){pp=Qe.position.clone(),mp=Qe.quaternion.clone();let r=new w(...qe.position);Yo=r.clone().add(new w(-qe.radius*.85,qe.radius*.4,qe.radius*3.2)),Ah=r.clone().add(new w(...qe.focusOffset??[-qe.radius*.65,0,0]))}_t&&$o()}}function $o(){gt&&(gt=!1,yn=!0,Pt=qe.id,Rh(),lt.throttle(.12),lt.arrival(),Xo=0,en="",document.body.style.setProperty("--warp-strength","0"),Qe&&Yo&&(Qe.position.copy(Yo),Mn.copy(Ah),Qe.lookAt(Mn)),document.body.classList.remove("travelling"),Q("navigate").hidden=!0,Q("direct").hidden=!0,Q("skip").hidden=!0,Q("navigate").textContent=`Abrir ${qe.module} \u2197`,Q("flight-status").textContent=qe.id==="earth"?"\xD3rbita terrestre estabelecida":qe.id==="agents"?"Campo de Intelig\xEAncias alcan\xE7ado":qe.id==="observatory"?"Rede de Problem\xE1ticas alcan\xE7ada":qe.id==="research"?"\xD3rbita da Lua de Pistas estabelecida":"Acoplamento conclu\xEDdo",Q("speed").textContent="\xD3RBITA",Q("progress").style.width="100%",Q("reticle-label").textContent=`${qe.short.toUpperCase()} / CONEX\xC3O ESTABELECIDA`,Fi("Chegada \xB7 "+qe.name),Wn(qe.arrival),Xr())}var ap=null,Gs=null,op=0;function Rh(){let r=wt.find(e=>e.id===Pt);if(r){let e=ap!==r.id,t=++op;Gs?.cancel();let i=Q("local-details"),n=()=>{Q("local-sector").textContent=r.sector,Q("local-emblem").textContent=r.symbol,Q("local-name").textContent=r.name,Q("local-description").textContent=r.description,Q("local-status").textContent=gt?"EM TR\xC2NSITO \xB7 \xDALTIMO LOCAL":"CONEX\xC3O ESTABELECIDA",Q("local-contents").replaceChildren(...r.contents.map(s=>{let a=document.createElement("span");return a.textContent=s,a})),Q("local-open").hidden=!Kt.includes(r.id),Q("local-open").disabled=gt||xi>=0,Q("local-open").textContent=`Abrir ${r.module} \u2197`,ap=r.id,e&&!gt&&Q("local-open").focus({preventScroll:!0})};if(!e||_t){n();return}Q("local-open").disabled=!0,Gs=i.animate([{opacity:1,transform:"translateY(0)"},{opacity:0,transform:"translateY(-4px)"}],{duration:180,easing:"ease-in",fill:"forwards"}),Gs.finished.then(()=>{t===op&&(n(),Gs.cancel(),_t||(Gs=i.animate([{opacity:0,transform:"translateY(6px)"},{opacity:1,transform:"translateY(0)"}],{duration:520,easing:"cubic-bezier(.2,.7,.2,1)"})))}).catch(()=>{})}}Q("local-open").onclick=()=>{let r=wt.find(e=>e.id===Pt);r&&Sp(r)};function Mp(){Sp(qe)}function Sp(r){!Kt.includes(r.id)||xi>=0||gt||(vp=r.id,xi=0,lt.select(),Fi("Preparando sa\xEDda do cockpit \xB7 "+r.module),Wn(r.id==="earth"?"Preparando a imers\xE3o territorial. O cockpit se recolhe para dar lugar ao mapa.":r.id==="research"?"Preparando a sala de Pesquisa. A lua hologr\xE1fica vai ajudar voc\xEA a localizar cada pista.":r.id==="connections"?"Preparando a sala de Conex\xF5es da nave. A tela de explora\xE7\xE3o est\xE1 pronta para receber voc\xEA.":r.id==="agents"?"Preparando a C\xE2mara de Intelig\xEAncias. Escolha uma presen\xE7a para iniciar sua conversa.":"Preparando acesso \xE0 esta\xE7\xE3o. Transferindo os controles para o m\xF3dulo."),Q("transfer-label").textContent=r.id==="earth"?"Entrando no observat\xF3rio territorial":r.id==="research"?"Entrando na sala de Pesquisa":r.id==="connections"?"Entrando na sala de Conex\xF5es":r.id==="agents"?"Entrando na C\xE2mara de Intelig\xEAncias":"Acessando "+r.module,document.body.classList.add("disembarking"),document.querySelectorAll("#flight-ui button").forEach(e=>e.disabled=!0))}function Qf(){xi=-1,document.body.classList.remove("disembarking"),document.body.classList.add("transfer-covered"),Wr("open",{destination:vp}),parent===window&&!window.SpaceBridge&&bp()}function bp(){xi=-1,document.body.classList.remove("transfer-covered","disembarking"),document.querySelectorAll("#flight-ui button").forEach(r=>r.disabled=!1),Xr(),Rh()}function Ko(r){Hs=r,lt.pause(r),cancelAnimationFrame(jo),clearTimeout(Mh),document.body.classList.remove("speaking"),r?Q("message").textContent=up:(qo=performance.now(),jo=requestAnimationFrame(Ph))}window.receiveSpaceCommand=r=>{r?.channel==="econectiva-space"&&(r.type==="configure"&&Array.isArray(r.destinations)&&(Q("management").hidden=r.management!==!0,Kt=r.destinations.filter(e=>wt.some(t=>t.id===e)),!Kt.includes(qe.id)&&Kt.length&&Ch(wt.find(e=>e.id===Kt[0])),Q("navigate").disabled=!Kt.length,Q("direct").disabled=!Kt.length,Xr()),r.type==="pause"&&(yh=!0,Ko(!0)),r.type==="resume"&&(yh=!1,bp(),Ko(document.hidden),r.returned&&(Fi("Retorno ao cockpit \xB7 posi\xE7\xE3o preservada"),Wn("Bem-vindo de volta. Mantive nossa posi\xE7\xE3o. Podemos continuar a explora\xE7\xE3o quando voc\xEA quiser."))))};window.addEventListener("message",r=>{if(!(r.source!==parent||r.origin!==location.origin))try{window.receiveSpaceCommand(JSON.parse(r.data))}catch{}});var Th,Eh,Vs=0,Tp=[];function eg(r){let e=new mt;e.position.set(...r.position),Jt.add(e);let t=document.createElement("canvas");t.width=t.height=64;let i=t.getContext("2d"),n=i.createRadialGradient(32,32,0,32,32,32);n.addColorStop(0,"rgba(255,255,255,1)"),n.addColorStop(.12,"rgba(255,255,255,.85)"),n.addColorStop(.35,"rgba(255,255,255,.22)"),n.addColorStop(1,"rgba(255,255,255,0)"),i.fillStyle=n,i.fillRect(0,0,64,64);let s=new Yi(t),a=[8645375,12362239,6474495,12845041],o=new ni(.028,10,8),c=new Et({color:15137535}),l=72,h=95,d=()=>(h=h*1664525+1013904223>>>0,h/4294967296);for(let p=0;p<18;p++){let u=new mt;e.add(u);let g=1.7+d()*1.15,m=.68+d()*.3,v=new Ie(a[p%a.length]),f=new Float32Array(l*3),_=new Float32Array(l*3);for(let P=0;P<l;P++){let O=Math.pow(1-P/(l-1),1.7)*.8;_.set([v.r*O,v.g*O,v.b*O],P*3)}let x=new Xe;x.setAttribute("position",new ft(f,3)),x.setAttribute("color",new ft(_,3));let S=new xr(x,new qi({vertexColors:!0,transparent:!0,opacity:.9,blending:fi,depthWrite:!1}));S.frustumCulled=!1,u.add(S);let T=new In(new pn({map:s,color:v,transparent:!0,opacity:.8,blending:fi,depthWrite:!1}));T.scale.setScalar(.4+d()*.18),u.add(T);let M=new Oe(o,c);u.add(M),Tp.push({plane:u,halo:T,core:M,geometry:x,positions:f,radius:g,eccentricity:m,phase:d()*Math.PI*2,speed:(.2+d()*.32)*(p%2?1:-1),tiltX:d()*Math.PI,tiltY:d()*Math.PI,tiltZ:d()*Math.PI,drift:(d()-.5)*.08,tail:.75+d()*.8})}Ep(0)}function Ep(r){Vs+=r;for(let e of Tp){let t=e.phase+Vs*e.speed;e.plane.rotation.set(e.tiltX+Math.sin(Vs*.06)*.12,e.tiltY+Vs*e.drift,e.tiltZ+Math.cos(Vs*.045)*.1);for(let i=0;i<72;i++){let n=t-Math.sign(e.speed)*i/71*e.tail;e.positions.set([Math.cos(n)*e.radius,Math.sin(n)*e.radius*e.eccentricity,Math.sin(n*3)*.06],i*3)}e.core.position.fromArray(e.positions),e.halo.position.copy(e.core.position),e.geometry.attributes.position.needsUpdate=!0}}function tg(){let r=new Sr(wt.map(t=>new w(...t.position)),!0,"centripetal"),e=new mt;e.name="research-red-thread";for(let[t,i,n]of[[.022,.95,16721989],[.065,.14,16716339],[.14,.035,16717376]]){let s=new Oe(new Ar(r,640,t,8,!0),new Et({color:n,transparent:!0,opacity:i,blending:fi,depthWrite:!1}));e.add(s)}Jt.add(e)}function ig(r,e){let t=new mt;t.position.set(...r.position);let i=new Pi({color:3162962,roughness:.38,metalness:.8}),n=new Et({color:r.color}),s=new Oe(new Ki(2,.18,12,80),i);s.rotation.x=.7,t.add(s);let a=new Oe(new Ki(2.03,.035,8,80),n);a.rotation.copy(s.rotation),t.add(a);let o=new Oe(new Ji(.55,.8,2.4,12),i);t.add(o);let c=new Oe(new Er(.45),n);c.position.y=1.6,t.add(c);for(let l=0;l<4;l++){let h=new Oe(new qt(3.8,.08,.14),i);h.rotation.y=l*Math.PI/2,t.add(h);let d=new Oe(new qt(1.1,.06,2.1),new Pi({color:1456460,metalness:.55,roughness:.35}));d.position.set(Math.cos(l*Math.PI/2)*3,0,Math.sin(l*Math.PI/2)*3),d.rotation.y=l*Math.PI/2,t.add(d);for(let p=0;p<4;p++){let u=new Oe(new qt(.025,.075,2),n);u.position.set(-.4+p*.26,0,0),d.add(u)}}if(e===2){let l=s.clone();l.rotation.y=1.3,t.add(l)}Jt.add(t),dp.push(t)}function ng(){Vn.add(Qe),Ht=new mt,Qe.add(Ht);let r=new Pi({color:1384748,metalness:.86,roughness:.3}),e=new Pi({color:198670,metalness:.6,roughness:.44}),t=new Pi({color:4216419,metalness:.9,roughness:.23}),i=new Et({color:5688028}),n=new Et({color:15181932});function s(m,v,f,_,x,S,T=r){let M=new Oe(new qt(m,v,f),T);return M.position.set(_,x,S),Ht.add(M),M}function a(m,v,f,_=r){let x=new w(...m),S=new w(...v),T=new Oe(new qt(f,x.distanceTo(S),f*.7),_);T.position.copy(x).add(S).multiplyScalar(.5),T.quaternion.setFromUnitVectors(new w(0,1,0),S.sub(x).normalize()),Ht.add(T)}function o(m,v,f=r){let _=new fn;m.forEach(([S,T],M)=>M?_.lineTo(S,T):_.moveTo(S,T)),_.closePath();let x=new Oe(new Tr(_,{depth:.055,bevelEnabled:!0,bevelThickness:.012,bevelSize:.012,bevelSegments:2}),f);x.position.z=v,Ht.add(x)}let c=new Et({color:7912923,transparent:!0,opacity:.025,depthWrite:!1,side:Vt});function l(m){let v=new fn;m.forEach(([_,x],S)=>S?v.lineTo(_,x):v.moveTo(_,x)),v.closePath();let f=new Oe(new wr(v),c);f.position.z=-1.55,Ht.add(f)}l([[-.6,.6],[.6,.6],[.28,-.2],[-.28,-.2]]);for(let m of[-1,1])l([[m*.6,.6],[m*.68,.6],[m*.64,-.42],[m*.28,-.2]]);s(6,2.1,.2,0,1.64,-1.5),s(6,2.4,.3,0,-1.53,-1.25);for(let m of[-1,1]){o([[m*.68,.64],[m*3,.64],[m*3,-2],[m*.64,-.48]],-1.53),a([m*.65,.64,-1.48],[m*.6,-.42,-1.12],.045),a([m*.635,.62,-1.445],[m*.585,-.4,-1.085],.006,t),o([[m*.3,-.19],[m*.95,-.4],[m*1.5,-.95],[m*.17,-.6]],-1.18,e),a([m*.35,.62,-1.42],[m*.14,-.2,-1.18],.065),a([m*.335,.6,-1.375],[m*.125,-.19,-1.135],.009,t),a([m*.34,.6,-1.36],[m*.13,-.19,-1.12],.003,i),a([m*.15,-.2,-1.1],[m*1.1,-.57,-.85],.045,t),a([m*.15,-.19,-1.075],[m*1.1,-.56,-.82],.005,i);for(let v=0;v<5;v++){let f=m*(.33-v*.038),_=.5-v*.15;s(.045,.016,.028,f,_,-1.32+v*.045,e);let x=new Oe(new ni(.006,8,6),t);x.position.set(f,_,-1.29+v*.045),Ht.add(x)}for(let[v,f,_]of[[.25,.25,-1.25],[.18,-.08,-1.16]]){let x=new Oe(new Ji(.026,.026,.07,16),t);x.rotation.x=Math.PI/2,x.position.set(m*v,f,_),Ht.add(x);let S=new Oe(new ni(.011,12,8),i);S.position.set(m*v,f,_+.04),Ht.add(S)}o([[m*.06,.59],[m*.53,.59],[m*.48,.48],[m*.06,.49]],-1.33,e),a([m*.07,.56,-1.25],[m*.47,.56,-1.25],.004,i);for(let v=0;v<7;v++)s(.019,.009,.008,m*(.1+v*.05),.525,-1.24,v===5?n:t),s(.022,.012,.018,m*(.38+v*.045),-.34-v*.022,-1,v%3?t:i)}o([[-.3,-.2],[.3,-.2],[.48,-.57],[-.48,-.57]],-1.12),a([-.28,-.21,-1.04],[.28,-.21,-1.04],.025,e);let h=new Oe(new Ji(.13,.17,.07,40),e);h.position.set(0,-.36,-.92),Ht.add(h);let d=new Oe(new Ki(.12,.003,6,64),i);d.rotation.x=Math.PI/2,d.position.set(0,-.32,-.92),Ht.add(d);let p=new Ir(8371164,1.8,4);p.position.set(0,.22,-.55),Qe.add(p);let u=new Ir(2198470,.55,3);u.position.set(0,-.27,-.65),Qe.add(u),Ht.scale.x=Qe.aspect;let g=new Xe;bh=new Float32Array(xp.length*6),g.setAttribute("position",new ft(bh,3)),kr=new Nn(g,new qi({color:10673151,transparent:!0,opacity:.3,depthWrite:!1})),kr.frustumCulled=!1,Qe.add(kr)}function rg(){try{Vn=new us,Qe=new Rt(48,innerWidth/innerHeight,.1,1200),Qe.position.copy(Jo(0)),Mn.copy(Jo(.35)),Qe.lookAt(Mn),Jt=new mt,Jt.visible=!1,Vn.add(Jt),Ft=new Go({antialias:devicePixelRatio<2,alpha:!0,powerPreference:"high-performance"}),Ft.setPixelRatio(Math.min(devicePixelRatio,innerWidth<760?1.25:1.7)),Ft.setSize(innerWidth,innerHeight),Ft.outputColorSpace=bt,Ft.toneMapping=Ns,Ft.toneMappingExposure=1.2,Q("universe").append(Ft.domElement),ng(),Vn.add(new Ps(7838655,1.15));let r=new Rs(15006207,3.2);r.position.set(-20,15,20),Vn.add(r);let e=new Xe,t=[],i=[],n=95,s=()=>(n=n*1664525+1013904223>>>0,n/4294967296);for(let c=0;c<2200;c++){let l=s()*Math.PI*2,h=s()*2-1,d=180+s()*200,p=Math.sqrt(1-h*h);t.push(d*p*Math.cos(l),d*h,d*p*Math.sin(l));let u=new Ie().setHSL(.53+s()*.13,.15+s()*.3,.45+s()*.5);i.push(u.r,u.g,u.b)}e.setAttribute("position",new Te(t,3)),e.setAttribute("color",new Te(i,3)),np=new fs(e,new yr({size:.8,vertexColors:!0,transparent:!0,opacity:.95})),Vn.add(np);let a=new Cs().load("earth.png",void 0,void 0,()=>Fi("Textura da Terra indispon\xEDvel \xB7 representa\xE7\xE3o simplificada"));a.colorSpace=bt,a.anisotropy=Math.min(8,Ft.capabilities.getMaxAnisotropy()),xn=new Oe(new ni(5,72,48),new Pi({map:a,roughness:.85,metalness:.05})),xn.position.set(...wt[0].position),xn.rotation.y=2.5,xn.rotation.z=.12,Jt.add(xn),vh=new Oe(new ni(5.12,64,40),new zt({uniforms:{glow:{value:new Ie(6668287)}},vertexShader:"varying vec3 n; varying vec3 v; void main(){vec4 p=modelViewMatrix*vec4(position,1.);n=normalize(normalMatrix*normal);v=normalize(-p.xyz);gl_Position=projectionMatrix*p;}",fragmentShader:"varying vec3 n;varying vec3 v;uniform vec3 glow;void main(){float f=pow(1.-max(dot(n,v),0.),3.);gl_FragColor=vec4(glow,f*.65);}",transparent:!0,depthWrite:!1,blending:fi})),vh.position.copy(xn.position),Jt.add(vh);let o=new Oe(new Ki(6.15,.009,5,160),new Et({color:7069389,transparent:!0,opacity:.3}));o.position.copy(xn.position),o.rotation.x=1.15,o.rotation.y=.22,Jt.add(o),wt.slice(1).forEach((c,l)=>{c.id==="agents"?eg(c):c.id==="observatory"?(Th=tp(c),Jt.add(Th.group)):c.id==="research"?(Eh=ip(c),Jt.add(Eh.group)):ig(c,l)}),tg(),Ft.domElement.addEventListener("webglcontextlost",c=>{c.preventDefault(),Wo=!1,Q("fallback").hidden=!1,Fi("Modo leve \xB7 contexto gr\xE1fico interrompido")}),Ft.domElement.addEventListener("webglcontextrestored",()=>{Wo=!0,Q("fallback").hidden=!0})}catch{Wo=!1,Q("fallback").hidden=!1,Fi("Modo leve \xB7 renderiza\xE7\xE3o 3D indispon\xEDvel")}}var sg=0,lp=!1;function Ph(r){if(Hs)return;let e=(r-qo)/1e3,t=Math.min(e||.016,.05);if(qo=r,Sh+=t,Jf.draw(t,_t,document.body.classList.contains("speaking")),!lp&&Ft&&e>.035&&++sg>150&&(Ft.setPixelRatio(1),lp=!0),xi>=0&&(xi+=t,xi>=(_t?.25:1.9)&&Qf()),gt){Ui+=t;let{charge:i,jump:n,settle:s}=Hn,a=Math.min(Math.max((Ui-i)/n,0),1),o=a<.5?4*a*a*a:1-Math.pow(-2*a+2,3)/2;Q("progress").style.width=`${Math.min(Ui/(i+n+s),1)*100}%`,Ui>=i&&en==="charge"&&(en="jump",lt.warpJump(),Q("flight-status").textContent="Salto conectivo \xB7 corredor aberto",Q("speed").textContent="SALTO",Fi("Salto iniciado \xB7 "+qe.name)),a>=1&&en==="jump"&&(en="settle",Q("flight-status").textContent="Desacelerando \xB7 aproxima\xE7\xE3o orbital",Q("speed").textContent="APROXIMA\xC7\xC3O");let c=en==="jump"?Math.sin(a*Math.PI):0;document.body.style.setProperty("--warp-strength",String(c)),lt.throttle(en==="charge"?Ui/i*.6:c),Qe&&(Qe.position.lerpVectors(pp,Yo,o),Mn.copy(Ah)),Ui>=i+n+s&&$o()}else if(Qe&&!_t&&xi<0){if(yn){Xo+=t*.018;let i=wt.find(s=>s.id===Pt),n=new w(...i.position);Qe.position.copy(n).add(new w(Math.sin(Xo)*i.radius*3.2-i.radius*.85,i.radius*.4,Math.cos(Xo)*i.radius*3.2)),Mn.copy(n).add(new w(...i.focusOffset??[-i.radius*.65,0,0]))}else xh+=t*.025,Qe.position.lerp(Jo(xh),1-Math.exp(-t*.4)),Mn.lerp(Jo(xh+.35),1-Math.exp(-t*.4)),Q("speed").textContent="CRUZEIRO";lt.throttle(.16)}if(kr&&!_t){let i=gt&&en==="jump"?Math.sin(Math.min((Ui-Hn.charge)/Hn.jump,1)*Math.PI):0;xp.forEach((n,s)=>{n.z+=t*(gt?15+i*180:5*n.speed),n.z>-2&&(n.z=-110);let a=.12+n.speed*.14+i*16;bh.set([n.x,n.y,n.z,n.x,n.y,n.z-a],s*6)}),kr.geometry.attributes.position.needsUpdate=!0,kr.material.opacity=gt?.35+i*.65:.3}if(Qe&&Wo){if(_t||(Ep(t),Th?.update(t),Eh?.update(t),xn.rotation.y+=t*.012,dp.forEach((i,n)=>{i.rotation.y+=t*(.025+n*.005)})),Qe.lookAt(Mn),gt){let i=Math.min(Ui/Hn.charge,1),n=i*i*i*(i*(i*6-15)+10);Qe.quaternion.slerpQuaternions(mp,Qe.quaternion.clone(),n)}Ft.render(Vn,Qe)}$f(),jo=requestAnimationFrame(Ph)}Q("start").onclick=async()=>{wh=!0,Q("flight-status").textContent="Rota cont\xEDnua \xB7 piloto autom\xE1tico",Q("reticle-label").textContent="PILOTO AUTOM\xC1TICO / ROTA CONT\xCDNUA",Q("welcome").hidden=!0,Q("flight-ui").hidden=!1,await lt.enable(Q("start-sound").checked),fp(),lt.arrival(),Fi("Expedi\xE7\xE3o iniciada \xB7 Iaret\xE9 online"),Wn("Ol\xE1, sou a Iaret\xE9, sua intelig\xEAncia de bordo. J\xE1 estamos em uma rota cont\xEDnua de explora\xE7\xE3o. Escolha a Terra ou uma esta\xE7\xE3o e eu preparo nosso salto."),Q("navigate").focus({preventScroll:!0})};Q("sound").onclick=async()=>{await lt.enable(!lt.enabled),Q("start-sound").checked=lt.enabled,fp(),lt.select()};Q("motion").onclick=()=>{_t=!_t,gp(),_t&&gt&&$o()};Q("navigate").onclick=yp;Q("skip").onclick=$o;Q("direct").onclick=Mp;Q("exit").onclick=()=>Wr("exit");Q("management").onclick=()=>{lt.select(),Wr("management")};Q("ask").onclick=Q("assistant-orb").onclick=()=>{lt.select(),Wr("assistant")};Q("journal-toggle").onclick=()=>{lt.select(),Q("journal").showModal(),Q("journal-toggle").setAttribute("aria-expanded","true")};Q("journal-close").onclick=()=>Q("journal").close();Q("journal").addEventListener("close",()=>{Q("journal-toggle").setAttribute("aria-expanded","false"),Q("journal-toggle").focus()});window.addEventListener("keydown",r=>{if(!(!wh||Hs||Q("journal").open||r.altKey||r.ctrlKey||r.metaKey)){if(r.key>="1"&&r.key<=String(wt.length)){let e=wt[Number(r.key)-1];Kt.includes(e.id)&&(r.preventDefault(),Ch(e))}r.key==="Enter"&&r.target===document.body&&(r.preventDefault(),yp())}});window.addEventListener("resize",()=>{Ft&&(Qe.aspect=innerWidth/innerHeight,Ht&&(Ht.scale.x=Qe.aspect),Qe.updateProjectionMatrix(),Ft.setSize(innerWidth,innerHeight))});document.addEventListener("visibilitychange",()=>Ko(document.hidden||yh));window.addEventListener("pagehide",()=>{Ko(!0),hp.disconnect(),lt.dispose(),Ft?.dispose()});gp();Xr();rg();qo=performance.now();jo=requestAnimationFrame(Ph);Wr("ready");})();
/**
 * @license
 * Copyright 2010-2026 Three.js Authors
 * SPDX-License-Identifier: MIT
 */
