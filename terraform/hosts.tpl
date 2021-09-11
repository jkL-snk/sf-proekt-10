[app]
%{ for ip in vm2 ~}
${ip}
%{ endfor ~}
%{ for ip in vm3 ~}
${ip}
%{ endfor ~}

[database]
%{ for ip in vm1 ~}
${ip}
%{ endfor ~}
[database.vars]
postgresql_version=13
postgresql_data_directory="/var/lib/postgres/13/main"
[web]
%{ for ip in vm1 ~}
${ip}
%{ endfor ~}

