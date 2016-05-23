module a;

var a,b,c: integer;
   d,e: boolean;
   arr: integer[7][9][11];
   barr: boolean[3][5][7];


   function foo(a, b:integer[]): boolean;
   begin
    a := b
   end foo;

begin
  if(!foo(arr[a+c][b*c], arr[1][1]) && foo(arr[3][5], arr[1][1])) then
    arr[3][5][1] := 3
    else
    arr[5][3][1] := 2
    end
end a.
