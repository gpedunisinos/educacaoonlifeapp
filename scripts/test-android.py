#!/usr/bin/env python3
"""Run native integration tests and capture the emulator at audited milestones.

Requires a running isolated API (port 8082) and a protected dart-define JSON.
Credentials never appear in commands, report metadata or console summaries.
"""
import argparse,json,os,re,subprocess,time
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--defines',type=Path,required=True)
p.add_argument('--device',default='emulator-5554')
p.add_argument('--test',default='integration_test/android_audit_test.dart')
p.add_argument('--output',type=Path,default=Path('/tmp/onlife-android-audit'))
a=p.parse_args()
settings=json.loads(a.defines.read_text())
if settings.get('API_HOST') not in ('10.0.2.2','127.0.0.1') or str(settings.get('API_PORT'))!='8082' or str(settings.get('NATIVE_AUDIT')).lower()!='true':p.error('Only the isolated Android validation API is supported')
if not re.fullmatch(r'emulator-\d+',a.device):p.error('Use an emulator, never an unapproved physical device')
a.output.mkdir(parents=True,exist_ok=True,mode=0o700)
adb=Path(os.environ.get('ANDROID_HOME',str(Path.home()/'Android/Sdk')))/'platform-tools/adb'
subprocess.run([str(adb),'-s',a.device,'reverse','tcp:8082','tcp:8082'],check=True,capture_output=True)
cmd=['flutter','test',a.test,'-d',a.device,'--dart-define-from-file='+str(a.defines),'--reporter','expanded']
started=time.time();captures=[];milestones=[]
secrets=[str(settings[k]) for k in settings if any(word in k.lower() for word in ('password','token','secret')) and settings[k]]
with (a.output/'test.log').open('w') as log:
 process=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,bufsize=1)
 for line in process.stdout:
  for secret in secrets:line=line.replace(secret,'[REDACTED]')
  log.write(line);log.flush()
  if 'AUDIT ' in line:milestones.append(line.strip());print(line.strip(),flush=True)
  capture=re.search(r'AUDIT_CAPTURE ([a-zA-Z0-9_-]+)',line)
  if capture:
   name=capture[1]+'.png'
   try:
    image=subprocess.run([str(adb),'-s',a.device,'exec-out','screencap','-p'],capture_output=True,timeout=12,check=True).stdout
    if not image.startswith(b'\x89PNG'):raise ValueError('Invalid screenshot')
    (a.output/name).write_bytes(image);captures.append(name)
   except Exception:print('Capture unavailable at '+capture[1],flush=True)
 result=process.wait()
report={'test':a.test,'device':a.device,'exit_code':result,'seconds':round(time.time()-started,1),'milestones':milestones,'captures':captures}
(a.output/'report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2))
print(json.dumps({'exit_code':result,'report':str(a.output/'report.json'),'captures':len(captures)}),flush=True)
raise SystemExit(result)
