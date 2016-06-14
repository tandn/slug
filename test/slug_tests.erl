-module( slug_tests ).
-author( "Warren Kenny <warren.kenny@gmail.com>" ).

-include_lib( "eunit/include/eunit.hrl" ).

slug_test() ->
    ?assertEqual( slug:make( "Hello World" ), "hello-world" ),
    ?assertEqual( slug:make( "Hello World", [{lower, false}] ), "Hello-World" ),
    ?assertEqual( slug:make( "Hello_World" ), "hello_world" ),
    ?assertEqual( slug:make( "Hello/World" ), "hello-world" ),
    ?assertEqual( slug:make( "Hello?World" ), "helloworld" ),
    ?assertEqual( slug:make( "Hello?World-Foo" ), "helloworld-foo" ),
    ?assertEqual( slug:make( "Hello World", [{ separator, $_ }] ), "hello_world" ),
    ?assertEqual( slug:make( "Hello-World" ), "hello-world" ).