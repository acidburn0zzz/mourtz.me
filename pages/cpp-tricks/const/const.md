## const

The const keyword specifies that a variable's value is constant and tells the compiler to prevent the programmer from modifying it. In C++, you can use the const keyword instead of the #define preprocessor directive to define constant values. Values defined with const are subject to type checking, and can be used in place of constant expressions.

<!--- [Pointing to const](#Pointing to const)-->

___

### Pointer and const

```
const int i = 92;           // regural const variable

const int *p1 = &i;         // data is const, pointer is not.

int* const p2;              // pointer is const, data is not.

const int* const p3;        // bot data and pointer are const.

```

### Casting

```
const int i = 92;

// const_cast only works on pointer/reference, and it can be used to cast away constness or volatility.
// Fortunately, newer versions of GCC and Clang prevent you from casting away constness.
const_cast<int&>(i) = 6;    

int j = 9;
static_cast<const int&>(j); // static_cast can be used to modify the type of data, making j const.
```

### Functions and const

#### __Method overloading__

```
class Foo{
    string name = "dummy";
public:
    void printName() { cout << name << " non-const" << endl; }
    void printName() const { cout << name << " const" << endl; }
};

int main(){
    Foo f;
    f.printName();
    
    const Foo c;
    c.printName();
    
    return 0;
}
```

#### __Mutable Data Members__
This keyword can only be applied to non-static **and** non-const data members of a class. If a data member is declared mutable, then it is **legal** to assign a value to this data member from a const member function.

```
class Foo{
    mutable int x = 0;
public:
    void printName() const { cout << ++x << endl; }
};

int main(){
    Foo f;
    f.printName();  
    
    return 0;
}
```

Special Thanks to [Bo Qian](http://boqian.weebly.com/c-programming.html) for his amazing notes.