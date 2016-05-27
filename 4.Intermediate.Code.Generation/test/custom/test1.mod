module test;


var B : boolean[1][2][3];

    A : integer[100][100][100];

        x : integer;


        function f(a:integer[]):integer;

        begin

        return a[5]

        end f;


        function g(a:integer[][]):integer;

        begin

        return f(a[3])

  end g;


  begin

  A[0][3][5] := 999;

  WriteInt(g(A[1]))

  end test.
