-- rotates a sprite
return function(x1,y1,s,x2,y2,deg)
 local r =deg/360
 local sr=sin(r)
 local cr=cos(r)
 local b =sr*sr+cr*cr
 local s2=s/2
 local w =sqrt(s2^2*2)
 for i=-w,w do
  for j=-w,w do
   local sx=-1+x1+(( sr*i+cr*j)/b+s2)
   local sy=-1+y1+((-sr*j+cr*i)/b+s2)
   local oob=sx<x1 or sy<y1 or sx>=x1+s or sy>=y1+s
   local col=(not oob) and sget(sx,sy) or 0
   if col>0 then pset(x2+j,y2+i,col) end
  end 
 end
end
