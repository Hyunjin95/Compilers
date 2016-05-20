module a;

var a,b,c: integer;
   d,e: boolean;
   arr: integer[7][9][11];
   barr: boolean[3][5][7];

procedure bar(arr:integer[]);
begin
end bar;

function foo(arr:boolean[][][]): integer;
begin
//  arr[a+3][b+5][c+7] := 3

  d := arr[a+3][2][3] && arr[b+3][c+2][1]
//    bar(arr[a+3][b+5])
end foo;


begin
  d := barr[a+3][2][3] && true

end a.
