Europe/Moscow:
    timezone.system

selinux:
    cmd.run:
        - name: setenforce 0

epel-release:
  pkg:
    - installed

update_pkgs:
    pkg.uptodate:
        - refresh: true
        - require:
           - pkg: epel-release

# install_pkgs:
#     pkg.installed:
#         - pkgs:
#             - policycoreutils-python-utils
#         - require:
#             - pkg: epel-release

policycoreutils-python-utils:
    pkg.installed

disabled:
    selinux.mode

