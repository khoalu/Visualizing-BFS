int getBit(int x, int k)
{
  return (x >> k) & 1;
}

int onBit(int x, int k)
{
  return x | (1 << k);
}

int offBit(int x, int k)
{
  return x & ~(1 << k);
}
