-- from krajzeg's 'the lair' http://www.lexaloffle.com/bbs/?tid=4051

function extend(obj,props)
 obj=obj or {}
 for k,v in pairs(props or {}) do
  obj[k]=v
 end
 return obj
end

--works as a foreach loop
--for characters in string
function each_char(str,fn)
 for i=1,#str do
  fn(sub(str,i,i),i)
 end
end

--lets us define large lookup
--tables using one token, via
--string parsing and multiline
--strings
function lut(str)
 local result,s={},1
 each_char(str,function(c,i)
  if c=="\n" then
   add(result,ob(sub(str,s,i)))
   s=i
  end
 end)
 return result
end

--lets us define constant
--objects with a single
--token by using multiline
--strings
function ob(str,props)
 local result,s,n={},1,1
 each_char(str,function(c,i)
  local sc,nxt=sub(str,s,s),i+1
  if c=="=" then
   n=sub(str,s,i-1)
   s=nxt
  elseif c=="," then
   result[n]=sc=='"'
    and sub(str,s+1,i-2)
    or sc!="f"
    and sub(str,s,i-1)+0    
   s=nxt
   if (type(n)=="number") n+=1
  elseif sc!='"' and c==" " or c=="\n" then
   s=nxt
  end
 end)
 return extend(props,result)
end

return {
 extend=extend;
 each_char=each_char;
 lut=lut;
 ob=ob;
}
