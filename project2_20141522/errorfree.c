/*  */

int a[99];

int myFunc(int arr[], int a, int b) {
    int temp;
    int i;

    i = 10;

    while(i>0) {
	arr[i] = a + i;
	i = i - 1;
    }

    if(a>b) {
	temp = a;
    }
    else {
	temp = b;
    }

    return temp;
}

int main(void) {
    int re;

    while(i<99) {
	a[i] = i;
	i = i+1;
    }

    re = myFunc(a, 3, 5);

    return 0;
}
