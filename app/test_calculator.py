

def test_add():
    assert add(0,1) == 1
    assert add(1,1) == 2
    assert add(4,3) == 7
    assert add(3,3) == 6
    assert add(4,2) == 6
    assert add(4,4) == 8

def add(number1, number2):
    return number1 + number2