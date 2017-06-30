void mergesort(int arr[], int low, int high, int temp[])
{
	int mid;

	if(low == high) return;

	mid = (low + high) / 2;
	mergesort(arr, low, mid, temp);
	mergesort(arr, mid + 1, high, temp);
	{
		int i;
		int l;
		int r;

		l = low;
		r = mid + 1;
		i = low;

		while(i <= high)
		{
			int isLeft;
			isLeft = 0;

			if(mid < l) isLeft = 0;
			else if(high < r) isLeft = 1;
			else if(arr[l] <= arr[r])
				isLeft = 1;
			if(isLeft)
			{
				temp[i] = arr[l];
				l = l + 1;
			}
			else
			{
				temp[i] = arr[r];
				r = r + 1;
			}

			i = i + 1;
		}

		i = low;

		while(i <= high)
		{
			arr[i] = temp[i];
			i = i + 1;
		}
	}
}


void main(void)
{
	int array[10];
	int temp[10];
	int i;

	i = 0;
	while(i < 10)
	{
		array[i] = input();
		i = i + 1;
	}

	mergesort(array, 0, 9, temp);

	i = 0;
	while(i < 10)
	{
		output(array[i]);
		i = i + 1;
	}
}
