**Conform to PEP8**
- help(); and dir(object) to get objects' attrib and method
- f strings are more readable, easier to write, less prone to errors;
- Don't manually ".close()" a file. If an Exception is thrown, it won't close. 
The construct "with" is usually inbuilt in the context manager of classes that need to be closed.
- No general Exception; catch the actual Exception (e.g. `except ValueError():`)
- Learn comprehensions (list/dict/gen/set). They are your friend.
- Use "isinstance" to check variable type.

- Iterations:
```python
element 	        -> in list:
i, element 	        -> in enumerate(list, <start=1>):
i, (e1, e2, ...)	-> in enumerate(zip(list1, list2, ...)):
```

- Looping dictionaries:
```python
for k in dict:  		# this defaults to keys
for k, v in dict.items(): 	# .items() method is made to this
```

- Tuples and lists allow unpacking:
```python
a, b = [1, 2]                   # or, a tuple like (1, 2)
```

- Watch video on NumPy and Pandas

- Ternary condition for simple if/else:
```python
condition = False
x = 1 if condition else 0       # Ternary condition
print(x)                        # 0
```

- Learn how to package and install your code in your work dir.

- time.time() is used to get what time it currently is.
- Most accurate to time your code is time.perf_counter()

_________________________

Don't litter your code with prints. Use "import logging". For instance:

- import logging
```python
import logging

def print_vs_logging():
    logging.debug("debug info")
    logging.info("just some info")
    logging.error("uh oh :(")

def main():
    level = logging.DEBUG
    fmt = '[%(levelname)s] %(asctime)s - %(message)s'
    logging.basicConfig(level=level, format=fmt)
    print_vs_logging()

main()
```
________________________

Learn decorators. They are there to help.