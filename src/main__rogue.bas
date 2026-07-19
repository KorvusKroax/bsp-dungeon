0 r=rnd(-ti):rem initialize random number generator
1 tl=0:br=1:x=0:y=1:rem for readability

2 dim rm(8,1,1):rem rooms in the nine (3x3) sectors
3 dim pr(8):rem flag for phantom rooms

4 dim cn(8):rem exit flags - 1=left, 2=right, 4=up, 8=down (bitwise)
5 dim vs(8):rem visited - 1=connected, 0=not connected
6 dim al(8):rem list of active (connected) rooms
7 dim ct(3):rem temporary list for current room's possible connections



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
70 gosub 1300:rem draw corridors

80 get a$
81 if a$=" " then 10
82 if a$=chr$(13) then print "{home} seed: "seed
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





800 rem *** connect rooms ***
810 for i=0 to 8:cn(i)=0:vs(i)=0:next i:rem reset connection flags

820 r=int(rnd(1)*9):rem select random starting room
830 vs(r)=1:al(0)=r:rem mark starting room as connected and add to list

840 for n=1 to 8

850 a=al(int(rnd(1)*n)):rem select random connected room
860 m=a-int(a/3)*3:rem determine column of room (0,1,2)

865 s=0:rem avialable connections counter
870 if m>0 then if vs(a-1)=0 then ct(s)=a-1:s=s+1:rem not the left column
880 if m<2 then if vs(a+1)=0 then ct(s)=a+1:s=s+1:rem not the right column
890 if a>2 then if vs(a-3)=0 then ct(s)=a-3:s=s+1:rem not the top row
900 if a<6 then if vs(a+3)=0 then ct(s)=a+3:s=s+1:rem not the bottom row
910 if s=0 then 850:rem no available connections, select another room

920 b=ct(int(rnd(1)*s)):rem select random available connection
930 if b=a-1 then cn(a)=cn(a)+1:cn(b)=cn(b)+2:rem left-right connection
940 if b=a+1 then cn(a)=cn(a)+2:cn(b)=cn(b)+1:rem right-left connection
950 if b=a-3 then cn(a)=cn(a)+4:cn(b)=cn(b)+8:rem up-down connection
960 if b=a+3 then cn(a)=cn(a)+8:cn(b)=cn(b)+4:rem down-up connection

970 vs(b)=1:al(n)=b:rem mark new room as connected and add to list
980 next n

990 return





1000 rem *** draw rooms ***
1010 for i=0 to 8

1015 if pr(i)=1 then poke 1024+rm(i,tl,x)+rm(i,tl,y)*40,102:goto 1170:rem phantom room

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
1130 for k=a0+1 to a1-1:poke 1024+k,46:next k:rem fill room with dots
1140 next j
1150 poke 1024+rm(i,tl,x)+rm(i,br,y)*40,109
1160 poke 1024+rm(i,br,x)+rm(i,br,y)*40,125

1170 next i
1180 return





1300 rem *** draw corridors ***
1310 for a=0 to 8
1315 rem if (cn(a) and 1)<>0 then b=a-1:gosub ...:rem open left
1320 if (cn(a) and 2)<>0 then b=a+1:gosub 2000:rem horizontal corridor
1325 rem if (cn(a) and 4)<>0 then b=a-3:gosub ...:rem open up
1330 if (cn(a) and 8)<>0 then b=a+3:gosub 2500:rem vertical corridor
1340 next a
1350 return



2000 rem horizontal corridor

2010 if pr(a)=1 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto 2060
2020 ax=rm(a,br,x)
2040 dy=rm(a,br,y)-rm(a,tl,y)-2
2045 ay=rm(a,tl,y)+1+int(rnd(1)*dy)
2050 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

2060 if pr(b)=1 then bx=rm(b,tl,x):by=rm(b,tl,y):goto 2100
2070 bx=rm(b,tl,x)
2080 dy=rm(b,br,y)-rm(b,tl,y)-2
2085 by=rm(b,tl,y)+1+int(rnd(1)*dy)
2090 a0=bx+by*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

2100 if ay=by then 2300

2110 rem horizontal z-shaped corridor
2130 mx=ax+1+int(rnd(1)*(bx-ax-2))

2140 for j=ax+1 to mx
2150 a0=j+ay*40:poke 1024+a0,102:rem corridor
2160 next j
2163 dy=sgn(by-ay)
2165 if ay+dy=by then 2200
2170 for j=ay+dy to by-dy step dy
2180 a0=mx+j*40:poke 1024+a0,102:rem corridor
2190 next j
2200 for j=mx to bx-1
2210 a0=j+by*40:poke 1024+a0,102:rem corridor
2220 next j
2230 return

2300 rem horizontal straight corridor
2320 for j=ax+1 to bx-1
2330 a0=j+ay*40:poke 1024+a0,102:rem corridor
2340 next j
2350 return



2500 rem vertical corridor

2510 if pr(a)=1 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto 2560
2520 ay=rm(a,br,y)
2540 dx=rm(a,br,x)-rm(a,tl,x)-2
2545 ax=rm(a,tl,x)+1+int(rnd(1)*dx)
2550 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

2560 if pr(b)=1 then bx=rm(b,tl,x):by=rm(b,tl,y):goto 2600
2570 by=rm(b,tl,y)
2580 dx=rm(b,br,x)-rm(b,tl,x)-2
2585 bx=rm(b,tl,x)+1+int(rnd(1)*dx)
2590 a0=bx+by*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

2600 if ax=bx then 2800

2610 rem vertical z-shaped corridor
2630 my=ay+1+int(rnd(1)*(by-ay-2))

2640 for j=ay+1 to my
2650 a0=ax+j*40:poke 1024+a0,102:rem corridor
2660 next j
2663 dx=sgn(bx-ax)
2665 if ax+dx=bx then 2700
2670 for j=ax+dx to bx-dx step dx
2680 a0=j+my*40:poke 1024+a0,102:rem corridor
2690 next j
2700 for j=my to by-1
2710 a0=bx+j*40:poke 1024+a0,102:rem corridor
2720 next j
2730 return

2800 rem vertical straight corridor
2820 for j=ay+1 to by-1
2830 a0=ax+j*40:poke 1024+a0,102:rem corridor
2840 next j
2850 return
