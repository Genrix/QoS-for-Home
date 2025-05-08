# ip/firewall/mangle/ export terse
# 2025-05-07 by RouterOS 7.18.2
/ip firewall mangle add action=change-ttl chain=forward new-ttl=set:64 out-interface=ether1 ttl=greater-than:64
/ip firewall mangle add action=jump chain=forward comment="Jump to sort new packets, conn-mark" connection-mark=no-mark jump-target=Conn-mark
/ip firewall mangle add action=passthrough chain=forward comment="Mark packets"
/ip firewall mangle add action=change-dscp chain=forward connection-mark=Download-conn new-dscp=8
/ip firewall mangle add action=mark-packet chain=forward connection-mark=Download-conn in-interface=ether1 new-packet-mark=Download-pkt-in passth
rough=no
/ip firewall mangle add action=mark-packet chain=forward connection-mark=Download-conn new-packet-mark=Download-pkt-out out-interface=ether1 pass
through=no
/ip firewall mangle add action=change-dscp chain=forward connection-mark=Browser-conn new-dscp=14
/ip firewall mangle add action=mark-packet chain=forward connection-mark=Browser-conn in-interface=ether1 new-packet-mark=Browser-pkt-in passthro
ugh=no
/ip firewall mangle add action=mark-packet chain=forward connection-mark=Browser-conn new-packet-mark=Browser-pkt-out out-interface=ether1 passth
rough=no
/ip firewall mangle add action=change-dscp chain=forward connection-mark=OBS-conn new-dscp=34
/ip firewall mangle add action=mark-packet chain=forward connection-mark=OBS-conn in-interface=ether1 new-packet-mark=OBS-pkt-in passthrough=no
/ip firewall mangle add action=mark-packet chain=forward connection-mark=OBS-conn new-packet-mark=OBS-pkt-out out-interface=ether1 passthrough=no
/ip firewall mangle add action=change-dscp chain=forward connection-mark=Games-conn new-dscp=46
/ip firewall mangle add action=mark-packet chain=forward connection-mark=Games-conn in-interface=ether1 new-packet-mark=Games-pkt-in passthrough=
no
/ip firewall mangle add action=mark-packet chain=forward connection-mark=Games-conn new-packet-mark=Games-pkt-out out-interface=ether1 passthroug
h=no
/ip firewall mangle add action=change-dscp chain=forward connection-mark=IPCALL-conn new-dscp=40
/ip firewall mangle add action=mark-packet chain=forward connection-mark=IPCALL-conn in-interface=ether1 new-packet-mark=IPCALL-pkt-in passthroug
h=no
/ip firewall mangle add action=mark-packet chain=forward connection-mark=IPCALL-conn new-packet-mark=IPCALL-pkt-out out-interface=ether1 passthro
ugh=no
/ip firewall mangle add action=change-dscp chain=forward connection-mark=NetServ-conn new-dscp=48
/ip firewall mangle add action=mark-packet chain=forward connection-mark=NetServ-conn in-interface=ether1 new-packet-mark=NetServ-pkt-in passthro
ugh=no
/ip firewall mangle add action=mark-packet chain=forward connection-mark=NetServ-conn new-packet-mark=NetServ-pkt-out out-interface=ether1 passth
rough=no
/ip firewall mangle add action=change-dscp chain=forward connection-mark=no-mark-conn new-dscp=0
/ip firewall mangle add action=mark-packet chain=forward connection-mark=no-mark-conn in-interface=ether1 new-packet-mark=no-mark-pkt-in passthro
ugh=no
/ip firewall mangle add action=mark-packet chain=forward connection-mark=no-mark-conn new-packet-mark=no-mark-pkt-out out-interface=ether1 passth
rough=no
/ip firewall mangle add action=passthrough chain=Conn-mark comment="Sort new packets, conn-mark"
/ip firewall mangle add action=mark-connection chain=Conn-mark dscp=8 new-connection-mark=Download-conn passthrough=no 
/ip firewall mangle add action=mark-connection chain=Conn-mark dscp=!46 new-connection-mark=Browser-conn passthrough=no port=80,443,8080 protocol
=tcp
/ip firewall mangle add action=mark-connection chain=Conn-mark dscp=!46 new-connection-mark=Browser-conn passthrough=no port=80,443,8080 protocol
=udp
/ip firewall mangle add action=mark-connection chain=Conn-mark dscp=34 new-connection-mark=OBS-conn passthrough=no port=1935 protocol=tcp
/ip firewall mangle add action=mark-connection chain=Conn-mark dscp=46 new-connection-mark=Games-conn passthrough=no
/ip firewall mangle add action=mark-connection chain=Conn-mark dscp=40 new-connection-mark=IPCALL-conn passthrough=no protocol=udp
/ip firewall mangle add action=mark-connection chain=Conn-mark new-connection-mark=NetServ-conn passthrough=no port=53,67,68,123,853,5222,5228,53
53 protocol=udp
/ip firewall mangle add action=mark-connection chain=Conn-mark new-connection-mark=NetServ-conn passthrough=no port=53,67,68,123,853,5222,5228,53
53 protocol=tcp
/ip firewall mangle add action=mark-connection chain=Conn-mark new-connection-mark=NetServ-conn passthrough=no protocol=icmp
/ip firewall mangle add action=mark-connection chain=Conn-mark new-connection-mark=Browser-conn passthrough=no protocol=udp
/ip firewall mangle add action=mark-connection chain=Conn-mark new-connection-mark=Browser-conn passthrough=no protocol=tcp
/ip firewall mangle add action=mark-connection chain=Conn-mark new-connection-mark=no-mark-conn passthrough=no
/ip firewall mangle add action=return chain=Conn-mark
/ip firewall mangle add action=mark-connection chain=input comment="NetServices Router as HW Device" connection-mark=no-mark new-connection-mark=
Router-conn passthrough=no
/ip firewall mangle add action=change-dscp chain=input connection-mark=Router-conn new-dscp=48
/ip firewall mangle add action=mark-packet chain=input connection-mark=Router-conn new-packet-mark=Router-pkt-in passthrough=no
/ip firewall mangle add action=mark-connection chain=output connection-mark=no-mark new-connection-mark=Router-conn passthrou
gh=no
/ip firewall mangle add action=change-dscp chain=output connection-mark=Router-conn new-dscp=48
/ip firewall mangle add action=mark-packet chain=output connection-mark=Router-conn new-packet-mark=Router-pkt-out passthrough=no
