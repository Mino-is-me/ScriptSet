fStartFrame = 50
fEndFrame = 100 

arAllFrames = for i= fStartFrame to fEndFrame collect i 
	
arSpecific = #()
arIntervalFrames = #()

temp = 0
iInterval =4
--while cnt < fEndFrame do 

for i=fStartFrame to fEndFrame do 
(
    temp += 1
    cnt = fStartFrame +  ( iInterval * temp )
	if cnt < fEndFrame do 
	(
		append arSpecific cnt 
	)
)


for i in arSpecific do 
(
	indexkey = findItem arAllFrames i 
	--print indexKey 
	arAllFrames = deleteItem arAllFrames indexkey
)

indexKey = findItem arAllFrames fStartFrame
arAllFrames = deleteItem arAllFrames indexkey

indexKey = findItem arAllFrames fEndFrame
arAllFrames = deleteItem arAllFrames indexKey
for i in arAllFrames do print i
	
