#!/usr/bin/env python3
import json, os, sys
from pathlib import Path

tf = json.load(open(sys.argv[1]))
bastion = tf["edge_gateway_public_ip"]["value"]
backend = tf["backend_private_ip"]["value"]
frontend = tf["frontend_private_ip"]["value"]
workspace = os.environ["WORKSPACE"]

ssh_tpl = Path("ssh_config.tpl.j2").read_text()
ssh_out = ssh_tpl.replace("{{ bastion_ip }}", bastion)\
                 .replace("{{ backend_ip }}", backend)\
                 .replace("{{ frontend_ip }}", frontend)\
                 .replace("{{ workspace }}", workspace)
Path(f"{workspace}/.ssh").mkdir(parents=True, exist_ok=True)
Path(f"{workspace}/.ssh/config").write_text(ssh_out)

inv_tpl = Path("inventory.tpl.j2").read_text()
Path(f"{workspace}/inventory.ini").write_text(inv_tpl)
