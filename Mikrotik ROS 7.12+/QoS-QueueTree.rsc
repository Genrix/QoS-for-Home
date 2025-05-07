# queue/tree/ export terse
# 2025-05-07 by RouterOS 7.18.2
/queue tree add limit-at=90M max-limit=360M name=Down parent=global priority=1
/queue tree add bucket-size=0.05 limit-at=20M max-limit=350M name=Browser-in packet-mark=Browser-pkt-in parent=Down priority=4
/queue tree add limit-at=10M max-limit=360M name=Games-in packet-mark=Games-pkt-in parent=Down priority=1
/queue tree add limit-at=5M max-limit=350M name=Download-in packet-mark=Download-pkt-in parent=Down
/queue tree add limit-at=5M max-limit=360M name=nomark-in packet-mark=no-mark-pkt-in parent=Down
/queue tree add limit-at=90M max-limit=350M name=Upload parent=global priority=1
/queue tree add limit-at=10M max-limit=350M name=Games-out packet-mark=Games-pkt-out parent=Upload priority=1
/queue tree add limit-at=20M max-limit=200M name=Browser-out packet-mark=Browser-pkt-out parent=Upload priority=4
/queue tree add limit-at=5M max-limit=200M name=Download-out packet-mark=Download-pkt-out parent=Upload
/queue tree add limit-at=5M max-limit=350M name=nomark-out packet-mark=no-mark-pkt-out parent=Upload
/queue tree add limit-at=25M max-limit=360M name=OBS-in packet-mark=OBS-pkt-in parent=Down priority=2
/queue tree add limit-at=25M max-limit=350M name=OBS-out packet-mark=OBS-pkt-out parent=Upload priority=2
/queue tree add limit-at=2M max-limit=360M name=NetServ-in packet-mark=NetServ-pkt-in parent=Down priority=1
/queue tree add limit-at=2M max-limit=350M name=NetServ-out packet-mark=NetServ-pkt-out parent=Upload priority=1
/queue tree add limit-at=2M max-limit=360M name=Router-in packet-mark=Router-pkt-in parent=Down priority=1
/queue tree add limit-at=2M max-limit=350M name=Router-out packet-mark=Router-pkt-out parent=Upload priority=1
/queue tree add limit-at=10M max-limit=360M name=IPCALL-in packet-mark=IPCALL-pkt-in parent=Down priority=2
/queue tree add limit-at=10M max-limit=350M name=IPCALL-out packet-mark=IPCALL-pkt-out parent=Upload priority=2
