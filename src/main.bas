
0 r=rnd(-ti):rem initialize random number generator

9 tl=0:br=1:x=0:y=1:rem for readability

10 dim rm(100,1,1):rem room (index), (0=top left, 1=bottom right), (0=x, 1=y)
30 dim cl(100,1):rem child indexes left-right or top-bottom (0 is main room)
40 dim cn(100,1):rem connections of rooms (indexes)

60 mp=10:rem minimum partition size (walls included)
70 gp=3:rem minimum inner gap between walls (odd numbers only)



100 rem *** main loop ***
101 seed=-int(rnd(1)*32768)-1:rem random seed
102 rem seed=-6551
103 r=rnd(seed):rem initialize random number generator
105 gosub 500: rem create partitions
110 gosub 1500:rem shrink partitions to rooms
120 gosub 2000:rem set connections
130 print"{clr}"
140 gosub 3000:rem draw rooms
150 gosub 3500:rem draw corridors
155 print " seed: ";seed
160 get a$:if a$<>" " then 160
170 goto 100





500 rem *** binary space partitioning ***
510 rc=0:rem room count
520 rm(rc,tl,x)=0:rm(rc,tl,y)=0
530 rm(rc,br,x)=39:rm(rc,br,y)=24
540 cl(rc,0)=-1:cl(rc,1)=-1
550 i=0:rem current room index
560 dx=rm(i,br,x)-rm(i,tl,x)
570 dy=rm(i,br,y)-rm(i,tl,y)
580 if rnd(1)<0.5 then 600
590 if dx>(mp-1)*2 then gosub 1100:goto 620
600 if dy>(mp-1)*2 then gosub 1300:goto 620
610 if dx>(mp-1)*2 then gosub 1100
620 print"{clr}{down} partitions:";rc+1
630 i=i+1
640 if i<=rc then 560
650 return

1100 rem *** split vertical ***
1110 x1=rm(i,tl,x)
1120 x2=rm(i,br,x)
1130 sp=x1+(mp-1)+int(rnd(1)*(x2-x1-(mp-1)*2+1))
1140 rem left room
1150 rc=rc+1
1160 rm(rc,tl,x)=x1:rm(rc,br,x)=sp
1170 rm(rc,tl,y)=rm(i,tl,y):rm(rc,br,y)=rm(i,br,y)
1180 cl(rc,0)=-1:cl(rc,1)=-1
1190 cl(i,0)=rc
1210 rem right room
1220 rc=rc+1
1230 rm(rc,tl,x)=sp:rm(rc,br,x)=x2
1240 rm(rc,tl,y)=rm(i,tl,y):rm(rc,br,y)=rm(i,br,y)
1250 cl(rc,0)=-1:cl(rc,1)=-1
1260 cl(i,1)=rc
1280 return

1300 rem *** split horizontal ***
1310 y1=rm(i,tl,y)
1320 y2=rm(i,br,y)
1330 sp=y1+(mp-1)+int(rnd(1)*(y2-y1-(mp-1)*2+1))
1340 rem top room
1350 rc=rc+1
1360 rm(rc,tl,x)=rm(i,tl,x):rm(rc,br,x)=rm(i,br,x)
1370 rm(rc,tl,y)=y1:rm(rc,br,y)=sp
1380 cl(rc,0)=-1:cl(rc,1)=-1
1390 cl(i,0)=rc
1410 rem bottom room
1420 rc=rc+1
1430 rm(rc,tl,x)=rm(i,tl,x):rm(rc,br,x)=rm(i,br,x)
1440 rm(rc,tl,y)=sp:rm(rc,br,y)=y2
1455 cl(rc,0)=-1:cl(rc,1)=-1
1460 cl(i,1)=rc
1480 return





1500 rem *** shrink partition to room ***
1501 print"{clr}{down} shrinking partitions to rooms..."
1502 for i=0 to rc
1505 if cl(i,0)>-1 then 1665:rem skip non-leaf partitions
1510 xs=rm(i,tl,x)+1
1520 ys=rm(i,tl,y)+1
1530 xe=rm(i,br,x)-1
1540 ye=rm(i,br,y)-1

1550 dx=xe-xs-gp
1560 dy=ye-ys-gp
1570 if dx>0 then xs=xs+int(rnd(1)*dx)
1580 if dy>0 then ys=ys+int(rnd(1)*dy)

1590 dx=xe-xs-gp
1600 dy=ye-ys-gp
1610 if dx>0 then xe=xe-int(rnd(1)*dx)
1620 if dy>0 then ye=ye-int(rnd(1)*dy)

1630 rm(i,tl,x)=xs and 254
1640 rm(i,tl,y)=ys and 254
1650 rm(i,br,x)=xe and 254
1660 rm(i,br,y)=ye and 254
1665 next i
1670 return





2000 rem *** connect rooms ***
2003 print"{clr}{down} setting connections..."
2005 cc=0:rem connection count
2010 for i=0 to rc
2020 if cl(i,0)=-1 then 2090
2030 a=cl(i,0):b=cl(i,1)
2040 n=a:gosub 2300:cn(cc,0)=n
2050 n=b:gosub 2300:cn(cc,1)=n
2060 cc=cc+1
2090 next i
2110 return

2300 if cl(n,0)>-1 then n=cl(n,int(rnd(1)*2)):goto 2300
2310 return





3000 rem *** draw rooms ***
3020 for i=0 to rc
3030 if cl(i,0)>-1 then 3200:rem skip non-leaf partitions
3070 a0=rm(i,tl,y)*40:a1=rm(i,br,y)*40
3080 for j=rm(i,tl,x) to rm(i,br,x)
3090 poke 1024+j+a0,102:poke 55296+j+a0,1
3100 poke 1024+j+a1,102:poke 55296+j+a1,1
3110 next j
3130 for j=rm(i,tl,y)+1 to rm(i,br,y)-1
3140 a0=rm(i,tl,x)+j*40:a1=rm(i,br,x)+j*40
3150 poke 1024+a0,102:poke 55296+a0,1
3155 rem fill room with dots
3160 for k=a0+1 to a1-1
3165 poke 1024+k,46
3168 next k
3170 poke 1024+a1,102:poke 55296+a1,1
3180 next j
3200 next i
3210 return





3500 rem *** draw corridors ***
3510 for i=0 to cc-1
3520 gosub 3600
3530 next i
3540 return

3600 rem draw corridor between two rooms
3610 a=cn(i,0):b=cn(i,1)
3630 if rm(a,br,x)>=rm(b,tl,x) and rm(a,tl,x)<=rm(b,br,x) then 4000:rem xoverlap
3640 if rm(a,br,y)>=rm(b,tl,y) and rm(a,tl,y)<=rm(b,br,y) then 4500:rem yoverlap
3650 rem no any overlap, maybe it can be l corridor
3660 if rnd(1)<0.5 then 4500:rem vertical or horizontal corridor



4000 rem vertical corridor
4010 if rm(a,br,y)<rm(b,tl,y) then ay=rm(a,br,y):by=rm(b,tl,y):goto 4030
4020 ay=rm(a,tl,y):by=rm(b,br,y)
4030 dx=rm(a,br,x)-rm(a,tl,x)-2
4040 ax=rm(a,tl,x)+int(rnd(1)*dx) or 1
4050 dx=rm(b,br,x)-rm(b,tl,x)-2
4060 bx=rm(b,tl,x)+int(rnd(1)*dx) or 1
4070 rem doors
4080 a0=ax+ay*40:poke 1024+a0,43:poke 55296+a0,10
4085 a0=bx+by*40:poke 1024+a0,43:poke 55296+a0,10
4090 if ax<>bx then 4300: rem vertical z corridor

4200 rem vertical straight corridor
4210 if ay<by then sy=ay:ey=by:goto 4230
4220 sy=by:ey=ay
4230 for j=sy+1 to ey-1
4240 a0=ax+j*40:gosub 5000
4250 next j
4280 return

4300 rem vertical z corridor
4310 dx=sgn(bx-ax)
4320 dy=sgn(by-ay)
4340 my=(ay+dy+int(rnd(1)*abs(by-ay-2*dy))*dy) or 1
4360 for j=ay+dy to my-dy step dy
4370 a0=ax+j*40:gosub 5000
4380 next j
4390 for j=ax to bx step dx
4400 a0=j+my*40:gosub 5000
4410 next j
4420 for j=my+dy to by-dy step dy
4430 a0=bx+j*40:gosub 5000
4440 next j
4450 return



4500 rem horizontal corridor
4510 if rm(a,br,x)<rm(b,tl,x) then ax=rm(a,br,x):bx=rm(b,tl,x):goto 4530
4520 ax=rm(a,tl,x):bx=rm(b,br,x)
4530 dy=rm(a,br,y)-rm(a,tl,y)-2
4540 ay=rm(a,tl,y)+int(rnd(1)*dy) or 1
4550 dy=rm(b,br,y)-rm(b,tl,y)-2
4560 by=rm(b,tl,y)+int(rnd(1)*dy) or 1
4570 rem doors
4580 a0=ax+ay*40:poke 1024+a0,43:poke 55296+a0,10
4585 a0=bx+by*40:poke 1024+a0,43:poke 55296+a0,10
4590 if ay<>by then 4800: rem horizontal z corridor

4700 rem horizontal straight corridor
4710 if ax<bx then sx=ax:ex=bx:goto 4730
4720 sx=bx:ex=ax
4730 for j=sx+1 to ex-1
4740 a0=j+ay*40:gosub 5000
4750 next j
4780 return

4800 rem horizontal z corridor
4810 dx=sgn(bx-ax)
4820 dy=sgn(by-ay)
4840 mx=(ax+dx+int(rnd(1)*abs(bx-ax-2*dx))*dx) or 1
4860 for j=ax+dx to mx-dx step dx
4870 a0=j+ay*40:gosub 5000
4880 next j
4890 for j=ay to by step dy
4900 a0=mx+j*40:gosub 5000
4910 next j
4920 for j=mx+dx to bx-dx step dx
4930 a0=j+by*40:gosub 5000
4940 next j
4950 return



5000 rem *** check if a corridor collides a wall ***
5005 p=peek(1024+a0)
5010 if p=43 or p=46 then return:rem door or inner room
5020 if p=102 then poke 1024+a0,43:return:rem door
5030 poke 1024+a0,35
5040 return
