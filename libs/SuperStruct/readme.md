
# SuperStructs

SuperStructs are an experimental take on the common class data type seen in standard OOP.
Although they are very similar to classes, there are some differences:

Main differences:
- Superstructs are basically useless without composition (form of inheritance)
- Calling a superstruct method will call that same method in all attached superstructs, for that object
- Superstructs are mutable at runtime and will not break children/parents when modified
- Superstruct's object fields are defined on creation, and are static. (__newindex = error)
- There is no constructor function, structure fields are copied from template.
- Method overriding is not a thing; parent class functions are static



Planning:

We have 2 options:
store all parent functions in self.___functions table

call parent functions from its own table



