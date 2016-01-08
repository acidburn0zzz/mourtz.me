#include <iostream>
#include <string>

using namespace std;

class Foo{
    string name = "dummy";
public:
    void printName() { cout << name << " non-const" << endl; }
    void printName() const { cout << name << " const" << endl; }
};

int main(){
    const int i =21;
    int w = 12;

    const int *p1 = &i;  // data is const, pointer is not
    p1++;
    cout << i << ", " << p1 << endl;

    int* const p2 = &w; // pointer is const, data is not
    cout << w << ", " << p2 << endl;

	const int* const p3 = &i;  // bot data and pointer are const
	cout << i << ", " << p3 << endl;

    // Method Overloading
    Foo f;
    f.printName();

    static_cast<const Foo&>(f).printName();

    return 0;
}
