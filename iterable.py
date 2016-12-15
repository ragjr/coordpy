#v1
el = [4999.34,4998.04,4997.74,4999.36]

def neighborhood(iterable):
    iterator = iter(iterable)
    prev_item = None
    current_item = next(iterator)  # throws StopIteration if empty.
    for next_item in iterator:
        yield (prev_item, current_item, next_item)
        prev_item = current_item
        current_item = next_item
    yield (prev_item, current_item, None)
    
for prev,item,next in neighborhood(el):
    print prev, item, next

#v2
el = iter([[1,4999.34],[2,4998.04],[3,4997.74],[4,4999.36]])

for e in el:
	e1 = e[1]
	e2 = el.next()
	e2 = e2[1]
	print([e1,e2])
    
#results
#[4999.34, 4998.04]
#[4997.74, 4999.36]
