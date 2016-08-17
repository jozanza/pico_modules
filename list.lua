{

 -- create
 create=function()
  return ({
   size=0;
   first=0;
   last=-1;
   max=nil;
   empty=list.empty;
   full=list.full;
   limit=list.limit;
   copy=list.copy;
   head=list.head;
   tail=list.tail;
   lpush=list.lpush;
   rpush=list.rpush;
   lpop=list.lpop;
   rpop=list.rpop;
   lpoprpush=list.lpoprpush;
   rpoplpush=list.rpoplpush;
   map=list.map;
   filter=list.filter;
   reduce=list.reduce;
   foreach=list.foreach;
  })
 end;

 -- of
 of=function(...)
  local _=list.create()
  foreach({...},bind(_.rpush,_))
  return _
 end;

 -- empty
 empty=function(_)
  return _.first>_.last
 end;

 -- full
 full=function(_)
  return (
   _.max and
   _.max<=_.size
  )
 end;
 
 -- limit
 limit=function(_,n)
  _.max=n
  return _
 end;

 -- copy
 copy=function(_)
  return clone(_)
 end;

 -- head
 head=function(_)
  return _[_.first]
 end;

 -- tail
 tail=function(_)
  return _[_.last]
 end;

 -- push left
 lpush=function(_,v)
  if (_:full()) return _:rpoplpush(v)
  _.first-=1
  _[_.first]=v
  _.size+=1
  return _
 end;

 -- push right
 rpush=function(_,v)
  if (_:full()) return _:lpoprpush(v)
  _.last+=1
  _[_.last]=v
  _.size+=1
  return _
 end;

 -- pop left
 lpop=function(_)
  if (_:empty()) return _
  _[_.first]=nil -- gc
  _.first+=1
  _.size-=1
  return _
 end;

 -- pop right
 rpop=function(_)
  if (_:empty()) return _
  _[_.last]=nil -- gc
  _.last-=1
  _.size-=1
  return _
 end;

 -- pop left + push right
 lpoprpush=function(_,v)
  return _:lpop():rpush(v)
 end;

 -- pop right + push left
 rpoplpush=function(_,v)
  return _:rpop():lpush(v)
 end;

 -- map
 map=function(_,f)
  if (_:empty()) return _
  local i=1
  for k=_.first,_.last do
   _[k]=f(v,i,_)
   i+=1
  end
  return _
 end;

 -- filter
 filter=function(_,f)
  if (_:empty()) return _
  local i=1
  for k=_.first,_.last do
   if (f(v,i,_)) _:rpush(v)
   i+=1
  end
  return _
 end;

 -- reduce
 reduce=function(_,f,x)
  local a=clone(x)
  local i=1
  if (_:empty()) return a
  for k=_.first,_.last do
   a=f(a,_[k],i,_)
   i+=1
  end
  return a
 end;

 -- foreach
 foreach=function(_,f)
  local i=1
  if (_:empty()) return _
  for k=_.first,_.last do
   f(_[k],i,_)
   i+=1
  end
  return _
 end;

}
