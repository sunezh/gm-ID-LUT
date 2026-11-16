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
N 280 -50 280 20 {lab=noise}
C {sky130_fd_pr/nfet_01v8.sym} 10 0 0 0 {name=M1
L=\{length\}
W=\{width\}
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
C {sky130_fd_pr/corner.sym} -210 220 0 0 {name=CORNER only_toplevel=false corner=tt}
C {devices/code_shown.sym} -60 230 0 0 {name=s1 only_toplevel=false value="* Parameters
.param VDS = 0.9
.param VGS = 0.8
.param VSB = 0
.param length = 0.15
.param width = 5
.temp 27

.control
shell rm -f sweep_nfet_01v8.txt
set appendwrite
set wr_singlescale
set wr_vecnames
compose vgs_vec start=0 stop=1.8 step=0.45
compose L_vec values 0.15 0.16

foreach Lval $&L_vec
    echo "L=" $Lval
    alterparam length = $Lval
    reset

    foreach vg $&vgs_vec
        alter VGS dc = $vg
        op
        wrdata sweep_nfet_01v8.txt all
        unset wr_vecnames
        destroy all
    end
end

unset appendwrite
alterparam length = 0.15
reset
op
show
write sweep_nfet_01v8.raw

* noise v(noise) VGS lin 1 1 1
.endc
"}
C {devices/ccvs.sym} 280 50 0 0 {name=H1 vnam=VDS value=1}
C {devices/lab_wire.sym} -80 -50 0 0 {name=p2 sig_type=std_logic lab=d}
C {devices/lab_wire.sym} -60 0 0 0 {name=p3 sig_type=std_logic lab=g}
C {devices/lab_wire.sym} 160 0 0 0 {name=p4 sig_type=std_logic lab=b}
C {devices/lab_wire.sym} 280 -50 0 0 {name=p1 sig_type=std_logic lab=noise}
C {devices/code_shown.sym} 420 230 0 0 {name=s2 only_toplevel=false value="* Saves
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
.save @m.xm1.msky130_fd_pr__nfet_01v8[l]
.save @VGS[dc]
.save @VDS[dc]
.save @VSB[dc]
.save g d b noise
"}
C {devices/launcher.sym} 460 -30 0 0 {name=h2
descr="load op + annotate"
tclcommand="xschem raw_read $netlist_dir/sweep_nfet_01v8.raw;
set show_hidden_texts 1;
xschem annotate_op;"}
C {devices/ngspice_get_value.sym} 880 -40 0 0 {name=r1 node="v(@m.xm1.msky130_fd_pr__nfet_01v8[vth])"
descr="vth="}
C {devices/ngspice_get_expr.sym} 880 10 0 0 {name=r3 node="[format %.4g [expr [ngspice::get_node \{@m.xm1.msky130_fd_pr__nfet_01v8[gm]\}] / [ngspice::get_node \{i(@m.xm1.msky130_fd_pr__nfet_01v8[id])\}]]]"
descr="gm/ID="}
C {devices/ngspice_get_value.sym} 760 -40 0 0 {name=r2 node="@m.xm1.msky130_fd_pr__nfet_01v8[cgg]"
descr="cgg="}
C {devices/ngspice_get_value.sym} 760 10 0 0 {name=r4 node="@m.xm1.msky130_fd_pr__nfet_01v8[capbd]"
descr="capbd="}
C {devices/ngspice_get_value.sym} 760 60 0 0 {name=r5 node="@m.xm1.msky130_fd_pr__nfet_01v8[capbs]"
descr="capbs="}
C {devices/ngspice_get_value.sym} 760 110 0 0 {name=r6 node="@m.xm1.msky130_fd_pr__nfet_01v8[cgdo]"
descr="cgdo="}
C {devices/ngspice_get_value.sym} 760 160 0 0 {name=r7 node="@m.xm1.msky130_fd_pr__nfet_01v8[cgso]"
descr="cgso="}
C {devices/ngspice_get_expr.sym} 880 60 0 0 {name=r8 node="[format %.4g [expr [ngspice::get_node \{@m.xm1.msky130_fd_pr__nfet_01v8[gm]\}] / [ngspice::get_node \{@m.xm1.msky130_fd_pr__nfet_01v8[gds]\}]]]"
descr="gm/gds="}
C {devices/ngspice_get_expr.sym} 880 110 0 0 {name=r9 node="[format %.1f [expr [ngspice::get_node \{@m.xm1.msky130_fd_pr__nfet_01v8[gm]\}] / ([ngspice::get_node \{@m.xm1.msky130_fd_pr__nfet_01v8[cgg]\}] + [ngspice::get_node \{@m.xm1.msky130_fd_pr__nfet_01v8[cgso]\}] + [ngspice::get_node \{@m.xm1.msky130_fd_pr__nfet_01v8[cgdo]\}] + [ngspice::get_node \{@m.xm1.msky130_fd_pr__nfet_01v8[cgbo]\}]) / 6.283 / 1e9]]"
descr="fT (GHz)="}
