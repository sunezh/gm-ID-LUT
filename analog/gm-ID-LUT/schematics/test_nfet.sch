v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 0 30 0 120 {lab=GND}
N 0 0 0 30 {lab=GND}
N -120 90 -120 120 {lab=GND}
N -200 90 -200 120 {lab=GND}
N -120 -0 -120 30 {lab=#net1}
N -120 0 -40 0 {lab=#net1}
N -200 -40 0 -40 {lab=#net2}
N 0 -40 0 -30 {lab=#net2}
N -200 -40 -200 30 {lab=#net2}
C {devices/gnd.sym} 0 120 0 0 {name=l1 lab=GND}
C {sky130_fd_pr/nfet_01v8.sym} -20 0 0 0 {name=M1
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {devices/vsource.sym} -200 60 0 0 {name=VDS value=1 savecurrent=false}
C {devices/vsource.sym} -120 60 0 0 {name=VGS value=0.8 savecurrent=false}
C {devices/gnd.sym} -200 120 0 0 {name=l2 lab=GND}
C {devices/gnd.sym} -120 120 0 0 {name=l3 lab=GND}
C {sky130_fd_pr/corner.sym} 130 -20 0 0 {name=CORNER only_toplevel=false corner=tt}
C {devices/code_shown.sym} 270 -20 0 0 {name=s1 only_toplevel=false value=".control
op
print @m.xm1.msky130_fd_pr__nfet_01v8[gm]
print @m.xm1.msky130_fd_pr__nfet_01v8[id]
print @m.xm1.msky130_fd_pr__nfet_01v8[vth]
.endc
"}
