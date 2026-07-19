0 r=rnd(-ti):rem initialize random number generator
1 tl=0:br=1:x=0:y=1:rem for readability

2 dim rm(8,1,1):rem rooms in the nine (3x3) sectors
3 dim pr(8):rem flag for phantom rooms

4 dim cn(8),vs(8),al(8),ct(3):rem temporary arrays for room connections

5 dim ds(100):rem dungeons seeds
7 cd=0:ld=-1:rem current and last dungeon

10 if ds(cd)<>0 then 30
15 seed=-int(rnd(0)*32768)-1:rem random seed
20 rem seed=-17:rem -5232:rem -29968
25 ds(cd)=seed

30 r=rnd(ds(cd)):rem initialize random number generator
40 print "{clr}{down} create map...":gosub 1000: rem create map
50 print "{clr}":gosub 2000:rem draw map

60 pr=int(rnd(1)*9):rem room of passage to prev level
65 px=rm(pr,tl,x)+1+int(rnd(1)*(rm(pr,br,x)-rm(pr,tl,x)-2))
70 py=rm(pr,tl,y)+1+int(rnd(1)*(rm(pr,br,y)-rm(pr,tl,y)-2))
75 poke 1024+px+py*40,60
80 nr=int(rnd(1)*9):rem room of passage to next level
85 nx=rm(nr,tl,x)+1+int(rnd(1)*(rm(nr,br,x)-rm(nr,tl,x)-2))
90 ny=rm(nr,tl,y)+1+int(rnd(1)*(rm(nr,br,y)-rm(nr,tl,y)-2))
95 poke 1024+nx+ny*40,62



100 rem *** player ***
110 if cd>ld then xx=px:yy=py:goto 130
120 xx=nx:yy=ny
130 ld=cd

200 p=xx+yy*40
210 bg=peek(1024+p):rem store char under the player
220 poke 1024+p,0:rem draw player

230 get a$
240 if a$="w" then dx=0:dy=-1:goto 300:rem up
250 if a$="d" then dx=+1:dy=0:goto 300:rem right
260 if a$="s" then dx=0:dy=+1:goto 300:rem down
270 if a$="a" then dx=-1:dy=0:goto 300:rem left
280 if a$=chr$(13) then 500:rem action
290 goto 230

300 rem check collision
310 np=(xx+dx)+(yy+dy)*40:rem new position
320 c=peek(1024+np)
330 if c=46 then 400:rem floor
340 if c=102 then 400:rem corridor
350 if c=43 then 400:rem door
350 if c=60 or c=62 then 400:rem stairs to prev or next level
360 goto 230:rem colliding, no move

400 poke 1024+p,bg
410 xx=xx+dx:yy=yy+dy
420 goto 200

500 rem leave current level
510 if bg=60 then 550
520 if bg=62 then 570
530 goto 230

550 if cd=0 then end
560 cd=cd-1:goto 10

570 if cd=100 then end
580 cd=cd+1:goto 10



1000 rem *** create sectors ***
1020 gs=5:rem minimum sector size (inner space)
1030 x0=0:rem first sector column
1040 x3=39:rem last sector column
1060 y0=0:rem first sector row
1070 y3=24:rem last sector row
1080 xs=x0+gs+1:xe=x3-gs*3-1
1090 x1=xs+int(rnd(1)*(xe-xs)):rem second sector column
1100 xs=x1+gs+1:xe=x3-gs
1110 x2=xs+int(rnd(1)*(xe-xs)):rem third sector column
1120 ys=y0+gs+1:ye=y3-gs*3-1
1130 y1=ys+int(rnd(1)*(ye-ys)):rem second sector row
1140 ys=y1+gs+1:ye=y3-gs
1150 y2=ys+int(rnd(1)*(ye-ys)):rem third sector row



1200 rem *** create rooms in sectors ***
1210 rm(0,tl,x)=x0+1:rm(0,br,x)=x1-1:rm(0,tl,y)=y0+1:rm(0,br,y)=y1-1
1220 rm(1,tl,x)=x1+1:rm(1,br,x)=x2-1:rm(1,tl,y)=y0+1:rm(1,br,y)=y1-1
1230 rm(2,tl,x)=x2+1:rm(2,br,x)=x3-1:rm(2,tl,y)=y0+1:rm(2,br,y)=y1-1
1240 rm(3,tl,x)=x0+1:rm(3,br,x)=x1-1:rm(3,tl,y)=y1+1:rm(3,br,y)=y2-1
1250 rm(4,tl,x)=x1+1:rm(4,br,x)=x2-1:rm(4,tl,y)=y1+1:rm(4,br,y)=y2-1
1260 rm(5,tl,x)=x2+1:rm(5,br,x)=x3-1:rm(5,tl,y)=y1+1:rm(5,br,y)=y2-1
1270 rm(6,tl,x)=x0+1:rm(6,br,x)=x1-1:rm(6,tl,y)=y2+1:rm(6,br,y)=y3-1
1280 rm(7,tl,x)=x1+1:rm(7,br,x)=x2-1:rm(7,tl,y)=y2+1:rm(7,br,y)=y3-1
1290 rm(8,tl,x)=x2+1:rm(8,br,x)=x3-1:rm(8,tl,y)=y2+1:rm(8,br,y)=y3-1



1300 rem *** set phantom rooms ***
1310 for i=0 to 8:pr(i)=0:next i:rem reset removed room flags
1320 nr=int(rnd(1)*4):rem number of rooms to remove (0-3)
1330 if nr=0 then 1400
1340 for i=1 to nr
1350 r=int(rnd(1)*9):rem random room index
1360 if pr(r)=1 then 1350
1370 pr(r)=1
1380 next i



1400 rem *** shrink rooms ***
1410 gr=2:rem minimum inner gap between room walls
1420 for i=0 to 8
1430 if pr(i)=1 then 1540
1440 xs=rm(i,tl,x):ys=rm(i,tl,y)
1450 xe=rm(i,br,x):ye=rm(i,br,y)

1460 dx=xe-xs-gr*2:dy=ye-ys-gr*2
1470 if dx>0 then xs=xs+int(rnd(1)*dx)
1480 if dy>0 then ys=ys+int(rnd(1)*dy)
1490 dx=xe-xs-gr:dy=ye-ys-gr
1500 if dx>0 then xe=xe-int(rnd(1)*dx)
1510 if dy>0 then ye=ye-int(rnd(1)*dy)

1520 rm(i,tl,x)=xs:rm(i,tl,y)=ys
1530 rm(i,br,x)=xe:rm(i,br,y)=ye
1540 next i



1600 rem *** set room connections ***
1610 for i=0 to 8:cn(i)=0:vs(i)=0:next i:rem reset connection flags
1620 a=int(rnd(1)*9):rem select random starting room
1630 vs(a)=1:al(0)=a:rem mark starting room as connected and add to list

1640 for n=1 to 8
1650 a=al(int(rnd(1)*n)):rem select random connected room
1660 m=a-int(a/3)*3:rem determine column of room (0,1,2)

1665 s=0:rem avialable connections counter
1670 if m>0 then if vs(a-1)=0 then ct(s)=a-1:s=s+1:rem not the left column
1680 if m<2 then if vs(a+1)=0 then ct(s)=a+1:s=s+1:rem not the right column
1690 if a>2 then if vs(a-3)=0 then ct(s)=a-3:s=s+1:rem not the top row
1700 if a<6 then if vs(a+3)=0 then ct(s)=a+3:s=s+1:rem not the bottom row
1710 if s=0 then 1650:rem no available connections, select another room

1720 b=ct(int(rnd(1)*s)):rem select random available connection
1730 if b=a-3 then cn(b)=cn(b)+4:rem cn(a)=cn(a)+1:rem b is up
1740 if b=a+1 then cn(a)=cn(a)+2:rem cn(b)=cn(b)+8:rem b is right
1750 if b=a+3 then cn(a)=cn(a)+4:rem cn(b)=cn(b)+1:rem b is down
1760 if b=a-1 then cn(b)=cn(b)+2:rem cn(a)=cn(a)+8:rem b is left

1770 vs(b)=1:al(n)=b:rem mark new room as connected and add to list
1780 next n

1790 return



2000 rem *** draw rooms ***
2010 for i=0 to 8
2015 if pr(i)=1 then poke 1024+rm(i,tl,x)+rm(i,tl,y)*40,102:goto 2170:rem phantom room

2020 a0=rm(i,tl,y)*40:a1=rm(i,br,y)*40
2030 for j=rm(i,tl,x)+1 to rm(i,br,x)-1
2040 poke 1024+j+a0,67
2050 poke 1024+j+a1,67
2060 next j
2070 poke 1024+rm(i,tl,x)+a0,112
2080 poke 1024+rm(i,br,x)+a0,110

2090 for j=rm(i,tl,y)+1 to rm(i,br,y)-1
2100 a0=rm(i,tl,x)+j*40:a1=rm(i,br,x)+j*40
2110 poke 1024+a0,66
2120 poke 1024+a1,66
2130 for k=a0+1 to a1-1:poke 1024+k,46:next k:rem fill room with dots
2140 next j
2150 poke 1024+rm(i,tl,x)+rm(i,br,y)*40,109
2160 poke 1024+rm(i,br,x)+rm(i,br,y)*40,125

2170 next i



3000 rem *** draw corridors ***
3010 for a=0 to 8
3015 rem if (cn(a) and 1)<>0 then b=a-3:gosub ...:rem open up
3020 if (cn(a) and 2)<>0 then b=a+1:gosub 3100:rem horizontal corridor
3030 if (cn(a) and 4)<>0 then b=a+3:gosub 3500:rem vertical corridor
3035 rem if (cn(a) and 8))<>0 then b=a-1:gosub ...:rem open left
3040 next a
3050 return



3100 rem *** horizontal corridor ***
3110 if pr(a)=1 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto 3160
3120 ax=rm(a,br,x)
3140 dy=rm(a,br,y)-rm(a,tl,y)-2
3145 ay=rm(a,tl,y)+1+int(rnd(1)*dy)
3150 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

3160 if pr(b)=1 then bx=rm(b,tl,x):by=rm(b,tl,y):goto 3200
3170 bx=rm(b,tl,x)
3180 dy=rm(b,br,y)-rm(b,tl,y)-2
3185 by=rm(b,tl,y)+1+int(rnd(1)*dy)
3190 a0=bx+by*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

3200 if ay=by then 3400

3210 rem horizontal z-shaped corridor
3220 mx=ax+1+int(rnd(1)*(bx-ax-2))
3230 for j=ax+1 to mx
3240 a0=j+ay*40:poke 1024+a0,102:rem corridor
3250 next j
3260 dy=sgn(by-ay)
3265 if ay+dy=by then 3300
3270 for j=ay+dy to by-dy step dy
3280 a0=mx+j*40:poke 1024+a0,102:rem corridor
3290 next j
3300 for j=mx to bx-1
3310 a0=j+by*40:poke 1024+a0,102:rem corridor
3320 next j
3330 return

3400 rem horizontal straight corridor
3410 for j=ax+1 to bx-1
3420 a0=j+ay*40:poke 1024+a0,102:rem corridor
3430 next j
3440 return



3500 rem *** vertical corridor ***
3510 if pr(a)=1 then ax=rm(a,tl,x):ay=rm(a,tl,y):goto 3560
3520 ay=rm(a,br,y)
3540 dx=rm(a,br,x)-rm(a,tl,x)-2
3545 ax=rm(a,tl,x)+1+int(rnd(1)*dx)
3550 a0=ax+ay*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

3560 if pr(b)=1 then bx=rm(b,tl,x):by=rm(b,tl,y):goto 3600
3570 by=rm(b,tl,y)
3580 dx=rm(b,br,x)-rm(b,tl,x)-2
3585 bx=rm(b,tl,x)+1+int(rnd(1)*dx)
3590 a0=bx+by*40:poke 1024+a0,43:rem poke 55296+a0,10:rem door

3600 if ax=bx then 3800

3610 rem vertical z-shaped corridor
3620 my=ay+1+int(rnd(1)*(by-ay-2))
3630 for j=ay+1 to my
3640 a0=ax+j*40:poke 1024+a0,102:rem corridor
3650 next j
3660 dx=sgn(bx-ax)
3665 if ax+dx=bx then 3700
3670 for j=ax+dx to bx-dx step dx
3680 a0=j+my*40:poke 1024+a0,102:rem corridor
3690 next j
3700 for j=my to by-1
3710 a0=bx+j*40:poke 1024+a0,102:rem corridor
3720 next j
3730 return

3800 rem vertical straight corridor
3810 for j=ay+1 to by-1
3820 a0=ax+j*40:poke 1024+a0,102:rem corridor
3830 next j
3840 return
