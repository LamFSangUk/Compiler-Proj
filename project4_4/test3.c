int k(int x)
{
	return x+3;
}
void g(int four)
{
	if(four==1)
	{
	}
	else
	{
		int four;
		four = k(2);
	}
}

void main(void)
{
	int x;
	x=1;
	{
		{
			int x;
			x=2;
			g(x);
		}
	}
	output(x);
}
