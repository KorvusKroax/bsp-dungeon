
0 r=rnd(-ti):rem initialize random number generator

1 tl=0:br=1:x=0:y=1:rem for readability

2 rem wall types
3 dim w(15):for i=0 to 15:read a:w(i)=a:next i
4 data 0,0,0,109,0,66,112,107,0,125,67,113,110,115,114,91
5 rem index of w means: bit 0=up, bit 1=right, bit 2=down, bit 3=left

10 dim rm(100,1,1):rem room (index), (0=top left, 1=bottom right), (0=x, 1=y)
30 dim cl(100,1):rem child indexes left-right or top-bottom (0 is main room)
40 dim cn(100,1):rem connections of rooms (indexes)

60 mp=10:rem minimum partition size (walls included)
70 gp=3:rem minimum inner gap between walls (odd numbers only)



100 rem *** main loop ***
101 seed=-int(rnd(1)*32768)-1:rem random seed
102 rem seed=-5497:rem -14923 -31339 -7427 -24002 -19323 -17746
103 r=rnd(seed):rem initialize random number generator

105 gosub 500: rem create partitions
110 gosub 1500:rem shrink partitions to rooms
120 gosub 2000:rem set connections
130 print"{clr}"
140 gosub 3000:rem draw rooms
150 gosub 5000:rem draw corridors
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

1600 xs=rm(i,tl,x):rem +1
1610 ys=rm(i,tl,y):rem +1
1620 xe=rm(i,br,x):rem -1
1630 ye=rm(i,br,y):rem -1
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
3120 wa=j+a0:wt=10:gosub 4000
3125 wa=j+a1:wt=10:gosub 4000
3130 next j
3140 wa=rm(i,tl,x)+a0:wt=6:gosub 4000
3145 wa=rm(i,br,x)+a0:wt=12:gosub 4000

3150 for j=rm(i,tl,y)+1 to rm(i,br,y)-1
3160 a0=rm(i,tl,x)+j*40:a1=rm(i,br,x)+j*40
3170 wa=a0:wt=5:gosub 4000
3180 wa=a1:wt=5:gosub 4000
3200 for k=a0+1 to a1-1:poke 1024+k,46:next k:rem fill room with dots
3230 next j
3240 wa=rm(i,tl,x)+rm(i,br,y)*40:wt=3:gosub 4000
3245 wa=rm(i,br,x)+rm(i,br,y)*40:wt=9:gosub 4000

3300 next i
3310 return



4000 rem *** draw wall ***
4010 p=peek(1024+wa)
4015 if p=w(wt) then return:rem the wall is already there
4020 if p=32 then poke 1024+wa,w(wt):return:rem empty space

4030 n=-1
4040 for ii=0 to 15
4050 if p=w(ii) then n=ii
4060 next ii
4070 if n=-1 then poke 1024+wa,w(wt):return:rem not a wall

4080 poke 1024+wa,w(wt or n):poke 55296+wa,1
4090 return



5000 rem *** draw corridors ***
5010 for i=0 to cc-1
5020 a=cn(i,0):b=cn(i,1):gosub 6000
5030 next i
5040 return

6000 rem draw corridor between two rooms (a-b)

6010 rem xo=min(rm(a,br,x),rm(b,br,x))-max(rm(a,tl,x),rm(b,tl,x))
6020 dx=rm(b,br,x)-rm(a,br,x):x1=rm(a,br,x)-dx*(dx<0):rem get smaller x
6030 dx=rm(b,tl,x)-rm(a,tl,x):x2=rm(a,tl,x)-dx*(dx>0):rem get bigger x
6040 xo=x1-x2

6100 rem yo=min(rm(a,br,y),rm(b,br,y))-max(rm(a,tl,y),rm(b,tl,y))
6110 dy=rm(b,br,y)-rm(a,br,y):y1=rm(a,br,y)-dy*(dy<0):rem get smaller y
6120 dy=rm(b,tl,y)-rm(a,tl,y):y2=rm(a,tl,y)-dy*(dy>0):rem get bigger y
6130 yo=y1-y2

6200 rem xg=max(rm(b,tl,x)-rm(a,br,x),rm(a,tl,x)-rm(b,br,x))
6210 x1=rm(b,tl,x)-rm(a,br,x)
6220 x2=rm(a,tl,x)-rm(b,br,x)
6230 dx=x2-x1:xg=x1-dx*(dx>0):rem get bigger x

6300 rem yg=max(rm(b,tl,y)-rm(a,br,y),rm(a,tl,y)-rm(b,br,y))
6310 y1=rm(b,tl,y)-rm(a,br,y)
6320 y2=rm(a,tl,y)-rm(b,br,y)
6330 dy=y2-y1:yg=y1-dy*(dy>0):rem get bigger y

6400 if xg=0 and yg=0 then 8000:rem l-shaped for corner touch

6405 rem possible horizontal connection types
6410 if xg<0 or (xg=0 and yo<0) then hc=0:goto 6500
6420 if xg=0 and yo>=0 and cl(a,0)>-2 and cl(b,0)>-2 then hc=1:goto 6500:rem door-only corridor
6430 if xg>0 and rnd(1)<0.5 then hc=3:goto 6500:rem l-shaped corridor
6440 hc=2:rem z-shaped corridor

6500 rem possible vertical connection types
6510 if yg<0 or (yg=0 and xo<0) then vc=0:goto 6600
6520 if yg=0 and xo>=0 and cl(a,0)>-2 and cl(b,0)>-2 then vc=1:goto 6600:rem door-only corridor
6530 if yg>0 and rnd(1)<0.5 then vc=3:goto 6600:rem l-shaped corridor
6540 vc=2:rem z-shaped corridor

6600 rem decide horizontal or vertical corridor
6620 if hc>0 and vc>0 then on rnd(1)*2+1 goto 6700,6800
6630 if vc>0 then 6800
6700 on hc goto 7000,7100,8000:rem horizontal door-only, z-shaped, l-shaped
6800 on vc goto 7500,7600,8000:rem vertical door-only, z-shaped, l-shaped



7000 rem horizontal door only
7010 dx=rm(b,br,x)-rm(a,br,x):ax=rm(a,br,x)-dx*(dx<0):rem get smaller x
7020 dy=rm(b,tl,y)-rm(a,tl,y):ys=rm(a,tl,y)-dy*(dy>0):rem get bigger y
7030 dy=rm(b,br,y)-rm(a,br,y):ye=rm(a,br,y)-dy*(dy<0):rem get smaller y
7050 dy=ye-ys-2
7060 ay=ys+1+int(rnd(1)*dy) or 1
7070 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,13
7080 return



7100 rem horizontal z-shaped corridor
7110 if rm(a,br,x)<=rm(b,tl,x) then ax=rm(a,br,x):bx=rm(b,tl,x):goto 7120
7115 ax=rm(a,tl,x):bx=rm(b,br,x)

7120 if cl(a,0)>-2 then 7140
7125 ax=int((rm(a,tl,x)+rm(a,br,x))/2) or 1
7130 ay=int((rm(a,tl,y)+rm(a,br,y))/2) or 1
7133 a0=ax+ay*40:poke 1024+a0,127:rem door-only room
7135 goto 7160

7140 dy=rm(a,br,y)-rm(a,tl,y)-2
7145 ay=rm(a,tl,y)+1+int(rnd(1)*dy) or 1
7150 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,10

7160 if cl(b,0)>-2 then 7180
7165 bx=int((rm(b,tl,x)+rm(b,br,x))/2) or 1
7170 by=int((rm(b,tl,y)+rm(b,br,y))/2) or 1
7173 a0=bx+by*40:poke 1024+a0,127:rem door-only room
7175 goto 7200

7180 dy=rm(b,br,y)-rm(b,tl,y)-2
7185 by=rm(b,tl,y)+1+int(rnd(1)*dy) or 1
7190 a0=bx+by*40:poke 1024+a0,43:rem poke 55296+a0,10

7200 if ay=by then 7400

7202 dx=sgn(bx-ax):if dx=0 then return
7204 mx=(ax+dx+int(rnd(1)*abs(bx-ax-2*dx))*dx) or 1
7210 dy=sgn(by-ay):if dy=0 then 7260
7220 for j=ay+dy to by-dy step dy
7230 a0=mx+j*40:gosub 9000
7240 next j
7250 a0=mx+ay*40:gosub 9100:rem corner
7255 a0=mx+by*40:gosub 9100:rem corner

7260 if dx=0 then return
7280 for j=ax+dx to mx-dx step dx
7290 a0=j+ay*40:gosub 9000
7295 next j
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



7500 rem vertical door only
7510 dy=rm(b,br,y)-rm(a,br,y):ay=rm(a,br,y)-dy*(dy<0):rem get smaller y
7520 dx=rm(b,tl,x)-rm(a,tl,x):xs=rm(a,tl,x)-dx*(dx>0):rem get bigger x
7530 dx=rm(b,br,x)-rm(a,br,x):xe=rm(a,br,x)-dx*(dx<0):rem get smaller x
7550 dx=xe-xs-2
7560 ax=xs+1+int(rnd(1)*dx) or 1
7570 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,13
7580 return



7600 rem vertical z-shaped corridor
7610 if rm(a,br,y)<=rm(b,tl,y) then ay=rm(a,br,y):by=rm(b,tl,y):goto 7620
7615 ay=rm(a,tl,y):by=rm(b,br,y)

7620 if cl(a,0)>-2 then 7640
7625 ax=int((rm(a,tl,x)+rm(a,br,x))/2) or 1
7630 ay=int((rm(a,tl,y)+rm(a,br,y))/2) or 1
7633 a0=ax+ay*40:poke 1024+a0,127:rem door-only room
7635 goto 7660

7640 dx=rm(a,br,x)-rm(a,tl,x)-2
7645 ax=rm(a,tl,x)+1+int(rnd(1)*dx) or 1
7650 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,10

7660 if cl(b,0)>-2 then 7680
7665 bx=int((rm(b,tl,x)+rm(b,br,x))/2) or 1
7670 by=int((rm(b,tl,y)+rm(b,br,y))/2) or 1
7673 a0=bx+by*40:poke 1024+a0,127:rem door-only room
7675 goto 7700

7680 dx=rm(b,br,x)-rm(b,tl,x)-2
7685 bx=rm(b,tl,x)+1+int(rnd(1)*dx) or 1
7690 a0=bx+by*40:poke 1024+a0,43:rem poke 55296+a0,10

7700 if ax=bx then 7900

7702 dy=sgn(by-ay):if dy=0 then return
7704 my=(ay+dy+int(rnd(1)*abs(by-ay-2*dy))*dy) or 1
7710 dx=sgn(bx-ax):if dx=0 then 7760
7720 for j=ax+dx to bx-dx step dx
7730 a0=j+my*40:gosub 9000
7740 next j
7750 a0=ax+my*40:gosub 9100:rem corner
7755 a0=bx+my*40:gosub 9100:rem corner

7760 if dy=0 then return
7780 for j=ay+dy to my-dy step dy
7790 a0=ax+j*40:gosub 9000
7795 next j
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



8000 rem l-shaped corridor

8010 if cl(a,0)>-2 then 8030
8015 ax=int((rm(a,tl,x)+rm(a,br,x))/2) or 1
8020 ay=int((rm(a,tl,y)+rm(a,br,y))/2) or 1
8023 a0=ax+ay*40:poke 1024+a0,127:rem door-only room
8025 goto 8050

8030 dx=rm(a,br,x)-rm(a,tl,x)-2
8035 ax=rm(a,tl,x)+1+int(rnd(1)*dx) or 1
8040 dy=rm(a,br,y)-rm(a,tl,y)-2
8045 ay=rm(a,tl,y)+1+int(rnd(1)*dy) or 1

8050 if cl(b,0)>-2 then 8070
8055 bx=int((rm(b,tl,x)+rm(b,br,x))/2) or 1
8060 by=int((rm(b,tl,y)+rm(b,br,y))/2) or 1
8063 a0=bx+by*40:poke 1024+a0,127:rem door-only room
8065 goto 8100

8070 dx=rm(b,br,x)-rm(b,tl,x)-2
8075 bx=rm(b,tl,x)+1+int(rnd(1)*dx) or 1
8080 dy=rm(b,br,y)-rm(b,tl,y)-2
8085 by=rm(b,tl,y)+1+int(rnd(1)*dy) or 1

8100 rem decide corridor direction
8110 if rnd(1)<0.5 then sx=ax:sy=ay:ex=bx:ey=by:goto 8200
8120 sx=bx:sy=by:ex=ax:ey=ay

8200 rem horizontal part
8210 dx=sgn(ex-sx):if dx=0 then 8300
8220 for j=sx+dx to ex-dx step dx
8230 a0=j+sy*40:gosub 9000
8240 next j

8300 rem vertical part
8310 dy=sgn(ey-sy):if dy=0 then return
8320 for j=sy+dy to ey-dy step dy
8330 a0=ex+j*40:gosub 9000
8340 next j

8350 if dx<>0 then a0=ex+sy*40:gosub 9100:rem corner

8400 return




9000 rem *** set corridor ***
9010 p=peek(1024+a0)
9020 if p=43 or p=46 then return:rem door or inner room
9030 if p=66 or p=67 then poke 1024+a0,46:return:rem passage (.)
9040 poke 1024+a0,102:rem corridor
9050 return

9100 rem *** set corridor corner ***
9110 p=peek(1024+a0)
9120 if p=32 then poke 1024+a0,42:return
9125 print p
9130 return
