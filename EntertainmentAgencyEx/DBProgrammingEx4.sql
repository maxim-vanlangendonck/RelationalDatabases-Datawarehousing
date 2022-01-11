/*Exercise 4
Write a SP add_entertainer_style to add a new Entertainer_Style, given the entertainerid, the stylename
and the stylestrength (= parameters)
Check if the given entertainer exists. If not, throw an error
Check if the given stylename exists. If not, throw an error
Check if the entertainer not already has this style. If so, throw an error
Check if the given stylestrength is a value between 1 and 3
If the given stylestrength is already taken for this entertainerid: the other stylestrengths are getting a new
value = old value + 1. Make sure there are no more than 3 stylestrengths per entertainer
Use an output parameter to pass the result back to the user: 1 if the insert succeeded and 0 if the insert
didn't succeed
Write testcode for the following cases:
	Add entertainer with entertainerid = 1020 + stylename = chamber music + stylestrength = 1
	Add entertainer with entertainerid = 1003 + stylename = disco + stylestrength = 3
	Add entertainer with entertainerid = 1005 + stylename = Jazz + stylestrength = 1
	Add entertainer with entertainerid = 1005 + stylename = Jazz + stylestrength = 4
	Add entertainer with entertainerid = 1005 + stylename = Folk + stylestrength = 2
	Add entertainer with entertainerid = 1003 + stylename = Folk + stylestrength = 3 */