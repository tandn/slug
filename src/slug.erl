-module( slug ).
-author( "Warren Kenny <warren.kenny@gmail.com>" ).
-export( [make/1, make/2] ).

-define( is_lower( C ), ( C >= $a andalso C =< $z ) ).
-define( is_upper( C ), ( C >= $A andalso C =< $Z ) ).
-define( is_digit( C ), ( C >= $0 andalso C =< $9 ) ).
-define( is_space( C ), ( 
    C =:= $\s orelse C =:= $\n orelse C =:= $\t orelse C =:= $\r 
) ).

-define( is_diacrit( C ), (
    ( C >= 224 andalso C =< 255 andalso C =/= 247 ) orelse
    ( C >= 192 andalso C =< 223 andalso C =/= 215 ) orelse
    C =:= 131 orelse C =:= 138 orelse C =:= 140 orelse C =:= 142 orelse
    C =:= 154 orelse C =:= 156 orelse C =:= 158 orelse C =:= 159
) ).

-record( options, { separator   = $-    :: char(),
                    lower       = true  :: boolean(),
                    binary      = true  :: boolean()
} ).

%%
%%  Convert a character to lower case
%%
-spec to_lower( char() ) -> char().
to_lower( C ) when ?is_upper( C ) ->
    ( C - $A ) + $a;

to_lower( C ) ->
    C.

%%
%%  Parse an options proplist into an options record
%%
-spec parse_options( proplists:proplist(), #options{} ) -> #options{}.
parse_options( [{ separator, Sep } | T], Out ) ->
    parse_options( T, Out#options{ separator = Sep } );

parse_options( [{ lower, Lower } | T], Out ) ->
    parse_options( T, Out#options{ lower = Lower } );

parse_options( [], Out ) ->
    Out.

-spec make( string() | binary() ) -> string() | binary().
make( String ) ->
    make( String, [] ).

-spec make( string() | binary(), proplists:proplist() ) -> string() | binary().
make( String, Options ) ->
    make( want:string( String ), [], parse_options( Options, #options{ binary = is_binary( String ) } ) ).

make( [ C | T ], Acc, Options = #options{ lower = true } ) when ?is_upper( C ) ->
    make( T, [ to_lower( C ) | Acc ], Options );

make( [ C | T ], Acc, Options = #options{ lower = false } ) when ?is_upper( C ) ->
    make( T, [ C | Acc ], Options );

make( [ C | T ], Acc, Options ) when ?is_lower( C ) orelse ?is_digit( C ) orelse C =:= $_ ->
    make( T, [ C | Acc ], Options );

make( [ C | T ], Acc, Options = #options{ separator = Sep } ) when ?is_space( C ) orelse C =:= $/ orelse C =:= Sep ->
    case Acc of
        [ Sep | _ ] -> make( T, Acc, Options );
        _           -> make( T, [ Sep | Acc ], Options )
    end;

make( [ C | T ], Acc, Options ) when ?is_diacrit( C ) ->
    make( T, [ translate( C ) | Acc ], Options );

make( [ _ | T ], Acc, Options ) ->
    make( T, Acc, Options );

make( [], Acc, #options{ separator = Sep, binary = true } ) ->
    case Acc of
        [ Sep | T ] -> want:binary( lists:flatten( lists:reverse( T ) ) );
        _           -> want:binary( lists:flatten( lists:reverse( Acc ) ) )
    end;

make( [], Acc, #options{ separator = Sep } ) ->
    case Acc of
        [ Sep | T ] -> lists:flatten( lists:reverse( T ) );
        _           -> lists:flatten( lists:reverse( Acc ) )
    end.

%%
%%  Translate diacritic characters to more basic versions
%%
-spec translate( integer() ) -> char().
translate( 131 ) -> $f;
translate( 138 ) -> $s;
translate( 140 ) -> "oe";
translate( 142 ) -> $z;
translate( 154 ) -> $s;
translate( 156 ) -> "oe";
translate( 158 ) -> $z;
translate( 159 ) -> $y;
translate( 192 ) -> $a;
translate( 193 ) -> $a;
translate( 194 ) -> $a;
translate( 195 ) -> $a;
translate( 196 ) -> $a;
translate( 197 ) -> $a;
translate( 198 ) -> "ae";
translate( 199 ) -> $c;
translate( 200 ) -> $e;
translate( 201 ) -> $e;
translate( 202 ) -> $e;
translate( 203 ) -> $e;
translate( 204 ) -> $i;
translate( 205 ) -> $i;
translate( 206 ) -> $i;
translate( 207 ) -> $i;
translate( 208 ) -> "dh";
translate( 209 ) -> $n;
translate( 210 ) -> $o;
translate( 211 ) -> $o;
translate( 212 ) -> $o;
translate( 213 ) -> $o;
translate( 214 ) -> $o;
translate( 216 ) -> $o;
translate( 217 ) -> $u;
translate( 218 ) -> $u;
translate( 219 ) -> $u;
translate( 220 ) -> $u;
translate( 221 ) -> $y;
translate( 222 ) -> "th";
translate( 223 ) -> "ss";
translate( 224 ) -> $a;
translate( 225 ) -> $a;
translate( 226 ) -> $a;
translate( 227 ) -> $a;
translate( 228 ) -> $a;
translate( 229 ) -> $a;
translate( 230 ) -> "ae";
translate( 231 ) -> $c;
translate( 232 ) -> $e;
translate( 233 ) -> $e;
translate( 234 ) -> $e;
translate( 235 ) -> $e;
translate( 236 ) -> $i;
translate( 237 ) -> $i;
translate( 238 ) -> $i;
translate( 239 ) -> $i;
translate( 240 ) -> "dh";
translate( 241 ) -> $n;
translate( 242 ) -> $o;
translate( 243 ) -> $o;
translate( 244 ) -> $o;
translate( 245 ) -> $o;
translate( 246 ) -> $o;
translate( 248 ) -> $o;
translate( 249 ) -> $u;
translate( 250 ) -> $u;
translate( 251 ) -> $u;
translate( 252 ) -> $u;
translate( 253 ) -> $y;
translate( 254 ) -> "th";
translate( 255 ) -> $y;
translate( C ) -> C.