PDK's found at: home/sunezh/.volare
Transistor instance name: m.xm1.msky130_fd_pr__nfet_01v8

## Bin Edges in um
W: 0.36, 0.39, 0.42, 0.52, 0.54, 0.55, 0.58, 0.60, 0.61, 0.64, 0.65, 0.74, 0.84, 1, 1.26, 1.68, 2, 3, 5, 7f
L: 0.15, 0.18, 0.25, 0.5, 1, 2, 4, 8, 20

## Setup
Chose W = 5 (characterized width that is wide enough to avoid narrow width effects), source grounded, have L as a .param

Using CCVS -> .noise measures voltage so no conversion (would need resistor with own noise if CCCS used)
- All ngspice controlled sources (ngspice prefixes them as E (VCVS), F (CCCS), G (VCCS), H(CCVS)) are ideal and noiseless 

#### ngspice show m.xm1.msky130_fd_pr__nfet_01v8

ngspice 2 -> op
Doing analysis at TEMP = 27.000000 and TNOM = 27.000000

Using SPARSE 1.3 as Direct Linear Solver

No. of Data Rows : 1
ngspice 3 -> show m.xm1.msky130_fd_pr__nfet_01v8
 BSIM4v5: Berkeley Short Channel IGFET Model-4
     device m.xm1.msky130_fd_pr__
      model xm1:sky130_fd_pr__nfe
          l               1.5e-07
          w                 5e-06
          m                     1
         nf                     1
         sa                     0
         sb                     0
         sd                     0
        sca                     0
        scb                     0
        scc                     0
         sc                     0
        min                     0
         ad              1.45e-12
         as              1.45e-12
         pd             1.058e-05
         ps             1.058e-05
        nrd                 0.058
        nrs                 0.058
        off                     0
       rbdb                    50
       rbsb                    50
       rbpb                    50
       rbps                    50
       rbpd                    50
     delvto                     0
      mulu0                     1
        xgw                     0
      ngcon                     1
   trnqsmod                     0
   acnqsmod                     0
   rbodymod                     1
   rgatemod                     0
     geomod                     0
    rgeomod                     0
       gmbs           0.000179107
         gm            0.00113669
        gds           5.20395e-05
      vdsat              0.100063
        vth              0.707631
         id           9.65674e-05
        ibd          -1.00507e-12
        ibs          -6.44992e-18
        gbd                 1e-12
        gbs           1.15162e-12
       isub           1.97515e-11
      igidl                     0
      igisl                     0
        igs                     0
        igd                     0
        igb                     0
       igcs                     0
       igcd                     0
        vbs           -5.6004e-06
        vgs              0.799994
        vds              0.999989
        cgg           3.70188e-15
        cgs          -2.68144e-15
        cgd           5.51982e-18
        cbg          -9.27101e-16
        cbd           1.14277e-18
        cbs          -6.72198e-16
        cdg          -1.11057e-15
        cdd          -2.31763e-18
        cds           1.34195e-15
        csg          -1.66421e-15
        csd          -4.34496e-18
        css           2.01169e-15
        cgb          -1.02595e-15
        cdb          -2.29066e-16
        csb          -3.43138e-16
        cbb           1.59816e-15
      capbd           2.20344e-15
      capbs           3.33415e-15
         qg           4.24971e-15
         qb          -3.39954e-15
         qd          -3.40226e-16
         qs          -5.09937e-16
       qinv                     0
       qdef                     0
       gcrg                     0
       gtau                     0
    vgsteff             0.0843726
     vdseff             0.0989643
       cgso           1.23157e-15
       cgdo           1.23157e-15
       cgbo           1.30242e-20
       weff           4.95628e-06
       leff           1.26136e-07

Values for the table:
| Group | Values |
| --- | --- |
| DC/small-signal | id, gm, gds, gmbs, vth, vdsat (drain saturation voltage) |
| Intrinsic caps | cgg (total intrinsic gate capacitance), cgs, cgd, cgb, cdd, css (last two are diagonal self capacitances) |
| Overlap caps | cgso, cgdo, cgbo (these overlap capacitances are not included in cgg, cgs, cgd) |
| Junction caps | capbd, capbs | 

## sweep_nfet_01v8 bench
Device: XM1 = sky130_fd_pr__nfet_01v8, W=5u fixed, L={length}
Transistor source: Grounded 
Sources:
- VGS: Goes to gate, value of dc {VGS} ac 1 (noise input reference)
- VDS: Goes to drain and is also used to sense drain current, value of dc {VDS}
- VSB: + at GND, - at bulk. So bulk voltage is -VSB (sweep VSB >= 0)
- H1: CCVS that senses i(VDS) with a gain of 1

Sign bookeeping: i(VDS) = v(noise) = -ID
Sweep: L via alterparam length + reset (re-picks model bin). VGS/VDS/VSB using alter.

Parameter defaults (w = 5):
.param VDS = 1
.param VGS = 0.8
.param VSB = 0
.param length = 0.15
.temp 27

Bench defaults (using above params)
id = 96.6 µA
gm = 1.137 mS
vth = 0.708 V
gm/ID = 11.8 S/A


compose vgs_vec start=0 stop=1.8 step=0.025
compose L_vec values 0.15 0.16 0.17 0.18 0.19 
+ 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4

[:, 0] gives an index, a 1D shape of (x,)
[:, :1] gives a slice, a 2D shape of (x, 1)