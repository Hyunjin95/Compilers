// This is a valid character test set.
'a'
'z'
'0'
'9'
'!'
')'
' '
'\n'
'\t'
'\0'
'\''
'\\'

// These should not be passed.
''
'ab'
'a\n'
'  '
'\"'
'
'

// This is a valid string test set.
"a"
"ab"
"hello world"
"asdfasdf\n\t\0\"\\"
"adsjflsafjlajfl  jw90t09jr23jro2n3p429123"
"asdjfajfpaofjspoafapofpjo \'\0\t\n"
"\%"


// These should not be passed.
"
"
