# coding-exercise

* The refactoring challenge doesn’t solve the problems with the code, and it’s introduced some new ones. 
* There’s no way of extending this with other functions without modifying the Node class. 
* It still relies on nil check to determine whether a node is a value or operation node. 
* If I wanted to introduce a unary operation node (e.g. sin) I’d need to make major changes to the code. -If I wanted to use something that wasn’t available as a method on Float - again I’d need to make major changes. 
* Flatten is missing some tests
