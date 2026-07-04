
0 r=rnd(-ti):rem initialize random number generator

9 tl=0:br=1:x=0:y=1:rem for readability

10 dim rm(100,1,1):rem room (index), (0=top left, 1=bottom right), (0=x, 1=y)
30 dim cl(100,1):rem child indexes left-right or top-bottom (0 is main room)
40 dim cn(100,1):rem connections of rooms (indexes)

60 mp=10:rem minimum partition size (walls included)
70 gp=3:rem minimum inner gap between walls (odd numbers only)



100 rem *** main loop ***
101 seed=-int(rnd(1)*32768)-1:rem random seed
102 rem seed=-15080:rem -24002:rem -19323:rem -17746 -2169
103 r=rnd(seed):rem initialize random number generator

105 gosub 500: rem create partitions
110 gosub 1500:rem shrink partitions to rooms
120 gosub 2000:rem set connections
130 print"{clr}"
140 gosub 3000:rem draw rooms
150 gosub 3500:rem draw corridors
155 print " seed: ";seed

160 get a$
162 if a$=" " then 100
165 if a$=chr$(13) then 103
170 goto 160





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
1510 print"{down} shrinking partitions to rooms..."
1520 for i=0 to rc
1530 if cl(i,0)>-1 then 1800:rem skip non-leaf partitions

1600 xs=rm(i,tl,x)+1
1610 ys=rm(i,tl,y)+1
1620 xe=rm(i,br,x)-1
1630 ye=rm(i,br,y)-1
1640 dx=xe-xs-gp
1650 dy=ye-ys-gp
1660 if dx>0 then xs=xs+int(rnd(1)*dx)
1670 if dy>0 then ys=ys+int(rnd(1)*dy)
1680 dx=xe-xs-gp
1690 dy=ye-ys-gp
1700 if dx>0 then xe=xe-int(rnd(1)*dx)
1710 if dy>0 then ye=ye-int(rnd(1)*dy)
1720 rm(i,tl,x)=xs and 254
1730 rm(i,tl,y)=ys and 254
1740 rm(i,br,x)=xe and 254
1750 rm(i,br,y)=ye and 254

1800 next i
1810 return





2000 rem *** connect rooms ***
2010 print"{down} setting connections..."
2020 cc=0:rem connection count
2030 for i=0 to rc
2040 if cl(i,0)=-1 then 2200:rem skip leaf partitions
2100 a=cl(i,0):b=cl(i,1)
2110 n=a:gosub 2300:cn(cc,0)=n
2120 n=b:gosub 2300:cn(cc,1)=n
2130 cc=cc+1
2200 next i
2210 return

2300 if cl(n,0)>-1 then n=cl(n,int(rnd(1)*2)):goto 2300
2310 return





3000 rem *** draw rooms ***
3010 for i=0 to rc
3020 if cl(i,0)>-1 then 3300
3025 if rnd(1)<0.2 then cl(i,0)=-2:goto 3300: rem make a door-only room
3100 a0=rm(i,tl,y)*40:a1=rm(i,br,y)*40
3110 for j=rm(i,tl,x)+1 to rm(i,br,x)-1
3120 poke 1024+j+a0,67:rem poke 55296+j+a0,1
3130 poke 1024+j+a1,67:rem poke 55296+j+a1,1
3140 next j
3145 poke 1024+rm(i,tl,x)+a0,112
3149 poke 1024+rm(i,br,x)+a0,110

3150 for j=rm(i,tl,y)+1 to rm(i,br,y)-1
3160 a0=rm(i,tl,x)+j*40:a1=rm(i,br,x)+j*40
3170 poke 1024+a0,66:rem poke 55296+a0,1
3180 poke 1024+a1,66:rem poke 55296+a1,1
3190 rem fill room with dots
3200 for k=a0+1 to a1-1
3210 poke 1024+k,46
3220 next k
3230 next j
3160 a0=rm(i,br,y)*40
3165 poke 1024+rm(i,tl,x)+a0,109
3169 poke 1024+rm(i,br,x)+a0,125

3300 next i
3310 return





3500 rem *** draw corridors ***
3510 for i=0 to cc-1
3520 a=cn(i,0):b=cn(i,1):gosub 6200
3530 next i
3540 return



6000 rem draw corridor between two rooms

6200 rem xg=max(rm(b,tl,x)-rm(a,br,x),rm(a,tl,x)-rm(b,br,x))
6210 x1=rm(b,tl,x)-rm(a,br,x):x2=rm(a,tl,x)-rm(b,br,x)
6230 dx=x2-x1:xg=x1-dx*(dx>0):rem get bigger x
6300 rem yg=max(rm(b,tl,y)-rm(a,br,y),rm(a,tl,y)-rm(b,br,y))
6310 y1=rm(b,tl,y)-rm(a,br,y):y2=rm(a,tl,y)-rm(b,br,y)
6330 dy=y2-y1:yg=y1-dy*(dy>0):rem get bigger y

6600 rem decide horizontal or vertical corridor
6610 if xg>0 and yg>0 then on rnd(1)*2+1 goto 7100,7600
6630 if yg>0 then 7600

7100 rem horizontal corridor
7110 if rm(a,br,x)<=rm(b,tl,x) then ax=rm(a,br,x):bx=rm(b,tl,x):goto 7120
7115 ax=rm(a,tl,x):bx=rm(b,br,x)

7120 if cl(a,0)=-2 then gosub 8000:goto 7160
7140 dy=rm(a,br,y)-rm(a,tl,y)-2
7145 ay=rm(a,tl,y)+1+int(rnd(1)*dy) or 1
7150 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,10
7160 if cl(b,0)=-2 then gosub 8100:goto 7200
7180 dy=rm(b,br,y)-rm(b,tl,y)-2
7185 by=rm(b,tl,y)+1+int(rnd(1)*dy) or 1
7190 a0=bx+by*40:poke 1024+a0,43:rem poke 55296+a0,10
7200 if ay=by then 7400

7205 rem horizontal z-shaped corridor
7210 dx=sgn(bx-ax):dy=sgn(by-ay)
7230 mx=(ax+dx+int(rnd(1)*abs(bx-ax-2*dx))*dx) or 1
7240 for j=ax+dx to mx-dx step dx
7250 a0=j+ay*40:gosub 9000
7260 next j
7270 for j=ay to by step dy
7280 a0=mx+j*40:gosub 9000
7290 next j
7300 for j=mx+dx to bx-dx step dx
7310 a0=j+by*40:gosub 9000
7320 next j
7330 return

7400 rem horizontal straight corridor
7410 dx=sgn(bx-ax)
7420 for j=ax+dx to bx-dx step dx
7430 a0=j+ay*40:gosub 9000
7440 next j
7450 return



7600 rem vertical corridor
7610 if rm(a,br,y)<=rm(b,tl,y) then ay=rm(a,br,y):by=rm(b,tl,y):goto 7620
7615 ay=rm(a,tl,y):by=rm(b,br,y)

7620 if cl(a,0)=-2 then gosub 8000:goto 7660
7640 dx=rm(a,br,x)-rm(a,tl,x)-2
7645 ax=rm(a,tl,x)+1+int(rnd(1)*dx) or 1
7650 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,10
7660 if cl(b,0)=-2 then gosub 8100:goto 7700
7680 dx=rm(b,br,x)-rm(b,tl,x)-2
7685 bx=rm(b,tl,x)+1+int(rnd(1)*dx) or 1
7690 a0=bx+by*40:poke 1024+a0,43:rem poke 55296+a0,10
7700 if ax=bx then 7900

7705 rem vertical z-shaped corridor
7710 dx=sgn(bx-ax):dy=sgn(by-ay)
7730 my=(ay+dy+int(rnd(1)*abs(by-ay-2*dy))*dy) or 1
7740 for j=ay+dy to my-dy step dy
7750 a0=ax+j*40:gosub 9000
7760 next j
7770 for j=ax to bx step dx
7780 a0=j+my*40:gosub 9000
7790 next j
7800 for j=my+dy to by-dy step dy
7810 a0=bx+j*40:gosub 9000
7820 next j
7830 return

7900 rem vertical straight corridor
7910 dy=sgn(by-ay)
7920 for j=ay+dy to by-dy step dy
7930 a0=ax+j*40:gosub 9000
7940 next j
7950 return



8000 rem ** set door-only room for a ***
8010 ax=int((rm(a,tl,x)+rm(a,br,x))/2) or 1
8020 ay=int((rm(a,tl,y)+rm(a,br,y))/2) or 1
8030 a0=ax+ay*40:poke 1024+a0,127:rem door-only room
8040 return

8100 rem ** set door-only room for b ***
8110 bx=int((rm(b,tl,x)+rm(b,br,x))/2) or 1
8120 by=int((rm(b,tl,y)+rm(b,br,y))/2) or 1
8130 a0=bx+by*40:poke 1024+a0,127:rem door-only room
8140 return



9000 rem *** set corridor ***
9010 p=peek(1024+a0)
9020 if p=43 or p=46 then return:rem door or inner room
9030 if p=66 or p=67 then poke 1024+a0,46:return:rem door
9040 poke 1024+a0,102:rem corridor
9050 return
