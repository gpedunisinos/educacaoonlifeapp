#!/usr/bin/env python3
"""Publish an already-built web release, retaining the previous document root.

Does not build, access databases, edit Apache or remove releases. Run only after
API compatibility, backup and local validation have been checked.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import shlex
import subprocess
import tarfile
import tempfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--build', type=Path, required=True)
parser.add_argument('--revision', required=True)
parser.add_argument('--host', default='ubuntu@54.94.142.29')
args = parser.parse_args()
if not re.fullmatch(r'[0-9a-f]{7,40}', args.revision):
    parser.error('Use a verified commit revision.')
root = args.build.resolve()
for name in ['index.html', 'main.dart.js', 'assets/assets/space/space.bundle.js']:
    if not (root / name).is_file():
        parser.error('Missing compiled asset: ' + name)
# Preserve the complete icon fonts already repaired in production. Dynamic icon
# selections in the shared widgets package are not all visible to tree shaking.
for relative, minimum in {
    'assets/fonts/MaterialIcons-Regular.otf': 1_000_000,
    'assets/packages/cupertino_icons/assets/CupertinoIcons.ttf': 200_000,
}.items():
    font = root / relative
    if not font.is_file() or font.stat().st_size < minimum:
        parser.error('Build with --no-tree-shake-icons to preserve the complete icon fonts: ' + relative)
for path in root.rglob('*'):
    if path.is_symlink() or path.name == '.env' or 'service_account' in path.name:
        parser.error('Refusing symlink or protected configuration in the build.')
release = 'integrations-' + datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + args.revision[:7]
with tempfile.TemporaryDirectory(prefix='onlife-web-release-') as temp:
    archive = Path(temp) / (release + '.tgz')
    with tarfile.open(archive, 'w:gz') as output:
        for path in sorted(root.iterdir()):
            output.add(path, arcname=path.name)
    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    remote_archive = '/tmp/' + archive.name
    subprocess.run(['scp', '-q', str(archive), args.host + ':' + remote_archive], check=True)
    remote = r'''
import hashlib,json,os,subprocess,sys
from pathlib import Path
p=json.load(sys.stdin)
archive=Path(p['archive'])
assert hashlib.sha256(archive.read_bytes()).hexdigest()==p['sha256']
base=Path('/var/www/onlife-releases');target=base/p['release'];web=Path('/var/www/usp_app')
assert not target.exists() and (web.is_dir() or web.is_symlink())
subprocess.run(['sudo','install','-d','-o','ubuntu','-g','ubuntu','-m','755',str(base)],check=True)
target.mkdir(mode=0o755)
subprocess.run(['tar','--no-same-owner','-xzf',str(archive),'-C',str(target)],check=True)
assert (target/'index.html').is_file() and (target/'main.dart.js').is_file()
previous=str(web.resolve()) if web.is_symlink() else str(base/('previous-'+p['release']))
if not web.is_symlink():
 subprocess.run(['sudo','mv',str(web),previous],check=True)
link=Path('/var/www/usp_app.next-'+p['release'])
subprocess.run(['sudo','ln','-s',str(target),str(link)],check=True)
subprocess.run(['sudo','mv','-Tf',str(link),str(web)],check=True)
manifest={'revision':p['revision'],'archive_sha256':p['sha256'],'previous_root':previous,'release':str(target)}
private=Path('/home/ubuntu/backups/onlife-web-releases')
private.mkdir(parents=True,exist_ok=True,mode=0o700)
record=private/(p['release']+'.json')
record.write_text(json.dumps(manifest,indent=2));record.chmod(0o600)
(target/'onlife-release.json').write_text(json.dumps({'revision':p['revision'],'archive_sha256':p['sha256']},indent=2))
for url in ['https://web.uniusp.gpedu.com.br/','https://plataforma.atopos.spotec.app/']:
 result=subprocess.run(['curl','-fSs','-o','/dev/null',url],capture_output=True)
 if result.returncode:
  subprocess.run(['sudo','ln','-sfn',previous,str(web)],check=True)
  raise SystemExit('Frontend check failed; previous document root restored, both releases retained')
print(json.dumps(manifest))
'''
    payload = {'archive': remote_archive, 'sha256': digest, 'release': release, 'revision': args.revision}
    subprocess.run(['ssh', '-o', 'BatchMode=yes', args.host, 'python3 -c ' + shlex.quote(remote)],
                   input=json.dumps(payload), text=True, check=True)
