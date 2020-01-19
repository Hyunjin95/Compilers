module fibo;

var n: integer;

// fib(n: integer): integer
// Compute the fibonacci number of n. n >= 0
function fib(n: integer): integer;
begin
  if (n <= 1) then
    return n
  else
    return fib(n-1) + fib(n-2)
  end
end fib;

begin
  WriteStr("Enter a number: "); n := ReadInt();

  // Loop until the user enters a number < 0
  while (n > 0) do
    WriteStr("Result: "); WriteInt(fib(n)); WriteStr("\n");
    WriteStr("Enter a number: "); n := ReadInt()
  end
end fibo.
