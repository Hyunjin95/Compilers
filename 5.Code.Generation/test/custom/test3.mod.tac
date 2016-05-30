test3.mod:
[[ module: test
  [[ type manager
    base types:
      <NULL>
      <int>
      <char>
      <bool>
      <ptr(4) to <NULL>>
    pointer types:
      <ptr(4) to <NULL>>
      <ptr(4) to <array of <char>>>
      <ptr(4) to <array 6 of <char>>>
    array types:
      <array of <char>>
      <array 6 of <char>>
  ]]
  [[
    [ *DIM(<ptr(4) to <NULL>>,<int>) --> <int>     ]
    [ *DOFS(<ptr(4) to <NULL>>) --> <int>     ]
    [ *ReadInt() --> <int>     ]
    [ *WriteChar(<char>) --> <NULL>     ]
    [ *WriteInt(<int>) --> <NULL>     ]
    [ *WriteLn() --> <NULL>     ]
    [ *WriteStr(<ptr(4) to <array of <char>>>) --> <NULL>     ]
    [ @_str_1   <array 6 of <char>>     ]
      [ data: 'Hello' ]
    [ @i        <int>     ]
    [ *proc() --> <NULL>     ]
    [ $t0       <ptr(4) to <array 6 of <char>>>     ]
  ]]
  [[ test
      0:     &()    t0 <- _str_1
      1:     param  0 <- t0
      2:     call   WriteStr
      3:     assign i <- 3
      4:     call   proc
  ]]

  [[ procedure: proc
    [[
      [ $_str_1   <int>       ]
    ]]
    [[ proc
        0:     assign _str_1 <- 3
    ]]
  ]]
]]
