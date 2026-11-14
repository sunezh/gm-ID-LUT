v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 30 30 30 110 {lab=GND}
N -120 0 -10 0 {lab=g}
N -200 -50 30 -50 {lab=d}
N 30 0 160 0 {lab=b}
N 30 -50 30 -30 {lab=d}
N -200 -50 -200 20 {lab=d}
N -120 0 -120 20 {lab=g}
N 160 0 160 20 {lab=b}
N 280 80 280 110 {lab=GND}
N 30 110 280 110 {lab=GND}
N 160 80 160 110 {lab=GND}
N -200 110 30 110 {lab=GND}
N -200 80 -200 110 {lab=GND}
N -120 80 -120 110 {lab=GND}
N 280 0 280 20 {lab=noise}
C {sky130_fd_pr/nfet_01v8.sym} 10 0 0 0 {name=M1
L=\{length\}
W=5
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
C {devices/vsource.sym} -200 50 0 0 {name=VDS value=\{VDS\} savecurrent=false}
C {devices/vsource.sym} -120 50 0 0 {name=VGS value="dc \{VGS\} ac 1" savecurrent=false}
C {devices/gnd.sym} 30 110 0 0 {name=l1 lab=GND}
C {devices/vsource.sym} 160 50 2 1 {name=VSB value=\{VSB\} savecurrent=false}
C {sky130_fd_pr/corner.sym} -210 190 0 0 {name=CORNER only_toplevel=false corner=tt}
C {devices/code_shown.sym} -60 200 0 0 {name=s1 only_toplevel=false value="* Parameters
.param VDS = 1
.param VGS = 0.8
.param VSB = 0
.param length = 0.15
.temp 27

* Saves
.save @m.xm1.msky130_fd_pr__nfet_01v8[id]
.save @m.xm1.msky130_fd_pr__nfet_01v8[gm]
.save @m.xm1.msky130_fd_pr__nfet_01v8[gds]
.save @m.xm1.msky130_fd_pr__nfet_01v8[gmbs]
.save @m.xm1.msky130_fd_pr__nfet_01v8[vth]
.save @m.xm1.msky130_fd_pr__nfet_01v8[vdsat]
.save @m.xm1.msky130_fd_pr__nfet_01v8[cgg]
.save @m.xm1.msky130_fd_pr__nfet_01v8[cgs]
.save @m.xm1.msky130_fd_pr__nfet_01v8[cgd]
.save @m.xm1.msky130_fd_pr__nfet_01v8[cgb]
.save @m.xm1.msky130_fd_pr__nfet_01v8[cdd]
.save @m.xm1.msky130_fd_pr__nfet_01v8[css]
.save @m.xm1.msky130_fd_pr__nfet_01v8[cgso]
.save @m.xm1.msky130_fd_pr__nfet_01v8[cgdo]
.save @m.xm1.msky130_fd_pr__nfet_01v8[cgbo]
.save @m.xm1.msky130_fd_pr__nfet_01v8[capbd]
.save @m.xm1.msky130_fd_pr__nfet_01v8[capbs]
.save all

.control
op

* noise v(noise) VGS lin 1 1 1
.endc
"}
C {devices/ccvs.sym} 280 50 0 0 {name=H1 vnam=VDS value=1}
C {devices/lab_wire.sym} -80 -50 0 0 {name=p2 sig_type=std_logic lab=d}
C {devices/lab_wire.sym} -60 0 0 0 {name=p3 sig_type=std_logic lab=g}
C {devices/lab_wire.sym} 160 0 0 0 {name=p4 sig_type=std_logic lab=b}
C {devices/lab_wire.sym} 280 0 0 0 {name=p1 sig_type=std_logic lab=noise}
