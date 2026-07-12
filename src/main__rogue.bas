0 r=rnd(-ti):rem initialize random number generator
1 tl=0:br=1:x=0:y=1:rem for readability

2 dim rm(8,1,1):rem rooms in the nine (3x3) sectors
3 dim pr(8):rem flag for phantom rooms
4 dim cn(11,1):rem connections of rooms



10 rem *** main loop ***
11 seed=-int(rnd(1)*32768)-1:rem random seed
12 rem seed=-10518:rem -5232:rem -29968

15 r=rnd(seed):rem initialize random number generator

20 print "{clr}"
30 print "{down} set sectors":gosub 100
40 print "{down} create rooms":gosub 300
50 print "{down} set connections":gosub 800
55 print "{clr}"
60 gosub 1000:rem draw rooms
70 gosub 1500:rem draw corridors

75 print " seed: "seed
80 get a$
81 if a$=" " then 10
82 if a$=chr$(13) then 15
90 goto 80





100 rem *** create sectors ***
120 gs=5:rem minimum sector size (inner space)

130 x0=0:rem first sector column
140 x3=39:rem last sector column

160 y0=0:rem first sector row
170 y3=24:rem last sector row

180 xs=x0+gs+1:xe=x3-gs*3-1
190 x1=xs+int(rnd(1)*(xe-xs)):rem second sector column
200 xs=x1+gs+1:xe=x3-gs
210 x2=xs+int(rnd(1)*(xe-xs)):rem third sector column

220 ys=y0+gs+1:ye=y3-gs*3-1
230 y1=ys+int(rnd(1)*(ye-ys)):rem second sector row
240 ys=y1+gs+1:ye=y3-gs
250 y2=ys+int(rnd(1)*(ye-ys)):rem third sector row
260 return





300 rem *** create rooms in sectors ***

310 rm(0,tl,x)=x0+1:rm(0,br,x)=x1-1:rm(0,tl,y)=y0+1:rm(0,br,y)=y1-1
320 rm(1,tl,x)=x1+1:rm(1,br,x)=x2-1:rm(1,tl,y)=y0+1:rm(1,br,y)=y1-1
330 rm(2,tl,x)=x2+1:rm(2,br,x)=x3-1:rm(2,tl,y)=y0+1:rm(2,br,y)=y1-1
340 rm(3,tl,x)=x0+1:rm(3,br,x)=x1-1:rm(3,tl,y)=y1+1:rm(3,br,y)=y2-1
350 rm(4,tl,x)=x1+1:rm(4,br,x)=x2-1:rm(4,tl,y)=y1+1:rm(4,br,y)=y2-1
360 rm(5,tl,x)=x2+1:rm(5,br,x)=x3-1:rm(5,tl,y)=y1+1:rm(5,br,y)=y2-1
370 rm(6,tl,x)=x0+1:rm(6,br,x)=x1-1:rm(6,tl,y)=y2+1:rm(6,br,y)=y3-1
380 rm(7,tl,x)=x1+1:rm(7,br,x)=x2-1:rm(7,tl,y)=y2+1:rm(7,br,y)=y3-1
390 rm(8,tl,x)=x2+1:rm(8,br,x)=x3-1:rm(8,tl,y)=y2+1:rm(8,br,y)=y3-1


395 print " set phantom rooms"

400 for i=0 to 8:pr(i)=0:next i:rem reset removed room flags
410 nr=int(rnd(1)*4):rem number of rooms to remove (0-3)
420 if nr=0 then 600
430 for i=1 to nr
440 r=int(rnd(1)*9):rem random room index
450 if pr(r)=1 then 440
460 pr(r)=1
470 next i


500 print " shrink rooms"

600 gr=2:rem minimum inner gap between room walls

601 for i=0 to 8
602 if pr(i)=1 then 770

610 xs=rm(i,tl,x)
620 ys=rm(i,tl,y)
630 xe=rm(i,br,x)
640 ye=rm(i,br,y)
650 dx=xe-xs-gr*2
660 dy=ye-ys-gr*2
670 if dx>0 then xs=xs+int(rnd(1)*dx)
680 if dy>0 then ys=ys+int(rnd(1)*dy)
690 dx=xe-xs-gr
700 dy=ye-ys-gr
710 if dx>0 then xe=xe-int(rnd(1)*dx)
720 if dy>0 then ye=ye-int(rnd(1)*dy)
730 rm(i,tl,x)=xs
740 rm(i,tl,y)=ys
750 rm(i,br,x)=xe
760 rm(i,br,y)=ye

770 next i
780 return





800 rem *** connect rooms *** (temporarily all rooms connected)
810 cc=0:rem connection counter
820 for iy=0 to 2
830 for ix=0 to 2
840 cr=ix+iy*3:rem current room
850 if ix<2 then cn(cc,0)=cr:cn(cc,1)=cr+1:cc=cc+1
860 if iy<2 then cn(cc,0)=cr:cn(cc,1)=cr+3:cc=cc+1
870 next ix
880 next iy
890 return





1000 rem *** draw rooms ***
1010 for i=0 to 8

1015 if pr(i)=1 then poke 1024+rm(i,tl,x)+rm(i,tl,y)*40,127:goto 1170

1020 a0=rm(i,tl,y)*40:a1=rm(i,br,y)*40
1030 for j=rm(i,tl,x)+1 to rm(i,br,x)-1
1040 poke 1024+j+a0,67
1050 poke 1024+j+a1,67
1060 next j
1070 poke 1024+rm(i,tl,x)+a0,112
1080 poke 1024+rm(i,br,x)+a0,110

1090 for j=rm(i,tl,y)+1 to rm(i,br,y)-1
1100 a0=rm(i,tl,x)+j*40:a1=rm(i,br,x)+j*40
1110 poke 1024+a0,66
1120 poke 1024+a1,66
1130 rem for k=a0+1 to a1-1:poke 1024+k,46:next k:rem fill room with dots
1140 next j
1150 poke 1024+rm(i,tl,x)+rm(i,br,y)*40,109
1160 poke 1024+rm(i,br,x)+rm(i,br,y)*40,125

1170 next i
1180 return





1500 rem *** draw corridors ***
1510 for i=0 to 11
1520 a=cn(i,0):b=cn(i,1)
1530 if b-a=1 then gosub 7100:rem horizontal corridor
1540 if b-a=3 then gosub 7600:rem vertical corridor
1550 next i
1560 return



7100 rem horizontal corridor

7110 if pr(a)=1 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto 7160
7120 ax=rm(a,br,x)
7140 dy=rm(a,br,y)-rm(a,tl,y)-2
7145 ay=rm(a,tl,y)+1+int(rnd(1)*dy)
7150 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

7160 if pr(b)=1 then bx=rm(b,tl,x):by=rm(b,tl,y):goto 7200
7170 bx=rm(b,tl,x)
7180 dy=rm(b,br,y)-rm(b,tl,y)-2
7185 by=rm(b,tl,y)+1+int(rnd(1)*dy)
7190 a0=bx+by*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

7200 if ay=by then 7400

7210 rem horizontal z-shaped corridor
7230 mx=ax+1+int(rnd(1)*(bx-ax-2))

7240 for j=ax+1 to mx
7250 a0=j+ay*40:poke 1024+a0,102:rem corridor
7260 next j
7263 dy=sgn(by-ay)
7265 if ay+dy=by then 7300
7270 for j=ay+dy to by-dy step dy
7280 a0=mx+j*40:poke 1024+a0,35:rem corridor
7290 next j
7300 for j=mx to bx-1
7310 a0=j+by*40:poke 1024+a0,102:rem corridor
7320 next j
7330 return

7400 rem horizontal straight corridor
7420 for j=ax+1 to bx-1
7430 a0=j+ay*40:poke 1024+a0,102:rem corridor
7440 next j
7450 return



7600 rem vertical corridor

7610 if pr(a)=1 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto 7660
7620 ay=rm(a,br,y)
7640 dx=rm(a,br,x)-rm(a,tl,x)-2
7645 ax=rm(a,tl,x)+1+int(rnd(1)*dx)
7650 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

7660 if pr(b)=1 then bx=rm(b,tl,x):by=rm(b,tl,y):goto 7700
7670 by=rm(b,tl,y)
7680 dx=rm(b,br,x)-rm(b,tl,x)-2
7685 bx=rm(b,tl,x)+1+int(rnd(1)*dx)
7690 a0=bx+by*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

7700 if ax=bx then 7900

7710 rem vertical z-shaped corridor
7730 my=ay+1+int(rnd(1)*(by-ay-2))

7740 for j=ay+1 to my
7750 a0=ax+j*40:poke 1024+a0,102:rem corridor
7760 next j
7763 dx=sgn(bx-ax)
7765 if ax+dx=bx then 7800
7770 for j=ax+dx to bx-dx step dx
7780 a0=j+my*40:poke 1024+a0,35:rem corridor
7790 next j
7800 for j=my to by-1
7810 a0=bx+j*40:poke 1024+a0,102:rem corridor
7820 next j
7830 return

7900 rem vertical straight corridor
7920 for j=ay+1 to by-1
7930 a0=ax+j*40:poke 1024+a0,102:rem corridor
7940 next j
7950 return
