/*Exercise 3
Write a SP add_musical_preference to add a new musical preference given a customerid, a stylename and a
preferenceSeq (= parameters)
Check if the customer exists. If not, throw an error
Check if the stylename exists. If not, throw an error
Check the preferenceSeq: if the customer already has a stylename with this preferenceSeq: this stylename
and the subsequent styles get preferenceSeq + 1
Use an output parameter to pass the result back to the user: 1 if the insert succeeded and 0 if the insert
didn't succeed
Write testcode for the following cases:
	for customer 10005 add Variety with PreferenceSeq = 3
	for customer 10007 add Variety with PreferenceSeq = 1 */