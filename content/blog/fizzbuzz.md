+++
title = "Fizz/Buzz Interview Question"
description = ""
tags = [
        "development",
]
date = "2014-04-02"
categories = [
    "Development",
]
highlight = "true"
+++
##The Fizz Buzz" interview question
One of the hardest things about hiring people is determining who will be a good fit for the company. For development teams this can be narrowly defined as someone who can answer arcane questions regarding computer science. One the tests I have seen used by many companies is the infamous "Fizz Buzz" problem. This problem is basically defined as follows:

1.	If a number is divisible by 3 print out "Fizz"
2.	If a number is divisible by 5 print out "Buzz"
3.	If a number is divisible by both 3 and 5, print out "Fizz Buzz"
4.	If a number is not divisible by either 3 or 5, then print out the number

There are variations but you get the idea. So what the interviewer is looking for is two things, first that the code will actually implement the above steps correctly, and secondly that the code will do so with the minimal code depth.

The solution that is typically looked for is something like the following:
```javascript
void FizzBuzzTest(int num)
{
	if !( (num % 3) || (num % 5) )		// divisible by 3 & 5?
		printf ("FizzBuzz")
	else
	{
		if !(num %3) printf("Fizz")	// divisible only by 3?
		elseif !(num %5) printf("Buzz")	// divisible only by 5?
		else printf("%d", num);		// not divisible by either 3 or 5
	}
	
}
```

This solution will get a poor grade because numbers not divisible by 3 and/or 5 will take 3 tests (3 if-statements) to make the determination, a more optimal solution would be:

```javascript
void BetterFizzBuzzTest(int num)
{
	if !(num%3) // divisible by 3?
	{
		if !(num%5) // also divisible by 5
			printf("FizzBuzz);
		else
			printf("Fizz") // only divisible by 3
	}
	elseif !(num%5)
		printf("Buzz");
	else
		printf("%d",num);

}
```
The reason this code is "better" is that it only takes two if-statements to determine what to print out. So is there a way we can make this even better?
```c
void EvenBetterFizzBuzzTest(int num)
{
	if (!num%3 && !num%5) // not divisible by 3 or 5, most common
		printf("%d",i);
	elseif(!num%3 && num%5) // divisible only by 3, second most common
		printf("Fizz")
	elseif(!num%5)
		printf("Buzz")	// divisible only by 5, third most common
	else
		printf("FizzBuzz")	// divisible by 3 and 5, least common
	
}
```

What's nice about this solution is that the most common pattern is performed in a single test. Knowing that for the inputs the system can expect (yes, I'm assuming they are sufficiently randomized), we know that numbers not divisible by either 3 or 5 will be the majority, thus we can slant our solution to minimize the latency for inputs that are most frequent. 
Now I want to show one more solution to this problem that I think is better than all the others.

```c
void EvenBetterFizzBuzzTest(int num)
{
	if (!num%3 && !num%5)
		printf("%d",i);
	if (!num%3 && num%5)
		printf("Fizz")
	if (num%3 && !num%5)
		printf("Buzz")
	if (!num%3 && !num%5)
		printf("FizzBuzz")	
}
```

I have deliberately removed all comments. Looking at this code it is very easy to determine what the function does, it is very readable. But this code violates all the optimizations that we have performed in the prior solutions; it can take up to four if-statements to determine the output. So how could this possibly be better than the previous solution?

For that answer we have to look at the evolution of compiler technology. Way back when I first got into programming,
compilers were very dumb. In fact C compilers had keywords like register that allowed you to provide the hints the compiler would use to produce optimal code. Back in those days it was easy to re-write a function in assembly language that blew away anything the compiler could generate.

That was then, this is now. Both compilers and processors have made tremendous advances. What we want to do is provide the compiler with as much information about what we intend to do so it can determine the optimal execution code to accomplish our goal. By hand-optimizing the solution we remove information that the compiler could use to produce better code. Don't confuse this optimization with algorithmic optimization, you should still work to optimize the algorithms, a compiler can only optimize the code based on the perceived intent, it cannot create a new solution (notice I left the test for the most common case at the start of the method).

So today's processors have multiple execution units and tons of registers. They also are paired with advance compilers that incorporate scads of optimization algorithms. And they are getting better all the time. 
